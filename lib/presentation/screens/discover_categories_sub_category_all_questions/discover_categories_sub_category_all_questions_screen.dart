import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/discover_categories_sub_category_all_questions/discover_categories_sub_category_all_questions_bloc.dart';
import '../../../infrastructure/common_response/sub_category_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/qaa_post_list_item.dart';

class DiscoverCategoriesSubCategoryAllQuestionsScreen extends StatefulWidget {
  static const routeName = '/discover_categoris_sub_category_all_questions_screen';
  DiscoverCategoriesSubCategoryAllQuestionsScreen({Key key, @required this.subCategory})
      : super(key: key);
  final SubCategoryResponse subCategory;

  @override
  _DiscoverCategoriesSubCategoryAllQuestionsScreenState createState() =>
      _DiscoverCategoriesSubCategoryAllQuestionsScreenState();
}

class _DiscoverCategoriesSubCategoryAllQuestionsScreenState
    extends State<DiscoverCategoriesSubCategoryAllQuestionsScreen> {
  final _scrollController = ScrollController();
  DiscoverCategoriesSubCategoryAllQuestionsBloc discoverCategoriesSubCategoryAllQuestionsBloc;
  final refreshController = RefreshController();
  bool isRefreshData = false;
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    discoverCategoriesSubCategoryAllQuestionsBloc =
        serviceLocator<DiscoverCategoriesSubCategoryAllQuestionsBloc>();
    discoverCategoriesSubCategoryAllQuestionsBloc
        .add(SubCategoryAllQuestionsFetchEvent(subCategoryId: widget.subCategory.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: widget.subCategory.name != null ? widget.subCategory.name : '',
      ),
      body: BlocProvider(
        create: (context) => discoverCategoriesSubCategoryAllQuestionsBloc,
        child: BlocListener<DiscoverCategoriesSubCategoryAllQuestionsBloc,
            DiscoverCategoriesSubCategoryAllQuestionsState>(
          listener: (context, state) {
            if (state.status == QaaPostStatus.success) {
              successRequestBefore = true;
              isRefreshData = false;
              refreshController.refreshCompleted();
            } else if (state.status == QaaPostStatus.failure) {
              isRefreshData = false;
              refreshController.refreshFailed();
            }
          },
          child: BlocBuilder<DiscoverCategoriesSubCategoryAllQuestionsBloc,
              DiscoverCategoriesSubCategoryAllQuestionsState>(
            builder: (context, state) {
              if (successRequestBefore) return showInfo(state);
              switch (state.status) {
                case QaaPostStatus.failure:
                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.userError,
                      function: () {
                        discoverCategoriesSubCategoryAllQuestionsBloc.add(
                            SubCategoryAllQuestionsFetchEvent(
                                subCategoryId: widget.subCategory.id));
                      });
                case QaaPostStatus.success:
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

  Widget showInfo(DiscoverCategoriesSubCategoryAllQuestionsState state) {
    if (state.posts.isEmpty) {
      return BlocError(context: context, blocErrorState: BlocErrorState.noPosts, function: () {});
    }
    return RefreshData(
      refreshController: refreshController,
      onRefresh: () {
        isRefreshData=true;
        discoverCategoriesSubCategoryAllQuestionsBloc.add(SubCategoryAllQuestionsFetchEvent(
            subCategoryId: widget.subCategory.id, isUpdateData: true));
      },
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index >= state.posts.length
              ? BottomLoader()
              : QaaPostListItem(
                  post: state.posts[index],
                  deleteItemFunction: () {
                    Navigator.pop(context);
                    discoverCategoriesSubCategoryAllQuestionsBloc.add(DeleteQuestion(
                      questionId: state.posts[index].questionId,
                      context: context,
                      index: index,
                    ));
                  },
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
    if (_isBottom && !isRefreshData)
      discoverCategoriesSubCategoryAllQuestionsBloc
          .add(SubCategoryAllQuestionsFetchEvent(subCategoryId: widget.subCategory.id));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
