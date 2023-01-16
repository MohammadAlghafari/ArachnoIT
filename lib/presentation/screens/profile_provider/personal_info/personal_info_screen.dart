import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/presentation/screens/profile_provider/edit_profile/edit_contact_info.dart';
import 'package:arachnoit/presentation/screens/profile_provider/edit_profile/edit_social_info.dart';
import 'package:arachnoit/presentation/screens/profile_provider/profile_follow_list_info/profile_follow_list_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoTab extends StatefulWidget {
  final ProfileInfoResponse profileInfoResponse;
  final ScrollController scrollController;
  final ProfileProviderBloc profileProviderBloc;

  static const routeName = '/Media_Tab_Profile';

  const PersonalInfoTab({
    @required this.scrollController,
    @required this.profileInfoResponse,
    @required this.profileProviderBloc,
  });

  @override
  _CollapsingTabState createState() => new _CollapsingTabState();
}

class _CollapsingTabState extends State<PersonalInfoTab>
    with AutomaticKeepAliveClientMixin {
  HealthCareProviderProfileDto userInfo = HealthCareProviderProfileDto();
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {});
    });
    userInfo = widget.profileInfoResponse.healthcareProviderProfileDto;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0XFFF7F7F7),
      body: Container(
        padding: EdgeInsets.only(right: 10, left: 10, top: 20),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            contactInfo(),
            SizedBox(height: 10),
            socialMedia(myProfileResponse: widget.profileInfoResponse),
            SizedBox(height: 10),
            // location()
          ],
        ),
      ),
    );
  }

  Widget contactInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 40,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_pin_rounded,
                    color: Color(0XFFF65535),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).contact_information,
                    style: TextStyle(color: Color(0XFFF65535), fontSize: 18),
                  )
                ],
              ),
              Spacer(),
              (GlobalPurposeFunctions.isProfileOwner(userInfo.id))
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditContactInfoScreen(
                                  info: userInfo,
                                  bloc: widget.profileProviderBloc,
                              profileInfoResponse:
                              widget.profileInfoResponse,
                                )));
                      },
                    )
                  : Container()
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              margin: EdgeInsets.only(left: 35, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).country,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      SizedBox(height: 7),
                      Text(
                        userInfo?.country ?? "",
                        style:
                        TextStyle(color: Color(0XFF909090), fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).city,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      SizedBox(height: 7),
                      Text(
                        userInfo?.city ?? "",
                        style:
                        TextStyle(color: Color(0XFF909090), fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Text(
                    AppLocalizations.of(context).address,
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userInfo?.address ??
                        AppLocalizations
                            .of(context)
                            .no_address,
                    style: TextStyle(color: Color(0XFF909090), fontSize: 17),
                  ),
                ],
              )),
          Divider(
            thickness: 2,
            color: Color(0XFFE5E5E5),
          ),
          Container(
            margin: EdgeInsets.only(left: 35, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).email,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(width: 40),
                    Container(
                      child: Text(
                        userInfo?.email ?? AppLocalizations.of(context).email,
                        style:
                        TextStyle(color: Color(0XFF909090), fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).mobile,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(width: 30),
                    Container(
                      child: Text(
                        userInfo?.mobile ??
                            AppLocalizations
                                .of(context)
                                .no_mobile_number,
                        style:
                        TextStyle(color: Color(0XFF909090), fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).land_line + ":",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(width: 10),
                    Text(
                      userInfo?.workPhone ??
                          AppLocalizations
                              .of(context)
                              .no_land_line,
                      style: TextStyle(color: Color(0XFF909090), fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget socialMedia({ProfileInfoResponse myProfileResponse}) {
    int instagramLength = userInfo?.instagram?.trim()?.length ?? 0;
    int facebookLength = userInfo?.facebook?.trim()?.length ?? 0;
    int telegramLength = userInfo?.telegram?.trim()?.length ?? 0;
    int youtubeLength = userInfo?.youtube?.trim()?.length ?? 0;
    int twitterLength = userInfo?.twiter?.trim()?.length ?? 0;
    int whatsappLength = userInfo?.whatsApp?.trim()?.length ?? 0;
    int sumAllSocialMedialValue = instagramLength +
        facebookLength +
        telegramLength +
        youtubeLength +
        twitterLength +
        whatsappLength;
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 40,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0XFFF65535),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).social_media,
                    style: TextStyle(color: Color(0XFFF65535), fontSize: 18),
                  )
                ],
              ),
              ((GlobalPurposeFunctions.isProfileOwner(userInfo.id)))
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditSocialInfoScreen(
                              bloc: widget.profileProviderBloc,
                              info: userInfo,
                              profileInfoResponse: widget.profileInfoResponse,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          (sumAllSocialMedialValue == 0)
              ?IconButton(
            icon: Icon(Icons.follow_the_signs_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return ProfileFollowListInfoScreen(
                      profileTypeId: myProfileResponse
                          .healthcareProviderProfileDto.id,
                    );
                  }));
            },
          )
          // Text(AppLocalizations.of(context)
          //     .there_is_not_any_social_information_to_show)
              : Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(
                children: [
                  if (instagramLength > 0) Spacer(),
                  if (instagramLength > 0)
                    InkWell(
                      onTap: () async {
                        await launch(userInfo.instagram);
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/instagram.svg',
                          width: 30,
                          height: 30,
                          semanticsLabel: 'Acme Logo',
                        ),
                      ),
                    ),
                  if (telegramLength > 0) Spacer(),
                  if (telegramLength > 0)
                    InkWell(
                      onTap: () async {
                        await launch("https://t.me/${userInfo.telegram}");
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/telegram.svg',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  if (whatsappLength > 0) Spacer(),
                  if (whatsappLength > 0)
                    InkWell(
                      onTap: () async {
                        await launch(
                            "https://wa.me/${userInfo.whatsApp}?text=Hello");
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/whatsapp.svg',
                          width: 30,
                          height: 30,
                          semanticsLabel: 'Acme Logo',
                        ),
                      ),
                    ),
                  if (facebookLength > 0) Spacer(),
                  if (facebookLength > 0)
                    InkWell(
                      onTap: () async {
                        await launch(userInfo.facebook);
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/facebook.svg',
                          width: 30,
                          height: 30,
                          semanticsLabel: 'Acme Logo',
                        ),
                      ),
                    ),
                  if (youtubeLength > 0) Spacer(),
                  if (youtubeLength > 0)
                    InkWell(
                      onTap: () async {
                        await launch(userInfo.youtube);
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/youtube.svg',
                          width: 30,
                          height: 30,
                          semanticsLabel: 'Acme Logo',
                        ),
                      ),
                    ),
                  if (twitterLength > 0) Spacer(),
                  if (twitterLength > 0)
                    InkWell(
                      onTap: () async {
                        await launch(
                            "https://twitter.com/" + userInfo.twiter);
                      },
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/images/twitter.svg',
                          width: 30,
                          height: 30,
                          semanticsLabel: 'Acme Logo',
                        ),
                      ),
                    ),
                  Spacer(),
                ],
              )),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget location() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 40,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0XFFF65535),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).location,
                      style: TextStyle(color: Color(0XFFF65535), fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).go,
                      style: TextStyle(color: Color(0XFFF65535), fontSize: 18),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0XFFF65535),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color(0XFFC4C4C4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )),
            height: 300,
          ),
        ],
      ),
    );
  }
}
