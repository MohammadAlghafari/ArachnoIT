import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/screens/discover_my_interests_add_interests/discover_my_interests_add_interests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../application/discover_my_interest/discover_my_interest_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/discover_my_interest_item.dart';
import '../discover_my_interests_sub_categories_details/discover_my_interests_sub_catergories_details.dart';

class DiscoverMyIntresetsScreen extends StatefulWidget {
  final bool showAppBar;
  DiscoverMyIntresetsScreen({this.showAppBar = false});

  @override
  _DiscoverMyIntresetsScreenState createState() => _DiscoverMyIntresetsScreenState();
}

class _DiscoverMyIntresetsScreenState extends State<DiscoverMyIntresetsScreen>
    with AutomaticKeepAliveClientMixin {
  DiscoverMyInterestBloc discoverMyInterestBloc;
  var _scrollController = ScrollController();
  ValueNotifier<bool> showFloatingActionButton = ValueNotifier(true);
  RefreshController refreshController = RefreshController();
  bool isRefreshData = false;
  @override
  void initState() {
    super.initState();
    discoverMyInterestBloc = serviceLocator<DiscoverMyInterestBloc>();
    discoverMyInterestBloc.add(FetchMyInterestSubCategories());
  }

  double lastValue = -111;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: widget.showAppBar
            ? AppBarProject.showAppBar(title: AppLocalizations.of(context).my_interests)
            : null,
        body: Container(
          child: BlocProvider(
            create: (context) => discoverMyInterestBloc,
            child: BlocListener<DiscoverMyInterestBloc, DiscoverMyInterestState>(
              listener: (context, state) {
                if (state is LoadingState) {
                } else if (state is GetMyInterestSubCategoriesSuccess) {
                  refreshController.refreshCompleted();
                  if (state.subCatergories.length <= 7) {
                    showFloatingActionButton.value = true;
                    return true;
                  }
                } else
                  refreshController.refreshFailed();
              },
              child: BlocBuilder<DiscoverMyInterestBloc, DiscoverMyInterestState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return LoadingBloc();
                  } else if (state is GetMyInterestSubCategoriesSuccess) {
                    return NotificationListener<ScrollUpdateNotification>(
                        onNotification: (scrollEnd) {
                          if (state.subCatergories.length <= 5) {
                            showFloatingActionButton.value = true;
                            return true;
                          }
                          final maxScroll = _scrollController.position.maxScrollExtent;
                          final currentScroll = _scrollController.position.maxScrollExtent * 0.8;
                          if (currentScroll <= (maxScroll * 0.5)) {
                          } else {
                            var metrics = scrollEnd.metrics;
                            print(metrics);
                            if (metrics.pixels <= lastValue)
                              showFloatingActionButton.value = true;
                            else
                              showFloatingActionButton.value = false;
                            lastValue = metrics.pixels;
                            return true;
                          }
                        },
                        child: (state.subCatergories.length > 0)
                            ? RefreshData(
                                refreshController: refreshController,
                                onRefresh: () {
                                  isRefreshData = true;
                                  discoverMyInterestBloc
                                      .add(FetchMyInterestSubCategories(reloadData: true));
                                },
                                body: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: state.subCatergories.length,
                                  itemBuilder: (context, index) {
                                    return MyInterestsItem(
                                      title: state.subCatergories[index].name ?? "",
                                      counte: state.subCatergories[index].blogsCount +
                                              state.subCatergories[index].groupsCount +
                                              state.subCatergories[index].questionsCount ??
                                          0,
                                      isSubscribedTo:
                                          state.subCatergories[index].isSubscribedTo ?? false,
                                      function: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                DiscoverMyInterestsSubCategoriesDetailsScreen(
                                                  subCategoryItem: state.subCatergories[index],
                                                )));
                                      },
                                    );
                                  },
                                ),
                              )
                            : BlocError(
                                context: context,
                                blocErrorState: BlocErrorState.noPosts,
                                function: () {
                                  discoverMyInterestBloc.add(FetchMyInterestSubCategories());
                                }));
                  } else
                    return BlocError(
                        context: context,
                        blocErrorState: BlocErrorState.userError,
                        function: () {
                          discoverMyInterestBloc.add(FetchMyInterestSubCategories());
                        });
                },
              ),
            ),
          ),
        ),
        floatingActionButton: showButtonNavigatorBar());
  }

  Widget showError() {
    return Container(
      child: InkWell(
        onTap: () {
          discoverMyInterestBloc.add(FetchMyInterestSubCategories());
        },
        child: Center(
          child: Text("Error Happened Try again"),
        ),
      ),
    );
  }

  showButtonNavigatorBar() {
    return ValueListenableBuilder(
      valueListenable: showFloatingActionButton,
      builder: (BuildContext context, bool showButton, Widget child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
          opacity: (showButton) ? 1 : 0,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              if (showButton) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DiscoverMyInterestsAddInterestsScreen(showAppBar: true)));
              }
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
