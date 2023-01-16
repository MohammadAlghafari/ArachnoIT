import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_courses/profile_provider_courses_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/profile_Qualification_show_more_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/profile_provider/courses/update_course.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../injections.dart';

import 'add_new_courses.dart';

class CoursesShowMore extends StatefulWidget {
  final bool canMakeUpdate;
  final String userId;
  CoursesShowMore({@required this.canMakeUpdate, @required this.userId});
  @override
  State<StatefulWidget> createState() {
    return _CoursesShowMore();
  }
}

class _CoursesShowMore extends State<CoursesShowMore> {
  ProfileProviderCoursesBloc profileProviderCoursesBloc;
  bool isReloadData = false;
  RefreshController controller = RefreshController();
  final _scrollController = ScrollController();
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    profileProviderCoursesBloc = serviceLocator<ProfileProviderCoursesBloc>();
    profileProviderCoursesBloc.add(GetAllCourses(newRequest: true, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0XFFEFEFEF),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).courses,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      floatingActionButton: widget.canMakeUpdate
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Color(0XFFF65636),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddNewCoursesScreen()))
                    .then((value) {
                  profileProviderCoursesBloc
                      .add(GetAllCourses(newRequest: true, userId: widget.userId));
                });
              })
          : Container(),
      body: BlocProvider<ProfileProviderCoursesBloc>(
        create: (context) => profileProviderCoursesBloc,
        child: BlocListener<ProfileProviderCoursesBloc, ProfileProviderCoursesState>(
          listener: (context, state) {
            if (state.status == ProfileProviderStatus.success) {
              isReloadData = false;
              successRequestBefore = true;
              controller.refreshCompleted();
            } else if (state.status == ProfileProviderStatus.failure) {
              isReloadData = false;
              controller.refreshFailed();
            }
            if (state.status == ProfileProviderStatus.deleteItemSuccess) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).success_delete_item, context);
                Navigator.pop(context);
              });
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderCoursesBloc, ProfileProviderCoursesState>(
            builder: (context, state) {
              if (state.status == ProfileProviderStatus.initial) return LoadingBloc();
              if (state.status == ProfileProviderStatus.loading && !successRequestBefore) {
                if (!successRequestBefore)
                  return LoadingBloc();
                else
                  return showInfo(state);
              } else if (state.status == ProfileProviderStatus.failure) {
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      profileProviderCoursesBloc
                          .add(GetAllCourses(newRequest: true, userId: widget.userId));
                    });
              } else {
                return showInfo(state);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showInfo(ProfileProviderCoursesState state) {
    if (state.posts.length == 0)
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            profileProviderCoursesBloc.add(GetAllCourses(newRequest: true, userId: widget.userId));
          });
    return RefreshData(
      refreshController: controller,
      onRefresh: () {
        isReloadData = true;
        profileProviderCoursesBloc.add(GetAllCourses(newRequest: true, userId: widget.userId));
      },
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.posts.length) return BottomLoader();

          List<FileResponse> files = [];
          List<String> imageUrl = [];
          List<AttachmentResponse> arrayItems = state?.posts[index]?.attachments ?? [];
          for (AttachmentResponse item in arrayItems) {
            if (GlobalPurposeFunctions.fileTypeIsImage(fileExtention: item.extension))
              imageUrl.add(item.url);
            else
              files.add(FileResponse(
                  contentLength: item?.contentLength ?? 0,
                  contentType: item?.contentType ?? "",
                  extension: item?.extension ?? "",
                  fileType: item?.fileType ?? "",
                  id: item?.id ?? "",
                  name: item?.name ?? "",
                  url: item?.url ?? "",
                  localeImage: ""));
          }

          return ProfileQualificationShowMoreListItem(
            titleItemName: AppLocalizations.of(context).courses_item_name,
            name: state.posts[index].name,
            itemDetail: state.posts[index]?.place ?? "",
            duration: '',
            canMakeUpdate: widget.canMakeUpdate,
            files: files ?? [],
            videosList: [],
            imageUrl: imageUrl ?? [],
            updateFunction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdateCourse(
                        bloc: profileProviderCoursesBloc,
                        course: state.posts[index],
                        index: index,
                      )));
            },
            deleteFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderCoursesBloc.add(
                  DeleteCourseEvent(context: context, id: state.posts[index].id, index: index));
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom && !isReloadData) {
      profileProviderCoursesBloc.add(GetAllCourses(newRequest: false, userId: widget.userId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
