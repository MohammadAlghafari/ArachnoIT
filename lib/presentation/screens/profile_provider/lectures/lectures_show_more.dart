import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_lectures/profile_provider_lectures_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/profile_Qualification_show_more_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/profile_provider/lectures/add_lecture_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/lectures/update_lectures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LecturesShowMore extends StatefulWidget {
  final bool canMakeUpdate;
  final String userId;
  LecturesShowMore({@required this.canMakeUpdate, @required this.userId});
  @override
  State<StatefulWidget> createState() {
    return _LecturesShowMore();
  }
}

class _LecturesShowMore extends State<LecturesShowMore> {
  ProfileProviderLecturesBloc profileProviderLecturesBloc;
  bool isReloadData = false;
  RefreshController controller = RefreshController();
  final _scrollController = ScrollController();
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    profileProviderLecturesBloc = serviceLocator<ProfileProviderLecturesBloc>();
    profileProviderLecturesBloc.add(GetAllLectures(newRequest: true, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Color(0XFFEFEFEF),
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).lectures,
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
                      .push(
                        MaterialPageRoute(builder: (context) => AddLectureScreen()),
                      )
                      .then((value) => {
                            profileProviderLecturesBloc
                                .add(GetAllLectures(newRequest: true, userId: widget.userId))
                          });
                })
            : Container(),
        body: BlocProvider<ProfileProviderLecturesBloc>(
          create: (context) => profileProviderLecturesBloc,
          child: BlocListener<ProfileProviderLecturesBloc, ProfileProviderLecturesState>(
            listener: (context, state) {
              if (state.status == ProfileProviderStatus.success) {
                isReloadData = false;
                controller.refreshCompleted();
                successRequestBefore = true;
              } else if (state.status == ProfileProviderStatus.failure) {
                isReloadData = false;
                controller.refreshFailed();
              }
              if (state.status == ProfileProviderStatus.deleteItemSuccess) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                  Navigator.pop(context);
                  GlobalPurposeFunctions.showToast(
                      AppLocalizations.of(context).success_delete_item, context);
                });
              } else {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              }
            },
            child: BlocBuilder<ProfileProviderLecturesBloc, ProfileProviderLecturesState>(
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
                        profileProviderLecturesBloc
                            .add(GetAllLectures(newRequest: true, userId: widget.userId));
                      });
                } else {
                  return showInfo(state);
                }
              },
            ),
          ),
        ));
  }

  Widget showInfo(ProfileProviderLecturesState state) {
    if (state.posts.length == 0)
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            profileProviderLecturesBloc
                .add(GetAllLectures(newRequest: true, userId: widget.userId));
          });
    return RefreshData(
      refreshController: controller,
      onRefresh: () {
        isReloadData = true;
        profileProviderLecturesBloc.add(GetAllLectures(newRequest: true, userId: widget.userId));
      },
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.posts.length) return BottomLoader();
          List<FileResponse> files = [];
          List<String> image = [];
          List<String> imageUrl = [];
          List<AttachmentResponse> arrayItems = state?.posts[index]?.attachments ?? [];
          for (AttachmentResponse item in arrayItems) {
            if (GlobalPurposeFunctions.fileTypeIsImage(fileExtention: item.extension))
              imageUrl.add(item.url);
            else if (GlobalPurposeFunctions.fileTypeIsVideo(fileExtention: item.extension))
              image.add(item.url);
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
            canMakeUpdate: widget.canMakeUpdate,
            titleItemName: AppLocalizations.of(context).license_item_name,
            name: state.posts[index].title,
            itemDetail: state.posts[index].description ?? AppLocalizations.of(context).no_detail,
            files: [],
            imageUrl: imageUrl,
            videosList: image,
            updateFunction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdateLecturesScreen(
                        bloc: profileProviderLecturesBloc,
                        item: state.posts[index],
                        index: index,
                      )));
            },
            deleteFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderLecturesBloc.add(DeleteSelectedItem(
                index: index,
                itemId: state.posts[index].id,
                context: context,
              ));
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom && !isReloadData) {
      profileProviderLecturesBloc.add(GetAllLectures(newRequest: false, userId: widget.userId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
