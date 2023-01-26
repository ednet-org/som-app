import 'company_size.dart';
import 'company_type.dart';

class ProviderCriteria {
  final String location;
  final CompanyType companyType;
  final CompanySize companySize;

  const ProviderCriteria({
    required this.location,
    required this.companyType,
    required this.companySize,
  });

  static ProviderCriteria fromJson(Map<String, dynamic> json) {
    return ProviderCriteria(
      location: json['location'],
      companyType: CompanyType.fromJson(json['companyType']),
      companySize: CompanySize.fromStringOrNull(json['companySize']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'companyType': companyType.toJson(),
      'companySize': companySize.toJson(),
    };
  }
}
