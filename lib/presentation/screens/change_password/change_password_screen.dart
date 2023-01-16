import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';

import '../../../application/changePassword/change_password_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../injections.dart';
import '../../custom_widgets/styled_text_field.dart';
import '../login/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change_password_screen';

  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordBloc changePasswordBloc;
  bool currentPasswordVisibility = false;
  bool newPasswordVisibility = false;
  bool confirmPasswordVisibility = false;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    changePasswordBloc = serviceLocator<ChangePasswordBloc>();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: AppLocalizations.of(context).change_your_password,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding:
                  EdgeInsets.only(right: 25, left: 25, bottom: 15, top: 50),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocProvider(
                    create: (BuildContext context) => changePasswordBloc,
                    child:
                    BlocListener<ChangePasswordBloc, ChangePasswordState>(
                      listener: (context, state) {
                        if (state is CurrentPasswordVisibilityChangedState) {
                          currentPasswordController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset:
                                  currentPasswordController.text.length));
                          currentPasswordVisibility = state.visibility;
                        } else if (state is NewPasswordVisibilityChangedState) {
                          newPasswordController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: newPasswordController.text.length));
                          newPasswordVisibility = state.visibility;
                        } else if (state
                        is ConfirmPasswordVisibilityChangedState) {
                          confirmPasswordController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset:
                                  confirmPasswordController.text.length));
                          confirmPasswordVisibility = state.visibility;
                        } else if (state is InputsValidatedState)
                          BlocProvider.of<ChangePasswordBloc>(context)
                              .add(ChangePasswordSubmittedEvent(
                            currentPassword: currentPasswordController.text,
                            newPassword: newPasswordController.text,
                            confirmPassword: confirmPasswordController.text,
                          ));
                        else if (state.status.isSubmissionInProgress)
                          GlobalPurposeFunctions.showOrHideProgressDialog(
                              context, true);
                        else if (state is ChangePasswordSuccefulState) {
                          GlobalPurposeFunctions.showOrHideProgressDialog(
                              context, false)
                              .then((value) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                LoginScreen.routeName,
                                    (Route<dynamic> route) => false);
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
                        children: [
                          BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                            buildWhen: (previous, current) =>
                            previous.currentPassword !=
                                current.currentPassword ||
                                current
                                is CurrentPasswordVisibilityChangedState,
                            builder: (context, state) {
                              return StyledTextField(
                                hintText: AppLocalizations.of(context)
                                    .current_password,
                                controller: currentPasswordController,
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<ChangePasswordBloc>(context)
                                        .add(
                                        CurrentPasswordVisibilityChangedEvent(
                                            visibility:
                                            currentPasswordVisibility));
                                  },
                                  child: Icon(
                                    currentPasswordVisibility
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 22,
                                  ),
                                ),
                                errorText: state.currentPassword.invalid
                                    ? AppLocalizations.of(context)
                                    .this_field_is_required
                                    : null,
                                obscureText:
                                currentPasswordVisibility ? false : true,
                                textInputAction: TextInputAction.next,
                                readOnly: false,
                                handleOnChange: (value) {
                                  BlocProvider.of<ChangePasswordBloc>(context)
                                      .add(CurrentPasswordChangedEvent(
                                      currentPassword: value));
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
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
                                    BlocProvider.of<ChangePasswordBloc>(context)
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
                                errorText: state.newPassword.invalid &&
                                    currentPasswordController.text !=
                                        newPasswordController.text
                                    ? AppLocalizations.of(context)
                                    .this_field_is_required
                                    : state.newPassword.invalid &&
                                    currentPasswordController.text ==
                                        currentPasswordController.text
                                    ? AppLocalizations.of(context)
                                    .new_password_cannot_match_old_password
                                    : null,
                                obscureText:
                                newPasswordVisibility ? false : true,
                                textInputAction: TextInputAction.next,
                                readOnly: false,
                                handleOnChange: (value) {
                                  BlocProvider.of<ChangePasswordBloc>(context)
                                      .add(NewPasswordChangedEvent(
                                      currentPassword:
                                      currentPasswordController.text,
                                      newPassword: value));
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                            buildWhen: (previous, current) =>
                            previous.confirmPassword !=
                                current.confirmPassword ||
                                current
                                is ConfirmPasswordVisibilityChangedState,
                            builder: (context, state) {
                              return StyledTextField(
                                hintText: AppLocalizations.of(context)
                                    .confirm_password,
                                controller: confirmPasswordController,
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<ChangePasswordBloc>(context)
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
                                  BlocProvider.of<ChangePasswordBloc>(context)
                                      .add(ConfirmPasswordChangedEvent(
                                      newPassword:
                                      newPasswordController.text,
                                      confirmPassword: value));
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                            buildWhen: (previous, current) =>
                            previous.status != current.status,
                            builder: (context, state) {
                              return Container(
                                width: double.infinity,
                                height: 45,
                                child: FlatButton(
                                  onPressed: () {
                                    BlocProvider.of<ChangePasswordBloc>(context)
                                        .add(ValidateInputsEvent(
                                      currentPassword:
                                      currentPasswordController.text,
                                      newPassword: newPasswordController.text,
                                      confirmPassword:
                                      confirmPasswordController.text,
                                    ));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .change_password,
                                    style: regularMontserrat(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Theme.of(context).accentColor,
                                  shape: GlobalPurposeFunctions
                                      .buildButtonBorder(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 30,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Icon(
                    Icons.lock_open,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
