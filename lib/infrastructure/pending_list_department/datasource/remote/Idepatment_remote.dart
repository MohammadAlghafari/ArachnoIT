import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/fetch_pending_list_department.dart';
import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/get_department_by_id.dart';
import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/join_leave_department.dart';
import 'package:flutter/widgets.dart';

class IDepartmentRemoteDataSource {
  final FetchPendingListDepartmentRemote fetchPendingListDepartment;
  final JoinOrLeaveDepartment joinOrLeaveDepartment;
  final GetDepartmentById getDepartmentById;

  IDepartmentRemoteDataSource({
    @required this.getDepartmentById,
    @required this.fetchPendingListDepartment,
    @required this.joinOrLeaveDepartment,
  });
}
