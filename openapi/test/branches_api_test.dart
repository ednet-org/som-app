import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for BranchesApi
void main() {
  final instance = Openapi().getBranchesApi();

  group(BranchesApi, () {
    // Create category
    //
    //Future branchesBranchIdCategoriesPost(String branchId, BranchesGetRequest branchesGetRequest) async
    test('test branchesBranchIdCategoriesPost', () async {
      // TODO
    });

    // Delete branch
    //
    //Future branchesBranchIdDelete(String branchId) async
    test('test branchesBranchIdDelete', () async {
      // TODO
    });

    // List branches
    //
    //Future<BuiltList<Branch>> branchesGet() async
    test('test branchesGet', () async {
      // TODO
    });

    // Create branch
    //
    //Future branchesPost(BranchesGetRequest branchesGetRequest) async
    test('test branchesPost', () async {
      // TODO
    });

    // Delete category
    //
    //Future categoriesCategoryIdDelete(String categoryId) async
    test('test categoriesCategoryIdDelete', () async {
      // TODO
    });

  });
}
