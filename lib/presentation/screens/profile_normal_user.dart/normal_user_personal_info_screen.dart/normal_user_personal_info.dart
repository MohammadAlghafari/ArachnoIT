import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/edit/edit_normal_user_contact_info.dart';
import 'package:arachnoit/presentation/screens/profile_provider/edit_profile/edit_contact_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NormalUserPersonalInfo extends StatefulWidget {
  final ProfileInfoResponse profileInfoResponse;
  final ScrollController scrollController;
  final ProfileProviderBloc profileProviderBloc;

  static const routeName = '/Media_Tab_Profile';

  const NormalUserPersonalInfo({
    @required this.scrollController,
    @required this.profileInfoResponse,
    @required this.profileProviderBloc,
  });

  @override
  _NormalUserPersonalInfo createState() => new _NormalUserPersonalInfo();
}

class _NormalUserPersonalInfo extends State<NormalUserPersonalInfo>
    with AutomaticKeepAliveClientMixin {
  NormalUserProfileDto userInfo = NormalUserProfileDto();
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {});
    });
    userInfo = widget.profileInfoResponse.normalUserProfileDto;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0XFFF7F7F7),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right: 10, left: 10, top: 20),
          child: Column(
            children: [contactInfo(), SizedBox(height: 10)],
          ),
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
                    style: mediumMontserrat(
                        color: Color(0XFFF65535), fontSize: 18),
                  )
                ],
              ),
              Spacer(),
              GlobalPurposeFunctions.isProfileOwner(
                      widget.profileInfoResponse.normalUserProfileDto.id)
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNormalUserContactInfo(
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
                        style:
                        mediumMontserrat(color: Colors.black, fontSize: 17),
                      ),
                      SizedBox(height: 7),
                      Text(
                        userInfo?.country ?? "",
                        style: mediumMontserrat(
                            color: Color(0XFF909090), fontSize: 17),
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
                        style:
                        mediumMontserrat(color: Colors.black, fontSize: 17),
                      ),
                      SizedBox(height: 7),
                      Text(
                        userInfo?.city ?? "",
                        style: mediumMontserrat(
                            color: Color(0XFF909090), fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Text(
                    AppLocalizations.of(context).address,
                    style: mediumMontserrat(color: Colors.black, fontSize: 17),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userInfo?.address ??
                        AppLocalizations
                            .of(context)
                            .no_address,
                    style: mediumMontserrat(
                        color: Color(0XFF909090), fontSize: 17),
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
                      style:
                      mediumMontserrat(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(width: 40),
                    Container(
                      child: Text(
                        userInfo?.email ?? "",
                        style: mediumMontserrat(
                            color: Color(0XFF909090), fontSize: 15),
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
                      style:
                      mediumMontserrat(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(width: 30),
                    Container(
                      child: Text(
                        userInfo?.mobile ?? "",
                        style: mediumMontserrat(
                            color: Color(0XFF909090), fontSize: 15),
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
                      AppLocalizations.of(context).land_line,
                      style:
                      mediumMontserrat(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(width: 10),
                    Text(
                      userInfo?.workPhone ?? "",
                      style: mediumMontserrat(
                          color: Color(0XFF909090), fontSize: 15),
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
}
