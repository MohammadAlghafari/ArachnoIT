import 'dart:ui';

import 'package:arachnoit/application/add_question/add_question_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:arachnoit/infrastructure/question_details/response/question_details_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/advance_search_tags_item.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/file_item.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:arachnoit/presentation/custom_widgets/search_tag_dialog.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddQuestionScreen extends StatefulWidget {
  static const routeName = 'addQuestionPage';
  const AddQuestionScreen(
      {Key key,
      this.questionId,
      this.groupId,
      this.addQuestionBloc,
      @required this.item,
      @required this.isUpdateQuestion})
      : super(key: key);
  final bool isUpdateQuestion;
  final QaaResponse item;
  final String questionId;
  final String groupId;
  final AddQuestionBloc addQuestionBloc;
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionScreen> with AutomaticKeepAliveClientMixin {
  AddQuestionBloc _addQuestionBloc;
  String categoryId = "";
  List<String> tags;
  TextEditingController _mainCategoryController;
  TextEditingController _subCategoryController;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  List<SearchModel> searchedList;
  List<SearchModel> selectedTagsItem;
  Map<String, int> wrapTagItemsIndex = Map<String, int>();
  List<FileResponse> files;
  Map<String, int> wrapFilesItemsIndex = Map<String, int>();
  bool askAnonymous = false;
  bool viewToHealthcareProvidersOnly = false;
  List<String> removedFiles;

  @override
  void initState() {
    _addQuestionBloc = serviceLocator<AddQuestionBloc>();
    _mainCategoryController = TextEditingController();
    _subCategoryController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    searchedList = <SearchModel>[];
    selectedTagsItem = <SearchModel>[];
    files = <FileResponse>[];
    // if (widget.questionId != null) {
    //   _addQuestionBloc.add(AddQuestionGetQuestionInfoEvent(
    //     questionId: widget.questionId,
    //   ));
    // }
    if (widget.isUpdateQuestion) {
      _mainCategoryController.text = widget.item.category;
      _titleController.text = widget.item.questionTitle;
      _descriptionController.text = widget.item.questionBody;
      int length = widget?.item?.files?.length ?? 0;
      if (length != 0) files = widget.item.files;
      length = widget?.item?.tags?.length ?? 0;
      if (length != 0) {
        for (TagResponse item in widget.item.tags)
          selectedTagsItem.add(SearchModel(id: item.id, name: item.name));
      }
      length = widget?.item?.subCategories?.length ?? 0;
      if (length == 0) {}
      askAnonymous = widget.item.askAnonymously;
      viewToHealthcareProvidersOnly = widget.item.viewToHealthcareProvidersOnly;
    }
    removedFiles = <String>[];
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocProvider<AddQuestionBloc>(
        create: (context) => _addQuestionBloc,
        child: BlocListener<AddQuestionBloc, AddQuestionState>(
          listener: (context, state) {
            if (state is LoadingState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            } else if (state is AddQuestionGetMainCategoryState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                _handelGetMainCategorySuccess(state);
              });
            } else if (state is AddQuestionGetTagsState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                _handleGetTagsSuccess(state);
              });
            } else if (state is AddQuestionChanagSelectedTagListState) {
              _handleChanagSelectedTagListState(state);
            } else if (state is AddQuestionUpdatedFileListState) {
              _handleUpdatedFilesState(state);
            } else if (state is RemoteValidationErrorState)
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) => GlobalPurposeFunctions.showToast(
                        state.remoteValidationErrorMessage,
                        context,
                      ));
            else if (state is RemoteServerErrorState)
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) => GlobalPurposeFunctions.showToast(
                        state.remoteServerErrorMessage,
                        context,
                      ));
            else if (state is RemoteClientErrorState)
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) => GlobalPurposeFunctions.showToast(
                        AppLocalizations.of(context).data_error,
                        context,
                      ));
            else if (state is AddQuestionAskSuccessState) {
              if (widget.isUpdateQuestion) {
                widget.item.askAnonymously = state.response.askAnonymously;
                widget.item.category = widget.addQuestionBloc.categoryName;
                widget.item.categoryId = widget.addQuestionBloc.categoriesId;
                widget.item.subCategory = _subCategoryController.text;
                widget.item.subCategories = widget?.addQuestionBloc?.subCategoryItem ?? [];
                widget.item.questionTitle = _titleController.text;
                widget.item.questionBody = _descriptionController.text;
                List<TagResponse> items = [];
                for (SearchModel item in searchedList)
                  items.add(TagResponse(id: item.id, name: item.name));
                widget.item.tags = items;
                widget.item.files = files;

                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) => Navigator.of(context).pop(widget.item));
              } else {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) => Navigator.of(context).pop(true));
              }
            }
          },
          child: BlocBuilder<AddQuestionBloc, AddQuestionState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 40, left: 40, bottom: 20),
                  child: Column(
                    children: [
                      BlocBuilder<AddQuestionBloc, AddQuestionState>(
                        bloc: widget.addQuestionBloc,
                        builder: (context, state) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).categories + " : ",
                                      style: regularMontserrat(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text((widget.addQuestionBloc.categoryName.length != 0)
                                        ? widget.addQuestionBloc.categoryName
                                        : AppLocalizations.of(context)
                                            .did_not_choose_any_category_yet),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).subCategory + " : ",
                                      style: regularMontserrat(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    showSubCategoriesItem()
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _titleController,
                              style: regularMontserrat(
                                fontSize: 11.0,
                                color: Colors.black,
                              ),
                              cursorColor: Theme.of(context).accentColor,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  hintText: AppLocalizations.of(context).your_question_title,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "*",
                            style: regularMontserrat(
                                color: Theme.of(context).accentColor, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _descriptionController,
                              style: TextStyle(fontSize: 11.0, height: 2.0, color: Colors.black),
                              cursorColor: Theme.of(context).accentColor,
                              keyboardType: TextInputType.text,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  hintText: AppLocalizations.of(context).your_question_details,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "*",
                            style: regularMontserrat(
                                color: Theme.of(context).accentColor, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                _addQuestionBloc.add(
                                  AddQuestionGetTagsEvent(),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.circular(20)),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 5,
                                    child: Text(
                                      AppLocalizations.of(context).add_tags,
                                      textAlign: TextAlign.center,
                                      style: mediumMontserrat(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Icon(
                                      Icons.tag,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: FlatButton(
                              onPressed: () async {
                                FilePickerResult result =
                                    await FilePicker.platform.pickFiles(allowMultiple: true);

                                if (result != null) {
                                  List<PlatformFile> platformFiles = result.files;
                                  platformFiles.forEach((element) {
                                    FileResponse fileResponse = FileResponse();
                                    fileResponse.url = element.path;
                                    fileResponse.name = element.name;
                                    fileResponse.extension = element.extension;
                                    files.add(fileResponse);
                                  });

                                  _addQuestionBloc.add(AddQuestionUpdateFilesListEvent(
                                    files: files,
                                  ));
                                } else {
                                  // User canceled the picker
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.circular(20)),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      AppLocalizations.of(context).upload_attachment,
                                      textAlign: TextAlign.center,
                                      style: mediumMontserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Icon(
                                      Icons.attachment,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      showTags(),
                      showFiles(),
                      if (GlobalPurposeFunctions.getUserObject().userType == 0 ||
                          GlobalPurposeFunctions.getUserObject().userType == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: state is AddQuestionViewToHealthcareOnlyState
                                  ? state.viewToHealthcareOnly
                                  : viewToHealthcareProvidersOnly,
                              onChanged: (value) {
                                viewToHealthcareProvidersOnly = value;
                                _addQuestionBloc.add(
                                  AddQuestionViewToHealthcareProvidersOnlyEvent(
                                    viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
                                  ),
                                );
                              },
                            ),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).this_question_is_seen_only_health_care,
                              textAlign: TextAlign.start,
                              style: lightMontserrat(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ))
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: state is AddQuestionAskAnonymousState
                                ? state.askAnonymous
                                : askAnonymous,
                            onChanged: (value) {
                              askAnonymous = value;
                              _addQuestionBloc.add(
                                AddQuestionAskAnonymousEvent(
                                  askAnonymous: askAnonymous,
                                ),
                              );
                            },
                          ),
                          Expanded(
                              child: Text(
                            AppLocalizations.of(context).ask_anonymously,
                            textAlign: TextAlign.start,
                            style: lightMontserrat(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                          onPressed: () {
                            if (widget.addQuestionBloc.categoriesId.isEmpty) {
                              GlobalPurposeFunctions.showToast(
                                AppLocalizations.of(context).category_cannot_be_empty,
                                context,
                              );
                            } else if (widget.addQuestionBloc.subCategoryItem.length == 0) {
                              GlobalPurposeFunctions.showToast(
                                AppLocalizations.of(context).subCategory_cannot_be_empty,
                                context,
                              );
                            } else if (_titleController.text.length <= 10) {
                              GlobalPurposeFunctions.showToast(
                                AppLocalizations.of(context)
                                    .question_title_should_be_more_than_10_characters,
                                context,
                              );
                            } else if (_descriptionController.text.length <= 10) {
                              GlobalPurposeFunctions.showToast(
                                AppLocalizations.of(context)
                                    .question_Details_should_be_more_than_10_characters,
                                context,
                              );
                            } else {
                              List<String> tags = <String>[];
                              for (SearchModel item in selectedTagsItem) {
                                tags.add(item.id);
                              }
                              List<String> subCategoryIds = [];
                              for (SubCategoryResponse item in widget
                                  .addQuestionBloc.subCategoryItem) subCategoryIds.add(item.id);
                              _addQuestionBloc.add(
                                AddQuestionAskButtonClicked(
                                  id: widget.questionId,
                                  subCategoryIds: subCategoryIds,
                                  groupId: widget.groupId != null ? widget.groupId : null,
                                  title: _titleController.text,
                                  body: _descriptionController.text,
                                  viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
                                  askAnonymously: askAnonymous,
                                  questionTags: tags,
                                  files: files
                                      .where(
                                        (element) => element.id == null,
                                      )
                                      .toList(),
                                  removedFiles: removedFiles,
                                ),
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(25)),
                          ),
                          color: Theme.of(context).accentColor,
                          child: Text(
                            AppLocalizations.of(context).ask,
                            style: mediumMontserrat(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget showSubCategoriesItem() {
    if (widget.addQuestionBloc.subCategoryItem.length == 0) {
      return Text(AppLocalizations.of(context).did_not_choose_any_sub_category_yet);
    }
    return Wrap(
      children: widget.addQuestionBloc.subCategoryItem
          .map((item) => Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 5),
                    Center(
                        child: InkWell(
                      onTap: () {
                        widget.addQuestionBloc.add(DeleteItemFromSubCategory(subCategory: item.id));
                        widget.addQuestionBloc
                            .add(UpdateCheckListValue(isRemoveItem: true, subCategoryItem: item));
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    )),
                    SizedBox(width: 5),
                    AutoDirection(
                        text: item.name,
                        child: Flexible(
                            child: Text(
                          item.name,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ))
          .toList()
          .cast<Widget>(),
    );
  }

  Widget showTags() {
    return Wrap(
      children: selectedTagsItem.map((e) {
        return Padding(
          padding: EdgeInsets.only(left: 4, right: 4),
          child: InkWell(
              onTap: () {
                _addQuestionBloc.add(AddQuestionRemoveSelectedTagItem(
                    tagsItem: selectedTagsItem, index: wrapTagItemsIndex[e.id]));
              },
              child: AdvanceSearchTagsItem(selectedTagsItem: e)),
        );
      }).toList(),
    );
  }

  Widget showFiles() {
    return Wrap(
      children: files.map((e) {
        return Padding(
          padding: EdgeInsets.only(left: 4, right: 4),
          child: InkWell(
            onTap: () {
              if (files[wrapFilesItemsIndex[e.name]].id != null) {
                removedFiles.add(files[wrapFilesItemsIndex[e.name]].id);
              }
              _addQuestionBloc.add(AddQuestionRemoveFileItem(
                files: files,
                index: wrapFilesItemsIndex[e.name],
              ));
            },
            child: FileItem(
              fileExtension: e.extension,
              fileName: e.name,
              filePath: e.url,
              fileId: e.id,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handelGetMainCategorySuccess(AddQuestionGetMainCategoryState state) {
    searchedList.clear();
    for (var i = 0; i < state.categories.length; i++) {
      searchedList.add(SearchModel(id: state.categories[i].id, name: state.categories[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: searchedList,
            )).then((val) {
      if (val != null) {
        categoryId = state.categories[val].id;
        _mainCategoryController.text = state.categories[val].name;
      }
    });
  }

  void _handleGetTagsSuccess(AddQuestionGetTagsState state) {
    searchedList.clear();
    for (var i = 0; i < state.tagItems.length; i++) {
      searchedList.add(SearchModel(id: state.tagItems[i].id, name: state.tagItems[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchTagDialog(
              data: searchedList,
              wrapIdTagsItem: wrapTagItemsIndex,
            )).then((value) {
      if (value != null) {
        _addQuestionBloc.add(AddQuestionChanagSelectedTagListEvent(tagsItem: value));
      }
    });
  }

  void _handleChanagSelectedTagListState(AddQuestionChanagSelectedTagListState state) {
    wrapTagItemsIndex.clear();
    selectedTagsItem = state.tagsItem;
    for (int i = 0; i < selectedTagsItem.length; i++) {
      wrapTagItemsIndex[selectedTagsItem[i].id] = i;
    }
  }

  void _handleUpdatedFilesState(AddQuestionUpdatedFileListState state) {
    wrapFilesItemsIndex.clear();
    files = state.files;
    for (int i = 0; i < files.length; i++) {
      wrapFilesItemsIndex[files[i].name] = i;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
