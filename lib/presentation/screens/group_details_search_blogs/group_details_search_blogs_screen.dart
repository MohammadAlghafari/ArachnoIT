import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/search_blog_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/group_details_search_blogs/group_details_search_blogs_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';

class GroupDetailsSearchBlogsScreen extends StatefulWidget {
  GroupDetailsSearchBlogsScreen(
      {Key key,
      @required this.searchText,
      @required this.groupId,
      @required this.shouldDestroyWidget,
      @required this.categoryId,
      @required this.subCategoryId,
      @required this.accountType,
      @required this.tagsId = const <String>[]})
      : super(key: key);
  final String searchText;
  final String groupId;
  final String categoryId;
  final String subCategoryId;
  final int accountType;
  final bool shouldDestroyWidget;
  final List<String> tagsId;
  @override
  _GroupDetailsSearchBlogsScreenState createState() => _GroupDetailsSearchBlogsScreenState();
}

class _GroupDetailsSearchBlogsScreenState extends State<GroupDetailsSearchBlogsScreen>
    with AutomaticKeepAliveClientMixin {
  bool isUpdateValue = false;
  final _scrollController = ScrollController();
  GroupDetailsSearchBlogsBloc groupDetailsSearchBlogsBloc;
  final refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    groupDetailsSearchBlogsBloc = serviceLocator<GroupDetailsSearchBlogsBloc>();
  }

  void loadingData() {
    if (widget.searchText != null) {
      groupDetailsSearchBlogsBloc.add(SearchTextBlogsFetchEvent(
        groupId: widget.groupId,
        query: widget.searchText,
        newRequest: true,
      ));
    } else if (widget.categoryId != null ||
        widget.subCategoryId != null ||
        widget.accountType != null ||
        widget.tagsId.length != 0) {
      groupDetailsSearchBlogsBloc.add(AdvancedSearchBlogsFetchEvent(
          accountType: widget.accountType,
          categoryId: widget.categoryId,
          groupId: widget.groupId,
          subCategoryId: widget.subCategoryId,
          newRequest: true,
          tagsId: widget.tagsId));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    loadingData();
    return BlocProvider<GroupDetailsSearchBlogsBloc>(
      create: (context) => groupDetailsSearchBlogsBloc,
      child: BlocListener<GroupDetailsSearchBlogsBloc, GroupDetailsSearchBlogsState>(
        listener: (context, state) {
          if (state.status == BlogPostStatus.success) {
            isUpdateValue = false;
            refreshController.refreshCompleted();
          } else if (state.status == BlogPostStatus.failure) {
            isUpdateValue = false;
            refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<GroupDetailsSearchBlogsBloc, GroupDetailsSearchBlogsState>(
          builder: (context, state) {
            switch (state.status) {
              case BlogPostStatus.loading:
                if (state.posts.length == 0) return LoadingBloc();
                return showInfo(state);
              case BlogPostStatus.failure:
                if (state.posts.length > 0) return showInfo(state);
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      loadingData();
                    });
              case BlogPostStatus.success:
                return showInfo(state);
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(GroupDetailsSearchBlogsState state) {
    if (state.posts.isEmpty) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            loadingData();
          });
    }
    return RefreshData(
        refreshController: refreshController,
        scrollController: _scrollController,
        onRefresh: () {
          isUpdateValue = true;
          loadingData();
        },
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return index >= state.posts.length
                ? BottomLoader()
                : SearchBlogListItem(blog: state.posts[index]);
          },
          itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
          controller: _scrollController,
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isUpdateValue) if (widget.searchText != null) {
      groupDetailsSearchBlogsBloc.add(SearchTextBlogsFetchEvent(
          groupId: widget.groupId, query: widget.searchText, newRequest: false));
    } else if (widget.categoryId != null ||
        widget.subCategoryId != null ||
        widget.accountType != null) {
      groupDetailsSearchBlogsBloc.add(AdvancedSearchBlogsFetchEvent(
          accountType: widget.accountType,
          categoryId: widget.categoryId,
          groupId: widget.groupId,
          subCategoryId: widget.subCategoryId,
          tagsId: widget.tagsId,
          newRequest: false));
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
