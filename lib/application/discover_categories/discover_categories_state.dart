part of 'discover_categories_bloc.dart';

class DiscoverCategoriesState  {
  const DiscoverCategoriesState();

}

class LoadingState extends DiscoverCategoriesState {
}

class GetCategoriesSucessfulState extends DiscoverCategoriesState {
  GetCategoriesSucessfulState({@required this.categories});

  final List<CategoryResponse> categories;

}

class RemoteValidationErrorState extends DiscoverCategoriesState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends DiscoverCategoriesState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends DiscoverCategoriesState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}

class ErrorRefreshData  extends DiscoverCategoriesState {
  
}