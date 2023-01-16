import 'package:arachnoit/application/add_question/add_question_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddQuestionSubCategories extends StatefulWidget {
  final AddQuestionBloc addQuestionBloc;
  bool isUpdateQuestion;
  final QaaResponse item;
  AddQuestionSubCategories(
      {@required this.addQuestionBloc, @required this.item, this.isUpdateQuestion = false});
  @override
  State<StatefulWidget> createState() {
    return _AddQuestionSubCategories();
  }
}

class _AddQuestionSubCategories extends State<AddQuestionSubCategories>
    with AutomaticKeepAliveClientMixin {
  bool successRequestBefore = false;
  RefreshController refreshController = RefreshController();
  Map<String, bool> value;
  @override
  void initState() {
    super.initState();
    value = Map<String, bool>();
    if (widget.isUpdateQuestion) {
      widget.addQuestionBloc.add(AddQuestionGetSubCategoryEvent(widget.addQuestionBloc.categoriesId));
      widget.isUpdateQuestion = false;
    }
  }

  List<SubCategoryResponse> items = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<AddQuestionBloc, AddQuestionState>(
      bloc: widget.addQuestionBloc,
      listener: (context, state) {
        if (state is RemoteClientErrorState ||
            state is RemoteServerErrorState ||
            state is RemoteValidationErrorState) {
          refreshController.refreshFailed();
        }
        if (state is AddQuestionGetSubCategoryState) {
          widget.isUpdateQuestion = false;
          refreshController.refreshCompleted();
          successRequestBefore = true;
          items = state.subCategories;
          value = Map<String, bool>();
          widget.addQuestionBloc.subCategoryItem = [];
          for (SubCategoryResponse item in state.subCategories) {
            value[item.id] = false;
          }
          int leng = widget?.item?.subCategories?.length ?? 0;
          if (widget.addQuestionBloc.categoriesId == widget.item.categoryId) {
            if (leng == 0) {
              widget.addQuestionBloc.subCategoryItem.add(SubCategoryResponse(
                  id: widget.item.subCategoryId, name: widget.item.subCategory));
              value[widget.item.subCategoryId] = true;
            } else {
              for (SubCategoryResponse item in widget.item.subCategories) {
                widget.addQuestionBloc.subCategoryItem.add(item);
                value[item.id] = true;
              }
            }
          }
        } else if (state is UpdateCheckListValueState) {
          value[state.subCategoryID] = !value[state.subCategoryID];
        } else if (state is ResetSubCategoryValue) {
          items = [];
        }
      },
      child: BlocBuilder<AddQuestionBloc, AddQuestionState>(
        builder: (context, state) {
          if (widget.addQuestionBloc.categoriesId.length == 0) {
            return Center(
              child: Text(AppLocalizations.of(context).you_should_select_category_first),
            );
          }
          if (items.length > 0) return showInfo();
          if (state is LoadingState) {
            return LoadingBloc();
          } else if (state is RemoteClientErrorState)
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.userError,
              function: () {
                widget.addQuestionBloc
                    .add(AddQuestionGetSubCategoryEvent(widget.addQuestionBloc.categoriesId));
              },
            );
          else if (state is RemoteServerErrorState)
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.serverError,
              function: () {
                widget.addQuestionBloc.add(AddQuestionGetSubCategoryEvent(widget.addQuestionBloc
                    .categoriesId)); // discoverCategoriesBloc.add(GetCategoriesEvent());
              },
            );
          else if (state is RemoteValidationErrorState) {
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.validationError,
              function: () {
                widget.addQuestionBloc.add(AddQuestionGetSubCategoryEvent(widget.addQuestionBloc
                    .categoriesId)); // discoverCategoriesBloc.add(GetCategoriesEvent());
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
        widget.addQuestionBloc.add(AddQuestionGetSubCategoryEvent(
            widget.addQuestionBloc.categoriesId,
            isRefreshData: true));
      },
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
            child: Divider(),
          );
        },
        padding: EdgeInsets.only(left: 8, right: 8, top: 12),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: QuestionSubCategoryItem(
              isSelectedItem: value[items[index].id],
              name: items[index].name,
              updateCheckFunction: () {
                widget.addQuestionBloc.add(UpdateCheckListValue(
                    isRemoveItem: value[items[index].id], subCategoryItem: items[index]));
              },
            ),
          );
        },
        physics: BouncingScrollPhysics(),
        itemCount: items.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class QuestionSubCategoryItem extends StatelessWidget {
  final bool isSelectedItem;
  final String name;
  final Function updateCheckFunction;
  QuestionSubCategoryItem({
    @required this.isSelectedItem,
    @required this.name,
    @required this.updateCheckFunction,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: updateCheckFunction,
      child: Container(
        height: 55,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Expanded (child: Text(
                 name,
                 style: mediumMontserrat(
                   color: Colors.black,
                   fontSize: 14,
                 ),
               )),
               Container (
                  child: Checkbox(
                    value: isSelectedItem,
                    onChanged: (value) {
                      updateCheckFunction();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
