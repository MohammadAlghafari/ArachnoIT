part of 'profile_provider_lectures_bloc.dart';

abstract class ProfileProviderLecturesEvent extends Equatable {
  const ProfileProviderLecturesEvent();

  @override
  List<Object> get props => [];
}

class GetAllLectures extends ProfileProviderLecturesEvent {
  final bool newRequest;
  final String userId;
  GetAllLectures({this.newRequest, @required this.userId});
}

class AddItemToFileList extends ProfileProviderLecturesEvent {
  final List<ImageType> file;
  AddItemToFileList({this.file});
}

class RemoveItemFromFileList extends ProfileProviderLecturesEvent {
  final int index;
  RemoveItemFromFileList({this.index});
}

class AddNewLecturesState extends ProfileProviderLecturesEvent {
  final String title;
  final String description;
  final List<ImageType> file;
  final BuildContext context;
  AddNewLecturesState({this.file, this.description, this.title, this.context});
}

class UpdateLecturesState extends ProfileProviderLecturesEvent {
  final String title;
  final String description;
  final List<ImageType> file;
  final String itemId;
  final BuildContext context;
  final int index;
  final List<String> removedFile;
  UpdateLecturesState({
    this.index,
    this.itemId,
    this.file,
    this.description,
    this.title,
    this.context,
    this.removedFile,
  });
}

class UpdateValue extends ProfileProviderLecturesEvent {
  final NewLecturesResponse item;
  final int index;
  UpdateValue({this.item, this.index});
}

class DeleteSelectedItem extends ProfileProviderLecturesEvent {
  final String itemId;
  final int index;
  final BuildContext context;
  DeleteSelectedItem({this.itemId, this.index,@required this.context});
}
