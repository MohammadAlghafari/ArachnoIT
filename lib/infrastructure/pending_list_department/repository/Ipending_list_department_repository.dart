import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_by_id_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/join_leave_department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/params.dart';
import 'package:flutter/cupertino.dart';

abstract class IPendingListDepartmentRepository{

Future<ResponseWrapper<List<DepartmentModel>>> getAllDepartment({
  @required int pageNumber ,
  @required int pageSize ,
  @required String healthCareProviderId,
});

Future<ResponseWrapper<JoinLeaveDepartmentModel>> joinOrLeaveDepartment({
  @required String departmentId,
  @required RequestType requestType,
});

Future<ResponseWrapper<DepartmentByIdModel>> getDepartmentById({
  @required String departmentId,
});
}