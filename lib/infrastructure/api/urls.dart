class Urls {
  ///https://mentalhealthintouch.com/
  // static const String BASE_URL = "https://Arachnoit.com/";
  static const String BASE_URL = "https://mentalhealthintouch.com/";
  static const String LOGIN_USER =
      BASE_URL + "Authentication/api/Account/login";
  static const String GET_TERMS_AND_CONDITION =
      BASE_URL + 'MobileWebApi/api/App/GetPrivacyPolicyAndTerms';
  static const String GET_PROFILE_FOLLOW_LIST =
      "MobileWebApi/api/Profile/GetFollowList";
  static const String LOGOUT_USER =
      BASE_URL + "Authentication/api/Account/Logout";
  static const String COUNTRIES =
      BASE_URL + "MobileWebApi/api/Registration/GetCountries";
  static const String CITIES_BY_COUNTRY =
      BASE_URL + "MobileWebApi/api/Registration/GetCitiesByCountry";
  static const String SPECIFICATION =
      BASE_URL + "MobileWebApi/api/Registration/GetSpecification";
  static const String SUB_SPECIFICSTION =
      BASE_URL + "MobileWebApi/api/Registration/GetSubSpecification";
  static const String EMAIL_AVAILABLE =
      BASE_URL + "MobileWebApi/api/Registration/IsEmailAvailable";
  static const String PHONE_NUMBER_AVAILABLE =
      BASE_URL + "MobileWebApi/api/Registration/IsPhoneNumberAvailable";
  static const String TOUCH_POINT_NAME_AVAILABLE =
      BASE_URL + "MobileWebApi/api/Registration/IsTouchPointNameAvailable";
  static const String REGISTER_HEALTH_CARE_PROVIDER =
      BASE_URL + "MobileWebApi/api/Registration/RegisterHealthcareProvider";
  static const String REGISTER_NORMAL_USER =
      BASE_URL + "MobileWebApi/api/Registration/RegisterNormalUser";
  static const String ACCOUNT_TYPES =
      BASE_URL + "MobileWebApi/api/Registration/GetAccountTypes";
  static const String CONFIRM_REGISTRATION =
      BASE_URL + "MobileWebApi/api/Registration/ConfirmRegisteration";
  static const String SEND_ACTIVATION_CODE =
      BASE_URL + "MobileWebApi/api/Registration/SendActivationCode";
  static const String SET_LANGUAGE =
      BASE_URL + "MobileWebApi/api/Profile/SetLanguage";
  static const String RESET_PASSWORD =
      BASE_URL + "Authentication/api/Account/ResetPassword";
  static const String REQUEST_RESET_PASSWORD =
      BASE_URL + "Authentication/api/Account/RequestResetPassword";
  static const String CHANGE_PASSWORD =
      BASE_URL + "Authentication/api/Account/ChangePassword";
  static const String GET_BLOGS = BASE_URL + "SocialWebAPI/api/Blog/GetBlogs";
  static const String GET_BLOG_DETAILS =
      BASE_URL + "SocialWebAPI/api/Blog/GetBlogInformation";
  static const String GET_QUESTION_DETAILS =
      BASE_URL + "QAAWebAPI/api/Question/GetQuestionInformation";
  static const String GET_QAAS =
      BASE_URL + "QAAWebAPI/api/Question/GetQuestions";
  static const String GET_QUESTION_FILES =
      BASE_URL + "QAAWebAPI/api/Question/GetQuestionFiles";
  static const String SET_USEFUL_VOTE_FOR_QUESTION =
      BASE_URL + "QAAWebAPI/api/Question/SetUsefulVoteForQuestion";
  static const String SET_EMPHASIS_VOTE_FOR_ANSWER =
      BASE_URL + "QAAWebAPI/api/Answer/SetEmphasisVoteForAnswer";
  static const String SET_USEFUL_VOTE_FOR_ANSWER =
      BASE_URL + "QAAWebAPI/api/Answer/SetUsefulVoteForAnswer";
  static const String GET_CATEGORIES =
      BASE_URL + "QAAWebAPI/api/Category/GetCategoriesSubCategoriesWithStats";
  static const String GET_SEARCH_CATEGORIES =
      BASE_URL + "QAAWebAPI/api/Category/GetCategories";
  static const String GET_SEARCH_SUB_CATEGORIES =
      BASE_URL + "QAAWebAPI/api/Category/GetSubCategories";
  static const String USER_MANUAL =
      BASE_URL + "/ProfilesDirectory/usermanual/manual.pdf";
  static const String SPECIFICATION_PLATFORM =
      BASE_URL + "/ProfilesDirectory/usermanual/specification.pdf";
  static const String SET_USEFUL_VOTE_FOR_BLOG =
      BASE_URL + "SocialWebAPI/api/Blog/SetUsefulVoteForBlog";
  static const String SET_EMPHASIS_VOTE_FOR_BLOG =
      BASE_URL + "SocialWebAPI/api/Blog/SetEmphasisVoteForBlog";
  static const String SET_USEFUL_VOTE_FOR_COMMENT =
      BASE_URL + "SocialWebAPI/api/Comment/SetUsefulVoteForComment";
  static const String GET_GROUPS =
      BASE_URL + "MobileWebAPI/api/Group/GetGroups";
  static const String GET_GROUP_DETAILS =
      BASE_URL + "MobileWebAPI/api/Group/GetGroup";
  static const String GET_NEWEST_HEALTH_CARE_PROVIDERS =
      BASE_URL + "MobileWebAPI/api/Search/GetNewestHealthcareProviders";
  static const String GET_FAVORITE_HEALTH_CARE_PROVIDERS =
      BASE_URL + "MobileWebAPI/api/Profile/GetFavoriteList";
  static const String SET_FAVORITE_HEALTH_CARE_PROVIDER =
      BASE_URL + "MobileWebAPI/api/Profile/SetFavoriteList";
  static const String PROVIDER_PROFILE_LINK = BASE_URL + "Profile/Index/";
  static const String GET_QUESTION_TAGS =
      BASE_URL + "QAAWebAPI/api/Question/GetQuestionTags";
  static const String AdVANCE_SEARCH_PROVIDER =
      BASE_URL + "MobileWebAPI/api/Search/AdvancedSearch";
  static const String TEXT_SEARCH_PROVIDER =
      BASE_URL + "MobileWebApi/api/Search/TextSearch";
  static const String PROVIDER_SERVICES_RESPONSE =
      BASE_URL + "MobileWebApi/api/Profile/GetHealthcareProviderServices";
  static const String GET_PERSON_LOCATIONS =
      BASE_URL + "Authentication/api/Account/GetPersonLocations";
  static const String ADD_REPORT =
      BASE_URL + "MobileWebApi/api/Report/AddReport";
  static const String SET_GROUP_INOVATION =
      BASE_URL + "MobileWebApi/api/Group/SetGroupInvitation";
  static const String GET_PATENTS =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetPatents";
  static const String SET_PATENT_INIVATION =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/SetPatentInvitation";
  static const String JOIN_IN_GROUP =
      BASE_URL + 'MobileWebApi/api/Group/JoinInGroup';
  static const String ACTION_SUBSCRIPTION =
      BASE_URL + 'MobileWebApi/api/Subscription/ActionSubscription';
  static const String GET_BRIEF_PROFILE =
      BASE_URL + 'MobileWebApi/api/Profile/GetBriefProfile';
  static const String ACTION_COMMENT =
      BASE_URL + "SocialWebAPI/api/Comment/ActionComment";
  static const String Question_ACTION_COMMENT =
      BASE_URL + "QAAWebAPI/api/Comment/ActionComment";
  static const String REMOVE_COMMENT =
      BASE_URL + "SocialWebAPI/api/Comment/RemoveComment";
  static const String REMOVE_ANSWER =
      BASE_URL + "QAAWebAPI/api/Answer/RemoveAnswer";
  static const String Question_REMOVE_COMMENT =
      BASE_URL + "QAAWebAPI/api/Comment/RemoveComment";
  static const String ACTION_REPLAY =
      BASE_URL + "SocialWebAPI/api/Reply/ActionReply";
  static const String Question_ACTION_REPLAY =
      BASE_URL + "SocialWebAPI/api/Answer/ActionAnswer";
  static const String Remove_Replay =
      BASE_URL + "SocialWebAPI/api/Reply/RemoveReply";
  static const String GET_DEPARTMENT =
      BASE_URL + "MobileWebApi/api/BusinessAdvancedProfile/GetDepartments";
  static const String SET_DEPARTMENT_INVITATION = BASE_URL +
      "MobileWebApi/api/BusinessAdvancedProfile/SetDepartmentInvitation";
  static const String GET_DEPARTMENT_BY_ID =
      BASE_URL + "MobileWebApi/api/BusinessAdvancedProfile/GetDepartment";
  static const String GET_COMMENT_INFO =
      BASE_URL + "SocialWebAPI/api/Comment/GetCommentInfo";
  static const String Question_GET_COMMENT_INFO =
      BASE_URL + "QAAWebAPI/api/Answer/GetAnswerInformation";
  static const String GET_VOTES = BASE_URL + "QAAWebAPI/api/Question/GetVotes";
  static const String SHARE_BLOGS = BASE_URL + "app/feed/blog/";
  static const String GET_PROFILE_INFO =
      BASE_URL + "MobileWebApi/api/Profile/GetProfileInfo";
  static const String GET_LECTURE =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetLectures";
  static const String GET_PROJECTS =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetProjects";
  static const String GET_LICENSES =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetLicenses";
  static const String GET_CERTIFICATE =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetCertificates";
  static const String GET_EXPERIANCE =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetExperiences";
  static const String GET_EDUCATION =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetEducations";
  static const String GET_COURSES =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetCourses";
  static const String GET_SKILLS =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetSkills";
  static const String GET_LANGUAGE =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetLanguageSkills";
  static const String ADD_QUESTION =
      BASE_URL + "QAAWebAPI/api/Question/ActionQuestion";
  static const String ADD_BLOG = BASE_URL + "SocialWebApi/api/Blog/ActionBlog";
  static const String ADD_ANSWER =
      BASE_URL + "QAAWebAPI/api/Answer/ActionAnswer";
  static const String ADD_LICENSES =
      "MobileWebApi/api/AdvancedProfile/SetLicense";
  static const String ADD_CERTIFICATE =
      "MobileWebApi/api/AdvancedProfile/SetCertificate";
  static const String ADD_EXPERIANCE =
      "MobileWebApi/api/AdvancedProfile/SetExperience";
  static const String ADD_EDUCATION =
      "MobileWebApi/api/AdvancedProfile/SetEducation";
  static const String Get_Group_Members =
      "MobileWebApi/api/Search/GetGroupMembers";
  static const String Remove_Members_From_Group =
      "MobileWebApi/api/Group/RemoveMembers";
  static const String Invite_Member_To_Group =
      "MobileWebApi/api/Group/SetGroupInvitation";
  static const String Group_Permission =
      "MobileWebApi/api/Group/GetPermissions";
  static const String Add_Group = "MobileWebApi/api/Group/SetGroup";
  static const String Delete_Group = "MobileWebApi/api/Group/RemoveGroup";
  static const String GET_LANGUAGE_SKILLS =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetLanguageSkills";
  static const String GET_LANGUAGE_SKILLS_BY_ID =
      BASE_URL + "MobileWebApi/api/AdvancedProfile/GetHcpLanguageSkill";
  static const String DELETE_CERTIFICATE =
      "MobileWebApi/api/AdvancedProfile/RemoveCertificate";
  static const String DELETE_EDUCATION =
      "MobileWebApi/api/AdvancedProfile/RemoveEducation";
  static const String DELETE_EXPERIANCE =
      "MobileWebApi/api/AdvancedProfile/RemoveExperience";
  static const String DELETE_LICENSE =
      "MobileWebApi/api/AdvancedProfile/RemoveLicense";
  static const String SET_CONTACT_INFO =
      "MobileWebApi/api/Profile/SetContatInfo";
  static const String SET_SOCIAL_MEDIA_LINK =
      "MobileWebApi/api/Profile/SetSocialMediaLinks";
  static const String SET_PROFILE_PHOTOS =
      "MobileWebApi/api/Profile/SetPersonalProfilePhoto";
  static const String SET_LICENSE =
      "MobileWebApi/api/AdvancedProfile/SetLicense";
  static const String DELETE_LANGUAGE =
      "MobileWebApi/api/AdvancedProfile/RemoveLanguageSkill";
  static const String SET_LANGUAGE_SKILL =
      "MobileWebApi/api/AdvancedProfile/SetLanguageSkill";
  static const String SET_LECTURES =
      "MobileWebApi/api/AdvancedProfile/SetLecture";
  static const String DELETE_LECTURES =
      "MobileWebApi/api/AdvancedProfile/RemoveLecture";
  static const String Set_Course = "MobileWebApi/api/AdvancedProfile/SetCourse";
  static const String Delete_Course =
      "MobileWebApi/api/AdvancedProfile/RemoveCourse";
  static const String SET_PROJECT =
      "MobileWebApi/api/AdvancedProfile/SetProject";
  static const String DELETE_PROJECT =
      "MobileWebApi/api/AdvancedProfile/RemoveProject";
  static const String SET_SKILL = "MobileWebApi/api/AdvancedProfile/SetSkill";
  static const String DELETE_SKILL =
      "MobileWebApi/api/AdvancedProfile/RemoveSkill";
  static const String EDIT_PROVIDER_GENERAL_INFO =
      "MobileWebApi/api/Profile/SetHealthcareProviderGeneralInfoForm";
  static const String EDIT_GENERAL_INFO =
      "MobileWebApi/api/Profile/SetPersonProfileBasicInfo";
  static const String Set_Follow_Health_Care_Provider =
      "MobileWebApi/api/Profile/SetFollowList";
  static const String USER_SHARE_BLOGS =
      BASE_URL + "HealthcareProvider/Profile/";
  static const String SHARE_HOME_BLOGS = BASE_URL + "app/feed/blog/";
  static const String SHARE_HOME_QAA = BASE_URL + "app/feed/question/";
  static const String DELETE_BLOG =
      BASE_URL + "SocialWebAPI/api/Blog/RemoveBlog";
  static const String DELETE_QUESTION =
      BASE_URL + "QAAWebAPI/api/Question/RemoveQuestion";
  static const String VALIDATE_FACEBOOK_ACCESS_TOKEN =
      BASE_URL + "Authentication/api/Account/ValidateFaceBookAccessToken";
  static const String LOGIN_WITH_FACEBOOK =
      BASE_URL + "Authentication/api/Account/LoginWithFaceBookTokenAsync";
  static const String VALIDATE_GOOGLE_ACCESS_TOKEN =
      BASE_URL + "Authentication/api/Account/ValidateGoogleAccessToken";
  static const String LOGIN_WITH_GOOGLE =
      BASE_URL + "Authentication/api/Account/LoginWithGoogleTokenAsync";
  static const String Get_USER_NOTIFICATION =
      BASE_URL + "MobileWebApi/api/Profile/GetPersonNotificationAsync";
  static const String READ_USER_NOTIFICATION =
      BASE_URL + "MobileWebApi/api/Profile/ReadNotificationAsync";
  static const String READ_ALL_PERSON_NOTIFICATIONS =
      BASE_URL + "MobileWebApi/api/Profile/ReadAllPersonNotifications";
  static const String GET_LATEST_VERSION_APK =
      BASE_URL + "MobileWebApi/api/App/GetLatestApkVersions";
}