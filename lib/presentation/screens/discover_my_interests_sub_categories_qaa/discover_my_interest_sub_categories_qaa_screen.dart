import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/discover_my_interests_sub_categories_qaa/discover_my_interests_sub_categories_qaa_bloc.dart';
import '../../../infrastructure/common_response/sub_category_response.dart';
import '../../custom_widgets/qaa_post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';

class DisocverMyInterestSubCategorisQaaScreen extends StatefulWidget {
  final SubCategoryResponse subCategoryInfo;
  DisocverMyInterestSubCategorisQaaScreen({this.subCategoryInfo});
  @override
  _DisocverMyInterestSubCategorisQaaScreen createState() =>
      _DisocverMyInterestSubCategorisQaaScreen();
}

class _DisocverMyInterestSubCategorisQaaScreen
    extends State<DisocverMyInterestSubCategorisQaaScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  DiscoverMyInterestsSubCategoriesQaaBloc
      discoverMyInterestsSubCategoriesQaaBloc;
  final refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    discoverMyInterestsSubCategoriesQaaBloc =
        serviceLocator<DiscoverMyInterestsSubCategoriesQaaBloc>()
          ..add(DiscoverMyInterestsSubCategoriesQaaFetch(
              subCategoryId: widget.subCategoryInfo.id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => discoverMyInterestsSubCategoriesQaaBloc,
      child: BlocListener<DiscoverMyInterestsSubCategoriesQaaBloc,
          DiscoverMyInterestsSubCategoriesQaaState>(
        listener: (context, state) {},
        child: BlocBuilder<DiscoverMyInterestsSubCategoriesQaaBloc,
            DiscoverMyInterestsSubCategoriesQaaState>(
          builder: (context, state) {
            switch (state.status) {
              case QaaMyInterestsSubCategoriesQaaStatus.loading:
                return LoadingBloc();
              case QaaMyInterestsSubCategoriesQaaStatus.failure:
                if (state.posts.length > 0) return showItem(state);
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    discoverMyInterestsSubCategoriesQaaBloc.add(
                        ReloadDiscoverMyInterestsSubCategoriesQaaFetch(
                            subCategoryId: widget.subCategoryInfo.id));
                  },
                );
              case QaaMyInterestsSubCategoriesQaaStatus.success:
                return showItem(state);
              default:
                return LoadingBloc();
            }
          },
        ),
      ),
    );
  }

  Widget showItem(DiscoverMyInterestsSubCategoriesQaaState state) {
    if (state.posts.isEmpty) {
      return BlocError(
        context: context,
        blocErrorState: BlocErrorState.noPosts,
        function: () {
          discoverMyInterestsSubCategoriesQaaBloc.add(
              ReloadDiscoverMyInterestsSubCategoriesQaaFetch(
                  subCategoryId: widget.subCategoryInfo.id));
        },
      );
    }
    return RefreshData(
      refreshController: refreshController,
      onRefresh: () {
        discoverMyInterestsSubCategoriesQaaBloc.add(
            ReloadDiscoverMyInterestsSubCategoriesQaaFetch(
                subCategoryId: widget.subCategoryInfo.id));
      },
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length
              ? BottomLoader()
              : QaaPostListItem(
                  post: state.posts[index],
                  deleteItemFunction: () {
                    Navigator.pop(context);
                    discoverMyInterestsSubCategoriesQaaBloc.add(DeleteQuestion(
                      questionId: state.posts[index].questionId,
                      context: context,
                      index: index,
                    ));
                  },
                );
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
    if (_isBottom)
      discoverMyInterestsSubCategoriesQaaBloc.add(
          DiscoverMyInterestsSubCategoriesQaaFetch(
              subCategoryId: widget.subCategoryInfo.id));
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
