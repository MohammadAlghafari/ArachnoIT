part of 'profile_provider_experiance_bloc.dart';

abstract class ProfileProviderExperianceEvent extends Equatable {
  const ProfileProviderExperianceEvent();

  @override
  List<Object> get props => [];
}

class GetALlExperiance extends ProfileProviderExperianceEvent {
  final bool newRequest;
  final String userId;
  GetALlExperiance({this.newRequest,@required this.userId});
}

class AddItemToFileList extends ProfileProviderExperianceEvent {
  final List<ImageType> file;
  AddItemToFileList({this.file});
}

class RemoveItemFromFileList extends ProfileProviderExperianceEvent {
  final int index;
  RemoveItemFromFileList({this.index});
}
class AddNewExperiance extends ProfileProviderExperianceEvent {
  final String name;
  final String startDate;
  final String endDate;
  final String organization;
  final String url;
  final List<ImageType> file;
  final String description;
  final BuildContext context;
  final bool withExpireTime;
  AddNewExperiance({
    this.file,
    this.organization,
    this.startDate,
    this.name,
    this.description,
    this.endDate,
    this.context,
    this.url,
    this.withExpireTime,
  });

}



class UpdateExperianceEvent extends ProfileProviderExperianceEvent {
  final String name;
  final String startDate;
  final String endDate;
  final String organization;
  final String url;
  final List<ImageType> file;
  final String description;
  final BuildContext context;
  final bool withExpireTime;
  final String id;
  final List<String> removedFiles;
  UpdateExperianceEvent({
    this.file,
    this.organization,
    this.startDate,
    this.name,
    this.description,
    this.endDate,
    this.context,
    this.url,
    this.withExpireTime,
    this.id,
    this.removedFiles,
  });

}

class UpdateInfoAfterSuccess extends ProfileProviderExperianceEvent{
  final NewExperianceResponse response;
  final int index;
  UpdateInfoAfterSuccess({this.response,this.index});
}

class DeleteExperianceEvent extends ProfileProviderExperianceEvent {
  final int index;
  final String typeId;
  final BuildContext context;
  DeleteExperianceEvent({this.index, this.typeId,@required this.context});
}
