part of 'profile_provider_education_bloc.dart';

abstract class ProfileProviderEducationEvent extends Equatable {
  const ProfileProviderEducationEvent();

  @override
  List<Object> get props => [];
}

class GetAllEducation extends ProfileProviderEducationEvent {
  final bool newRequest;
  final String userId ;
  GetAllEducation({this.newRequest,@required this.userId});
}

class AddItemToFileList extends ProfileProviderEducationEvent {
  final List<ImageType> file;
  AddItemToFileList({this.file});
}

class RemoveItemFromFileList extends ProfileProviderEducationEvent {
  final int index;
  RemoveItemFromFileList({this.index});
}

class ChangeNoEndDateTimeValue extends ProfileProviderEducationEvent {
  final bool value;
  ChangeNoEndDateTimeValue({this.value});
}

class AddNewEducation extends ProfileProviderEducationEvent {
  final String grade;
  final String school;
  final String link;
  final String startDate;
  final String endDate;
  final String fieldOfStudy;
  final String description;
  final List<ImageType> file;
  final bool withExpireTime;
  final BuildContext context;
  AddNewEducation({
    this.endDate,
    this.withExpireTime,
    this.context,
    this.file,
    this.startDate,
    this.description,
    this.fieldOfStudy,
    this.grade,
    this.link,
    this.school,
  });
}

class UpdateEducation extends ProfileProviderEducationEvent {
  final String grade;
  final String school;
  final String link;
  final String startDate;
  final String endDate;
  final String fieldOfStudy;
  final String description;
  final List<ImageType> file;
  final bool withExpireTime;
  final BuildContext context;
  final String id;
  final List<String>removedFiles;
  UpdateEducation(
      {this.endDate,
      this.withExpireTime,
      this.context,
      this.file,
      this.startDate,
      this.description,
      this.fieldOfStudy,
      this.grade,
      this.link,
      this.school,
      this.id,
      this.removedFiles
      });
}

class UpdateEducationList extends ProfileProviderEducationEvent {
  final NewEducationResponse educationResponse;
  final int index;
  UpdateEducationList({this.index, this.educationResponse});
}

class DeleteEducationEvent extends ProfileProviderEducationEvent {
  final int index;
  final String typeId;
  final BuildContext context ;
  DeleteEducationEvent({this.index, this.typeId,@required this.context});
}
