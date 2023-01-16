part of 'pending_list_patents_bloc.dart';

enum PenddingListPatentsStatus {
  initial,
  loading,
  success,
  failure,
  rejectOrAcceptEventLoading,
  successAcceptGroup,
  successRejectGroup,
  failedRejectOrAccept,
}

class PenddingListPatentsState {
  PenddingListPatentsState(
      {this.hasReachedMax = false,
      this.posts = const <PatentsResponse>[],
      this.status = PenddingListPatentsStatus.initial,
      this.erroMessage = ""});
  final bool hasReachedMax;
  final PenddingListPatentsStatus status;
  final List<PatentsResponse> posts;
  final String erroMessage;
  PenddingListPatentsState copyWith({
    bool hasReachedMax,
    PenddingListPatentsStatus status,
    List<PatentsResponse> posts,
    String erroMessage,
  }) {
    return PenddingListPatentsState(
        posts: (posts) ?? this.posts,
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        status: (status) ?? this.status,
        erroMessage: (erroMessage) ?? this.erroMessage);
  }
}
