part of 'provider_list_item_bloc.dart';

class ProviderListItemState {
  const ProviderListItemState();
}

class SetFavoriteProviderState extends ProviderListItemState {
  const SetFavoriteProviderState({this.status});

  final bool status;
}

class RemoteValidationErrorState extends ProviderListItemState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends ProviderListItemState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ProviderListItemState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}

class GetBriedProfileSuceess extends ProviderListItemState {
  final BriefProfileResponse profileInfo;

  GetBriedProfileSuceess({this.profileInfo});
}
