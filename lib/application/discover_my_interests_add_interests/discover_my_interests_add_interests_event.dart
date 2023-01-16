part of 'discover_my_interests_add_interests_bloc.dart';

abstract class DiscoverMyInterestsAddInterestsEvent extends Equatable {
  const DiscoverMyInterestsAddInterestsEvent();

  @override
  List<Object> get props => [];
}

class FetchMyInterestAddInterest extends DiscoverMyInterestsAddInterestsEvent {
  final bool isRefreshData;
  FetchMyInterestAddInterest({this.isRefreshData=false  });
}

class ChangeMyInterestAddInterestEvent
    extends DiscoverMyInterestsAddInterestsEvent {
  final List<CategoryResponse> categoryResponse;
  ChangeMyInterestAddInterestEvent({@required this.categoryResponse});
  @override
  List<Object> get props => [categoryResponse];
}

class ChangeMyInterestClickEvent extends DiscoverMyInterestsAddInterestsEvent {
  final int index;
  final CategoryResponse categoryResponse;
  ChangeMyInterestClickEvent(
      {@required this.categoryResponse, @required this.index});
  @override
  List<Object> get props => [categoryResponse, index];
}

class UpdateSubCategoryStateFromNotificationIcon extends DiscoverMyInterestsAddInterestsEvent{
  final int index;
  final CategoryResponse items;
  final bool subScripeAll;
  UpdateSubCategoryStateFromNotificationIcon({this.index,this.items,this.subScripeAll});
}

class UpdateSubCategoryStateFromBottomSheet extends DiscoverMyInterestsAddInterestsEvent{
  final int index;
  final CategoryResponse items;
  UpdateSubCategoryStateFromBottomSheet({this.index,this.items});
}

class SendActionSubscrption extends DiscoverMyInterestsAddInterestsEvent{
  final List<CategoryResponse> categoryResponse;
  SendActionSubscrption({this.categoryResponse});
}

