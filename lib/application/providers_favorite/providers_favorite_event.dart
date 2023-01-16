part of 'providers_favorite_bloc.dart';

abstract class ProvidersFavoriteEvent  {
  const ProvidersFavoriteEvent();

}

class ProvidersFavoriteFetch extends ProvidersFavoriteEvent {
  final bool rebuildScreen;


  ProvidersFavoriteFetch({@required this.rebuildScreen});
}

class DeleteItem extends ProvidersFavoriteEvent {
  final int index;
  DeleteItem({this.index});
}

class AddItemToArray extends ProvidersFavoriteEvent {
  final ProviderItemResponse providerItemResponse;
  AddItemToArray({this.providerItemResponse});
}

class RemoveItemFromFavouriteMap extends ProvidersFavoriteEvent {
  final String id;
  final int index;
  RemoveItemFromFavouriteMap({@required this.id,@required this.index});
}
