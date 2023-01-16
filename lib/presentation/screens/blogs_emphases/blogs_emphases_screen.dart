import 'package:arachnoit/application/blogs_emphases_vote/blogs_emphases_vote_bloc.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/blogs_vote_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsEmphasesVoteScreen extends StatefulWidget {
  final String itemId;
  BlogsEmphasesVoteScreen({@required this.itemId});
  @override
  State<StatefulWidget> createState() {
    return _BlogsEmphasesVoteScreen();
  }
}

class _BlogsEmphasesVoteScreen extends State<BlogsEmphasesVoteScreen>
    with AutomaticKeepAliveClientMixin {
  BlogsEmphasesVoteBloc searchGroupBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    searchGroupBloc = serviceLocator<BlogsEmphasesVoteBloc>();
    searchGroupBloc.add(GetUsefulBlogsVote(
        itemId: widget.itemId, newRequest: true, itemType: 2, voteType: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider<BlogsEmphasesVoteBloc>(
      create: (context) => searchGroupBloc,
      child: BlocListener<BlogsEmphasesVoteBloc, BlogsEmphasesVoteState>(
        listener: (context, state) {},
        child: BlocBuilder<BlogsEmphasesVoteBloc, BlogsEmphasesVoteState>(
          builder: (context, state) {
            switch (state.status) {
              case BlogsEmphasesVoteStatus.loading:
                return LoadingBloc();
              case BlogsEmphasesVoteStatus.failure:
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    searchGroupBloc.add(GetUsefulBlogsVote(
                        itemId: widget.itemId,
                        newRequest: true,
                        itemType: 2,
                        voteType: 1));
                  },
                );
              case BlogsEmphasesVoteStatus.success:
                if (state.votes.isEmpty) {
                  return BlocError(
                    context: context,
                    blocErrorState: BlocErrorState.noPosts,
                    function: () {
                      searchGroupBloc.add(GetUsefulBlogsVote(
                          itemId: widget.itemId,
                          newRequest: true,
                          itemType: 2,
                          voteType: 1));
                    },
                  );
                }
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.votes.length
                        ? BottomLoader()
                        : BlogsVoteListItem(
                            item: state.votes[index],
                          );
                  },
                  itemCount: state.hasReachedMax
                      ? state.votes.length
                      : state.votes.length + 1,
                  controller: _scrollController,
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {}
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  bool get wantKeepAlive => true;
}
