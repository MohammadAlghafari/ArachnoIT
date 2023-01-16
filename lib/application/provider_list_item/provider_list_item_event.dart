part of 'provider_list_item_bloc.dart';

abstract class ProviderListItemEvent extends Equatable {
  const ProviderListItemEvent();

  @override
  List<Object> get props => [];
}

class SetFavoriteProviderEvent extends ProviderListItemEvent {
  const SetFavoriteProviderEvent({this.favoritePersonId,this.favoriteStatus,this.index,this.context});
  
  final String favoritePersonId;
  final bool favoriteStatus;
  final int index;
  final BuildContext context;
  @override
  List<Object> get props => [favoritePersonId,favoriteStatus,index,context];
}

class CopyToClipboardEvent extends ProviderListItemEvent {
  const CopyToClipboardEvent({this.text,});
  
  final String text;
  @override
  List<Object> get props => [text,];
}



class GetProfileBridEvent extends ProviderListItemEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}
