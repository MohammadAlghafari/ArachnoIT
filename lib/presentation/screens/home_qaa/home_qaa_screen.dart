import 'package:arachnoit/application/home/home_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/qaa_post_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/home_qaa/home_qaa_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';

class HomeQaaScreen extends StatefulWidget {
  final bool shouldReloadData;
  HomeQaaScreen({@required this.shouldReloadData});
  @override
  _HomeQaaScreenState createState() => _HomeQaaScreenState();
}

class _HomeQaaScreenState extends State<HomeQaaScreen> with AutomaticKeepAliveClientMixin {
  HomeBloc homeBloc;
  final _scrollController = ScrollController();
  RefreshController controller = RefreshController();
  HomeQaaBloc homeQaaBloc;
  bool successRequestBefore = false;
  bool isRefreshData = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    homeBloc = serviceLocator<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    homeQaaBloc = serviceLocator<HomeQaaBloc>()..add(HomeQaaPostsFetch());
    super.build(context);
    return BlocProvider(
      create: (context) => homeQaaBloc,
      child: BlocListener<HomeQaaBloc, HomeQaaState>(
        listener: (context, state) {
          if (state.status == QaaPostStatus.success) {
            successRequestBefore = true;
            isRefreshData = false;
            controller.refreshCompleted();
            homeBloc.add(ChangeDestroyQAAStatus(destoryStatus: false));
          } else if (state.status != QaaPostStatus.loading &&
              state.status != QaaPostStatus.initial) {
            isRefreshData = false;
            controller.refreshFailed();
          }
        },
        child: BlocBuilder<HomeQaaBloc, HomeQaaState>(
          builder: (context, state) {
            if (successRequestBefore) return showInfo(state);
            switch (state.status) {
              case QaaPostStatus.loading:
                return LoadingBloc();
              case QaaPostStatus.failure:
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      homeQaaBloc.add(ReloadHomeQaaPostsFetch());
                    });
              case QaaPostStatus.success:
                return showInfo(state);
              default:
                return LoadingBloc();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(HomeQaaState state) {
    if (state.posts.isEmpty) {
      return Scaffold(
        floatingActionButton: (GlobalPurposeFunctions.getUserObject() != null)
            ? FloatingActionButton(
                elevation: 2,
                child: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, AddQuestionScreen.routeName).then((value) {
                    if (value != null && (value as bool)) {
                      successRequestBefore = false;

                      homeQaaBloc.add(ReloadHomeQaaPostsFetch());
                    }
                  });
                })
            : null,
        body: BlocError(
            context: context,
            blocErrorState: BlocErrorState.noPosts,
            function: () {
              homeQaaBloc.add(HomeQaaPostsFetch());
            }),
      );
    }
    return Scaffold(
        floatingActionButton: (GlobalPurposeFunctions.getUserObject() != null)
            ? FloatingActionButton(
                elevation: 2,
                child: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, AddQuestionScreen.routeName).then((value) {
                    if (value != null) {
                      successRequestBefore = false;
                      homeQaaBloc.add(ReloadHomeQaaPostsFetch());
                    }
                  });
                })
            : null,
        body: RefreshData(
          refreshController: controller,
          onRefresh: () {
            isRefreshData = true;
            homeQaaBloc.add(ReloadHomeQaaPostsFetch());
          },
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.posts.length
                  ? BottomLoader()
                  : QaaPostListItem(
                      post: state.posts[index],
                      deleteItemFunction: () {
                        Navigator.pop(context);
                        homeQaaBloc.add(DeleteQuestion(
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
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isRefreshData) homeQaaBloc.add(HomeQaaPostsFetch());
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
