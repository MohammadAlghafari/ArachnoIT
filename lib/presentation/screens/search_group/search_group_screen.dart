import 'package:arachnoit/application/search_group/search_group_bloc.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/search_group_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchGroupScreen extends StatefulWidget {
  final bool shouldDestroyWidget;
  final String textSearch;
  final String categoryId;
  final String subCategoryId;
  final bool isAdvanceSearch;
  SearchGroupScreen(
      {this.shouldDestroyWidget = false,
      this.categoryId,
      this.subCategoryId,
      this.textSearch,
      this.isAdvanceSearch = false});
  @override
  State<StatefulWidget> createState() {
    return _SearchGroupScreen();
  }
}

class _SearchGroupScreen extends State<SearchGroupScreen>
    with AutomaticKeepAliveClientMixin {
  SearchGroupBloc searchGroupBloc;
  final _scrollController = ScrollController();
  final refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    searchGroupBloc = serviceLocator<SearchGroupBloc>();
  }

  getData() {
    if (widget.textSearch != null && !widget.isAdvanceSearch) {
      searchGroupBloc.add(GetGroupsSearchTextEvent(
          newRequest: true, searchText: widget.textSearch));
    } else if (widget.isAdvanceSearch)
      searchGroupBloc.add(GetAdvanceSearchValuesEvent(
        newRequest: true,
        categoryId: widget.categoryId,
        subCategoryID: widget.subCategoryId,
      ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    getData();
    return BlocProvider<SearchGroupBloc>(
      create: (context) => searchGroupBloc,
      child: BlocListener<SearchGroupBloc, SearchGroupState>(
        listener: (context, state) {},
        child: BlocBuilder<SearchGroupBloc, SearchGroupState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchGroupStateStatus.loading:
                if (state.posts.length != 0) return showInfo(state);
                return LoadingBloc();
              case SearchGroupStateStatus.failure:
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    getData();
                  },
                );
              case SearchGroupStateStatus.success:
                return showInfo(state);
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(SearchGroupState state) {
    if (state.posts.isEmpty) {
      return BlocError(
        context: context,
        blocErrorState: BlocErrorState.noPosts,
        function: () {
          getData();
        },
      );
    }
    return RefreshData(
      onRefresh: () {
        getData();
      },
      refreshController: refreshController,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length
              ? BottomLoader()
              : SearchGroupListItem(
                  groupResponse: state.posts[index],
                );
        },
        itemCount:
            state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        controller: _scrollController,
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      if (widget.textSearch != null && !widget.isAdvanceSearch) {
        searchGroupBloc.add(GetGroupsSearchTextEvent(
            newRequest: false, searchText: widget.textSearch));
      } else if (widget.isAdvanceSearch)
        searchGroupBloc.add(GetAdvanceSearchValuesEvent(
          newRequest: false,
          categoryId: widget.categoryId,
          subCategoryID: widget.subCategoryId,
        ));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  bool get wantKeepAlive => !widget.shouldDestroyWidget;
}
