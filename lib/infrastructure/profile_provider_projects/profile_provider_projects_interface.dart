import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/new_projects_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/projects_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';

abstract class ProfileProviderProjectsInterface {
  Future<ResponseWrapper<List<ProjectsResponse>>> getUserProfileProjects({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });

  Future<ResponseWrapper<NewProjectResponse>> addNewProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
  });

  Future<ResponseWrapper<NewProjectResponse>> updateSelectedProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
    String description,
    String id,
    List<String> removedfiles,
  });

  Future<ResponseWrapper<bool>> deleteSeletecteProject({
  String itemId,
  });
}
