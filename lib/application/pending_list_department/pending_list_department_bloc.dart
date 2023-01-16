import 'dart:async';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/get_department_by_id.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_by_id_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/join_leave_department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

part 'pending_list_department_event.dart';

part 'pending_list_department_state.dart';

class PendingListDepartmentBloc
    extends Bloc<PendingListDepartmentEvent, PendingListDepartmentState> {
  final CatalogFacadeService catalogFacadeService;

  PendingListDepartmentBloc({@required this.catalogFacadeService})
      : assert(catalogFacadeService != null, "inject catalogFacade"),
        super(PendingListDepartmentInitial());

  final _departmentSizeLimit = 20;

  @override
  Stream<PendingListDepartmentState> mapEventToState(
    PendingListDepartmentEvent event,
  ) async* {
    if (event is FetchPendingListDepartmentEvent)
      yield* _mapEventToFetchPendingListDepartment(state, event);
    else if (event is AcceptOrLeaveDepartmentEvent)
      yield* _mapEventToAcceptOrLeaveDepartment(event);
    else if (event is GetDepartmentDetailByIdEvent)
      yield* _mapEventToGetDepartmentById(event);
  }

  Stream<PendingListDepartmentState> _mapEventToFetchPendingListDepartment(
      PendingListDepartmentState state,
      FetchPendingListDepartmentEvent fetchPendingListDepartmentEvent) async* {
    if (fetchPendingListDepartmentEvent.rebuildScreen)
      state = PendingListDepartmentState();
    if (state.hasReachedMax) {
      yield state;
      return;
    }

    try {
      if (state.stateStatus == PendingListDepartmentStatus.initial ||
          state.stateStatus == PendingListDepartmentStatus.failure) {
        yield state.copyWith(
          hasReachedMax: state.hasReachedMax,
          departments: state.departments,
          stateStatus: PendingListDepartmentStatus.loading,
        );

        final ResponseWrapper<List<DepartmentModel>> responseWrapper =
            await _fetchPendingListDepartment();

        if (responseWrapper.responseType == ResType.ResponseType.SUCCESS)
          yield state.copyWith(
            hasReachedMax: _hasReachedMax(responseWrapper.data.length),
            departments: responseWrapper.data,
            stateStatus: PendingListDepartmentStatus.success,
          );
        else
          yield state.copyWith(
              hasReachedMax: state.hasReachedMax,
              stateStatus: PendingListDepartmentStatus.failure,
              departments: state.departments);
        return;
      }

      final ResponseWrapper<List<DepartmentModel>> responseWrapper =
          await _fetchPendingListDepartment(
              pageNumber:
                  (state.departments.length / _departmentSizeLimit).round());

      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
        bool isEmptyList = responseWrapper.data.isEmpty;
        yield isEmptyList
            ? state.copyWith(
                hasReachedMax: true,
                stateStatus: PendingListDepartmentStatus.success,
                departments: state.departments)
            : state.copyWith(
                hasReachedMax: _hasReachedMax(responseWrapper.data.length),
                stateStatus: PendingListDepartmentStatus.success,
                departments: List.of(state.departments)
                  ..addAll(responseWrapper.data));
      } else
        yield state.copyWith(
            hasReachedMax: state.hasReachedMax,
            stateStatus: PendingListDepartmentStatus.failure,
            departments: state.departments);
    } catch (e) {
      yield state.copyWith(
        stateStatus: PendingListDepartmentStatus.failure,
      );
    }
  }

  Future<ResponseWrapper<List<DepartmentModel>>> _fetchPendingListDepartment(
      {int pageNumber}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
    LoginResponse responses = LoginResponse.fromJson(loginResponse);

    String userId = responses.userId;

    return await catalogFacadeService.getAllDepartment(
      pageNumber: pageNumber ?? 0,
      pageSize: _departmentSizeLimit,
      healthCareProviderId: userId,
    );
  }

  Stream<PendingListDepartmentState> _mapEventToAcceptOrLeaveDepartment(
      AcceptOrLeaveDepartmentEvent event) async* {
    yield state.copyWith(
        stateStatus: PendingListDepartmentStatus.leaveOrAcceptEventLoading);

    final ResponseWrapper<JoinLeaveDepartmentModel> responseWrapper =
        await catalogFacadeService.joinLeaveDepartment(
      departmentId: event.departmentId,
      requestType: event.requestType,
    );

    if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
      if (event.requestType == RequestType.Accept) {
        state.departments
            .firstWhere((element) => element.id == event.departmentId)
            .requestStatus = 1;

        yield state.copyWith(
            stateStatus: PendingListDepartmentStatus.successAcceptDepartment);
      } else {
        state.departments
            .removeWhere((element) => element.id == event.departmentId);
        yield state.copyWith(
            stateStatus: PendingListDepartmentStatus.successLeaveDepartment);
      }
    } else {
      yield state.copyWith(
          stateStatus: PendingListDepartmentStatus.operationFailed);
    }
  }

  bool _hasReachedMax(int postsCount) => postsCount < _departmentSizeLimit;

  Stream<PendingListDepartmentState> _mapEventToGetDepartmentById(
      GetDepartmentDetailByIdEvent event) async* {
    try {
      yield state.copyWith(
        stateStatus: PendingListDepartmentStatus.getDepartmentByIdLoading,
      );

      final ResponseWrapper<DepartmentByIdModel> responseWrapper =
          await catalogFacadeService.getDepartmentById(
              departmentId: event.departmentId);

      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS)
        yield state.copyWith(
            departmentByIdModel: responseWrapper.data,
            stateStatus: PendingListDepartmentStatus.getDepartmentByIdSuccess);
      else
        yield state.copyWith(
            stateStatus: PendingListDepartmentStatus.getDepartmentByIdFailure);
    } catch (e) {
      yield state.copyWith(
        stateStatus: PendingListDepartmentStatus.getDepartmentByIdFailure,
      );
    }
  }
}
