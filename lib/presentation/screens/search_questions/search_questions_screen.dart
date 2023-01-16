import 'package:arachnoit/application/search_question/search_question_bloc.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/search_blog_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/search_question_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchQuestionScreen extends StatefulWidget {
  final bool shouldDestroyWidget;
  final String categoryId;
  final String subCategoryId;
  final int accountTypeId;
  final int orderByQuestions;
  final List<String> tagsId;
  final String searchText;
  final bool isAdvanceSearch;
  SearchQuestionScreen({
    this.shouldDestroyWidget = false,
    this.tagsId,
    this.subCategoryId,
    this.orderByQuestions,
    this.categoryId,
    this.accountTypeId,
    this.searchText,
    this.isAdvanceSearch = false,
  });
  @override
  State<StatefulWidget> createState() {
    return _SearchQuestionScreen();
  }
}

class _SearchQuestionScreen extends State<SearchQuestionScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final refreshController = RefreshController();
  SearchQuestionBloc searchQuestionBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    searchQuestionBloc = serviceLocator<SearchQuestionBloc>();
  }

  void getData() {
    if (widget.searchText != null && !widget.isAdvanceSearch) {
      searchQuestionBloc
          .add(GetSearchTextEvent(newRequest: true, query: widget.searchText));
    } else if (widget.isAdvanceSearch) {
      searchQuestionBloc.add(new GetAdvanceSearchValuesEvent(
          accountTypeId: widget.accountTypeId,
          categoryId: widget.categoryId,
          newRequest: true,
          orderByQuestions: widget.orderByQuestions,
          subCategoryId: widget.subCategoryId,
          tagsId: widget.tagsId));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    getData();
    return BlocProvider(
      create: (context) => searchQuestionBloc,
      child: BlocListener<SearchQuestionBloc, SearchQuestionState>(
        listener: (context, state) {},
        child: BlocBuilder<SearchQuestionBloc, SearchQuestionState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchQuestionStatus.loading:
                if (state.posts.length != 0) return showInfo(state);
                return LoadingBloc();
              case SearchQuestionStatus.failure:
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    getData();
                  },
                );
              case SearchQuestionStatus.success:
                return showInfo(state);
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(SearchQuestionState state) {
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
      refreshController: refreshController,
      onRefresh: () {
        getData();
      },
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length
              ? BottomLoader()
              : new SearchQuestionListItem(question: state.posts[index]);
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
      searchQuestionBloc
          .add(GetSearchTextEvent(newRequest: false, query: widget.searchText));
    } else if (widget.isAdvanceSearch) {
      searchQuestionBloc.add(new GetAdvanceSearchValuesEvent(
          accountTypeId: widget.accountTypeId,
          categoryId: widget.categoryId,
          newRequest: false,
          orderByQuestions: widget.orderByQuestions,
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
  bool get wantKeepAlive => true;
}
