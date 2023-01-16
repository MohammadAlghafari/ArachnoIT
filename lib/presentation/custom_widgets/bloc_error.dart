import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum BlocErrorState { serverError, timeLimite, userError, validationError, unkownError, noPosts }

// ignore: must_be_immutable
class BlocError extends StatelessWidget {
  Function function;
  String img;
  String errorTitle = "";
  IconData iconData;
  factory BlocError({
    @required BlocErrorState blocErrorState,
    @required Function function,
    @required BuildContext context,
    // ignore: avoid_init_to_null
    IconData iconData = null,
    String img,
    String errorTitle,
  }) {
    if (blocErrorState == BlocErrorState.serverError) {
      return BlocError.serverError(function, context, iconData, errorTitle);
    } else if (blocErrorState == BlocErrorState.timeLimite) {
      return BlocError.timeLimite(function, context, iconData, errorTitle);
    } else if (blocErrorState == BlocErrorState.validationError) {
      return BlocError.validationError(function, context, iconData, errorTitle);
    } else if (blocErrorState == BlocErrorState.userError) {
      return BlocError.userError(function, context, iconData, errorTitle);
    } else if (blocErrorState == BlocErrorState.noPosts) {
      return BlocError.noPosts(function, context, iconData, errorTitle);
    } else {
      return BlocError.unkownError(function, context, iconData, errorTitle);
    }
  }

  BlocError.noPosts(Function function, BuildContext context, IconData icon, String errorTitle) {
    this.function = function;
    this.img = "assets/images/no_files_found.svg";
    this.errorTitle = (errorTitle != null)
        ? errorTitle
        : AppLocalizations.of(context).there_is_not_yet;
    iconData = icon;
  }

  BlocError.userError(Function function, BuildContext context, IconData icon, String errorTitle) {
    this.function = function;
    this.img = "assets/images/network_error.svg";
    this.errorTitle = (errorTitle != null)
        ? errorTitle
        : AppLocalizations.of(context).check_your_internet_connection;
    this.iconData = icon;
  }

  BlocError.validationError(
      Function function, BuildContext context, IconData icon, String errorTitle) {
    this.function = function;
    this.img = "assets/images/try_again.svg";
    this.errorTitle = (errorTitle != null)
        ? errorTitle
        : AppLocalizations.of(context).check_your_internet_connection;
    this.iconData = icon;
  }

  BlocError.unkownError(Function function, BuildContext context, IconData icon, String errorTitle) {
    this.function = function;
    this.img = "assets/images/try_again.svg";
    this.errorTitle = (errorTitle != null)
        ? errorTitle
        : AppLocalizations.of(context).check_your_internet_connection;
    this.iconData = icon;
  }

  BlocError.serverError(Function function, BuildContext context, IconData icon, String errorTitle) {
    this.function = function;
    this.img = "assets/images/network_error.svg";
    this.errorTitle = (errorTitle != null)
        ? errorTitle
        : AppLocalizations.of(context).check_your_internet_connection;
    this.iconData = icon;
  }

  BlocError.timeLimite(Function function, BuildContext context, IconData icon, String errorTitle) {
    this.function = function;
    this.img = "assets/images/network_error.svg";
    this.errorTitle = (errorTitle != null)
        ? errorTitle
        : AppLocalizations.of(context).check_your_internet_connection;
    this.iconData = icon;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: InkWell(
          onTap: function,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (iconData == null)
                  ? SvgPicture.asset(img, color: Theme.of(context).accentColor)
                  : Icon(iconData),
              SizedBox(height: 12),
              Container(
                child: Center(
                  child: Text(errorTitle),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
