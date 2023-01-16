import 'package:arachnoit/application/home/home_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/add_blog/add_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../application/home_blog/home_blog_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/blog_post_list_item.dart';
import '../../custom_widgets/bottom_loader.dart';

class HomeBlogScreen extends StatefulWidget {
  final String userId;
  final bool shouldReloadData;
  HomeBlogScreen({this.userId = "", @required this.shouldReloadData});
  @override
  _HomeBlogScreenState createState() => _HomeBlogScreenState();
}

class _HomeBlogScreenState extends State<HomeBlogScreen> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  HomeBlogBloc homeBlogBloc;
  HomeBloc homeBloc;
  bool successRequestBefore = false;
  bool isRefreshData = false;
  bool calledRequestForPagenation = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    homeBlogBloc = serviceLocator<HomeBlogBloc>();
    homeBloc = serviceLocator<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    homeBlogBloc.add(HomeBlogPostFetched(userId: widget.userId));
    super.build(context);
    return BlocProvider(
      create: (context) => homeBlogBloc,
      child: BlocListener<HomeBlogBloc, HomeBlogState>(
        listener: (context, state) {
          isRefreshData = false;
          homeBloc.add(ChangeDestroyBlogsStatus(destoryStatus: false));
          if (state.status == BLogPostStatus.success) {
            successRequestBefore = true;
            calledRequestForPagenation = false;
            homeBloc.add(ChangeDestroyBlogsStatus(destoryStatus: false));
            refreshController.refreshCompleted();
          } else if (state.status == BLogPostStatus.failure) {
            calledRequestForPagenation = false;
            refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<HomeBlogBloc, HomeBlogState>(
          builder: (context, state) {
            if (successRequestBefore) return showInfo(state);
            switch (state.status) {
              case BLogPostStatus.loadingData:
                return LoadingBloc();
              case BLogPostStatus.failure:
                print('failer');
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      homeBlogBloc.add(HomeBlogPostFetched(userId: widget.userId));
                    });

              case BLogPostStatus.success:
                return showInfo(state);
              default:
                if (state.posts.length != 0) return showInfo(state);
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
      Scaffold(
        floatingActionButton: ((GlobalPurposeFunctions.isHealthcareProvider()))
            ? FloatingActionButton(
                elevation: 2,
                child: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddBlogPage()))
                      .then((value) {
                    if (value != null) {
                      successRequestBefore = false;
                      homeBlogBloc
                          .add(ReloadHomeBlogPostFetched(userId: widget.userId, reloadData: true));
                    }
                  });
                })
            : Container(),
        body: BlocError(
            context: context,
            blocErrorState: BlocErrorState.noPosts,
            function: () {
              homeBlogBloc.add(ReloadHomeBlogPostFetched(userId: widget.userId));
            }),
      );
    }
    return Scaffold(
      floatingActionButton: ((GlobalPurposeFunctions.isHealthcareProvider()))
          ? FloatingActionButton(
              elevation: 2,
              child: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddBlogPage()))
                    .then((value) {
                  if (value != null) {
                    successRequestBefore = false;
                    homeBlogBloc
                        .add(ReloadHomeBlogPostFetched(userId: widget.userId, reloadData: true));
                  }
                });
              })
          : Container(),
      body: RefreshData(
        onRefresh: () {
          if (widget.userId.length != 0)
            homeBlogBloc.add(ReloadHomeBlogPostFetched(userId: widget.userId, reloadData: true));
          else
            homeBlogBloc.add(ReloadHomeBlogPostFetched(reloadData: true));
        },
        refreshController: refreshController,
        body: ListView.builder(
          itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
          itemBuilder: (context, index) {
            if (!calledRequestForPagenation && (index) == state.posts.length - 3) {
              homeBlogBloc.add(HomeBlogPostFetched());
              calledRequestForPagenation = true;
            }
            return index >= state.posts.length
                ? BottomLoader()
                : BlogPostListItem(
                    post: state.posts[index],
                    play: false,
                    function: () {
                      Navigator.pop(context);
                      homeBlogBloc.add(DeleteBlog(
                          index: index, blogId: state.posts[index].id, context: context));
                    },
                  );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isRefreshData) {
      homeBlogBloc.add(HomeBlogPostFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  bool get wantKeepAlive => !widget.shouldReloadData;
}
