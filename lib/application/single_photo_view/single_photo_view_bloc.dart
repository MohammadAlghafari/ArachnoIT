import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../common/global_prupose_functions.dart';

part 'single_photo_view_event.dart';
part 'single_photo_view_state.dart';

class SinglePhotoViewBloc
    extends Bloc<SinglePhotoViewEvent, SinglePhotoViewState> {
  SinglePhotoViewBloc() : super(SinglePhotoViewState());

  @override
  Stream<SinglePhotoViewState> mapEventToState(
    SinglePhotoViewEvent event,
  ) async* {
    if (event is DownloadFileEvent) yield* _mapDownloadFileToState(event);
  }

  Stream<SinglePhotoViewState> _mapDownloadFileToState(
    DownloadFileEvent event,
  ) async* {
    try {
      GlobalPurposeFunctions.downloadFile(event.url, event.fileName);
    } on Exception catch (_) {}
  }
}
