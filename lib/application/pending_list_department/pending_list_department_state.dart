part of 'pending_list_department_bloc.dart';

enum PendingListDepartmentStatus {
  initial,
  loading,
  success,
  failure,
  leaveOrAcceptEventLoading,
  successAcceptDepartment,
  successLeaveDepartment,
  operationFailed,
  getDepartmentByIdLoading,
  getDepartmentByIdSuccess,
  getDepartmentByIdFailure
}

class PendingListDepartmentState  {
  final bool hasReachedMax;
  final PendingListDepartmentStatus stateStatus;
  final List<DepartmentModel> departments;
  final DepartmentByIdModel departmentByIdModel;

  PendingListDepartmentState({
    this.hasReachedMax = false,
    this.stateStatus = PendingListDepartmentStatus.initial,
    this.departments = const <DepartmentModel>[],
    this.departmentByIdModel,
  });

  PendingListDepartmentState copyWith({
     bool hasReachedMax,
     PendingListDepartmentStatus stateStatus,
     List<DepartmentModel> departments,
     DepartmentByIdModel departmentByIdModel
  }) {
    return PendingListDepartmentState(
        departments: departments ?? this.departments,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        stateStatus: stateStatus ?? this.stateStatus,
        departmentByIdModel: departmentByIdModel
    );
  }

  @override
  String toString() {
    return 'PendingListDepartmentState{hasReachedMax: $hasReachedMax, stateStatus: $stateStatus, departments: $departments}';
  }
}

class PendingListDepartmentInitial extends PendingListDepartmentState {
}
