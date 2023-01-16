part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageInitialEvent extends LanguageEvent {
  const LanguageInitialEvent();
}

class LanguageChangedEvent extends LanguageEvent {
  const LanguageChangedEvent({this.language});

  final String language;

  @override
  List<Object> get props => [language];
}
