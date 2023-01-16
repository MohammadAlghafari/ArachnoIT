import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/discover_categories_sub_category_all_blogs/discover_categories_sub_category_all_blogs_bloc.dart';
import '../../../infrastructure/common_response/sub_category_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/blog_post_list_item.dart';
import '../../custom_widgets/bottom_loader.dart';

class DiscoverCategoriesSubCategoryAllBlogsScreen extends StatefulWidget {
  static const routeName = '/discover_categoris_sub_category_all_blogs_screen';
  DiscoverCategoriesSubCategoryAllBlogsScreen({Key key, @required this.subCategory})
      : super(key: key);
  final SubCategoryResponse subCategory;
  @override
  _DiscoverCategoriesSubCategoryAllBlogsScreenState createState() =>
      _DiscoverCategoriesSubCategoryAllBlogsScreenState();
}

class _DiscoverCategoriesSubCategoryAllBlogsScreenState
    extends State<DiscoverCategoriesSubCategoryAllBlogsScreen> {
  final _scrollController = ScrollController();
  DiscoverCategoriesSubCategoryAllBlogsBloc discoverCategoriesSubCategoryAllBlogsBloc;
  RefreshController refreshController = RefreshController();
  bool isRefreshData = false;
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    discoverCategoriesSubCategoryAllBlogsBloc =
        serviceLocator<DiscoverCategoriesSubCategoryAllBlogsBloc>();
    discoverCategoriesSubCategoryAllBlogsBloc
        .add(SubCategoryAllBlogPostFetchEvent(subCategoryId: widget.subCategory.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: widget.subCategory.name != null ? widget.subCategory.name : '',
      ),
      body: BlocProvider(
        create: (context) => discoverCategoriesSubCategoryAllBlogsBloc,
        child: BlocListener<DiscoverCategoriesSubCategoryAllBlogsBloc,
            DiscoverCategoriesSubCategoryAllBlogsState>(
          listener: (context, state) {
            if (state.status == BLogPostStatus.success) {
              isRefreshData = false;
              successRequestBefore = true;
              refreshController.refreshCompleted();
            } else if (state.status == BLogPostStatus.failure) {
              isRefreshData = false;
              refreshController.refreshFailed();
            }
          },
          child: BlocBuilder<DiscoverCategoriesSubCategoryAllBlogsBloc,
              DiscoverCategoriesSubCategoryAllBlogsState>(
            builder: (context, state) {
              if (successRequestBefore) return showInfo(state);
              switch (state.status) {
                case BLogPostStatus.loading:
                  return LoadingBloc();
                case BLogPostStatus.failure:
                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.userError,
                      function: () {
                        discoverCategoriesSubCategoryAllBlogsBloc.add(
                            SubCategoryAllBlogPostFetchEvent(subCategoryId: widget.subCategory.id));
                      });
                case BLogPostStatus.success:
                  if (state.posts.isEmpty) {
                    return BlocError(
                        context: context,
                        blocErrorState: BlocErrorState.noPosts,
                        function: () {
                          discoverCategoriesSubCategoryAllBlogsBloc.add(
                              SubCategoryAllBlogPostFetchEvent(
                                  subCategoryId: widget.subCategory.id));
                        });
                  }
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

  Widget showInfo(DiscoverCategoriesSubCategoryAllBlogsState state) {
    return RefreshData(
      scrollController: _scrollController,
      onRefresh: () {
        isRefreshData = true;
        discoverCategoriesSubCategoryAllBlogsBloc.add(SubCategoryAllBlogPostFetchEvent(
            subCategoryId: widget.subCategory.id, isReloadData: true));
      },
      refreshController: refreshController,
      body: InViewNotifierList(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(parent: ClampingScrollPhysics()),
        shrinkWrap: true,
        initialInViewIds: ['0'],
        isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.5 * viewPortDimension) && deltaBottom > (0.5 * viewPortDimension);
        },
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
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
                            discoverCategoriesSubCategoryAllBlogsBloc.add(DeleteBlog(
                                index: index, blogId: state.posts[index].id, context: context));
                          },
                        );
                },
              );
            },
          );
        },
        onListEndReached: () {},
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
      discoverCategoriesSubCategoryAllBlogsBloc
          .add(SubCategoryAllBlogPostFetchEvent(subCategoryId: widget.subCategory.id));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
