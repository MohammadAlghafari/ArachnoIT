import 'package:arachnoit/application/pending_list_department/pending_list_department_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/pending_item/pending_item.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/utils/params.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/pending_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'department_detail.dart';

class PendingListDepartmentView extends StatefulWidget {
  @override
  _PendingListDepartmentViewState createState() => _PendingListDepartmentViewState();
}

class _PendingListDepartmentViewState extends State<PendingListDepartmentView>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  PendingListDepartmentBloc pendingListDepartmentBloc;

  @override
  void initState() {
    super.initState();
    pendingListDepartmentBloc = serviceLocator<PendingListDepartmentBloc>();
    pendingListDepartmentBloc.add(FetchPendingListDepartmentEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: pendingListDepartmentBloc,
      child: BlocConsumer<PendingListDepartmentBloc, PendingListDepartmentState>(
          listener: (context, state) {
        if (state.stateStatus == PendingListDepartmentStatus.leaveOrAcceptEventLoading)
          GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
        else if (state.stateStatus == PendingListDepartmentStatus.successAcceptDepartment ||
            state.stateStatus == PendingListDepartmentStatus.successLeaveDepartment)
          GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
        else if (state.stateStatus == PendingListDepartmentStatus.operationFailed) {
          GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          GlobalPurposeFunctions.showToast(AppLocalizations.of(context).process_failure, context);
        }
      }, builder: (context, state) {
        if (state.stateStatus == PendingListDepartmentStatus.failure)
          return BlocError(
            context: context,
            blocErrorState: BlocErrorState.userError,
            function: () => pendingListDepartmentBloc.add(FetchPendingListDepartmentEvent()),
          );
        else if (state.stateStatus == PendingListDepartmentStatus.loading||state.stateStatus == PendingListDepartmentStatus.initial)
          return Center(child: CircularProgressIndicator());
        else if (state.stateStatus == PendingListDepartmentStatus.success)
          return departmentLoaded(state);
        else
          return departmentLoaded(state);
      }),
    );
  }

  final refreshController = RefreshController();
  Widget departmentLoaded(PendingListDepartmentState state) {
    final departments = state.departments;

    return departments.isNotEmpty
        ? RefreshData(
            refreshController: refreshController,
            onRefresh: () {
              pendingListDepartmentBloc.add(FetchPendingListDepartmentEvent(rebuildScreen: true));
            },
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final departmentObj = departments[index];
                return index >= departments.length
                    ? BottomLoader()
                    : PendingListItem(
                        pendingItemContaint: PendingItem(
                            description: departmentObj.description,
                            name: departmentObj.name,
                            requestStatus: departmentObj.requestStatus,
                            imageUrl: ""),
                        acceptInovationFuncation: () => acceptInvitation(departmentObj.id),
                        leaveFunction: () => refuseInvitation(departmentObj.id),
                        navigatorFunction: () => navigation(departmentObj),
                      );
              },
              itemCount: state.hasReachedMax ? departments.length : departments.length + 1,
              controller: _scrollController,
            ),
          )
        : Center(
            child: Text("No Invitations yet!!"),
          );
  }

  void acceptInvitation(String departmentId) {
    pendingListDepartmentBloc.add(AcceptOrLeaveDepartmentEvent(
      requestType: RequestType.Accept,
      departmentId: departmentId,
    ));
  }

  void refuseInvitation(String departmentId) {
    pendingListDepartmentBloc.add(AcceptOrLeaveDepartmentEvent(
      requestType: RequestType.Leave,
      departmentId: departmentId,
    ));
  }

  void navigation(DepartmentModel departmentModel) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DepartmentDetail(
              departmentModel: departmentModel,
            )));
  }

  void _onScroll() {
    if (_isBottom) {
      pendingListDepartmentBloc..add(FetchPendingListDepartmentEvent());
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
