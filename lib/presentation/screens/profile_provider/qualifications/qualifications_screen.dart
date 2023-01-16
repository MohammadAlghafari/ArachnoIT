import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_cerificate/profile_provider_certificate_bloc.dart';
import 'package:arachnoit/application/profile_provider_courses/profile_provider_courses_bloc.dart';
import 'package:arachnoit/application/profile_provider_education/profile_provider_education_bloc.dart';
import 'package:arachnoit/application/profile_provider_experiance/profile_provider_experiance_bloc.dart';
import 'package:arachnoit/application/profile_provider_language/profile_provider_language_bloc.dart';
import 'package:arachnoit/application/profile_provider_lectures/profile_provider_lectures_bloc.dart';
import 'package:arachnoit/application/profile_provider_licenses/profile_provider_licenses_bloc.dart';
import 'package:arachnoit/application/profile_provider_projects/profile_provider_projects_bloc.dart';
import 'package:arachnoit/application/profile_provider_skills/profile_provider_skills_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/language.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/profile_provider/certificate/certificate_show_more.dart';
import 'package:arachnoit/presentation/screens/profile_provider/courses/courses_show_more.dart';
import 'package:arachnoit/presentation/screens/profile_provider/educations/educations_show_more.dart';
import 'package:arachnoit/presentation/screens/profile_provider/experiance/experiance_show_more_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/language/language_show_more.dart';
import 'package:arachnoit/presentation/screens/profile_provider/lectures/lectures_show_more.dart';
import 'package:arachnoit/presentation/screens/profile_provider/licenses/licenses_show_more.dart';
import 'package:arachnoit/presentation/screens/profile_provider/projects/projects_show_more_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/skills/skills_show_more.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_catagory_item_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QualificationsTab extends StatefulWidget {
  final ScrollController controller;
  final String userId;
  static const routeName = '/Media_Tab_Profile';

  const QualificationsTab({@required this.controller, @required this.userId});

  @override
  _CollapsingTabState createState() => new _CollapsingTabState();
}

class _CollapsingTabState extends State<QualificationsTab> with AutomaticKeepAliveClientMixin {
  bool containerQualification = false;
  ProfileInfoResponse profileInfo = ProfileInfoResponse();
  ProfileProviderLecturesBloc profileProviderLecturesBloc;
  HealthCareProviderProfileDto provider;
  ProfileProviderProjectsBloc profileProviderProjectsBloc;
  ProfileProviderLicensesBloc profileProviderLicensesBloc;
  ProfileProviderCertificateBloc profileProviderCertificateBloc;
  ProfileProviderExperianceBloc profileProviderExperianceBloc;
  ProfileProviderEducationBloc profileProviderEducationBloc;
  ProfileProviderCoursesBloc profileProviderCoursesBloc;
  ProfileProviderSkillsBloc profileProviderSkillsBloc;
  ProfileProviderLanguageBloc profileProviderLanguageBloc;
  ProfileProviderBloc profileProviderBloc;
  @override
  void initState() {
    super.initState();
    profileProviderBloc = serviceLocator<ProfileProviderBloc>();
    profileProviderBloc.add(GetProfileInfoEvent(userId: widget.userId));
    profileProviderLecturesBloc = serviceLocator<ProfileProviderLecturesBloc>();
    profileProviderLicensesBloc = serviceLocator<ProfileProviderLicensesBloc>();
    profileProviderCertificateBloc = serviceLocator<ProfileProviderCertificateBloc>();
    profileProviderExperianceBloc = serviceLocator<ProfileProviderExperianceBloc>();
    profileProviderProjectsBloc = serviceLocator<ProfileProviderProjectsBloc>();
    profileProviderEducationBloc = serviceLocator<ProfileProviderEducationBloc>();
    profileProviderCoursesBloc = serviceLocator<ProfileProviderCoursesBloc>();
    profileProviderSkillsBloc = serviceLocator<ProfileProviderSkillsBloc>();
    profileProviderLanguageBloc = serviceLocator<ProfileProviderLanguageBloc>();
  }

  void initalRequest() {
    profileProviderLecturesBloc = serviceLocator<ProfileProviderLecturesBloc>();
    profileProviderLicensesBloc = serviceLocator<ProfileProviderLicensesBloc>();
    profileProviderCertificateBloc = serviceLocator<ProfileProviderCertificateBloc>();
    profileProviderExperianceBloc = serviceLocator<ProfileProviderExperianceBloc>();
    profileProviderProjectsBloc = serviceLocator<ProfileProviderProjectsBloc>();
    profileProviderEducationBloc = serviceLocator<ProfileProviderEducationBloc>();
    profileProviderCoursesBloc = serviceLocator<ProfileProviderCoursesBloc>();
    profileProviderSkillsBloc = serviceLocator<ProfileProviderSkillsBloc>();
    profileProviderLanguageBloc = serviceLocator<ProfileProviderLanguageBloc>();
    if (provider.hasLectures) {
      containerQualification = true;
      profileProviderLecturesBloc.add(GetAllLectures(newRequest: true, userId: widget.userId));
    }
    if (provider.hasLicenses) {
      containerQualification = true;
      profileProviderLicensesBloc.add(GetAllLicenses(newRequest: true, userId: widget.userId));
    }
    if (provider.hasCertificates) {
      containerQualification = true;
      profileProviderCertificateBloc
          .add(GetAllCertificate(newRequest: true, userId: widget.userId));
    }
    if (provider.hasExperiences) {
      profileProviderExperianceBloc.add(GetALlExperiance(newRequest: true, userId: widget.userId));
      containerQualification = true;
    }
    if (provider.hasProjects) {
      containerQualification = true;
      profileProviderProjectsBloc.add(GetAllProjects(newRequest: true, userId: widget.userId));
    }
    if (provider.hasEducations) {
      containerQualification = true;
      profileProviderEducationBloc.add(GetAllEducation(newRequest: true, userId: widget.userId));
    }
    if (provider.hasCourses) {
      containerQualification = true;
      profileProviderCoursesBloc.add(GetAllCourses(newRequest: true, userId: widget.userId));
    }
    if (provider.hasSkills) {
      containerQualification = true;
      profileProviderSkillsBloc.add(GetAllSkills(newRequest: true, userId: widget.userId));
    }
    if (provider.hasLanguageSkills) {
      containerQualification = true;
      profileProviderLanguageBloc
          .add(GetAllLanguage(newRequest: true, userId: widget.userId, context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        floatingActionButton: (GlobalPurposeFunctions.isProfileOwner(widget.userId))
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddCategoryItem.routeName).then((value) {
                    profileProviderBloc.add(GetProfileInfoEvent(userId: widget.userId));
                  });
                },
                backgroundColor: Color(0XFFF65636),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            : Container(),
        body: BlocProvider<ProfileProviderBloc>(
          create: (context) => profileProviderBloc,
          child: BlocListener<ProfileProviderBloc, ProfileProviderState>(
            listener: (context, state) {
              if (state is SuccessGetProviderProfile) {
                profileInfo = state.profileInfoResponse;
                provider = state.profileInfoResponse.healthcareProviderProfileDto;
                initalRequest();
              }
            },
            child: BlocBuilder<ProfileProviderBloc, ProfileProviderState>(
              builder: (context, state) {
                if (state is LoadingProviderInfo) {
                  return LoadingBloc();
                } else if (state is RemoteUserProviderServerErrorState) {
                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.serverError,
                      function: () {
                        profileProviderBloc.add(GetProfileInfoEvent(userId: widget.userId));
                      });
                } else if (state is RemoteUserClientErrorState) {
                  return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      profileProviderBloc.add(GetProfileInfoEvent(userId: widget.userId));
                    },
                  );
                } else if (state is SuccessGetProviderProfile) {
                  return containerQualification
                      ? SingleChildScrollView(
                          child: Column(
                          children: [
                            (provider.hasLicenses) ? showLicenses() : Container(),
                            (provider.hasLectures) ? showlectures() : Container(),
                            (provider.hasCertificates) ? showCertificate() : Container(),
                            (provider.hasExperiences) ? showExperiance() : Container(),
                            (provider.hasProjects) ? showProjects() : Container(),
                            (provider.hasEducations) ? showEducatios() : Container(),
                            (provider.hasCourses) ? showCourses() : Container(),
                            (provider.hasSkills) ? showSkills() : Container(),
                            (provider.hasLanguageSkills) ? showLanguage() : Container(),
                          ],
                        ))
                      : BlocError(
                          blocErrorState: BlocErrorState.noPosts,
                          context: context,
                          function: () {},
                          errorTitle: AppLocalizations.of(context)
                              .this_health_care_provider_did_not_add_any_skills,
                        );
                } else
                  return Container(
                    color: Colors.yellow,
                  );
              },
            ),
          ),
        ));
  }

  Widget showLanguage() {
    CommonLanguage commonLanguage = CommonLanguage(context);
    return BlocProvider<ProfileProviderLanguageBloc>(
      create: (context) => profileProviderLanguageBloc,
      child: BlocBuilder<ProfileProviderLanguageBloc, ProfileProviderLanguageState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).language_skills,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
              body: BlocError(
                  context: context,
                  iconData: Icons.replay_outlined,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    profileProviderLanguageBloc.add(
                        GetAllLanguage(newRequest: true, userId: widget.userId, context: context));
                  },
                  errorTitle: AppLocalizations.of(context).error_happened_try_again),
              title: AppLocalizations.of(context).language_skills,
              isLoadingData: false,
            );
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(
                              state.posts[index].englishName,
                              commonLanguage.getLevelNameByID(state.posts[index].languageLevel),
                              ProfileProviderAddItemIcons.languages);
                        }),
                    title: AppLocalizations.of(context).language_skills,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => LanguageShowMore(
                                    canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                        profileInfo.healthcareProviderProfileDto.id),
                                    userId: widget.userId,
                                  )))
                          .then((value) {
                        profileProviderLanguageBloc.add(GetAllLanguage(
                            newRequest: true, userId: widget.userId, context: context));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showSkills() {
    return BlocProvider<ProfileProviderSkillsBloc>(
      create: (context) => profileProviderSkillsBloc,
      child: BlocBuilder<ProfileProviderSkillsBloc, ProfileProviderSkillsState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).skills,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
              body: BlocError(
                iconData: Icons.replay_outlined,
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  profileProviderSkillsBloc
                      .add(GetAllSkills(newRequest: true, userId: widget.userId));
                },
              ),
              title: AppLocalizations.of(context).skills,
              isLoadingData: false,
            );
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(state.posts[index].name,
                              state.posts[index].description, ProfileProviderAddItemIcons.skills);
                        }),
                    title: AppLocalizations.of(context).skills,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => SkillsShowMoreScreen(
                                  canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                      profileInfo.healthcareProviderProfileDto.id),
                                  userId: widget.userId)))
                          .then((value) {
                        profileProviderSkillsBloc
                            .add(GetAllSkills(newRequest: true, userId: widget.userId));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showCourses() {
    return BlocProvider<ProfileProviderCoursesBloc>(
      create: (context) => profileProviderCoursesBloc,
      child: BlocBuilder<ProfileProviderCoursesBloc, ProfileProviderCoursesState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).courses,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
              body: BlocError(
                iconData: Icons.replay_outlined,
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  profileProviderCoursesBloc
                      .add(GetAllCourses(newRequest: true, userId: widget.userId));
                },
              ),
              title: AppLocalizations.of(context).courses,
              isLoadingData: false,
            );
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(state.posts[index].name,
                              state.posts[index].place, ProfileProviderAddItemIcons.courses);
                        }),
                    title: AppLocalizations.of(context).courses,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => CoursesShowMore(
                                  canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                      profileInfo.healthcareProviderProfileDto.id),
                                  userId: widget.userId)))
                          .then((value) {
                        profileProviderCoursesBloc
                            .add(GetAllCourses(newRequest: true, userId: widget.userId));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showEducatios() {
    return BlocProvider<ProfileProviderEducationBloc>(
      create: (context) => profileProviderEducationBloc,
      child: BlocBuilder<ProfileProviderEducationBloc, ProfileProviderEducationState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).educations,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
              body: BlocError(
                iconData: Icons.replay_outlined,
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  profileProviderEducationBloc
                      .add(GetAllEducation(newRequest: true, userId: widget.userId));
                },
              ),
              title: AppLocalizations.of(context).educations,
              isLoadingData: false,
            );
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(
                              state.posts[index].school,
                              state.posts[index].description,
                              ProfileProviderAddItemIcons.educations);
                        }),
                    title: AppLocalizations.of(context).educations,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => EducatiosShowMore(
                                  canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                      profileInfo.healthcareProviderProfileDto.id),
                                  userId: widget.userId)))
                          .then((value) {
                        profileProviderEducationBloc
                            .add(GetAllEducation(newRequest: true, userId: widget.userId));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showProjects() {
    return BlocProvider<ProfileProviderProjectsBloc>(
      create: (context) => profileProviderProjectsBloc,
      child: BlocBuilder<ProfileProviderProjectsBloc, ProfileProviderProjectsState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).projects,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
              body: BlocError(
                context: context,
                iconData: Icons.replay_outlined,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  profileProviderProjectsBloc
                      .add(GetAllProjects(newRequest: true, userId: widget.userId));
                },
                errorTitle: AppLocalizations.of(context).error_happened_try_again,
              ),
              title: AppLocalizations.of(context).projects,
              isLoadingData: false,
            );
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(
                              state?.posts[index]?.name ?? "",
                              state?.posts[index]?.description ?? "",
                              ProfileProviderAddItemIcons.projects);
                        }),
                    title: AppLocalizations.of(context).projects,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ProjectsShowMore(
                                  canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                      profileInfo.healthcareProviderProfileDto.id),
                                  userId: widget.userId)))
                          .then((value) {
                        profileProviderProjectsBloc
                            .add(GetAllProjects(newRequest: true, userId: widget.userId));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showExperiance() {
    return BlocProvider<ProfileProviderExperianceBloc>(
      create: (context) => profileProviderExperianceBloc,
      child: BlocBuilder<ProfileProviderExperianceBloc, ProfileProviderExperianceState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).experience,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
              body: BlocError(
                iconData: Icons.replay_outlined,
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  profileProviderExperianceBloc
                      .add(GetALlExperiance(newRequest: true, userId: widget.userId));
                },
                errorTitle: AppLocalizations.of(context).error_happened_try_again,
              ),
              title: AppLocalizations.of(context).experience,
              isLoadingData: false,
            );
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(
                              state.posts[index].title,
                              state.posts[index].description,
                              ProfileProviderAddItemIcons.experiance);
                        }),
                    title: AppLocalizations.of(context).experience,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ExperianceShowMoreScreen(
                                  canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                      profileInfo.healthcareProviderProfileDto.id),
                                  userId: widget.userId)))
                          .then((value) {
                        profileProviderExperianceBloc
                            .add(GetALlExperiance(newRequest: true, userId: widget.userId));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showCertificate() {
    return BlocProvider<ProfileProviderCertificateBloc>(
      create: (context) => profileProviderCertificateBloc,
      child: BlocBuilder<ProfileProviderCertificateBloc, ProfileProviderCertificateState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).certificate,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
              body: BlocError(
                context: context,
                blocErrorState: BlocErrorState.userError,
                iconData: Icons.replay_outlined,
                function: () {
                  profileProviderCertificateBloc
                      .add(GetAllCertificate(newRequest: true, userId: widget.userId));
                },
              ),
              title: AppLocalizations.of(context).certificate,
              isLoadingData: false,
            );
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(
                              state.posts[index].name,
                              state.posts[index].organization,
                              ProfileProviderAddItemIcons.certificates);
                        }),
                    title: AppLocalizations.of(context).certificate,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => CertificateShowMoreScreen(
                                  canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                      profileInfo.healthcareProviderProfileDto.id),
                                  userId: widget.userId)))
                          .then((value) {
                        profileProviderCertificateBloc
                            .add(GetAllCertificate(newRequest: true, userId: widget.userId));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showlectures() {
    return BlocProvider<ProfileProviderLecturesBloc>(
      create: (context) => profileProviderLecturesBloc,
      child: BlocBuilder<ProfileProviderLecturesBloc, ProfileProviderLecturesState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              navigatorFunction: () {},
              isLoadingData: true,
              title: AppLocalizations.of(context).lectures,
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return _QualificationsListItem(
                body: BlocError(
                  context: context,
                  iconData: Icons.replay_outlined,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    profileProviderLecturesBloc
                        .add(GetAllLectures(newRequest: true, userId: widget.userId));
                  },
                ),
                isLoadingData: false,
                title: AppLocalizations.of(context).lectures);
          } else
            return (state.posts.length == 0)
                ? Container()
                : _QualificationsListItem(
                    body: ListView.builder(
                        itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                        padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return showLecturesListItem(
                              state.posts[index].title,
                              state.posts[index].description,
                              ProfileProviderAddItemIcons.lecturesKey);
                        }),
                    title: AppLocalizations.of(context).lectures,
                    navigatorFunction: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => LecturesShowMore(
                                  canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                      profileInfo.healthcareProviderProfileDto.id),
                                  userId: widget.userId)))
                          .then((value) {
                        profileProviderLecturesBloc
                            .add(GetAllLectures(newRequest: true, userId: widget.userId));
                      });
                    },
                    isLoadingData: false,
                  );
        },
      ),
    );
  }

  Widget showLicenses() {
    return BlocProvider<ProfileProviderLicensesBloc>(
      create: (context) => profileProviderLicensesBloc,
      child: BlocBuilder<ProfileProviderLicensesBloc, ProfileProviderLicensesState>(
        builder: (context, state) {
          if (state.status == ProfileProviderStatus.loading) {
            return _QualificationsListItem(
              isLoadingData: true,
              title: AppLocalizations.of(context).licenses,
              navigatorFunction: () {},
            );
          } else if (state.status == ProfileProviderStatus.failure) {
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.userError,
              iconData: Icons.replay_outlined,
              function: () {
                profileProviderLicensesBloc
                    .add(GetAllLicenses(newRequest: true, userId: widget.userId));
              },
            );
          }
          return (state.posts.length == 0)
              ? Container()
              : _QualificationsListItem(
                  navigatorFunction: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => LicensesShowMoreScreen(
                                canMakeUpdate: GlobalPurposeFunctions.isProfileOwner(
                                    profileInfo.healthcareProviderProfileDto.id),
                                userId: widget.userId)))
                        .then((value) {
                      profileProviderLicensesBloc
                          .add(GetAllLicenses(newRequest: true, userId: widget.userId));
                    });
                  },
                  body: (state.posts.length == 0)
                      ? Container()
                      : ListView.builder(
                          itemCount: (state.posts.length > 2) ? 2 : state.posts.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String item = "";
                            String file = state.posts[index].fileUrl;
                            for (int i = file.length - 1; i >= 0; i--) {
                              if (state.posts[index].fileUrl[i] == '.') {
                                item = state.posts[index].fileUrl.substring(i);
                                break;
                              }
                            }
                            return showLicensesListItem(state.posts[index].title,
                                state.posts[index].description, item, state.posts[index].fileUrl);
                          }),
                  isLoadingData: false,
                  title: AppLocalizations.of(context).licenses,
                );
        },
      ),
    );
  }

  Widget showLicensesListItem(String title, String description, String extention, String url) {
    return (extention == ".jpg" || extention == ".png" || extention == ".jpeg")
        ? Stack(fit: StackFit.loose, alignment: Alignment.center, children: [
            Container(
              padding: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
              margin: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: Colors.transparent,
              ),
              height: 263.0,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: _handleFileType(fileExtention: extention, url: url)),
            ),
            Container(
              height: 253.0,
              padding: EdgeInsets.only(right: 12, left: 12, top: 0, bottom: 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: [
                        0.0,
                        1.0,
                      ])),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          description ?? "",
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ])
        : InkWell(
            onTap: () {
              GlobalPurposeFunctions.downloadFile(url, title);
            },
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(right: 30, left: 30, top: 0, bottom: 10),
                    margin: EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.transparent,
                    ),
                    height: 170.0,
                    width: MediaQuery.of(context).size.width,
                    child: GlobalPurposeFunctions.handleFileTypeIcon(
                        context: context, fileExtension: extention, fileUrl: url)),
                Text(
                  description ?? "",
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
                )
              ],
            ),
          );
  }

  Widget showLecturesListItem(String title, String description, String svgPath) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                ProfileProviderAddItemIcons.getIconByKeyValue(
                  key: svgPath,
                ),
              ),
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color)),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      subtitle: Text(
        description,
        style: TextStyle(color: Color(0XFFC4C4C4), fontSize: 16),
      ),
    );
  }

  Widget _handleFileType({String fileExtention, String url}) {
    switch (fileExtention) {
      case '.jpg':
      case '.png':
      case '.jpeg':
        return ChachedNetwrokImageView(
          imageUrl: url,
          autoWidthAndHeigh: true,
        );
      case '.pdf':
      case '.doc':
      case '.docx':
      case 'pps':
      case 'ppt':
      case 'pptx':
      case 'xls':
      case 'xlsx':
      case 'tiff':
      case 'gif':
      case 'odf':
      case 'otf':
        return Container();
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _QualificationsListItem extends StatelessWidget {
  final Function navigatorFunction;
  final Widget body;
  final bool isLoadingData;
  final String title;
  _QualificationsListItem({
    this.isLoadingData,
    this.navigatorFunction,
    this.body,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 40,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.person_pin_sharp,
                color: Color(0XFFF65535),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(color: Color(0XFFF65535), fontSize: 18),
              )
            ],
          ),
          (!isLoadingData) ? body : LoadingBloc(),
          if (!isLoadingData)
            Center(
              child: TextButton(
                child: Text(AppLocalizations.of(context).show_more),
                onPressed: navigatorFunction,
              ),
            )
        ],
      ),
    );
  }
}
