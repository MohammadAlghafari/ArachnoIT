part of 'profile_provider_projects_bloc.dart';

abstract class ProfileProviderProjectsEvent extends Equatable {
  const ProfileProviderProjectsEvent();

  @override
  List<Object> get props => [];
}

class GetAllProjects extends ProfileProviderProjectsEvent {
  final bool newRequest;
  final String userId;
  GetAllProjects({this.newRequest,@required this.userId});
}

class AddItemToFileList extends ProfileProviderProjectsEvent {
  final List<ImageType> file;
  AddItemToFileList({this.file});
}

class RemoveItemFromFileList extends ProfileProviderProjectsEvent {
  final int index;
  RemoveItemFromFileList({this.index});
}

class SetNewProject extends ProfileProviderProjectsEvent {
  final BuildContext context;
  final String name;
  final String startDate;
  final String endDate;
  final String link;
  final List<ImageType> file;
  final bool withExpireTime;
  final String description;
  SetNewProject({
    this.context,
    this.name,
    this.startDate,
    this.endDate,
    this.link,
    this.file,
    this.withExpireTime,
    this.description,
  });
}

class UpdateSelectedProject extends ProfileProviderProjectsEvent {
  final BuildContext context;
  final String name;
  final String startDate;
  final String endDate;
  final String link;
  final List<ImageType> file;
  final bool withExpireTime;
  final String description;
  final String id;
  final List<String> removedfiles;
  UpdateSelectedProject({
    this.context,
    this.name,
    this.startDate,
    this.endDate,
    this.link,
    this.file,
    this.id,
    this.withExpireTime,
    this.description,
    this.removedfiles,
  });
}

class UpdateListAfterSuccess extends ProfileProviderProjectsEvent{
  final int index;
  final NewProjectResponse newItem;
  UpdateListAfterSuccess({this.index,this.newItem});
}

class DeleteProjectItem extends ProfileProviderProjectsEvent{
  final int index;
  final String itemId;
  final BuildContext context;
  DeleteProjectItem({this.index,this.itemId, @required this.context});
}