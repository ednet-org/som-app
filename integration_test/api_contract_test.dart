import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:openapi/openapi.dart';

const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);
const _outboxPathOverride = String.fromEnvironment(
  'OUTBOX_PATH',
  defaultValue: '',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'API endpoints are exercised via app client',
    (tester) async {
      await tester.runAsync(() async {
        final api = Openapi(
          dio: Dio(BaseOptions(baseUrl: _baseUrl)),
          serializers: standardSerializers,
        );

        final consultantToken =
            await _login(api, 'consultant@som.local', 'DevPass123!');
        final buyerToken =
            await _login(api, 'buyer-admin@som.local', 'DevPass123!');
        final providerToken =
            await _login(api, 'provider-admin@som.local', 'DevPass123!');

        final subscriptions = await api.getSubscriptionsApi().subscriptionsGet();
        expect(subscriptions.statusCode, 200);
        final subscriptionsList = subscriptions.data?.subscriptions;
        expect(subscriptionsList, isNotNull);
        expect(subscriptionsList, isNotEmpty);
        final planId = subscriptionsList!.first.id!;

        var branchesResponse = await api.getBranchesApi().branchesGet();
        expect(branchesResponse.statusCode, 200);
        if (branchesResponse.data == null || branchesResponse.data!.isEmpty) {
          await api.getBranchesApi().branchesPost(
                headers: _authHeader(consultantToken),
                branchesGetRequest: BranchesGetRequest((b) => b..name = 'Seed'),
              );
          branchesResponse = await api.getBranchesApi().branchesGet();
        }
        final branch = branchesResponse.data!.first;
        final branchId = branch.id!;
        String categoryId;
        if (branch.categories == null || branch.categories!.isEmpty) {
          await api.getBranchesApi().branchesBranchIdCategoriesPost(
                branchId: branchId,
                headers: _authHeader(consultantToken),
                branchesGetRequest:
                    BranchesGetRequest((b) => b..name = 'Category'),
              );
          branchesResponse = await api.getBranchesApi().branchesGet();
        }
        final refreshedBranch = branchesResponse.data!
            .firstWhere((item) => item.id == branchId);
        categoryId = refreshedBranch.categories!.first.id!;

        final companies = await api.getCompaniesApi().companiesGet();
        expect(companies.statusCode, 200);

        final stamp = DateTime.now().millisecondsSinceEpoch;
        final buyerEmail = 'buyer-admin-$stamp@som.local';
        final buyerRegistrationNr = 'REG-$stamp';

        final registerRequest = RegisterCompanyRequest((b) => b
          ..company.replace(CompanyRegistration((c) => c
            ..name = 'Buyer Co $stamp'
            ..address.replace(Address((a) => a
              ..country = 'AT'
              ..city = 'Vienna'
              ..street = 'Test Street'
              ..number = '1'
              ..zip = '1010'))
            ..uidNr = 'ATU-$stamp'
            ..registrationNr = buyerRegistrationNr
            ..companySize = CompanyRegistrationCompanySizeEnum.number1
            ..type = CompanyRegistrationTypeEnum.number0
            ..websiteUrl = 'https://example.com'
            ..termsAccepted = true
            ..privacyAccepted = true))
          ..users.add(UserRegistration((u) => u
            ..email = buyerEmail
            ..firstName = 'Buyer'
            ..lastName = 'Admin'
            ..salutation = 'Mx'
            ..roles = ListBuilder([
              UserRegistrationRolesEnum.number4,
              UserRegistrationRolesEnum.number0,
            ]))));

        final registerResponse = await api
            .getCompaniesApi()
            .registerCompany(registerCompanyRequest: registerRequest);
        expect(registerResponse.statusCode, 200);

        final confirmToken = await _obtainToken(
          api,
          buyerEmail,
          type: 'confirm_email',
          contains: 'confirmEmail',
        );
        final confirmResponse = await api.getAuthApi().authConfirmEmailGet(
              token: confirmToken,
              email: buyerEmail,
            );
        expect(confirmResponse.statusCode, 200);

        final resetResponse = await api.getAuthApi().authResetPasswordPost(
              authResetPasswordPostRequest:
                  AuthResetPasswordPostRequest((b) => b
                    ..email = buyerEmail
                    ..token = confirmToken
                    ..password = 'TempPass123!'
                    ..confirmPassword = 'TempPass123!'),
            );
        expect(resetResponse.statusCode, 200);

        final forgotResponse = await api.getAuthApi().authForgotPasswordPost(
              authForgotPasswordPostRequest:
                  AuthForgotPasswordPostRequest((b) => b..email = buyerEmail),
            );
        expect(forgotResponse.statusCode, 200);

        final resetToken = await _obtainToken(
          api,
          buyerEmail,
          type: 'reset_password',
          contains: 'resetPassword',
        );
        final resetResponseTwo = await api.getAuthApi().authResetPasswordPost(
              authResetPasswordPostRequest:
                  AuthResetPasswordPostRequest((b) => b
                    ..email = buyerEmail
                    ..token = resetToken
                    ..password = 'TempPass456!'
                    ..confirmPassword = 'TempPass456!'),
            );
        expect(resetResponseTwo.statusCode, 200);

        final buyerAdminToken = await _login(api, buyerEmail, 'TempPass456!');
        final companyList = await api.getCompaniesApi().companiesGet();
        final buyerCompany = companyList.data!.firstWhere(
          (company) => company.registrationNr == buyerRegistrationNr,
        );
        final buyerCompanyId = buyerCompany.id!;

        final companyResponse = await api.getCompaniesApi().companiesCompanyIdGet(
              companyId: buyerCompanyId,
            );
        expect(companyResponse.statusCode, 200);

        final updateResponse = await api.getCompaniesApi().companiesCompanyIdPut(
              companyId: buyerCompanyId,
              headers: _authHeader(buyerAdminToken),
              companyDto: CompanyDto((b) => b
                ..id = buyerCompanyId
                ..name = 'Buyer Co $stamp Updated'
                ..registrationNr = buyerRegistrationNr
                ..uidNr = 'ATU-$stamp'
                ..companySize = 1
                ..type = 0
                ..address.replace(Address((a) => a
                  ..country = 'AT'
                  ..city = 'Vienna'
                  ..street = 'Test Street'
                  ..number = '1'
                  ..zip = '1010'))
                ..websiteUrl = 'https://updated.example.com'),
            );
        expect(updateResponse.statusCode, 200);

        final usersResponse = await api.getUsersApi().companiesCompanyIdUsersGet(
              companyId: buyerCompanyId,
              headers: _authHeader(buyerAdminToken),
            );
        expect(usersResponse.statusCode, 200);

        final extraUserEmail = 'buyer-user-$stamp@som.local';
        final registerUserResponse =
            await api.getUsersApi().companiesCompanyIdRegisterUserPost(
                  companyId: buyerCompanyId,
                  headers: _authHeader(buyerAdminToken),
                  userRegistration: UserRegistration((u) => u
                    ..email = extraUserEmail
                    ..firstName = 'Buyer'
                    ..lastName = 'User'
                    ..salutation = 'Mx'
                    ..roles =
                        ListBuilder([UserRegistrationRolesEnum.number0])),
                );
        expect(registerUserResponse.statusCode, 200);

        final userToken = await _obtainToken(
          api,
          extraUserEmail,
          type: 'confirm_email',
          contains: 'confirmEmail',
        );
        await api.getAuthApi().authResetPasswordPost(
              authResetPasswordPostRequest:
                  AuthResetPasswordPostRequest((b) => b
                    ..email = extraUserEmail
                    ..token = userToken
                    ..password = 'TempPass123!'
                    ..confirmPassword = 'TempPass123!'),
            );

        final refreshedUsers =
            await api.getUsersApi().companiesCompanyIdUsersGet(
                  companyId: buyerCompanyId,
                  headers: _authHeader(buyerAdminToken),
                );
        final userDto = refreshedUsers.data!
            .firstWhere((user) => user.email == extraUserEmail);

        final updateUserResponse =
            await api.getUsersApi().companiesCompanyIdUsersUserIdUpdatePut(
                  companyId: buyerCompanyId,
                  userId: userDto.id!,
                  headers: _authHeader(buyerAdminToken),
                  userDto: UserDto((b) => b
                    ..id = userDto.id
                    ..companyId = buyerCompanyId
                    ..email = userDto.email
                    ..firstName = 'Buyer Updated'
                    ..lastName = userDto.lastName
                    ..salutation = userDto.salutation
                    ..roles = userDto.roles?.toBuilder()),
                );
        expect(updateUserResponse.statusCode, 200);

        final userDetailResponse =
            await api.getUsersApi().companiesCompanyIdUsersUserIdGet(
                  companyId: buyerCompanyId,
                  userId: userDto.id!,
                  headers: _authHeader(buyerAdminToken),
                );
        expect(userDetailResponse.statusCode, 200);

        final loadUserResponse =
            await api.getUsersApi().usersLoadUserWithCompanyGet(
                  userId: userDto.id!,
                  headers: _authHeader(buyerAdminToken),
                );
        expect(loadUserResponse.statusCode, 200);

        final userDeleteResponse =
            await api.getUsersApi().companiesCompanyIdUsersUserIdDelete(
                  companyId: buyerCompanyId,
                  userId: userDto.id!,
                  headers: _authHeader(buyerAdminToken),
                );
        expect(userDeleteResponse.statusCode, 200);

        final switchRoleResponse = await api.getAuthApi().authSwitchRolePost(
              headers: _authHeader(buyerToken),
              authSwitchRolePostRequest:
                  AuthSwitchRolePostRequest((b) => b..role = 'buyer'),
            );
        expect(switchRoleResponse.statusCode, 200);

        final inquiryRequest = CreateInquiryRequest((b) => b
          ..branchId = branchId
          ..categoryId = categoryId
          ..productTags = ListBuilder(['laptop', 'support'])
          ..deadline =
              DateTime.now().toUtc().add(const Duration(days: 5))
          ..deliveryZips = ListBuilder(['1010'])
          ..numberOfProviders = 2
          ..description = 'Need laptops');

        final inquiryResponse = await api.getInquiriesApi().createInquiry(
              headers: _authHeader(buyerToken),
              createInquiryRequest: inquiryRequest,
            );
        expect(inquiryResponse.statusCode, 200);
        final inquiryId = inquiryResponse.data!.id!;

        final inquiryList =
            await api.getInquiriesApi().inquiriesGet(headers: _authHeader(buyerToken));
        expect(inquiryList.statusCode, 200);

        final inquiryDetail =
            await api.getInquiriesApi().inquiriesInquiryIdGet(
                  inquiryId: inquiryId,
                  headers: _authHeader(buyerToken),
                );
        expect(inquiryDetail.statusCode, 200);

        final providerCompanies =
            await api.getCompaniesApi().companiesGet(type: '1');
        final providerCompanyId =
            providerCompanies.data!.firstWhere((c) => c.type == 1).id!;

        final assignResponse = await api.getInquiriesApi().inquiriesInquiryIdAssignPost(
              inquiryId: inquiryId,
              headers: _authHeader(consultantToken),
              inquiriesInquiryIdAssignPostRequest:
                  InquiriesInquiryIdAssignPostRequest((b) => b
                    ..providerCompanyIds = ListBuilder([providerCompanyId])),
            );
        expect(assignResponse.statusCode, 200);

        final offerResponse = await api.getOffersApi().inquiriesInquiryIdOffersPost(
              inquiryId: inquiryId,
              headers: _authHeader(providerToken),
              file: MultipartFile.fromBytes(
                [0x25, 0x50, 0x44, 0x46],
                filename: 'offer.pdf',
              ),
            );
        expect(offerResponse.statusCode, 200);
        final offerId = offerResponse.data!.id!;

        final offersList = await api.getOffersApi().inquiriesInquiryIdOffersGet(
              inquiryId: inquiryId,
              headers: _authHeader(buyerToken),
            );
        expect(offersList.statusCode, 200);

        final acceptResponse =
            await api.getOffersApi().offersOfferIdAcceptPost(
                  offerId: offerId,
                  headers: _authHeader(buyerToken),
                );
        expect(acceptResponse.statusCode, 200);

        final secondInquiryResponse = await api.getInquiriesApi().createInquiry(
              headers: _authHeader(buyerToken),
              createInquiryRequest: CreateInquiryRequest((b) => b
                ..branchId = branchId
                ..categoryId = categoryId
                ..productTags = ListBuilder(['toner'])
                ..deadline =
                    DateTime.now().toUtc().add(const Duration(days: 6))
                ..deliveryZips = ListBuilder(['1020'])
                ..numberOfProviders = 1
                ..description = 'Need toner'),
            );
        final secondInquiryId = secondInquiryResponse.data!.id!;

        await api.getInquiriesApi().inquiriesInquiryIdAssignPost(
              inquiryId: secondInquiryId,
              headers: _authHeader(consultantToken),
              inquiriesInquiryIdAssignPostRequest:
                  InquiriesInquiryIdAssignPostRequest((b) => b
                    ..providerCompanyIds = ListBuilder([providerCompanyId])),
            );

        final secondOfferResponse =
            await api.getOffersApi().inquiriesInquiryIdOffersPost(
                  inquiryId: secondInquiryId,
                  headers: _authHeader(providerToken),
                  file: MultipartFile.fromBytes(
                    [0x25, 0x50, 0x44, 0x46],
                    filename: 'offer2.pdf',
                  ),
                );
        final secondOfferId = secondOfferResponse.data!.id!;

        final rejectResponse =
            await api.getOffersApi().offersOfferIdRejectPost(
                  offerId: secondOfferId,
                  headers: _authHeader(buyerToken),
                );
        expect(rejectResponse.statusCode, 200);

        final adResponse = await api.getAdsApi().createAd(
              headers: _authHeader(providerToken),
              createAdRequest: CreateAdRequest((b) => b
                ..type = 'normal'
                ..status = 'active'
                ..branchId = branchId
                ..url = 'https://example.com'
                ..imagePath = '/tmp/ad.png'
                ..headline = 'Demo Ad'),
            );
        expect(adResponse.statusCode, 200);
        final adId = adResponse.data!.id!;

        final adsList = await api.getAdsApi().adsGet();
        expect(adsList.statusCode, 200);

        final adsCompanyList = await api.getAdsApi().adsGet(
              branchId: branchId,
              headers: _authHeader(providerToken),
            );
        expect(adsCompanyList.statusCode, 200);

        final adGet = await api.getAdsApi().adsAdIdGet(adId: adId);
        expect(adGet.statusCode, 200);

        final adUpdate = await api.getAdsApi().adsAdIdPut(
              adId: adId,
              headers: _authHeader(providerToken),
              ad: Ad((b) => b
                ..id = adId
                ..status = 'draft'
                ..branchId = branchId
                ..url = 'https://example.com'
                ..imagePath = '/tmp/ad.png'),
            );
        expect(adUpdate.statusCode, 200);

        final adDelete = await api.getAdsApi().adsAdIdDelete(
              adId: adId,
              headers: _authHeader(providerToken),
            );
        expect(adDelete.statusCode, 200);

        final statsBuyer = await api.getStatsApi().statsBuyerGet(
              headers: _authHeader(buyerToken),
            );
        expect(statsBuyer.statusCode, 200);

        final statsProvider = await api.getStatsApi().statsProviderGet(
              headers: _authHeader(providerToken),
            );
        expect(statsProvider.statusCode, 200);

        final statsConsultant = await api.getStatsApi().statsConsultantGet(
              headers: _authHeader(consultantToken),
            );
        expect(statsConsultant.statusCode, 200);

        final consultantList = await api.getConsultantsApi().consultantsGet(
              headers: _authHeader(consultantToken),
            );
        expect(consultantList.statusCode, 200);

        final consultantEmail = 'consultant-$stamp@som.local';
        final consultantCreate = await api.getConsultantsApi().consultantsPost(
              headers: _authHeader(consultantToken),
              userRegistration: UserRegistration((b) => b
                ..email = consultantEmail
                ..firstName = 'Consultant'
                ..lastName = 'User'
                ..salutation = 'Mx'
                ..roles = ListBuilder([UserRegistrationRolesEnum.number3])),
            );
        expect(consultantCreate.statusCode, 200);

        final consultantCompany = CompanyRegistration((c) => c
          ..name = 'Consultant Co $stamp'
          ..address.replace(Address((a) => a
            ..country = 'AT'
            ..city = 'Graz'
            ..street = 'Consultant'
            ..number = '2'
            ..zip = '8010'))
          ..uidNr = 'ATU-CONS-$stamp'
          ..registrationNr = 'CREG-$stamp'
          ..companySize = CompanyRegistrationCompanySizeEnum.number0
          ..type = CompanyRegistrationTypeEnum.number0
          ..termsAccepted = false
          ..privacyAccepted = false);
        final consultantUser = UserRegistration((u) => u
          ..email = 'consultant-co-admin-$stamp@som.local'
          ..firstName = 'Consultant'
          ..lastName = 'Admin'
          ..salutation = 'Mx'
          ..roles = ListBuilder([
            UserRegistrationRolesEnum.number4,
            UserRegistrationRolesEnum.number0,
          ]));
        final consultantRegisterRequest =
            ConsultantsRegisterCompanyPostRequest((b) => b
              ..company.replace(consultantCompany)
              ..users.add(consultantUser));
        final consultantRegisterCompany =
            await api.getConsultantsApi().consultantsRegisterCompanyPost(
                  headers: _authHeader(consultantToken),
                  consultantsRegisterCompanyPostRequest:
                      consultantRegisterRequest,
                );
        expect(consultantRegisterCompany.statusCode, 200);

        final newBranchName = 'Dev Branch $stamp';
        await api.getBranchesApi().branchesPost(
              headers: _authHeader(consultantToken),
              branchesGetRequest: BranchesGetRequest((b) => b..name = newBranchName),
            );
        final branchesAfter = await api.getBranchesApi().branchesGet();
        final newBranch = branchesAfter.data!
            .firstWhere((b) => b.name == newBranchName);
        await api.getBranchesApi().branchesBranchIdCategoriesPost(
              branchId: newBranch.id!,
              headers: _authHeader(consultantToken),
              branchesGetRequest: BranchesGetRequest((b) => b..name = 'Dev Cat'),
            );
        final refreshedBranches = await api.getBranchesApi().branchesGet();
        final refreshedNewBranch = refreshedBranches.data!
            .firstWhere((b) => b.id == newBranch.id);
        final newCategoryId = refreshedNewBranch.categories!.first.id!;
        await api.getBranchesApi().categoriesCategoryIdDelete(
              categoryId: newCategoryId,
              headers: _authHeader(consultantToken),
            );
        await api.getBranchesApi().branchesBranchIdDelete(
              branchId: newBranch.id!,
              headers: _authHeader(consultantToken),
            );

        final providerEmail = 'provider-admin-$stamp@som.local';
        final providerRegNr = 'PREG-$stamp';
        final providerRequest = RegisterCompanyRequest((b) => b
          ..company.replace(CompanyRegistration((c) => c
            ..name = 'Provider Co $stamp'
            ..address.replace(Address((a) => a
              ..country = 'AT'
              ..city = 'Linz'
              ..street = 'Provider'
              ..number = '3'
              ..zip = '4020'))
            ..uidNr = 'ATU-PROV-$stamp'
            ..registrationNr = providerRegNr
            ..companySize = CompanyRegistrationCompanySizeEnum.number1
            ..type = CompanyRegistrationTypeEnum.number1
            ..providerData.replace(ProviderRegistrationData((p) => p
              ..bankDetails.replace(BankDetails((b) => b
                ..iban = 'AT000000000000000000'
                ..bic = 'DEVATW00'
                ..accountOwner = 'Provider Admin'))
              ..branchIds = ListBuilder(['pending-branch-$stamp'])
              ..subscriptionPlanId = planId
              ..paymentInterval = ProviderRegistrationDataPaymentIntervalEnum.number0))
            ..termsAccepted = true
            ..privacyAccepted = true))
          ..users.add(UserRegistration((u) => u
            ..email = providerEmail
            ..firstName = 'Provider'
            ..lastName = 'Admin'
            ..salutation = 'Mx'
            ..roles = ListBuilder([
              UserRegistrationRolesEnum.number4,
              UserRegistrationRolesEnum.number1,
            ]))));
        await api.getCompaniesApi()
            .registerCompany(registerCompanyRequest: providerRequest);

        final providerCompaniesAfter =
            await api.getCompaniesApi().companiesGet(type: '1');
        final pendingProviderCompany = providerCompaniesAfter.data!
            .firstWhere((c) => c.registrationNr == providerRegNr);

        final approveResponse =
            await api.getProvidersApi().providersCompanyIdApprovePost(
                  companyId: pendingProviderCompany.id!,
                  headers: _authHeader(consultantToken),
                  providersCompanyIdApprovePostRequest:
                      ProvidersCompanyIdApprovePostRequest((b) => b
                        ..approvedBranchIds =
                            ListBuilder(['pending-branch-$stamp'])),
                );
        expect(approveResponse.statusCode, 200);

        final declineResponse =
            await api.getProvidersApi().providersCompanyIdDeclinePost(
                  companyId: pendingProviderCompany.id!,
                  headers: _authHeader(consultantToken),
                );
        expect(declineResponse.statusCode, 200);

        final upgradeResponse =
            await api.getSubscriptionsApi().subscriptionsUpgradePost(
                  headers: _authHeader(providerToken),
                  subscriptionsUpgradePostRequest:
                      SubscriptionsUpgradePostRequest((b) => b..planId = planId),
                );
        expect(upgradeResponse.statusCode, 200);

        final companyDeleteResponse =
            await api.getCompaniesApi().companiesCompanyIdDelete(
                  companyId: buyerCompanyId,
                  headers: _authHeader(buyerAdminToken),
                );
        expect(companyDeleteResponse.statusCode, 200);
      });
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}

Future<String> _login(Openapi api, String email, String password) async {
  final response = await api.getAuthApi().authLoginPost(
        authLoginPostRequest: AuthLoginPostRequest((b) => b
          ..email = email
          ..password = password),
      );
  expect(response.statusCode, 200);
  return response.data!.token!;
}

Map<String, String> _authHeader(String token) => {
      'authorization': 'Bearer $token',
    };

Future<String> _obtainToken(
  Openapi api,
  String email, {
  required String type,
  required String contains,
}) async {
  final devToken = await _issueDevToken(api, email, type: type);
  if (devToken.isNotEmpty) {
    return devToken;
  }
  return _waitForOutboxToken(email, contains: contains);
}

Future<String> _issueDevToken(
  Openapi api,
  String email, {
  required String type,
}) async {
  try {
    final response = await api.dio.post<dynamic>(
      '/dev/auth/token',
      data: {'email': email, 'type': type},
    );
    if (response.statusCode == 200 && response.data is Map) {
      final token = (response.data as Map)['token'];
      if (token is String && token.isNotEmpty) {
        return token;
      }
    }
  } catch (_) {
    // Dev endpoint may be disabled.
  }
  return '';
}

Future<String> _waitForOutboxToken(
  String email, {
  required String contains,
}) async {
  final candidateDirs = <Directory>[
    if (_outboxPathOverride.isNotEmpty) Directory(_outboxPathOverride),
    Directory('api/storage/outbox'),
    Directory('storage/outbox'),
    Directory('api/build/storage/outbox'),
    Directory('api/build/bin/storage/outbox'),
    Directory('build/storage/outbox'),
  ];
  final emailKey = email.replaceAll('@', '_');
  final deadline = DateTime.now().add(const Duration(seconds: 60));
  final extraDirs = await _discoverOutboxDirs();
  while (DateTime.now().isBefore(deadline)) {
    for (final dir in [...candidateDirs, ...extraDirs]) {
      if (!dir.existsSync()) {
        continue;
      }
      List<File> files = [];
      try {
        files = dir
            .listSync()
            .whereType<File>()
            .where((file) => file.path.contains(emailKey))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
      } catch (_) {
        continue;
      }
      for (final file in files.reversed) {
        final jsonBody =
            jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        final text = jsonBody['text'] as String? ?? '';
        if (!text.contains(contains)) {
          continue;
        }
        final match = RegExp(r'token=([^&\\s]+)').firstMatch(text);
        if (match != null) {
          return match.group(1)!;
        }
      }
    }
    await Future.delayed(const Duration(milliseconds: 200));
  }
  throw StateError('Token not found for $email');
}

Future<List<Directory>> _discoverOutboxDirs() async {
  final roots = <Directory>[Directory.current];
  final outboxDirs = <Directory>[];
  final maxDepth = 6;
  for (final root in roots) {
    await _walkDirs(root, 0, maxDepth, outboxDirs);
  }
  return outboxDirs;
}

Future<void> _walkDirs(
  Directory dir,
  int depth,
  int maxDepth,
  List<Directory> outboxDirs,
) async {
  if (depth > maxDepth) {
    return;
  }
  try {
    await for (final entity in dir.list(followLinks: false)) {
      if (entity is Directory) {
        final path = entity.path.replaceAll('\\', '/');
        if (path.endsWith('storage/outbox')) {
          outboxDirs.add(entity);
          continue;
        }
        await _walkDirs(entity, depth + 1, maxDepth, outboxDirs);
      }
    }
  } catch (_) {
    // Ignore directories we can't access during tests.
  }
}
