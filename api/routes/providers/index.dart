import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/models/models.dart';
import 'package:som_api/services/request_auth.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }
  final auth = await parseAuth(
    context,
    secret: const String.fromEnvironment('SUPABASE_JWT_SECRET',
        defaultValue: 'som_dev_secret'),
    users: context.read<UserRepository>(),
  );
  if (auth == null || !auth.roles.contains('consultant')) {
    return Response(statusCode: 403);
  }
  final queryParams = context.request.uri.queryParameters;

  // Pagination parameters
  final limit = int.tryParse(queryParams['limit'] ?? '') ?? 50;
  final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
  final search = queryParams['search'];

  // Filter parameters
  final branchId = queryParams['branchId'];
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
  final providerRepo = context.read<ProviderRepository>();
  final inquiryRepo = context.read<InquiryRepository>();
  final offerRepo = context.read<OfferRepository>();

  // Use the optimized search method with pagination
  final searchResult = await providerRepo.searchProviders(
    ProviderSearchParams(
      limit: limit,
      offset: offset,
      search: search,
      branchId: branchId,
      providerType: providerType,
      status: status,
      zipPrefix: zipPrefix,
      companySize: companySize,
      claimed: claimed,
    ),
    companyRepo,
  );

  final totalCount = searchResult.totalCount;
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
    final buffer = StringBuffer();
    buffer.writeln(
        'companyName,subscriptionPlanId,registrationDate,iban,bic,accountOwner,paymentInterval');
    for (final row in results) {
      buffer.writeln(
          '${row['companyName']},${row['subscriptionPlanId']},${row['registrationDate']},${row['iban']},${row['bic']},${row['accountOwner']},${row['paymentInterval']}');
    }
    return Response(
      headers: {'content-type': 'text/csv', ...paginationHeaders},
      body: buffer.toString(),
    );
  }

  return Response.json(body: results, headers: paginationHeaders);
}
