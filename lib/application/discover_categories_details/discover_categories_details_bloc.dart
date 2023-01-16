import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'discover_categories_details_event.dart';
part 'discover_categories_details_state.dart';

const _pageLimit = 20;

class DiscoverCategoriesDetailsBloc
    extends Bloc<DiscoverCategoriesDetailsEvent, DiscoverCategoriesDetailsState> {
  DiscoverCategoriesDetailsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const DiscoverCategoriesDetailsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<DiscoverCategoriesDetailsState> mapEventToState(
    DiscoverCategoriesDetailsEvent event,
  ) async* {
    if (event is FetchSubCategoryDataEvent) yield* _mapFetchDataToState(event, state);
  }

  Stream<DiscoverCategoriesDetailsState> _mapFetchDataToState(
      FetchSubCategoryDataEvent event, DiscoverCategoriesDetailsState state) async* {
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    if (event.blogsCount == 0 && event.groupsCount  == 0 && event.questionsCount == 0) {
      state = state.copyWith(
          blogs: [],
          groups: [],
          questions: [],
          selectedItemIndex: event.selectedItemIndex,
          loading: false,
          isError: false);
      yield state;
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      return;
    }
    try {
      state = state.copyWith(
          blogs: [],
          groups: [],
          questions: [],
          selectedItemIndex: event.selectedItemIndex,
          loading: true,
          isError: false);
      yield state;
      if (event.blogsCount != 0) {
        try {
          final blogs = await catalogService.getSubCategoryBlogs(
            categoryId: event.categoryId,
            subCategoryId: event.subCategoryId,
            pageNumber: 0,
            pageSize: _pageLimit,
          );
          GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
          switch (blogs.responseType) {
            case ResType.ResponseType.SUCCESS:
              state = state.copyWith(
                  blogs: blogs.data,
                  groups: state.groups,
                  questions: state.questions,
                  selectedItemIndex: state.selectedItemIndex,
                  loading: false,
                  isError: false);
              yield state;
              break;
            case ResType.ResponseType.VALIDATION_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.SERVER_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.CLIENT_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.NETWORK_ERROR:
              yield state.copyWith(isError: true);
              break;
          }
        } catch (_) {
          GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
          yield state.copyWith(isError: true);
        }
      }
      if (event.groupsCount != 0) {
        try {
          final groups = await catalogService.getSubCategoryGroups(
            pageNumber: 0,
            pageSize: _pageLimit,
            enablePagination: false,
            searchString: '',
            healthcareProviderId: '',
            approvalListOnly: false,
            ownershipType: 3,
            categoryId: '',
            subCategoryId: event.subCategoryId,
            mySubscriptionsOnly: false,
          );
          GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
          switch (groups.responseType) {
            case ResType.ResponseType.SUCCESS:
              state = state.copyWith(
                  blogs: state.blogs,
                  groups: groups.data,
                  questions: state.questions,
                  selectedItemIndex: state.selectedItemIndex,
                  loading: false,
                  isError: false);
              yield state;
              break;
            case ResType.ResponseType.VALIDATION_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.SERVER_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.CLIENT_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.NETWORK_ERROR:
              yield state.copyWith(isError: true);
              break;
          }
        } catch (_) {
          GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
          yield state.copyWith(isError: true);
        }
      }

      if (event.questionsCount != 0) {
        try {
          final questions = await catalogService.getSubCategoryQuestions(
            categoryId: event.categoryId,
            subCategoryId: event.subCategoryId,
            pageNumber: 0,
            pageSize: _pageLimit,
          );
          GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
          switch (questions.responseType) {
            case ResType.ResponseType.SUCCESS:
              state = state.copyWith(
                  blogs: state.blogs,
                  groups: state.groups,
                  questions: questions.data,
                  selectedItemIndex: state.selectedItemIndex,
                  loading: false,
                  isError: false);
              yield state;
              break;
            case ResType.ResponseType.VALIDATION_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.SERVER_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.CLIENT_ERROR:
              yield state.copyWith(isError: true);
              break;
            case ResType.ResponseType.NETWORK_ERROR:
              yield state.copyWith(isError: true);
              break;
          }
        } catch (_) {
          GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
          yield state.copyWith(isError: true);
        }
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield state.copyWith(isError: true);
    }
  }
}
