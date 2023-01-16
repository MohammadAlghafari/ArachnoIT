import 'dart:ui';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/domain/common/social_register.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/terms_and_policy_text.dart';
import 'package:arachnoit/presentation/screens/in_app_terms_and_conditions/in_app_terms_and_conditions_Screen.dart';
import 'package:arachnoit/presentation/screens/login/login_screen.dart';
import 'package:flutter/gestures.dart';
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
import '../../../injections.dart';
import '../../custom_widgets/activaiton_dialog.dart';
import '../../custom_widgets/dropdown_text_field.dart';
import '../../custom_widgets/register_card_sub_headline.dart';
import '../../custom_widgets/registration_card.dart';
import '../../custom_widgets/registration_headline.dart';
import '../../custom_widgets/searchDialog.dart';
import '../../custom_widgets/styled_text_field.dart';
import '../verification/verification_screen.dart';

class RegisterNormalUserScreen extends StatefulWidget {
  static const routeName = '/register_normal_user_screen';
  final SocailRegisterParam socailRegisterParam;

  const RegisterNormalUserScreen({Key key, this.socailRegisterParam})
      : super(key: key);

  @override
  _RegisterNormalUserScreenState createState() =>
      _RegisterNormalUserScreenState();
}

class _RegisterNormalUserScreenState extends State<RegisterNormalUserScreen> {
  RegistrationBloc registrationBloc;
  ScrollController scrollController;
  TextEditingController firstNameController = TextEditingController(text: "");
  //FocusNode firstNameNode = FocusNode();
  TextEditingController lastNameController = TextEditingController(text: "");
  //FocusNode lastNameNode = FocusNode();
  TextEditingController dateOfBirthController = TextEditingController(text: "");
  //FocusNode dateOfBirthNode = FocusNode();
  TextEditingController emailController = TextEditingController(text: "");
  //FocusNode emailNode = FocusNode();
  TextEditingController countryController = TextEditingController(text: "");
  //FocusNode countryNode = FocusNode();
  TextEditingController cityController = TextEditingController(text: "");
  //FocusNode cityNode = FocusNode();
  TextEditingController mobileCodeController = TextEditingController(text: "");
  //FocusNode mobileCodeNode = FocusNode();
  TextEditingController mobileController = TextEditingController(text: "");
  //FocusNode mobileNode = FocusNode();
  TextEditingController passwordController = TextEditingController(text: "");
  //FocusNode passwordNode = FocusNode();
  TextEditingController confirmPasswordController =
  TextEditingController(text: "");
  //FocusNode confirmPasswordNode = FocusNode();
  int genderGroupValue = 0;
  bool agreeOnTerms = false;
  List<SearchModel> searchedList = [];
  CountryResponse country;
  CitiesByCountryResponse city;
  RegExp regex = RegExp(AppConst.EMAILPATTERN);
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  @override
  void initState() {
    super.initState();
    genderGroupValue = widget.socailRegisterParam.gender;
    dateOfBirthController.text = widget.socailRegisterParam.birthday;
    scrollController = ScrollController();
    registrationBloc = serviceLocator<RegistrationBloc>();
    emailController.text = widget.socailRegisterParam.email;
    firstNameController.text = widget.socailRegisterParam.firstName;
    lastNameController.text = widget.socailRegisterParam.lastName;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    //firstNameNode.dispose();
    lastNameController.dispose();
    //lastNameNode.dispose();
    dateOfBirthController.dispose();
    //dateOfBirthNode.dispose();
    emailController.dispose();
    //emailNode.dispose();
    countryController.dispose();
    //countryNode.dispose();
    cityController.dispose();
    //cityNode.dispose();
    mobileCodeController.dispose();
    //mobileCodeNode.dispose();
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBarProject.showAppBar(
            title: AppLocalizations
                .of(context)
                .normal_user,
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
                  confirmPasswordController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: confirmPasswordController.text.length));
                  confirmPasswordVisibility = state.visibility;
                } else if (state is LoadingState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, true);
                else if (state is RemoteValidationErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    state.remoteValidationErrorMessage,
                    context,
                  ));
                else if (state is RemoteClientErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).data_error,
                    context,
                  ));
                else if (state is RemoteServerErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    state.remoteServerErrorMessage,
                    context,
                  ));
                else if (state is CountriesState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.countries.length; i++) {
                      searchedList.add(SearchModel(
                          id: state.countries[i].id,
                          name: state.countries[i].name));
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
                        /*  BlocProvider.of<RegistrationBloc>(context)
                            .add(RegistrationCountryChanged(country.name)); */
                      }
                    });
                  });
                } else if (state is CititesByCountryState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.cities.length; i++) {
                      searchedList.add(SearchModel(
                          id: state.cities[i].id, name: state.cities[i].name));
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
                } else if (state.dateOfBirth.invalid) {
                  //dateOfBirthNode.requestFocus();
                  scrollController.jumpTo(0);
                } else if (state.email.invalid) {
                  //emailNode.requestFocus();
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent / 2);
                } else if (state.country.invalid) {
                  //countryNode.requestFocus();
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent / 2);
                } else if (state.city.invalid) {
                  //cityNode.requestFocus();
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                } else if (state.mobile.invalid) {
                  //mobileNode.requestFocus();
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                } else if (state.password.invalid) {
                  //passwordNode.requestFocus();
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                } else if (state.confirmPassword.invalid) {
                  //confirmPasswordNode.requestFocus();
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                } else if (state is RegistrationUserRegisteredState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, true)
                      .then((value) =>
                      Navigator.of(context)
                          .pushReplacementNamed(VerificationScreen.routeName));
                else if (state is RegistrationInputValidatedState) {
                  if (!agreeOnTerms) {
                    GlobalPurposeFunctions.showToast(
                        AppLocalizations
                            .of(context)
                            .please_agree_to_our_terms_to_continue,
                        context);
                    return;
                  }
                  BlocProvider.of<RegistrationBloc>(context)
                      .add(RegistrationValidateEmailPhone(
                    email: emailController.text,
                    mobile: mobileCodeController.text + mobileController.text,
                  ));
                } else if (state is RegistrationIsEmailMobileAvailableState &&
                    !state.emailAvailable.isAvailable &&
                    state.emailAvailable.isConfirmed)
                  GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).email_error,
                    context,
                  );
                else if (state is RegistrationIsEmailMobileAvailableState &&
                    !state.emailAvailable.isAvailable &&
                    !state.emailAvailable.isConfirmed)
                  showDialog(
                      context: context,
                      builder: (context) => ActivationDialog());
                else if (state is RegistrationIsEmailMobileAvailableState &&
                    !state.mobileAvailable.isAvailable)
                  GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).mobile_error,
                    context,
                  );
                else if (state is RegistrationIsEmailMobileAvailableState &&
                    state.emailAvailable.isAvailable &&
                    state.mobileAvailable.isAvailable)
                  BlocProvider.of<RegistrationBloc>(context)
                      .add(RegistrationRegisterNormalUser(
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
                          AppLocalizations.of(context).normal_user +
                          "\""),
                  RegistrationCard(
                    cardHeadline:
                    AppLocalizations
                        .of(context)
                        .your_personal_information,
                    children: [
                      RegisterCardSubHeadline(
                          text: AppLocalizations
                              .of(context)
                              .first_name_),
                      SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<RegistrationBloc, RegistrationState>(
                        buildWhen: (previous, current) =>
                        previous.firstName != current.firstName,
                        builder: (context, state) {
                          return StyledTextField(
                              hintText: AppLocalizations.of(context).first_name,
                              controller: firstNameController,
                              // node: firstNameNode,
                              textInputAction: TextInputAction.next,
                              errorText: state.firstName.invalid
                                  ?AppLocalizations
                                  .of(context)
                                  .this_field_is_required
                                  : null,
                              /*  handleOnChange: (value) {
                              if (firstNameController.text.isNotEmpty)
                                BlocProvider.of<RegistrationBloc>(context)
                                    .add(RegistrationFirstNameChanged(value));
                            }, */
                              readOnly: false);
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RegisterCardSubHeadline(
                        text: AppLocalizations.of(context).last_name_,
                      ),
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
                                  ?AppLocalizations
                                  .of(context)
                                  .this_field_is_required
                                  : null,
                              /*  handleOnChange: (value) {
                              if (lastNameController.text.isNotEmpty)
                                BlocProvider.of<RegistrationBloc>(context)
                                    .add(RegistrationLastNameChanged(value));
                            }, */
                              readOnly: false);
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Stack(
                        children: [
                          BlocBuilder<RegistrationBloc, RegistrationState>(
                            buildWhen: (previous, current) =>
                            previous.dateOfBirth != current.dateOfBirth ||
                                previous.lastName != current.lastName,
                            builder: (context, state) {
                              return DropDownTextField(
                                hintText:
                                AppLocalizations
                                    .of(context)
                                    .date_of_birth,
                                controller: dateOfBirthController,
                                // node: dateOfBirthNode,
                                errorText: state.lastName.invalid
                                    ? null
                                    : state.dateOfBirth.invalid
                                    ?AppLocalizations
                                    .of(context)
                                    .this_field_is_required
                                    : null,
                                handleTap: () async {
                                  String date = await GlobalPurposeFunctions
                                      .buildDataPicker(context);
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
                                text: AppLocalizations
                                    .of(context)
                                    .date_of_birth_),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RegisterCardSubHeadline(
                          text: AppLocalizations
                              .of(context)
                              .gender),
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
                                        .add(RegistrationGenderChangedEvent(
                                        value));
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
                                        .add(RegistrationGenderChangedEvent(
                                        value));
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
                      cardHeadline:
                      AppLocalizations
                          .of(context)
                          .contact_information,
                      children: [
                        RegisterCardSubHeadline(
                            text: AppLocalizations
                                .of(context)
                                .email_),
                        SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<RegistrationBloc, RegistrationState>(
                          buildWhen: (previous, current) =>
                          previous.email != current.email ||
                              previous.dateOfBirth != current.dateOfBirth ||
                              current
                              is RegistrationIsEmailMobileAvailableState ||
                              current is LoadingAvailabilityState,
                          builder: (context, state) {
                            return StyledTextField(
                              hintText: AppLocalizations.of(context).email,
                              readOnly:
                              (widget.socailRegisterParam.email.length == 0)
                                  ?false
                                  : true,
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              //node: emailNode,
                              keyboardType: TextInputType.emailAddress,
                              errorText: state.dateOfBirth.invalid
                                  ? null
                                  : state.email.invalid
                                  ?AppLocalizations
                                  .of(context)
                                  .email_invalid
                                  : null,
                              /*  handleOnChange: (value) {
                                if (emailController.text.isNotEmpty &&
                                    regex.hasMatch(value))
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(RegistrationEmailChanged(value));
                              }, */
                              suffixIcon: state is LoadingAvailabilityState
                                  ? LoadingBloc()
                                  : state
                              is RegistrationIsEmailMobileAvailableState
                                  ? state.emailAvailable.isAvailable
                                  ?Icon(Icons.check,
                                  color: Colors.green)
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
                                  hintText:
                                  AppLocalizations
                                      .of(context)
                                      .country,
                                  controller: countryController,
                                  //node: countryNode,
                                  errorText: state.email.invalid
                                      ? null
                                      : state.country.invalid
                                      ?AppLocalizations
                                      .of(context)
                                      .this_field_is_required
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
                                      ?AppLocalizations
                                      .of(context)
                                      .this_field_is_required
                                      : null,
                                  handleTap: () {
                                    countryController.text.isEmpty
                                        ? GlobalPurposeFunctions.showToast(
                                      AppLocalizations
                                          .of(context)
                                          .choose_your_country_first,
                                      context,
                                    )
                                        : BlocProvider.of<RegistrationBloc>(
                                        context)
                                        .add(GetCitiesByCountryEvent(
                                        country.id));
                                  },
                                );
                              },
                            ),
                            Positioned(
                              child: RegisterCardSubHeadline(
                                  text: AppLocalizations
                                      .of(context)
                                      .city_),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RegisterCardSubHeadline(
                            text: AppLocalizations
                                .of(context)
                                .mobile_),
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
                                //node: mobileCodeNode,
                                textInputAction: TextInputAction.next,
                                errorText: null,
                                handleOnChange: (value) {},
                                readOnly: true,
                              ),
                            ),
                            Expanded(
                                child: BlocBuilder<RegistrationBloc,
                                    RegistrationState>(
                                  buildWhen: (previous, current) =>
                                  previous.mobile != current.mobile ||
                                      previous.city != current.city ||
                                      current
                                      is RegistrationIsEmailMobileAvailableState ||
                                      current is LoadingAvailabilityState,
                                  builder: (context, state) {
                                    return StyledTextField(
                                      hintText: AppLocalizations.of(context).mobile,
                                      controller: mobileController,
                                      readOnly: false,
                                      // node: mobileNode,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      errorText: state.city.invalid
                                          ? null
                                          : state.mobile.invalid
                                          ?AppLocalizations
                                          .of(context)
                                          .this_field_is_required
                                          : null,
                                      /* handleOnChange: (value) {
                                    if (mobileController.text.isNotEmpty)
                                      BlocProvider.of<RegistrationBloc>(context)
                                          .add(
                                              RegistrationMobileChanged(value));
                                  }, */
                                      suffixIcon: state is LoadingAvailabilityState
                                          ? LoadingBloc()
                                          : state
                                      is RegistrationIsEmailMobileAvailableState
                                          ? state.mobileAvailable.isAvailable
                                          ?Icon(Icons.check,
                                          color: Colors.green)
                                          : Icon(Icons.clear,
                                          color: Colors.red)
                                          : null,
                                    );
                                  },
                                )),
                          ],
                        ),
                      ]),
                  RegistrationCard(
                      cardHeadline:
                      AppLocalizations
                          .of(context)
                          .security_information,
                      children: [
                        RegisterCardSubHeadline(
                            text: AppLocalizations
                                .of(context)
                                .password_),
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
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(PasswordVisibilityChangedEvent(
                                      visibility: passwordVisibility));
                                },
                                child: Icon(
                                  passwordVisibility
                                      ?Icons.visibility
                                      : Icons.visibility_off,
                                  size: 22,
                                ),
                              ),
                              controller: passwordController,
                              // node: passwordNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              obscureText: passwordVisibility ? false : true,
                              errorText: state.mobile.invalid
                                  ? null
                                  : state.password.invalid
                                  ?AppLocalizations
                                  .of(context)
                                  .password_invalid
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
                            text:
                            AppLocalizations
                                .of(context)
                                .confirm_password_),
                        SizedBox(
                          height: 5,
                        ),
                        BlocBuilder<RegistrationBloc, RegistrationState>(
                          buildWhen: (previous, current) =>
                          previous.confirmPassword !=
                              current.confirmPassword ||
                              previous.password != current.password ||
                              current is ConfirmPasswordVisibilityChangedState,
                          builder: (context, state) {
                            return StyledTextField(
                              hintText:
                              AppLocalizations
                                  .of(context)
                                  .confirm_password,
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<RegistrationBloc>(context)
                                      .add(
                                      ConfirmPasswordVisibilityChangedEvent(
                                          visibility:
                                          confirmPasswordVisibility));
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
                              obscureText:
                              confirmPasswordVisibility ?false : true,
                              errorText: state.password.invalid
                                  ? null
                                  : state.confirmPassword.invalid
                                  ?AppLocalizations
                                  .of(context)
                                  .password_not_match
                                  : null,
                              /*  handleOnChange: (value) {
                                if (confirmPasswordController.text.isNotEmpty && state.firstName.valid && state.lastName.valid && state.dateOfBirth.valid && state.email.valid && state.country.valid && state.city.valid && state.mobile.valid)
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
                                if (state
                                is RegistrationAgreeOnTermsChangedState)
                                  agreeOnTerms = state.agree;
                              },
                              child: BlocBuilder<RegistrationBloc,
                                  RegistrationState>(
                                builder: (context, state) {
                                  return Checkbox(
                                      value: agreeOnTerms,
                                      onChanged: (value) {
                                        BlocProvider.of<RegistrationBloc>(
                                            context)
                                            .add(
                                            RegistrationAgreeOnTermsChangedEvent(
                                                value));
                                      });
                                },
                              ),
                            ),
                            TermsAndPolicyText()
                          ],
                        ),
                      ]),
                  BlocBuilder<RegistrationBloc, RegistrationState>(
                    buildWhen: (previous, current) =>
                    previous.status != current.status,
                    builder: (context, state) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          onPressed: () {
                            if (state.status.isPure || state.status.isInvalid)
                              BlocProvider.of<RegistrationBloc>(context)
                                  .add(RegistrationValidateNormalUserInputs(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                dateOfBirth: dateOfBirthController.text,
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
                            style: regularMontserrat(color: Colors.white, fontSize: 18),
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
