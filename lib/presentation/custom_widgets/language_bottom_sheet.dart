import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../application/language/language_bloc.dart';
import '../../common/global_prupose_functions.dart';
import 'restart_widget.dart';

// ignore: must_be_immutable
class LanguageBottomSheet extends StatelessWidget {
  LanguageBottomSheet({Key key, @required this.languageBloc}) : super(key: key);

  final LanguageBloc languageBloc;
  String currentLanguage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                    padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.circular(20)),
                    ),
                    child: Text(
                      AppLocalizations.of(context).please_choose_language,
                      style: mediumMontserrat(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 10),
                  child: BlocProvider(
                    create: (context) => languageBloc..add(LanguageInitialEvent()),
                    child: BlocListener<LanguageBloc, LanguageState>(
                      listener: (context, state) {
                        if (state is LanguageInitialState) {
                          currentLanguage = state.language;
                        } else if (state is SameLanguageSelectedState) {
                          currentLanguage = state.language;
                        } else if (state is LanguageChangedState)
                          RestartWidget.of(context).restartApp();
                        else if (state is SameLanguageSelectedState)
                          Navigator.of(context).pop();
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
                        else if (state is RemoteClientErrorState)
                          GlobalPurposeFunctions.showToast(
                            AppLocalizations.of(context).data_error,
                            context,
                          );
                      },
                      child: BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                          return state is LoadingState
                              ? LoadingBloc()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: FlatButton(
                                  onPressed: () {
                                    BlocProvider.of<LanguageBloc>(context)
                                        .add(LanguageChangedEvent(language: 'en-US'));
                                  },
                                  shape: GlobalPurposeFunctions.buildButtonBorder(),
                                  color: currentLanguage == "en-US"
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 2,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .english,
                                          textAlign: TextAlign.center,
                                          style: mediumMontserrat(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  50),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  "En",
                                                  style: mediumMontserrat(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                )),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: FlatButton(
                                  onPressed: () {
                                    BlocProvider.of<LanguageBloc>(context)
                                        .add(LanguageChangedEvent(language: 'ar-SY'));
                                  },
                                  shape: GlobalPurposeFunctions.buildButtonBorder(),
                                  color: currentLanguage == "ar-SY"
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .arabic,
                                          textAlign: TextAlign.center,
                                          style: mediumMontserrat(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(50),
                                          ),
                                          child: Center(
                                              child: Text(
                                                "ع",
                                                style: boldMontserrat(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 16),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
