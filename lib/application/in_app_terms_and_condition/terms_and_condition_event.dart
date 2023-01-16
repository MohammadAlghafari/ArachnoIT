part of 'terms_and_condition_bloc.dart';

abstract class TermsAndConditionEvent extends Equatable {
  const TermsAndConditionEvent();

  @override
  List<Object> get props => [];
}

class GetTermsAndConditionEvent extends TermsAndConditionEvent {
  final int termsOrPolicy;

  GetTermsAndConditionEvent({
    this.termsOrPolicy,
  });
}

class RefreshDataEvent extends TermsAndConditionEvent {
  final int termsOrPolicy;

  RefreshDataEvent({
    this.termsOrPolicy,
  });
}

class FailedGettingTermsAndCondition extends TermsAndConditionEvent {}
