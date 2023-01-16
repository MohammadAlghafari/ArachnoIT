import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/register_card_sub_headline.dart';
import 'package:arachnoit/presentation/custom_widgets/registration_socail.dart';
import 'package:arachnoit/presentation/custom_widgets/restart_widget.dart';
import 'package:arachnoit/presentation/custom_widgets/styled_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';

import '../../../application/login/login_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../injections.dart';
import '../main/main_screen.dart';
import '../registraition/registration_screen.dart';
import '../verification/verification_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc;
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController emailOrMobileController =
  TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool passwordVisibility = false;

  @override
  void initState() {
    super.initState();
    loginBloc = serviceLocator<LoginBloc>();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailOrMobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (BuildContext context) => loginBloc,
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is PasswordVisibilityChangedState) {
                  passwordController.selection = TextSelection.fromPosition(
                      TextPosition(offset: passwordController.text.length));
                  passwordVisibility = state.visibility;
                } else if (state is InputsValidatedState)
                  BlocProvider.of<LoginBloc>(context).add(LoginSubmitted(
                    emailOrMobile: emailOrMobileController.text,
                    password: passwordController.text,
                  ));
                else if (state is LoginRequestResetPasswordLoadingState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, true);
                else if (state is LoginRequestResetPasswordSuccefulState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) {
                    Navigator.of(context).pop();
                    GlobalPurposeFunctions.showToast(
                        state.successMessage, context);
                  });
                else if (state is LoginSuccefulState) {
                  RestartWidget.of(context).restartApp();
                  GlobalPurposeFunctions.showToast(
                    state.successMessage,
                    context,
                  );
                  Navigator.of(context)
                      .pushReplacementNamed(MainScreen.routeName);
                } else if (state is RemoteValidationErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    state.remoteValidationErrorMessage,
                    context,
                  ));
                else if (state is RemoteServerErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    state.remoteServerErrorMessage,
                    context,
                  ));
                else if (state is RemoteClientErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).data_error,
                    context,
                  ));
                else if (state is AccountNeedsActivationState) {
                  GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).need_verification,
                    context,
                  );
                  Navigator.of(context).pushNamed(VerificationScreen.routeName);
                }
              },
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Container(
                    child: Image.asset(
                      "assets/images/platform_icon.png",
                      height: 80,
                      width: 120,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        _EmailOrMobileInput(
                          loginBloc: loginBloc,
                          controller: emailOrMobileController,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 20,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                            previous.password != current.password ||
                                current is PasswordVisibilityChangedState,
                            builder: (context, state) {
                              return _PasswordInput(
                                passwordController: passwordController,
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<LoginBloc>(context).add(
                                        PasswordVisibilityChangedEvent(
                                            visibility: passwordVisibility));
                                  },
                                  child: Icon(
                                    passwordVisibility
                                        ?Icons.visibility
                                        : Icons.visibility_off,
                                    size: 22,
                                  ),
                                ),
                                errorText: state.password.invalid
                                    ?AppLocalizations
                                    .of(context)
                                    .password_invalid
                                    : null,
                                obscureText: passwordVisibility ? false : true,
                                handleOnchange: (password) =>
                                    context
                                        .read<LoginBloc>()
                                        .add(LoginPasswordChanged(password)),
                              );
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                      previous.status != current.status,
                      builder: (context, state) {
                        return state.status.isSubmissionInProgress
                            ? LoadingBloc()
                            : Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            RegistrationScreen.routeName);
                                      },
                                      child: Text(
                                        AppLocalizations
                                            .of(context)
                                            .sign_up,
                                        style: lightMontserrat(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: RaisedButton(
                                      color:
                                      Theme
                                          .of(context)
                                          .accentColor,
                                      onPressed: () {
                                        context
                                            .read<LoginBloc>()
                                            .add(ValidateInputsEvent(
                                          emailOrMobile:
                                          emailOrMobileController
                                              .text,
                                          password:
                                          passwordController.text,
                                        ));
                                        FocusScope.of(context).unfocus();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        AppLocalizations
                                            .of(context)
                                            .login,
                                        style: semiBoldMontserrat(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showForgetPasswordDialog(context,
                                      emailController, loginBloc);
                                },
                                child: Text(
                                  AppLocalizations
                                      .of(context)
                                      .forgot_password,
                                  style: lightMontserrat(
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  showOrValue(),
                  SizedBox(height: 10),
                  RegistrationSocail(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showOrValue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Divider(
              thickness: 1.5,
              color: Theme.of(context).primaryColor,
              indent: 10,
            )),
        Container(
          padding: EdgeInsets.all(5),
          color: Colors.transparent,
          child: Text(
            AppLocalizations.of(context).or,
            style: regularMontserrat(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Expanded(
            child: Divider(
              thickness: 1.5,
              color: Theme.of(context).primaryColor,
              endIndent: 10,
            )),
      ],
    );
  }

  static showForgetPasswordDialog(BuildContext context,
      TextEditingController emailController, LoginBloc loginBloc) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
          child: BlocProvider.value(
            value: loginBloc,
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
              previous.email != current.email,
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.only(
                                right: 20,
                                left: 20,
                                bottom: 10,
                                top: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.circular(20)),
                              ),
                              child: Text(
                                AppLocalizations.of(context).reset_password,
                                textAlign: TextAlign.start,
                                style: semiBoldMontserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 5),
                            child: RegisterCardSubHeadline(
                                text: AppLocalizations.of(context).email_),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                            child: StyledTextField(
                              hintText: AppLocalizations.of(context).email,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              errorText: state.email.invalid
                                  ?AppLocalizations
                                  .of(context)
                                  .email_invalid
                                  : null,
                              handleOnChange: (value) {
                                context.read<LoginBloc>().add(
                                    LoginForgetPasswordEmailChanged(value));
                              },
                              readOnly: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.white,
                            child: Text(
                              AppLocalizations.of(context).cancel,
                              style: semiBoldMontserrat(
                                color: Theme.of(context).accentColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: FlatButton(
                            onPressed: () {
                              if (state.email.valid)
                                BlocProvider.of<LoginBloc>(context).add(
                                    LoginForgetPasswordSubmitted(
                                        emailController.text));
                            },
                            color: Colors.white,
                            child: Text(
                              AppLocalizations.of(context).submit,
                              style: semiBoldMontserrat(
                                color: Theme.of(context).accentColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}

class _EmailOrMobileInput extends StatelessWidget {
  const _EmailOrMobileInput({
    Key key,
    this.loginBloc,
    this.controller,
  }) : super(key: key);

  final LoginBloc loginBloc;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
      previous.emailOrMobile != current.emailOrMobile,
      builder: (context, state) {
        return TextFormField(
          style: mediumMontserrat(
            fontSize: 18,
            color: Theme
                .of(context)
                .primaryColor,
          ),
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
            ),
            isDense: true,
            contentPadding: EdgeInsets.all(18),
            filled: true,
            fillColor: Colors.grey.shade100,
            hintText: AppLocalizations.of(context).email,
            hintStyle: mediumMontserrat(fontSize: 16, color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none),
            errorText: state.emailOrMobile.invalid
                ?AppLocalizations
                .of(context)
                .email_invalid
                : null,
            errorStyle: TextStyle(color: Colors.red),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          onChanged: (emailOrMobile) => context.read<LoginBloc>().add(
            LoginEmailOrMobileChanged(emailOrMobile),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key key,
    this.passwordController,
    this.prefixIcon,
    this.handleOnchange,
    this.errorText,
    this.obscureText,
  }) : super(key: key);

  final TextEditingController passwordController;
  final Widget prefixIcon;
  final Function handleOnchange;
  final String errorText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:
      mediumMontserrat(fontSize: 18, color: Theme
          .of(context)
          .primaryColor),
      cursorColor: Colors.black,
      controller: passwordController,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        isDense: true,
        contentPadding: EdgeInsets.all(18),
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: AppLocalizations.of(context).password,
        hintStyle: mediumMontserrat(fontSize: 16, color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.red),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      textInputAction: TextInputAction.next,
      obscureText: obscureText,
      onChanged: handleOnchange,
    );
  }
}
