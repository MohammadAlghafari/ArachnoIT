import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/discover_categories/discover_categories_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/discover_category_item.dart';

class DiscoverCategoriesScreen extends StatefulWidget {
  DiscoverCategoriesScreen({Key key}) : super(key: key);

  @override
  _DiscoverCategoriesScreenState createState() => _DiscoverCategoriesScreenState();
}

class _DiscoverCategoriesScreenState extends State<DiscoverCategoriesScreen>
    with AutomaticKeepAliveClientMixin {
  DiscoverCategoriesBloc discoverCategoriesBloc;
  List<CategoryResponse> items = [];
  @override
  void initState() {
    super.initState();
    discoverCategoriesBloc = serviceLocator<DiscoverCategoriesBloc>();
    discoverCategoriesBloc.add(GetCategoriesEvent());
  }

  RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => discoverCategoriesBloc,
      child: BlocListener<DiscoverCategoriesBloc, DiscoverCategoriesState>(
        listener: (context, state) {
          if (state is GetCategoriesSucessfulState) {
            refreshController.refreshCompleted();
            items = [];
            for (CategoryResponse object in state.categories)
              if (object.subCategories.length > 0) items.add(object);
          } else {
            refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<DiscoverCategoriesBloc, DiscoverCategoriesState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return LoadingBloc();
            } else if (state is RemoteClientErrorState)
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
              );
            else if (state is RemoteServerErrorState)
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.serverError,
                function: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
              );
            else if (state is RemoteValidationErrorState) {
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.validationError,
                function: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
              );
            } else {
              return RefreshData(
                refreshController: refreshController,
                onRefresh: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent(isRefreshData: true));
                },
                body: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, i) => (items[i].subCategories.length > 0)
                      ? DiscoverCategoryItem(
                          category: items[i],
                        )
                      : Container(),
                  itemCount: items.length,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
/*
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../application/discover_categories/discover_categories_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/discover_category_item.dart';

class DiscoverCategoriesScreen extends StatefulWidget {
  DiscoverCategoriesScreen({Key key}) : super(key: key);

  @override
  _DiscoverCategoriesScreenState createState() =>
      _DiscoverCategoriesScreenState();
}

class _DiscoverCategoriesScreenState extends State<DiscoverCategoriesScreen>
    with AutomaticKeepAliveClientMixin {
  DiscoverCategoriesBloc discoverCategoriesBloc;

  @override
  void initState() {
    super.initState();
    discoverCategoriesBloc = serviceLocator<DiscoverCategoriesBloc>();
    discoverCategoriesBloc.add(GetCategoriesEvent());
  }

  RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => discoverCategoriesBloc,
      child: BlocListener<DiscoverCategoriesBloc, DiscoverCategoriesState>(
        listener: (context, state) {},
        child: BlocBuilder<DiscoverCategoriesBloc, DiscoverCategoriesState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return LoadingBloc();
            } else if (state is RemoteClientErrorState)
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
              );
            else if (state is RemoteServerErrorState)
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.serverError,
                function: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
              );
            else if (state is RemoteValidationErrorState) {
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.validationError,
                function: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
              );
            } else if (state is GetCategoriesSucessfulState) {
              return RefreshData(
                refreshController: refreshController,
                onRefresh: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
                body: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: state.categories.map((e) {
                    return DiscoverCategoryItem(
                      category: e,
                    );
                  }).toList(),
                ),
              );

              //    GridView.builder(
              //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount:2,
              //     ),
              //     itemBuilder: (context, i) => DiscoverCategoryItem(
              //       category: state.categories[i],
              //     ),
              //     itemCount: state.categories.length,
              //   ),
              // );
            } else {
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.unkownError,
                function: () {
                  discoverCategoriesBloc.add(GetCategoriesEvent());
                },
              );
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
*/
