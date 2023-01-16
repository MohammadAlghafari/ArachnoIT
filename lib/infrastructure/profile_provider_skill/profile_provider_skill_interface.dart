import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/new_skill_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/skills_response.dart';

abstract class ProfileProviderSkillInterface {
    Future<ResponseWrapper<List<SkillsResponse>>> getUeseProfileSkills({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  });


    Future<ResponseWrapper<NewSkillResponse>> setNewSkill({
     String name,
    String startDate,
    String endDate,
    String description,
    String itemId,
  });
  Future<ResponseWrapper<bool>> deleteSelectedSkill({
  String itemId,
  });


}