import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/caller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetDepartmentById extends Caller<String,dynamic>{
  final Dio dio;

  GetDepartmentById({@required this.dio});
  @override
  Future<dynamic> call(String departmentId) async{
    try{
      Response response = await dio.get(Urls.GET_DEPARTMENT_BY_ID + "/$departmentId");

      return response ;
    }
    catch(e){
      rethrow ;
    }
  }

}