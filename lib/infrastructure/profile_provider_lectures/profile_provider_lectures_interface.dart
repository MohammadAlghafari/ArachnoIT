import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/new_lectures_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/qualifications_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';

abstract class ProfileProviderLecturesInterface {
  Future<ResponseWrapper<List<QualificationsResponse>>> getUserProfileLecture({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });

  Future<ResponseWrapper<NewLecturesResponse>> setNewLectures({
    String title,
    String description,
    List<ImageType> file,
  });

  Future<ResponseWrapper<NewLecturesResponse>> updateSelectedLectures({
    String title,
    String description,
    List<ImageType> file,
    String itemID,
    List<String>removedFile
  });


  Future<ResponseWrapper<bool>> deleteSelectedLectures({
    String itemId,
  });


}
