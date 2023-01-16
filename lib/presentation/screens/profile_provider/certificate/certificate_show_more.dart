import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_cerificate/profile_provider_certificate_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/profile_Qualification_show_more_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/profile_provider/certificate/add_certificate_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/certificate/update_certificate_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../infrastructure/common_response/attachment_response.dart';

class CertificateShowMoreScreen extends StatefulWidget {
  final bool canMakeUpdate;
  final String userId;
  CertificateShowMoreScreen({@required this.canMakeUpdate, @required this.userId});
  @override
  State<StatefulWidget> createState() {
    return _CertificateShowMore();
  }
}

class _CertificateShowMore extends State<CertificateShowMoreScreen> {
  ProfileProviderCertificateBloc profileProviderCertificateBloc;
  RefreshController controller = RefreshController();
  final _scrollController = ScrollController();
  bool isReloadData = false;
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    profileProviderCertificateBloc = serviceLocator<ProfileProviderCertificateBloc>();
    profileProviderCertificateBloc.add(GetAllCertificate(newRequest: true, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Color(0XFFEFEFEF),
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).certificate,
            style: mediumMontserrat(color: Colors.black, fontSize: 18),
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
                      .push(MaterialPageRoute(builder: (context) => AddNewCertificateScreen()))
                      .then((value) {
                    profileProviderCertificateBloc
                        .add(GetAllCertificate(newRequest: true, userId: widget.userId));
                  });
                })
            : Container(),
        body: BlocProvider<ProfileProviderCertificateBloc>(
          create: (context) => profileProviderCertificateBloc,
          child: BlocListener<ProfileProviderCertificateBloc, ProfileProviderCertificateState>(
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
                });
              } else if (state.status == ProfileProviderStatus.invalid) {
                GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).check_your_internet_connection, context);
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              } else {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              }
            },
            child: BlocBuilder<ProfileProviderCertificateBloc, ProfileProviderCertificateState>(
              builder: (context, state) {
                if (state.status == ProfileProviderStatus.initial) return LoadingBloc();

                if (state.status == ProfileProviderStatus.loading && !successRequestBefore) {
                  if (!successRequestBefore)
                    return LoadingBloc();
                  else
                    return showItem(state);
                } else if (state.status == ProfileProviderStatus.failure) {
                  if (state.posts.length > 0) return showItem(state);

                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.userError,
                      function: () {
                        profileProviderCertificateBloc
                            .add(GetAllCertificate(newRequest: true, userId: widget.userId));
                      });
                } else {
                  return showItem(state);
                }
              },
            ),
          ),
        ));
  }

  Widget showItem(ProfileProviderCertificateState state) {
    if (state.posts.length == 0)
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            profileProviderCertificateBloc
                .add(GetAllCertificate(newRequest: true, userId: widget.userId));
          });

    return RefreshData(
      refreshController: controller,
      onRefresh: () {
        isReloadData = true;
        profileProviderCertificateBloc
            .add(GetAllCertificate(newRequest: true, userId: widget.userId));
      },
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.posts.length) return BottomLoader();

          List<FileResponse> files = [];
          List<String> imageUrl = [];
          List<AttachmentResponse> item = state?.posts[index]?.attachments ?? [];
          for (AttachmentResponse it in item) {
            if (GlobalPurposeFunctions.fileTypeIsImage(fileExtention: it.extension)) {
              imageUrl.add(it.url);
            } else
              files.add(FileResponse(
                  contentLength: it?.contentLength ?? 0,
                  contentType: it?.contentType ?? "",
                  extension: it?.extension ?? "",
                  fileType: it?.fileType ?? "",
                  id: it?.id ?? "",
                  name: it?.name ?? "",
                  url: it?.url ?? "",
                  localeImage: ""));
          }

          return ProfileQualificationShowMoreListItem(
            titleItemName: AppLocalizations.of(context).license_item_name,
            canMakeUpdate: widget.canMakeUpdate,
            name: state.posts[index].name,
            itemDetail: AppLocalizations.of(context).no_detail,
            duration: DateFormat('yyyy-MM-dd').format(state.posts[index].issueDate),
            files: files,
            imageUrl: imageUrl,
            updateFunction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdateCertificateScreen(
                        blocFromLastScreen: profileProviderCertificateBloc,
                        certificateItem: state.posts[index],
                        id: state.posts[index].id,
                        index: index,
                      )));
            },
            deleteFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderCertificateBloc.add(DeleteCertificateEvent(
                  index: index, typeId: state.posts[index].id, context: context));
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom && !isReloadData) {
      profileProviderCertificateBloc
          .add(GetAllCertificate(newRequest: false, userId: widget.userId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
