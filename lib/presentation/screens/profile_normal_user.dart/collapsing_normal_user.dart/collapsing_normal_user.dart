import 'dart:convert';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/presentation/custom_widgets/sliver_delegate.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/edit/edit_normal_user_basic_info.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
as ex;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollapsingNoramlUSer extends StatefulWidget {
  static const routeName = '/Collapsing_Tab';
  final String userId;
  final ProfileInfoResponse profileInfoResponse;
  final List<Widget> tabs;
  final List<Widget> tabsBody;
  final ProfileProviderBloc profileProviderBloc;
  final ScrollController scrollController;

  CollapsingNoramlUSer({
    @required this.userId,
    @required this.profileInfoResponse,
    @required this.tabs,
    @required this.tabsBody,
    @required this.scrollController,
    @required this.profileProviderBloc,
  });

  @override
  _CollapsingNoramlUSer createState() => new _CollapsingNoramlUSer();
}

class _CollapsingNoramlUSer extends State<CollapsingNoramlUSer>
    with TickerProviderStateMixin {
  TabController primaryTC;
  String summer;
  double size = 40.0;
  double scale = 0.0;
  double constScale = 0.7142857142857143;
  ValueNotifier<double> newScale = ValueNotifier(1.5);
  NormalUserProfileDto provider;

  void updateValue() {
    if (widget.scrollController.hasClients) {
      scale = widget.scrollController.offset / 300;

      scale = scale * 2;

      if (scale >= 0.6) {
        // sizeContainerTitle = MediaQuery.of(context).size.width * 0.5;
        newScale.value = 0.9;
      } else {
        // if (scale < 0.3)
        //   titleOverFlow = TextOverflow.visible;
        // else
        //   titleOverFlow = TextOverflow.ellipsis;
        // sizeContainerTitle = MediaQuery.of(context).size.width * 0.3;
        newScale.value = 1.5 - (scale * constScale);
      }
    } else {
      // titleOverFlow = TextOverflow.visible;
      newScale.value = 1.5;
    }
  }

  @override
  void dispose() {
    widget.scrollController.dispose();

    primaryTC.removeListener(tabControlerListener);
    primaryTC.dispose();
    super.dispose();
    GlobalPurposeFunctions.changeStatusColor(Colors.white, false);
  }

  int index;

  void tabControlerListener() {
//    if(primaryTC.index==1 || primaryTC.index==2){
//      scrollController.animateTo(scrollController.position.maxScrollExtent -100,
//          curve: Curves.linear, duration: Duration(milliseconds: 200));
//    }else {print('mpp');}

    if (index != primaryTC.index) {
      //your code
      index = primaryTC.index;
    }
  }

  @override
  void initState() {
    super.initState();

    primaryTC = TabController(length: 1, vsync: this);
    primaryTC.addListener(tabControlerListener);
    provider = widget.profileInfoResponse.normalUserProfileDto;
    summer = provider?.summary ?? "";
    widget.scrollController.addListener(() => updateValue());
  }

  double sizeContainerTitle;
  final List<Color> colors = Colors.primaries;

  @override
  Widget build(BuildContext context) {
    GlobalPurposeFunctions.changeStatusColor(Color(0XFFDD4D31), true);
    return SafeArea(
      child: ex.NestedScrollView(
          controller: widget.scrollController,
          innerScrollPositionKeyBuilder: () {
            var index = '';
            if (primaryTC.index == 0) return Key(index);
          },
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              flexibleSpaceWidget(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          top: summer.length > 0 ?10 : 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                            EdgeInsets.only(left: 15, right: 15, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (summer.length != 0)
                                  SizedBox(
                                    height: 10,
                                  ),
                                Text(
                                  provider?.summary ?? "",
                                  style: TextStyle(color: Color(0XFF4B4B4B)),
                                ),
                                (summer.length != 0)
                                    ? SizedBox(
                                        height: 15,
                                      )
                                    : Container(),
                                if (summer.length != 0)
                                  Divider(
                                    thickness: 2,
                                    color: Color(0XFFE5E5E5),
                                  ),
                                SizedBox(
                                  height: 15,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                                AppLocalizations
                                                    .of(context)
                                                    .following,
                                                style: regularMontserrat(
                                                    fontSize: 15,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                                provider.followingCount
                                                    .toString(),
                                                style: boldMontserrat(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        width: 5,
                                        color: Color(0XFFE5E5E5),
                                        thickness: 2,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                                AppLocalizations
                                                    .of(context)
                                                    .questions,
                                                style: regularMontserrat(
                                                    fontSize: 15,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                                '${provider?.questionsCount ??
                                                    0}',
                                                style: boldMontserrat(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                  TabBar(
                      controller: primaryTC,
                      labelColor: Color(0xFFF65636),
                      unselectedLabelColor: Colors.black26,
                      tabs: widget.tabs),
                ),
                pinned: true,
                key: Key('Posts'),
              ),
            ];
          },
          body: TabBarView(controller: primaryTC, children: [
            ex.NestedScrollViewInnerScrollPositionKeyWidget(
                const Key('Info'), widget.tabsBody[0]),
          ])),
    );
  }

  Widget flexibleSpaceWidget() {
    return SliverAppBar(
      expandedHeight: 150.0,
      pinned: true,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Theme.of(context).accentColor,
      actions: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.share),
              color: Colors.white,
              onPressed: () {
                GlobalPurposeFunctions.share(context,
                    "${Urls.USER_SHARE_BLOGS}${widget.profileInfoResponse.normalUserProfileDto.id}");
              },
            ),
            SizedBox(
              width: 10,
            ),
            GlobalPurposeFunctions.isProfileOwner(widget.userId)
                ? IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.white,
                    onPressed: () {
                      SharedPreferences _prefs =
                      serviceLocator<SharedPreferences>();
                      LoginResponse userInfo = LoginResponse.fromMap(
                          json.decode(_prefs.get(PrefsKeys.LOGIN_RESPONSE)));
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => EditNormalUserBasicInfo(
                                    userType: userInfo.userType,
                                    normalUserProfileDto: provider,
                                  )))
                          .then((value) {
                        if (value != null)
                          widget.profileProviderBloc
                              .add(GetProfileInfoEvent(userId: widget.userId));
                      });
                    },
                  )
                : Container(),
            SizedBox(
              width: 10,
            ),
          ],
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding:
          EdgeInsets.only(top: 1, bottom: 10, left: 50, right: 50),
          stretchModes: [StretchMode.blurBackground],
          title: ValueListenableBuilder<double>(
            valueListenable: newScale,
            builder: (context, value, _) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildActionsNew(context),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            provider?.firstName ??
                                "" + provider?.lastName ??
                                "",
                            style: semiBoldMontserrat(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            provider?.inTouchPointName ?? "",
                            style: semiBoldMontserrat(
                                fontSize: 12.0,
                                color: Colors.white.withOpacity(0.6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          background: Container(
            padding: EdgeInsets.only(top: 70, left: 15),
            color: Color(0xFFF65636),
          )),
      //   ],
    );
  }

  Widget _buildActionsNew(BuildContext context) {
    Widget profile = new GestureDetector(
      child: new Container(
        height: size,
        width: size,
        child: ChachedNetwrokImageView(
          imageUrl: provider?.profilePhotoUrl ?? "",
          isCircle: true,
        ),
      ),
    );

    return new Transform(
      transform: new Matrix4.identity()..scale(newScale.value, newScale.value),
      alignment: Alignment.bottomCenter,
      child: profile,
    );
  }
}
