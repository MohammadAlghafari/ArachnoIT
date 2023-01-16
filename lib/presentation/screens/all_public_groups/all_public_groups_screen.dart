import 'package:arachnoit/application/all_groups/all_groups_bloc.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/groups_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPublicGroupsScreen extends StatefulWidget {
  static const routeName = '/all_public_groups_screen';
  const AllPublicGroupsScreen({Key key}) : super(key: key);

  @override
  _AllPublicGroupsScreenState createState() => _AllPublicGroupsScreenState();
}

class _AllPublicGroupsScreenState extends State<AllPublicGroupsScreen> {
  final _scrollController = ScrollController();
  AllGroupsBloc allGroupsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    allGroupsBloc = serviceLocator<AllGroupsBloc>();
    allGroupsBloc.add(AllGroupsFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
          title:AppLocalizations.of(context).all_group),
      body: BlocProvider(
        create: (context) => allGroupsBloc,
        child: BlocListener<AllGroupsBloc, AllGroupsState>(
          listener: (context, state) {},
          child: BlocBuilder<AllGroupsBloc, AllGroupsState>(
            builder: (context, state) {
              switch (state.status) {
                case AllGroupsStatus.failure:
                  {
                    return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.userError,
                      function: () {
                        allGroupsBloc.add(AllGroupsFetchEvent(reloadDataFromFirst: true));
                      },
                    );
                  }
                case AllGroupsStatus.success:
                  if (state.allGroups.isEmpty) {
                    return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.noPosts,
                      function: () {
                        allGroupsBloc.add(AllGroupsFetchEvent(reloadDataFromFirst: true));
                      },
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return index >= state.allGroups.length
                          ? BottomLoader()
                          : GroupsGroupItem(

                              group: state.allGroups[index],
                            );
                    },
                    itemCount: state.hasReachedMax
                        ? state.allGroups.length
                        : state.allGroups.length + 1,
                    controller: _scrollController,
                  );
                default:
                  return LoadingBloc();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) allGroupsBloc.add(AllGroupsFetchEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
