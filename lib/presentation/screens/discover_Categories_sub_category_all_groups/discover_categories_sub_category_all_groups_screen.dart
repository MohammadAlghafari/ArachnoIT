import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/discover_categories_sub_category_all_groups/discover_categories_sub_category_all_groups_bloc.dart';
import '../../../infrastructure/common_response/sub_category_response.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/groups_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injections.dart';

class DiscoverCategoriesSubCategoryAllGroupsScreen extends StatefulWidget {
  static const routeName = '/discover_categoris_sub_category_all_groups_screen';
  DiscoverCategoriesSubCategoryAllGroupsScreen({Key key, @required this.subCategory})
      : super(key: key);
  final SubCategoryResponse subCategory;

  @override
  _DiscoverCategoriesSubCategoryAllGroupsScreenState createState() =>
      _DiscoverCategoriesSubCategoryAllGroupsScreenState();
}

class _DiscoverCategoriesSubCategoryAllGroupsScreenState
    extends State<DiscoverCategoriesSubCategoryAllGroupsScreen> {
  final _scrollController = ScrollController();
  DiscoverCategoriesSubCategoryAllGroupsBloc discoverCategoriesSubCategoryAllGroupsBloc;
  bool successRequestBefore = false;
  final refreshController = RefreshController();
  bool isRefreshData = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    discoverCategoriesSubCategoryAllGroupsBloc =
        serviceLocator<DiscoverCategoriesSubCategoryAllGroupsBloc>();
    discoverCategoriesSubCategoryAllGroupsBloc
        .add(SubCategoryGroupsFetchEvent(subCategoryId: widget.subCategory.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: widget.subCategory.name != null ? widget.subCategory.name : '',
      ),
      body: BlocProvider(
        create: (context) => discoverCategoriesSubCategoryAllGroupsBloc,
        child: BlocListener<DiscoverCategoriesSubCategoryAllGroupsBloc,
            DiscoverCategoriesSubCategoryAllGroupsState>(
          listener: (context, state) {
            if (state.status == GroupsStatus.success) {
              successRequestBefore = true;
              isRefreshData = false;
              refreshController.refreshCompleted();
            } else if (state.status == GroupsStatus.failure) {
              isRefreshData = false;
              refreshController.refreshFailed();
            }
          },
          child: BlocBuilder<DiscoverCategoriesSubCategoryAllGroupsBloc,
              DiscoverCategoriesSubCategoryAllGroupsState>(
            builder: (context, state) {
              switch (state.status) {
                case GroupsStatus.loading:
                  if (successRequestBefore) return showInfo(state);
                  return LoadingBloc();
                case GroupsStatus.failure:
                  if (successRequestBefore) return showInfo(state);
                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.userError,
                      function: () {
                        discoverCategoriesSubCategoryAllGroupsBloc
                            .add(SubCategoryGroupsFetchEvent(subCategoryId: widget.subCategory.id));
                      });
                case GroupsStatus.success:
                  return showInfo(state);
                default:
                  return LoadingBloc();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showInfo(DiscoverCategoriesSubCategoryAllGroupsState state) {
    if (state.allGroups.isEmpty) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            discoverCategoriesSubCategoryAllGroupsBloc.add(SubCategoryGroupsFetchEvent(
                subCategoryId: widget.subCategory.id, isReloadData: true));
          });
    }
    return RefreshData(
      onRefresh: () {
        isRefreshData = true;
        discoverCategoriesSubCategoryAllGroupsBloc.add(
            SubCategoryGroupsFetchEvent(subCategoryId: widget.subCategory.id, isReloadData: true));
      },
      refreshController: refreshController,
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index >= state.allGroups.length
              ? BottomLoader()
              : GroupsGroupItem(
                  group: state.allGroups[index],
                );
        },
        itemCount: state.hasReachedMax ? state.allGroups.length : state.allGroups.length + 1,
        controller: _scrollController,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isRefreshData)
      discoverCategoriesSubCategoryAllGroupsBloc
          .add(SubCategoryGroupsFetchEvent(subCategoryId: widget.subCategory.id));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
