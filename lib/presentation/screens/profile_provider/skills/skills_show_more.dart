import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_skills/profile_provider_skills_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/profile_Qualification_show_more_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/profile_provider/skills/add_skill.dart';
import 'package:arachnoit/presentation/screens/profile_provider/skills/update_skill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SkillsShowMoreScreen extends StatefulWidget {
  final bool canMakeUpdate;
  final String userId;
  SkillsShowMoreScreen({@required this.canMakeUpdate, @required this.userId});
  @override
  State<StatefulWidget> createState() {
    return _SkillsShowMoreScreen();
  }
}

class _SkillsShowMoreScreen extends State<SkillsShowMoreScreen> {
  RefreshController controller = RefreshController();
  ProfileProviderSkillsBloc profileProviderSkillsBloc;
  final _scrollController = ScrollController();
  bool isReloadData = false;
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    profileProviderSkillsBloc = serviceLocator<ProfileProviderSkillsBloc>();
    profileProviderSkillsBloc.add(GetAllSkills(newRequest: true, userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0XFFEFEFEF),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).skills,
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
                    .push(MaterialPageRoute(builder: (context) => AddSkillScreen()))
                    .then((value) {
                  profileProviderSkillsBloc
                      .add(GetAllSkills(newRequest: true, userId: widget.userId));
                });
              })
          : Container(),
      body: BlocProvider<ProfileProviderSkillsBloc>(
        create: (context) => profileProviderSkillsBloc,
        child: BlocListener<ProfileProviderSkillsBloc, ProfileProviderSkillsState>(
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
              GlobalPurposeFunctions.showToast(
                  AppLocalizations.of(context).success_delete_item, context);
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                Navigator.pop(context);
              });
            } else if (state.status == ProfileProviderStatus.failedDelete) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderSkillsBloc, ProfileProviderSkillsState>(
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
                      profileProviderSkillsBloc
                          .add(GetAllSkills(newRequest: true, userId: widget.userId));
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

  Widget showInfo(ProfileProviderSkillsState state) {
    if (state.posts.length == 0)
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            profileProviderSkillsBloc.add(GetAllSkills(newRequest: true, userId: widget.userId));
          });
    return RefreshData(
      refreshController: controller,
      onRefresh: () {
        isReloadData = true;
        profileProviderSkillsBloc.add(GetAllSkills(newRequest: true, userId: widget.userId));
      },
      body: ListView.builder(
        controller: _scrollController,
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.posts.length) return BottomLoader();
          return ProfileQualificationShowMoreListItem(
            canMakeUpdate: widget.canMakeUpdate,
            titleItemName: AppLocalizations.of(context).skills_item_name,
            name: state.posts[index].name,
            itemDetail: state.posts[index].description ?? AppLocalizations.of(context).no_detail,
            files: [],
            imageUrl: [],
            updateFunction: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdateSkillScreen(
                        bloc: profileProviderSkillsBloc,
                        index: index,
                        skillsItem: state.posts[index],
                      )));
            },
            deleteFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderSkillsBloc.add(DeleteSelectedSkill(
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
      profileProviderSkillsBloc.add(GetAllSkills(newRequest: false, userId: widget.userId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
