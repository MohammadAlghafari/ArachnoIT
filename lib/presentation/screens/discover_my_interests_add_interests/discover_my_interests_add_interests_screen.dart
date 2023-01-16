import 'package:arachnoit/application/discover_my_interests_add_interests/discover_my_interests_add_interests_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/discover_my_interests_add_interests_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/restart_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscoverMyInterestsAddInterestsScreen extends StatefulWidget {
  final bool showAppBar;
  DiscoverMyInterestsAddInterestsScreen({Key key, this.showAppBar = false}) : super(key: key);

  @override
  _DiscoverMyInterestsAddInterestsScreen createState() => _DiscoverMyInterestsAddInterestsScreen();
}

class _DiscoverMyInterestsAddInterestsScreen extends State<DiscoverMyInterestsAddInterestsScreen>
    with AutomaticKeepAliveClientMixin {
  DiscoverMyInterestsAddInterestsBloc discoverMyInterestsAtInterestsBloc;
  List<CategoryResponse> categoryResponse = [];
  RefreshController refreshController = RefreshController();
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    discoverMyInterestsAtInterestsBloc = serviceLocator<DiscoverMyInterestsAddInterestsBloc>();
    discoverMyInterestsAtInterestsBloc.add(FetchMyInterestAddInterest());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: (widget.showAppBar)
          ? AppBarProject.showAppBar(title: AppLocalizations.of(context).discover)
          : null,
      body: Container(
        child: BlocProvider<DiscoverMyInterestsAddInterestsBloc>.value(
          value: discoverMyInterestsAtInterestsBloc,
          child: BlocListener<DiscoverMyInterestsAddInterestsBloc,
              DiscoverMyInterestsAddInterestsState>(
            listener: (context, state) {
              if (state is GetMyInterestAddInterestSuccess) {
                successRequestBefore = true;
                refreshController.refreshCompleted();
                categoryResponse = [];
                for (CategoryResponse item in state.categoryList)
                  if (item.subCategories.length > 0) categoryResponse.add(item);
              } else if (state is SuccessUpdateSubCategoryState) {
                refreshController.refreshFailed();
                GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
                discoverMyInterestsAtInterestsBloc
                    .add(SendActionSubscrption(categoryResponse: categoryResponse));
                categoryResponse[state.index] = state.categoryResponse;
              } else if (state is FailedSendActionSubscrption) {
                refreshController.refreshFailed();
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                GlobalPurposeFunctions.showToast(state.message, context);
              } else {
                refreshController.refreshFailed();
              }
            },
            child: BlocBuilder<DiscoverMyInterestsAddInterestsBloc,
                DiscoverMyInterestsAddInterestsState>(
              builder: (context, state) {
                if (successRequestBefore) return showInfo();
                if (state is LoadingState) {
                  return LoadingBloc();
                } else if (state is RemoteClientErrorState) {
                  return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.userError,
                    errorTitle: AppLocalizations.of(context).server_error,
                    function: () {
                      discoverMyInterestsAtInterestsBloc.add(FetchMyInterestAddInterest());
                    },
                  );
                } else if (state is RemoteServerErrorState) {
                  return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.serverError,
                    errorTitle: AppLocalizations.of(context).server_error,
                    function: () {
                      discoverMyInterestsAtInterestsBloc.add(FetchMyInterestAddInterest());
                    },
                  );
                } else if (state is RemoteValidationErrorState) {
                  return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.validationError,
                    errorTitle: AppLocalizations.of(context).server_error,
                    function: () {
                      discoverMyInterestsAtInterestsBloc.add(FetchMyInterestAddInterest());
                    },
                  );
                } else {
                  return showInfo();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget showInfo() {
    return Stack(
      children: [
        RefreshData(
          refreshController: refreshController,
          onRefresh: () {
            discoverMyInterestsAtInterestsBloc.add(FetchMyInterestAddInterest(isRefreshData: true));
          },
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, i) => (categoryResponse[i].subCategories.length > 0)
                ? DiscoverMyInterestsAddInterestsItem(
                    categoryItem: categoryResponse[i],
                    index: i,
                    categoryResponse: categoryResponse,
                    discoverMyInterestsAtInterestsBloc: discoverMyInterestsAtInterestsBloc)
                : Container(),
            itemCount: categoryResponse.length,
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(bottom: 50),
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     physics: BouncingScrollPhysics(),
        //     itemCount: categoryResponse.length,
        //     itemBuilder: (context, index) {
        //       return DiscoverMyInterestsAddInterestsItem(
        //         categoryItem: categoryResponse[index],
        //         index: index,
        //       );
        //     },
        //   ),
        // ),
        // saveButton(context)
      ],
    );
  }

  Widget saveButton(BuildContext context) {
    return Positioned(
      bottom: -7,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          discoverMyInterestsAtInterestsBloc
              .add(SendActionSubscrption(categoryResponse: categoryResponse));
        },
        height: 60,
        child: Center(
          child: Text(
            AppLocalizations.of(context).save,
            style: boldMontserrat(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        color: Colors.black,
      ),
    );
  }

  Widget showAppBar() {
    return AppBarProject.showAppBar(
      title: AppLocalizations.of(context).my_interests,
    );
  }

  Widget showError() {
    return Container(
      child: InkWell(
        onTap: () {
          discoverMyInterestsAtInterestsBloc.add(SendActionSubscrption());
        },
        child: Center(
          child: Text("Error Happened Try again"),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
