import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_language/profile_provider_language_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/language.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/profile_Qualification_show_more_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/profile_provider/language/add_language_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/language/update_current_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LanguageShowMore extends StatefulWidget {
  final bool canMakeUpdate;
  final String userId;
  LanguageShowMore({@required this.canMakeUpdate, @required this.userId});
  @override
  State<StatefulWidget> createState() {
    return _LanguageShowMore();
  }
}

class _LanguageShowMore extends State<LanguageShowMore> {
  ProfileProviderLanguageBloc profileProviderLanguageBloc;
  RefreshController controller = RefreshController();
  final _scrollController = ScrollController();
  bool isReloadData = false;
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    profileProviderLanguageBloc = serviceLocator<ProfileProviderLanguageBloc>();
    profileProviderLanguageBloc
        .add(GetAllLanguage(newRequest: true, userId: widget.userId, context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0XFFEFEFEF),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).language,
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
                    .push(MaterialPageRoute(
                        builder: (context) => AddLanguageScreen(userId: widget.userId)))
                    .then((value) {
                  profileProviderLanguageBloc.add(
                      GetAllLanguage(newRequest: true, userId: widget.userId, context: context));
                });
              })
          : Container(),
      body: BlocProvider<ProfileProviderLanguageBloc>(
        create: (context) => profileProviderLanguageBloc,
        child: BlocListener<ProfileProviderLanguageBloc, ProfileProviderLanguageState>(
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
            } else if (state.status == ProfileProviderStatus.failedDelete) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                GlobalPurposeFunctions.showToast(state.errorMessage, context);
              });
            }
          },
          child: BlocBuilder<ProfileProviderLanguageBloc, ProfileProviderLanguageState>(
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
                      profileProviderLanguageBloc.add(GetAllLanguage(
                          newRequest: true, userId: widget.userId, context: context));
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

  Widget showInfo(ProfileProviderLanguageState state) {
    if (state.posts.length == 0)
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            profileProviderLanguageBloc
                .add(GetAllLanguage(newRequest: true, userId: widget.userId, context: context));
          });
    CommonLanguage commonLanguage = CommonLanguage(context);
    return RefreshData(
      onRefresh: () {
        isReloadData = true;
        profileProviderLanguageBloc
            .add(GetAllLanguage(newRequest: true, userId: widget.userId, context: context));
      },
      refreshController: controller,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.posts.length) return BottomLoader();

          return ProfileQualificationShowMoreListItem(
            titleItemName: AppLocalizations.of(context).language_skills_item_name,
            canMakeUpdate: widget.canMakeUpdate,
            name: state.posts[index].englishName,
            itemDetail: commonLanguage.getLevelNameByID(state.posts[index].languageLevel) ??
                AppLocalizations.of(context).no_detail,
            files: [],
            imageUrl: [],
            videosList: [],
            updateFunction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdateLanguageScreen(
                        language: state.posts[index],
                        bloc: profileProviderLanguageBloc,
                        index: index,
                      )));
            },
            deleteFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderLanguageBloc
                  .add(DeletetItem(itemId: state.posts[index].id, index: index, context: context));
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    if (_isBottom && !isReloadData) {
      profileProviderLanguageBloc
          .add(GetAllLanguage(newRequest: false, userId: widget.userId, context: context));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
