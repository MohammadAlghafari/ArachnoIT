import 'dart:async';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:equatable/equatable.dart';

part 'terms_and_condition_event.dart';

part 'terms_and_condition_state.dart';

class TermsAndConditionBloc extends Bloc<TermsAndConditionEvent, TermsAndConditionState> {
  CatalogFacadeService catalogFacadeService;

  TermsAndConditionBloc({
    @required this.catalogFacadeService,
  })  : assert(catalogFacadeService != null),
        super(
          const TermsAndConditionState(),
        );

  @override
  Stream<TermsAndConditionState> mapEventToState(
    TermsAndConditionEvent event,
  ) async* {
    if (event is GetTermsAndConditionEvent) {
      yield state.copyWith(
        status: TermsProviderStatus.loading,
      );
      yield await _mapGetTermsAndConditionInfo(state, event);
    } else if (event is RefreshDataEvent) {
      yield await _mapGetTermsAndConditionInfo(state, event);
    } else if (event is FailedGettingTermsAndCondition) {
      yield state.copyWith(
        status: TermsProviderStatus.failure,
        terms: null,
      );
    }
  }

  Future<TermsAndConditionState> _mapGetTermsAndConditionInfo(
      TermsAndConditionState state, TermsAndConditionEvent event) async {
    try {
      final terms = await _fetchTermsAndCondition(event);
      return terms.isEmpty
          ? state
          : state.copyWith(
              status: TermsProviderStatus.success,
              terms: terms,
            );
    } catch (e) {
      return state.copyWith(status: TermsProviderStatus.failure);
    }
  }

  Future<String> _fetchTermsAndCondition(GetTermsAndConditionEvent event) async {
    try {
      final response = await catalogFacadeService.getTermsInfo(
        termsOrPolicy: event.termsOrPolicy,
      );

      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching Terms');
    } on Exception catch (_) {
      throw Exception('error fetching Terms');
    }
  }
}
