import 'package:arachnoit/application/in_app_terms_and_condition/terms_and_condition_bloc.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../injections.dart';

class InAppTermsAndConditionsScreen extends StatefulWidget {
  final bool isTermsRequest;
  const InAppTermsAndConditionsScreen({@required this.isTermsRequest}) : super();

  @override
  _InAppTermsAndConditionsScreenState createState() => _InAppTermsAndConditionsScreenState();
}

class _InAppTermsAndConditionsScreenState extends State<InAppTermsAndConditionsScreen> {
  TermsAndConditionBloc termsAndConditionsBloc;
  bool successBefore = false;

  @override
  void initState() {
    super.initState();
    termsAndConditionsBloc = serviceLocator<TermsAndConditionBloc>();
    termsAndConditionsBloc
      ..add(GetTermsAndConditionEvent(termsOrPolicy: widget.isTermsRequest ? 0 : 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
          title: widget.isTermsRequest
              ? AppLocalizations.of(context).terms
              : AppLocalizations.of(context).privacy_policy),
      body: BlocProvider<TermsAndConditionBloc>(
        create: (context) => termsAndConditionsBloc,
        child: BlocListener<TermsAndConditionBloc, TermsAndConditionState>(
          listener: (context, state) {},
          child: BlocBuilder<TermsAndConditionBloc, TermsAndConditionState>(
            builder: (context, state) {
              switch (state.status) {
                case TermsProviderStatus.loading:
                  return LoadingBloc();
                  break;
                case TermsProviderStatus.failure:
                  if (successBefore) {
                    return showInfo(state, termsAndConditionsBloc, context);
                  } else
                    return Material(
                      child: BlocError(
                        context: context,
                        blocErrorState: BlocErrorState.userError,
                        function: () {
                          termsAndConditionsBloc
                            ..add(
                              GetTermsAndConditionEvent(
                                  termsOrPolicy: widget.isTermsRequest ? 0 : 1),
                            );
                        },
                      ),
                    );
                  break;
                case TermsProviderStatus.success:
                  successBefore = true;
                  return showInfo(state, termsAndConditionsBloc, context);
                default:
                  return LoadingBloc();
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget showInfo(TermsAndConditionState state, TermsAndConditionBloc termsAndConditionBloc,
    BuildContext context) {
  if (state.terms.isEmpty) {
    return const Center(child: Text('no Terms to show'));
  }
  return Container(
    child: ListView(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Html(
                data: state.terms,
                style: {
                  'h1': Style(
                    direction: Localizations.localeOf(context).toString() == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                },
                onLinkTap: (
                  String url,
                  RenderContext context,
                  Map<String, String> attributes,
                  element,
                ) {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
