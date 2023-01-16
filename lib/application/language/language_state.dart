part of 'language_bloc.dart';

class LanguageState {
  const LanguageState();
}

class LanguageInitialState extends LanguageState {
  const LanguageInitialState({this.language});
  final String language;
}

class LanguageChangedState extends LanguageState {
  const LanguageChangedState({this.language});
  final String language;
}

class LoadingState extends LanguageState {
  const LoadingState();
}

class SameLanguageSelectedState extends LanguageState {
  const SameLanguageSelectedState({this.language});
  final String language;
}

class RemoteValidationErrorState extends LanguageState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends LanguageState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends LanguageState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}
