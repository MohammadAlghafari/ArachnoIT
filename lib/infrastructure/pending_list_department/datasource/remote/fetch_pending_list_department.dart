import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/caller.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/params.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



class FetchPendingListDepartmentRemote extends Caller<GetDepartmentParam, dynamic > {
  final Dio dio;

  FetchPendingListDepartmentRemote({@required this.dio});

  @override
  Future<dynamic> call(GetDepartmentParam getDepartmentParam) async {
    try{

      final param = {
        "healthcareProviderId": getDepartmentParam.healthCareProviderId,
        "pageNumber": getDepartmentParam.pageNumber,
        "pageSize": getDepartmentParam.pageSize,
        "ownershipType": 2,
        "approvalListOnly": false,
        "searchString":"",
        "enablePagination": true
      };
      Response response = await dio.get(Urls.GET_DEPARTMENT, queryParameters: param);

      return response ;
    }
    catch(e){
      rethrow ;
    }
  }
}


