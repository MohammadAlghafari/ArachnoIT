import 'package:arachnoit/application/providers_favorite/providers_favorite_bloc.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/providers_all/providers_all_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/providers_provider_list_item.dart';

class ProvidersAllScreen extends StatefulWidget {
  ProvidersAllScreen({
    Key key,
  }) : super(key: key);

  @override
  _ProvidersAllScreenState createState() => _ProvidersAllScreenState();
}

class _ProvidersAllScreenState extends State<ProvidersAllScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  ProvidersAllBloc providersAllBloc;
  final refreshController = RefreshController();
  bool successRequestBefore = false;
  bool isRefreshData = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    providersAllBloc = serviceLocator<ProvidersAllBloc>();
    providersAllBloc.add(ProvidersAllFetch());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => providersAllBloc,
      child: BlocListener<ProvidersAllBloc, ProvidersAllState>(
        listener: (context, state) {
          if (state.status == ProvidersAllStatus.success) {
            successRequestBefore = true;
            refreshController.refreshCompleted();
            isRefreshData = false;
          } else {
            refreshController.refreshFailed();
            isRefreshData = false;
          }
        },
        child: BlocBuilder<ProvidersAllBloc, ProvidersAllState>(
          builder: (context, state) {
            if (successRequestBefore) return showItem(state);
            switch (state.status) {
              case ProvidersAllStatus.failure:
                if (successRequestBefore) {
                  return showItem(state);
                }
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    providersAllBloc.add(ProvidersAllFetch());
                  },
                );
              case ProvidersAllStatus.success:
                return showItem(state);
              default:
                {
                  if (successRequestBefore) {
                    return showItem(state);
                  } else
                    return LoadingBloc();
                }
            }
          },
        ),
      ),
    );
  }

  Widget showItem(ProvidersAllState state) {
    if (state.providers.length == 0) {
      return BlocError(
        context: context,
        blocErrorState: BlocErrorState.noPosts,
        function: () {
          providersAllBloc.add(ProvidersAllFetch());
        },
      );
    }
    return RefreshData(
      onRefresh: () {
        isRefreshData = true;

        providersAllBloc.add(ProvidersAllFetch(rebuildScreen: true));
      },
      refreshController: refreshController,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.providers.length
              ? BottomLoader()
              : ProvidersProviderListItem(
                  provider: state.providers[index],
                  deleteItemFunction: () {},
                  index: -1,
                );
        },
        itemCount: state.hasReachedMax ? state.providers.length : state.providers.length + 1,
        controller: _scrollController,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isRefreshData) providersAllBloc.add(ProvidersAllFetch());
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
