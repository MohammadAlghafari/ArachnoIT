import 'dart:async';

import 'package:arachnoit/infrastructure/active_session/response/active_session_model.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
part 'active_session_event.dart';
part 'active_session_state.dart';

class ActiveSessionBloc extends Bloc<ActiveSessionEvent, ActiveSessionState> {
  CatalogFacadeService catalogService;
  ActiveSessionBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(ActiveSessionInitial());

  @override
  Stream<ActiveSessionState> mapEventToState(ActiveSessionEvent event) async* {
    if (event is GetALlActiveSessionEvent) {
      yield* _mapGetALlActiveSessionEvent(event);
    } else if (event is SendReportEvent) {
      yield* _mapSendReportEvent(event);
    }
  }

  Stream<ActiveSessionState> _mapSendReportEvent(SendReportEvent event) async* {
    if (event.message.trim().length == 0) {
      yield FailedSendReport(message: "add message");
      return;
    }
    try {
      yield LoadingSendReport();
      ResponseWrapper<bool> res = await catalogService.sendReport(
          itemId: event.itemId, message: event.message);
      if (res.data == true) {
        yield SendReportSuccess(message: res.successMessage);
        return;
      } else {
        yield FailedSendReport(message: res.errorMessage);
        return;
      }
    } catch (e) {
      yield FailedSendReport(message: "Error happened try again");
      return;
    }
  }

  Stream<ActiveSessionState> _mapGetALlActiveSessionEvent(GetALlActiveSessionEvent event) async* {
    try {
      if(!event.isRefreshData)
      yield LoadingState();
      ResponseWrapper<List<ActiveSessionModel>> res =
          await catalogService.getAllActiveSessions();
      switch (res.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GelAllActiveSessionSuccess(activeSeeions: res.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: res.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: res.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      yield RemoteClientErrorState();
      return;
    }
  }
}
