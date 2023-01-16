import 'package:arachnoit/application/add_question/add_question_bloc.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../custom_widgets/discover_category_item.dart';

class QuestionCategories extends StatefulWidget {
  final TabController tabController;
  final AddQuestionBloc addQuestionBloc;
  QuestionCategories({Key key, this.tabController, @required this.addQuestionBloc})
      : super(key: key);

  @override
  _QuestionCategories createState() => _QuestionCategories();
}

class _QuestionCategories extends State<QuestionCategories> with AutomaticKeepAliveClientMixin {
  List<CategoryResponse> items = [];
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    widget.addQuestionBloc.add(AddQuestionGetMainCategoryEvent());
  }

  RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<AddQuestionBloc, AddQuestionState>(
      bloc: widget.addQuestionBloc,
      listener: (context, state) {
        if (state is AddQuestionGetMainCategoryState) {
          successRequestBefore = true;
          refreshController.refreshCompleted();
        } else if (state is RemoteClientErrorState ||
            state is RemoteServerErrorState ||
            state is RemoteValidationErrorState) {
          refreshController.refreshFailed();
        }
        if (state is AddQuestionGetMainCategoryState) {
          for (CategoryResponse item in state.categories) {
            if (item.subCategories.length > 0) items.add(item);
          }
        }
      },
      child: BlocBuilder<AddQuestionBloc, AddQuestionState>(
        builder: (context, state) {
          if (successRequestBefore) {
            return showInfo();
          }
          if (state is LoadingState) {
            return LoadingBloc();
          } else if (state is RemoteClientErrorState)
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.userError,
              function: () {
                widget.addQuestionBloc.add(AddQuestionGetMainCategoryEvent());
              },
            );
          else if (state is RemoteServerErrorState)
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.serverError,
              function: () {
                widget.addQuestionBloc.add(AddQuestionGetMainCategoryEvent());
              },
            );
          else if (state is RemoteValidationErrorState) {
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.validationError,
              function: () {
                widget.addQuestionBloc.add(AddQuestionGetMainCategoryEvent());
              },
            );
          } else {
            return showInfo();
          }
        },
      ),
    );
  }

  Widget showInfo() {
    return RefreshData(
      refreshController: refreshController,
      onRefresh: () {
        widget.addQuestionBloc.add(AddQuestionGetMainCategoryEvent());
      },
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, i) {
          int length = items[i]?.subCategories?.length ?? 0;
          return InkWell(
            onTap: () {},
            child: length > 0
                ? DiscoverCategoryItem(
                    showTrueCheck:items[i].id==widget.addQuestionBloc.categoriesId ,
                    category: items[i],
                    function: () {
                      widget.tabController.animateTo((widget.tabController.index + 1) % 3);
                      widget.addQuestionBloc.add(
                          SetCategorieId(categoriesId: items[i].id, categoryName: items[i].name));
                      widget.addQuestionBloc.add(AddQuestionGetSubCategoryEvent(items[i].id));
                    },
                  )
                : Container(width: 0, height: 0),
          );
        },
        itemCount: items.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
