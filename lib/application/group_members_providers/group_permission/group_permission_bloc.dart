import 'dart:async';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_permission/response/group_permission_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'group_permission_event.dart';

part 'group_permission_state.dart';

class GroupPermissionBloc extends Bloc<GroupPermissionEvent, GroupPermissionState> {
  CatalogFacadeService catalogFacadeService;

  GroupPermissionBloc({@required this.catalogFacadeService}) : super(GroupPermissionState());

  @override
  Stream<GroupPermissionState> mapEventToState(
    GroupPermissionEvent event,
  ) async* {

    if (event is GetGroupPermission) yield* groupPermission(state);
    else if(event is ChangeMemberPermissionType)
      yield state.copyWith(memberInvitePermissionType: event.memberInvitePermissionType);
  }

  Stream<GroupPermissionState> groupPermission(GroupPermissionState state) async* {
    yield state.copyWith(groupPermissionStatus: GroupPermissionStatus.loadingData);
    try {
      final ResponseWrapper<List<GroupPermission>> response = await catalogFacadeService.getGroupPermission();
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield state.copyWith(
            groupPermissionStatus: GroupPermissionStatus.success,
            groupPermission: response.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(groupPermissionStatus: GroupPermissionStatus.failureValidation);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(groupPermissionStatus: GroupPermissionStatus.serverError);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(groupPermissionStatus: GroupPermissionStatus.networkError);
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(groupPermissionStatus: GroupPermissionStatus.networkError);
          break;
      }
    } catch (e) {
      yield state.copyWith();
    }
  }
}
