import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/profile_normal_user.dart/profile_normal_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDialogInfo extends StatelessWidget {
  final BriefProfileResponse info;
  UserDialogInfo({this.info});
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
                  ),
                  Container(height: 30),
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

  //                followingButton(context)
//
  Widget viewMoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => ProfileNormalUser(userId: info.id)))
              .then((value) {
            Navigator.pop(context);
          });
        },
        child: Text(
          AppLocalizations.of(context).show_more,
          textAlign: TextAlign.center,
        ),
      )),
    );
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
                  _follwersNumber(context, info.followingCount, AppLocalizations.of(context).following),
                  _follwersNumber(context, info.followersCount, AppLocalizations.of(context).followers)
                ],
              ),
            ),
            SizedBox(height: 10),
            (info.summary == "" || info.summary == "null")
                ? Flexible(
                    child: Text(
                    "${info?.summary ?? ""}",
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
              Text("${info.mobile}"),
            ],
          ),
          Row(
            children: [
              Icon(Icons.mobile_friendly, color: Theme.of(context).accentColor),
              SizedBox(width: 4),
              Text("${info.email}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget followingButton(BuildContext context) {
    return Transform.translate(
      offset: Offset(10, 10),
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
                  onPressed: () {},
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
                        Text(AppLocalizations.of(context).following)
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Text(info.fullName,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
