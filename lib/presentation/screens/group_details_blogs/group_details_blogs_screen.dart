import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../application/group_details_blogs/group_details_blogs_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/blog_post_list_item.dart';
import '../../custom_widgets/bottom_loader.dart';

class GroupDetailsBlogsScreen extends StatefulWidget {
  GroupDetailsBlogsScreen({Key key, @required this.groupId, @required this.groupDetailsBlogsBloc})
      : super(key: key);
  final String groupId;
  final GroupDetailsBlogsBloc groupDetailsBlogsBloc;

  @override
  _GroupDetailsBlogsScreenState createState() => _GroupDetailsBlogsScreenState();
}

class _GroupDetailsBlogsScreenState extends State<GroupDetailsBlogsScreen>
    with AutomaticKeepAliveClientMixin {
  bool calledRequestForPagenation = false;
  bool isUpdateValue = false;
  final _scrollController = ScrollController();
  final refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    widget.groupDetailsBlogsBloc.add(GroupBlogPostsFetched(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => widget.groupDetailsBlogsBloc,
      child: BlocListener<GroupDetailsBlogsBloc, GroupDetailsBlogsState>(
        listener: (context, state) {
          print("the state.status ${state.status}");
          if (state.status == BLogPostStatus.success) {
            calledRequestForPagenation = false;
            isUpdateValue = false;
            refreshController.refreshCompleted();
          } else if (state.status == BLogPostStatus.failure) {
            calledRequestForPagenation = false;
            isUpdateValue = false;
            refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<GroupDetailsBlogsBloc, GroupDetailsBlogsState>(
          builder: (context, state) {
            switch (state.status) {
              case BLogPostStatus.loading:
                if (state.posts.length == 0) return LoadingBloc();
                return showInfo(state);
              case BLogPostStatus.failure:
                if (state.posts.length > 0) return showInfo(state);
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      widget.groupDetailsBlogsBloc
                          .add(GroupBlogPostsFetched(groupId: widget.groupId, rebuildScreen: true));
                    });
              case BLogPostStatus.success:
                return showInfo(state);
              default:
                return LoadingBloc();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(GroupDetailsBlogsState state) {
    if (state.posts.length == 0) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            widget.groupDetailsBlogsBloc
                .add(GroupBlogPostsFetched(groupId: widget.groupId, rebuildScreen: true));
          });
    }
    return RefreshData(
      refreshController: refreshController,
      onRefresh: () {
        isUpdateValue = true;
        widget.groupDetailsBlogsBloc
            .add(GroupBlogPostsFetched(groupId: widget.groupId, rebuildScreen: true));
      },
      body: ListView.builder(
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (context, index) {
          if (!calledRequestForPagenation && (index) == state.posts.length - 3) {
            widget.groupDetailsBlogsBloc.add(GroupBlogPostsFetched(groupId: widget.groupId));
            calledRequestForPagenation = true;
          }
          return index >= state.posts.length
              ? BottomLoader()
              : BlogPostListItem(
                  post: state.posts[index],
                  play: false,
                  function: () {
                    Navigator.pop(context);
                    widget.groupDetailsBlogsBloc.add(
                        DeleteBlog(index: index, blogId: state.posts[index].id, context: context));
                  },
                );
        },
      ),
      // InViewNotifierList(
      //   scrollDirection: Axis.vertical,
      //   initialInViewIds: ['0'],
      //   primary: false,
      //   shrinkWrap: true,
      //   physics: NeverScrollableScrollPhysics(),
      //   isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension) {
      //     return deltaTop < (0.5 * viewPortDimension) && deltaBottom > (0.5 * viewPortDimension);
      //   },
      //   itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
      //   controller: _scrollController,
      //   builder: (BuildContext context, int index) {
      //     return LayoutBuilder(
      //       builder: (BuildContext context, BoxConstraints constraints) {
      //         return InViewNotifierWidget(
      //           id: '$index',
      //           builder: (BuildContext context, bool isInView, Widget child) {
      //             return index >= state.posts.length
      //                 ? BottomLoader()
      //                 : BlogPostListItem(
      //                     post: state.posts[index],
      //                     play: isInView,
      //                     function: () {
      //                       Navigator.pop(context);
      //                       widget.groupDetailsBlogsBloc.add(DeleteBlog(
      //                           index: index, blogId: state.posts[index].id, context: context));
      //                     },
      //                   );
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isUpdateValue)
      widget.groupDetailsBlogsBloc.add(GroupBlogPostsFetched(groupId: widget.groupId));
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
