import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/discover_my_interests_sub_categories_blogs/discover_my_interests_sub_categories_blogs_bloc.dart';
import '../../../infrastructure/common_response/sub_category_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/blog_post_list_item.dart';
import '../../custom_widgets/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class DiscoverMyInterestsSubCategoriesBlogsScreen extends StatefulWidget {
  final SubCategoryResponse subCategoryInfo;
  DiscoverMyInterestsSubCategoriesBlogsScreen({@required this.subCategoryInfo});
  @override
  State<StatefulWidget> createState() {
    return _DiscoverMyInterestsSubCategoriesBlogsScreen();
  }
}

class _DiscoverMyInterestsSubCategoriesBlogsScreen
    extends State<DiscoverMyInterestsSubCategoriesBlogsScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  DiscoverMyInterestsSubCategoriesBlogsBloc
      discoverMyInterestsSubCategoriesBlogsBloc;
  final refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    discoverMyInterestsSubCategoriesBlogsBloc =
        serviceLocator<DiscoverMyInterestsSubCategoriesBlogsBloc>();
    discoverMyInterestsSubCategoriesBlogsBloc.add(
        DiscoverMyInterestsSubCategoriesBlogsFetched(
            subCategoryId: widget.subCategoryInfo.id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => discoverMyInterestsSubCategoriesBlogsBloc,
      child: BlocListener<DiscoverMyInterestsSubCategoriesBlogsBloc,
          DiscoverMyInterestsSubCategoriesBlogsState>(
        listener: (context, state) {},
        child: BlocBuilder<DiscoverMyInterestsSubCategoriesBlogsBloc,
            DiscoverMyInterestsSubCategoriesBlogsState>(
          builder: (context, state) {
            switch (state.status) {
              case BLogPostStatus.loading:
                return LoadingBloc();
              case BLogPostStatus.failure:
                if (state.posts.length > 0) return showItem(state);
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    discoverMyInterestsSubCategoriesBlogsBloc.add(
                        ReloadDiscoverMyInterestsSubCategoriesBlogsFetched(
                            subCategoryId: widget.subCategoryInfo.id));
                  },
                );

              case BLogPostStatus.success:
                return showItem(state);
              default:
                return LoadingBloc();
            }
          },
        ),
      ),
    );
  }

  Widget showItem(DiscoverMyInterestsSubCategoriesBlogsState state) {
    if (state.posts.isEmpty) {
      return BlocError(
        context: context,
        blocErrorState: BlocErrorState.noPosts,
        function: () {
          discoverMyInterestsSubCategoriesBlogsBloc.add(
              ReloadDiscoverMyInterestsSubCategoriesBlogsFetched(
                  subCategoryId: widget.subCategoryInfo.id));
        },
      );
    }
    return RefreshData(
      onRefresh: () {
        discoverMyInterestsSubCategoriesBlogsBloc.add(
            ReloadDiscoverMyInterestsSubCategoriesBlogsFetched(
                subCategoryId: widget.subCategoryInfo.id));
      },
      refreshController: refreshController,
      body: InViewNotifierList(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        initialInViewIds: ['0'],
        isInViewPortCondition:
            (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.5 * viewPortDimension) &&
              deltaBottom > (0.5 * viewPortDimension);
        },
        itemCount:
            state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        builder: (BuildContext context, int index) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return InViewNotifierWidget(
                id: '$index',
                builder: (BuildContext context, bool isInView, Widget child) {
                  return index >= state.posts.length
                      ? BottomLoader()
                      : BlogPostListItem(
                          post: state.posts[index],
                          play: isInView,
                          function: () {
                          Navigator.pop(context);
                          discoverMyInterestsSubCategoriesBlogsBloc.add(DeleteBlog(
                              index: index,
                              blogId: state.posts[index].id,
                              context: context));
                        },
                        );
                },
              );
            },
          );
        },
        onListEndReached: () {
          discoverMyInterestsSubCategoriesBlogsBloc.add(
              DiscoverMyInterestsSubCategoriesBlogsFetched(
                  subCategoryId: widget.subCategoryInfo.id));
        },
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
      discoverMyInterestsSubCategoriesBlogsBloc.add(
          DiscoverMyInterestsSubCategoriesBlogsFetched(
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
