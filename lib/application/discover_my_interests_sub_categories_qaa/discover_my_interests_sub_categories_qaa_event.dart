part of 'discover_my_interests_sub_categories_qaa_bloc.dart';

abstract class DiscoverMyInterestsSubCategoriesQaaEvent extends Equatable {
  const DiscoverMyInterestsSubCategoriesQaaEvent();

  @override
  List<Object> get props => [];
}

class DiscoverMyInterestsSubCategoriesQaaFetch
    extends DiscoverMyInterestsSubCategoriesQaaEvent {
  final String subCategoryId;
  DiscoverMyInterestsSubCategoriesQaaFetch({this.subCategoryId});
  @override
  List<Object> get props => [subCategoryId];
}

class ReloadDiscoverMyInterestsSubCategoriesQaaFetch
    extends DiscoverMyInterestsSubCategoriesQaaEvent {
  final String subCategoryId;
  ReloadDiscoverMyInterestsSubCategoriesQaaFetch({this.subCategoryId});
  @override
  List<Object> get props => [subCategoryId];
}


class DeleteQuestion extends DiscoverMyInterestsSubCategoriesQaaEvent {
  final String questionId;
  final int index;
  final BuildContext context;
  DeleteQuestion({@required this.questionId, @required this.index, @required this.context});
}