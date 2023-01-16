import 'dart:io';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/response/experiance_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/response/new_experiance_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';

abstract class ProfileProviderExperianceInterface {
   Future<ResponseWrapper<List<ExperianceResponse>>> getUserProfileExperiance({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });
 
   Future<ResponseWrapper<NewExperianceResponse>> addNewExperiance({
    String name,
    String startDate,
    String endDate,
    String organization,
    String url,
    List<ImageType> file,
    String description,
  });
     Future<ResponseWrapper<NewExperianceResponse>> updateSelectedExperiance({
    String name,
    String startDate,
    String endDate,
    String organization,
    String url,
    List<ImageType> file,
    String description,
    String id,
    List<String>removedfiles
  });

   Future<ResponseWrapper<bool>> deleteSelectedExperiance({
    String itemId,
  });
}