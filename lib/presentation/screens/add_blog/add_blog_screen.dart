import 'dart:ui';

import 'package:arachnoit/application/add_blog/add_blog_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/blog_details/response/blog_details_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:arachnoit/presentation/custom_widgets/advance_search_tags_item.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/file_item.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:arachnoit/presentation/custom_widgets/search_tag_dialog.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:image_picker/image_picker.dart';

import '../../../injections.dart';

class AddBlogPage extends StatefulWidget {
  static const routeName = 'addBlogPage';
  const AddBlogPage({Key key, this.blogId, this.getBlogsResponse, this.groupId}) : super(key: key);
  final GetBlogsResponse getBlogsResponse;
  final String blogId;
  final String groupId;
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  AddBlogBloc _addBlogBloc;
  String categoryId = "";
  String subCategoryId = "";
  List<String> tags;
  TextEditingController _mainCategoryController;
  TextEditingController _subCategoryController;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  List<SearchModel> searchedList = [];
  List<SearchModel> selectedTagsItem = [];
  Map<String, int> wrapTagItemsIndex = Map<String, int>();
  List<FileResponse> files;
  Map<String, int> wrapFilesItemsIndex = Map<String, int>();
  bool publishByCreator = false;
  bool viewToHealthcareProvidersOnly = false;
  int blogType = 0;
  int externalFileType = 0;
  int imageFileType = 0;
  String externalFileUrl = "";
  TextEditingController _externalUrlController;
  dynamic _previewData;
  List<String> removedFiles;
  String externalFileId = "";

  @override
  void initState() {
    _addBlogBloc = serviceLocator<AddBlogBloc>();
    _mainCategoryController = TextEditingController();
    _subCategoryController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    searchedList = <SearchModel>[];
    selectedTagsItem = <SearchModel>[];
    files = <FileResponse>[];
    _externalUrlController = TextEditingController();
    removedFiles = <String>[];
    if (widget.blogId != null) {
      _addBlogBloc.add(
        AddBlogGetBlogInfoEvent(blogId: widget.blogId),
      );
    }

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
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: true,
          title: Text(
            AppLocalizations.of(context).add_blog,
            style: semiBoldMontserrat(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocProvider(
          create: (context) => _addBlogBloc,
          child: BlocListener<AddBlogBloc, AddBlogState>(
            listener: (context, state) {
              if (state is LoadingState) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              } else if (state is AddBlogGetMainCategoryState) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                  _handelGetMainCategorySuccess(state);
                });
              } else if (state is AddBlogGetSubCategoryState) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                  _handelGetSubCategory(state);
                });
              } else if (state is AddBlogGetTagsState) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                  _handleGetTagsSuccess(state);
                });
              } else if (state is AddBlogChanagSelectedTagListState) {
                _handleChanagSelectedTagListState(state);
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
              else if (state is AddBlogPostSuccessState) {
                if (widget.blogId != null) {
                  widget.getBlogsResponse.categoryId = categoryId;
                  widget.getBlogsResponse.category = _mainCategoryController.text;
                  widget.getBlogsResponse.subCategory = _subCategoryController.text;
                  widget.getBlogsResponse.subCategoryId = state.response.subCategoryId;
                  widget.getBlogsResponse.viewToHealthcareProvidersOnly =
                      state.response.viewToHealthcareProvidersOnly;
                  List<TagResponse> tags = [];
                  selectedTagsItem.forEach((element) {
                    tags.add(TagResponse(id: element.id, name: element.name));
                  });
                  widget.getBlogsResponse.htmlBody = state.response.body;
                  widget.getBlogsResponse.title = state.response.title;
                  widget.getBlogsResponse.tags = tags;
                  widget.getBlogsResponse.blogType = state.response.blogType;
                  widget.getBlogsResponse.files = state.response.files;
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                      .then((value) => Navigator.of(context).pop(widget.getBlogsResponse));
                } else {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                      .then((value) => Navigator.of(context).pop(true));
                }
              } else if (state is AddBlogUpdatedFileListState) {
                _handleUpdatedFilesState(state);
              } else if (state is AddBlogShowLinkPreviewState) {
                if (!state.showPreview) {
                  blogType = 0;
                  externalFileType = 0;
                  externalFileUrl = "";
                  imageFileType = 0;
                  if (externalFileId.isNotEmpty) {
                    removedFiles.add(externalFileId);
                  }
                }
              } else if (state is AddBlogGetBlogInfoState) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                  _handleBlogInfoResponse(state.response);
                });
              }
            },
            child: BlocBuilder<AddBlogBloc, AddBlogState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 40, left: 40, bottom: 20),
                    child: Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     AutoDirection(
                        //       text: "hello",
                        //       child: Text(
                        //         "Target:",
                        //         style: TextStyle(
                        //             color: PRIMARYCOLOR,
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w600),
                        //       ),
                        //     ),
                        //     Radio(
                        //       value: 1,
                        //       groupValue: 0,
                        //       onChanged: (value) {},
                        //       activeColor: ACCENTCOLOR,
                        //     ),
                        //     Text(
                        //       "public",
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w300,
                        //       ),
                        //     ),
                        //     Radio(
                        //       value: 2,
                        //       groupValue: 2,
                        //       onChanged: (value) {},
                        //       activeColor: ACCENTCOLOR,
                        //     ),
                        //     Text(
                        //       "Group",
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w300,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // DropdownButton(
                        //   onTap: () {
                        //           Navigator.of(context).pop();
                        //           showDialog(
                        //               context: context,
                        //               builder: (context) => SearchDialog());
                        //         },
                        //   items: ["",]
                        //             .map<DropdownMenuItem<String>>((String value) {
                        //           return DropdownMenuItem<String>(
                        //             value: value,
                        //             child: Text(value),
                        //           );
                        //         }).toList(),

                        //   underline: Container(
                        //     height: 1.0,
                        //     decoration: const BoxDecoration(
                        //         border: Border(
                        //             bottom: BorderSide(color: PRIMARYCOLOR, width: 1.0))),
                        //   ),
                        //   icon: Icon(
                        //     Icons.arrow_drop_down,
                        //     color: PRIMARYCOLOR,
                        //   ),
                        //   onChanged: (selected) {},
                        //   isExpanded: true,
                        //   hint: Text(
                        //     "Group",
                        //     style: TextStyle(color: PRIMARYCOLOR, fontSize: 18),
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     Checkbox(value: true, onChanged: (value) {}),
                        //     Expanded(
                        //         child: Text(
                        //       "Publish this blog by creator name",
                        //       textAlign: TextAlign.start,
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w300,
                        //       ),
                        //     ))
                        //   ],
                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: DropDownTextField(
                                controller: _mainCategoryController,
                                hintText: AppLocalizations.of(context).category,
                                handleTap: () {
                                  _addBlogBloc.add(AddBlogGetMainCategoryEvent());
                                },
                                errorText: null,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropDownTextField(
                                controller: _subCategoryController,
                                hintText: AppLocalizations.of(context).subCategory,
                                handleTap: () {
                                  if (categoryId == null || categoryId.length == 0)
                                    GlobalPurposeFunctions.showToast(
                                      AppLocalizations.of(context).please_select_category,
                                      context,
                                    );
                                  else {
                                    _addBlogBloc.add(AddBlogGetSubCategoryEvent(categoryId));
                                  }
                                },
                                errorText: null,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _titleController,
                                style: regularMontserrat(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                                cursorColor: Theme.of(context).accentColor,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    hintText: AppLocalizations.of(context).your_blog_title,
                                    hintStyle: lightMontserrat(
                                      color: Colors.black87,
                                      fontSize: 12.0,
                                    ),
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
                              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16),
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
                                style: regularMontserrat(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                                cursorColor: Theme.of(context).accentColor,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    hintText: AppLocalizations.of(context).your_blog_details,
                                    filled: true,
                                    hintStyle: lightMontserrat(
                                      color: Colors.black87,
                                      fontSize: 12.0,
                                    ),
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
                              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: () {
                              _addBlogBloc.add(
                                AddBlogGetTagsEvent(),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).add_tags,
                                  style: regularMontserrat(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.tag,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.circular(20)),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        showTags(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: FlatButton(
                                onPressed: (blogType == 0 || blogType == 4)
                                    ? () async {
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: false,
                                          type: FileType.custom,
                                          allowedExtensions: ["pdf", "doc", "docx"],
                                        );
                                        if (result != null) {
                                          files.clear();
                                          wrapFilesItemsIndex.clear();
                                          List<PlatformFile> platformFiles = result.files;
                                          platformFiles.forEach((element) {
                                            FileResponse fileResponse = FileResponse();
                                            fileResponse.url = element.path;
                                            fileResponse.name = element.name;
                                            fileResponse.extension = element.extension;
                                            files.add(fileResponse);
                                          });
                                          blogType = 4;
                                          externalFileType = 0;
                                          imageFileType = 0;
                                          _addBlogBloc.add(AddBlogUpdateFilesListEvent(
                                            files: files,
                                          ));
                                        }
                                      }
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(20)),
                                ),
                                color: blogType == 4
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                disabledColor: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 2,
                                      child: Text(
                                        AppLocalizations.of(context).docs,
                                        textAlign: TextAlign.center,
                                        style: regularMontserrat(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.my_library_books,
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
                                onPressed: (blogType == 0 || blogType == 3)
                                    ? () async {
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: false,
                                          type: FileType.custom,
                                          allowedExtensions: ["mp3"],
                                        );
                                        if (result != null) {
                                          files.clear();
                                          wrapFilesItemsIndex.clear();
                                          List<PlatformFile> platformFiles = result.files;
                                          platformFiles.forEach((element) {
                                            FileResponse fileResponse = FileResponse();
                                            fileResponse.url = element.path;
                                            fileResponse.name = element.name;
                                            fileResponse.extension = element.extension;
                                            files.add(fileResponse);
                                          });
                                          blogType = 3;
                                          externalFileType = 0;
                                          imageFileType = 0;
                                          _addBlogBloc.add(AddBlogUpdateFilesListEvent(
                                            files: files,
                                          ));
                                        }
                                      }
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(20)),
                                ),
                                color: blogType == 3
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                disabledColor: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        AppLocalizations.of(context).audio,
                                        textAlign: TextAlign.center,
                                        style: regularMontserrat(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.audiotrack,
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
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: FlatButton(
                                onPressed: ((blogType == 0 && externalFileType == 0) ||
                                        (blogType == 2 && externalFileType == 1))
                                    ? () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Container(
                                                height: 125.0,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsetsDirectional.only(
                                                        bottom: 10.0,
                                                        start: 25.0,
                                                        end: 25.0,
                                                      ),
                                                      child: TextFormField(
                                                        controller: _externalUrlController,
                                                        style: regularMontserrat(
                                                          color: Theme.of(context).primaryColor,
                                                          fontSize: 18.0,
                                                        ),
                                                        cursorColor: Colors.black,
                                                        decoration: new InputDecoration(
                                                            contentPadding: EdgeInsets.only(
                                                                left: 15,
                                                                bottom: 11,
                                                                top: 11,
                                                                right: 15),
                                                            hintStyle: regularMontserrat(
                                                                color: Colors.black54,
                                                                fontSize: 16),
                                                            hintText: "https://youtubelink.com"),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceAround,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            if (_externalUrlController
                                                                .text.isEmpty) {
                                                              Navigator.of(context).pop();
                                                            } else {
                                                              blogType = 2;
                                                              externalFileType = 1;
                                                              imageFileType = 0;
                                                              externalFileUrl =
                                                                  _externalUrlController.text;
                                                              _addBlogBloc.add(
                                                                AddBlogShowLinkPreviewEvent(true),
                                                              );
                                                              Navigator.of(context).pop();
                                                            }
                                                          },
                                                          child: Text(
                                                            AppLocalizations.of(context).ok,
                                                            style: regularMontserrat(
                                                              color: Theme.of(context).accentColor,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text(
                                                            AppLocalizations.of(context).cancel,
                                                            style: regularMontserrat(
                                                              color: Theme.of(context).accentColor,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        // FilePickerResult result =
                                        //     await FilePicker.platform.pickFiles(
                                        //   allowMultiple: false,
                                        //   type: FileType.custom,
                                        //   allowedExtensions: ["mp4"],
                                        // );
                                        // if (result != null) {
                                        //   files.clear();
                                        //   wrapFilesItemsIndex.clear();
                                        //   List<PlatformFile> platformFiles =
                                        //       result.files;
                                        //   platformFiles.forEach((element) {
                                        //     FileResponse fileResponse =
                                        //         FileResponse();
                                        //     fileResponse.url = element.path;
                                        //     fileResponse.name = element.name;
                                        //     fileResponse.extension =
                                        //         element.extension;
                                        //     files.add(fileResponse);
                                        //   });
                                        //   blogType = 2;
                                        //   externalFileType = 1;
                                        //   imageFileType = 0;
                                        //   _addBlogBloc
                                        //       .add(AddBlogUpdateFilesListEvent(
                                        //     files: files,
                                        //   ));
                                        // }
                                      }
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(20)),
                                ),
                                color: (blogType == 2 && externalFileType == 1)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                disabledColor: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        AppLocalizations.of(context).youtube_link,
                                        textAlign: TextAlign.center,
                                        style: regularMontserrat(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.video_collection,
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
                            // Expanded(
                            //   child: FlatButton(
                            //     onPressed: ((blogType == 0 &&
                            //                 externalFileType == 0) ||
                            //             (blogType == 2 &&
                            //                 externalFileType == 0))
                            //         ? () async {
                            //             FilePickerResult result =
                            //                 await FilePicker.platform.pickFiles(
                            //               allowMultiple: false,
                            //               type: FileType.custom,
                            //               allowedExtensions: ["mp4"],
                            //             );
                            //             if (result != null) {
                            //               files.clear();
                            //               wrapFilesItemsIndex.clear();
                            //               List<PlatformFile> platformFiles =
                            //                   result.files;
                            //               platformFiles.forEach((element) {
                            //                 FileResponse fileResponse =
                            //                     FileResponse();
                            //                 fileResponse.url = element.path;
                            //                 fileResponse.name = element.name;
                            //                 fileResponse.extension =
                            //                     element.extension;
                            //                 files.add(fileResponse);
                            //               });
                            //               blogType = 2;
                            //               externalFileType = 0;
                            //               imageFileType = 0;
                            //               _addBlogBloc
                            //                   .add(AddBlogUpdateFilesListEvent(
                            //                 files: files,
                            //               ));
                            //             }
                            //           }
                            //         : null,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.only(
                            //           topLeft: Radius.circular(20),
                            //           topRight: Radius.circular(20),
                            //           bottomLeft: Radius.zero,
                            //           bottomRight: Radius.circular(20)),
                            //     ),
                            //     color: (blogType == 2 && externalFileType == 0)
                            //         ? Theme.of(context).accentColor
                            //         : Theme.of(context).primaryColor,
                            //     disabledColor: Colors.grey,
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceEvenly,
                            //       children: [
                            //         Flexible(
                            //           flex: 2,
                            //           fit: FlexFit.tight,
                            //           child: Text(
                            //             AppLocalizations.of(context).video,
                            //             textAlign: TextAlign.center,
                            //             style: regularMontserrat(
                            //                 color: Colors.white, fontSize: 12),
                            //           ),
                            //         ),
                            //         Flexible(
                            //           flex: 1,
                            //           child: Icon(
                            //             Icons.videocam,
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: FlatButton(
                                onPressed: ((blogType == 0 && imageFileType == 0) ||
                                        (blogType == 1 && imageFileType == 1))
                                    ? () async {
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                          type: FileType.custom,
                                          allowedExtensions: ["jpg, jpeg, png"],
                                        );
                                        if (result != null) {
                                          List<PlatformFile> platformFiles = result.files;
                                          platformFiles.forEach((element) {
                                            FileResponse fileResponse = FileResponse();
                                            fileResponse.url = element.path;
                                            fileResponse.name = element.name;
                                            fileResponse.extension = element.extension;
                                            files.add(fileResponse);
                                          });
                                          blogType = 1;
                                          externalFileType = 0;
                                          imageFileType = 1;
                                          _addBlogBloc.add(AddBlogUpdateFilesListEvent(
                                            files: files,
                                          ));
                                        }
                                      }
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(20)),
                                ),
                                color: (blogType == 1 && imageFileType == 1)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                disabledColor: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        AppLocalizations.of(context).photo.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: regularMontserrat(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.photo,
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
                                onPressed: ((blogType == 0 && imageFileType == 0) ||
                                        (blogType == 1 && imageFileType == 0))
                                    ? () async {
                                        final picker = ImagePicker();
                                        final pickedFile =
                                            await picker.getImage(source: ImageSource.camera);

                                        if (pickedFile != null) {
                                          FileResponse fileResponse = FileResponse();
                                          fileResponse.url = pickedFile.path;
                                          fileResponse.name = pickedFile.path
                                              .substring(pickedFile.path.lastIndexOf('/') + 1);
                                          fileResponse.extension = pickedFile.path
                                              .substring(pickedFile.path.lastIndexOf('.') + 1);
                                          files.add(fileResponse);

                                          blogType = 1;
                                          externalFileType = 0;
                                          imageFileType = 0;
                                          _addBlogBloc.add(AddBlogUpdateFilesListEvent(
                                            files: files,
                                          ));
                                        }
                                      }
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(20)),
                                ),
                                color: (blogType == 1 && imageFileType == 0)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                disabledColor: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        AppLocalizations.of(context).camera.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: regularMontserrat(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Icons.camera_alt,
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
                        showFiles(),
                        SizedBox(
                          height: 10,
                        ),
                        showLinkPreview(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: state is AddBlogViewToHealthcareOnlyState
                                  ? state.viewToHealthcareOnly
                                  : viewToHealthcareProvidersOnly,
                              onChanged: (value) {
                                viewToHealthcareProvidersOnly = value;
                                _addBlogBloc.add(
                                  AddBlogViewToHealthcareProvidersOnlyEvent(
                                    viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
                                  ),
                                );
                              },
                            ),
                            Expanded(
                                child: Text(
                              AppLocalizations.of(context).this_blog_is_seen_only_health_car,
                              textAlign: TextAlign.start,
                              style: lightMontserrat(
                                color: Colors.black87,
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
                              if (categoryId.isEmpty) {
                                GlobalPurposeFunctions.showToast(
                                  AppLocalizations.of(context).category_cannot_be_empty,
                                  context,
                                );
                              } else if (subCategoryId.isEmpty) {
                                GlobalPurposeFunctions.showToast(
                                  AppLocalizations.of(context).subCategory_cannot_be_empty,
                                  context,
                                );
                              } else if (_titleController.text.length <= 10) {
                                GlobalPurposeFunctions.showToast(
                                  AppLocalizations.of(context)
                                      .blog_title_should_be_more_than_10_characters,
                                  context,
                                );
                              } else if (_descriptionController.text.length <= 10) {
                                GlobalPurposeFunctions.showToast(
                                  AppLocalizations.of(context)
                                      .blog_Details_should_be_more_than_10_characters,
                                  context,
                                );
                              } else {
                                List<String> tags = <String>[];
                                for (SearchModel item in selectedTagsItem) {
                                  tags.add(item.id);
                                }
                                _addBlogBloc.add(
                                  AddBlogPostButtonClicked(
                                    id: widget.blogId,
                                    subCategoryId: subCategoryId,
                                    groupId: widget?.groupId ?? null,
                                    title: _titleController.text,
                                    body: _descriptionController.text,
                                    blogType: blogType,
                                    viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
                                    publishByCreator: publishByCreator,
                                    blogTags: tags,
                                    files: files
                                        .where(
                                          (element) => element.id == null,
                                        )
                                        .toList(),
                                    externalFileUrl: externalFileUrl,
                                    externalFileType: externalFileType,
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
                              AppLocalizations.of(context).post,
                              style: semiBoldMontserrat(
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
        ));
  }

  Widget showTags() {
    return Wrap(
      children: selectedTagsItem.map((e) {
        return Padding(
          padding: EdgeInsets.only(left: 4, right: 4),
          child: InkWell(
              onTap: () {
                _addBlogBloc.add(AddBlogRemoveSelectedTagItem(
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
              _addBlogBloc.add(AddBlogRemoveFileItem(
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

  Widget showLinkPreview() {
    return (externalFileUrl.isNotEmpty)
        ? Column(
            children: [
              Container(
                padding: EdgeInsets.all(
                  10.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12.0,
                    ),
                  ),
                ),
                child: LinkPreview(
                  linkStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.375,
                  ),
                  metadataTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.375,
                  ),
                  metadataTitleStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.375,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  onPreviewDataFetched: (previewData) {
                    _addBlogBloc.add(
                      AddBlogShowLinkPreviewEvent(true),
                    );
                    _previewData = previewData;
                  },
                  previewData: _previewData,
                  text: externalFileUrl,
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.375,
                  ),
                  width: MediaQuery.of(context).size.width / 1.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: InkWell(
                  onTap: () {
                    _addBlogBloc.add(
                      AddBlogShowLinkPreviewEvent(false),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).remove,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            width: 0.0,
            height: 0.0,
          );
  }

  void _handelGetMainCategorySuccess(AddBlogGetMainCategoryState state) {
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

  void _handelGetSubCategory(AddBlogGetSubCategoryState state) {
    searchedList.clear();
    for (var i = 0; i < state.subCategories.length; i++) {
      searchedList
          .add(SearchModel(id: state.subCategories[i].id, name: state.subCategories[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: searchedList,
            )).then((val) {
      if (val != null) {
        subCategoryId = state.subCategories[val].id;
        _subCategoryController.text = state.subCategories[val].name;
      }
    });
  }

  void _handleGetTagsSuccess(AddBlogGetTagsState state) {
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
        _addBlogBloc.add(AddBlogChanagSelectedTagListEvent(tagsItem: value));
      }
    });
  }

  void _handleChanagSelectedTagListState(AddBlogChanagSelectedTagListState state) {
    wrapTagItemsIndex.clear();
    selectedTagsItem = state.tagsItem;
    for (int i = 0; i < selectedTagsItem.length; i++) {
      wrapTagItemsIndex[selectedTagsItem[i].id] = i;
    }
  }

  void _handleUpdatedFilesState(AddBlogUpdatedFileListState state) {
    wrapFilesItemsIndex.clear();
    files = state.files;
    for (int i = 0; i < files.length; i++) {
      wrapFilesItemsIndex[files[i].name] = i;
    }
    if (files.length == 0) {
      blogType = 0;
      externalFileType = 0;
      imageFileType = 0;
      externalFileUrl = "";
    }
  }

  void _handleBlogInfoResponse(BlogDetailsResponse response) {
    categoryId = response.categoryId;
    _mainCategoryController.text = response.category;
    subCategoryId = response.subCategoryId;
    _subCategoryController.text = response.subCategory;
    _titleController.text = response.title;
    _descriptionController.text = response.body;
    if (response.tags != null) {
      List<SearchModel> localTags = <SearchModel>[];
      response.tags.forEach((element) {
        SearchModel searchModel = SearchModel(name: element.name, id: element.id);
        localTags.add(searchModel);
      });
      _addBlogBloc.add(AddBlogChanagSelectedTagListEvent(tagsItem: localTags));
    }
    switch (response.blogType) {
      case 0:
        {}
        break;
      case 1:
        {
          blogType = 1;
          externalFileType = 0;
          imageFileType = 1;
          if (response.files != null) {
            List<FileResponse> localFiles = <FileResponse>[];
            response.files.forEach((element) {
              FileResponse file = FileResponse();
              file.name = element.name;
              file.extension = element.extension.substring(1);
              file.url = element.url;
              file.id = element.id;
              localFiles.add(file);
            });
            _addBlogBloc.add(AddBlogUpdateFilesListEvent(
              files: localFiles,
            ));
          }
        }
        break;
      case 2:
        {
          if (response.files[0].fileType == 0) {
            removedFiles.add(response.files[0].id);
            blogType = 2;
            externalFileType = 0;
            imageFileType = 0;
            if (response.files != null) {
              List<FileResponse> localFiles = <FileResponse>[];
              response.files.forEach((element) {
                FileResponse file = FileResponse();
                file.name = element.name;
                file.extension = element.extension.substring(1);
                file.url = element.url;
                file.id = element.id;
                localFiles.add(file);
              });
              _addBlogBloc.add(AddBlogUpdateFilesListEvent(
                files: localFiles,
              ));
            }
          } else if (response.files[0].fileType == 1) {
            externalFileId = response.files[0].id;
            removedFiles.add(response.files[0].id);
            blogType = 2;
            externalFileType = 1;
            imageFileType = 0;
            externalFileUrl = response.files[0].url;
            _addBlogBloc.add(
              AddBlogShowLinkPreviewEvent(true),
            );
          }
        }
        break;

      case 3:
        {
          blogType = 3;
          externalFileType = 0;
          imageFileType = 0;
          if (response.files != null) {
            List<FileResponse> localFiles = <FileResponse>[];
            response.files.forEach((element) {
              FileResponse file = FileResponse();
              file.name = element.name;
              file.extension = element.extension.substring(1);
              file.url = element.url;
              file.id = element.id;
              localFiles.add(file);
            });
            _addBlogBloc.add(AddBlogUpdateFilesListEvent(
              files: localFiles,
            ));
          }
        }
        break;
      case 4:
        {
          blogType = 4;
          externalFileType = 0;
          imageFileType = 0;
          if (response.files != null) {
            List<FileResponse> localFiles = <FileResponse>[];
            response.files.forEach((element) {
              FileResponse file = FileResponse();
              file.name = element.name;
              file.extension = element.extension.substring(1);
              file.url = element.url;
              file.id = element.id;
              localFiles.add(file);
            });
            _addBlogBloc.add(AddBlogUpdateFilesListEvent(
              files: localFiles,
            ));
          }
        }
        break;
    }

    viewToHealthcareProvidersOnly = response.viewToHealthcareProvidersOnly;
  }
}
