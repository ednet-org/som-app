import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/company_taxonomy_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/access_control.dart';
import 'package:som_api/services/audit_service.dart';
import 'package:som_api/services/csv_writer.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://localhost:54321'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !isConsultantAdmin(auth)) {
    return Response(statusCode: 403);
  }
  final queryParams = context.request.uri.queryParameters;

  // Pagination parameters
  final limit = int.tryParse(queryParams['limit'] ?? '') ?? 50;
  final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
  final search = queryParams['search'];

  // Filter parameters
  final branchId = queryParams['branchId'];
  final categoryId = queryParams['categoryId'];
  final companySize = queryParams['companySize'];
  final providerType = queryParams['providerType'];
  final zipPrefix = queryParams['zipPrefix'];
  final status = queryParams['status'];
  final claimedStr = queryParams['claimed'];
  final format = queryParams['format'];

  // Parse claimed parameter
  bool? claimed;
  if (claimedStr != null) {
    claimed = claimedStr.toLowerCase() == 'true';
  }

  final companyRepo = context.read<CompanyRepository>();
  final taxonomyRepo = context.read<CompanyTaxonomyRepository>();
  final providerRepo = context.read<ProviderRepository>();
  final inquiryRepo = context.read<InquiryRepository>();
  final offerRepo = context.read<OfferRepository>();

  List<String>? companyIdsFilter;
  if (branchId != null || categoryId != null) {
    Set<String>? branchCompanyIds;
    Set<String>? categoryCompanyIds;
    if (branchId != null) {
      branchCompanyIds =
          (await taxonomyRepo.listCompanyIdsByBranch(branchId)).toSet();
    }
    if (categoryId != null) {
      categoryCompanyIds =
          (await taxonomyRepo.listCompanyIdsByCategory(categoryId)).toSet();
    }
    if (branchCompanyIds != null && categoryCompanyIds != null) {
      companyIdsFilter =
          branchCompanyIds.intersection(categoryCompanyIds).toList();
    } else if (branchCompanyIds != null) {
      companyIdsFilter = branchCompanyIds.toList();
    } else if (categoryCompanyIds != null) {
      companyIdsFilter = categoryCompanyIds.toList();
    }
  }

  // Use the optimized search method with pagination
  final searchResult = await providerRepo.searchProviders(
    ProviderSearchParams(
      limit: limit,
      offset: offset,
      search: search,
      branchId: branchId,
      categoryId: categoryId,
      providerType: providerType,
      status: status,
      zipPrefix: zipPrefix,
      companySize: companySize,
      claimed: claimed,
    ),
    companyRepo,
    companyIdsFilter: companyIdsFilter,
  );

  final totalCount = searchResult.totalCount;

  final companyIds = searchResult.items.map((p) => p.companyId).toList();
  final branchAssignments =
      await taxonomyRepo.listBranchAssignmentsForCompanies(companyIds);
  final categoryAssignments =
      await taxonomyRepo.listCategoryAssignmentsForCompanies(companyIds);

  final hasMore = offset + searchResult.items.length < totalCount;

  // Build response with inquiry/offer counts for each provider
  final results = <Map<String, dynamic>>[];
  for (final provider in searchResult.items) {
    final received =
        await inquiryRepo.countAssignmentsForProvider(provider.companyId);
    final sentOffers =
        await offerRepo.countByProvider(companyId: provider.companyId);
    final acceptedOffers = await offerRepo.countByProvider(
      companyId: provider.companyId,
      status: 'won',
    );

    final json = provider.toJson();
    json['branchAssignments'] =
        (branchAssignments[provider.companyId] ?? const [])
            .map((a) => a.toJson())
            .toList();
    json['categoryAssignments'] =
        (categoryAssignments[provider.companyId] ?? const [])
            .map((a) => a.toJson())
            .toList();
    json['receivedInquiries'] = received;
    json['sentOffers'] = sentOffers;
    json['acceptedOffers'] = acceptedOffers;
    results.add(json);
  }

  final paginationHeaders = {
    'X-Total-Count': totalCount.toString(),
    'X-Has-More': hasMore.toString(),
  };

  if (format == 'csv') {
    final writer = CsvWriter();
    writer.writeRow([
      'companyName',
      'subscriptionPlanId',
      'registrationDate',
      'iban',
      'bic',
      'accountOwner',
      'paymentInterval'
    ]);
    for (final row in results) {
      writer.writeRow([
        row['companyName'],
        row['subscriptionPlanId'],
        row['registrationDate'],
        row['iban'],
        row['bic'],
        row['accountOwner'],
        row['paymentInterval'],
      ]);
    }
    await context.read<AuditService>().log(
          action: 'providers.exported',
          entityType: 'provider',
          entityId: auth.userId,
          actorId: auth.userId,
          metadata: {'format': 'csv', 'count': results.length},
        );
    return Response(
      headers: {'content-type': 'text/csv', ...paginationHeaders},
      body: writer.toString(),
    );
  }

  return Response.json(body: results, headers: paginationHeaders);
}
