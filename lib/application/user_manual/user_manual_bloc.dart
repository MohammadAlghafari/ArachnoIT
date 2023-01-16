import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common/global_prupose_functions.dart';

part 'user_manual_event.dart';
part 'user_manual_state.dart';

class UserManualBloc extends Bloc<UserManualEvent, UserManualState> {
  UserManualBloc() : super(UserManualState());

  @override
  Stream<UserManualState> mapEventToState(
    UserManualEvent event,
  ) async* {
    if (event is DownloadFileEvent) yield* _mapDownloadFileToState(event);
  }

  Stream<UserManualState> _mapDownloadFileToState(
    DownloadFileEvent event,
  ) async* {
    try {
     GlobalPurposeFunctions.downloadFile(event.url, event.fileName);
    } on Exception catch (_) {}
  }

  
}
