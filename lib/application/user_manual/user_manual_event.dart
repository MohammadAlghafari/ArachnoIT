part of 'user_manual_bloc.dart';

abstract class UserManualEvent extends Equatable {
  const UserManualEvent();

  @override
  List<Object> get props => [];
}

class DownloadFileEvent extends UserManualEvent {
  const DownloadFileEvent({this.url,this.fileName,this.context});
  final String url;
  final String fileName;
  final BuildContext context;
  @override
  List<Object> get props => [url,fileName];
}
