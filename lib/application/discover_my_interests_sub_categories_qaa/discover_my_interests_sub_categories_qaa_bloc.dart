import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/home_qaa/response/qaa_response.dart';

part 'discover_my_interests_sub_categories_qaa_event.dart';
part 'discover_my_interests_sub_categories_qaa_state.dart';

const _postLimit = 20;

class DiscoverMyInterestsSubCategoriesQaaBloc extends Bloc<
    DiscoverMyInterestsSubCategoriesQaaEvent,
    DiscoverMyInterestsSubCategoriesQaaState> {
  final CatalogFacadeService catalogService;
  DiscoverMyInterestsSubCategoriesQaaBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(DiscoverMyInterestsSubCategoriesQaaState());

  @override
  Stream<DiscoverMyInterestsSubCategoriesQaaState> mapEventToState(
      DiscoverMyInterestsSubCategoriesQaaEvent event) async* {
    if (event is DiscoverMyInterestsSubCategoriesQaaFetch) {
      yield await _mapMyInterestsSubCategoriesQaaPosts(
          event.subCategoryId, state);
    } else if (event is ReloadDiscoverMyInterestsSubCategoriesQaaFetch) {
      yield state.copyWith(
          status: QaaMyInterestsSubCategoriesQaaStatus.initial,
          hasReachedMax: false,
          posts: []);

      yield await _mapMyInterestsSubCategoriesQaaPosts(
          event.subCategoryId, state);
    } else if (event is DeleteQuestion) yield* _mapDeleteQuestion(event);
  }

  Stream<DiscoverMyInterestsSubCategoriesQaaState> _mapDeleteQuestion(
      DeleteQuestion event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final posts =
          await catalogService.deleteQuestion(questionId: event.questionId);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      if (posts.data == true) {
        final list = state.posts;
        list.removeAt(event.index);
        yield state.copyWith(posts: list);
      } else {
        yield state;
      }
    } catch (e) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield state;
    }
  }

  Future<DiscoverMyInterestsSubCategoriesQaaState>
      _mapMyInterestsSubCategoriesQaaPosts(String subCategoryId,
          DiscoverMyInterestsSubCategoriesQaaState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == QaaMyInterestsSubCategoriesQaaStatus.initial) {
        final posts =
            await _fetchMyInterestsSubCategoriesQaaPosts(subCategoryId);
        return state.copyWith(
          status: QaaMyInterestsSubCategoriesQaaStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
      }
      final posts = await _fetchMyInterestsSubCategoriesQaaPosts(
          subCategoryId, (state.posts.length / _postLimit).round());
      return posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: QaaMyInterestsSubCategoriesQaaStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      return state.copyWith(
          status: QaaMyInterestsSubCategoriesQaaStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<QaaResponse>> _fetchMyInterestsSubCategoriesQaaPosts(
      String subCategoryId,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getQaaInterestsSubCategoriesReomte(
          pageNumber: startIndex,
          pageSize: _postLimit,
          subCategoryId: subCategoryId);
      print("the response.responseType ${response.responseType}");
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching qaas');
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
