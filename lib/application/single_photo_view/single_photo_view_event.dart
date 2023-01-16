part of 'single_photo_view_bloc.dart';

abstract class SinglePhotoViewEvent extends Equatable {
  const SinglePhotoViewEvent();

  @override
  List<Object> get props => [];
}

class DownloadFileEvent extends SinglePhotoViewEvent {
  const DownloadFileEvent({this.url,this.fileName});
  
  final String url;
  final String fileName;
  @override
  List<Object> get props => [url,fileName];
}
