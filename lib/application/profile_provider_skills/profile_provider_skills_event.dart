part of 'profile_provider_skills_bloc.dart';

abstract class ProfileProviderSkillsEvent extends Equatable {
  const ProfileProviderSkillsEvent();

  @override
  List<Object> get props => [];
}

class GetAllSkills extends ProfileProviderSkillsEvent {
  final bool newRequest;
  final String userId;
  GetAllSkills({this.newRequest,@required this.userId});
}

class AddNewSkill extends ProfileProviderSkillsEvent {
  final String name;
  final String startDate;
  final String endDate;
  final String description;
  final BuildContext context;
  final bool withExpireTime;
  AddNewSkill({
    this.name,
    this.startDate,
    this.endDate,
    this.description,
    this.context,
    this.withExpireTime,
  });
}

class UpdateSkill extends ProfileProviderSkillsEvent {
  final String name;
  final String startDate;
  final String endDate;
  final String description;
  final BuildContext context;
  final bool withExpireTime;
  final String itemId;
  UpdateSkill({
    this.name,
    this.startDate,
    this.endDate,
    this.description,
    this.context,
    this.withExpireTime,
    this.itemId,
  });
}

class UpdateValueAfterSuccess extends ProfileProviderSkillsEvent {
  final int index;
  final NewSkillResponse skillResponse;
  UpdateValueAfterSuccess({this.index, this.skillResponse});
}

class DeleteSelectedSkill extends ProfileProviderSkillsEvent {
  final int index;
  final String itemId;
  final BuildContext context;
  DeleteSelectedSkill({this.index, this.itemId,@required this.context});
}
