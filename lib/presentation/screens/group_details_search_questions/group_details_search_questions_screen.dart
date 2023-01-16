import 'package:arachnoit/application/group_details_search_questions/group_details_search_questions_bloc.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/search_question_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../injections.dart';

class GroupDetailsSearchQuestionsScreen extends StatefulWidget {
  GroupDetailsSearchQuestionsScreen(
      {Key key,
      @required this.searchText,
      @required this.groupId,
      @required this.categoryId,
      @required this.subCategoryId,
      @required this.accountType,
      @required this.shouldDestroyWidget,
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
  _GroupDetailsSearchQuestionsScreenState createState() =>
      _GroupDetailsSearchQuestionsScreenState();
}

class _GroupDetailsSearchQuestionsScreenState extends State<GroupDetailsSearchQuestionsScreen>
    with AutomaticKeepAliveClientMixin {
  bool isUpdateValue = false;
  final _scrollController = ScrollController();
  GroupDetailsSearchQuestionsBloc groupDetailsSearchQuestionsBloc;
  final refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    groupDetailsSearchQuestionsBloc = serviceLocator<GroupDetailsSearchQuestionsBloc>();
  }

  void loadingData() {
    if (widget.searchText != null) {
      groupDetailsSearchQuestionsBloc.add(SearchTextQuestionsFetchEvent(
          groupId: widget.groupId, query: widget.searchText, newRequest: true));
    } else if (widget.categoryId != null ||
        widget.subCategoryId != null ||
        widget.accountType != null) {
      groupDetailsSearchQuestionsBloc.add(AdvancedSearchQuestionsFetchEvent(
          accountType: widget.accountType,
          categoryId: widget.categoryId,
          groupId: widget.groupId,
          subCategoryId: widget.subCategoryId,
          tagsId: widget.tagsId,
          newRequest: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    loadingData();
    return BlocProvider(
      create: (context) => groupDetailsSearchQuestionsBloc,
      child: BlocListener<GroupDetailsSearchQuestionsBloc, GroupDetailsSearchQuestionsState>(
        listener: (context, state) {
          if (state.status == QaaPostStatus.success) {
            isUpdateValue = false;
            refreshController.refreshCompleted();
          } else if (state.status == QaaPostStatus.failure) {
            isUpdateValue = false;
            refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<GroupDetailsSearchQuestionsBloc, GroupDetailsSearchQuestionsState>(
          builder: (context, state) {
            switch (state.status) {
              case QaaPostStatus.loading:
                if (state.posts.length == 0) return LoadingBloc();
                return showInfo(state);
              case QaaPostStatus.failure:
                if (state.posts.length > 0) return showInfo(state);
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      loadingData();
                    });
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.noPosts,
                    function: () {
                      loadingData();
                    });
              case QaaPostStatus.success:
                return showInfo(state);
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(GroupDetailsSearchQuestionsState state) {
    if (state.posts.isEmpty) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            loadingData();
          });
    }
    return RefreshData(
      scrollController: _scrollController,
      refreshController: refreshController,
      onRefresh: () {
        isUpdateValue = true;
        loadingData();
      },
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length
              ? BottomLoader()
              : SearchQuestionListItem(
                  question: state.posts[index],
                );
        },
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
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
    if (_isBottom && !isUpdateValue) if (widget.searchText != null) {
      groupDetailsSearchQuestionsBloc.add(SearchTextQuestionsFetchEvent(
          groupId: widget.groupId, query: widget.searchText, newRequest: false));
    } else if (widget.categoryId != null ||
        widget.subCategoryId != null ||
        widget.accountType != null) {
      groupDetailsSearchQuestionsBloc.add(AdvancedSearchQuestionsFetchEvent(
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
