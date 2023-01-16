import 'package:arachnoit/application/pending_list_group/pending_list_group_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/pending_item/pending_item.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/pending_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/group_details/group_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PendingListGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PenddingListGroup();
  }
}

class _PenddingListGroup extends State<PendingListGroup> with AutomaticKeepAliveClientMixin {
  PendingListGroupBloc penddingListGroup;
  final _scrollController = ScrollController();
  bool isUpdateValue = false;
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    penddingListGroup = serviceLocator<PendingListGroupBloc>();
    penddingListGroup.add(GetAllGroups(newRequest: true));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<PendingListGroupBloc>(
      create: (context) => penddingListGroup,
      child: BlocListener<PendingListGroupBloc, PendingListGroupState>(
        listener: (context, state) {
          GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          if (state.status == PendingListGroupStatus.success) {
            successRequestBefore = true;
            isUpdateValue = false;
            refreshController.refreshCompleted();
          } else if (state.status == PendingListGroupStatus.failure) {
            isUpdateValue = false;
            refreshController.refreshFailed();
          }
          if (state.status == PendingListGroupStatus.successAcceptOrLeaveGroup) {
            GlobalPurposeFunctions.showToast(state.message, context);
          } else if (state.status == PendingListGroupStatus.failedAcceptOrLeaveGroup) {
            GlobalPurposeFunctions.showToast(state.message, context);
          } else if (state.status == PendingListGroupStatus.success) {
            successRequestBefore = true;
          }
        },
        child: BlocBuilder<PendingListGroupBloc, PendingListGroupState>(
          builder: (context, state) {
            if (state.status == PendingListGroupStatus.loading ||
                state.status == PendingListGroupStatus.initial) {
              if (successRequestBefore)
                return showInfo(state);
              else
                return LoadingBloc();
            } else if (state.status == PendingListGroupStatus.failure) {
              if (successRequestBefore) return showInfo(state);
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  penddingListGroup.add(GetAllGroups(newRequest: true));
                },
              );
            } else {
              return showInfo(state);
            }
          },
        ),
      ),
    );
  }

  final refreshController = RefreshController();
  Widget showInfo(PendingListGroupState state) {
    if (state.posts.length == 0) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            successRequestBefore=false;
            penddingListGroup.add(GetAllGroups(newRequest: true));
          });
    } else {
      return RefreshData(
        refreshController: refreshController,
        onRefresh: () {
          isUpdateValue = true;
          penddingListGroup.add(GetAllGroups(newRequest: true));
        },
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return index >= state.posts.length ? BottomLoader() : showItem(state, index);
          },
          itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
          controller: _scrollController,
        ),
      );
    }
  }

  Widget showItem(PendingListGroupState state, int index) {
    return PendingListItem(
      pendingItemContaint: PendingItem(
          description: state.posts[index].description,
          imageUrl: state.posts[index].image == null ? "" : state.posts[index].image.url,
          name: state.posts[index].name,
          requestStatus: state.posts[index].requestStatus),
      leaveFunction: () {
        GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
        penddingListGroup.add(
          RemoveItemFromGroup(index: index, groupId: state.posts[index].groupId),
        );
      },
      acceptInovationFuncation: () {
        GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
        penddingListGroup.add(
          AcceptGroupInovation(index: index, groupId: state.posts[index].groupId),
        );
      },
      navigatorFunction: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GroupDetailsScreen(
                  groupId: state.posts[index].groupId,
                )));
      },
    );
  }

  void _onScroll() {
    if (_isBottom && !isUpdateValue) {
      penddingListGroup.add(GetAllGroups(newRequest: false));
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
