import 'dart:convert';
import 'dart:io';

const _defaultBaseUrl = 'http://127.0.0.1:8081';
const _systemAdminEmail = 'system-admin@som.local';
const _systemAdminPassword = 'ChangeMe123!';

final _baseUrl =
    String.fromEnvironment('API_BASE_URL', defaultValue: _defaultBaseUrl);

Future<void> main() async {
  final ts = DateTime.now().millisecondsSinceEpoch;
  final buyerAdminEmail = 'buyer.admin+$ts@example.com';
  final buyerUserEmail = 'buyer.user+$ts@example.com';
  final providerAdminEmail = 'provider.admin+$ts@example.com';
  final consultantEmail = 'consultant+$ts@example.com';

  final systemAdminToken = await _loginWithRetry(
    email: _systemAdminEmail,
    password: _systemAdminPassword,
  );

  final branchName = 'Branch-$ts';
  await _postJson(
    '/branches',
    token: systemAdminToken,
    body: {'name': branchName},
  );
  final branches = await _getJson('/branches');
  final branch = _findByName(branches, branchName);
  final branchId = branch['id'] as String;

  final categoryName = 'Category-$ts';
  await _postJson(
    '/branches/$branchId/categories',
    token: systemAdminToken,
    body: {'name': categoryName},
  );
  final branchesAfterCategory = await _getJson('/branches');
  final branchWithCategory = _findByName(branchesAfterCategory, branchName);
  final categories = (branchWithCategory['categories'] as List<dynamic>)
      .cast<Map<String, dynamic>>();
  final category = _findByName(categories, categoryName);
  final categoryId = category['id'] as String;

  final plansResponse = await _getJson('/Subscriptions');
  final plans = (plansResponse['subscriptions'] as List<dynamic>)
      .cast<Map<String, dynamic>>();
  final plan = _pickPlanWithAds(plans);

  final buyerCompanyName = 'Buyer Co $ts';
  final buyerRegistrationSentAt = DateTime.now().toUtc();
  await _postJson(
    '/Companies',
    body: {
      'company': {
        'name': buyerCompanyName,
        'address': _defaultAddress(),
        'uidNr': 'UID-$ts',
        'registrationNr': 'REG-$ts',
        'companySize': 0,
        'type': 0,
        'websiteUrl': 'https://buyer-$ts.example.com',
        'termsAccepted': true,
        'privacyAccepted': true,
      },
      'users': [
        {
          'email': buyerAdminEmail,
          'firstName': 'Buyer',
          'lastName': 'Admin',
          'salutation': 'Mr',
          'telephoneNr': '123456',
          'roles': [2, 4],
        },
      ],
    },
  );

  final companies = await _getJson('/Companies') as List<dynamic>;
  final buyerCompany = _findByName(companies, buyerCompanyName);
  final buyerCompanyId = buyerCompany['id'] as String;

  final buyerToken = await _completeRegistration(
    email: buyerAdminEmail,
    sentAfter: buyerRegistrationSentAt,
    password: 'BuyerAdmin123!',
  );

  final createUserSentAt = DateTime.now().toUtc();
  await _postJson(
    '/Companies/$buyerCompanyId/registerUser',
    token: buyerToken,
    body: {
      'email': buyerUserEmail,
      'firstName': 'Buyer',
      'lastName': 'User',
      'salutation': 'Ms',
      'roles': [2],
    },
  );

  await _completeRegistration(
    email: buyerUserEmail,
    sentAfter: createUserSentAt,
    password: 'BuyerUser123!',
  );

  final buyerUsers = await _getJson(
    '/Companies/$buyerCompanyId/users',
    token: buyerToken,
  ) as List<dynamic>;
  final buyerUser = _findByEmail(buyerUsers, buyerUserEmail);
  final buyerUserId = buyerUser['id'] as String;

  await _putJson(
    '/Companies/$buyerCompanyId/users/$buyerUserId/update',
    token: buyerToken,
    body: {'telephoneNr': '987654', 'title': 'Dr'},
  );

  await _delete(
    '/Companies/$buyerCompanyId/users/$buyerUserId',
    token: buyerToken,
  );

  final forgotSentAt = DateTime.now().toUtc();
  await _postJson('/auth/forgotPassword', body: {'email': buyerAdminEmail});
  await _resetPasswordFromEmail(
    email: buyerAdminEmail,
    sentAfter: forgotSentAt,
    password: 'BuyerAdmin456!',
  );

  final buyerTokenAfterReset = await _loginWithRetry(
    email: buyerAdminEmail,
    password: 'BuyerAdmin456!',
  );

  final providerCompanyName = 'Provider Co $ts';
  final providerRegistrationSentAt = DateTime.now().toUtc();
  await _postJson(
    '/Companies',
    body: {
      'company': {
        'name': providerCompanyName,
        'address': _defaultAddress(),
        'uidNr': 'PUID-$ts',
        'registrationNr': 'PREG-$ts',
        'companySize': 1,
        'type': 2,
        'websiteUrl': 'https://provider-$ts.example.com',
        'termsAccepted': true,
        'privacyAccepted': true,
        'providerData': {
          'bankDetails': {
            'iban': 'AT611904300234573201',
            'bic': 'BKAUATWW',
            'accountOwner': 'Provider Admin',
          },
          'branchIds': [branchId],
          'subscriptionPlanId': plan['id'],
          'paymentInterval': 0,
        },
      },
      'users': [
        {
          'email': providerAdminEmail,
          'firstName': 'Provider',
          'lastName': 'Admin',
          'salutation': 'Mr',
          'roles': [1, 2, 4],
        },
      ],
    },
  );

  final providers = await _getJson('/Companies') as List<dynamic>;
  final providerCompany = _findByName(providers, providerCompanyName);
  final providerCompanyId = providerCompany['id'] as String;

  final providerToken = await _completeRegistration(
    email: providerAdminEmail,
    sentAfter: providerRegistrationSentAt,
    password: 'ProviderAdmin123!',
  );

  await _postJson(
    '/auth/switchRole',
    token: providerToken,
    body: {'role': 'buyer'},
  );
  await _postJson(
    '/auth/switchRole',
    token: providerToken,
    body: {'role': 'provider'},
  );

  final billingRecord = await _postJson(
    '/billing',
    token: systemAdminToken,
    body: {
      'companyId': providerCompanyId,
      'amountInSubunit': 7990,
      'currency': 'EUR',
      'periodStart': DateTime.now().toUtc().toIso8601String(),
      'periodEnd': DateTime.now()
          .toUtc()
          .add(const Duration(days: 30))
          .toIso8601String(),
    },
  ) as Map<String, dynamic>;
  final billingId = billingRecord['id'] as String;
  final billingList =
      await _getJson('/billing', token: providerToken) as List<dynamic>;
  _assert(
    billingList.any((item) => item['id'] == billingId),
    'Billing record not visible to provider.',
  );
  await _putJson(
    '/billing/$billingId',
    token: providerToken,
    body: {'status': 'paid'},
  );

  final inquiryDeadline = _addBusinessDays(DateTime.now().toUtc(), 4);
  final inquiry = await _postJson(
    '/inquiries',
    token: buyerTokenAfterReset,
    body: {
      'branchId': branchId,
      'categoryId': categoryId,
      'productTags': ['tag1', 'tag2'],
      'deadline': inquiryDeadline.toIso8601String(),
      'deliveryZips': ['1010', '1020'],
      'numberOfProviders': 1,
      'description': 'Need a provider for testing.',
      'providerType': 'Händler',
      'providerCompanySize': '0-10',
    },
  ) as Map<String, dynamic>;
  final inquiryId = inquiry['id'] as String;
  final inquiryCreator = inquiry['createdByUserId'] as String;

  await _postJson(
    '/inquiries/$inquiryId/assign',
    token: systemAdminToken,
    body: {
      'providerCompanyIds': [providerCompanyId]
    },
  );

  final providerInquiries =
      await _getJson('/inquiries', token: providerToken) as List<dynamic>;
  _assert(
    providerInquiries.any((item) => item['id'] == inquiryId),
    'Assigned inquiry not visible to provider.',
  );
  final providerFiltered =
      await _getJson('/inquiries?status=open', token: providerToken)
          as List<dynamic>;
  _assert(
    providerFiltered.any((item) => item['id'] == inquiryId),
    'Filtered provider inquiries missing entry.',
  );

  await _getJson(
    '/inquiries?status=open&branchId=$branchId&deadlineFrom=${DateTime.now().toUtc().toIso8601String()}',
    token: buyerTokenAfterReset,
  );
  await _getJson(
    '/inquiries?status=open&editorIds=$inquiryCreator',
    token: systemAdminToken,
  );

  await _postJson(
    '/inquiries/$inquiryId/offers',
    token: providerToken,
    body: {
      'pdfBase64': base64Encode(utf8.encode('%PDF-1.4 placeholder')),
    },
  );

  final offers = await _getJson(
    '/inquiries/$inquiryId/offers',
    token: buyerTokenAfterReset,
  ) as List<dynamic>;
  final offerId = offers.first['id'] as String;
  await _postJson(
    '/offers/$offerId/accept',
    token: buyerTokenAfterReset,
    body: {},
  );

  final inquiryIgnore = await _postJson(
    '/inquiries',
    token: buyerTokenAfterReset,
    body: {
      'branchId': branchId,
      'categoryId': categoryId,
      'productTags': ['tagX'],
      'deadline': inquiryDeadline.toIso8601String(),
      'deliveryZips': ['1010'],
      'numberOfProviders': 1,
      'description': 'Second inquiry for ignore.',
    },
  ) as Map<String, dynamic>;
  final ignoredInquiryId = inquiryIgnore['id'] as String;
  await _postJson(
    '/inquiries/$ignoredInquiryId/assign',
    token: systemAdminToken,
    body: {
      'providerCompanyIds': [providerCompanyId]
    },
  );
  await _postJson(
    '/inquiries/$ignoredInquiryId/ignore',
    token: providerToken,
    body: {},
  );
  final providerIgnored =
      await _getJson('/inquiries?status=ignored', token: providerToken)
          as List<dynamic>;
  _assert(
    providerIgnored.any((item) => item['id'] == ignoredInquiryId),
    'Ignored inquiry not visible in provider filter.',
  );

  final adsResponse = await _postJson(
    '/ads',
    token: providerToken,
    body: {
      'type': 'normal',
      'status': 'active',
      'branchId': branchId,
      'url': 'https://provider-$ts.example.com',
      'headline': 'Provider Ad',
      'description': 'Test ad',
      'startDate': DateTime.now().toUtc().toIso8601String(),
      'endDate': DateTime.now()
          .toUtc()
          .add(const Duration(days: 14))
          .toIso8601String(),
    },
  ) as Map<String, dynamic>;
  final adId = adsResponse['id'] as String;

  final activeAds = await _getJson('/ads?branchId=$branchId') as List<dynamic>;
  _assert(activeAds.any((item) => item['id'] == adId),
      'Ad not visible in buyer list.');

  final providerAds = await _getJson(
    '/ads?scope=company&status=active',
    token: providerToken,
  ) as List<dynamic>;
  _assert(providerAds.any((item) => item['id'] == adId),
      'Ad not visible to provider.');

  await _putJson(
    '/ads/$adId',
    token: providerToken,
    body: {'status': 'draft'},
  );
  await _delete('/ads/$adId', token: providerToken);

  await _getJson(
    '/stats/buyer?from=${_rangeStart()}&to=${_rangeEnd()}',
    token: buyerTokenAfterReset,
  );
  await _getCsv(
    '/stats/buyer?from=${_rangeStart()}&to=${_rangeEnd()}&format=csv',
    token: buyerTokenAfterReset,
  );
  await _getJson(
    '/stats/provider?from=${_rangeStart()}&to=${_rangeEnd()}',
    token: providerToken,
  );
  await _getCsv(
    '/stats/provider?from=${_rangeStart()}&to=${_rangeEnd()}&format=csv',
    token: providerToken,
  );
  await _getJson(
    '/stats/consultant?from=${_rangeStart()}&to=${_rangeEnd()}&type=status',
    token: systemAdminToken,
  );
  await _getCsv(
    '/stats/consultant?from=${_rangeStart()}&to=${_rangeEnd()}&type=status&format=csv',
    token: systemAdminToken,
  );
  await _getCsv(
    '/stats/consultant?from=${_rangeStart()}&to=${_rangeEnd()}&type=period&format=csv',
    token: systemAdminToken,
  );

  final consultantSentAt = DateTime.now().toUtc();
  await _postJson(
    '/consultants',
    token: systemAdminToken,
    body: {
      'email': consultantEmail,
      'firstName': 'Consultant',
      'lastName': 'User',
      'salutation': 'Mx',
    },
  );
  await _completeRegistration(
    email: consultantEmail,
    sentAfter: consultantSentAt,
    password: 'Consultant123!',
  );

  await _postJson(
    '/consultants/registerCompany',
    token: systemAdminToken,
    body: {
      'company': {
        'name': 'Consultant Created $ts',
        'address': _defaultAddress(),
        'uidNr': 'CUID-$ts',
        'registrationNr': 'CREG-$ts',
        'companySize': 0,
        'type': 0,
      },
      'users': [
        {
          'email': 'consultant-created+$ts@example.com',
          'firstName': 'Admin',
          'lastName': 'User',
          'salutation': 'Mr',
          'roles': [4],
        },
      ],
    },
  );

  final cancellation = await _postJson(
    '/Subscriptions/cancel',
    token: providerToken,
    body: {'reason': 'Contract end'},
  ) as Map<String, dynamic>;
  final cancellationId = cancellation['id'] as String;
  final cancellations = await _getJson(
    '/Subscriptions/cancellations?status=pending',
    token: systemAdminToken,
  ) as List<dynamic>;
  _assert(
    cancellations.any((item) => item['id'] == cancellationId),
    'Cancellation request not visible to consultant.',
  );
  await _putJson(
    '/Subscriptions/cancellations/$cancellationId',
    token: systemAdminToken,
    body: {'status': 'approved'},
  );

  await _delete(
    '/Companies/$buyerCompanyId',
    token: systemAdminToken,
  );

  stdout.writeln('Smoke flows completed successfully.');
}

Future<String> _loginWithRetry({
  required String email,
  required String password,
  int retries = 5,
}) async {
  for (var attempt = 0; attempt < retries; attempt += 1) {
    try {
      final response = await _postJson(
        '/auth/login',
        body: {'email': email, 'password': password},
      ) as Map<String, dynamic>;
      return response['token'] as String;
    } catch (error) {
      if (attempt == retries - 1) rethrow;
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }
  throw StateError('Failed to login.');
}

Future<String> _completeRegistration({
  required String email,
  required DateTime sentAfter,
  required String password,
}) async {
  final token = await _awaitToken(
    email: email,
    sentAfter: sentAfter,
    pathHint: 'confirmEmail',
  );
  final confirmPath = Uri(
    path: '/auth/confirmEmail',
    queryParameters: {'token': token, 'email': email},
  ).toString();
  await _getJson(confirmPath);
  await _postJson(
    '/auth/resetPassword',
    body: {
      'email': email,
      'token': token,
      'password': password,
      'confirmPassword': password,
    },
  );
  return _loginWithRetry(email: email, password: password);
}

Future<void> _resetPasswordFromEmail({
  required String email,
  required DateTime sentAfter,
  required String password,
}) async {
  final token = await _awaitToken(
    email: email,
    sentAfter: sentAfter,
    pathHint: 'resetPassword',
  );
  await _postJson(
    '/auth/resetPassword',
    body: {
      'email': email,
      'token': token,
      'password': password,
      'confirmPassword': password,
    },
  );
}

Future<String> _awaitToken({
  required String email,
  required DateTime sentAfter,
  required String pathHint,
}) async {
  final outbox = Directory('api/storage/outbox');
  final deadline = DateTime.now().add(const Duration(seconds: 15));
  while (DateTime.now().isBefore(deadline)) {
    if (outbox.existsSync()) {
      final files = outbox.listSync().whereType<File>().toList()
        ..sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
        );
      for (final file in files) {
        final content =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        if ((content['to'] as String?)?.toLowerCase() != email.toLowerCase()) {
          continue;
        }
        final sentAt = DateTime.tryParse(content['sentAt'] as String? ?? '');
        if (sentAt == null || sentAt.isBefore(sentAfter)) {
          continue;
        }
        final text = content['text'] as String? ?? '';
        if (!text.contains(pathHint)) {
          continue;
        }
        final token = _extractToken(text);
        if (token != null) {
          return token;
        }
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
  throw StateError('Token not found for $email ($pathHint).');
}

String? _extractToken(String text) {
  final match = RegExp(r'token=([^&]+)').firstMatch(text);
  return match?.group(1);
}

Map<String, dynamic> _defaultAddress() => {
      'country': 'AT',
      'city': 'Vienna',
      'street': 'Main',
      'number': '1',
      'zip': '1010',
    };

Map<String, dynamic> _findByName(List<dynamic> list, String name) {
  for (final item in list) {
    if (item is Map<String, dynamic> && item['name'] == name) {
      return item;
    }
  }
  throw StateError('Item not found: $name');
}

Map<String, dynamic> _findByEmail(List<dynamic> list, String email) {
  for (final item in list) {
    if (item is Map<String, dynamic> && item['email'] == email) {
      return item;
    }
  }
  throw StateError('Item not found: $email');
}

Map<String, dynamic> _pickPlanWithAds(List<Map<String, dynamic>> plans) {
  for (final plan in plans) {
    final rules =
        (plan['rules'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final maxNormal = rules
        .where((rule) => rule['restriction'] == 1)
        .map((rule) => rule['upperLimit'] as int? ?? 0)
        .fold<int>(0, (prev, value) => value > prev ? value : prev);
    if (maxNormal > 0) {
      return plan;
    }
  }
  if (plans.isEmpty) {
    throw StateError('No subscription plans available.');
  }
  return plans.first;
}

DateTime _addBusinessDays(DateTime start, int days) {
  var remaining = days;
  var current = start;
  while (remaining > 0) {
    current = current.add(const Duration(days: 1));
    if (current.weekday == DateTime.saturday ||
        current.weekday == DateTime.sunday) {
      continue;
    }
    remaining -= 1;
  }
  return current;
}

String _rangeStart() =>
    DateTime.now().toUtc().subtract(const Duration(days: 30)).toIso8601String();
String _rangeEnd() =>
    DateTime.now().toUtc().add(const Duration(days: 1)).toIso8601String();

Future<dynamic> _getJson(String path, {String? token}) async {
  final response = await _request(
    'GET',
    path,
    token: token,
  );
  return response.body;
}

Future<String> _getCsv(String path, {String? token}) async {
  final response = await _request(
    'GET',
    path,
    token: token,
  );
  return response.rawBody;
}

Future<dynamic> _postJson(
  String path, {
  Map<String, dynamic>? body,
  String? token,
}) async {
  final response = await _request(
    'POST',
    path,
    body: body,
    token: token,
  );
  return response.body;
}

Future<dynamic> _putJson(
  String path, {
  Map<String, dynamic>? body,
  String? token,
}) async {
  final response = await _request(
    'PUT',
    path,
    body: body,
    token: token,
  );
  return response.body;
}

Future<void> _delete(
  String path, {
  String? token,
}) async {
  await _request(
    'DELETE',
    path,
    token: token,
  );
}

Future<_Response> _request(
  String method,
  String path, {
  Map<String, dynamic>? body,
  String? token,
}) async {
  final client = HttpClient();
  final uri = Uri.parse('$_baseUrl$path');
  final request = await client.openUrl(method, uri);
  request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
  if (token != null) {
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
  }
  if (body != null) {
    request.add(utf8.encode(jsonEncode(body)));
  }
  final response = await request.close();
  final rawBody = await utf8.decodeStream(response);
  dynamic decoded;
  if (rawBody.isNotEmpty) {
    try {
      decoded = jsonDecode(rawBody);
    } catch (_) {
      decoded = rawBody;
    }
  }
  if (response.statusCode >= 400) {
    throw StateError(
        'Request $method $path failed: ${response.statusCode} $rawBody');
  }
  return _Response(response.statusCode, rawBody, decoded);
}

void _assert(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

class _Response {
  _Response(this.statusCode, this.rawBody, this.body);
  final int statusCode;
  final String rawBody;
  final dynamic body;
}
