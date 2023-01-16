part of 'discover_categories_bloc.dart';

abstract class DiscoverCategoriesEvent extends Equatable {
  const DiscoverCategoriesEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends DiscoverCategoriesEvent{
  final bool isRefreshData;
  GetCategoriesEvent({this.isRefreshData=false});
}
