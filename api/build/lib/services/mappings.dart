String companyTypeFromWire(int value) {
  switch (value) {
    case 1:
      return 'provider';
    case 2:
      return 'buyer_provider';
    case 0:
    default:
      return 'buyer';
  }
}

int companyTypeToWire(String value) {
  switch (value) {
    case 'provider':
      return 1;
    case 'buyer_provider':
      return 2;
    case 'buyer':
    default:
      return 0;
  }
}

String companySizeFromWire(int value) {
  switch (value) {
    case 0:
      return '0-10';
    case 1:
      return '11-50';
    case 2:
      return '51-100';
    case 3:
      return '101-250';
    case 4:
      return '251-500';
    case 5:
      return '500+';
    default:
      return 'unknown';
  }
}

int companySizeToWire(String value) {
  switch (value) {
    case '0-10':
      return 0;
    case '11-50':
      return 1;
    case '51-100':
      return 2;
    case '101-250':
      return 3;
    case '251-500':
      return 4;
    case '500+':
      return 5;
    default:
      return 0;
  }
}

String roleFromWire(int value) {
  switch (value) {
    case 4:
      return 'admin';
    case 3:
      return 'consultant';
    case 1:
      return 'provider';
    case 0:
      return 'buyer';
    case 2:
    default:
      return 'buyer';
  }
}

int roleToWire(String value) {
  switch (value) {
    case 'admin':
      return 4;
    case 'consultant':
      return 3;
    case 'provider':
      return 1;
    case 'buyer':
    default:
      return 2;
  }
}

String paymentIntervalFromWire(int value) {
  return value == 1 ? 'yearly' : 'monthly';
}

int paymentIntervalToWire(String value) {
  return value.toLowerCase() == 'yearly' ? 1 : 0;
}

String restrictionTypeFromWire(int value) {
  switch (value) {
    case 0:
      return 'max_users';
    case 1:
      return 'max_normal_ads';
    case 2:
      return 'max_banner_ads';
    case 3:
      return 'max_inquiries';
    case 4:
      return 'max_offers';
    case 5:
    default:
      return 'other';
  }
}

int restrictionTypeToWire(String value) {
  switch (value) {
    case 'max_users':
      return 0;
    case 'max_normal_ads':
      return 1;
    case 'max_banner_ads':
      return 2;
    case 'max_inquiries':
      return 3;
    case 'max_offers':
      return 4;
    default:
      return 5;
  }
}
