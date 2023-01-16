part of 'blog_list_item_bloc.dart';

@immutable
class BlogListItemState {
  const BlogListItemState();
}

class VoteEmphasisState extends BlogListItemState {
  const VoteEmphasisState({this.vote});

  final bool vote;
}

class VoteUsefulState extends BlogListItemState {
  const VoteUsefulState({this.vote});

  final bool vote;
}

class RemoteValidationErrorState extends BlogListItemState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends BlogListItemState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends BlogListItemState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}

class GetBriedProfileSuceess extends BlogListItemState {
  final BriefProfileResponse profileInfo;

  GetBriedProfileSuceess({this.profileInfo});
}

class UpdateEmphasesAndUsefulManulaState extends BlogListItemState {
  final int usefulCount;
  final int emphasesCount;
  UpdateEmphasesAndUsefulManulaState({this.usefulCount, this.emphasesCount});
}

class SendReportSuccess extends BlogListItemState {
  final String message;
  SendReportSuccess({this.message});
}

class FailedSendReport extends BlogListItemState {
  final String message;
  FailedSendReport({this.message});
}

class SuccessUpdateObject extends BlogListItemState {
  final GetBlogsResponse newBlogItem;
  SuccessUpdateObject({this.newBlogItem});
}
