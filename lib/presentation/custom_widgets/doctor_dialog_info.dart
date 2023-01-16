import 'package:arachnoit/application/profile_actions_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/profile_provider/collapsing_tab_provider/collapsing_tab_provider.dart';
import 'package:arachnoit/presentation/screens/profile_provider/profile_provider/profile_provider_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorDialogInfo extends StatelessWidget {
  final BriefProfileResponse info;
  ProfileActionsBloc profileActionsBloc = serviceLocator<ProfileActionsBloc>();
  DoctorDialogInfo({this.info});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(19)),
            child: Container(
              color: Theme.of(context).accentColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: _header(context)),
                    flex: 2,
                  ),
                  (GlobalPurposeFunctions.isProfileOwner(info.id))
                      ? Container()
                      : followingButton(context),
                  Flexible(
                    flex: 6,
                    child: Container(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 12),
                                bodyData(context),
                                SizedBox(height: 12),
                                mobileAndEmail(context),
                                SizedBox(height: 12),
                                viewMoreButton(context),
                                SizedBox(height: 12),
                              ],
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget viewMoreButton(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ProfileProviderScreen(userId: info.id)))
            .then((value) {
          Navigator.pop(context);
        });
      },
      child: Text(
        AppLocalizations.of(context).show_more,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }

  Widget bodyData(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _follwersNumber(context, info.followingCount,
                      AppLocalizations.of(context).following),
                  _follwersNumber(context, info.followersCount,
                      AppLocalizations.of(context).followers)
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _follwersNumber(context, info.questionsCount,
                      AppLocalizations.of(context).questionAndAnswer),
                  _follwersNumber(context, info.answersCount,
                      AppLocalizations.of(context).answers),
                  _follwersNumber(context, info.blogsCount,
                      AppLocalizations.of(context).blogs)
                ],
              ),
            ),
            SizedBox(height: 10),
            (info.summary == "" || info.summary == "null")
                ? Flexible(
                    child: Text(
                    "${info.summary}",
                    textAlign: TextAlign.center,
                  ))
                : Container()
          ],
        ),
      ),
    );
  }

  Widget mobileAndEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16, left: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.mobile_friendly,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 4),
              Text(
                  "${info.mobile.length != 0 ? info.mobile : AppLocalizations.of(context).no_mobile_number}"),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.email_outlined, color: Theme.of(context).accentColor),
              SizedBox(width: 4),
              Flexible(child: Text("${info.email}")),
            ],
          ),
        ],
      ),
    );
  }

  Widget followingButton(BuildContext context) {
    return BlocProvider<ProfileActionsBloc>(
      create: (context) => profileActionsBloc,
      child: BlocListener<ProfileActionsBloc, ProfileActionsState>(
        listener: (context, state) {
          if (state is ChangeFollowProfileSuccess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            GlobalPurposeFunctions.showToast(state.messageStatus, context);
            info.isFollowingHcp = !info.isFollowingHcp;
          } else if (state is LoadingProfileActionState) {
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          }
        },
        child: BlocBuilder<ProfileActionsBloc, ProfileActionsState>(
          builder: (context, state) {
            return Transform.translate(
              offset: Offset(-5, 10),
              child: Container(
                color: Theme.of(context).accentColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: MaterialButton(
                          onPressed: () {
                            if (info.isFollowingHcp) {
                              showDialog(
                                  context: context,
                                  builder: (context) => UnFollowDialog(
                                        profilePhotoUrl: info.photo,
                                        userName: info.fullName,
                                      )).then((value) {
                                if (value) {
                                  profileActionsBloc.add(ChangeFollowProfile(
                                    healthCareProviderId: info.id,
                                    followStatus: !info.isFollowingHcp,
                                    context: context,
                                  ));
                                } else {
                                  GlobalPurposeFunctions
                                      .showOrHideProgressDialog(context, false);
                                }
                              });
                            } else {
                              profileActionsBloc.add(ChangeFollowProfile(
                                healthCareProviderId: info.id,
                                followStatus: !info.isFollowingHcp,
                                context: context,
                              ));
                            }
                          },
                          elevation: 0,
                          minWidth: 100,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 4),
                                Text(info.isFollowingHcp
                                    ? AppLocalizations.of(context).unFollow
                                    : AppLocalizations.of(context).following)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _follwersNumber(BuildContext context, int count, String description) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Icon(Icons.person, size: 38)),
          SizedBox(height: 6),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Container(
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black),
                child: Text(
                  "$count",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          Flexible(
            child: Text(description,
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ChachedNetwrokImageView(
                height: 70,
                width: 70,
                isCircle: true,
                imageUrl: info?.photo?.substring(1) ?? "",
              ),
            ),
          ),
          SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(info?.inTouchPointName ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
                Flexible(
                  child: Text(info?.specification ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                Flexible(
                  child: Text(info?.subSpecification ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
