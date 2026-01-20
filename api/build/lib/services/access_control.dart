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

