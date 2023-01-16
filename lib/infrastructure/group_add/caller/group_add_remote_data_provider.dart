import 'dart:convert';
import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GroupAddRemoteDataProvider {
 final Dio dio;
  const GroupAddRemoteDataProvider({@required this.dio});


  Future <dynamic> getCategoryGroup()async{
    final params = {
      'hitPlatform': 0,
      'withDataOnly': false,
    };
    Response response = await dio.get(Urls.GET_SEARCH_CATEGORIES, queryParameters: params);
    return response;

  }

 Future <dynamic> getSubCategoryGroup({
  @required String categoryId
})async{
   final params = {
     'hitPlatform': 0,
     'categoryId': categoryId,
   };
   Response response = await dio.get(Urls.GET_SEARCH_SUB_CATEGORIES, queryParameters: params);
   return response;

 }

 Future <dynamic> getAllGroup({
   @required String healthcareProviderId
})async{
   final myParams = {
     'healthcareProviderId':healthcareProviderId,
     'enablePagination': false,
     'approvalListOnly': false,
     'categoryId': null,
     'subCategoryId': null,
     'mySubscriptionsOnly': true,
   };
   Response response = await dio.get(Urls.GET_GROUPS, queryParameters: myParams);
   return response;

 }


 Future <dynamic> addGroup({
   @required String id,
   @required   String name,
   @required   String   description,
   @required   String parentGroupId,
   @required   List<String>  subCategory,
   @required   int privacyLevel,
   @required   File file,
})async{
   String fileName;
if(file!=null)
  fileName =  file.path.split('/').last;

   FormData formData = FormData.fromMap({
       "Id": id,
       "Name": name,
       "ParentGroupId":(parentGroupId!='00000000-0000-0000-0000-000000000000')? parentGroupId:'',
       "Description": description,
       "GroupMembers": [],
       "SubCategoryIds": jsonEncode(subCategory),
       "PrivacyLevel":privacyLevel,
       "file": (file!=null)? await MultipartFile.fromFile(file.path, filename: fileName): null
     });




   Response response = await dio.post(Urls.Add_Group, data: formData);
   return response;

 }

}