part of 'discover_my_interest_bloc.dart';

 class DiscoverMyInterestState  {
  const DiscoverMyInterestState();

}



class GetMyInterestSubCategoriesSuccess extends DiscoverMyInterestState {
  final List<SubCategoryResponse> subCatergories;
  GetMyInterestSubCategoriesSuccess({this.subCatergories});
}

class LoadingState extends DiscoverMyInterestState {}

class RemoteValidationErrorState extends DiscoverMyInterestState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends DiscoverMyInterestState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends DiscoverMyInterestState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}
