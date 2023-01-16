part of 'profile_provider_language_bloc.dart';

abstract class ProfileProviderLanguageEvent extends Equatable {
  const ProfileProviderLanguageEvent();

  @override
  List<Object> get props => [];
}

class GetAllLanguage extends ProfileProviderLanguageEvent {
  final bool newRequest;
  final bool forHealthCareProvider;
  final String userId;
  final BuildContext context;
  GetAllLanguage({this.newRequest, this.forHealthCareProvider = true,@required this.userId,@required this.context});
}

class AddNewLanguage extends ProfileProviderLanguageEvent {
  final int languageLevel;
  final String languageId;
  final BuildContext  context;
  AddNewLanguage({this.languageId, this.languageLevel,this.context});
}

class ShowLanguageLevel extends ProfileProviderLanguageEvent {}

class DeletetItem extends ProfileProviderLanguageEvent {
  final String itemId;
  final int index;
  final BuildContext context;
  DeletetItem({this.itemId, this.index,@required this.context});
}

class UpdateListValue extends ProfileProviderLanguageEvent {
  final int level;
  final int index;
  UpdateListValue({this.level,this.index});
}
