// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Branch on _Branch, Store {
  final _$uuidAtom = Atom(name: '_Branch.uuid');

  @override
  String? get uuid {
    _$uuidAtom.reportRead();
    return super.uuid;
  }

  @override
  set uuid(String? value) {
    _$uuidAtom.reportWrite(value, super.uuid, () {
      super.uuid = value;
    });
  }

  final _$titleAtom = Atom(name: '_Branch.title');

  @override
  String? get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String? value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$categoryAtom = Atom(name: '_Branch.category');

  @override
  Branch? get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(Branch? value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  final _$productAtom = Atom(name: '_Branch.product');

  @override
  Branch? get product {
    _$productAtom.reportRead();
    return super.product;
  }

  @override
  set product(Branch? value) {
    _$productAtom.reportWrite(value, super.product, () {
      super.product = value;
    });
  }

  final _$_BranchActionController = ActionController(name: '_Branch');

  @override
  void setUuid(String value) {
    final _$actionInfo =
        _$_BranchActionController.startAction(name: '_Branch.setUuid');
    try {
      return super.setUuid(value);
    } finally {
      _$_BranchActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitle(String value) {
    final _$actionInfo =
        _$_BranchActionController.startAction(name: '_Branch.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$_BranchActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategory(Branch value) {
    final _$actionInfo =
        _$_BranchActionController.startAction(name: '_Branch.setCategory');
    try {
      return super.setCategory(value);
    } finally {
      _$_BranchActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProduct(Branch value) {
    final _$actionInfo =
        _$_BranchActionController.startAction(name: '_Branch.setProduct');
    try {
      return super.setProduct(value);
    } finally {
      _$_BranchActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
uuid: ${uuid},
title: ${title},
category: ${category},
product: ${product}
    ''';
  }
}
