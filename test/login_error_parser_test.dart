import 'package:flutter_test/flutter_test.dart';
import 'package:som/ui/domain/model/login/login_error_parser.dart';

void main() {
  test('returns string message as-is', () {
    expect(parseLoginErrorMessage('Invalid password'), 'Invalid password');
  });

  test('returns message field from map', () {
    expect(parseLoginErrorMessage({'message': 'Bad request'}), 'Bad request');
  });

  test('returns error field from map when message missing', () {
    expect(parseLoginErrorMessage({'error': 'Oops'}), 'Oops');
  });

  test('returns fallback for non-string values', () {
    expect(parseLoginErrorMessage(404), '404');
  });

  test('returns default for null data', () {
    expect(parseLoginErrorMessage(null), 'Something went wrong');
  });
}
