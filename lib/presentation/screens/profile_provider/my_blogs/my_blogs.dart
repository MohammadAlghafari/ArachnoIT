import 'package:arachnoit/application/home_blog/home_blog_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/blog_post_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/add_blog/add_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../injections.dart';

class MyBlogsScreen extends StatefulWidget {
  final String userId;
  MyBlogsScreen({this.userId = ""});
  @override
  _MyBlogsScreen createState() => _MyBlogsScreen();
}

class _MyBlogsScreen extends State<MyBlogsScreen> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  HomeBlogBloc homeBlogBloc;
  bool successRequestBefore=false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    homeBlogBloc = serviceLocator<HomeBlogBloc>();
    homeBlogBloc.add(HomeBlogPostFetched(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => homeBlogBloc,
      child: BlocListener<HomeBlogBloc, HomeBlogState>(
        listener: (context, state) {
          print("The stat us is ${state.status}");
          if(state.status==BLogPostStatus.success )
          successRequestBefore=true;
        },
        child: BlocBuilder<HomeBlogBloc, HomeBlogState>(
          builder: (context, state) {
            switch (state.status) {
              case BLogPostStatus.loadingData:
                return LoadingBloc();
              case BLogPostStatus.failure:
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      homeBlogBloc.add(ReloadHomeBlogPostFetched(userId: widget.userId));
                    });

              case BLogPostStatus.success:
                return showInfo(state);
              default:
                if (successRequestBefore){
                  return showInfo(state);
                } 
                return LoadingBloc();
            }
          },
        ),
      ),
    );
  }

  final refreshController = RefreshController();
  Widget showInfo(HomeBlogState state) {
    if (state.posts.isEmpty) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            homeBlogBloc.add(ReloadHomeBlogPostFetched(userId: widget.userId));
          });
    }
    return Scaffold(
      floatingActionButton: ((GlobalPurposeFunctions.isHealthcareProvider()))
          ? FloatingActionButton(
              elevation: 2,
              child: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, AddBlogPage.routeName).then((value) {
                  if (value != null && (value as bool)) {
                    homeBlogBloc.add(ReloadHomeBlogPostFetched(userId: widget.userId));
                  }
                });
              })
          : Container(),
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
                            homeBlogBloc.add(DeleteBlog(
                                index: index, blogId: state.posts[index].id, context: context));
                          },
                        );
                },
              );
            },
          );
        },
        onListEndReached: () {
          homeBlogBloc.add(HomeBlogPostFetched());
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
    if (_isBottom) homeBlogBloc.add(HomeBlogPostFetched());
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
