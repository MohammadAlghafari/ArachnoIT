import 'dart:io';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/response/educations_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/response/new_education_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';

abstract class ProfileProviderEducationsInterface{
  Future<ResponseWrapper<List<EducationsResponse>>> getUserProfileEducation({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });

   Future<ResponseWrapper<NewEducationResponse>> addNewEducation({
    String grade,
    String school,
    String link,
    String startDate,
    String endDate,
    String fieldOfStudy,
    String description,
    List<ImageType> file,
  });
    Future<ResponseWrapper<NewEducationResponse>> updateSelectedEducations({
    String grade,
    String school,
    String link,
    String startDate,
    String endDate,
    String fieldOfStudy,
    String description,
    List<ImageType> file,
    String id,
    List<String> removedFiles,
  });
  
  Future<ResponseWrapper<bool>> deleteSelectedEducation({
    String itemId,
  });
}