import '../models/models.dart';
import 'request_auth.dart';

bool isConsultant(RequestAuth auth) => auth.roles.contains('consultant');

bool isConsultantAdmin(RequestAuth auth) {
  return auth.roles.contains('consultant') && auth.roles.contains('admin');
}

bool isSameCompany(RequestAuth auth, String companyId) {
  return auth.companyId == companyId;
}

bool canAccessCompany(RequestAuth auth, String companyId) {
  return isConsultant(auth) || isSameCompany(auth, companyId);
}

bool canAccessInquiryAsBuyer(RequestAuth auth, InquiryRecord inquiry) {
  return auth.activeRole == 'buyer' && inquiry.buyerCompanyId == auth.companyId;
}

bool canAccessInquiryAsProvider({
  required RequestAuth auth,
  required bool isAssignedProvider,
  required bool isProviderActive,
}) {
  if (auth.activeRole != 'provider') {
    return false;
  }
  return isProviderActive && isAssignedProvider;
}

bool canAccessOfferAsBuyer(RequestAuth auth, InquiryRecord inquiry) {
  return auth.activeRole == 'buyer' && inquiry.buyerCompanyId == auth.companyId;
}

bool canAccessOfferAsProvider(RequestAuth auth, OfferRecord offer) {
  return auth.activeRole == 'provider' && offer.providerCompanyId == auth.companyId;
}
