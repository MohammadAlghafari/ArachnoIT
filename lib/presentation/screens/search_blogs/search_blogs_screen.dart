import 'package:arachnoit/application/search/search_bloc.dart';
import 'package:arachnoit/application/search_blogs/search_blogs_bloc.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/search_blog_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchBlogsScreen extends StatefulWidget {
  final bool shouldDestroyWidget;
  final String categoryId;
  final String subCategoryId;
  final int accountTypeId;
  final int orderByBlogs;
  final List<String> tagsId;
  final bool myFeed;
  final String searchText;
  final bool isAdvanceSearch;
  final Key key;
  SearchBlogsScreen({
    this.shouldDestroyWidget = false,
    this.tagsId,
    this.subCategoryId,
    this.orderByBlogs,
    this.myFeed,
    this.categoryId,
    this.accountTypeId,
    this.searchText,
    this.isAdvanceSearch = false,
    this.key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SearchBlogsScreen();
  }
}

class _SearchBlogsScreen extends State<SearchBlogsScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _refreshController = RefreshController();
  SearchBlogsBloc searchBlogsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    searchBlogsBloc = serviceLocator<SearchBlogsBloc>();
  }

  void getData() {
    if (widget.searchText != null && !widget.isAdvanceSearch) {
      searchBlogsBloc
          .add(GetSearchTextEvent(newRequest: true, query: widget.searchText));
    } else if (widget.isAdvanceSearch) {
      searchBlogsBloc.add(new GetAdvanceSearchValuesEvent(
          accountTypeId: widget.accountTypeId,
          categoryId: widget.categoryId,
          myFeed: widget.myFeed,
          newRequest: true,
          orderByBlogs: widget.orderByBlogs,
          subCategoryId: widget.subCategoryId,
          tagsId: widget.tagsId));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    getData();
    return BlocProvider(
      create: (context) => searchBlogsBloc,
      child: BlocListener<SearchBlogsBloc, SearchBlogsState>(
        listener: (context, state) {},
        child: BlocBuilder<SearchBlogsBloc, SearchBlogsState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchBlogsStateStatus.loading:
                if (state.posts.length != 0) return showInfo(state);
                return LoadingBloc();
              case SearchBlogsStateStatus.failure:
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    getData();
                  },
                );
              case SearchBlogsStateStatus.success:
                if (state.posts.isEmpty) {
                  return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.noPosts,
                    function: () {
                      getData();
                    },
                  );
                }
                return showInfo(state);
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(SearchBlogsState state) {
    return RefreshData(
      onRefresh: () {
        getData();
      },
      refreshController: _refreshController,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length
              ? BottomLoader()
              : SearchBlogListItem(blog: state.posts[index]);
        },
        itemCount:
            state.hasReachedMax ? state.posts.length : state.posts.length + 1,
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
    if (_isBottom) if (widget.searchText != null && !widget.isAdvanceSearch) {
      searchBlogsBloc
          .add(GetSearchTextEvent(newRequest: false, query: widget.searchText));
    } else if (widget.isAdvanceSearch) {
      searchBlogsBloc.add(new GetAdvanceSearchValuesEvent(
          accountTypeId: widget.accountTypeId,
          categoryId: widget.categoryId,
          myFeed: widget.myFeed,
          newRequest: false,
          orderByBlogs: widget.orderByBlogs,
          subCategoryId: widget.subCategoryId,
          tagsId: widget.tagsId));
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
