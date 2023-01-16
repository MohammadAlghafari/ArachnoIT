import 'dart:io';
import 'dart:ui';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_sheet_image_selected.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/application/group_add/group_add_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_details_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/register_card_sub_headline.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:arachnoit/presentation/custom_widgets/styled_text_field.dart';
import 'package:arachnoit/presentation/screens/group_members_provider/home_gruop_memebers_screen.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGroupPage extends StatefulWidget {
  static const routeName = 'addGroupPage';
  final GroupDetailsResponse groupDetailsResponse;

  const AddGroupPage({@required this.groupDetailsResponse});

  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class SubCategoryModel {
  final String id;
  final String name;
  final bool selected;

  const SubCategoryModel({
    @required this.name,
    @required this.id,
    @required this.selected,
  });
}

class _AddGroupPageState extends State<AddGroupPage> with TickerProviderStateMixin {
  File _storedImage;
  GroupAddBloc addGroupBloc;
  LoginResponse loginResponse;
  SharedPreferences sharedPreferences;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _categoryDropDownTextFieldController;
  TextEditingController _subCategoryDropDownTextFieldController;
  TextEditingController _mainGroupDropDownTextFieldController;
  FocusNode _nameFocus;
  FocusNode _descriptionFocus;
  FocusNode _categoryFocus;
  FocusNode _subCategoryFocus;
  FocusNode _mainGroupFocus;
  ScrollController scrollController;
  bool isClicked = false;
  String categoryId;
  String parentGroupId;
  File picture;
  String groupId;
  String imageGroup;
  GroupType groupType = GroupType.Public;
  String title='';
  List<SubCategoryModel> subCategory = new List<SubCategoryModel>(0);

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 50,
      maxHeight: 600,
    );
    if (imageFile == null) {
      return;
    }
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      if (croppedFile != null)
        _storedImage = croppedFile;
      else
        _storedImage = File(imageFile.path);
    });
  }



  @override
  void initState() {
    super.initState();
    addGroupBloc = serviceLocator<GroupAddBloc>();
    sharedPreferences=serviceLocator<SharedPreferences>();
    loginResponse=LoginResponse.fromJson(sharedPreferences.getString(PrefsKeys.LOGIN_RESPONSE));
    if (widget.groupDetailsResponse != null) {
      addGroupBloc.add(SetDetailsGroup(subCategories: widget.groupDetailsResponse.subCategories, groupPrivacy: widget.groupDetailsResponse.privacyLevel,groupDetailsResponse: widget.groupDetailsResponse));
      imageGroup = (widget.groupDetailsResponse.image != null) ? widget.groupDetailsResponse.image.url ?? '' : '';
      groupId = widget.groupDetailsResponse.id;
      categoryId = widget.groupDetailsResponse.category.id;
      parentGroupId=widget.groupDetailsResponse.parentGroup.id;
      _nameController = new TextEditingController(text: widget.groupDetailsResponse.name);
      _descriptionController = new TextEditingController(text: widget.groupDetailsResponse.description);
      _categoryDropDownTextFieldController = new TextEditingController(text: widget.groupDetailsResponse.category.name);
      _subCategoryDropDownTextFieldController = new TextEditingController(text:(widget.groupDetailsResponse.subCategories.length>0)? widget.groupDetailsResponse.subCategories.last.name:null);
      _mainGroupDropDownTextFieldController = new TextEditingController(text: widget.groupDetailsResponse.parentGroup.name);

    } else {
      _nameController = new TextEditingController();
      _descriptionController = new TextEditingController();
      _categoryDropDownTextFieldController = new TextEditingController();
      _subCategoryDropDownTextFieldController = new TextEditingController();
      _mainGroupDropDownTextFieldController = new TextEditingController();
    }
    _nameFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _categoryFocus = FocusNode();
    _subCategoryFocus = FocusNode();
    _mainGroupFocus = FocusNode();
    scrollController = ScrollController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarProject.showAppBar(
          title:(widget.groupDetailsResponse!=null)?AppLocalizations.of(context).edit_group:AppLocalizations.of(context).add_group,
        ),
        body: BlocProvider(
            create: (context) => addGroupBloc,
            child: BlocListener<GroupAddBloc, GroupAddState>(
              listener: (context, state) {
                if (state.addGroupStatus is LoadingState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
                } else if (state.addGroupStatus is RemoteValidationErrorState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                  GlobalPurposeFunctions.showToast(AppLocalizations.of(context).error_happened_try_again, context);
                } else if (state.addGroupStatus is RemoteServerErrorState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                  GlobalPurposeFunctions.showToast(AppLocalizations.of(context).server_error, context);
                } else if (state.addGroupStatus is RemoteClientErrorState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                  GlobalPurposeFunctions.showToast(AppLocalizations.of(context).check_your_internet_connection, context);
                } else if (state.stateCategory == RequestState.success) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) => {
                        showDialog(
                            context: context,
                            builder: (context) => SearchDialog(
                                  data: state.groupCategory,
                                )).then((val) {
                          if (val != null) {
                            _categoryDropDownTextFieldController.text = state.groupCategory[val].name;
                            addGroupBloc.add(AddGroupCategoryValidation(categoryDropDown: _categoryDropDownTextFieldController.text));
                            categoryId = state.groupCategory[val].id;
                          }
                        })
                      });
                } else if (state.stateSubCategory == RequestState.success) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) => {
                        showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                                value: addGroupBloc,
                                child: showDialogSubCategory(
                                  state.groupSubCategory,
                                  addGroupBloc,
                                ))).then((val) {
                          if (val != null) {
                            addGroupBloc.add(SpiltSubCategoryChecked(subcategory: val, currentSubCategory: subCategory));

                            //  subCategory=val;
                            //     subCategory.add(SearchModel(name: state.groupSubCategories[val].name, id: state.groupSubCategory[val].id));
                          }
                        })
                      });
                } else if (state.stateAllGroup == RequestState.success) {

                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) => {
                        showDialog(
                            context: context,
                            builder: (context) => SearchDialog(
                                  data: state.groups,
                                )).then((val) {
                          if (val != null) {
                            addGroupBloc.add(RefreshScreen());
                            parentGroupId = state.groups[val].id;
                            _mainGroupDropDownTextFieldController.text = state.groups[val].name;
                          }
                        })
                      });
                }
              },



              child: BlocBuilder<GroupAddBloc, GroupAddState>(builder: (context, state) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: picture == null
                                      ? (imageGroup != null && imageGroup.isNotEmpty)
                                          ? ChachedNetwrokImageView(
                                              isCircle: true,
                                              imageUrl: imageGroup,
                                            )
                                          : Icon(
                                              Icons.camera_alt,
                                              size: 80,
                                              color: Colors.grey,
                                            )
                                      : Image.file(
                                          picture,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      await BottomSheetImageSelected.getDialog(context).then((val) {
                                        if (val != null) {
                                          if(val.keys.first.toString()=='delete'){
                                            picture=null;
                                            imageGroup=null;
                                          }else{
                                            PickedFile x = val['file'];
                                            if(x!=null){
                                              picture = File(x.path);

                                            }
                                          }
                                          addGroupBloc.add(RefreshScreen());

                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Card(
                          elevation: 0.0,
                          margin: EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).group_information+':',
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                        AppLocalizations.of(context).name+":",
                                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                showNameTextField(),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).description+":",
                                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "*",
                                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                showDescriptionTextField(),
                                SizedBox(height: 10),
                                showCategoryDropDown(addGroupBloc),
                                SizedBox(height: 10),
                                showSubCategoryDropDown(addGroupBloc),
                                SizedBox(height: 10),
                                showSubCategorySelected(addGroupBloc),
                                showMainGroupDropDown(addGroupBloc),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        groupPrivacyCard(),
                        saveGroupButton(addGroupBloc),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              }),
            )));
  }

  Widget showSubCategorySelected(GroupAddBloc addGroupBloc) {
    return BlocListener<GroupAddBloc, GroupAddState>(
      listener: (context, state) {
        subCategory = state.groupSubCategorySelected;
        if (subCategory.length > 0 && _subCategoryDropDownTextFieldController.text!= subCategory.last.name){
          _subCategoryDropDownTextFieldController.text = subCategory.last.name;
         addGroupBloc.add(AddGroupSubCategoryValidation(subCategoryDropDown:  _subCategoryDropDownTextFieldController.text));
        }
      //  else _subCategoryDropDownTextFieldController.clear();
      },
      child: BlocBuilder<GroupAddBloc, GroupAddState>(
        buildWhen: (last, current) => last.groupSubCategorySelected != current.groupSubCategorySelected,
        builder: (context, state) {
          return Wrap(
            children: subCategory
                .map((item) => Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 5),
                          Center(
                              child: InkWell(
                            onTap: () {
                              addGroupBloc.add(RemoveSubCategory(subCategoryDeleted: item, subCategories: subCategory));
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
        },
      ),
    );
  }

  Widget groupPrivacyCard() {
    return BlocBuilder<GroupAddBloc, GroupAddState>(
      buildWhen: (last, current) => last.selectedRadioButtonGroupType != current.selectedRadioButtonGroupType,
      builder: (context, state) {
        return Card(
          elevation: 0.0,
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).group_privacy+": *",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                showGroupPrivacyHeader("assets/images/ic_public.svg", AppLocalizations.of(context).public, GroupType.Public, state.selectedRadioButtonGroupType),
                showGroupPrivacyBodyTitle(AppLocalizations.of(context).public_content),
                showGroupPrivacyHeader("assets/images/ic_lock.svg", AppLocalizations.of(context).closed, GroupType.Closed, state.selectedRadioButtonGroupType),
                showGroupPrivacyBodyTitle(AppLocalizations.of(context).closed_content),
                showGroupPrivacyHeader("assets/images/ic_private.svg", AppLocalizations.of(context).private, GroupType.Private, state.selectedRadioButtonGroupType),
                showGroupPrivacyBodyTitle(AppLocalizations.of(context).private_content),
                showGroupPrivacyHeader("assets/images/ic_encoded.svg", AppLocalizations.of(context).encoded, GroupType.Encoded, state.selectedRadioButtonGroupType),
                showGroupPrivacyBodyTitle(AppLocalizations.of(context).encoded_content),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showGroupPrivacyHeader(String img, String title, GroupType value, GroupType groupValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Radio(
              value: value,
              groupValue: groupValue,
              visualDensity: VisualDensity(horizontal: -4.0, vertical: -2.0),
              onChanged: (value) {
                addGroupBloc.add(ChangeRadioButtonIndex(selectedRadioButtonGroupType: value));
              },
              activeColor: Theme.of(context).accentColor,
            ),
          ),
          showSvg(path: img),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget showGroupPrivacyBodyTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(right:40,left: 40),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w300, fontSize: 13),
          )),
        ],
      ),
    );
  }

  Widget showMainGroupDropDown(GroupAddBloc groupAddBloc) {
    return BlocBuilder<GroupAddBloc, GroupAddState>(
      buildWhen: (last, current) => last.addGroupMainGroupDropDown != current.addGroupMainGroupDropDown,
      builder: (context, state) {
        return Stack(
          children: [
            DropDownTextField(
              hintText: AppLocalizations.of(context).mainGroup,
              controller: _mainGroupDropDownTextFieldController,
              errorText: (state.addGroupMainGroupDropDown.invalid) ? AppLocalizations.of(context).this_field_is_required : null,
              handleTap: () {
                groupAddBloc.add(GetAllGroup(healthcareProviderId:loginResponse.userId,groupId: groupId));
              },
            ),
            Positioned(
              child: RegisterCardSubHeadline(text: AppLocalizations.of(context).mainGroup),
            )
          ],
        );
      },
    );
  }

  Widget showSubCategoryDropDown(GroupAddBloc groupAddBloc) {

    return BlocBuilder<GroupAddBloc, GroupAddState>(
      buildWhen: (last, current) => last.addGroupSubCategoryDropDown != current.addGroupSubCategoryDropDown,
      builder: (context, state) {
        return Stack(
          children: [
            DropDownTextField(
              hintText: AppLocalizations.of(context).subCategory,
              controller: _subCategoryDropDownTextFieldController,
              errorText: (state.addGroupSubCategoryDropDown.invalid) ? AppLocalizations.of(context).this_field_is_required : null,
              handleTap: () {
                if (_categoryDropDownTextFieldController.text.isNotEmpty)
                  groupAddBloc.add(GetSubCategoryGroup(categoryId: categoryId, currentSubCategory: subCategory));
                else
                  GlobalPurposeFunctions.showToast(AppLocalizations.of(context).please_select_category, context);
              },
            ),
            Positioned(
              child: RegisterCardSubHeadline(text: AppLocalizations.of(context).categories),
            )
          ],
        );
      },
    );
  }

  Widget showCategoryDropDown(GroupAddBloc groupAddBloc) {
    return BlocBuilder<GroupAddBloc, GroupAddState>(
      buildWhen: (last, current) => last.addGroupCategoryDropDown != current.addGroupCategoryDropDown,
      builder: (context, state) {
        return Stack(
          children: [
            DropDownTextField(
              hintText:AppLocalizations.of(context).categories,
              controller: _categoryDropDownTextFieldController,
              errorText: (state.addGroupCategoryDropDown.invalid) ? AppLocalizations.of(context).this_field_is_required : null,
              handleTap: () {
                groupAddBloc.add(GetCategoryGroup());
              },
            ),
            Positioned(
              child: RegisterCardSubHeadline(text: AppLocalizations.of(context).category),
            )
          ],
        );
      },
    );
  }

  Widget showSvg({String path}) {
    return SvgPicture.asset(
      path,
      width: 20,
      height: 20,
    );
  }

  Widget saveGroupButton(GroupAddBloc addGroupBloc) {
    return BlocBuilder<GroupAddBloc, GroupAddState>(
      builder: (context, state) {
        return BlocListener<GroupAddBloc, GroupAddState>(
          listener: (context, state) {
            if (state.addGroupState == RequestState.success) {
              GlobalPurposeFunctions.showToast(AppLocalizations.of(context).process_success ,context);
              if(groupId==null)
               Navigator.pushNamed(context,HomeGroupMembersScreen.routeName,arguments: state.addGroupResponse.entity.id).then((value) =>   Navigator.pop(context,'back'));
              else {
                switch(state.selectedRadioButtonGroupType){
                  case GroupType.Public:
                    widget.groupDetailsResponse.privacyLevel= 0;
                    break;

                  case GroupType.Closed:
                    widget.groupDetailsResponse.privacyLevel= 1;
                    break;
                  case GroupType.Private:
                    widget.groupDetailsResponse.privacyLevel= 2;
                    break;
                  case GroupType.Encoded:
                    widget.groupDetailsResponse.privacyLevel= 3;
                    break;
                }
                widget.groupDetailsResponse.name= _nameController.text;
                widget.groupDetailsResponse.description= _descriptionController.text;

                  widget.groupDetailsResponse.image.url=null;
                  widget.groupDetailsResponse.image.localeImage=(picture!=null)? picture.path:null;


                Navigator.pop(context,{'picture' :(picture!=null) ?picture.path:null,
                'groupDetailsResponse': widget.groupDetailsResponse});
              }
            }
              if (state.status == FormzStatus.valid && isClicked) {
                isClicked = false;
                addGroupBloc.add(SubmittedButtonAddGroup(
                    id: groupId,
                    name: _nameController.text,
                    description: _descriptionController.text,
                    file: picture,
                    parentGroupId: parentGroupId?? '',
                    privacyLevel: state.selectedRadioButtonGroupType,
                    subCategory: subCategory));
             }
            if (state.addGroupName.invalid && isClicked) {
              isClicked = false;
              scrollController.jumpTo(0);
            } else if (state.addGroupDescription.invalid && isClicked) {
              isClicked = false;
              scrollController.jumpTo(1);
            } else if (state.addGroupCategoryDropDown.invalid && isClicked) {
              isClicked = false;
              scrollController.jumpTo(1);
            } else if (state.addGroupSubCategoryDropDown.invalid && isClicked) {
              isClicked = false;
              scrollController.jumpTo(1);
            } else if (state.addGroupMainGroupDropDown.invalid && isClicked) {
              isClicked = false;
              scrollController.jumpTo(1);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: (state.addGroupState == RequestState.loadingData)
                  ? CircularProgressIndicator()
                  : FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      onPressed: () {
                        isClicked = true;
                        if(subCategory.length==0)
                          _subCategoryDropDownTextFieldController.clear();
                        addGroupBloc.add(
                          AddGroupSaveGroupCheckValidation(
                            description: _descriptionController.text,
                            name: _nameController.text,
                            categoryDropDown: _categoryDropDownTextFieldController.text,
                            mainGroupDropDown: _mainGroupDropDownTextFieldController.text,
                            subCategoryDropDown: _subCategoryDropDownTextFieldController.text,
                          ),
                        );
                      },
                      shape: GlobalPurposeFunctions.buildButtonBorder(),
                      color: Theme.of(context).accentColor,
                      child: Text(
                          AppLocalizations.of(context).save_group,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget showTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "*",
              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget showNameTextField() {
    return BlocBuilder<GroupAddBloc, GroupAddState>(
      buildWhen: (last, current) => last.addGroupName != current.addGroupName,
      builder: (context, state) {
        return StyledTextField(
          hintText: AppLocalizations.of(context).name,
          controller: _nameController,
          textInputAction: TextInputAction.done,
          readOnly: false,
          node: _nameFocus,
          errorText: (state.addGroupName.invalid) ? AppLocalizations.of(context).this_field_is_required : null,
          handleOnChange: (currentValue) {
            BlocProvider.of<GroupAddBloc>(context).add(AddGroupNameChange(name: currentValue));
          },
        );
      },
    );
  }

  Widget showDescriptionTextField() {
    return BlocBuilder<GroupAddBloc, GroupAddState>(
      buildWhen: (last, current) => last.addGroupDescription != current.addGroupDescription,
      builder: (context, state) {
        return StyledTextField(
          hintText: AppLocalizations.of(context).description,
          controller: _descriptionController,
          textInputAction: TextInputAction.done,
          readOnly: false,
          errorText: (state.addGroupDescription.invalid) ? AppLocalizations.of(context).this_field_is_required : null,
          handleOnChange: (currentValue) {
            BlocProvider.of<GroupAddBloc>(context).add(AddGroupDescriptionChange(description: currentValue));
          },
        );
      },
    );
  }

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      leadingActions: [FloatingSearchBarAction.back()],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Colors.accents.map((color) {
              return Container(height: 112, color: color);
            }).toList(),
          ),
        );
      },
      body: Container(
        padding: EdgeInsets.only(top: 50),
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemBuilder: (context, i) => Container(),
          itemCount: 10,
          shrinkWrap: true,
        ),
      ),
      elevation: 0.5,
      automaticallyImplyBackButton: false,
      automaticallyImplyDrawerHamburger: false,
      backdropColor: Colors.grey[100],
      isScrollControlled: true,
    );
  }

  Widget showDialogSubCategory(List<SubCategoryModel> subcategory, GroupAddBloc addGroupBloc) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    List<SubCategoryModel> searchedList = [];
    return Dialog(
        child: BlocListener<GroupAddBloc, GroupAddState>(
      listener: (context, state) {
        searchedList = state.searchSubCategory;
      },
      child: BlocBuilder<GroupAddBloc, GroupAddState>(builder: (context, state) {
        return Container(
            height: 400,
            child: FloatingSearchBar(
              hint: 'Search...',
              hintStyle: TextStyle(
                fontSize: 18,
              ),
              scrollPadding: const EdgeInsets.only(top: 0, bottom: 5),
              transitionDuration: const Duration(milliseconds: 0),
              margins: EdgeInsets.all(5),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: isPortrait ? 0.0 : -1.0,
              openAxisAlignment: 0.0,
              maxWidth: isPortrait ? 600 : 500,
              debounceDelay: const Duration(milliseconds: 0),
              onQueryChanged: (query) {
                addGroupBloc.add(SearchQuerySubCategory(query: query, searchList: subcategory));
              },
              // Specify a custom transition to be used for
              // animating between opened and closed stated.
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              leadingActions: [FloatingSearchBarAction.back()],
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListView.builder(
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () {
                        FloatingSearchBar.of(context).close();
                        SubCategoryModel xx = subcategory.where((element) => element.id == searchedList[i].id).first;
                        addGroupBloc.add(CheckSubCategories(subcategory: subcategory, index: xx));
                      },
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Flexible(fit: FlexFit.tight, flex: 1, child: Icon(Icons.search)),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 4,
                                child: Text(
                                  searchedList[i].name,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: searchedList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                );
              },
              body: Container(
                  padding: EdgeInsets.only(top: 50),
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(bottom: 60),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CheckboxListTile(
                                title: AutoDirection(
                                  text: subcategory[i].name,
                                  child: Text(
                                    subcategory[i].name,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                                  ),
                                ),
                                value: subcategory[i].selected,
                                onChanged: (value) {
                                  addGroupBloc.add(CheckSubCategories(subcategory: subcategory, index: subcategory[i]));
                                }),
                          ),
                          itemCount: subcategory.length,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                color: Colors.white,
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(00.0), side: BorderSide(width: 0.5, color: Colors.grey)),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 18, color: Color(0XFFF76B4F)),
                                      ),
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 60,
                                color: Colors.white,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context, subcategory);
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(00.0), side: BorderSide(width: 0.5, color: Colors.grey)),
                                  child: Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0XFFF76B4F),
                                    ),
                                  )),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              elevation: 0.5,
              automaticallyImplyBackButton: false,
              automaticallyImplyDrawerHamburger: false,
              isScrollControlled: true,
            ));
      }),
    ));
  }

}