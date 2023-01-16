import 'package:arachnoit/application/latest_version/latest_version_bloc.dart';
import 'package:arachnoit/application/profile_actions_bloc.dart';
import 'package:arachnoit/application/profile_follow_list/profile_follow_list_bloc.dart';
import 'package:arachnoit/infrastructure/notification/notification_repository.dart';
import 'package:arachnoit/infrastructure/profile/call/set_normal_user_general_info.dart';
import 'package:arachnoit/infrastructure/profile/call/set_profile_image.dart';
import 'package:arachnoit/infrastructure/profile/call/set_social_media_link.dart';
import 'package:arachnoit/infrastructure/profile_action/caller/profile_action_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/profile_action/profile_action_repository.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/call/get_profile_follow_list_info.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/profile_follow_list_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/call/delete_course.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/call/delete_language.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/call/set_new_language.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/call/delete_lectures.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/call/update_lectures.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/call/delete_licenses.dart';
import 'dart:io';
import 'package:arachnoit/application/active_session/active_session_bloc.dart';
import 'package:arachnoit/application/add_blog/add_blog_bloc.dart';
import 'package:arachnoit/application/add_question/add_question_bloc.dart';
import 'package:arachnoit/application/discover_my_interests_add_interests/discover_my_interests_add_interests_bloc.dart';
import 'package:arachnoit/application/group_add/group_add_bloc.dart';
import 'package:arachnoit/application/group_details_search_bloc_tags/group_details_search_bloc_tags_bloc.dart';
import 'package:arachnoit/application/group_members_providers/group_members/group_members_bloc.dart';
import 'package:arachnoit/application/pending_list_department/pending_list_department_bloc.dart';
import 'package:arachnoit/application/profile_provider_courses/profile_provider_courses_bloc.dart';
import 'package:arachnoit/application/profile_provider_education/profile_provider_education_bloc.dart';
import 'package:arachnoit/application/profile_provider_language/profile_provider_language_bloc.dart';
import 'package:arachnoit/application/profile_provider_skills/profile_provider_skills_bloc.dart';
import 'package:arachnoit/application/search/search_bloc.dart';
import 'package:arachnoit/application/search_blogs/search_blogs_bloc.dart';
import 'package:arachnoit/application/search_group/search_group_bloc.dart';
import 'package:arachnoit/application/search_provider/search_provider_bloc.dart';
import 'package:arachnoit/application/search_question/search_question_bloc.dart';
import 'package:arachnoit/infrastructure/add_blog/add_blog_repository.dart';
import 'package:arachnoit/infrastructure/add_questions/add_question_repository.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/add_question_remote_provider.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/get_questions_main_category.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/get_questions_sub_category.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/get_questions_tags.dart';
import 'package:arachnoit/infrastructure/blog_details/caller/delete_comment.dart';
import 'package:arachnoit/infrastructure/blog_details/caller/report_comment.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/caller/add_replay.dart';
import 'package:arachnoit/infrastructure/group_add/caller/group_add_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/group_add/group_add_repository.dart';
import 'package:arachnoit/infrastructure/group_details_search/caller/get_group_advance_search_add_tags.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/caller/get_group_members_local_data_provider.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/caller/get_group_members_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/get_group_members_repository.dart';
import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/get_department_by_id.dart';
import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/join_leave_department.dart';
import 'package:arachnoit/infrastructure/pending_list_department/repository/pending_list_department_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/call/delete_certificate.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/call/update_educations.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/profile_provider_educations_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/call/delete_experiance.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/call/get_profile_language.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/profile_provider_lectures_repository.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/call/get_profile_licenses.dart';
import 'package:arachnoit/infrastructure/question_details/caller/action_answer.dart';
import 'package:arachnoit/infrastructure/question_replay_details/caller/question_replay_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/question_replay_details/question_replay_repository.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_advance_search_blogs.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_remote_blogs_sub_category.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_text_search_blogs.dart';
import 'package:arachnoit/infrastructure/search_blogs/search_blogs_repository.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_group_advance_search.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_group_search_text.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_remote_group_main_category.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_remote_group_sub_category.dart';
import 'package:arachnoit/infrastructure/search_group/search_group_repositories.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_account_type.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_advance_search.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_cities_by_country.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_country.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_services.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_specification.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_sub_specification.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_text_search.dart';
import 'package:arachnoit/infrastructure/search_provider/search_provider_repositories.dart';
import 'package:arachnoit/infrastructure/search_question/search_question_repositories.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'application/all_groups/all_groups_bloc.dart';
import 'application/blog_comment_item/blog_comment_item_bloc.dart';
import 'application/blog_details/blog_details_bloc.dart';
import 'application/blog_list_item/blog_list_item_bloc.dart';
import 'application/blog_replay_detail/blog_replay_comment_item_bloc.dart';
import 'application/blog_replay_item/blog_replay_item_bloc.dart';
import 'application/blogs_emphases_vote/blogs_emphases_vote_bloc.dart';
import 'application/blogs_useful_vote/blogs_useful_vote_bloc.dart';
import 'application/blogs_vote_item/blogs_vote_item_bloc.dart';
import 'application/changePassword/change_password_bloc.dart';
import 'application/discover/discover_bloc.dart';
import 'application/discover_categories/discover_categories_bloc.dart';
import 'application/discover_categories_details/discover_categories_details_bloc.dart';
import 'application/discover_categories_sub_category_all_blogs/discover_categories_sub_category_all_blogs_bloc.dart';
import 'application/discover_categories_sub_category_all_groups/discover_categories_sub_category_all_groups_bloc.dart';
import 'application/discover_categories_sub_category_all_questions/discover_categories_sub_category_all_questions_bloc.dart';
import 'application/discover_my_interest/discover_my_interest_bloc.dart';
import 'application/discover_my_interests_sub_categories_blogs/discover_my_interests_sub_categories_blogs_bloc.dart';
import 'application/discover_my_interests_sub_categories_qaa/discover_my_interests_sub_categories_qaa_bloc.dart';
import 'application/discover_my_interests_sub_catergories_details/discover_my_interests_sub_catergories_details_bloc.dart';
import 'application/forgetPassword/forget_password_bloc.dart';
import 'application/group_details/group_details_bloc.dart';
import 'application/group_details_blogs/group_details_blogs_bloc.dart';
import 'application/group_details_questions/group_details_questions_bloc.dart';
import 'application/group_details_search/group_details_search_bloc.dart';
import 'application/group_details_search_blogs/group_details_search_blogs_bloc.dart';
import 'application/group_details_search_questions/group_details_search_questions_bloc.dart';
import 'application/group_members_providers/group_invite_members/group_invite_members_bloc.dart';
import 'application/group_members_providers/group_permission/group_permission_bloc.dart';
import 'application/group_members_providers/home_group_members/home_group_members_bloc.dart';
import 'application/groups/groups_bloc.dart';
import 'application/home/home_bloc.dart';
import 'application/home_blog/home_blog_bloc.dart';
import 'application/home_qaa/home_qaa_bloc.dart';
import 'application/in_app_terms_and_condition/terms_and_condition_bloc.dart';
import 'application/language/language_bloc.dart';
import 'application/local_auth/local_auth_bloc.dart';
import 'application/login/login_bloc.dart';
import 'application/logout/logout_bloc.dart';
import 'application/main/main_bloc.dart';
import 'application/notification_provider/notification_bloc.dart';
import 'application/pending_list_group/pending_list_group_bloc.dart';
import 'application/pending_list_patents/pending_list_patents_bloc.dart';
import 'application/profile_provider/profile_provider_bloc.dart';
import 'application/profile_provider_cerificate/profile_provider_certificate_bloc.dart';
import 'application/profile_provider_experiance/profile_provider_experiance_bloc.dart';
import 'application/profile_provider_lectures/profile_provider_lectures_bloc.dart';
import 'application/profile_provider_licenses/profile_provider_licenses_bloc.dart';
import 'application/profile_provider_projects/profile_provider_projects_bloc.dart';
import 'application/provider_list_item/provider_list_item_bloc.dart';
import 'application/providers/providers_bloc.dart';
import 'application/providers_all/providers_all_bloc.dart';
import 'application/providers_favorite/providers_favorite_bloc.dart';
import 'application/qaa_list_item/qaa_list_item_bloc.dart';
import 'application/question_answer_item/question_answer_item_bloc.dart';
import 'application/question_details/question_details_bloc.dart';
import 'application/question_replay_details/question_replay_details_bloc.dart';
import 'application/registration/registration_bloc.dart';
import 'application/registration_socail/registration_socail_bloc.dart';
import 'application/single_photo_view/single_photo_view_bloc.dart';
import 'application/user_manual/user_manual_bloc.dart';
import 'application/verification/verification_bloc.dart';
import 'common/pref_keys.dart';
import 'infrastructure/active_session/active_session_repository.dart';
import 'infrastructure/active_session/caller/remote/get_all_active_session.dart';
import 'infrastructure/active_session/caller/remote/make_report.dart';
import 'infrastructure/add_blog/caller/add_blog_remote_provider.dart';
import 'infrastructure/add_blog/caller/get_blogs_main_category.dart';
import 'infrastructure/add_blog/caller/get_blogs_sub_category.dart';
import 'infrastructure/add_blog/caller/get_blogs_tags.dart';
import 'infrastructure/all_groups/all_groups_repository.dart';
import 'infrastructure/all_groups/caller/get_public_groups_remote_data_provider.dart';
import 'infrastructure/api/urls.dart';
import 'infrastructure/blog_comment_item/blog_comment_item_repository.dart';
import 'infrastructure/blog_comment_item/caller/set_useful_vote_for_blog_comment_remote_data_provider.dart';
import 'infrastructure/blog_details/blog_details_repository.dart';
import 'infrastructure/blog_details/caller/add_comment.dart';
import 'infrastructure/blog_details/caller/get_blog_details_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/new_license_response.dart';
import 'infrastructure/blog_comment_item/caller/get_profile_brief.dart';
import 'infrastructure/home_blog/caller/delete_blog.dart';
import 'infrastructure/home_blog/caller/report_blogs.dart';
import 'infrastructure/blog_details/caller/set_emphasis_vote_for_blog_details_remote_data_provider.dart';
import 'infrastructure/blog_details/caller/set_useful_vote_for_blog_details_remote_data_provider.dart';
import 'infrastructure/blog_details/caller/update_comment.dart';
import 'infrastructure/blog_replay_detail/blog_replay_comment_item_repository.dart';
import 'infrastructure/blog_replay_detail/caller/delete_replay.dart';
import 'infrastructure/blog_replay_detail/caller/get_blogs_details.dart';
import 'infrastructure/blog_replay_detail/caller/report_replay.dart';
import 'infrastructure/blog_replay_detail/caller/update_replay.dart';
import 'infrastructure/blog_replay_item/blog_replay_item_repository.dart';
import 'infrastructure/blog_replay_item/caller/get_replay_profile_brife.dart';
import 'infrastructure/blogs_emphasis_vote/blogs_emphasis_vote_repository.dart';
import 'infrastructure/blogs_emphasis_vote/call/get_emphasis_votes.dart';
import 'infrastructure/blogs_vote/blogs_useful_vote_repository.dart';
import 'infrastructure/blogs_vote/call/get_useful_votes.dart';
import 'infrastructure/blogs_vote_item/blogs_vote_item_repository.dart';
import 'infrastructure/blogs_vote_item/call/get_blogs_vote_item_profile_brife.dart';
import 'infrastructure/catalog_facade_service.dart';
import 'infrastructure/changePassword/caller/change_password_remote_data_change_password.dart';
import 'infrastructure/changePassword/change_password._repository.dart';
import 'infrastructure/discover_categories/caller/get_categories_remote_data_provider.dart';
import 'infrastructure/discover_categories/discover_categories_repository.dart';
import 'infrastructure/discover_categories_details/caller/get_sub_category_blogs_remote_data_provider.dart';
import 'infrastructure/discover_categories_details/caller/get_sub_category_groups_remote_Data_provider.dart';
import 'infrastructure/discover_categories_details/caller/get_sub_category_questions_remote_data_provider.dart';
import 'infrastructure/discover_categories_details/discover_categories_details_repository.dart';
import 'infrastructure/discover_categories_sub_category_all_blogs/caller/get_sub_category_all_blogs_remote_data_provider.dart';
import 'infrastructure/discover_categories_sub_category_all_blogs/discover_categories_sub_category_all_blogs_repository.dart';
import 'infrastructure/discover_categories_sub_category_all_groups/caller/get_sub_category_all_groups_remote_data_provider.dart';
import 'infrastructure/discover_categories_sub_category_all_groups/discover_categories_sub_category_all_groups_repository.dart';
import 'infrastructure/discover_categories_sub_category_all_questions/caller/get_sub_category_all_questions_remote_Data_provider.dart';
import 'infrastructure/discover_categories_sub_category_all_questions/discover_categories_sub_category_all_questions_repository.dart';
import 'infrastructure/discover_my_interests/caller/action_subscrption_remote.dart';
import 'infrastructure/discover_my_interests/caller/get_my_interests_sub_catergories_remote.dart';
import 'infrastructure/discover_my_interests/discover_my_interests_repository.dart';
import 'infrastructure/discover_my_interests_add_interests/caller/get_my_interests_at_interests_remote.dart';
import 'infrastructure/discover_my_interests_add_interests/discover_my_interests_add_interests_repository.dart';
import 'infrastructure/discover_my_interests_sub_categories_blogs/caller/get_my_interests_sub_categories_blogs.dart';
import 'infrastructure/discover_my_interests_sub_categories_blogs/discover_my_interests_sub_categories_blogs_repositories.dart';
import 'infrastructure/discover_my_interests_sub_catergories_qaa/call/get_my_interests_sub_catergories_qaa_interface_remote.dart';
import 'infrastructure/discover_my_interests_sub_catergories_qaa/discover_my_interests_sub_catergories_qaa_repository.dart';
import 'infrastructure/forgetPassword/caller/forget_password_remote_data_reset_password.dart';
import 'infrastructure/forgetPassword/forget_password_repository.dart';
import 'infrastructure/group_details/caller/get_group_details_remote_Data_provider.dart';
import 'infrastructure/group_details/caller/join_to_group.dart';
import 'infrastructure/group_details/group_details_repository.dart';
import 'infrastructure/group_details_blogs/caller/get_groups_blog_remote_data_provider.dart';
import 'infrastructure/group_details_blogs/group_details_blogs_repository.dart';
import 'infrastructure/group_details_questions/caller/get_group_questions_remote_data_provider.dart';
import 'infrastructure/group_details_questions/group_details_questions_repostory.dart';
import 'infrastructure/group_details_search/caller/get_group_advanced_search_categories_remote_data_provider.dart';
import 'infrastructure/group_details_search/caller/get_group_advanced_search_sub_categories_remote_data_provider.dart';
import 'infrastructure/group_details_search/group_details_search_repository.dart';
import 'infrastructure/group_details_search_blogs/caller/get_advanced_search_blogs_remote_data_provider.dart';
import 'infrastructure/group_details_search_blogs/caller/get_search_text_blogs_remote_data_provider.dart';
import 'infrastructure/group_details_search_blogs/group_details_search_blogs_repository.dart';
import 'infrastructure/group_details_search_questions/caller/get_advanced_search_questions_remote_data_provider.dart';
import 'infrastructure/group_details_search_questions/caller/get_search_text_questions_remote_data_provider.dart';
import 'infrastructure/group_details_search_questions/group_details_search_questions_repository.dart';
import 'infrastructure/group_members_providers/group_invite_members/caller/group_invite_members_local_data_provider.dart';
import 'infrastructure/group_members_providers/group_invite_members/caller/group_invite_members_remote_data_provider.dart';
import 'infrastructure/group_members_providers/group_invite_members/group_invite_members_repository.dart';
import 'infrastructure/group_members_providers/group_permission/caller/group_perimsiion_remote_data_provider.dart';
import 'infrastructure/group_members_providers/group_permission/group_permission_repository.dart';
import 'infrastructure/groups/caller/get_my_groups_remote_Data_provider.dart';
import 'infrastructure/groups/caller/get_public_and_my_groups_remote_data_provider.dart';
import 'infrastructure/groups/groups_repository.dart';
import 'infrastructure/home_blog/caller/get_blogs_local_data_provider.dart';
import 'infrastructure/home_blog/caller/get_blogs_remote_data_provide.dart';
import 'infrastructure/home_blog/caller/get_profile_brief.dart';
import 'infrastructure/home_blog/caller/set_emphasis_vote_for_blog_remote_data_provider.dart';
import 'infrastructure/home_blog/caller/set_useful_vote_for_blog_remote_data_provider.dart';
import 'infrastructure/home_blog/home_blog_repository.dart';
import 'infrastructure/home_qaa/caller/delete_selected_question.dart';
import 'infrastructure/home_qaa/caller/get_qaa_local_data_provider.dart';
import 'infrastructure/home_qaa/caller/get_qaa_remote_data_provider.dart';
import 'infrastructure/home_qaa/caller/get_question_files_remote_data_provider.dart';
import 'infrastructure/home_qaa/caller/report_qaa.dart';
import 'infrastructure/home_qaa/caller/set_useful_vote_for_question_remote_data_provider.dart';
import 'infrastructure/home_qaa/home_qaa_repository.dart';
import 'infrastructure/in_app_terms_and_policies/caller/get_terms_and_condition.dart';
import 'infrastructure/in_app_terms_and_policies/terms_and_condition_repository.dart';
import 'infrastructure/language/caller/language_remote_data_set_language.dart';
import 'infrastructure/language/language_repository.dart';
import 'infrastructure/latest_version/caller/get_latest_version.dart';
import 'infrastructure/latest_version/latest_version_repository.dart';
import 'infrastructure/login/caller/login_local_data_provider.dart';
import 'infrastructure/login/caller/login_remote_data_login_to_server.dart';
import 'infrastructure/login/caller/login_remote_data_request_reset_password.dart';
import 'infrastructure/login/login_repository.dart';
import 'infrastructure/logout/caller/logout_user_remote_data_provider.dart';
import 'infrastructure/logout/logout_repository.dart';
import 'infrastructure/notification/caller/get_notification.dart';
import 'infrastructure/notification/caller/get_remote_read_notification.dart';
import 'infrastructure/notification/caller/read_all_notification.dart';
import 'infrastructure/pendding_list_group/caller/accept_group_invitation.dart';
import 'infrastructure/pendding_list_group/caller/get_all_groups.dart';
import 'infrastructure/pendding_list_group/caller/remove_group.dart';
import 'infrastructure/pendding_list_group/pendding_list_group_repository.dart';
import 'infrastructure/pendding_list_patents/call/accept_inovation.dart';
import 'infrastructure/pendding_list_patents/call/get_all_patents.dart';
import 'infrastructure/pendding_list_patents/call/reject_inovation.dart';
import 'infrastructure/pendding_list_patents/pending_list_patents_repository.dart';
import 'infrastructure/pending_list_department/datasource/remote/Idepatment_remote.dart';
import 'infrastructure/pending_list_department/datasource/remote/fetch_pending_list_department.dart';
import 'infrastructure/profile/call/get_profile_country.dart';
import 'infrastructure/profile/call/profile_get_specification.dart';
import 'infrastructure/profile/call/profile_get_sub_specification.dart';
import 'infrastructure/profile/call/set_contact_info.dart';
import 'infrastructure/profile/call/set_provider_general_info.dart';
import 'infrastructure/profile_provider_certificate/call/get_profile_certificate.dart';
import 'infrastructure/profile_provider_certificate/call/set_new_certificate.dart';
import 'infrastructure/profile_provider_certificate/call/update_certificate.dart';
import 'infrastructure/profile_provider_courses/call/get_profile_courses.dart';
import 'infrastructure/profile_provider_courses/call/set_course.dart';
import 'infrastructure/profile_provider_courses/call/update_course.dart';
import 'infrastructure/profile_provider_educations/call/delete_education.dart';
import 'infrastructure/profile_provider_educations/call/get_profile_educatios.dart';
import 'infrastructure/profile_provider_educations/call/set_new_education.dart';
import 'infrastructure/profile_provider_experiance/call/get_profile_experiance.dart';
import 'infrastructure/profile/call/get_profile_info.dart';
import 'infrastructure/profile_provider_experiance/call/set_new_experiance.dart';
import 'infrastructure/profile_provider_experiance/call/update_experiance.dart';
import 'infrastructure/profile_provider_lectures/call/add_new_lectures.dart';
import 'infrastructure/profile_provider_lectures/call/get_profile_lecture.dart';
import 'infrastructure/profile_provider_experiance/profile_provider_experiance_repository.dart';
import 'infrastructure/profile_provider_licenses/call/set_new_license.dart';
import 'infrastructure/profile_provider_licenses/call/update_license.dart';
import 'infrastructure/profile_provider_projects/call/delete_project.dart';
import 'infrastructure/profile_provider_projects/call/get_profile_projects.dart';
import 'infrastructure/profile_provider_courses/profile_provider_courses_repository.dart';
import 'infrastructure/profile_provider_projects/call/set_project.dart';
import 'infrastructure/profile_provider_projects/call/update_project.dart';
import 'infrastructure/profile_provider_projects/profile_provider_projects_repository.dart';
import 'infrastructure/profile_provider_skill/call/delete_skill.dart';
import 'infrastructure/profile_provider_skill/call/get_profile_skills.dart';
import 'infrastructure/profile/profile_repository.dart';
import 'infrastructure/profile_provider_experiance/response/experiance_response.dart';
import 'infrastructure/profile_provider_certificate/profile_provider_certificate_repository.dart';
import 'infrastructure/profile_provider_language/profile_provider_language_repository.dart';
import 'infrastructure/profile_provider_licenses/profile_provider_repository.dart';
import 'infrastructure/profile_provider_skill/call/set_skill.dart';
import 'infrastructure/profile_provider_skill/profile_provider_skill_repository.dart';
import 'infrastructure/providers_all/caller/get_all_providers_remote_data_call_providers.dart';
import 'infrastructure/providers_all/providers_all_repository.dart';
import 'infrastructure/providers_favorite/caller/get_favorite_providers_remote_data_provider.dart';
import 'infrastructure/providers_favorite/providers_favorite_repository.dart';
import 'infrastructure/providers_provider_item/caller/set_favorite_provider_remote_data_provider.dart';
import 'infrastructure/providers_provider_item/providers_provider_item_repository.dart';
import 'infrastructure/question_answer_item/caller/set_emphasis_vote_for_answer_remote_data_provider.dart';
import 'infrastructure/question_answer_item/caller/set_useful_vote_for_answer_remote_data_provider.dart';
import 'infrastructure/question_answer_item/question_answer_item_repository.dart';
import 'infrastructure/question_details/caller/get_question_details_remote_data_provider.dart';
import 'infrastructure/question_details/caller/set_useful_vote_for_question_details_remote_data_provider.dart';
import 'infrastructure/question_details/question_details_repository.dart';
import 'infrastructure/registration/caller/registration_local_data_provider.dart';
import 'infrastructure/registration/caller/registration_remote_data_get_account_types.dart';
import 'infrastructure/registration/caller/registration_remote_data_get_countries.dart';
import 'infrastructure/registration/caller/registration_remote_data_get_specification.dart';
import 'infrastructure/registration/caller/registration_remote_data_get_sub_specification.dart';
import 'infrastructure/registration/caller/registration_remote_data_is_email_mobile_available.dart';
import 'infrastructure/registration/caller/registration_remote_data_is_touch_point_name_email_mobile_available.dart';
import 'infrastructure/registration/caller/registration_remote_data_register_health_care_provider.dart';
import 'infrastructure/registration/caller/registration_remote_data_register_normal_user.dart';
import 'infrastructure/registration/caller/registration_remote_date_get_cities_by_country.dart';
import 'infrastructure/registration/registration_repository.dart';
import 'infrastructure/registration_socail/caller/login_with_facebook.dart';
import 'infrastructure/registration_socail/caller/login_with_google.dart';
import 'infrastructure/registration_socail/caller/validate_facebook_token.dart';
import 'infrastructure/registration_socail/caller/validate_google_token.dart';
import 'infrastructure/registration_socail/registration_socail_repository.dart';
import 'infrastructure/search_blogs/call/remote/get_remote_blogs_add_tags.dart';
import 'infrastructure/search_blogs/call/remote/get_remote_blogs_main_category.dart';
import 'infrastructure/search_question/caller/remote/get_advance_search_questions.dart';
import 'infrastructure/search_question/caller/remote/get_remote_questions_add_tags.dart';
import 'infrastructure/search_question/caller/remote/get_remote_questions_main_category.dart';
import 'infrastructure/search_question/caller/remote/get_remote_questions_sub_category.dart';
import 'infrastructure/search_question/caller/remote/get_text_search_questions.dart';
import 'infrastructure/verification/caller/verification_remote_data_confirm_registration.dart';
import 'infrastructure/verification/caller/verifivation_remote_data_send_activation_code.dart';
import 'infrastructure/verification/verification_repository.dart';
import 'presentation/screens/group_members_provider/home_gruop_memebers_screen.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async => appDependencies();

Future<void> appDependencies() async {
  serviceLocator.registerLazySingleton(
    () => CatalogFacadeService(
      questionReplayDetailRepository: serviceLocator(),
      groupAddRepository: serviceLocator(),
      profileActionRepository: serviceLocator(),
      termsAndConditionsRepository: serviceLocator(),
      getGroupInviteMembersRepository: serviceLocator(),
      getGroupMembersRepository: serviceLocator(),
      getGroupPermissionRepository: serviceLocator(),
      profileProviderLecturesRepository: serviceLocator(),
      profileProviderExperianceRepository: serviceLocator(),
      profileProviderEducationsRepository: serviceLocator(),
      profileProviderCoursesRepository: serviceLocator(),
      profileProviderCertificateRepository: serviceLocator(),
      profileProviderRepository: serviceLocator(),
      profileProviderSkillRepository: serviceLocator(),
      profileFollowListRepository: serviceLocator(),
      loginRepository: serviceLocator(),
      profileProvierLanguageRepository: serviceLocator(),
      registrationRepository: serviceLocator(),
      verificationRepository: serviceLocator(),
      forgetPasswordRepository: serviceLocator(),
      homeBlogRepository: serviceLocator(),
      languageRepository: serviceLocator(),
      changePasswordRepository: serviceLocator(),
      homeQaaRepository: serviceLocator(),
      logoutRepsitory: serviceLocator(),
      questionAnswerItemRepository: serviceLocator(),
      questionDetailsRepository: serviceLocator(),
      blogDetailsRepository: serviceLocator(),
      commentItemRepository: serviceLocator(),
      groupsRepository: serviceLocator(),
      allGroupsRepository: serviceLocator(),
      providersAllRepository: serviceLocator(),
      providersFavoriteRepository: serviceLocator(),
      providerItemRepository: serviceLocator(),
      discoverCategoriesRepository: serviceLocator(),
      discoverCategoriesDetailsRepository: serviceLocator(),
      discoverCategoriesSubCategoryAllBlogsRepository: serviceLocator(),
      discoverCategoriesSubCategoryAllGroupsRepostory: serviceLocator(),
      discoverCategoriesSubCategoryAllQuestionsRepository: serviceLocator(),
      groupDetailsRepository: serviceLocator(),
      disconverMyInterestsSubCategorisRepositories: serviceLocator(),
      discoverMyInterestRepository: serviceLocator(),
      discoverMyInterestsSubCatergoriesQaaRepository: serviceLocator(),
      groupDetailsBlogsRepository: serviceLocator(),
      groupDetailsQuestionsRepository: serviceLocator(),
      groupDetailsSearchBlogsRepository: serviceLocator(),
      groupDetailsSearchQuestionsRepository: serviceLocator(),
      groupDetailsSearchRepository: serviceLocator(),
      discoverMyInterestsAtInterestsRepository: serviceLocator(),
      searchProviderRepositories: serviceLocator(),
      searchGroupRepositories: serviceLocator(),
      searchBlogsRepository: serviceLocator(),
      searchQuestionsRepository: serviceLocator(),
      activeSessionRepository: serviceLocator(),
      penddingListGroupRepository: serviceLocator(),
      penddingListPatentsRepository: serviceLocator(),
      blogReplayCommentItemRepository: serviceLocator(),
      pendingListDepartmentRepository: serviceLocator(),
      blogReplayItemRepository: serviceLocator(),
      blogsVoteRepository: serviceLocator(),
      blogsEmphasisVoteRepository: serviceLocator(),
      blogsVoteItemRepository: serviceLocator(),
      profileRepository: serviceLocator(),
      profileProviderProjectsRepository: serviceLocator(),
      addQuestionRepository: serviceLocator(),
      addBlogRepository: serviceLocator(),
      registrationSocailRepository: serviceLocator(),
      notificationRepository: serviceLocator(),
      latestVersionRepository: serviceLocator(),
    ),
  );

  serviceLocator
    ..registerLazySingleton(() => JoinOrLeaveDepartment(dio: serviceLocator()))
    ..registerLazySingleton(
            () =>
            FetchPendingListDepartmentRemote(
                dio: serviceLocator()))..registerLazySingleton(() =>
      GetDepartmentById(dio: serviceLocator()))..registerLazySingleton(() =>
      PendingListDepartmentRepository(
          iDepartmentRemoteDataSource: serviceLocator()))
    ..registerLazySingleton(() => IDepartmentRemoteDataSource(
        getDepartmentById: serviceLocator(),
        fetchPendingListDepartment: serviceLocator(),
        joinOrLeaveDepartment: serviceLocator()))
    ..registerFactory(() =>
        PendingListDepartmentBloc(catalogFacadeService: serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => LoginRepository(
      loginLocalDataProvider: serviceLocator(),
      loginRemoteDataLoginToServer: serviceLocator(),
      loginRemoteDataRequestResetPassword: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AddQuestionRepository(
      addQuestionRemoteDataToServer: serviceLocator(),
      getQuestionsMainCategory: serviceLocator(),
      getQuestionsSubCategory: serviceLocator(),
      getQuestionsTags: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AddBlogRepository(
      addBlogRemoteDataToServer: serviceLocator(),
      getBlogsMainCategory: serviceLocator(),
      getBlogsSubCategory: serviceLocator(),
      getBlogsTags: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AddBlogRemoteDataToServer(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetBlogsMainCategory(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetBlogsSubCategory(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetBlogsTags(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AddQuestionRemoteDataToServer(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetQuestionsMainCategory(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetQuestionsSubCategory(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetQuestionsTags(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => LogoutRepsitory(
      logoutUserRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetProfileBrife(dio: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteSelectedBlogs(dio: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => HomeBlogRepository(
      getBlogsLocalDataProvider: serviceLocator(),
      getBlogsRemoteDataProvider: serviceLocator(),
      setEmphasisVoteForBlogRemoteDataProvider: serviceLocator(),
      setUsefulVoteForBlogRemoteDataProvider: serviceLocator(),
      getProfileBrife: serviceLocator(),
      reportBlogs: serviceLocator(),
      deleteSelectedBlogs: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => ReportBlogs(dio: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ReportQaa(dio: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteSelectedQuestion(dio: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => HomeQaaRepository(
      getQaaLocalDataProvider: serviceLocator(),
      getQaaRemoteDataProvider: serviceLocator(),
      getQuestionFilesRemoteDataProvider: serviceLocator(),
      setUsefulVoteForQuestionRemoteDataProvider: serviceLocator(),
      reportQaa: serviceLocator(),
      deleteSelectedQuestion: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => BlogDetailsRepository(
        getBlogDetailsRemoteDataProvider: serviceLocator(),
        setEmphasisVoteForBlogDetailsRemoteDataProvider: serviceLocator(),
        setUsefulVoteForBlogDetailsRemoteDataProvider: serviceLocator(),
        addComment: serviceLocator(),
        updatComment: serviceLocator(),
        deleteComment: serviceLocator(),
        sendCommentReport: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SendCommentReport(
      dio: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteComment(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => UpdatComment(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetBlogDetailsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AddComment(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => QuestionDetailsRepository(
      getQuestionDetailsRemoteDataProvider: serviceLocator(),
      setUsefulVoteForQuestionDetailsRemoteDataProvider: serviceLocator(),
      addAnswer: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetQuestionDetailsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetUsefulVoteForQuestionDetailsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AddAnswer(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => QuestionAnswerItemRepository(
      setEmphasisVoteForAnswerRemoteDataProvider: serviceLocator(),
      setUsefulVoteForAnswerRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => CommentItemRepository(
        setUsefulVoteForCommentRemoteDataProvider: serviceLocator(),
        getCommentProfileBrife: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCommentProfileBrife(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetUsefulVoteForCommentRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetUsefulVoteForAnswerRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetEmphasisVoteForAnswerRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => LoginLocalDataProvider(),
  );

  serviceLocator.registerLazySingleton(
    () => LoginRemoteDataLoginToServer(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => LoginRemoteDataRequestResetPassword(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => LogoutUserRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetBlogsLocalDataProvider(),
  );

  serviceLocator.registerLazySingleton(
    () => GetBlogsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetQaaLocalDataProvider(),
  );

  serviceLocator.registerLazySingleton(
    () => GetQaaRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetQuestionFilesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetUsefulVoteForQuestionRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetEmphasisVoteForBlogDetailsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetUsefulVoteForBlogDetailsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetEmphasisVoteForBlogRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetUsefulVoteForBlogRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddQuestionBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddBlogBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => LogoutBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ForgetPasswordRepository(
      forgetPasswordRemoteDataResetPassword: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ForgetPasswordRemoteDataResetPassword(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ForgetPasswordBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ChangePasswordRepository(
      changePasswordremoteDataChangePassword: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ChangePasswordremoteDataChangePassword(
      dio: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => ChangePasswordBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => LocalAuthBloc(),
  );

  serviceLocator.registerFactory(
    () => UserManualBloc(),
  );

  serviceLocator.registerLazySingleton(
    () => HomeBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => MainBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AllGroupsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AllGroupsRepository(
      getPublicGroupsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GroupsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GroupsRepository(
      getMyGroupsRemoteDataProvider: serviceLocator(),
      getPublicAndMyGroupsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetPublicAndMyGroupsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetPublicGroupsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetMyGroupsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => JoinInGroup(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () =>
        GroupDetailsBloc(
            catalogService: serviceLocator(),
            sharedPreferences: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => GroupDetailsRepository(
        getGroupDetailsRemoteDataProvider: serviceLocator(),
        joinInGroup: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => GetGroupDetailsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GroupDetailsBlogsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GroupDetailsBlogsRepository(
      getGroupBlogsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetGroupBlogsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GroupDetailsQuestionsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GroupDetailsQuestionsRepository(
      getGroupQuestionsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetGroupQuestionsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GroupDetailsSearchBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GroupDetailsSearchRepository(
      getGroupsAdvancedSearchCategoriesRemoteDataProvider: serviceLocator(),
      getGroupsAdvancedSearchSubCategoriesRemoteDataProvider: serviceLocator(),
      getGroupAdvanceSearchAddTags: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetGroupsAdvancedSearchCategoriesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetGroupsAdvancedSearchSubCategoriesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GroupDetailsSearchBlogsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GroupDetailsSearchBlogsRepository(
      getSearchTextBlogsRemoteDataProvider: serviceLocator(),
      getAdvancedSearchBlogsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetSearchTextBlogsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetAdvancedSearchBlogsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => GroupDetailsSearchQuestionsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GroupDetailsSearchQuestionsRepository(
      getSearchTextQuestionsRemoteDataProvider: serviceLocator(),
      getAdvancedSearchQuestionsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetSearchTextQuestionsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetAdvancedSearchQuestionsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => DiscoverBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ProvidersBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ProvidersAllBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ProvidersAllRepository(
      getAllProvidersRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetAllProvidersRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ProvidersFavoriteBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ProvidersFavoriteRepository(
      getFavoriteProvidersRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetFavoriteProvidersRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ProviderListItemBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => ProvidersProviderItemRepository(
      setFavoriteProviderRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SetFavoriteProviderRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => DiscoverCategoriesBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DiscoverCategoriesRepository(
      getCategoriesRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetCategoriesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => DiscoverCategoriesDetailsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DiscoverCategoriesDetailsRepository(
      getSubCategoryBlogsRemoteDataProvider: serviceLocator(),
      getSubCategoryGroupsRemoteDataProvider: serviceLocator(),
      getSubCategoryQuestionsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetSubCategoryBlogsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetSubCategoryQuestionsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetSubCategoryGroupsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => DiscoverCategoriesSubCategoryAllBlogsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DiscoverCategoriesSubCategoryAllBlogsRepository(
      getSubCategoryAllBlogsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetSubCategoryAllBlogsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => DiscoverCategoriesSubCategoryAllGroupsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DiscoverCategoriesSubCategoryAllGroupsRepository(
      getSubCategoryAllGroupsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetSubCategoryAllGroupsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => DiscoverCategoriesSubCategoryAllQuestionsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DiscoverCategoriesSubCategoryAllQuestionsRepository(
      getSubCategoryAllQuestionsRemoteDataProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetSubCategoryAllQuestionsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => HomeBlogBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => HomeQaaBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => QuestionDetailsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => BlogDetailsBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CommentItemBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => QuestionAnswerItemBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => BlogListItemBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => QaaListItemBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SinglePhotoViewBloc(),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRepository(
      registrationLocalDataProvider: serviceLocator(),
      registrationRemoteDataGetCitiesByCountry: serviceLocator(),
      registrationRemoteDataGetAccountTypes: serviceLocator(),
      registrationRemoteDataGetCountries: serviceLocator(),
      registrationRemoteDataGetSpecification: serviceLocator(),
      registrationRemoteDataGetSubSpecification: serviceLocator(),
      registrationRemoteDataIsTouchPointNameEmailMobileAvailable:
      serviceLocator(),
      registrationRemoteDataIsEmailMobileAvailable: serviceLocator(),
      registrationRemoteDataRegisterHealthCareProvider: serviceLocator(),
      registrationRemoteDataRegisterNormalUser: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationLocalDataProvider(),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataGetCountries(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataGetCitiesByCountry(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataGetAccountTypes(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataGetSpecification(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataGetSubSpecification(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataIsTouchPointNameEmailMobileAvailable(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataIsEmailMobileAvailable(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataRegisterHealthCareProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => RegistrationRemoteDataRegisterNormalUser(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegistrationBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => VerificationRepository(
      verificationRemoteDataConfrmRegistration: serviceLocator(),
      verificationRemoteDataSendActivationCode: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => VerificationRemoteDataConfrmRegistration(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => VerificationRemoteDataSendActivationCode(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => VerificationBloc(
      catalogService: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => LanguageRepository(
      languageRemoteDataSetLanguage: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => LanguageRemoteDataSetLanguage(
      dio: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => LanguageBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
          () => GetMyInterestsSubCategoriesRemote(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetSubScriptionRemote(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => DiscoverMyInterestsRepository(
        getMyInterestSubCategories: serviceLocator(),
        getSubScriptionRemote: serviceLocator(),
      ));

  serviceLocator.registerFactory(
          () => DiscoverMyInterestBloc(catalogService: serviceLocator()));

  serviceLocator.registerLazySingleton(() =>
      DisconverMyInterestsSubCategorisRepositories(
          getMyInterestsSubCategories: serviceLocator()));

  serviceLocator.registerLazySingleton(
          () => GetMyInterestsSubCategoriesBlogsRemote(dio: serviceLocator()));

  serviceLocator.registerFactory(() =>
      DiscoverMyInterestsSubCategoriesBlogsBloc(
          catalogService: serviceLocator()));
//DiscoverMyInterestsSubCatergoriesQaaRepository
  serviceLocator.registerFactory(() =>
      DiscoverMyInterestsSubCategoriesQaaBloc(
          catalogService: serviceLocator()));

  serviceLocator.registerLazySingleton(() =>
      DiscoverMyInterestsSubCatergoriesQaaRepository(
          getMyInterestsSubCatergoriesQaaInterfaceRemote: serviceLocator()));

  serviceLocator.registerLazySingleton(() =>
      GetMyInterestsSubCatergoriesQaaInterfaceRemote(dio: serviceLocator()));

  serviceLocator.registerFactory(() =>
      DiscoverMyInterestsAddInterestsBloc(catalogService: serviceLocator()));

  serviceLocator.registerLazySingleton(() =>
      DiscoverMyInterestsAddInterestsRepository(
          getMyInterestsAtInterestsRemote: serviceLocator()));

  serviceLocator.registerLazySingleton(
          () => GetMyInterestsAddInterestsRemote(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => getNetworkObj(),
  );
  serviceLocator.registerFactory(() =>
      DiscoverMyInterestsSubCatergoriesDetailsBloc(
          catalogFacadeService: serviceLocator()));

  serviceLocator.registerLazySingleton(
          () => GetGroupAdvanceSearchAddTags(dio: serviceLocator()));

  serviceLocator.registerFactory(() => GroupDetailsSearchBlocTagsBloc());

  serviceLocator
      .registerFactory(() => SearchBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => SearchProviderBloc(catalogService: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchRemoteProviderGetAccount(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchProviderRemoteGetSpecification(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchProviderRemoteGetSubSpecification(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchProviderRemoteGetCountry(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchProviderRemoterGetCitiesByCountry(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchRemoteProviderGetAdvanceSearch(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchProviderRemoteGetTextSearch(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SearchProviderRemoteGetServices(dio: serviceLocator()));
  serviceLocator
      .registerFactory(() => SearchGroupBloc(catalogService: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetRemoteGroupMainCategory(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetRemoteGroupSubCategory(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetGroupAdvanceSearch(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetGroupSearchText(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SearchGroupRepositories(
        getRemoteGroupMainCategory: serviceLocator(),
        getRemoteGroupSubCategory: serviceLocator(),
        getGroupAdvanceSearch: serviceLocator(),
        getGroupSearchText: serviceLocator(),
      ));
  serviceLocator
      .registerFactory(() => SearchBlogsBloc(catalogService: serviceLocator()));

  serviceLocator.registerLazySingleton(
          () => GetRemoteBlogsMainCategory(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetRemoteBlogsSubCategory(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetBlogsAdvanceSearchAddTags(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetAdvanceSearchBlogs(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetTextSearchBlogs(dio: serviceLocator()));

  serviceLocator.registerFactory(
          () =>
          QuestionReplayDetailsBloc(catalogFacadeService: serviceLocator()));
  serviceLocator.registerFactory(() =>
      QuestionReplayDetailRepository(
          questionReplayRemoteDataProvider: serviceLocator()));
  serviceLocator.registerFactory(
          () => QuestionReplayRemoteDataProvider(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(() => SearchBlogsRepository(
      getRemoteBlogsMainCategory: serviceLocator(),
      getRemoteBlogsSubCategory: serviceLocator(),
      getBlogsAdvanceSearchAddTags: serviceLocator(),
      getAdvanceSearchBlogs: serviceLocator(),
      getTextSearchBlogs: serviceLocator()));

  serviceLocator.registerLazySingleton(() => SearchProviderRepositories(
        searchRemoteProviderGetAccount: serviceLocator(),
        searchProviderRemoteGetSpecification: serviceLocator(),
        searchProviderRemoteGetSubSpecification: serviceLocator(),
        searchProviderRemoteGetCountry: serviceLocator(),
        searchProviderRemoterGetCitiesByCountry: serviceLocator(),
        searchRemoteProviderAdvanceSearch: serviceLocator(),
        searchProviderRemoteGetTextSearch: serviceLocator(),
        searchProviderRemoteGetServices: serviceLocator(),
      ));

  serviceLocator.registerFactory(
          () => SearchQuestionBloc(catalogService: serviceLocator()));

  serviceLocator.registerLazySingleton(
          () => GetAdvanceSearchQuestions(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetQuestionsAdvanceSearchAddTags(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetRemoteQuestionsMainCategory(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetRemoteQuestionsSubCategory(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetTextSearchQuestions(dio: serviceLocator()));

  serviceLocator.registerFactory(
          () => ActiveSessionBloc(catalogService: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ActiveSessionRepository(
      getAllActiveSessionItem: serviceLocator(), makeReport: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetAllActiveSession(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => MakeReport(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(() => SearchQuestionsRepository(
        getAdvanceSearchQuestions: serviceLocator(),
        getQuestionsAdvanceSearchAddTags: serviceLocator(),
        getRemoteQuestionsMainCategory: serviceLocator(),
        getRemoteQuestionsSubCategory: serviceLocator(),
        getTextSearchQuestions: serviceLocator(),
      ));

  serviceLocator.registerFactory(
          () => PendingListGroupBloc(catalogService: serviceLocator()));

  serviceLocator.registerLazySingleton(() => PenddingListGroupRepository(
      getAllPenddingGroups: serviceLocator(),
      acceptGroupInvitation: serviceLocator(),
      removeFromGroup: serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => RemoveFromGroup(dio: serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetAllPenddingGroups(dio: serviceLocator()));

  serviceLocator.registerFactory(
          () => PenddingListPatentsBloc(catalogService: serviceLocator()));

  serviceLocator.registerLazySingleton(() => PenddingListPatentsRepository(
        getAllPatents: serviceLocator(),
        acceptPatentsInovation: serviceLocator(),
        rejectPatentsInovation: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(
          () => AcceptPatentsInovation(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => RejectPatentsInovation(dio: serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetAllPatents(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => AcceptGroupInvitation(dio: serviceLocator()));

  serviceLocator.registerFactory(
          () => BlogReplayDetailBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(() => GetBlogsDetail(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => BlogReplayDetailRepository(
      addReplay: serviceLocator(),
      deleteReplay: serviceLocator(),
      updateReplay: serviceLocator(),
      getBlogsDetail: serviceLocator(),
      sendReplayReport: serviceLocator()));

  // GroupPermission
  serviceLocator.registerFactory(
          () => GroupPermissionBloc(catalogFacadeService: serviceLocator()));
  serviceLocator.registerFactory(() =>
      GetGroupPermissionRepository(
          getGroupPermissionsRemoteDataProvider: serviceLocator()));
  serviceLocator.registerFactory(
          () => GetGroupPermissionsRemoteDataProvider(dio: serviceLocator()));

  // groupMembers

  serviceLocator.registerFactory(
          () => GroupMembersBloc(catalogFacadeService: serviceLocator()));
  serviceLocator.registerFactory(() => GetGroupMembersRepository(
      getGroupMembersLocalDataProvider: serviceLocator(),
      getGroupMembersRemoteDataProvider: serviceLocator()));
  serviceLocator.registerFactory(
          () => GetGroupMembersRemoteDataProvider(dio: serviceLocator()));
  serviceLocator.registerFactory(() => GetGroupMembersLocalDataProvider());

  // groupMembersInvite

  serviceLocator.registerFactory(
          () => GroupInviteMembersBloc(catalogFacadeService: serviceLocator()));
  serviceLocator.registerFactory(() => GetGroupInviteMembersRepository(
      getGroupInviteMembersLocalDataProvider: serviceLocator(),
      getGroupInviteMembersRemoteDataProvider: serviceLocator()));
  serviceLocator.registerFactory(
          () => GetGroupInviteMembersRemoteDataProvider(dio: serviceLocator()));
  serviceLocator
      .registerFactory(() => GetGroupInviteMembersLocalDataProvider());
  // HomeGroupMember
  serviceLocator.registerFactory(
          () => HomeGroupMembersBloc(catalogFacadeService: serviceLocator()));
  // group add
  serviceLocator
      .registerFactory(() => GroupAddBloc(catalogService: serviceLocator()));
  serviceLocator
      .registerFactory(() => GroupAddRemoteDataProvider(dio: serviceLocator()));
  serviceLocator.registerFactory(
          () =>
          GroupAddRepository(groupAddRemoteDataProvider: serviceLocator()));

  ///profileProviderLecturesRepository
  serviceLocator.registerLazySingleton(() => ProfileProviderLecturesRepository(
        getProfileLecture: serviceLocator(),
        addNewLectures: serviceLocator(),
        updateLectures: serviceLocator(),
        removerLectures: serviceLocator(),
      ));

  serviceLocator.registerFactory(
          () => ProfileActionsBloc(catalogFacadeService: serviceLocator()));
  serviceLocator.registerFactory(() =>
      ProfileActionRepository(
          profileActionRemoteDataProvider: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileActionRemoteDataProvider(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(() => RemoverLectures(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => UpdateLectures(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => AddNewLectures(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => SendReplayReport(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => AddReplay(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => DeleteCommentReplay(
        dio: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => UpdateCommentReplay(
        dio: serviceLocator(),
      ));

  serviceLocator.registerLazySingleton(
      () => BlogReplayItemRepository(getReplayProfileBrife: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetReplayProfileBrife(dio: serviceLocator()));
  serviceLocator
      .registerFactory(() => ReplayItemBloc(catalogService: serviceLocator()));

  serviceLocator.registerFactory(
          () => BlogsUsefulVoteBloc(catalogService: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => PostsVotesRepository(getVotes: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetVotes(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () =>
          BlogsEmphasisVoteRepository(getEmphasisVotes: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetEmphasisVotes(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(() =>
      BlogsVoteItemRepository(getBlogsVoteItemProfileBrife: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => GetBlogsVoteItemProfileBrife(dio: serviceLocator()));

  serviceLocator.registerFactory(
          () => BlogsEmphasesVoteBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => BlogsVoteItemBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileProviderBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileFollowListBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileProviderEducationBloc(catalogService: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ProfileRepository(
        getProfileInfo: serviceLocator(),
        setContactInfo: serviceLocator(),
        getProfileCountry: serviceLocator(),
        setSocailMedialLink: serviceLocator(),
        profileGetSpecification: serviceLocator(),
        profileGetSubSpecification: serviceLocator(),
        setProfileImage: serviceLocator(),
        setProviderGeneralInfo: serviceLocator(),
        setNormalUserGeneralInfo: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() =>
      ProfileFollowListRepository(
        getProfileFollowInfo: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(
          () => SetNormalUserGeneralInfo(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => SetProviderGeneralInfo(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetProfileImage(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => ProfileGetSubSpecification(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(
          () => ProfileGetSpecification(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetSocailMedialLink(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileCountry(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetContactInfo(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SetProject(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateProject(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteProject(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(() => ProfileProviderProjectsRepository(
        getProfileProjects: serviceLocator(),
        setProject: serviceLocator(),
        updateProject: serviceLocator(),
        deleteProject: serviceLocator(),
      ));
  serviceLocator
      .registerLazySingleton(() =>
      ProfileProviderExperianceRepository(
        getProfileExperiance: serviceLocator(),
        setNewExperiance: serviceLocator(),
        deleteExperiance: serviceLocator(),
        updateExperiance: serviceLocator(),
      ));
  serviceLocator
      .registerLazySingleton(() => DeleteExperiance(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateExperiance(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ProfileProviderCoursesRepository(
        getProfileCourses: serviceLocator(),
        setCourse: serviceLocator(),
        updateCourse: serviceLocator(),
        deleteCourse: serviceLocator(),
      ));
  serviceLocator
      .registerLazySingleton(() => DeleteCourse(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SetSkill(dio: serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => DeleteSkill(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SetCourse(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateCourse(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ProfileProviderSkillRepository(
        getProfileSkills: serviceLocator(),
        setSkill: serviceLocator(),
        deleteSkill: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(() => ProfileProvierLanguageRepository(
        getProfileLanguage: serviceLocator(),
        setNewLanguage: serviceLocator(),
        deleteLanguage: serviceLocator(),
      ));
  serviceLocator
      .registerLazySingleton(() =>
      ProfileProviderCertificateRepository(
        getProfileCertificate: serviceLocator(),
        setNewCertificate: serviceLocator(),
        deleteCertificate: serviceLocator(),
        updateCertificate: serviceLocator(),
      ));

  serviceLocator
      .registerLazySingleton(() => DeleteLanguage(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetNewLanguage(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteCertificate(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateCertificate(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ProfileProviderRepository(
        getProfileLicenses: serviceLocator(),
        setNewLicense: serviceLocator(),
        deleteLicenses: serviceLocator(),
        upadteLicense: serviceLocator(),
      ));

  serviceLocator
      .registerLazySingleton(() => DeleteLicenses(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpadteLicense(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetNewExperiance(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetNewCertificate(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetNewLicense(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileLanguage(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileCourses(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileSkills(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileExperiance(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() =>
      ProfileProviderEducationsRepository(
          getProfileEducations: serviceLocator(),
          setNewEducation: serviceLocator(),
          deleteEducation: serviceLocator(),
          updateEducations: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DeleteEducation(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateEducations(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetNewEducation(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(
          () => GetProfileCertificate(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileInfo(dio: serviceLocator()));
  serviceLocator.registerLazySingleton(() =>
      GetProfileFollowListInfo(
        dio: serviceLocator(),
      ));
  serviceLocator
      .registerLazySingleton(() => GetProfileLecture(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileProjects(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileLicenses(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProfileEducations(dio: serviceLocator()));

  serviceLocator.registerFactory(
          () => ProfileProviderCoursesBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileProviderLicensesBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileProviderLecturesBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileProviderProjectsBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () =>
          ProfileProviderCertificateBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () =>
          ProfileProviderExperianceBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileProviderSkillsBloc(catalogService: serviceLocator()));
  serviceLocator.registerFactory(
          () => ProfileProviderLanguageBloc(catalogService: serviceLocator()));

  serviceLocator.registerFactory(
          () => RegistrationSocailBloc(catalogService: serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegistrationSocailRepository(
        validateFaceBookToken: serviceLocator(),
        loginWithFaceBook: serviceLocator(),
        loginWithGoogle: serviceLocator(),
        validateGoogleToken: serviceLocator(),
      ));
  serviceLocator.registerLazySingleton(
          () => ValidateFaceBookToken(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LoginWithFaceBook(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LoginWithGoogle(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ValidateGoogleToken(dio: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ReadAllNotification(dio: serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => NotificationRepository(
        getUserNotificationInfo: serviceLocator(),
        readUserNotificationRemoteDataProvider: serviceLocator(),
        readAllNotification: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetUserNotificationInfo(
      dio: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => ReadUserNotificationRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => NotificationBloc(
      catalogFacadeService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => TermsAndConditionsRepository(
      getTermsAndConditions: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetTermsAndConditions(dio: serviceLocator()),
  );

 serviceLocator
      .registerFactory(() => LatestVersionBloc(catalogService: serviceLocator()));
  serviceLocator
      .registerFactory(() => TermsAndConditionBloc(catalogFacadeService: serviceLocator()));
  serviceLocator.registerFactory(() => LatestVersionRepository(getLatestVersion: serviceLocator()));
  serviceLocator.registerFactory(
    () => GetLatestVersion(dio: serviceLocator()),
  );
//getLatestVersion
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(
    () => sharedPreferences,
  );
}



Dio getNetworkObj() {
  BaseOptions options = BaseOptions(
    baseUrl: Urls.BASE_URL,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );
  Dio dio = new Dio(options);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.get(PrefsKeys.TOKEN);
        String lang = prefs.get(PrefsKeys.CULTURE_CODE);
        String fcmId = prefs.get("FcmId");
        if (lang == null) {
          prefs.setString(PrefsKeys.CULTURE_CODE, "en-US");
          options.headers["culture"] = "en-US";
        } else {
          options.headers["culture"] = lang;
        }
        options.headers["ClientType"] = Platform.isAndroid
            ? "Android"
            : Platform.isIOS
                ? "IOS"
                : "Other";
        options.headers["ClientAppVersion"] = "0";
        options.headers["ClientModel"] = "0";
        options.headers["ClientOSVersion"] = "0";
        options.headers["FcmId"] = fcmId != null ? fcmId : "";
        if (token != null) if (token.isNotEmpty)
          options.headers["Authorization"] = "bearer " + token;

        handler.next(options);
      },
    ),
  );
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90));
  return dio;
}
