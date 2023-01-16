part of 'home_group_members_bloc.dart';

@immutable
class HomeGroupMembersState extends Equatable {
  final List<String> personSearched;

  const HomeGroupMembersState({
    this.personSearched = const <String>[],
  });

  HomeGroupMembersState copyWith({
    List<String> personSearched,
  }) {
    return HomeGroupMembersState(
      personSearched: personSearched ?? this.personSearched,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [personSearched];
}
