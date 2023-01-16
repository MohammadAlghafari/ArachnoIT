import 'package:arachnoit/application/search_provider/search_provider_bloc.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/search_provider_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchProviderScreen extends StatefulWidget {
  final bool shouldDestroyWidget;
  final String searchTextQuery;
  final String accountTypeId;
  final String cityId;
  final String countryId;
  final int gender;
  final String serviceId;
  final String subSpecificationId;
  final bool isAdvanceSearch;
  final List<String> specificationsIds;
  SearchProviderScreen(
      {this.shouldDestroyWidget = true,
      this.searchTextQuery,
      this.isAdvanceSearch = false,
      this.subSpecificationId,
      this.accountTypeId,
      this.countryId,
      this.cityId,
      this.gender,
      this.serviceId,
      this.specificationsIds = const <String>[]});
  @override
  State<StatefulWidget> createState() {
    return _SearchProviderScreen();
  }
}

class _SearchProviderScreen extends State<SearchProviderScreen>
    with AutomaticKeepAliveClientMixin {
  SearchProviderBloc searchProviderBloc;
  final _scrollController = ScrollController();
  final refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    searchProviderBloc = serviceLocator<SearchProviderBloc>();
  }

  getData() {
    if (widget.searchTextQuery != null && !widget.isAdvanceSearch) {
      searchProviderBloc.add(FetchSearchTextProvider(
          newRequest: true, query: widget.searchTextQuery));
    } else if (widget.isAdvanceSearch) {
      searchProviderBloc.add(FetchAdvanceSearchProvider(
          newRequest: true,
          accountTypeId: widget.accountTypeId,
          gender: widget.gender,
          subSpecificationId: widget.subSpecificationId,
          cityId: widget.cityId,
          countryId: widget.countryId,
          serviceId: widget.serviceId,
          specificationsIds: widget.specificationsIds));
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    super.build(context);
    return BlocProvider(
      create: (context) => searchProviderBloc,
      child: BlocListener<SearchProviderBloc, SearchProviderState>(
        listener: (context, state) {},
        child: BlocBuilder<SearchProviderBloc, SearchProviderState>(
          builder: (context, state) {
            switch (state.status) {
              case BlogSearchProviderStatus.loading:
                if (state.posts.length != 0) return showInfo(state);
                return LoadingBloc();
              case BlogSearchProviderStatus.failure:
                if (state.posts.length != 0) return showInfo(state);
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.serverError,
                  function: () {
                    getData();
                  },
                );
              case BlogSearchProviderStatus.success:
                return showInfo(state);
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget showInfo(SearchProviderState state) {
    if (state.posts.isEmpty) {
      return BlocError(
        context: context,
        blocErrorState: BlocErrorState.noPosts,
        function: () {
          getData();
        },
      );
    }
    return RefreshData(
      onRefresh: () {
        getData();
      },
      refreshController: refreshController,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= state.posts.length
              ? BottomLoader()
              : new SearchProviderListItem(
                  advanceSearchResponse: state.posts[index]);
        },
        itemCount:
            state.hasReachedMax ? state.posts.length : state.posts.length + 1,
        controller: _scrollController,
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      if (widget.searchTextQuery != null && !widget.isAdvanceSearch) {
        searchProviderBloc.add(FetchSearchTextProvider(
            newRequest: false, query: widget.searchTextQuery));
      } else if (widget.isAdvanceSearch)
        searchProviderBloc.add(FetchAdvanceSearchProvider(
            newRequest: false,
            accountTypeId: widget.accountTypeId,
            gender: widget.gender,
            subSpecificationId: widget.subSpecificationId,
            cityId: widget.cityId,
            countryId: widget.countryId,
            serviceId: widget.serviceId,
            specificationsIds: widget.specificationsIds));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  bool get wantKeepAlive => !widget.shouldDestroyWidget;
}
