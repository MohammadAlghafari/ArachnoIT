import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';

import '../../../application/forgetPassword/forget_password_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../injections.dart';
import '../../custom_widgets/styled_text_field.dart';
import '../login/login_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/forget_password_screen';

  const ForgetPasswordScreen({Key key, @required this.email, @required this.token})
      : super(key: key);

  final String email;
  final String token;

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  ForgetPasswordBloc forgetPasswordBloc;
  bool newPasswordVisibility = false;
  bool confirmPasswordVisibility = false;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    forgetPasswordBloc = serviceLocator<ForgetPasswordBloc>();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: "Arachnoit",
      ),
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          BlocProvider(
            create: (BuildContext context) => forgetPasswordBloc,
            child: BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
              listener: (context, state) {
                if (state is NewPasswordVisibilityChangedState) {
                  newPasswordController.selection = TextSelection.fromPosition(
                      TextPosition(offset: newPasswordController.text.length));
                  newPasswordVisibility = state.visibility;
                } else if (state is ConfirmPasswordVisibilityChangedState) {
                  confirmPasswordController.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: confirmPasswordController.text.length));
                  confirmPasswordVisibility = state.visibility;
                } else if (state is InputsValidatedState)
                  BlocProvider.of<ForgetPasswordBloc>(context).add(
                      ResetPasswordEvent(
                          newPassword: newPasswordController.text,
                          confirmPassword: confirmPasswordController.text,
                          email: widget.email,
                          token: widget.token));
                else if (state.status.isSubmissionInProgress)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, true);
                else if (state is ResetPasswordSuccefulState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                    GlobalPurposeFunctions.showToast(
                        state.successMessage, context);
                  });
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
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(
                        right: 25, left: 25, bottom: 15, top: 50),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
                          buildWhen: (previous, current) =>
                          previous.newPassword != current.newPassword ||
                              current is NewPasswordVisibilityChangedState,
                          builder: (context, state) {
                            return StyledTextField(
                              hintText:
                              AppLocalizations.of(context).new_password,
                              controller: newPasswordController,
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<ForgetPasswordBloc>(context)
                                      .add(NewPasswordVisibilityChangedEvent(
                                      visibility: newPasswordVisibility));
                                },
                                child: Icon(
                                  newPasswordVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 22,
                                ),
                              ),
                              errorText: state.newPassword.invalid
                                  ? AppLocalizations.of(context)
                                  .password_invalid
                                  : null,
                              obscureText: newPasswordVisibility ? false : true,
                              textInputAction: TextInputAction.next,
                              readOnly: false,
                              handleOnChange: (value) {
                                BlocProvider.of<ForgetPasswordBloc>(context)
                                    .add(NewPasswordChangedEvent(
                                    newPassword: value));
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
                          buildWhen: (previous, current) =>
                          previous.confirmPassword !=
                              current.confirmPassword ||
                              current is ConfirmPasswordVisibilityChangedState,
                          builder: (context, state) {
                            return StyledTextField(
                              hintText:
                              AppLocalizations.of(context).confirm_password,
                              controller: confirmPasswordController,
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<ForgetPasswordBloc>(context)
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
                              errorText: state.confirmPassword.invalid
                                  ? AppLocalizations.of(context)
                                  .password_not_match
                                  : null,
                              obscureText:
                              confirmPasswordVisibility ? false : true,
                              textInputAction: TextInputAction.done,
                              readOnly: false,
                              handleOnChange: (value) {
                                BlocProvider.of<ForgetPasswordBloc>(context)
                                    .add(ConfirmPasswordChangedEvent(
                                    newPassword: newPasswordController.text,
                                    confirmPassword: value));
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          child: BlocBuilder<ForgetPasswordBloc,
                              ForgetPasswordState>(
                            buildWhen: (previous, current) =>
                            previous.status != current.status,
                            builder: (context, state) {
                              return FlatButton(
                                onPressed: () {
                                  BlocProvider.of<ForgetPasswordBloc>(context)
                                      .add(ValidateInputsEvent(
                                    newPassword: newPasswordController.text,
                                    confirmPassword:
                                    confirmPasswordController.text,
                                  ));
                                },
                                child: Text(
                                  AppLocalizations.of(context).change_password,
                                  style: regularMontserrat(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                color: Theme.of(context).accentColor,
                                shape:
                                GlobalPurposeFunctions.buildButtonBorder(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 30,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
              ),
              child: Center(
                child: Icon(
                  Icons.lock_open,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
