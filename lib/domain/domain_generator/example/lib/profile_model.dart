import 'package:annotations/annotations.dart';

part 'profile_model.g.dart';

@generateSubclass
class ProfileModel {
  String _firstName = 'Pero';
  String _lastName = 'Zdero';
  int _age = 20;
  bool _codes = true;
}
