import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/caller.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/params.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class JoinOrLeaveDepartment extends Caller<JoinOrLeaveDepartmentParam, dynamic> {
  final Dio dio;

  JoinOrLeaveDepartment({@required this.dio});

  @override
  Future<dynamic> call(JoinOrLeaveDepartmentParam joinOrLeaveDepartmentParam) async {

     int requestStatus = _getRequestStatus(joinOrLeaveDepartmentParam.requestType);

    final param = {
      "requestStatus": requestStatus,
      "id": joinOrLeaveDepartmentParam.departmentId,
      "isValid": true
    };

    Response response = await dio.put(Urls.SET_DEPARTMENT_INVITATION, data: param);
    return response;
  }

  int _getRequestStatus(RequestType requestType){
    if(requestType == RequestType.Accept)
      return 1;
    else
      return 3;

  }
}
