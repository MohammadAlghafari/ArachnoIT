part of 'pending_list_patents_bloc.dart';

abstract class PenddingListPatentsEvent extends Equatable {
  const PenddingListPatentsEvent();

  @override
  List<Object> get props => [];
}

class GetAllPatentsEvent extends PenddingListPatentsEvent{
  final bool newRequest;
  GetAllPatentsEvent({this.newRequest=true});
}

class RejectPatentsEvent extends PenddingListPatentsEvent{
  final String patentsId;
  final int index;
  RejectPatentsEvent({this.patentsId,this.index});
}

class AcceptPatentsEvent extends PenddingListPatentsEvent{
  final String patentsId;
  final int index;
  AcceptPatentsEvent({this.patentsId,this.index});
}