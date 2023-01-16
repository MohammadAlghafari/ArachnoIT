import 'package:arachnoit/application/pending_list_patents/pending_list_patents_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/response/patents_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/pending_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arachnoit/domain/pending_item/pending_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PendingListPatents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PendingListPatents();
  }
}

class _PendingListPatents extends State<PendingListPatents> with AutomaticKeepAliveClientMixin {
  PenddingListPatentsBloc penddingListPatentsBloc;
  final _scrollController = ScrollController();
  bool successRequestBefore = false;
  bool isUpdateValue = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    penddingListPatentsBloc = serviceLocator<PenddingListPatentsBloc>();
    penddingListPatentsBloc.add(GetAllPatentsEvent(newRequest: true));
  }

  final refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<PenddingListPatentsBloc>(
      create: (context) => penddingListPatentsBloc,
      child: BlocListener<PenddingListPatentsBloc, PenddingListPatentsState>(
        listener: (context, state) {
          if (state.status == PenddingListPatentsStatus.success) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            isUpdateValue = false;
            refreshController.refreshCompleted();
          } else if (state.status == PenddingListPatentsStatus.failure) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            isUpdateValue = false;
            refreshController.refreshFailed();
          }
          if (state.status == PenddingListPatentsStatus.rejectOrAcceptEventLoading) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          } else if (state.status == PenddingListPatentsStatus.successAcceptGroup) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          } else if (state.status == PenddingListPatentsStatus.failedRejectOrAccept) {
            GlobalPurposeFunctions.showToast(state.erroMessage, context);
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          } else if (state.status == PenddingListPatentsStatus.success) {
            successRequestBefore = true;
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          }
        },
        child: BlocBuilder<PenddingListPatentsBloc, PenddingListPatentsState>(
          builder: (context, state) {
            if (state.status == PenddingListPatentsStatus.loading ||
                state.status == PenddingListPatentsStatus.initial) {
              if (successRequestBefore) return showInfo(state);
              return LoadingBloc();
            } else if (state.status == PenddingListPatentsStatus.failure) {
              if (successRequestBefore) return showInfo(state);
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  penddingListPatentsBloc.add(GetAllPatentsEvent(newRequest: true));
                },
              );
            } else
              return showInfo(state);
          },
        ),
      ),
    );
  }

  Widget showInfo(PenddingListPatentsState state) {
    if (state.posts.length == 0) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            successRequestBefore=false;
            penddingListPatentsBloc.add(GetAllPatentsEvent(newRequest: true));
          });
    }
    return RefreshData(
      onRefresh: () {
        isUpdateValue = true;
        penddingListPatentsBloc.add(GetAllPatentsEvent(newRequest: true));
      },
      refreshController: refreshController,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length
              ? BottomLoader()
              : PendingListItem(
                  acceptInovationFuncation: () {
                    penddingListPatentsBloc
                        .add(AcceptPatentsEvent(index: index, patentsId: state.posts[index].id));
                  },
                  leaveFunction: () {
                    penddingListPatentsBloc
                        .add(RejectPatentsEvent(index: index, patentsId: state.posts[index].id));
                  },
                  pendingItemContaint: PendingItem(
                      description: state.posts[index].description,
                      imageUrl: state.posts[index].url,
                      name: state.posts[index].title,
                      requestStatus: state.posts[index].requestStatus),
                );
        },
        itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        controller: _scrollController,
      ),
    );
  }

  void _onScroll() {
    if (_isBottom && !isUpdateValue) {
      penddingListPatentsBloc.add(GetAllPatentsEvent(newRequest: false));
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
