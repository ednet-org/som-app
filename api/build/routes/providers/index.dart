import 'package:dart_frog/dart_frog.dart';

import 'package:som_api/infrastructure/repositories/company_repository.dart';
import 'package:som_api/infrastructure/repositories/inquiry_repository.dart';
import 'package:som_api/infrastructure/repositories/offer_repository.dart';
import 'package:som_api/infrastructure/repositories/provider_repository.dart';
import 'package:som_api/infrastructure/repositories/user_repository.dart';
import 'package:som_api/services/mappings.dart';
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
  final params = context.request.uri.queryParameters;
  final branchId = params['branchId'];
  final companySize = params['companySize'];
  final providerType = params['providerType'];
  final zipPrefix = params['zipPrefix'];
  final status = params['status'];
  final claimed = params['claimed'];
  final format = params['format'];

  final companies = await context.read<CompanyRepository>().listAll();
  final providerRepo = context.read<ProviderRepository>();
  final inquiryRepo = context.read<InquiryRepository>();
  final offerRepo = context.read<OfferRepository>();

  final results = <Map<String, dynamic>>[];
  for (final company in companies) {
    if (company.type != 'provider' && company.type != 'buyer_provider') {
      continue;
    }
    final profile = await providerRepo.findByCompany(company.id);
    if (profile == null) {
      continue;
    }
    if (status != null && profile.status != status) {
      continue;
    }
    if (claimed != null) {
      final claimedBool = claimed.toLowerCase() == 'true';
      if (claimedBool && profile.status != 'active') {
        continue;
      }
      if (!claimedBool && profile.status == 'active') {
        continue;
      }
    }
    if (branchId != null && !profile.branchIds.contains(branchId)) {
      continue;
    }
    if (providerType != null &&
        (profile.providerType ?? '') != providerType) {
      continue;
    }
    if (companySize != null &&
        companySizeToWire(company.companySize).toString() != companySize &&
        company.companySize != companySize) {
      continue;
    }
    if (zipPrefix != null &&
        !company.address.zip.toLowerCase().startsWith(zipPrefix.toLowerCase())) {
      continue;
    }
    final received = await inquiryRepo.countAssignmentsForProvider(company.id);
    final sentOffers = await offerRepo.countByProvider(companyId: company.id);
    final acceptedOffers = await offerRepo.countByProvider(
      companyId: company.id,
      status: 'won',
    );
    results.add({
      'companyId': company.id,
      'companyName': company.name,
      'companySize': company.companySize,
      'providerType': profile.providerType,
      'postcode': company.address.zip,
      'branchIds': profile.branchIds,
      'pendingBranchIds': profile.pendingBranchIds,
      'status': profile.status,
      'rejectionReason': profile.rejectionReason,
      'rejectedAt': profile.rejectedAt?.toIso8601String(),
      'claimed': profile.status == 'active',
      'receivedInquiries': received,
      'sentOffers': sentOffers,
      'acceptedOffers': acceptedOffers,
      'subscriptionPlanId': profile.subscriptionPlanId,
      'paymentInterval': profile.paymentInterval,
      'iban': profile.bankDetails.iban,
      'bic': profile.bankDetails.bic,
      'accountOwner': profile.bankDetails.accountOwner,
      'registrationDate': company.createdAt.toIso8601String(),
    });
  }
  if (format == 'csv') {
    final buffer = StringBuffer();
    buffer.writeln(
        'companyName,subscriptionPlanId,registrationDate,iban,bic,accountOwner,paymentInterval');
    for (final row in results) {
      buffer.writeln(
          '${row['companyName']},${row['subscriptionPlanId']},${row['registrationDate']},${row['iban']},${row['bic']},${row['accountOwner']},${row['paymentInterval']}');
    }
    return Response(
      headers: {'content-type': 'text/csv'},
      body: buffer.toString(),
    );
  }
  return Response.json(body: results);
}
