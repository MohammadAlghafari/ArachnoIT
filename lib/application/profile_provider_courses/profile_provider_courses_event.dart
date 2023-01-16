part of 'profile_provider_courses_bloc.dart';

abstract class ProfileProviderCoursesEvent extends Equatable {
  const ProfileProviderCoursesEvent();

  @override
  List<Object> get props => [];
}

class GetAllCourses extends ProfileProviderCoursesEvent {
  final bool newRequest;
  final String userId;
  GetAllCourses({this.newRequest,@required this.userId});
}

class AddItemToFileList extends ProfileProviderCoursesEvent {
  final List<ImageType> file;
  AddItemToFileList({this.file});
}

class RemoveItemFromFileList extends ProfileProviderCoursesEvent {
  final int index;
  RemoveItemFromFileList({this.index});
}

class AddNewCourse extends ProfileProviderCoursesEvent {
  final String name;
  final String place;
  final String date;
  final List<ImageType> file;
  final BuildContext context;
  AddNewCourse({
    this.context,
    this.place,
    this.date,
    this.file,
    this.name,
  });
}

class UpdateSelectedCourse extends ProfileProviderCoursesEvent {
  final String name;
  final String place;
  final String date;
  final List<ImageType> file;
  final List<String> removedfiles;
  final BuildContext context;
  final String id;
  UpdateSelectedCourse({
    this.name,
    this.place,
    this.date,
    this.file,
    this.removedfiles,
    this.context,
    this.id,
  });
}

class UpdateDataAfterSuccess extends ProfileProviderCoursesEvent {
  final int index;
  final NewCourseResponse newCourseResponse;

  UpdateDataAfterSuccess({this.index, this.newCourseResponse});
}

class DeleteCourseEvent extends ProfileProviderCoursesEvent {
  final String id;
  final int index;
  final BuildContext context;
  DeleteCourseEvent({this.id, this.index, this.context});
}
