import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/domain/common/social_register.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/registration_socail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/registration/registration_bloc.dart';
import '../../../common/app_const.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../injections.dart';
import 'register_business_user_screen.dart';
import 'register_individual_user_screen.dart';
import 'register_normal_user_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration_screen';
  final SocailRegisterParam socailRegisterParam;

  RegistrationScreen({Key key, @required this.socailRegisterParam}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationBloc registrationBloc;

  @override
  void initState() {
    super.initState();
    registrationBloc = serviceLocator<RegistrationBloc>();
  }

  Widget _buildCard(String title, String subtitle, IconData icon, BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Icon(
                icon,
                size: 100.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.start,
                          style: lightMontserrat(
                            fontSize: 16,
                            color: Theme.of(context).accentColor,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: mediumMontserrat(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: AppLocalizations.of(context).sign_up,
        leadingWidget: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocProvider<RegistrationBloc>(
          create: (context) => registrationBloc,
          child: BlocListener<RegistrationBloc, RegistrationState>(
            listener: (context, state) {
              if (state is LoadingState)
                GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              else if (state is AccountTypesState) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) => _showBottomSheet(context));
              } else if (state is RemoteClientErrorState)
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) => GlobalPurposeFunctions.showToast(
                          AppLocalizations.of(context).data_error,
                          context,
                        ));
              else if (state is RemoteValidationErrorState)
                GlobalPurposeFunctions.showToast(
                  state.remoteValidationErrorMessage,
                  context,
                );
              else if (state is RemoteServerErrorState)
                GlobalPurposeFunctions.showToast(
                  state.remoteServerErrorMessage,
                  context,
                );
              else if (state is EnterpriseAccountIdState) {
                Navigator.of(context).pop();
                if (widget.socailRegisterParam.token == "-1") {
                  _socialMedialBottomSheet(context, () {
                    Navigator.of(context).pushNamed(
                      RegisterIndividualUserScreen.routeName,
                      arguments: widget.socailRegisterParam,
                    );
                  }, RegisterationType.Enterprise);
                } else {
                  Navigator.of(context).pushNamed(RegisterIndividualUserScreen.routeName,
                      arguments: widget.socailRegisterParam);
                }
              } else if (state is IndividualAccountIdState) {
                Navigator.of(context).pop();
                if (widget.socailRegisterParam.token == "-1") {
                  _socialMedialBottomSheet(context, () {
                    Navigator.of(context).pushNamed(
                      RegisterBusinessUserScreen.routeName,
                      arguments: widget.socailRegisterParam,
                    );
                  }, RegisterationType.Individual);
                } else {
                  Navigator.of(context).pushNamed(RegisterBusinessUserScreen.routeName,
                      arguments: widget.socailRegisterParam);
                }
              }
            },
            child: BlocBuilder<RegistrationBloc, RegistrationState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      child: Image.asset(
                        "assets/images/platform_icon.png",
                        height: 80,
                        width: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                        onTap: () {
                          if (widget.socailRegisterParam.token == "-1")
                            _socialMedialBottomSheet(context, () {
                              Navigator.of(context).pushNamed(
                                RegisterNormalUserScreen.routeName,
                                arguments: widget.socailRegisterParam,
                              );
                            }, RegisterationType.NormalUser);
                          else {
                            Navigator.of(context).pushNamed(RegisterNormalUserScreen.routeName,
                                arguments: widget.socailRegisterParam);
                          }
                        },
                        child: _buildCard(
                            AppLocalizations.of(context).patient_interest_in_the_healthCare_world,
                            AppLocalizations.of(context).register_as_user,
                            Icons.person,
                            context)),
                    Row(
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
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          color: Colors.transparent,
                          child: Text(
                            AppLocalizations.of(context).or,
                            style: mediumMontserrat(
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
                    ),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<RegistrationBloc>(context).add(GetAccountTypesEvent());
                        //if (state is AccountTypesState) _showBottomSheet(context);
                      },
                      child: _buildCard(
                          AppLocalizations.of(context)
                              .doctor_dentist_pharmacist_hospital_laboratory_company_student_etc,
                          AppLocalizations.of(context).register_as_a_health_care_provider,
                          Icons.person,
                          context),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future _socialMedialBottomSheet(
      BuildContext context, Function navigate, RegisterationType registerationType) {
    return showModalBottomSheet<dynamic>(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return BlocProvider<RegistrationBloc>.value(
            value: registrationBloc,
            child: BlocBuilder<RegistrationBloc, RegistrationState>(
              builder: (context, state) {
                return Container(
                    height: 250,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        RegistrationSocail(registerationType: registerationType),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: navigate,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      child: Text(
                                        AppLocalizations.of(context).contnue_with_email,
                                        style: regularMontserrat(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ), //
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      child: Image.asset(
                                        "assets/images/gmail.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            ),
          );
        });
  }

  Future _showBottomSheet(BuildContext context) {
    return showModalBottomSheet<dynamic>(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return BlocProvider<RegistrationBloc>.value(
            value: registrationBloc,
            child: BlocBuilder<RegistrationBloc, RegistrationState>(
              builder: (context, state) {
                if (state is AccountTypeChangedState)
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: Colors.white),
                    child: Wrap(children: [
                      Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(10),
                                  padding:
                                      EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.zero,
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).choose_account_type,
                                    style: mediumMontserrat(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: FlatButton.icon(
                                        onPressed: () {
                                          BlocProvider.of<RegistrationBloc>(context)
                                              .add(EnterpriseSelectedEvent());
                                        },
                                        shape: GlobalPurposeFunctions.buildButtonBorder(),
                                        color: state.accountType == AppConst.UNKNOWN ||
                                                state.accountType == AppConst.INDIVIDUAL
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).accentColor,
                                        icon: Icon(
                                          Icons.people,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          AppLocalizations.of(context).enterprise,
                                          style: semiBoldMontserrat(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: FlatButton.icon(
                                        onPressed: () {
                                          BlocProvider.of<RegistrationBloc>(context)
                                              .add(IndividualSelectedEvent());
                                        },
                                        shape: GlobalPurposeFunctions.buildButtonBorder(),
                                        color: state.accountType == AppConst.UNKNOWN ||
                                                state.accountType == AppConst.BUSINESS
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).accentColor,
                                        icon: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          AppLocalizations.of(context).individual,
                                          style: semiBoldMontserrat(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  state.accountType == AppConst.UNKNOWN
                                      ? AppLocalizations.of(context).please_select_account_type
                                      : state.accountType == AppConst.INDIVIDUAL
                                          ? AppLocalizations.of(context).individual_info
                                          : AppLocalizations.of(context).business_info,
                                  style: regularMontserrat(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: FlatButton(
                                  onPressed: state.accountType == AppConst.UNKNOWN
                                      ? null
                                      : state.accountType == AppConst.INDIVIDUAL
                                          ? () => context
                                              .read<RegistrationBloc>()
                                              .add(NextButtonPressedEvent(state.accountType))
                                          : () => context
                                              .read<RegistrationBloc>()
                                              .add(NextButtonPressedEvent(state.accountType)),
                                  child: Text(
                                    AppLocalizations.of(context).next,
                                    style: semiBoldMontserrat(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  color: Theme.of(context).accentColor,
                                  disabledColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  );
                else
                  return Container();
              },
            ),
          );
        });
  }
}
