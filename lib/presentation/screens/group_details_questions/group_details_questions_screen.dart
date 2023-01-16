import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/group_details_questions/group_details_questions_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/qaa_post_list_item.dart';

class GroupDetailsQuestionsScreen extends StatefulWidget {
  GroupDetailsQuestionsScreen({Key key, @required this.groupId,@required this.groupDetailsQuestionsBloc}) : super(key: key);
  final String groupId;
final GroupDetailsQuestionsBloc groupDetailsQuestionsBloc; 
  @override
  _GroupDetailsQuestionsScreenState createState() => _GroupDetailsQuestionsScreenState();
}

class _GroupDetailsQuestionsScreenState extends State<GroupDetailsQuestionsScreen>
    with AutomaticKeepAliveClientMixin {
  bool calledRequestForPagenation = false;
  bool isUpdateValue = false;
  final _scrollController = ScrollController();
  
  final refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.groupDetailsQuestionsBloc.add(GroupQuestionPostsFetched(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => widget.groupDetailsQuestionsBloc,
      child: BlocListener<GroupDetailsQuestionsBloc, GroupDetailsQuestionsState>(
        listener: (context, state) {
          print("the state.status ${state.status}");
          if (state.status == QaaPostStatus.success) {
            isUpdateValue = false;
            refreshController.refreshCompleted();
          } else if (state.status == QaaPostStatus.failure) {
            isUpdateValue = false;
            refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<GroupDetailsQuestionsBloc, GroupDetailsQuestionsState>(
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
                      widget.groupDetailsQuestionsBloc.add(
                          GroupQuestionPostsFetched(groupId: widget.groupId, refreshData: true));
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

  Widget showInfo(GroupDetailsQuestionsState state) {
    if (state.posts.length == 0) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            widget.groupDetailsQuestionsBloc
                .add(GroupQuestionPostsFetched(groupId: widget.groupId, refreshData: true));
          });
    }
    return RefreshData(
      refreshController: refreshController,
      onRefresh: () {
        isUpdateValue = true;
        widget.groupDetailsQuestionsBloc
            .add(GroupQuestionPostsFetched(groupId: widget.groupId, refreshData: true));
      },
      body: ListView.builder(
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        itemBuilder: (context, index) {
          if (!calledRequestForPagenation && (index) == state.posts.length - 3) {
            widget.groupDetailsQuestionsBloc.add(GroupQuestionPostsFetched(groupId: widget.groupId));
            calledRequestForPagenation = true;
          }
          return index >= state.posts.length
              ? BottomLoader()
              : QaaPostListItem(
                  post: state.posts[index],
                  deleteItemFunction: () {
                    Navigator.pop(context);
                    widget.groupDetailsQuestionsBloc.add(DeleteQuestion(
                      questionId: state.posts[index].questionId,
                      context: context,
                      index: index,
                    ));
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
      //                 : QaaPostListItem(
      //                     post: state.posts[index],
      //                     deleteItemFunction: () {
      //                       Navigator.pop(context);
      //                       groupDetailsQuestionsBloc.add(DeleteQuestion(
      //                         questionId: state.posts[index].questionId,
      //                         context: context,
      //                         index: index,
      //                       ));
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
      widget.groupDetailsQuestionsBloc.add(GroupQuestionPostsFetched(groupId: widget.groupId));
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
