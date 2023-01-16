import 'dart:io';

import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/infrastructure/active_session/active_session_repository.dart';
import 'package:arachnoit/infrastructure/active_session/response/active_session_model.dart';
import 'package:arachnoit/infrastructure/add_blog/add_blog_repository.dart';
import 'package:arachnoit/infrastructure/add_blog/response/add_blog_response.dart';
import 'package:arachnoit/infrastructure/add_questions/add_question_repository.dart';
import 'package:arachnoit/infrastructure/add_questions/response/add_question_response.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/blog_replay_comment_item_repository.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/group_add/models/add_group_resposne.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_permission_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/joined_group_response.dart';
import 'package:arachnoit/infrastructure/group_details_search/group_details_search_repository.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/Invite_member_to_group_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/get_group_members_repository.dart';
import 'package:arachnoit/infrastructure/notification/notification_repository.dart';
import 'package:arachnoit/infrastructure/notification/response/notification_response.dart';
import 'package:arachnoit/infrastructure/pendding_list_group/pendding_list_group_repository.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/pending_list_patents_repository.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/response/patents_response.dart';
import 'package:arachnoit/infrastructure/pending_list_department/repository/pending_list_department_repository.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_by_id_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/join_leave_department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/params.dart';
import 'package:arachnoit/infrastructure/profile/call/set_social_media_link.dart';
import 'package:arachnoit/infrastructure/profile/response/contact_response.dart';
import 'package:arachnoit/infrastructure/profile/response/person_profile_basic_info_response.dart';
import 'package:arachnoit/infrastructure/profile/response/personal_profile_photos.dart';
import 'package:arachnoit/infrastructure/profile_action/profile_action_repository.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/response/profile_follow_list_reponse.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/profile_provider_certificate_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/repository/new_certificate_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/profile_provider_courses_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/new_course_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/profile_provider_educations_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/response/educations_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/response/new_education_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/profile_provider_experiance_repository.dart';
import 'package:arachnoit/infrastructure/profile/profile_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/repository/certificate_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/courses_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/response/experiance_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/response/new_experiance_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/profile_provider_language_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/response/language_response.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/profile_provider_lectures_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/new_lectures_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/qualifications_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/new_license_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/profile_provider_projects_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/new_projects_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/projects_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/profile_provider_skill_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/new_skill_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/skills_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/profile_provider_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/licenses_response.dart';
import 'package:arachnoit/infrastructure/question_details/response/action_answer_response.dart';
import 'package:arachnoit/infrastructure/registration_socail/registration_socail_repository.dart';
import 'package:arachnoit/infrastructure/registration_socail/response/social_response.dart';
import 'package:arachnoit/infrastructure/search_blogs/search_blogs_repository.dart';
import 'package:arachnoit/infrastructure/search_group/search_group_repositories.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:arachnoit/infrastructure/search_provider/response/provider_services_response.dart';
import 'package:arachnoit/infrastructure/search_provider/search_provider_repositories.dart';
import 'package:arachnoit/infrastructure/search_question/search_question_repositories.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'blog_comment_item/blog_comment_item_repository.dart';
import 'blog_details/response/comment_body_respose.dart';
import 'blog_replay_item/blog_replay_item_repository.dart';
import 'blogs_emphasis_vote/blogs_emphasis_vote_repository.dart';
import 'blogs_vote/blogs_useful_vote_repository.dart';
import 'blogs_vote_item/blogs_vote_item_repository.dart';
import 'common_response/blogs_vote_respose.dart';
import 'common_response/question_answer_response.dart';
import 'discover_my_interests_add_interests/discover_my_interests_add_interests_repository.dart';
import 'discover_my_interests_sub_catergories_qaa/discover_my_interests_sub_catergories_qaa_repository.dart';
import 'package:flutter/foundation.dart';
import 'all_groups/all_groups_repository.dart';
import 'api/response_wrapper.dart';
import 'blog_comment_item/blog_comment_item_repository.dart';
import 'blog_details/blog_details_repository.dart';
import 'blog_details/response/blog_details_response.dart';
import 'changePassword/change_password._repository.dart';
import 'common_response/category_response.dart';
import 'common_response/file_response.dart';
import 'common_response/provider_item_response.dart';
import 'common_response/vote_response.dart';
import 'discover_categories/discover_categories_repository.dart';
import 'discover_categories_details/discover_categories_details_repository.dart';
import 'discover_categories_sub_category_all_blogs/discover_categories_sub_category_all_blogs_repository.dart';
import 'discover_categories_sub_category_all_groups/discover_categories_sub_category_all_groups_repository.dart';
import 'discover_categories_sub_category_all_questions/discover_categories_sub_category_all_questions_repository.dart';
import 'discover_my_interests/discover_my_interests_repository.dart';
import 'discover_my_interests_sub_categories_blogs/discover_my_interests_sub_categories_blogs_repositories.dart';
import 'forgetPassword/forget_password_repository.dart';
import 'group_add/group_add_repository.dart';
import 'group_add/models/group_category_response.dart';
import 'group_details/group_details_repository.dart';
import 'group_details/response/delete_group_response.dart';
import 'group_details/response/group_details_response.dart';
import 'group_details_blogs/group_details_blogs_repository.dart';
import 'group_details_questions/group_details_questions_repostory.dart';
import 'group_details_search_blogs/group_details_search_blogs_repository.dart';
import 'group_details_search_questions/group_details_search_questions_repository.dart';
import 'group_members_providers/group_invite_members/group_invite_members_repository.dart';
import 'group_members_providers/group_invite_members/response/group_invite_members_response.dart';
import 'group_members_providers/group_invite_members/response/invite_member_json_body_request.dart';
import 'group_members_providers/group_members/response/get_group_members_response.dart';
import 'group_members_providers/group_permission/group_permission_repository.dart';
import 'group_members_providers/group_permission/response/group_permission_response.dart';
import 'groups/groups_repository.dart';
import 'common_response/group_response.dart';
import 'home_blog/home_blog_repository.dart';
import 'home_blog/response/get_blogs_response.dart';
import 'home_qaa/home_qaa_repository.dart';
import 'home_qaa/response/qaa_response.dart';
import 'in_app_terms_and_policies/terms_and_condition_repository.dart';
import 'language/language_repository.dart';
import 'latest_version/latest_version_repository.dart';
import 'latest_version/response/latest_version_response.dart';
import 'login/login_repository.dart';
import 'login/response/login_response.dart';
import 'logout/logout_repository.dart';
import 'notification/response/get_notification_response.dart';
import 'profile_follow_list/profile_follow_list_repository.dart';
import 'providers_all/providers_all_repository.dart';
import 'providers_favorite/providers_favorite_repository.dart';
import 'providers_provider_item/providers_provider_item_repository.dart';
import 'question_answer_item/question_answer_item_repository.dart';
import 'question_details/question_details_repository.dart';
import 'question_details/response/question_details_response.dart';
import 'question_replay_details/models/question_answer_replay_response.dart';
import 'question_replay_details/question_replay_repository.dart';
import 'registration/registration_repository.dart';
import 'registration/response/account_types_response.dart';
import 'registration/response/cities_by_country_response.dart';
import 'registration/response/country_reponse.dart';
import 'common_response/specification_response.dart';
import 'common_response/sub_specification_response.dart';
import 'verification/verification_repository.dart';

class CatalogFacadeService {
  const CatalogFacadeService(
      {this.loginRepository,
      this.registrationRepository,
      this.termsAndConditionsRepository,
      this.verificationRepository,
      this.forgetPasswordRepository,
      this.homeBlogRepository,
      this.languageRepository,
      this.changePasswordRepository,
      this.homeQaaRepository,
      this.logoutRepsitory,
      this.questionAnswerItemRepository,
      this.questionDetailsRepository,
      this.blogDetailsRepository,
      this.commentItemRepository,
      this.groupsRepository,
      this.allGroupsRepository,
      this.providersAllRepository,
      this.providersFavoriteRepository,
      this.providerItemRepository,
      this.discoverCategoriesRepository,
      this.discoverCategoriesDetailsRepository,
      this.discoverCategoriesSubCategoryAllBlogsRepository,
      this.discoverCategoriesSubCategoryAllGroupsRepostory,
      this.discoverCategoriesSubCategoryAllQuestionsRepository,
      this.groupDetailsRepository,
      this.groupDetailsBlogsRepository,
      this.groupDetailsQuestionsRepository,
      this.groupDetailsSearchBlogsRepository,
      this.groupDetailsSearchQuestionsRepository,
      this.groupDetailsSearchRepository,
      this.disconverMyInterestsSubCategorisRepositories,
      this.discoverMyInterestRepository,
      this.discoverMyInterestsAtInterestsRepository,
      this.discoverMyInterestsSubCatergoriesQaaRepository,
      @required this.searchProviderRepositories,
      @required this.searchGroupRepositories,
      @required this.searchBlogsRepository,
      @required this.searchQuestionsRepository,
      @required this.activeSessionRepository,
      @required this.penddingListGroupRepository,
      @required this.penddingListPatentsRepository,
      @required this.blogReplayCommentItemRepository,
      @required this.pendingListDepartmentRepository,
      @required this.blogReplayItemRepository,
      @required this.blogsVoteRepository,
      @required this.blogsEmphasisVoteRepository,
      @required this.blogsVoteItemRepository,
      @required this.profileRepository,
      @required this.profileProviderRepository,
        @required this.profileFollowListRepository,
      @required this.profileProvierLanguageRepository,
      @required this.profileProviderCertificateRepository,
      @required this.profileProviderSkillRepository,
      @required this.profileProviderCoursesRepository,
      @required this.profileProviderEducationsRepository,
      @required this.profileProviderProjectsRepository,
      @required this.profileProviderExperianceRepository,
      @required this.profileProviderLecturesRepository,
      @required this.addQuestionRepository,
      @required this.addBlogRepository,
      @required this.getGroupMembersRepository,
      @required this.getGroupInviteMembersRepository,
      @required this.getGroupPermissionRepository,
      @required this.groupAddRepository,
      @required this.profileActionRepository,
      @required this.questionReplayDetailRepository,
      @required this.registrationSocailRepository,
      @required this.notificationRepository,
      @required this.latestVersionRepository});
  final NotificationRepository notificationRepository;
  final TermsAndConditionsRepository termsAndConditionsRepository;
  final GetGroupMembersRepository getGroupMembersRepository;
  final GroupAddRepository groupAddRepository;
  final GetGroupPermissionRepository getGroupPermissionRepository;
  final GetGroupInviteMembersRepository getGroupInviteMembersRepository;
  final ProfileProviderLecturesRepository profileProviderLecturesRepository;
  final ProfileProviderExperianceRepository profileProviderExperianceRepository;
  final ProfileProviderProjectsRepository profileProviderProjectsRepository;
  final ProfileProviderEducationsRepository profileProviderEducationsRepository;
  final ProfileProviderCoursesRepository profileProviderCoursesRepository;
  final ProfileProviderSkillRepository profileProviderSkillRepository;
  final ProfileProviderCertificateRepository
  profileProviderCertificateRepository;
  final ProfileProvierLanguageRepository profileProvierLanguageRepository;
  final ProfileProviderRepository profileProviderRepository;
  final ProfileRepository profileRepository;
  final ProfileFollowListRepository profileFollowListRepository;
  final BlogsEmphasisVoteRepository blogsEmphasisVoteRepository;
  final PendingListDepartmentRepository pendingListDepartmentRepository;
  final ActiveSessionRepository activeSessionRepository;
  final DiscoverMyInterestsAddInterestsRepository
  discoverMyInterestsAtInterestsRepository;
  final LoginRepository loginRepository;
  final RegistrationRepository registrationRepository;
  final VerificationRepository verificationRepository;
  final ForgetPasswordRepository forgetPasswordRepository;
  final HomeBlogRepository homeBlogRepository;
  final LanguageRepository languageRepository;
  final ChangePasswordRepository changePasswordRepository;
  final HomeQaaRepository homeQaaRepository;
  final LogoutRepsitory logoutRepsitory;
  final QuestionAnswerItemRepository questionAnswerItemRepository;
  final QuestionDetailsRepository questionDetailsRepository;
  final BlogDetailsRepository blogDetailsRepository;
  final CommentItemRepository commentItemRepository;
  final GroupsRepository groupsRepository;
  final AllGroupsRepository allGroupsRepository;
  final ProvidersAllRepository providersAllRepository;
  final ProvidersFavoriteRepository providersFavoriteRepository;
  final ProvidersProviderItemRepository providerItemRepository;
  final DiscoverCategoriesRepository discoverCategoriesRepository;
  final DiscoverCategoriesDetailsRepository discoverCategoriesDetailsRepository;
  final DiscoverCategoriesSubCategoryAllBlogsRepository
      discoverCategoriesSubCategoryAllBlogsRepository;
  final DiscoverCategoriesSubCategoryAllGroupsRepository
      discoverCategoriesSubCategoryAllGroupsRepostory;
  final DiscoverCategoriesSubCategoryAllQuestionsRepository
      discoverCategoriesSubCategoryAllQuestionsRepository;
  final GroupDetailsRepository groupDetailsRepository;
  final DisconverMyInterestsSubCategorisRepositories
  disconverMyInterestsSubCategorisRepositories;
  final DiscoverMyInterestsRepository discoverMyInterestRepository;
  final DiscoverMyInterestsSubCatergoriesQaaRepository
      discoverMyInterestsSubCatergoriesQaaRepository;
  final GroupDetailsBlogsRepository groupDetailsBlogsRepository;
  final GroupDetailsQuestionsRepository groupDetailsQuestionsRepository;
  final GroupDetailsSearchBlogsRepository groupDetailsSearchBlogsRepository;
  final GroupDetailsSearchQuestionsRepository
  groupDetailsSearchQuestionsRepository;
  final GroupDetailsSearchRepository groupDetailsSearchRepository;
  final SearchProviderRepositories searchProviderRepositories;
  final SearchGroupRepositories searchGroupRepositories;
  final SearchBlogsRepository searchBlogsRepository;
  final SearchQuestionsRepository searchQuestionsRepository;
  final PenddingListGroupRepository penddingListGroupRepository;
  final PenddingListPatentsRepository penddingListPatentsRepository;
  final BlogReplayDetailRepository blogReplayCommentItemRepository;
  final BlogReplayItemRepository blogReplayItemRepository;
  final PostsVotesRepository blogsVoteRepository;
  final BlogsVoteItemRepository blogsVoteItemRepository;
  final AddQuestionRepository addQuestionRepository;
  final AddBlogRepository addBlogRepository;
  final ProfileActionRepository profileActionRepository;
  final QuestionReplayDetailRepository questionReplayDetailRepository;
  final RegistrationSocailRepository registrationSocailRepository;
  final LatestVersionRepository latestVersionRepository;
  Future<ResponseWrapper<List<GetGroupMembersResponse>>> getGroupMembers({
    @required String idGroup,
    @required bool includeHealthcareProvidersOnly,
    @required String query,
    @required bool enablePagination,
    @required int pageNumber,
    @required int pageSize,
    @required bool getNonGroupMembersOnly,
  }) async {
    return getGroupMembersRepository.getGroupMember(
        idGroup: idGroup,
        includeHealthcareProvidersOnly: includeHealthcareProvidersOnly,
        enablePagination: enablePagination,
        getNonGroupMembersOnly: getNonGroupMembersOnly,
        pageNumber: pageNumber,
        pageSize: pageSize,
        query: query);
  }

  Future<ResponseWrapper<List<GroupPermission>>> getGroupPermission() async {
    return getGroupPermissionRepository.getGroupPermission();
  }

  Future<ResponseWrapper<bool>> removeMemberFromGroup({
    @required String groupId,
    @required List<String> memberId,
  }) async {
    return getGroupMembersRepository.removeMembersFromGroup(
        groupId: groupId, membersId: memberId);
  }

  Future<ResponseWrapper<List<GetGroupInviteMembersResponse>>>
  getGroupInviteMembers({
    @required String idGroup,
    @required bool includeHealthcareProvidersOnly,
    @required String query,
    @required bool enablePagination,
    @required int pageNumber,
    @required int pageSize,
    @required bool getNonGroupMembersOnly,
  }) async {
    return getGroupInviteMembersRepository.getGroupInviteMember(
        idGroup: idGroup,
        includeHealthcareProvidersOnly: includeHealthcareProvidersOnly,
        enablePagination: enablePagination,
        getNonGroupMembersOnly: getNonGroupMembersOnly,
        pageNumber: pageNumber,
        pageSize: pageSize,
        query: query);
  }

  Future<ResponseWrapper<InviteMemberToGroupResponse>> inviteMembersToGroup({
    @required List<dynamic> inviteMemberPermission,
    @required String groupId,
    @required String personId,
  }) async {
    return getGroupInviteMembersRepository.inviteMemberToGroup(
        groupId: groupId,
        personId: personId,
        inviteMemberPermission: inviteMemberPermission);
  }

  Future<ResponseWrapper<LoginResponse>> loginIntoServer(
      {@required String email,
      @required String password,
      @required String model,
      @required String product,
      @required String brand,
      @required String ip,
      @required int osApiLevel}) async {
    return loginRepository.loginIntoServer(
        email: email,
        password: password,
        model: model,
        product: product,
        brand: brand,
        ip: ip,
        osApiLevel: osApiLevel);
  }

  Future<ResponseWrapper<bool>> logoutUser(
      {@required String model,
      @required String product,
      @required String brand,
      @required String ip,
      @required int osApiLevel}) async {
    return logoutRepsitory.logoutUser(
        model: model,
        product: product,
        brand: brand,
        ip: ip,
        osApiLevel: osApiLevel);
  }

  Future<ResponseWrapper<bool>> requestResetPassword({
    @required String email,
  }) async {
    return loginRepository.requestResetPassword(
      email: email,
    );
  }

  Future<ResponseWrapper<bool>> resetPassword({
    @required String newPassword,
    @required String confirmPassword,
    @required String email,
    @required String token,
  }) async {
    return forgetPasswordRepository.resetPassword(
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      email: email,
      token: token,
    );
  }

  Future<ResponseWrapper<bool>> changePassword({
    @required String currentPassword,
    @required String newPassword,
    @required String confirmPassword,
  }) async {
    return changePasswordRepository.cahngePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  Future<ResponseWrapper<List<CitiesByCountryResponse>>> getCitiesByCountry({
    @required String countryId,
  }) async {
    return registrationRepository.getCitiesByCountry(
      countryId: countryId,
    );
  }

  Future<ResponseWrapper<List<AccountTypesResponse>>> getAccountTypes() async {
    return registrationRepository.getAccountTypes();
  }

  Future<ResponseWrapper<List<SpecificationResponse>>> getSpecification(
      {@required String accountTypeId}) async {
    return registrationRepository.getSpecification(
        accountTypeId: accountTypeId);
  }

  Future<ResponseWrapper<List<SubSpecificationResponse>>> getSubSpecification(
      {@required String specificationId}) async {
    return registrationRepository.getSubSpecification(
        specificationId: specificationId);
  }

  Future<ResponseWrapper<List<CountryResponse>>> getCountries() async {
    return registrationRepository.getCountries();
  }

  Future<ResponseWrapper<List<dynamic>>> isTouchPointNameEmailMobileAvailable(
      {@required String touchPointName,
        @required String email,
        @required String mobile}) async {
    return registrationRepository.isTouchPointNameEmailMobileAvailable(
      touchPointName: touchPointName,
      email: email,
      mobile: mobile,
    );
  }

  Future<ResponseWrapper<List<dynamic>>> isEmailMobileAvailable(
      {@required String email, @required String mobile}) async {
    return registrationRepository.isEmailMobileAvailable(
      email: email,
      mobile: mobile,
    );
  }

  Future<ResponseWrapper<String>> registerHealthCareProvider({
    @required String inTouchPointName,
    @required String subSpecificationId,
    @required String email,
    @required String firstName,
    @required String lastName,
    @required String birthdate,
    @required int gender,
    @required String password,
    @required String mobile,
    @required String cityId,
  }) async {
    return registrationRepository.registerHealthCareProvider(
      inTouchPointName: inTouchPointName,
      subSpecificationId: subSpecificationId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      birthdate: birthdate,
      gender: gender,
      password: password,
      mobile: mobile,
      cityId: cityId,
    );
  }

  Future<ResponseWrapper<String>> registerNormalUser({
    @required String email,
    @required String firstName,
    @required String lastName,
    @required String birthdate,
    @required int gender,
    @required String password,
    @required String mobile,
    @required String cityId,
  }) async {
    return registrationRepository.registerNormalUser(
      email: email,
      firstName: firstName,
      lastName: lastName,
      birthdate: birthdate,
      gender: gender,
      password: password,
      mobile: mobile,
      cityId: cityId,
    );
  }

  Future<ResponseWrapper<bool>> confirmRegistration(
      {@required String email, @required String activationCode}) async {
    return verificationRepository.confirmRegistration(
      email: email,
      activationCode: activationCode,
    );
  }

  Future<ResponseWrapper<bool>> sendActivationCode(
      {@required String email, @required String phoneNumber}) async {
    return verificationRepository.sendActivationCode(
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  Future<ResponseWrapper<bool>> setLanguage() async {
    return languageRepository.setLanguage();
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogs({
    @required String personId,
    @required int accountTypeId,
    @required String blogId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required bool myFeed,
    @required List<String> tagsId,
    @required String query,
    @required bool isResearcher,
    @required int pageNumber,
    @required int pageSize,
    @required int orderByBlogs,
    @required bool mySubscriptionsOnly,
  }) async {
    return homeBlogRepository.getBlogs(
      personId: personId,
      accountTypeId: accountTypeId,
      blogId: blogId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      groupId: groupId,
      myFeed: myFeed,
      tagsId: tagsId,
      query: query,
      isResearcher: isResearcher,
      pageNumber: pageNumber,
      pageSize: pageSize,
      orderByBlogs: orderByBlogs,
      mySubscriptionsOnly: mySubscriptionsOnly,
    );
  }

  Future<ResponseWrapper<List<QaaResponse>>> getQaas({
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return homeQaaRepository.getQaas(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<bool>> deleteQuestion(
      {@required String questionId}) async {
    return homeQaaRepository.deleteQuestion(questionId: questionId);
  }

  Future<ResponseWrapper<List<FileResponse>>> getQuestionfiles({
    @required String questionId,
  }) async {
    return homeQaaRepository.getQuestionFiles(
      questionId: questionId,
    );
  }

  Future<ResponseWrapper<QuestionDetailsResponse>> getQuestionDetails({
    @required String questionId,
  }) async {
    return questionDetailsRepository.getQuestionDetails(
      questionId: questionId,
    );
  }

  Future<ResponseWrapper<BlogDetailsResponse>> getBlogDetails({
    @required String blogId,
  }) async {
    return blogDetailsRepository.getBlogDetails(
      blogId: blogId,
    );
  }

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForQuestion({
    @required String itemId,
    @required bool status,
  }) async {
    return homeQaaRepository.setUsefulVoteForQuestion(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<bool>> reportQaa({
    @required String description,
    @required String qaaId,
  }) async {
    return homeQaaRepository.sendQaaReport(
        description: description, qaaId: qaaId);
  }

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForQuestionDetails({
    @required String itemId,
    @required bool status,
  }) async {
    return questionDetailsRepository.setUsefulVoteForQuestionDetails(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForBlog({
    @required String itemId,
    @required bool status,
  }) async {
    return homeBlogRepository.setEmphasisVoteForBlog(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<BriefProfileResponse>> getBriefProfile(
      {String id}) async {
    return homeBlogRepository.getBriefProfile(id: id);
  }

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForBlog({
    @required String itemId,
    @required bool status,
  }) async {
    return homeBlogRepository.setUsefulVoteForBlog(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<bool>> deleteBlog({@required String blogID}) async {
    return homeBlogRepository.deleteBlog(blogID: blogID);
  }

  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForBlogDetails({
    @required String itemId,
    @required bool status,
  }) async {
    return blogDetailsRepository.setEmphasisVoteForBlogDetails(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<CommentBodyRespose>> setNewComment(
      {@required String comment, @required String postId}) async {
    return blogDetailsRepository.setNewComment(
        comment: comment, postId: postId);
  }

  Future<ResponseWrapper<CommentBodyRespose>> updateComment(
      {@required String comment,
        @required String postId,
        String commentId}) async {
    return blogDetailsRepository.updateComment(
        comment: comment, postId: postId, commentId: commentId);
  }

  Future<ResponseWrapper<bool>> deleteComment({String commentId}) async {
    return blogDetailsRepository.deleteSelectedComment(commentId: commentId);
  }

  Future<ResponseWrapper<bool>> removeAnswer({String answerId}) async {
    return questionDetailsRepository.removeAnswer(answerId: answerId);
  }

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForBlogDetails({
    @required String itemId,
    @required bool status,
  }) async {
    return blogDetailsRepository.setUsefulVoteForBlogDetails(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForAnswer({
    @required String itemId,
    @required bool status,
  }) async {
    return questionAnswerItemRepository.setEmphasisVoteForAnswer(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForAnswer({
    @required String itemId,
    @required bool status,
  }) async {
    return questionAnswerItemRepository.setUsefulVoteForAnswer(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForComment({
    @required String itemId,
    @required bool status,
  }) async {
    return commentItemRepository.setUsefulVoteForComment(
      itemId: itemId,
      status: status,
    );
  }

  Future<ResponseWrapper<BriefProfileResponse>> getCommentBriefProfile(
      {String id}) async {
    return await commentItemRepository.getBriefProfile(id: id);
  }

  Future<ResponseWrapper<List<GroupResponse>>> getPublicGroups({
    @required int pageNumber,
    @required int pageSize,
    @required bool enablePagination,
    @required String searchString,
    @required String healthcareProviderId,
    @required bool approvalListOnly,
    @required int ownershipType,
    @required String categoryId,
    @required String subCategoryId,
    @required bool mySubscriptionsOnly,
  }) async {
    return allGroupsRepository.getPublicGroups(
      pageNumber: pageNumber,
      pageSize: pageSize,
      enablePagination: enablePagination,
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      approvalListOnly: approvalListOnly,
      ownershipType: ownershipType,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      mySubscriptionsOnly: mySubscriptionsOnly,
    );
  }

  Future<ResponseWrapper<List<GroupResponse>>> getMyGroups({
    @required int pageNumber,
    @required int pageSize,
    @required bool enablePagination,
    @required String searchString,
    @required String healthcareProviderId,
    @required bool approvalListOnly,
    @required int ownershipType,
    @required String categoryId,
    @required String subCategoryId,
    @required bool mySubscriptionsOnly,
  }) async {
    return groupsRepository.getMyGroups(
      pageNumber: pageNumber,
      pageSize: pageSize,
      enablePagination: enablePagination,
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      approvalListOnly: approvalListOnly,
      ownershipType: ownershipType,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      mySubscriptionsOnly: mySubscriptionsOnly,
    );
  }

  Future<ResponseWrapper<List<dynamic>>> getPublicAndMyGroups({
    @required int publicPageNumber,
    @required int publicPageSize,
    @required bool publicEnablePagination,
    @required String publicSearchString,
    @required String publicHealthcareProviderId,
    @required bool publicApprovalListOnly,
    @required int publicOwnershipType,
    @required String publicCategoryId,
    @required String publicSubCategoryId,
    @required bool publicMySubscriptionsOnly,
    @required int myPageNumber,
    @required int myPageSize,
    @required bool myEnablePagination,
    @required String mySearchString,
    @required String myHealthcareProviderId,
    @required bool myApprovalListOnly,
    @required int myOwnershipType,
    @required String myCategoryId,
    @required String mySubCategoryId,
    @required bool myMySubscriptionsOnly,
  }) async {
    return groupsRepository.getPublicAndMyGroups(
      publicPageNumber: publicPageNumber,
      publicPageSize: publicPageSize,
      publicEnablePagination: publicEnablePagination,
      publicSearchString: publicSearchString,
      publicHealthcareProviderId: publicHealthcareProviderId,
      publicApprovalListOnly: publicApprovalListOnly,
      publicOwnershipType: publicOwnershipType,
      publicCategoryId: publicCategoryId,
      publicSubCategoryId: publicSubCategoryId,
      publicMySubscriptionsOnly: publicMySubscriptionsOnly,
      myPageNumber: myPageNumber,
      myPageSize: myPageSize,
      myEnablePagination: myEnablePagination,
      mySearchString: mySearchString,
      myHealthcareProviderId: myHealthcareProviderId,
      myApprovalListOnly: myApprovalListOnly,
      myOwnershipType: myOwnershipType,
      myCategoryId: myCategoryId,
      mySubCategoryId: mySubCategoryId,
      myMySubscriptionsOnly: myMySubscriptionsOnly,
    );
  }

  Future<ResponseWrapper<List<ProviderItemResponse>>> getAllProviders({
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return providersAllRepository.getAllProviders(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<ProviderItemResponse>>> getFavoriteProviders({
    @required String searchString,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return providersFavoriteRepository.getFavoriteProviders(
      searchString: searchString,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<bool>> setFollowProvider(
      {@required String healthCareProviderId,
        @required bool followStatus}) async {
    return profileActionRepository.setFollowProvider(
      followStatus: followStatus,
      healthCareProviderId: healthCareProviderId,
    );
  }

  Future<ResponseWrapper<bool>> setFavoriteProvider({
    @required String favoritePersonId,
    @required bool favoriteStatus,
  }) async {
    return providerItemRepository.setFavoriteProvider(
      favoritePersonId: favoritePersonId,
      favoriteStatus: favoriteStatus,
    );
  }

  Future<ResponseWrapper<List<CategoryResponse>>> getCategories() async {
    return discoverCategoriesRepository.getCategories();
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoryBlogs({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return discoverCategoriesDetailsRepository.getSubCategoryBlogs(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<QaaResponse>>> getSubCategoryQuestions({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return discoverCategoriesDetailsRepository.getSubCategoryQuestions(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<GroupResponse>>> getSubCategoryGroups({
    @required int pageNumber,
    @required int pageSize,
    @required bool enablePagination,
    @required String searchString,
    @required String healthcareProviderId,
    @required bool approvalListOnly,
    @required int ownershipType,
    @required String categoryId,
    @required String subCategoryId,
    @required bool mySubscriptionsOnly,
  }) async {
    return discoverCategoriesDetailsRepository.getSubCategoryGroups(
      pageNumber: pageNumber,
      pageSize: pageSize,
      enablePagination: enablePagination,
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      approvalListOnly: approvalListOnly,
      ownershipType: ownershipType,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      mySubscriptionsOnly: mySubscriptionsOnly,
    );
  }

  Future<ResponseWrapper<List<GroupResponse>>> getAllGroup(
      {@required String healthcareProviderId}) async {
    return groupAddRepository.getAllGroups(
        healthcareProviderId: healthcareProviderId);
  }

  Future<ResponseWrapper<List<CategoryAndSubResponse>>>
  getGroupCategory() async {
    return groupAddRepository.getGroupCategory();
  }

  Future<ResponseWrapper<AddGroupResponse>> addGroup({
    @required String name,
    @required String id,
    @required String description,
    @required String parentGroupId,
    @required List<String> subCategory,
    @required int privacyLevel,
    @required File file,
  }) async {
    return groupAddRepository.addGroup(
        subCategory: subCategory,
        privacyLevel: privacyLevel,
        parentGroupId: parentGroupId,
        file: file,
        description: description,
        name: name,
        id: id);
  }

  Future<ResponseWrapper<List<SubCategoryResponse>>> getGroupSubCategory(
      {@required String categoryId}) async {
    return groupAddRepository.getGroupSubCategory(categoryId: categoryId);
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoryAllBlogs({
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return discoverCategoriesSubCategoryAllBlogsRepository.getSubCategoryBlogs(
      subCategoryId: subCategoryId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<GroupResponse>>> getSubCategoryAllGroups({
    @required int pageNumber,
    @required int pageSize,
    @required bool enablePagination,
    @required String searchString,
    @required String healthcareProviderId,
    @required bool approvalListOnly,
    @required int ownershipType,
    @required String categoryId,
    @required String subCategoryId,
    @required bool mySubscriptionsOnly,
  }) async {
    return discoverCategoriesSubCategoryAllGroupsRepostory
        .getSubCategoryAllGroups(
      pageNumber: pageNumber,
      pageSize: pageSize,
      enablePagination: enablePagination,
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      approvalListOnly: approvalListOnly,
      ownershipType: ownershipType,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      mySubscriptionsOnly: mySubscriptionsOnly,
    );
  }

  Future<ResponseWrapper<List<QaaResponse>>> getSubCategoryAllQuestions({
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return discoverCategoriesSubCategoryAllQuestionsRepository
        .getSubCategoryAllQuestions(
      subCategoryId: subCategoryId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<DeleteGroupResponse>> deleteGroup({
    @required String groupId,
  }) async {
    return groupDetailsRepository.deleteGroup(
      groupId: groupId,
    );
  }

  Future<ResponseWrapper<GroupDetailsResponse>> getGroupDetails({
    @required String groupId,
  }) async {
    return groupDetailsRepository.getGroupDetails(
      groupId: groupId,
    );
  }

  Future<ResponseWrapper<JoinedGroupResponse>> joinInGroup({
    @required String groupId,
  }) async {
    return groupDetailsRepository.joinISelectedGroup(
      groupId: groupId,
    );
  }

  Future<ResponseWrapper<List<CategoryResponse>>>
  getMyInterestSubCategories() async {
    return discoverMyInterestRepository.getInterestSubCategories();
  }

  Future<ResponseWrapper<bool>> actionSubscrption(List<dynamic> param) async {
    return discoverMyInterestRepository.actionSubscrption(param);
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>>
  getMyInterestsSubCategoriesBlogs({@required String subCategoryId,
    @required int pageNumber,
    @required int pageSize}) async {
    return disconverMyInterestsSubCategorisRepositories.getSubCategoriesBlogs(
        pageNumber: pageNumber,
        pageSize: pageSize,
        subCategoryId: subCategoryId);
  }

  Future<ResponseWrapper<List<QaaResponse>>>
  getQaaInterestsSubCategoriesReomte({
    @required int pageNumber,
    @required int pageSize,
    @required String subCategoryId,
  }) async {
    return discoverMyInterestsSubCatergoriesQaaRepository
        .getInterestsSubCategoriesQaaRemote(
        pageNumber: pageNumber,
        pageSize: pageSize,
        subCategoryId: subCategoryId);
  }

  Future<ResponseWrapper<List<CategoryResponse>>>
  getMyInterestAtInterestRemoteData() async {
    return discoverMyInterestsAtInterestsRepository
        .getInterestsAtInterestsRemote();
  }

  //get_my_interests_sub_categories_blogs

  Future<ResponseWrapper<List<GetBlogsResponse>>> getGroupBlogs({
    @required String groupId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return groupDetailsBlogsRepository.getGroupBlogs(
      groupId: groupId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<QaaResponse>>> getGroupQuestions({
    @required String groupId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return groupDetailsQuestionsRepository.getGroupQuestions(
      groupId: groupId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>> getSearchTextBlogs({
    @required String groupId,
    @required String query,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return groupDetailsSearchBlogsRepository.getSearchTextBlogs(
      groupId: groupId,
      query: query,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<QaaResponse>>> getSearchTextQuestions({
    @required String groupId,
    @required String query,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return groupDetailsSearchQuestionsRepository.getSearchTextQuestions(
      groupId: groupId,
      query: query,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<CategoryResponse>>>
  getGroupSearchCategories() async {
    return groupDetailsSearchRepository.getCategories();
  }

  Future<ResponseWrapper<List<SubCategoryResponse>>>
  getGroupSearchSubCategories({
    @required String categoryId,
  }) async {
    return groupDetailsSearchRepository.getSubCategories(
      categoryId: categoryId,
    );
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>> getAdvancedSearchBlogs({
    @required int accountTypeId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required List<String> tagsId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return groupDetailsSearchBlogsRepository.getAdvancedSearchBlogs(
      accountTypeId: accountTypeId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      groupId: groupId,
      tagsId: tagsId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<QaaResponse>>> getAdvancedSearchQuestions({
    @required int accountTypeId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required List<String> tagsId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    return groupDetailsSearchQuestionsRepository.getAdvancedSearchQuestions(
      accountTypeId: accountTypeId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      groupId: groupId,
      tagsId: tagsId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<TagResponse>>>
  getGroupAdvanceSearchAllTags() async {
    return groupDetailsSearchRepository.getAddTags();
  }

  Future<ResponseWrapper<List<SpecificationResponse>>>
  getSearchProviderSpecification({@required String accountTypeId}) async {
    return searchProviderRepositories.getSpecification(
        accountTypeId: accountTypeId);
  }

  Future<ResponseWrapper<List<AccountTypesResponse>>>
  getSearchProviderAccountTypes() async {
    return searchProviderRepositories.getAccountTypes();
  }

  Future<ResponseWrapper<List<SubSpecificationResponse>>>
  getSearchProviderSubSpecification({@required String specificationId}) async {
    return searchProviderRepositories.getSubSpecification(
        specificationId: specificationId);
  }

  Future<ResponseWrapper<List<CountryResponse>>>
  getSearchProviderCountries() async {
    return searchProviderRepositories.getCountries();
  }

  Future<ResponseWrapper<List<CitiesByCountryResponse>>>
  getSearchProviderCitiesByCountry({
    @required String countryId,
  }) async {
    return searchProviderRepositories.getCitiesByCountry(
      countryId: countryId,
    );
  }

  Future<ResponseWrapper<List<AdvanceSearchResponse>>>
  getSeacrchProviderAdvanceSearch({
    String accountTypeId = "",
    String cityId = "",
    String countryId = "",
    int gender,
    String serviceId = "",
    List<String> specificationsIds = const <String>[],
    String subSpecificationId = "",
    int pageNumber,
    int pageSize,
  }) async {
    return searchProviderRepositories.setAdvanceSearchProvider(
        accountTypeId: accountTypeId,
        cityId: cityId,
        countryId: countryId,
        gender: gender,
        serviceId: serviceId,
        specificationsIds: specificationsIds,
        pageSize: pageSize,
        pageNumber: pageNumber,
        subSpecificationId: subSpecificationId);
  }

  Future<ResponseWrapper<List<AdvanceSearchResponse>>> getTextSearchProvider({
    int pageNumber,
    int pageSize,
    String query,
  }) async {
    return searchProviderRepositories.setSearchTextProvider(
        pageSize: pageSize, pageNumber: pageNumber, searchText: query);
  }

  Future<ResponseWrapper<List<ProviderServicesResponse>>>
  getProviderServices() async {
    return searchProviderRepositories.getProviderServices();
  }

  Future<ResponseWrapper<List<CategoryResponse>>>
  getGroupSearchMainCategories() async {
    return searchGroupRepositories.getMainCategory();
  }

  Future<ResponseWrapper<List<SubCategoryResponse>>>
  getGroupsSearchSubCategories({
    @required String categoryId,
  }) async {
    return searchGroupRepositories.getSubCategory(
      categoryId: categoryId,
    );
  }

  Future<ResponseWrapper<List<GroupResponse>>> getAdvanceSearchGroups({
    int pageNumber,
    int pageSize,
    String searchText,
    String categoryId,
    String subCategoryID,
    String userId,
  }) async {
    return searchGroupRepositories.getAdvanceSearchGroups(
        categoryId: categoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchText: searchText,
        subCategoryID: subCategoryID,
        userId: userId);
  }

  Future<ResponseWrapper<List<GroupResponse>>> getGroupsSearchText({
    int pageNumber,
    int pageSize,
    String searchText,
    String categoryId,
    String subCategoryID,
    String userId,
  }) async {
    return searchGroupRepositories.getGroupsSearchText(
      categoryId: categoryId,
      pageNumber: pageNumber,
      pageSize: pageSize,
      searchText: searchText,
      subCategoryID: subCategoryID,
      userId: userId,
    );
  }

  Future<ResponseWrapper<List<CategoryResponse>>>
  getBlogsSearchMainCategories() async {
    return searchBlogsRepository.getMainCategory();
  }

  Future<ResponseWrapper<List<SubCategoryResponse>>>
  getBlogsSearchSubCategories({
    @required String categoryId,
  }) async {
    return searchBlogsRepository.getSubCategory(
      categoryId: categoryId,
    );
  }

  Future<ResponseWrapper<List<TagResponse>>>
  getBlogsAdvanceSearchAllTags() async {
    return searchBlogsRepository.getAddTags();
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogsAdvanceSearch({
    String categoryId,
    String subCategoryId,
    int pageNumber,
    int pageSize,
    int accountTypeId,
    int orderByBlogs,
    List<String> tagsId,
    bool myFeed,
    String personId,
  }) async {
    return searchBlogsRepository.getBlogsAdvanceSearch(
        accountTypeId: accountTypeId,
        categoryId: categoryId,
        myFeed: myFeed,
        orderByBlogs: orderByBlogs,
        pageNumber: pageNumber,
        pageSize: pageSize,
        subCategoryId: subCategoryId,
        tagsId: tagsId,
        personId: personId);
  }

  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogsTextSearch(
      {int pageNumber, int pageSize, String query}) async {
    return searchBlogsRepository.getBlogsTextSearch(
        pageNumber: pageNumber, pageSize: pageSize, query: query);
  }

  Future<ResponseWrapper<List<CategoryResponse>>>
  getQuestionSearchMainCategories() async {
    return searchQuestionsRepository.getMainCategory();
  }

  Future<ResponseWrapper<List<SubCategoryResponse>>>
  getQuestionSearchSubCategories({
    @required String categoryId,
  }) async {
    return searchQuestionsRepository.getSubCategory(
      categoryId: categoryId,
    );
  }

  Future<ResponseWrapper<List<TagResponse>>>
  getQuestionAdvanceSearchAllTags() async {
    return searchQuestionsRepository.getAddTags();
  }

  Future<ResponseWrapper<List<QaaResponse>>> getQuestionAdvanceSearch({
    String categoryId,
    String subCategoryId,
    int pageNumber,
    int pageSize,
    int accountTypeId,
    int orderByQuestions,
    List<String> tagsId,
    bool myFeed,
    String personId,
  }) async {
    return searchQuestionsRepository.getQuestionsAdvanceSearch(
        accountTypeId: accountTypeId,
        categoryId: categoryId,
        orderByQuestions: orderByQuestions,
        pageNumber: pageNumber,
        pageSize: pageSize,
        subCategoryId: subCategoryId,
        tagsId: tagsId,
        personId: personId);
  }

  Future<ResponseWrapper<List<QaaResponse>>> getQuestionTextSearch(
      {int pageNumber, int pageSize, String query}) async {
    return searchQuestionsRepository.getQuestionsTextSearch(
        pageNumber: pageNumber, pageSize: pageSize, query: query);
  }

  Future<ResponseWrapper<List<ActiveSessionModel>>> getAllActiveSessions(
      {int pageNumber, int pageSize, String query}) async {
    return activeSessionRepository.getAllActiveSession();
  }

  Future<ResponseWrapper<bool>> sendReport(
      {String itemId, String message}) async {
    return activeSessionRepository.sendReport(itemId: itemId, message: message);
  }

  Future<ResponseWrapper<bool>> sendBlogsReport(
      {String blogID, String message}) async {
    return homeBlogRepository.sendBlogsReport(
        blogID: blogID, description: message);
  }

  Future<ResponseWrapper<bool>> sendReportAnswer(
      {@required String description, @required String commentId}) async {
    return questionDetailsRepository.sendReportAnswer(
        description: description, commentId: commentId);
  }

  Future<ResponseWrapper<bool>> sendCommentReport(
      {String description, String commentId}) async {
    return blogDetailsRepository.sendReport(
        description: description, commentId: commentId);
  }

  Future<ResponseWrapper<bool>> sendReplayReport(
      {String description, String commentId}) async {
    return blogReplayCommentItemRepository.sendReport(
        description: description, commentId: commentId);
  }

  Future<ResponseWrapper<bool>> questionSendReplayReport(
      {String description, String commentId}) async {
    return questionReplayDetailRepository.sendReport(
        description: description, commentId: commentId);
  }

  Future<ResponseWrapper<QuestionAnswerReplayResponse>> questionAddNewReplay(
      {@required String comment, @required String postId}) async {
    return questionReplayDetailRepository.questionSetNewReplay(
        comment: comment, postId: postId);
  }

  Future<ResponseWrapper<QuestionAnswerReplayResponse>>
  questionUpdateCommentReplay(
      {String message, String answerId, String replayCommentId}) async {
    return questionReplayDetailRepository.questionUpdateSelectedReplay(
        answerId: answerId, message: message, replayCommentId: replayCommentId);
  }

  Future<ResponseWrapper<bool>> questionDeleteCommentReplay(
      {String commentId}) async {
    return questionReplayDetailRepository.questionDeleteSelectedReplay(
        commentId: commentId);
  }

  Future<ResponseWrapper<QuestionAnswerResponse>> questionGetCommentReplay({
    @required String answerId,
    @required String questionId,
  }) async {
    return questionReplayDetailRepository.questionGetCommentReplay(
        answerId: answerId, questionId: questionId);
  }

  Future<ResponseWrapper<List<GroupResponse>>> getPenddingListAllGroup({
    int pageNumber,
    int pageSize,
    String searchText,
    String categoryId,
    String subCategoryID,
    String userId,
  }) async {
    return penddingListGroupRepository.getAllGroups(
        pageNumber: pageNumber, pageSize: pageSize, userId: userId);
  }

  Future<ResponseWrapper<bool>> removeFromPenddingGroup(
      {String userId, @required String groupId}) async {
    return penddingListGroupRepository.removeItemFromGroup(
        userId: userId, groupId: groupId);
  }

  Future<ResponseWrapper<bool>> acceptGroupInvitation(
      {String userId, @required String groupId}) async {
    return penddingListGroupRepository.acceptPendingGroupInvitation(
        userId: userId, groupId: groupId);
  }

  Future<ResponseWrapper<List<PatentsResponse>>> getAllPatents({
    String healthcareProviderId,
    int pageSize,
    int pageNumber,
  }) async {
    return penddingListPatentsRepository.getAllPatentsList(
        pageSize: pageSize,
        pageNumber: pageNumber,
        healthcareProviderId: healthcareProviderId);
  }

  Future<ResponseWrapper<bool>> acceptPatentsInovation({
    String patentsId,
  }) async {
    return penddingListPatentsRepository.acceptPendingPatentsInvitation(
        patentsId: patentsId);
  }

  Future<ResponseWrapper<bool>> rejectPatentsInovation({
    String patentsId,
  }) async {
    return penddingListPatentsRepository.rejectPatents(patentsId: patentsId);
  }

  Future<ResponseWrapper<List<DepartmentModel>>> getAllDepartment({
    @required int pageNumber,
    @required int pageSize,
    @required String healthCareProviderId,
  }) async =>
      await pendingListDepartmentRepository.getAllDepartment(
          healthCareProviderId: healthCareProviderId,
          pageSize: pageSize,
          pageNumber: pageNumber);

  Future<ResponseWrapper<JoinLeaveDepartmentModel>> joinLeaveDepartment({
    @required String departmentId,
    @required RequestType requestType,
  }) async =>
      await pendingListDepartmentRepository.joinOrLeaveDepartment(
        departmentId: departmentId,
        requestType: requestType,
      );

  Future<ResponseWrapper<DepartmentByIdModel>> getDepartmentById({
    @required String departmentId,
  }) async =>
      await pendingListDepartmentRepository.getDepartmentById(
          departmentId: departmentId);

  Future<ResponseWrapper<CommentBodyRespose>> addNewReplay(
      {@required String comment, @required String postId}) async {
    return blogReplayCommentItemRepository.setNewRaplay(
        comment: comment, postId: postId);
  }

  Future<ResponseWrapper<CommentBodyRespose>> updateCommentReplay(
      {@required String comment,
        @required String postId,
        String commentId}) async {
    return blogReplayCommentItemRepository.updateSeletedReplay(
        comment: comment, postId: postId, commentId: commentId);
  }

  Future<ResponseWrapper<bool>> deleteCommentReplay({String commentId}) async {
    return blogReplayCommentItemRepository.deleteSelectedReplay(
        commentId: commentId);
  }

  Future<ResponseWrapper<CommentResponse>> getCommentReplay({
    @required String commentId,
  }) async {
    return blogReplayCommentItemRepository.getCommentReplay(
      commentId: commentId,
    );
  }

  Future<ResponseWrapper<BriefProfileResponse>> getReplayBriefProfile(
      {String id}) async {
    return blogReplayItemRepository.getBriefProfile(id: id);
  }

  Future<ResponseWrapper<List<BlogsVoteResponse>>> getPostsVotes({
    @required int pageNumber,
    @required int pageSize,
    @required String itemId,
    @required int voteType,
    @required int itemType,
  }) async {
    return await blogsVoteRepository.getPostsVotes(
        pageNumber: pageNumber,
        pageSize: pageSize,
        voteType: voteType,
        itemId: itemId,
        itemType: itemType);
  }

  Future<ResponseWrapper<List<BlogsVoteResponse>>> getEmphasisVote({
    @required int pageNumber,
    @required int pageSize,
    @required String itemId,
    @required int voteType,
  }) async {
    return await blogsEmphasisVoteRepository.getEmphasesVotes(
        pageNumber: pageNumber,
        pageSize: pageSize,
        voteType: voteType,
        itemId: itemId);
  }

  Future<ResponseWrapper<BriefProfileResponse>> getVoteBriefProfile(
      {String id}) async {
    return blogsVoteItemRepository.getBriefProfile(id: id);
  }

  Future<ResponseWrapper<ProfileInfoResponse>> getProfileInfo(
      {String userId}) async {
    return profileRepository.getUserProfileInfo(userId: userId);
  }

  Future<ResponseWrapper<ProfileFollowListResponse>> getProfileFollowInfo(
      {String healthcareProvider}) async {
    return profileFollowListRepository.getProfileFollowListInfo(
        healthcareProviderId: healthcareProvider);
  }

  Future<ResponseWrapper<List<SubSpecificationResponse>>>
  getProfileSubSpecification({@required String specificationId}) async {
    return profileRepository.getSubSpecification(
        specificationId: specificationId);
  }

  Future<ResponseWrapper<List<SpecificationResponse>>> getProfileSpecification(
      {@required String accountTypeId}) async {
    return profileRepository.getSpecification(accountTypeId: accountTypeId);
  }

  Future<ResponseWrapper<bool>> setSocailMedialLink({
    String facebook,
    String twiter,
    String instagram,
    String telegram,
    String youtube,
    String whatsApp,
    String linkedIn,
  }) async {
    return profileRepository.updateSocailMediaLink(
      facebook: facebook,
      twiter: twiter,
      instagram: instagram,
      telegram: telegram,
      youtube: youtube,
      whatsApp: whatsApp,
      linkedIn: linkedIn,
    );
  }

  Future<ResponseWrapper<ContactResponse>> updateContactInfo(
      {String personId,
      String cityId,
      String phone,
      String workPhone,
      String mobile,
      String address}) async {
    return profileRepository.updateContactInfo(
        personId: personId,
        cityId: cityId,
        phone: phone,
        workPhone: workPhone,
        mobile: mobile,
        address: address);
  }

  Future<ResponseWrapper<List<CountryResponse>>> getProfileCountry() async {
    return profileRepository.getCountries();
  }

  Future<ResponseWrapper<List<QualificationsResponse>>> getProfileLecture({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    return profileProviderLecturesRepository.getUserProfileLecture(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<NewLecturesResponse>> setNewLectures({
    String title,
    String description,
    List<ImageType> file,
  }) async {
    return profileProviderLecturesRepository.setNewLectures(
      title: title,
      description: description,
      file: file,
    );
  }

  Future<ResponseWrapper<NewLecturesResponse>> updateLectures({
    String title,
    String description,
    List<ImageType> file,
    String itemId,
    List<String> removedFile,
  }) async {
    return profileProviderLecturesRepository.updateSelectedLectures(
        title: title,
        description: description,
        file: file,
        itemID: itemId,
        removedFile: removedFile);
  }

  Future<ResponseWrapper<bool>> deleteSelectedLectures({
    String itemId,
  }) async {
    return profileProviderLecturesRepository.deleteSelectedLectures(
        itemId: itemId);
  }

  Future<ResponseWrapper<NewProjectResponse>> setNewProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
    String description,
  }) async {
    return profileProviderProjectsRepository.addNewProject(
        endDate: endDate,
        file: file,
        link: link,
        name: name,
        startDate: startDate,
        description: description);
  }

  Future<ResponseWrapper<NewProjectResponse>> updateSelectedProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
    String description,
    String id,
    List<String> removedfiles,
  }) async {
    return profileProviderProjectsRepository.updateSelectedProject(
      endDate: endDate,
      file: file,
      link: link,
      name: name,
      startDate: startDate,
      description: description,
      id: id,
      removedfiles: removedfiles,
    );
  }

  Future<ResponseWrapper<bool>> deleteSeletecteProject({
    String itemId,
  }) async {
    return profileProviderProjectsRepository.deleteSeletecteProject(
        itemId: itemId);
  }

  Future<ResponseWrapper<List<ProjectsResponse>>> getProfilePrjects({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    return profileProviderProjectsRepository.getUserProfileProjects(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<LicensesResponse>>> getProfileLicense({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    return profileProviderRepository.getUserProfileLicenses(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<NewEducationResponse>> updateEducations({
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
  }) async {
    ResponseWrapper<NewEducationResponse> val =
        await profileProviderEducationsRepository.updateSelectedEducations(
      description: description,
      endDate: endDate,
      fieldOfStudy: fieldOfStudy,
      file: file,
      grade: grade,
      link: link,
      school: school,
      startDate: startDate,
      id: id,
      removedFiles: removedFiles,
    );
    return val;
  }

  Future<ResponseWrapper<NewEducationResponse>> addNewEducation({
    String grade,
    String school,
    String link,
    String startDate,
    String endDate,
    String fieldOfStudy,
    String description,
    List<ImageType> file,
  }) async {
    ResponseWrapper<NewEducationResponse> val =
        await profileProviderEducationsRepository.addNewEducation(
      description: description,
      endDate: endDate,
      fieldOfStudy: fieldOfStudy,
      file: file,
      grade: grade,
      link: link,
      school: school,
      startDate: startDate,
    );
    return val;
  }

  Future<ResponseWrapper<NewExperianceResponse>> updateExperiance({
    String name,
    String startDate,
    String endDate,
    String organization,
    String url,
    List<ImageType> file,
    String description,
    String id,
    List<String> removedFiles,
  }) async {
    ResponseWrapper<NewExperianceResponse> val =
        await profileProviderExperianceRepository.updateSelectedExperiance(
      description: description,
      endDate: endDate,
      file: file,
      url: url,
      name: name,
      organization: organization,
      startDate: startDate,
      id: id,
      removedfiles: removedFiles,
    );
    return val;
  }

  Future<ResponseWrapper<NewExperianceResponse>> addNewExperiance({
    String name,
    String startDate,
    String endDate,
    String organization,
    String url,
    List<ImageType> file,
    String description,
  }) async {
    ResponseWrapper<NewExperianceResponse> val =
        await profileProviderExperianceRepository.addNewExperiance(
            description: description,
            endDate: endDate,
            file: file,
            url: url,
            name: name,
            organization: organization,
            startDate: startDate);
    return val;
  }

  Future<ResponseWrapper<NewCertificateResponse>> addNewCertificate({
    @required String name,
    @required String issueDate,
    @required String expirationDate,
    @required String organization,
    @required String url,
    @required File file,
  }) async {
    return profileProviderCertificateRepository.addNewCertificate(
        file: file,
        expirationDate: expirationDate,
        issueDate: issueDate,
        name: name,
        organization: organization,
        url: url);
  }

  Future<ResponseWrapper<PersonalProfilePhotos>> setOrDeleteImage(
      {@required File image, @required bool isDeleteImage}) async {
    return profileRepository.setOrRemoveImage(
        image: image, isDeleteImage: isDeleteImage);
  }

  Future<ResponseWrapper<List<dynamic>>> setProfileProviderGeneralInfo({
    String firstName,
    String lastName,
    int gender,
    String birthdate,
    String summary,
    String inTouchPointName,
    String subSpecificationId,
    String organizationTypeId,
  }) async {
    return profileRepository.setProfileProviderGeneralInfo(
      birthdate: birthdate,
      firstName: firstName,
      gender: gender,
      inTouchPointName: inTouchPointName,
      lastName: lastName,
      organizationTypeId: organizationTypeId,
      subSpecificationId: subSpecificationId,
      summary: summary,
    );
  }

  Future<ResponseWrapper<PersonProfileBasicInfoResponse>>
  setProfileNormalUserGeneralInfo({
    String firstName,
    String lastName,
    int gender,
    String birthdate,
    String summary,
  }) async {
    return profileRepository.setProfileNormalUserGeneralInfo(
      birthdate: birthdate,
      firstName: firstName,
      gender: gender,
      lastName: lastName,
      summary: summary,
    );
  }

  Future<ResponseWrapper<bool>> deleteLicense({
    @required String itemId,
  }) async {
    print("the current is 1");

    return profileProviderRepository.deleteSelectedLicenses(itemId: itemId);
  }

  Future<ResponseWrapper<bool>> deleteExperiance({
    @required String itemId,
  }) async {
    return profileProviderExperianceRepository.deleteSelectedExperiance(
        itemId: itemId);
  }

  Future<ResponseWrapper<bool>> deleteCertificate({
    @required String itemId,
  }) async {
    return profileProviderCertificateRepository.deleteSelectedCertificate(
        itemId: itemId);
  }

  Future<ResponseWrapper<bool>> deleteEducation({
    @required String itemId,
  }) async {
    return profileProviderEducationsRepository.deleteSelectedEducation(
        itemId: itemId);
  }

  Future<ResponseWrapper<NewCertificateResponse>> updateCertificate({
    @required String name,
    @required String issueDate,
    @required String expirationDate,
    @required String organization,
    @required String url,
    @required File file,
    @required String id,
    @required List<String> removedfiles,
  }) async {
    return profileProviderCertificateRepository.updateSelectedCertificate(
      file: file,
      expirationDate: expirationDate,
      issueDate: issueDate,
      name: name,
      organization: organization,
      url: url,
      id: id,
      removedfiles: removedfiles,
    );
  }

  Future<ResponseWrapper<NewLicenseResponse>> updateProfileLicense(
      {String title, String description, File file, String id}) async {
    return profileProviderRepository.updateSelectedLicense(
        description: description, file: file, title: title, id: id);
  }

  Future<ResponseWrapper<NewLicenseResponse>> setProfileLicense(
      {String title, String description, File file}) async {
    return profileProviderRepository.addNewLicense(
        description: description, file: file, title: title);
  }

  Future<ResponseWrapper<List<CertificateResponse>>> getProfileCertificate({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    return profileProviderCertificateRepository.getUserProfileCertificate(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<ExperianceResponse>>> getProfileExperiance({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    return profileProviderExperianceRepository.getUserProfileExperiance(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<EducationsResponse>>> getProfileEducation({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    return profileProviderEducationsRepository.getUserProfileEducation(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<List<CoursesResponse>>> getProfileCourses({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    return profileProviderCoursesRepository.getUeseProfileCourses(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<NewCourseResponse>> setNewCourse({
    String name,
    String place,
    String date,
    List<ImageType> file,
  }) async {
    return profileProviderCoursesRepository.addNewCourse(
      date: date,
      file: file,
      place: place,
      name: name,
    );
  }

  Future<ResponseWrapper<NewCourseResponse>> updateCourse({
    String name,
    String place,
    String date,
    List<ImageType> file,
    List<String> removedfiles,
    String id,
  }) async {
    return profileProviderCoursesRepository.updateSelectedCourse(
      date: date,
      file: file,
      place: place,
      name: name,
      removedfiles: removedfiles,
      id: id,
    );
  }

  Future<ResponseWrapper<bool>> deleteCourse({
    String itemId,
  }) async {
    return profileProviderCoursesRepository.deleteSelectedCourse(
        itemId: itemId);
  }

  Future<ResponseWrapper<List<SkillsResponse>>> getProfileSkills({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
    bool enablePagination = true,
  }) async {
    return profileProviderSkillRepository.getUeseProfileSkills(
      searchString: searchString,
      healthcareProviderId: healthcareProviderId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<NewSkillResponse>> setNewSkill({
    String name,
    String startDate,
    String endDate,
    String description,
    String itemId,
  }) async {
    return profileProviderSkillRepository.setNewSkill(
        description: description,
        endDate: endDate,
        name: name,
        startDate: startDate,
        itemId: itemId);
  }

  Future<ResponseWrapper<bool>> deleteSelectedSkill({
    String itemID,
  }) async {
    return profileProviderSkillRepository.deleteSelectedSkill(itemId: itemID);
  }

  Future<ResponseWrapper<List<LanguageResponse>>> getAllLanguage({
    String searchString,
    int pageNumber,
    int pageSize,
    bool enablePagination,
    String healthcareProviderId,
  }) async {
    return profileProvierLanguageRepository.getAllLanguage(
        searchString: searchString,
        pageNumber: pageNumber,
        pageSize: pageSize,
        enablePagination: enablePagination,
        healthcareProviderId: healthcareProviderId);
  }

  Future<ResponseWrapper<bool>> deleteSelectedLanguage({
    String itemId,
  }) async {
    return profileProvierLanguageRepository.deleteSelectedItem(itemId: itemId);
  }

  Future<ResponseWrapper<bool>> addNewLanguage({
    int languageLevel,
    String languageId,
  }) async {
    return profileProvierLanguageRepository.addNewLanguage(
      languageId: languageId,
      languageLevel: languageLevel,
    );
  }

  Future<ResponseWrapper<AddQuestionResponse>> addQuestion({
    @required String id,
    @required List<String> subCategoryIds,
    @required String groupId,
    @required String title,
    @required String body,
    @required bool viewToHealthcareProvidersOnly,
    @required bool askAnonymously,
    @required List<String> questionTags,
    @required List<FileResponse> files,
    @required List<String> removedFiles,
  }) async {
    return addQuestionRepository.addQuestion(
      id: id,
      subCategoryIds: subCategoryIds,
      groupId: groupId,
      title: title,
      body: body,
      viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
      askAnonymously: askAnonymously,
      questionTags: questionTags,
      files: files,
      removedFiles: removedFiles,
    );
  }

  Future<ResponseWrapper<AddBlogResponse>> addBlog({
    @required String id,
    @required String subCategoryId,
    @required String groupId,
    @required String title,
    @required String body,
    @required int blogType,
    @required bool viewToHealthcareProvidersOnly,
    @required bool publishByCreator,
    @required List<String> blogTags,
    @required List<FileResponse> files,
    @required String externalFileUrl,
    @required int externalFileType,
    @required List<String> removedFiles,
  }) async {
    return addBlogRepository.addBlog(
      id: id,
      subCategoryId: subCategoryId,
      groupId: groupId,
      title: title,
      body: body,
      blogType: blogType,
      viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
      publishByCreator: publishByCreator,
      blogTags: blogTags,
      files: files,
      externalFileUrl: externalFileUrl,
      externalFileType: externalFileType,
      removedFiles: removedFiles,
    );
  }

  Future<ResponseWrapper<ActionAnswerResponse>> actionAnswer({
    @required String id,
    @required String questionId,
    @required String body,
    @required List<FileResponse> files,
    @required List<String> removedFiles,
  }) async {
    return questionDetailsRepository.actionAnswer(
      id: id,
      questionId: questionId,
      body: body,
      files: files,
      removedFiles: removedFiles,
    );
  }

  Future<ResponseWrapper<SocialResponse>> validateFaceBookToken(
      {@required String token}) async {
    return await registrationSocailRepository.facebookValidationToken(
        token: token);
  }

  Future<ResponseWrapper<LoginResponse>> sendFaceBookLogin({
    @required String token,
    @required String email,
    @required String model,
    @required String product,
    @required String brand,
    @required String ip,
    @required int osApiLevel,
    @required bool rememberMe,
    @required String fcmId,
  }) async {
    return await registrationSocailRepository.faceBookLogin(
        token: token,
        brand: brand,
        email: email,
        fcmId: fcmId,
        ip: ip,
        model: model,
        osApiLevel: osApiLevel,
        product: product,
        rememberMe: rememberMe);
  }

  Future<ResponseWrapper<SocialResponse>> validateGoogleToken(
      {@required String token}) async {
    return await registrationSocailRepository.googleValidationToken(
        token: token);
  }

  Future<ResponseWrapper<LoginResponse>> sendGoogleLogin({
    @required String token,
    @required String email,
    @required String model,
    @required String product,
    @required String brand,
    @required String ip,
    @required int osApiLevel,
    @required bool rememberMe,
    @required String fcmId,
  }) async {
    return await registrationSocailRepository.googleLogin(
        token: token,
        brand: brand,
        email: email,
        fcmId: fcmId,
        ip: ip,
        model: model,
        osApiLevel: osApiLevel,
        product: product,
        rememberMe: rememberMe);
  }

  Future<ResponseWrapper<NotificationResponseTest>> getNotificationInfo({
    String userId,
    int pageNumber,
    int pageSize,
    bool enablePagenation,
    bool getReadOnly,
    bool getUnReadOnly,
  }) async {
    return notificationRepository.getUserNotification(
      userId: userId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  Future<ResponseWrapper<bool>> readNotificationInfo({
    List<String> notificationId,
  }) async {
    return notificationRepository.postReadNotification(
      notificationId: notificationId,
    );
  }

  Future<ResponseWrapper<bool>> readAllNotifications({
    String personId,
  }) async {
    return notificationRepository.readAllNotifications(personId: personId);
  }

  Future<ResponseWrapper<String>> getTermsInfo({
    int termsOrPolicy,
  }) async {
    return termsAndConditionsRepository.getUserTerms(
        termsOrPolicy: termsOrPolicy);
  }

  Future<ResponseWrapper<LatestVersionResponse>> getLatestVersion() async {
    return latestVersionRepository.getVersion();
  }
}
