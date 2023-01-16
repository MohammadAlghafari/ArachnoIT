part of 'discover_my_interests_add_interests_bloc.dart';


 class DiscoverMyInterestsAddInterestsState /*extends Equatable*/ {
  const DiscoverMyInterestsAddInterestsState();
  
  // @override
  // List<Object> get props => [];
}

class GetMyInterestAddInterestSuccess extends DiscoverMyInterestsAddInterestsState {
  final List<CategoryResponse> categoryList;
  GetMyInterestAddInterestSuccess({@required this.categoryList});
  // @override
  // List<Object> get props => [];
}

class LoadingState extends DiscoverMyInterestsAddInterestsState {}

class RemoteValidationErrorState extends DiscoverMyInterestsAddInterestsState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  // @override
  // List<Object> get props => [remoteValidationErrorMessage];
}

class RemoteServerErrorState extends DiscoverMyInterestsAddInterestsState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  // @override
  // List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorState extends DiscoverMyInterestsAddInterestsState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  // @override
  // List<Object> get props => [remoteClientErrorMessage];
}

class ChangeCategoryStateByClickItem extends DiscoverMyInterestsAddInterestsState {
   final CategoryResponse categoryResponse;
   final int index;
  ChangeCategoryStateByClickItem(
      {@required this.categoryResponse, @required this.index});
  //   @override
  // List<Object> get props => [categoryResponse, index];
}

class SuccessUpdateSubCategoryState extends DiscoverMyInterestsAddInterestsState{
  int index;
  CategoryResponse categoryResponse;
  SuccessUpdateSubCategoryState({this.index,this.categoryResponse});
}

class SuccessSendActionSubscrption extends DiscoverMyInterestsAddInterestsState{
  final String message;
  SuccessSendActionSubscrption({this.message});
}
class FailedSendActionSubscrption extends DiscoverMyInterestsAddInterestsState{
  final String message;
  FailedSendActionSubscrption({this.message});
}