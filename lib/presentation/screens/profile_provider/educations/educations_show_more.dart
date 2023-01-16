import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_education/profile_provider_education_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/profile_Qualification_show_more_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/profile_provider/educations/add_educations_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/educations/update_education.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EducatiosShowMore extends StatefulWidget {
  final bool canMakeUpdate;
  final String userId;
  EducatiosShowMore({@required this.canMakeUpdate, @required this.userId});
  @override
  State<StatefulWidget> createState() {
    return _EducatiosShowMore();
  }
}

class _EducatiosShowMore extends State<EducatiosShowMore> {
  ProfileProviderEducationBloc profileProviderEducationBloc;
  final _scrollController = ScrollController();
  RefreshController controller = RefreshController();
  bool isReloadData = false;

  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    profileProviderEducationBloc = serviceLocator<ProfileProviderEducationBloc>();
    profileProviderEducationBloc.add(GetAllEducation(newRequest: true, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Color(0XFFEFEFEF),
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).educations,
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
                      .push(MaterialPageRoute(builder: (context) => AddEducationsScreen()))
                      .then((value) {
                    profileProviderEducationBloc
                        .add(GetAllEducation(newRequest: true, userId: widget.userId));
                  });
                })
            : Container(),
        body: BlocProvider<ProfileProviderEducationBloc>(
          create: (context) => profileProviderEducationBloc,
          child: BlocListener<ProfileProviderEducationBloc, ProfileProviderEducationState>(
            listener: (context, state) {
              if (state.status == ProfileProviderStatus.success) {
                successRequestBefore = true;
                isReloadData = false;
                controller.refreshCompleted();
              } else if (state.status == ProfileProviderStatus.failure) {
                isReloadData = false;
                controller.refreshFailed();
              }
              if (state.status == ProfileProviderStatus.deleteItemSuccess) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                  Navigator.pop(context);
                });
              } else if (state.status == ProfileProviderStatus.invalid) {
                GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).check_your_internet_connection, context);
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              } else {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              }
            },
            child: BlocBuilder<ProfileProviderEducationBloc, ProfileProviderEducationState>(
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
                        profileProviderEducationBloc
                            .add(GetAllEducation(newRequest: true, userId: widget.userId));
                      });
                } else {
                  return showInfo(state);
                }
              },
            ),
          ),
        ));
  }

  Widget showInfo(ProfileProviderEducationState state) {
    if (state.posts.length == 0)
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            profileProviderEducationBloc
                .add(GetAllEducation(newRequest: true, userId: widget.userId));
          });
    return RefreshData(
      onRefresh: () {
        isReloadData = true;
        profileProviderEducationBloc.add(GetAllEducation(newRequest: true, userId: widget.userId));
      },
      refreshController: controller,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.posts.length) return BottomLoader();

          List<FileResponse> files = [];
          List<String> imageUrl = [];
          List<AttachmentResponse> arrayOfItems = state?.posts[index]?.attachments ?? [];
          for (AttachmentResponse item in arrayOfItems) {
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
            titleItemName: AppLocalizations.of(context).educations_item_name,
            name: state.posts[index].fieldOfStudy,
            canMakeUpdate: widget.canMakeUpdate,
            itemDetail: state.posts[index].description ?? AppLocalizations.of(context).no_detail,
            duration: DateFormat('yyyy-MM-dd').format(state.posts[index].startDate),
            files: files,
            imageUrl: imageUrl,
            updateFunction: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateEducationScreen(
                    bloc: profileProviderEducationBloc,
                    id: state.posts[index].id,
                    index: index,
                    response: state.posts[index],
                  ),
                ),
              );
            },
            deleteFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderEducationBloc.add(DeleteEducationEvent(
                index: index,
                typeId: state.posts[index].id,
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
      profileProviderEducationBloc.add(GetAllEducation(newRequest: false, userId: widget.userId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
