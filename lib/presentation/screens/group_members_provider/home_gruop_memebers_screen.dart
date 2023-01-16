import 'package:arachnoit/application/group_members_providers/group_invite_members/group_invite_members_bloc.dart';
import 'package:arachnoit/application/group_members_providers/group_members/group_members_bloc.dart';
import 'package:arachnoit/application/group_members_providers/home_group_members/home_group_members_bloc.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/recreate_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as ex;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import '../../../injections.dart';
import 'group_invite_members/gruop_invite_memebers_screen.dart';
import 'group_members/gruop_memebers_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeGroupMembersScreen extends StatefulWidget {
  static const routeName = '/home_group_member_screen';
  final String groupId;

  const HomeGroupMembersScreen({@required this.groupId});

  @override
  _HomeGroupMembers createState() => new _HomeGroupMembers();
}

GroupMembersBloc groupMembersBloc;
GroupInviteMembersBloc groupInviteMembersBloc;

class _HomeGroupMembers extends State<HomeGroupMembersScreen> with TickerProviderStateMixin {
  TabController primaryTC;
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController querySearchedController = new TextEditingController();
  HomeGroupMembersBloc homeGroupMembersBloc;
  String searchQuery = '';

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [searchBar.getSearchAction(context)],
      title: Text(
        AppLocalizations.of(context).invite_members,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  void onSubmitted(String value) {
    print('submited');
    homeGroupMembersBloc..add(ResetSearched());
    if (primaryTC.index == 0)
      groupMembersBloc..add(SubmittedSearchGroupMember(groupId: widget.groupId, query: value));
    else
      groupInviteMembersBloc
        ..add(SubmittedSearchInviteMembers(groupId: widget.groupId, query: value));
  }

  void onChange(String value) {
    print('onChange');
    if (value.isEmpty)
      homeGroupMembersBloc..add(ResetSearched());
    else if (searchQuery != value) {
      if (primaryTC.index == 0)
        homeGroupMembersBloc..add(PersonSearchedGroupMember(groupId: widget.groupId, query: value));
      else
        homeGroupMembersBloc
          ..add(PersonSearchedInviteMember(groupId: widget.groupId, query: value));
    }

    searchQuery = value;
  }

  _HomeGroupMembers() {
    String title;
    Future.delayed(Duration.zero, () {
      title = AppLocalizations.of(context).search;
    });
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: onChange,
        controller: querySearchedController,
        onCleared: () {
          homeGroupMembersBloc..add(ResetSearched());
        },
        onClosed: () {
          homeGroupMembersBloc..add(ResetSearched());
        });
  }

  @override
  void initState() {
    super.initState();
    homeGroupMembersBloc = serviceLocator<HomeGroupMembersBloc>();
    homeGroupMembersBloc..add(ResetSearched());
    groupMembersBloc = serviceLocator<GroupMembersBloc>();
    groupInviteMembersBloc = serviceLocator<GroupInviteMembersBloc>();
    primaryTC = new TabController(length: 2, vsync: this);
    primaryTC.addListener(tabControlerListener);
  }

  int index;

  void tabControlerListener() {
    print(primaryTC.index);
    if (index != primaryTC.index) {
      //your code
      index = primaryTC.index;
    }
  }

  @override
  void dispose() {
    super.dispose();
    querySearchedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: searchBar.build(context),
          key: _scaffoldKey,
          body: BlocProvider(
            create: (context) => homeGroupMembersBloc,
            child: BlocBuilder<HomeGroupMembersBloc, HomeGroupMembersState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: TabBar(
                            controller: primaryTC,
                            isScrollable: false,
                            labelColor: Theme.of(context).accentColor,
                            indicatorColor: Theme.of(context).accentColor,
                            unselectedLabelColor: Color(0XFF19444C),
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            tabs: <Tab>[
                              Tab(
                                text: AppLocalizations.of(context).group_members,
                              ),
                              Tab(text: AppLocalizations.of(context).invite_members),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(controller: primaryTC, children: [
                            ex.NestedScrollViewInnerScrollPositionKeyWidget(
                                const Key('GroupMembers'),
                                GroupMembersScreen(
                                  groupId: widget.groupId,
                                )),
                            ex.NestedScrollViewInnerScrollPositionKeyWidget(
                              const Key('InviteMembers'),
                              GroupInviteMembersScreen(
                                groupId: widget.groupId,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    (state.personSearched.length > 0)
                        ? Container(
                            height: MediaQuery.of(context).size.height*0.4,
                            color: Colors.white,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:  state.personSearched.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      onSubmitted(state.personSearched[index]);
                                    },
                                    tileColor: Colors.white,
                                    leading: Icon(Icons.search),
                                    title: Text(state.personSearched[index]),
                                  );
                                }),
                          )
                        : Container()
                  ],
                );
              },
            ),
          )),
    );
  }
}
