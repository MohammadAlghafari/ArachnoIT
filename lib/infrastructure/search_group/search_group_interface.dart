import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchGroupInterface {
  Future<ResponseWrapper<List<SubCategoryResponse>>> getSubCategory(
      {@required categoryId});
  Future<ResponseWrapper<List<CategoryResponse>>> getMainCategory();
  Future<ResponseWrapper<List<GroupResponse>>> getAdvanceSearchGroups({int pageNumber, int pageSize,String searchText,String categoryId,String subCategoryID,String userId});
  Future<ResponseWrapper<List<GroupResponse>>> getGroupsSearchText({int pageNumber, int pageSize,String searchText,String categoryId,String subCategoryID,String userId}); 

}
//GroupResponse