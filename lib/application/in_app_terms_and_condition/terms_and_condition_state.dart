part of 'terms_and_condition_bloc.dart';

enum TermsProviderStatus {
  initial,
  loading,
  success,
  failure,
}

@immutable
class TermsAndConditionState {
  const TermsAndConditionState({
    this.status = TermsProviderStatus.initial,
    this.terms,
  });

  final TermsProviderStatus status;
  final String terms;

  TermsAndConditionState copyWith({
    TermsProviderStatus status,
    String terms,
  }) {
    return TermsAndConditionState(
      status: status ?? this.status,
      terms: terms ?? this.terms,
    );
  }
}
