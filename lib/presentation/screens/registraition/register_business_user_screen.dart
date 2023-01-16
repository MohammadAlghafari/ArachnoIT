import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/domain/common/social_register.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/terms_and_policy_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import '../../../application/registration/registration_bloc.dart';
import '../../../common/app_const.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../common/no_implicit_scroll_physics.dart';
import '../../../infrastructure/api/search_model.dart';
import '../../../infrastructure/registration/response/cities_by_country_response.dart';
import '../../../infrastructure/registration/response/country_reponse.dart';
import '../../../infrastructure/common_response/specification_response.dart';
import '../../../infrastructure/common_response/sub_specification_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/activaiton_dialog.dart';
import '../../custom_widgets/dropdown_text_field.dart';
import '../../custom_widgets/register_card_sub_headline.dart';
import '../../custom_widgets/registration_card.dart';
import '../../custom_widgets/registration_headline.dart';
import '../../custom_widgets/searchDialog.dart';
import '../../custom_widgets/styled_text_field.dart';
import '../verification/verification_screen.dart';

class RegisterBusinessUserScreen extends StatefulWidget {
  static const routeName = '/register_Business_user_screen';
  final SocailRegisterParam socailRegisterParam;

  const RegisterBusinessUserScreen({Key key, @required this.socailRegisterParam}) : super(key: key);

  @override
  _RegisterBusinessUserScreenState createState() => _RegisterBusinessUserScreenState();
}

class _RegisterBusinessUserScreenState extends State<RegisterBusinessUserScreen> {
  RegistrationBloc registrationBloc;
  ScrollController scrollController;
  TextEditingController firstNameController = TextEditingController(text: "");

  //FocusNode firstNameNode = FocusNode();
  TextEditingController lastNameController = TextEditingController(text: "");

  //FocusNode lastNameNode = FocusNode();
  TextEditingController touchPointNameController = TextEditingController(text: "");

  //FocusNode touchPointNameNode = FocusNode();
  TextEditingController dateOfBirthController = TextEditingController(text: "");

  //FocusNode dateOfBirthNode = FocusNode();
  TextEditingController qualificationController = TextEditingController(text: "");

  //FocusNode qualificationNode = FocusNode();
  TextEditingController specialityController = TextEditingController(text: "");

  //FocusNode specialityNode = FocusNode();
  TextEditingController emailController = TextEditingController(text: "");

  //FocusNode emailNode = FocusNode();
  TextEditingController countryController = TextEditingController(text: "");

  //FocusNode countryNode = FocusNode();
  TextEditingController cityController = TextEditingController(text: "");

  //FocusNode cityNode = FocusNode();
  TextEditingController mobileCodeController = TextEditingController(text: "");
  TextEditingController mobileController = TextEditingController(text: "");

  //FocusNode mobileNode = FocusNode();
  TextEditingController passwordController = TextEditingController(text: "");

  //FocusNode passwordNode = FocusNode();
  TextEditingController confirmPasswordController = TextEditingController(text: "");

  //FocusNode confirmPasswordNode = FocusNode();
  int genderGroupValue = 0;
  bool agreeOnTerms = false;
  List<SearchModel> searchedList = [];
  SpecificationResponse specification;
  SubSpecificationResponse subSpecification;
  CountryResponse country;
  CitiesByCountryResponse city;
  RegExp regex = RegExp(AppConst.EMAILPATTERN);
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    genderGroupValue = widget.socailRegisterParam.gender;
    dateOfBirthController.text = widget.socailRegisterParam.birthday;
    registrationBloc = serviceLocator<RegistrationBloc>();
    emailController.text = widget.socailRegisterParam.email;
    firstNameController.text = widget.socailRegisterParam.firstName;
    lastNameController.text = widget.socailRegisterParam.lastName;
    touchPointNameController.text = widget.socailRegisterParam.name;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    //firstNameNode.dispose();
    lastNameController.dispose();
    //lastNameNode.dispose();
    touchPointNameController.dispose();
    //touchPointNameNode.dispose();
    dateOfBirthController.dispose();
    //dateOfBirthNode.dispose();
    qualificationController.dispose();
    //qualificationNode.dispose();
    specialityController.dispose();
    //specialityNode.dispose();
    emailController.dispose();
    //emailNode.dispose();
    countryController.dispose();
    //countryNode.dispose();
    cityController.dispose();
    //cityNode.dispose();
    mobileCodeController.dispose();
    mobileController.dispose();
    //mobileNode.dispose();
    passwordController.dispose();
    //passwordNode.dispose();
    confirmPasswordController.dispose();
    //confirmPasswordNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String accountTypeId = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarProject.showAppBar(
            title: AppLocalizations
                .of(context)
                .register_as_user,
            leadingWidget: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            )),
        body: SingleChildScrollView(
          controller: scrollController,
          physics: NoImplicitScrollPhysics(),
          child: BlocProvider<RegistrationBloc>(
            create: (BuildContext context) => registrationBloc,
            child: BlocListener<RegistrationBloc, RegistrationState>(
              listener: (context, state) {
                if (state is PasswordVisibilityChangedState) {
                  passwordController.selection = TextSelection.fromPosition(
                      TextPosition(offset: passwordController.text.length));
                  passwordVisibility = state.visibility;
                } else if (state is ConfirmPasswordVisibilityChangedState) {
                  confirmPasswordController.selection = TextSelection.fromPosition(
                      TextPosition(offset: confirmPasswordController.text.length));
                  confirmPasswordVisibility = state.visibility;
                } else if (state is LoadingState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
                else if (state is RemoteValidationErrorState)
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
                else if (state is SpecificationState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.specification.length; i++) {
                      searchedList.add(SearchModel(
                          id: state.specification[i].id, name: state.specification[i].name));
                    }
                    showDialog(
                        context: context,
                        builder: (context) => SearchDialog(
                              data: searchedList,
                            )).then((val) {
                      if (val != null) {
                        specification = state.specification[val];
                        qualificationController.text = specification.name;
                        /*  BlocProvider.of<RegistrationBloc>(context).add(
                            RegistrationQualificationChanged(
                                specification.name)); */
                      }
                    });
                  });
                } else if (state is SubSpecificationState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.subSpecifications.length; i++) {
                      searchedList.add(SearchModel(
                          id: state.subSpecifications[i].id,
                          name: state.subSpecifications[i].name));
                    }
                    showDialog(
                        context: context,
                        builder: (context) => SearchDialog(
                              data: searchedList,
                            )).then((val) {
                      if (val != null) {
                        subSpecification = state.subSpecifications[val];
                        specialityController.text = subSpecification.name;
                        /*  BlocProvider.of<RegistrationBloc>(context).add(
                            RegistrationSpecialityChanged(
                                subSpecification.name)); */
                      }
                    });
                  });
                } else if (state is CountriesState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.countries.length; i++) {
                      searchedList.add(
                          SearchModel(id: state.countries[i].id, name: state.countries[i].name));
                    }
                    showDialog(
                        context: context,
                        builder: (context) => SearchDialog(
                              data: searchedList,
                            )).then((val) {
                      if (val != null) {
                        country = state.countries[val];
                        countryController.text = country.name;
                        mobileCodeController.text = country.key;
                        /* BlocProvider.of<RegistrationBloc>(context)
                            .add(RegistrationCountryChanged(country.name)); */
                      }
                    });
                  });
                } else if (state is CititesByCountryState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.cities.length; i++) {
                      searchedList
                          .add(SearchModel(id: state.cities[i].id, name: state.cities[i].name));
                    }
                    showDialog(
                        context: context,
                        builder: (context) => SearchDialog(
                              data: searchedList,
                            )).then((val) {
                      if (val != null) {
                        city = state.cities[val];
                        cityController.text = city.name;
                        /*  BlocProvider.of<RegistrationBloc>(context)
                            .add(RegistrationCityChanged(city.name)); */
                      }
                    });
                  });
                } else if (state.firstName.invalid) {
                  //firstNameNode.requestFocus();
                  scrollController.jumpTo(0);
                } else if (state.lastName.invalid) {
                  //lastNameNode.requestFocus();
                  scrollController.jumpTo(0);
                } else if (state.touchPointName.invalid) {
                  //touchPointNameNode.requestFocus();
                  scrollController.jumpTo(0);
                } else if (state.dateOfBirth.invalid) {
                  //dateOfBirthNode.requestFocus();
                  scrollController.jumpTo(0);
                } else if (state.qualification.invalid) {
                  //qualificationNode.requestFocus();
                  scrollController.jumpTo(0);
                } else if (state.speciality.invalid) {
                  //specialityNode.requestFocus();
                  scrollController.jumpTo(0);
                } else if (state.email.invalid) {
                  //emailNode.requestFocus();
                  scrollController.jumpTo(scrollController.position.maxScrollExtent / 2);
                } else if (state.country.invalid) {
                  //countryNode.requestFocus();
                  scrollController.jumpTo(scrollController.position.maxScrollExtent / 2);
                } else if (state.city.invalid) {
                  //cityNode.requestFocus();
                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                } else if (state.mobile.invalid) {
                  //mobileNode.requestFocus();
                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                } else if (state.password.invalid) {
                  //passwordNode.requestFocus();
                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                } else if (state.confirmPassword.invalid) {
                  //confirmPasswordNode.requestFocus();
                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                } else if (state is RegistrationUserRegisteredState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, true).then((value) =>
                      Navigator.of(context).pushReplacementNamed(VerificationScreen.routeName));
                else if (state is RegistrationInputValidatedState) {
                  if (!agreeOnTerms) {
                    GlobalPurposeFunctions.showToast(
                        AppLocalizations.of(context).please_agree_to_our_terms_to_continue,
                        context);
                    return;
                  }
                  BlocProvider.of<RegistrationBloc>(context).add(RegistrationValidateNameEmailPhone(
                    touchPointName: touchPointNameController.text,
                    email: emailController.text,
                    mobile: mobileCodeController.text + mobileController.text,
                  ));
                } else if (state is RegistrationIsTouchPointNameEmailMobileAvailableState &&
                    !state.emailAvailable.isAvailable &&
                    !state.emailAvailable.isConfirmed)
                  showDialog(context: context, builder: (context) => ActivationDialog());
                else if (state is RegistrationIsTouchPointNameEmailMobileAvailableState &&
                    !state.touchPointNameAvailable.touchPointAvailable)
                  GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).touch_name_error,
                    context,
                  );
                else if (state is RegistrationIsTouchPointNameEmailMobileAvailableState &&
                    !state.emailAvailable.isAvailable &&
                    state.emailAvailable.isConfirmed)
                  GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).email_error,
                    context,
                  );
                else if (state is RegistrationIsTouchPointNameEmailMobileAvailableState &&
                    !state.mobileAvailable.isAvailable)
                  GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).mobile_error,
                    context,
                  );
                else if (state is RegistrationIsTouchPointNameEmailMobileAvailableState &&
                    state.touchPointNameAvailable.touchPointAvailable &&
                    state.emailAvailable.isAvailable &&
                    state.mobileAvailable.isAvailable)
                  BlocProvider.of<RegistrationBloc>(context)
                      .add(RegistrationRegisterHealthCareProvider(
                    inTouchPointName: touchPointNameController.text,
                    subSpecificationId: subSpecification.id,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    birthdate: dateOfBirthController.text,
                    email: emailController.text,
                    cityId: city.id,
                    mobile: mobileController.text,
                    password: passwordController.text,
                    gender: genderGroupValue,
                  ));
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  RegistrationHeadline(
                      text: AppLocalizations.of(context).register_new_account +
                          "\"" +
                          AppLocalizations.of(context).business_user +
                          "\""),
                  RegistrationCard(
                    cardHeadline: AppLocalizations.of(context).your_personal_information,
                    children: [
                      RegisterCardSubHeadline(text: AppLocalizations.of(context).first_name_),
                      SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<RegistrationBloc, RegistrationState>(
                        buildWhen: (previous, current) => previous.firstName != current.firstName,
                        builder: (context, state) {
                          return StyledTextField(
                            hintText: AppLocalizations.of(context).first_name,
                            controller: firstNameController,
                            // node: firstNameNode,
                            textInputAction: TextInputAction.next,
                            errorText: state.firstName.invalid
                                ? AppLocalizations.of(context).this_field_is_required
                                : null,
                            /*  handleOnChange: (value) {
                              if (firstNameController.text.isNotEmpty)
                                BlocProvider.of<RegistrationBloc>(context)
                                    .add(RegistrationFirstNameChanged(value));
                            }, */
                            readOnly: false,
                          );
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RegisterCardSubHeadline(text: AppLocalizations.of(context).last_name_),
                      SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<RegistrationBloc, RegistrationState>(
                        buildWhen: (previous, current) =>
                            previous.lastName != current.lastName ||
                            previous.firstName != current.firstName,
                        builder: (context, state) {
                          return StyledTextField(
                            hintText: AppLocalizations.of(context).last_name,
                            controller: lastNameController,
                            //node: lastNameNode,
                            textInputAction: TextInputAction.next,
                            errorText: state.firstName.invalid
                                ? null
                                : state.lastName.invalid
                                    ? AppLocalizations.of(context).this_field_is_required
                                    : null,
                            /* handleOnChange: (value) {
                              if (lastNameController.text.isNotEmpty)
                                BlocProvider.of<RegistrationBloc>(context)
                                    .add(RegistrationLastNameChanged(value));
                            }, */
                            readOnly: false,
                          );
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RegisterCardSubHeadline(
                        text: AppLocalizations.of(context).touch_point_name_,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<RegistrationBloc, RegistrationState>(
                        buildWhen: (previous, current) =>
                            previous.touchPointName != current.touchPointName ||
                            previous.lastName != current.lastName ||
                            current is RegistrationIsTouchPointNameEmailMobileAvailableState ||
                            current is LoadingAvailabilityState,
                        builder: (context, state) {
                          return StyledTextField(
                            hintText: AppLocalizations.of(context).touch_point_name,
                            readOnly: false,
                            controller: touchPointNameController,
                            //node: touchPointNameNode,
                            textInputAction: TextInputAction.next,
                            errorText: state.lastName.invalid
                                ? null
                                : state.touchPointName.invalid
                                    ? AppLocalizations.of(context).touch_name_invalid
                                    : null,
                            /* handleOnChange: (value) {
                              if (touchPointNameController.text.length > 5)
                                BlocProvider.of<RegistrationBloc>(context).add(
                                    RegistrationTouchPointNameChanged(value));
                            }, */
                            suffixIcon: state is LoadingAvailabilityState
                                ? LoadingBloc()
                                : state is RegistrationIsTouchPointNameEmailMobileAvailableState
                                    ? state.touchPointNameAvailable.touchPointAvailable
                                        ? Icon(Icons.check, color: Colors.green)
                                        : Icon(Icons.clear, color: Colors.red)
                                    : null,
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context).trade_licence_is_recommended_to_use,
                              style: regularMontserrat(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          BlocBuilder<RegistrationBloc, RegistrationState>(
                            buildWhen: (previous, current) =>
                                previous.dateOfBirth != current.dateOfBirth ||
                                previous.touchPointName != current.touchPointName,
                            builder: (context, state) {
                              return DropDownTextField(
                                hintText: AppLocalizations.of(context).date_create_enterprise,
                                controller: dateOfBirthController,
                                //node: dateOfBirthNode,
                                errorText: state.touchPointName.invalid
                                    ? null
                                    : state.dateOfBirth.invalid
                                        ? AppLocalizations.of(context).this_field_is_required
                                        : null,
                                handleTap: () async {
                                  String date =
                                      await GlobalPurposeFunctions.buildDataPicker(context);
                                  if (date != null) {
                                    dateOfBirthController.text = date;
                                    /* BlocProvider.of<RegistrationBloc>(context)
                                    .add(RegistrationDateOfBirthChanged(date)); */
                                  }
                                },
                              );
                            },
                          ),
                          Positioned(
                            child: RegisterCardSubHeadline(
                                text: AppLocalizations.of(context).date_create_enterprise_),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          BlocBuilder<RegistrationBloc, RegistrationState>(
                            buildWhen: (previous, current) =>
                                previous.qualification != current.qualification ||
                                previous.dateOfBirth != current.dateOfBirth,
                            builder: (context, state) {
                              return DropDownTextField(
                                hintText: AppLocalizations.of(context).type,
                                controller: qualificationController,
                                //node: qualificationNode,
                                errorText: state.dateOfBirth.invalid
                                    ? null
                                    : state.qualification.invalid
                                        ? AppLocalizations.of(context).this_field_is_required
                                        : null,
                                handleTap: () {
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(GetSpecificationsEvent(accountTypeId));
                                },
                              );
                            },
                          ),
                          Positioned(
                            child:
                                RegisterCardSubHeadline(text: AppLocalizations.of(context).type_),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          BlocBuilder<RegistrationBloc, RegistrationState>(
                            buildWhen: (previous, current) =>
                                previous.speciality != current.speciality ||
                                previous.qualification != current.qualification,
                            builder: (context, state) {
                              return DropDownTextField(
                                hintText: AppLocalizations.of(context).speciality,
                                controller: specialityController,
                                //node: specialityNode,
                                errorText: state.qualification.invalid
                                    ? null
                                    : state.speciality.invalid
                                        ? AppLocalizations.of(context).this_field_is_required
                                        : null,
                                handleTap: () {
                                  qualificationController.text.isEmpty
                                      ? GlobalPurposeFunctions.showToast(
                                          AppLocalizations.of(context)
                                              .please_choose_your_type_first,
                                          context,
                                        )
                                      : BlocProvider.of<RegistrationBloc>(context)
                                          .add(GetSubSpecificationsEvent(specification.id));
                                },
                              );
                            },
                          ),
                          Positioned(
                            child: RegisterCardSubHeadline(
                                text: AppLocalizations.of(context).speciality_),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RegisterCardSubHeadline(text: AppLocalizations.of(context).gender),
                      BlocListener<RegistrationBloc, RegistrationState>(
                        listener: (context, state) {
                          if (state is RegistrationGenderChangedState)
                            genderGroupValue = state.genderType;
                        },
                        child: BlocBuilder<RegistrationBloc, RegistrationState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0,
                                  groupValue: genderGroupValue,
                                  onChanged: (value) {
                                    BlocProvider.of<RegistrationBloc>(context)
                                        .add(RegistrationGenderChangedEvent(value));
                                  },
                                  activeColor: Theme.of(context).accentColor,
                                ),
                                Text(AppLocalizations.of(context).male),
                                SizedBox(
                                  width: 20,
                                ),
                                Radio(
                                  value: 1,
                                  groupValue: genderGroupValue,
                                  onChanged: (value) {
                                    BlocProvider.of<RegistrationBloc>(context)
                                        .add(RegistrationGenderChangedEvent(value));
                                  },
                                  activeColor: Theme.of(context).accentColor,
                                ),
                                Text(AppLocalizations.of(context).female),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  RegistrationCard(
                      cardHeadline: AppLocalizations.of(context).contact_information,
                      children: [
                        RegisterCardSubHeadline(text: AppLocalizations.of(context).email_),
                        SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<RegistrationBloc, RegistrationState>(
                          buildWhen: (previous, current) =>
                              previous.email != current.email ||
                              previous.speciality != current.speciality ||
                              current is RegistrationIsTouchPointNameEmailMobileAvailableState ||
                              current is LoadingAvailabilityState,
                          builder: (context, state) {
                            return StyledTextField(
                              hintText: AppLocalizations.of(context).email,
                              readOnly:
                                  (widget.socailRegisterParam.email.length == 0) ? false : true,
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              //node: emailNode,
                              keyboardType: TextInputType.emailAddress,
                              errorText: state.speciality.invalid
                                  ? null
                                  : state.email.invalid
                                      ? AppLocalizations.of(context).email_invalid
                                      : null,
                              /* handleOnChange: (value) {
                                if (emailController.text.isNotEmpty &&
                                    regex.hasMatch(value))
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(RegistrationEmailChanged(value));
                              }, */
                              suffixIcon: state is LoadingAvailabilityState
                                  ? LoadingBloc()
                                  : state is RegistrationIsTouchPointNameEmailMobileAvailableState
                                      ? state.emailAvailable.isAvailable
                                          ? Icon(Icons.check, color: Colors.green)
                                          : Icon(Icons.clear, color: Colors.red)
                                      : null,
                            );
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            BlocBuilder<RegistrationBloc, RegistrationState>(
                              buildWhen: (previous, current) =>
                                  previous.country != current.country ||
                                  previous.email != current.email,
                              builder: (context, state) {
                                return DropDownTextField(
                                  hintText: AppLocalizations.of(context).country,
                                  controller: countryController,
                                  //node: countryNode,
                                  errorText: state.email.invalid
                                      ? null
                                      : state.country.invalid
                                          ? AppLocalizations.of(context).this_field_is_required
                                          : null,
                                  handleTap: () {
                                    BlocProvider.of<RegistrationBloc>(context)
                                        .add(GetCountriesEvent());
                                  },
                                );
                              },
                            ),
                            Positioned(
                              child: RegisterCardSubHeadline(
                                  text: AppLocalizations.of(context).country_),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Stack(
                          children: [
                            BlocBuilder<RegistrationBloc, RegistrationState>(
                              buildWhen: (previous, current) =>
                                  previous.city != current.city ||
                                  previous.country != current.country,
                              builder: (context, state) {
                                return DropDownTextField(
                                  hintText: AppLocalizations.of(context).city,
                                  controller: cityController,
                                  //node: cityNode,
                                  errorText: state.country.invalid
                                      ? null
                                      : state.city.invalid
                                          ? AppLocalizations.of(context).this_field_is_required
                                          : null,
                                  handleTap: () {
                                    countryController.text.isEmpty
                                        ? GlobalPurposeFunctions.showToast(
                                            AppLocalizations.of(context).choose_your_country_first,
                                            context,
                                          )
                                        : BlocProvider.of<RegistrationBloc>(context)
                                            .add(GetCitiesByCountryEvent(country.id));
                                  },
                                );
                              },
                            ),
                            Positioned(
                              child:
                                  RegisterCardSubHeadline(text: AppLocalizations.of(context).city_),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RegisterCardSubHeadline(text: AppLocalizations.of(context).mobile_),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 75,
                              child: StyledTextField(
                                hintText: AppLocalizations.of(context).code,
                                controller: mobileCodeController,
                                textInputAction: TextInputAction.next,
                                obscureText: false,
                                errorText: null,
                                handleOnChange: (value) {},
                                readOnly: true,
                              ),
                            ),
                            Expanded(
                                child: BlocBuilder<RegistrationBloc, RegistrationState>(
                              buildWhen: (previous, current) =>
                                  previous.mobile != current.mobile ||
                                  previous.city != current.city ||
                                  current
                                      is RegistrationIsTouchPointNameEmailMobileAvailableState ||
                                  current is LoadingAvailabilityState,
                              builder: (context, state) {
                                return StyledTextField(
                                  hintText: AppLocalizations.of(context).mobile,
                                  readOnly: false,
                                  controller: mobileController,
                                  //node: mobileNode,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  errorText: state.city.invalid
                                      ? null
                                      : state.mobile.invalid
                                          ? AppLocalizations.of(context).this_field_is_required
                                          : null,
                                  /* handleOnChange: (value) {
                                    if (mobileController.text.isNotEmpty)
                                      BlocProvider.of<RegistrationBloc>(context)
                                          .add(
                                              RegistrationMobileChanged(value));
                                  }, */
                                  suffixIcon: state is LoadingAvailabilityState
                                      ? LoadingBloc()
                                      : state is RegistrationIsTouchPointNameEmailMobileAvailableState
                                          ? state.mobileAvailable.isAvailable
                                              ? Icon(Icons.check, color: Colors.green)
                                              : Icon(Icons.clear, color: Colors.red)
                                          : null,
                                );
                              },
                            )),
                          ],
                        ),
                      ]),
                  RegistrationCard(
                      cardHeadline: AppLocalizations.of(context).security_information,
                      children: [
                        RegisterCardSubHeadline(text: AppLocalizations.of(context).password_),
                        SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<RegistrationBloc, RegistrationState>(
                          buildWhen: (previous, current) =>
                              previous.password != current.password ||
                              previous.mobile != current.mobile ||
                              current is PasswordVisibilityChangedState,
                          builder: (context, state) {
                            return StyledTextField(
                              hintText: AppLocalizations.of(context).password,
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<RegistrationBloc>(context).add(
                                      PasswordVisibilityChangedEvent(
                                          visibility: passwordVisibility));
                                },
                                child: Icon(
                                  passwordVisibility ? Icons.visibility : Icons.visibility_off,
                                  size: 22,
                                ),
                              ),
                              controller: passwordController,
                              //node: passwordNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              obscureText: passwordVisibility ? false : true,
                              errorText: state.mobile.invalid
                                  ? null
                                  : state.password.invalid
                                      ? AppLocalizations.of(context).password_invalid
                                      : null,
                              /*  handleOnChange: (value) {
                                if (passwordController.text.length > 6)
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(RegistrationPasswordChanged(value));
                              }, */
                              readOnly: false,
                            );
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RegisterCardSubHeadline(
                            text: AppLocalizations.of(context).confirm_password_),
                        SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<RegistrationBloc, RegistrationState>(
                          buildWhen: (previous, current) =>
                              previous.confirmPassword != current.confirmPassword ||
                              previous.password != current.password ||
                              current is ConfirmPasswordVisibilityChangedState,
                          builder: (context, state) {
                            return StyledTextField(
                              hintText: AppLocalizations.of(context).confirm_password,
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<RegistrationBloc>(context).add(
                                      ConfirmPasswordVisibilityChangedEvent(
                                          visibility: confirmPasswordVisibility));
                                },
                                child: Icon(
                                  confirmPasswordVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 22,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              controller: confirmPasswordController,
                              //node: confirmPasswordNode,
                              keyboardType: TextInputType.text,
                              obscureText: confirmPasswordVisibility ? false : true,
                              errorText: state.password.invalid
                                  ? null
                                  : state.confirmPassword.invalid
                                      ? AppLocalizations.of(context).password_not_match
                                      : null,
                              /*  handleOnChange: (value) {
                                if (confirmPasswordController.text.isNotEmpty)
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(RegistrationConfirmPasswordChanged(
                                          value));
                              }, */
                              readOnly: false,
                            );
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            BlocListener<RegistrationBloc, RegistrationState>(
                              listener: (context, state) {
                                if (state is RegistrationAgreeOnTermsChangedState)
                                  agreeOnTerms = state.agree;
                              },
                              child: BlocBuilder<RegistrationBloc, RegistrationState>(
                                builder: (context, state) {
                                  return Checkbox(
                                      value: agreeOnTerms,
                                      onChanged: (value) {
                                        BlocProvider.of<RegistrationBloc>(context)
                                            .add(RegistrationAgreeOnTermsChangedEvent(value));
                                      });
                                },
                              ),
                            ),
                            TermsAndPolicyText()
                          ],
                        ),
                      ]),
                  BlocBuilder<RegistrationBloc, RegistrationState>(
                    buildWhen: (previous, current) => previous.status != current.status,
                    builder: (context, state) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          onPressed: () {
                            if (state.status.isPure || state.status.isInvalid)
                              BlocProvider.of<RegistrationBloc>(context)
                                  .add(RegistrationValidateIndividualOrBusinessUserInputs(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                touchPointName: touchPointNameController.text,
                                dateOfBirth: dateOfBirthController.text,
                                qualification: qualificationController.text,
                                speciality: specialityController.text,
                                email: emailController.text,
                                country: countryController.text,
                                city: cityController.text,
                                mobile: mobileController.text,
                                password: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                              ));
                            else if (!agreeOnTerms) {
                              GlobalPurposeFunctions.showToast(
                                  AppLocalizations.of(context)
                                      .please_agree_to_our_terms_to_continue,
                                  context);
                            }
                          },
                          shape: GlobalPurposeFunctions.buildButtonBorder(),
                          color: Theme.of(context).accentColor,
                          child: Text(
                            AppLocalizations.of(context).register,
                            style: regularMontserrat(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
