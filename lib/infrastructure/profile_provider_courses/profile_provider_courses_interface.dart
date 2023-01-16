import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/courses_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/new_course_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';

abstract class ProfileProviderCoursesInterface {
  Future<ResponseWrapper<List<CoursesResponse>>> getUeseProfileCourses({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });

  Future<ResponseWrapper<NewCourseResponse>> addNewCourse({
    String name,
    String place,
    String date,
    List<ImageType> file,
  });

  Future<ResponseWrapper<NewCourseResponse>> updateSelectedCourse({
    String name,
    String place,
    String date,
    List<ImageType> file,
    List<String> removedfiles,
    String id,
  });

  Future<ResponseWrapper<bool>> deleteSelectedCourse({
    String itemId,
  });
}
