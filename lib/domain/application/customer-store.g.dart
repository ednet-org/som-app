// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer-store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CustomerStore on CustomerStoreBase, Store {
  final _$registeringCustomerAtom =
      Atom(name: 'CustomerStoreBase.registeringCustomer');

  @override
  RegisteringCustomer get registeringCustomer {
    _$registeringCustomerAtom.reportRead();
    return super.registeringCustomer;
  }

  @override
  set registeringCustomer(RegisteringCustomer value) {
    _$registeringCustomerAtom.reportWrite(value, super.registeringCustomer, () {
      super.registeringCustomer = value;
    });
  }

  @override
  String toString() {
    return '''
registeringCustomer: ${registeringCustomer}
    ''';
  }
}
