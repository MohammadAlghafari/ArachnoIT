import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../../application/verification/verification_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../injections.dart';
import '../main/main_screen.dart';
import '../registraition/registration_screen.dart';

class VerificationScreen extends StatefulWidget {
  static const routeName = '/verification_screen';

  const VerificationScreen({Key key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  VerificationBloc verificationBloc;
  TextEditingController confirmCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    verificationBloc = serviceLocator<VerificationBloc>();
  }

  @override
  void dispose() {
    confirmCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => verificationBloc,
            child: BlocListener<VerificationBloc, VerificationState>(
              listener: (context, state) {
                if (state is ClipboardDetectedState)
                  confirmCodeController.text = state.code;
                if (state is LoadingState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, true);
                if (state is ConfirmedRegistrationState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => Navigator.of(context)
                      .pushReplacementNamed(MainScreen.routeName));
                if (state is WrongActivationCodeState)
                  GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).wrong_activation_code,
                    context,
                  );
                if (state is ActivationCodeSentState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    AppLocalizations
                        .of(context)
                        .re_send_activation_code,
                    context,
                  ));

                if (state is RemoteValidationErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    state.remoteValidationErrorMessage,
                    context,
                  ));
                if (state is RemoteServerErrorState)
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) => GlobalPurposeFunctions.showToast(
                    state.remoteServerErrorMessage,
                    context,
                  ));
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context).verification,
                    style: semiBoldMontserrat(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations
                        .of(context)
                        .otp_has_been_sent_to_you_on_your_email_phone_please_enter_it_below,
                    textAlign: TextAlign.center,
                    style: regularMontserrat(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: BlocBuilder<VerificationBloc, VerificationState>(
                      builder: (context, state) {
                        return PinPut(
                          fieldsCount: 8,
                          eachFieldWidth: 30,
                          eachFieldHeight: 35,
                          eachFieldMargin: EdgeInsets.all(0),
                          eachFieldPadding: EdgeInsets.all(0),
                          textStyle: regularMontserrat(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                          eachFieldConstraints: BoxConstraints(
                            maxWidth: 30,
                            maxHeight: 35,
                          ),
                          pinAnimationType: PinAnimationType.slide,
                          keyboardType: TextInputType.number,
                          selectedFieldDecoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 1.5,
                                  ))),
                          followingFieldDecoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[600],
                                    width: 1.5,
                                  ))),
                          submittedFieldDecoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.5,
                                  ))),
                          controller: confirmCodeController,
                          onClipboardFound: (code) {
                            BlocProvider.of<VerificationBloc>(context)
                                .add(ClipboardDetectedEvent(code));
                          },
                          onSubmit: (code) {
                            BlocProvider.of<VerificationBloc>(context)
                                .add(ConfirmRegistrationEvent(code));
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<VerificationBloc, VerificationState>(
                    builder: (context, state) {
                      return FlatButton(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        shape: GlobalPurposeFunctions.buildButtonBorder(),
                        onPressed: () {
                          BlocProvider.of<VerificationBloc>(context)
                              .add(SendActivationCodeEvent());
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          AppLocalizations.of(context).resend_activation_code,
                          style: mediumMontserrat(
                              color: Colors.white, fontSize: 16),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    shape: GlobalPurposeFunctions.buildButtonBorder(),
                    onPressed: () {
                      Navigator.of(context).pushNamed(MainScreen.routeName);
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      AppLocalizations.of(context).back_to_home,
                      style:
                      mediumMontserrat(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(RegistrationScreen.routeName);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text:
                            AppLocalizations.of(context).re_register_start,
                            style: regularMontserrat(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalizations
                                    .of(context)
                                    .re_register_middle,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                  text: AppLocalizations
                                      .of(context)
                                      .re_register_end,
                                  style: TextStyle()),
                            ]),
                      ),
                    ),
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
