part of 'pending_list_department_bloc.dart';

abstract class PendingListDepartmentEvent extends Equatable {
  const PendingListDepartmentEvent();
}

class FetchPendingListDepartmentEvent extends PendingListDepartmentEvent {
  final bool rebuildScreen;
  FetchPendingListDepartmentEvent({this.rebuildScreen=false});
  @override
  List<Object> get props => [rebuildScreen];
}

class AcceptOrLeaveDepartmentEvent extends PendingListDepartmentEvent {
  final String departmentId;
  final RequestType requestType;

  AcceptOrLeaveDepartmentEvent({
    @required this.departmentId,
    @required this.requestType,
  });

  @override
  List<Object> get props => [];
}

class GetDepartmentDetailByIdEvent extends PendingListDepartmentEvent{
  final String departmentId;

  GetDepartmentDetailByIdEvent({@required this.departmentId});
  @override
  List<Object> get props => [];
}
