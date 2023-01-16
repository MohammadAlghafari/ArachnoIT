import 'package:arachnoit/application/providers_all/providers_all_bloc.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/providers_favorite/providers_favorite_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/providers_provider_list_item.dart';

class ProvidersFavoriteScreen extends StatefulWidget {
  ProvidersFavoriteScreen({
    Key key,
  }) : super(key: key);

  @override
  _ProvidersFavoriteScreenState createState() => _ProvidersFavoriteScreenState();
}

class _ProvidersFavoriteScreenState extends State<ProvidersFavoriteScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final refreshController = RefreshController();
  ProvidersFavoriteBloc providersFavoriteBloc;
  bool isRefreshData = false;
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    providersFavoriteBloc = serviceLocator<ProvidersFavoriteBloc>();
    providersFavoriteBloc.add(ProvidersFavoriteFetch(rebuildScreen: false));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => providersFavoriteBloc,
      child: BlocListener<ProvidersFavoriteBloc, ProvidersFavoriteState>(
        listener: (context, state) {
          if (state.status == ProvidersFavoriteStatus.success) {
            isRefreshData = false;
            successRequestBefore = true;
            refreshController.refreshCompleted();
          } else {
            isRefreshData = false;
            refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<ProvidersFavoriteBloc, ProvidersFavoriteState>(
          builder: (context, state) {
            if (successRequestBefore) return showInfo(state);
            switch (state.status) {
              case ProvidersFavoriteStatus.failure:
                if (state.providers.length != 0) return showInfo(state);
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    providersFavoriteBloc.add(ProvidersFavoriteFetch(rebuildScreen: false));
                  },
                );
              case ProvidersFavoriteStatus.success:
                return showInfo(state);
              default:
                if (state.providers.length == 0) return LoadingBloc();
                return showInfo(state);
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(ProvidersFavoriteState state) {
    if (state.providers.length == 0) {
      return BlocError(
        context: context,
        blocErrorState: BlocErrorState.noPosts,
        function: () {
          providersFavoriteBloc.add(ProvidersFavoriteFetch(rebuildScreen: true));
        },
      );
    }
    return RefreshData(
      refreshController: refreshController,
      onRefresh: () {
        isRefreshData = true;
        providersFavoriteBloc.add(ProvidersFavoriteFetch(rebuildScreen: true));
      },
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.providers.length
              ? BottomLoader()
              : ProvidersProviderListItem(
                  provider: state.providers[index],
                  deleteItemFunction: () {
                    providersFavoriteBloc.add(DeleteItem(index: index));
                  },
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
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isRefreshData)
      providersFavoriteBloc.add(ProvidersFavoriteFetch(rebuildScreen: false));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll < 0.9) return false;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  bool get wantKeepAlive => true;
}
