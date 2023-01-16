import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_licenses/profile_provider_licenses_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/licenses_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/profile_Qualification_show_more_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/profile_provider/licenses/add_licenses_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/licenses/update_licenses_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LicensesShowMoreScreen extends StatefulWidget {
  final bool canMakeUpdate;
  final String userId;
  LicensesShowMoreScreen({@required this.canMakeUpdate, @required this.userId});
  @override
  State<StatefulWidget> createState() {
    return _LicensesShowMore();
  }
}

class _LicensesShowMore extends State<LicensesShowMoreScreen> {
  ProfileProviderLicensesBloc profileProviderLicensesBloc;
  bool isReloadData = false;
  RefreshController controller = RefreshController();
  bool successRequestBefore = false;
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    profileProviderLicensesBloc = serviceLocator<ProfileProviderLicensesBloc>();
    profileProviderLicensesBloc.add(GetAllLicenses(newRequest: true, userId: widget.userId));
  }

  List<LicensesResponse> item = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Color(0XFFEFEFEF),
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).licenses,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        floatingActionButton: (widget.canMakeUpdate)
            ? FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Color(0XFFF65636),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddLicensesScreen()))
                      .then((value) {
                    profileProviderLicensesBloc
                        .add(GetAllLicenses(newRequest: true, userId: widget.userId));
                  });
                })
            : Container(),
        body: BlocProvider<ProfileProviderLicensesBloc>(
          create: (context) => profileProviderLicensesBloc,
          child: BlocListener<ProfileProviderLicensesBloc, ProfileProviderLicensesState>(
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
              }
              if (state.status == ProfileProviderStatus.invalid) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                GlobalPurposeFunctions.showToast(state.message, context);
              } else {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              }
            },
            child: BlocBuilder<ProfileProviderLicensesBloc, ProfileProviderLicensesState>(
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
                        profileProviderLicensesBloc
                            .add(GetAllLicenses(newRequest: true, userId: widget.userId));
                      });
                } else {
                  return showInfo(state);
                }
              },
            ),
          ),
        ));
  }

  Widget showInfo(ProfileProviderLicensesState state) {
    if (state.posts.length == 0)
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            profileProviderLicensesBloc
                .add(GetAllLicenses(newRequest: true, userId: widget.userId));
          });
    item = state.posts;
    return RefreshData(
      refreshController: controller,
      onRefresh: () {
        isReloadData = true;
        profileProviderLicensesBloc.add(GetAllLicenses(newRequest: true, userId: widget.userId));
      },
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.posts.length) return BottomLoader();
          String item = "";
          String file = state.posts[index].fileUrl;
          for (int i = file.length - 1; i >= 0; i--) {
            if (state.posts[index].fileUrl[i] == '.') {
              item = state.posts[index].fileUrl.substring(i);
              break;
            }
          }
          FileResponse fileResponse = FileResponse(
              contentLength: state?.posts[index]?.fileUrl?.length ?? 0,
              contentType: "",
              extension: item ?? "",
              fileType: 0,
              name: state?.posts[index]?.title ?? "",
              url: state?.posts[index]?.fileUrl ?? "",
              id: "0");
          List<FileResponse> list = [fileResponse];
          return ProfileQualificationShowMoreListItem(
            canMakeUpdate: widget.canMakeUpdate,
            titleItemName: AppLocalizations.of(context).license_item_name,
            name: state.posts[index].title,
            itemDetail: state.posts[index].description ?? AppLocalizations.of(context).no_detail,
            files: GlobalPurposeFunctions.fileTypeIsImage(fileExtention: item) ? [] : list,
            imageUrl: GlobalPurposeFunctions.fileTypeIsImage(fileExtention: item)
                ? [state.posts[index].fileUrl]
                : [],
            deleteFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderLicensesBloc.add(DeleteLicenseEvent(
                  index: index, typeId: state.posts[index].id, context: context));
            },
            updateFunction: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UpdateLicesnseScreen(
                    id: state.posts[index].id,
                    licensesItem: state.posts[index],
                    blocFromLastScreen: profileProviderLicensesBloc,
                    index: index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom && !isReloadData) {
      profileProviderLicensesBloc.add(GetAllLicenses(newRequest: false, userId: widget.userId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
