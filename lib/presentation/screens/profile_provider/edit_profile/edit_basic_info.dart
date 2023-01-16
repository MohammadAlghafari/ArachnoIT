import 'dart:io';
import 'dart:ui';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_sheet_image_selected.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/register_card_sub_headline.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditBasicInfo extends StatefulWidget {
  final int userType;
  final HealthCareProviderProfileDto healthcareProviderProfileDto;
  EditBasicInfo({@required this.userType, @required this.healthcareProviderProfileDto});
  @override
  State<StatefulWidget> createState() {
    return _EditBasicInfo();
  }
}

class _EditBasicInfo extends State<EditBasicInfo> {
  ///--> using this just to know if any things changed in this screen when change update the rebuild value
  Map<String, String> _rebuild = {};
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _fullNameInArabicController = TextEditingController();
  TextEditingController _abountController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _qualificationController = TextEditingController();
  TextEditingController _subQualificationController = TextEditingController();
  String qualificationId = '';
  String subQualificationId = '';
  List<SearchModel> seachItems = [];
  ProfileProviderBloc profileProviderBloc;
  File image = File("");
  ValueNotifier<int> selectedGenderType;

  @override
  void initState() {
    super.initState();
    selectedGenderType = ValueNotifier(widget.healthcareProviderProfileDto.gender);
    profileProviderBloc = serviceLocator<ProfileProviderBloc>();
    HealthCareProviderProfileDto htDto = widget.healthcareProviderProfileDto;
    _firstNameController.text = htDto.firstName;
    _lastNameController.text = htDto.lastName;
    _fullNameInArabicController.text = htDto.inTouchPointName;
    _abountController.text = htDto.summary;
    _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(htDto.birthdate);
    _qualificationController.text = htDto.specification;
    _subQualificationController.text = htDto.subSpecification;
    qualificationId = htDto.specificationId;
    subQualificationId = htDto.subSpecificationId;
    if (htDto.profilePhotoUrl != null) image = File(htDto.profilePhotoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_rebuild.length != 0)
          Navigator.of(context).pop(_rebuild);
        else
          Navigator.pop(context);
        return true;
      },
      child: Scaffold(
          appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).edit_basic_info),
          body: BlocProvider<ProfileProviderBloc>(
            create: (context) => profileProviderBloc,
            child: BlocListener<ProfileProviderBloc, ProfileProviderState>(
              listener: (context, state) {
                if (state is InvalidState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                  GlobalPurposeFunctions.showToast(
                      AppLocalizations.of(context).check_your_internet_connection, context);
                } else if (state is SuccessChangeImage) {
                  _rebuild['value'] = "value";
                  image = state.image;
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {});
                } else if (state is SuccessGetALLSpecification) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                    _handleSuccessGetALLSpecification(state);
                  });
                } else if (state is SuccessGetAllSubSpecification) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                    _handleSuccessGetAllSubSpecification(state);
                  });
                } else if (state is SuccessUpdateUserInfo) {
                  _rebuild['value'] = "value";
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                      .then((value) => Navigator.of(context).pop(_rebuild));
                } else {
                  GlobalPurposeFunctions.showToast(
                      AppLocalizations.of(context).check_your_internet_connection, context);
                }
              },
              child: ListView(
                padding: EdgeInsets.only(top: 18, left: 8, right: 8),
                children: [
                  showImageAndName(),
                  SizedBox(height: 20),
                  showFullNameInArabic(),
                  SizedBox(height: 20),
                  showAbout(),
                  SizedBox(height: 20),
                  showBirth(),
                  SizedBox(height: 20),
                  showQualification(),
                  SizedBox(height: 20),
                  showSubQualification(),
                  SizedBox(height: 20),
                  maleAndFemaleCheckBox(),
                  SizedBox(height: 20),
                  showCancelAndSaveButton(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )),
    );
  }

  Widget maleAndFemaleCheckBox() {
    return ValueListenableBuilder<int>(
        valueListenable: selectedGenderType,
        builder: (context, value, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: (value == 0) ? true : false,
                onChanged: (value) {
                  selectedGenderType.value = 0;
                },
              ),
              Text(AppLocalizations.of(context).male),
              SizedBox(
                width: 20,
              ),
              Checkbox(
                  value: (value == 1) ? true : false,
                  onChanged: (value) {
                    selectedGenderType.value = 1;
                  }),
              Text(AppLocalizations.of(context).female),
            ],
          );
        });
  }

  void _handleSuccessGetAllSubSpecification(SuccessGetAllSubSpecification state) {
    seachItems.clear();
    for (int i = 0; i < state.items.length; i++) {
      seachItems.add(SearchModel(name: state.items[i].name, id: state.items[i].id));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: seachItems,
            )).then((val) {
      if (val != null) {
        _subQualificationController.text = seachItems[val].name;
        subQualificationId = seachItems[val].id.toString();
      }
    });
  }

  void _handleSuccessGetALLSpecification(SuccessGetALLSpecification state) {
    seachItems.clear();
    for (int i = 0; i < state.items.length; i++) {
      seachItems.add(SearchModel(name: state.items[i].name, id: state.items[i].id));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: seachItems,
            )).then((val) {
      if (val != null) {
        _qualificationController.text = seachItems[val].name;
        qualificationId = seachItems[val].id.toString();
      }
    });
  }

  Widget showCancelAndSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
                child: Text(
                  AppLocalizations.of(context).cancel,
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () async {
            profileProviderBloc.add(ChangeUserInfo(
              summary: _abountController.text,
              subSpecificationId: subQualificationId,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              inTouchPointName: _fullNameInArabicController.text,
              birthdate: _dateOfBirthController.text,
              context: context,
              gender: selectedGenderType.value,
            ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              color: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
                child: Text(
                  AppLocalizations.of(context).save,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showSubQualification() {
    return Stack(
      children: [
        DropDownTextField(
          hintText: _subQualificationController.text,
          controller: _subQualificationController,
          errorText: "",
          color: Theme.of(context).primaryColor,
          handleTap: () async {
            if (qualificationId.length == 0) {
              GlobalPurposeFunctions.showToast(
                  AppLocalizations.of(context).please_add +
                      " " +
                      AppLocalizations.of(context).qualification,
                  context);
            } else {
              profileProviderBloc.add(
                  GetSubSpecificationsEvent(specificationId: qualificationId, context: context));
            }
          },
        ),
        Positioned(
          child: RegisterCardSubHeadline(text: AppLocalizations.of(context).sub_qualification),
        )
      ],
    );
  }

  Widget showQualification() {
    return Stack(
      children: [
        DropDownTextField(
          hintText: _qualificationController.text,
          controller: _qualificationController,
          errorText: "",
          color: Theme.of(context).primaryColor,
          handleTap: () async {
            profileProviderBloc
                .add(GetSpecificationsEvent(accountTypeId: widget.userType, context: context));
          },
        ),
        Positioned(
          child: RegisterCardSubHeadline(text: AppLocalizations.of(context).qualification),
        )
      ],
    );
  }

  Widget showBirth() {
    return Stack(
      children: [
        DropDownTextField(
          hintText: _dateOfBirthController.text,
          controller: _dateOfBirthController,
          errorText: "",
          color: Theme.of(context).primaryColor,
          handleTap: () async {
            String date = await GlobalPurposeFunctions.buildDataPicker(context);
            if (date != null) {
              _dateOfBirthController.text = date;
            }
          },
        ),
        Positioned(
          child: RegisterCardSubHeadline(text: AppLocalizations.of(context).date_of_birth_),
        )
      ],
    );
  }

  Widget showAbout() {
    return Row(
      children: [
        showTextField(
          controller: _abountController,
          title: AppLocalizations.of(context).about,
          fullWidth: true,
          maxLine: 3,
        ),
      ],
    );
  }

  Widget showImageAndName() {
    return BlocBuilder<ProfileProviderBloc, ProfileProviderState>(
      buildWhen: (last, current) {
        if (current is SuccessChangeImage) {
          return true;
        } else
          return false;
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () async {
                await BottomSheetImageSelected.getDialog(context).then((val) async {
                  if (val != null) {
                    if (val["delete"] == true) {
                      profileProviderBloc
                          .add(ChangeImageScreen(isDeleteImage: true, context: context));
                    } else if (val['file'] != null) {
                      PickedFile x = val['file'];
                      File file = await GlobalPurposeFunctions.cropImage(File(x.path));
                      profileProviderBloc.add(
                          ChangeImageScreen(image: file, isDeleteImage: false, context: context));
                    }
                  }
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: Container(
                  color: Colors.grey.shade300,
                  width: 100,
                  height: 100, //
                  child: (image.path == "")
                      ? Icon(Icons.image)
                      : ChachedNetwrokImageView(
                          showFullImageWhenClick: false,
                          imageUrl: image.path,
                          function: () async {
                            await BottomSheetImageSelected.getDialog(context).then((val) async {
                              if (val != null) {
                                if (val["delete"] == true) {
                                  profileProviderBloc.add(
                                      ChangeImageScreen(isDeleteImage: true, context: context));
                                } else {
                                  PickedFile x = val['file'];
                                  File file = await GlobalPurposeFunctions.cropImage(File(x.path));
                                  profileProviderBloc.add(ChangeImageScreen(
                                      image: file, isDeleteImage: false, context: context));
                                }
                              }
                            });
                          },
                        ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                showTextField(
                  controller: _firstNameController,
                  title: AppLocalizations.of(context).first_name_in_english,
                ),
                SizedBox(width: 10),
                showTextField(
                    controller: _lastNameController,
                    title: AppLocalizations.of(context).last_name_in_english),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget showFullNameInArabic() {
    return Row(
      children: [
        showTextField(
            controller: _fullNameInArabicController,
            title: AppLocalizations.of(context).full_name_in_arabic,
            fullWidth: true,
            maxLine: 1),
      ],
    );
  }

  Widget showTextField(
      {TextEditingController controller,
      String title,
      IconData icon,
      bool fullWidth = false,
      int maxLine = 1}) {
    return Padding(
      padding: EdgeInsets.only(left: 6, right: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                width: (fullWidth)
                    ? MediaQuery.of(context).size.width - 30
                    : MediaQuery.of(context).size.width - 150,
                child: TextField(
                  maxLines: maxLine,
                  decoration: InputDecoration(
                    suffixIcon: (Icon(icon) ?? null),
                  ),
                  cursorColor: Colors.grey,
                  selectionWidthStyle: BoxWidthStyle.max,
                  controller: controller,
                  smartQuotesType: SmartQuotesType.enabled,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
