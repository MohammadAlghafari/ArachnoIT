import 'dart:convert';
import 'package:arachnoit/application/profile_actions_bloc.dart';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/common/account_type_id.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/presentation/custom_widgets/sliver_delegate.dart';
import 'package:arachnoit/presentation/screens/profile_provider/profile_follow_list_info/profile_follow_list_info.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
as ex;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/profile_provider/edit_profile/edit_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollapsingTabProvider extends StatefulWidget {
  static const routeName = '/Collapsing_Tab';
  final String userId;
  final ProfileInfoResponse profileInfoResponse;
  final List<Widget> tabs;
  final List<Widget> tabsBody;
  final ProfileProviderBloc profileProviderBloc;
  final ScrollController scrollController;

  CollapsingTabProvider({
    @required this.userId,
    @required this.profileInfoResponse,
    @required this.tabs,
    @required this.tabsBody,
    @required this.scrollController,
    @required this.profileProviderBloc,
  });

  @override
  _CollapsingTabProvider createState() => new _CollapsingTabProvider();
}

class _CollapsingTabProvider extends State<CollapsingTabProvider>
    with TickerProviderStateMixin {
  TabController primaryTC;
  double size = 40.0;
  double scale = 0.0;
  double constScale = 0.7142857142857143;
  ValueNotifier<double> newScale = ValueNotifier(1.5);
  HealthCareProviderProfileDto provider;
  ProfileActionsBloc profileActionsBloc;
  String summery = "";
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
    if (index != primaryTC.index) {
      index = primaryTC.index;
    }
  }

  void updateValue() {
    if (widget.scrollController.hasClients) {
      scale = widget.scrollController.offset / 300;
      scale = scale * 2;
      if (scale >= 0.6) {
        newScale.value = 0.9;
      } else {
        newScale.value = 1.5 - (scale * constScale);
      }
    } else {
      newScale.value = 1.5;
    }
  }

  @override
  void initState() {
    super.initState();
    profileActionsBloc = serviceLocator<ProfileActionsBloc>();
    primaryTC = TabController(length: 3, vsync: this);
    primaryTC.addListener(tabControlerListener);
    provider = widget.profileInfoResponse.healthcareProviderProfileDto;
    widget.scrollController.addListener(() => updateValue());
  }

  double sizeContainerTitle;
  final List<Color> colors = Colors.primaries;
  TextOverflow titleOverFlow = TextOverflow.visible;

  @override
  Widget build(BuildContext context) {
    summery = provider?.summary ?? "";
    GlobalPurposeFunctions.changeStatusColor(Color(0XFFDD4D31), true);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(provider.profilePhotoUrl);
      },
      child: SafeArea(
        child: ex.NestedScrollView(
            controller: widget.scrollController,
            innerScrollPositionKeyBuilder: () {
              var index = '';
              if (primaryTC.index == 0) {
                index = 'Info';
              } else if (primaryTC.index == 1) {
                index = 'Qualifications';
              } else {
                index = 'Posts';
              }
              return Key(index);
            },
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                // (GlobalPurposeFunctions.isProfileOwner(widget.userId)) ? flexibleSpaceWidget() : Container(),
                (true) ? flexibleSpaceWidget() : Container(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (!GlobalPurposeFunctions.isProfileOwner(
                                provider.id))
                                ? BlocProvider<ProfileActionsBloc>(
                                    create: (context) => profileActionsBloc,
                              child: BlocListener<ProfileActionsBloc,
                                  ProfileActionsState>(
                                      listener: (context, state) {
                                        if (state is LoadingProfileActionState)
                                          GlobalPurposeFunctions
                                              .showOrHideProgressDialog(
                                              context, true);
                                        else if (state
                                        is ChangeFavoriteProfileSuccess) {
                                          GlobalPurposeFunctions
                                              .showOrHideProgressDialog(
                                              context, false);
                                          GlobalPurposeFunctions.showToast(
                                              state.messageStatus, context);
                                          provider.addedToFavoriteList =
                                              !provider.addedToFavoriteList;
                                        } else if (state
                                        is ChangeFollowProfileSuccess) {
                                          GlobalPurposeFunctions
                                              .showOrHideProgressDialog(
                                              context, false);
                                          GlobalPurposeFunctions.showToast(
                                              state.messageStatus, context);
                                          provider.isFollowingHcp =
                                          !provider.isFollowingHcp;
                                        } else if (state
                                        is RemoteValidationErrorProfileState) {
                                          GlobalPurposeFunctions
                                              .showOrHideProgressDialog(
                                              context, false);
                                          GlobalPurposeFunctions.showToast(
                                              state
                                                  .remoteValidationErrorMessage,
                                              context);
                                        } else if (state
                                        is RemoteServerErrorProfileState) {
                                          GlobalPurposeFunctions
                                              .showOrHideProgressDialog(
                                              context, false);
                                          GlobalPurposeFunctions.showToast(
                                              state.remoteServerErrorMessage,
                                              context);
                                        } else if (state
                                        is RemoteClientErrorProfileState) {
                                          GlobalPurposeFunctions
                                              .showOrHideProgressDialog(
                                              context, false);
                                          GlobalPurposeFunctions.showToast(
                                              state.remoteClientErrorMessage,
                                              context);
                                        }
                                      },
                                child: BlocBuilder<ProfileActionsBloc,
                                    ProfileActionsState>(
                                        builder: (context, state) {
                                          return Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              ClipOval(
                                                child: Material(
                                                  color: Color(
                                                      0xFF19444D),
                                                  // button color
                                                  child: InkWell(
                                                    splashColor: Colors
                                                        .transparent,
                                                    // inkwell color
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: Icon(
                                                        provider.addedToFavoriteList
                                                            ? Icons.star
                                                            : Icons
                                                            .star_outline,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (provider
                                                          .addedToFavoriteList)
                                                        showDialog(
                                                            context: context,
                                                            builder: (
                                                                context) =>
                                                                UnFavoriteDialog(
                                                                  profilePhotoUrl:
                                                                  provider
                                                                      .profilePhotoUrl,
                                                                  userName: provider
                                                                      .fullName,
                                                                )).then(
                                                                (value) =>
                                                            {
                                                              (value)
                                                                  ?profileActionsBloc
                                                                  .add(
                                                                  ChangeFavoriteProfile(
                                                                          favoritePersonId: widget
                                                                              .profileInfoResponse
                                                                              .healthcareProviderProfileDto
                                                                              .id,
                                                                          favoriteStatus: !provider
                                                                              .addedToFavoriteList))
                                                                  : print(
                                                                  'cancelled')
                                                            });
                                                      else
                                                        profileActionsBloc.add(
                                                            ChangeFavoriteProfile(
                                                                favoritePersonId: widget
                                                                    .profileInfoResponse
                                                                    .healthcareProviderProfileDto
                                                                    .id,
                                                                favoriteStatus:
                                                                !provider
                                                                    .addedToFavoriteList));
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              RaisedButton(
                                                onPressed: () {},
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.message,
                                                      size: 17,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      'message',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20)),
                                                color: Color(0xFF19444D),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              followButton()
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  top: summery.length > 0 ? 10 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    summery,
                                    style: TextStyle(color: Color(0XFF4B4B4B)),
                                  ),
                                  (summery.length != 0)
                                      ?SizedBox(height: 15)
                                      : Container(),
                                  if (summery.length != 0)
                                    Divider(
                                      thickness: 2,
                                      color: Color(0XFFE5E5E5),
                                    ),
                                  SizedBox(height: 15),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return ProfileFollowListInfoScreen();
                                                    }));
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                  AppLocalizations
                                                      .of(context)
                                                      .followers,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black
                                                          .withOpacity(0.5))),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                  provider?.followersCount
                                                      .toString() ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: 5,
                                          color: Color(0XFFE5E5E5),
                                          thickness: 2,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                AppLocalizations
                                                    .of(context)
                                                    .services,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                                "${provider?.services?.length ??
                                                    ""}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                        VerticalDivider(
                                          width: 5,
                                          color: Color(0XFFE5E5E5),
                                          thickness: 2,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                AppLocalizations
                                                    .of(context)
                                                    .questionAndAnswer,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text('${provider.questionsCount}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                        VerticalDivider(
                                          width: 5,
                                          color: Color(0XFFE5E5E5),
                                          thickness: 2,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                AppLocalizations
                                                    .of(context)
                                                    .groups,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                                '${provider.publicGroupsCount}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
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
              ex.NestedScrollViewInnerScrollPositionKeyWidget(
                  const Key('Qualifications'), widget.tabsBody[1]),
              ex.NestedScrollViewInnerScrollPositionKeyWidget(
                  const Key('Posts'), widget.tabsBody[2]),
            ])),
      ),
    );
  }

  Widget followButton() {
    return RaisedButton(
      onPressed: () {
        if (provider.isFollowingHcp) {
          showDialog(
              context: context,
              builder: (context) => UnFollowDialog(
                    profilePhotoUrl: provider.profilePhotoUrl,
                    userName: provider.fullName,
                  )).then((value) {
            if (value) {
              profileActionsBloc.add(ChangeFollowProfile(
                healthCareProviderId: provider.id,
                followStatus: !provider.isFollowingHcp,
                context: context,
              ));
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          });
        } else {
          profileActionsBloc.add(ChangeFollowProfile(
            healthCareProviderId: provider.id,
            followStatus: !provider.isFollowingHcp,
            context: context,
          ));
        }
        // if (provider.isFollowingHcp) {
        //   showDialog(
        //       context: context,
        //       builder: (context) =>
        //           UnFollowDialog(
        //             profilePhotoUrl:
        //                 provider
        //                     .profilePhotoUrl,
        //             userName: provider
        //                 .fullName,
        //           )).then((value) => {
        //         (value)
        //             ? profileActionsBloc.add(ChangeFollowProfile(
        //                 healthCareProviderId:
        //                     provider
        //                         .id,
        //                 followStatus:
        //                     !provider
        //                         .isFollowingHcp,
        //                 context:
        //                     context))
        //             : print('cancel')
        //       });
        // } else {
        //   profileActionsBloc.add(
        //       ChangeFollowProfile(
        //           healthCareProviderId:
        //               provider.id,
        //           followStatus: !provider
        //               .isFollowingHcp,
        //           context: context));
        // }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          Text((!provider.isFollowingHcp) ? 'follow' : 'following',
              style: TextStyle(color: Colors.white))
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: (!provider.isFollowingHcp) ? Color(0xFF19444D) : Color(0XFFF65535),
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
          //
          children: [
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () {
                GlobalPurposeFunctions.share(context,
                    "${Urls.USER_SHARE_BLOGS}${widget.profileInfoResponse.healthcareProviderProfileDto.id}");
              },
            ),
            (GlobalPurposeFunctions.isProfileOwner(
                    widget.profileInfoResponse.healthcareProviderProfileDto.id))
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
                              builder: (context) => EditBasicInfo(
                                    userType: userInfo.userType,
                                    healthcareProviderProfileDto: provider,
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
          title: ValueListenableBuilder(
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
                              provider.fullName.length > 15
                                  ? '${provider.fullName.substring(0, 15)}..'
                                  : '${provider.fullName}',
                              softWrap: true,
                              style: TextStyle(fontSize: 15),
                              overflow: titleOverFlow,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              provider.inTouchPointName.length > 20
                                  ? '@${provider.inTouchPointName.substring(0, 19)}....'
                                  : '@${provider.inTouchPointName}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
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
          imageUrl: provider.profilePhotoUrl,
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

class UnFollowDialog extends StatelessWidget {
  final String profilePhotoUrl;
  final String userName;

  const UnFollowDialog(
      {@required this.profilePhotoUrl, @required this.userName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            Flexible(
              child: Card(
                child: ChachedNetwrokImageView(
                  imageUrl: profilePhotoUrl,
                  isCircle: true,
                  width: 50,
                  height: 50,
                  autoWidthAndHeigh: false,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              AppLocalizations.of(context).unFollow,
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              userName,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(00.0),
                            side: BorderSide(width: 0.5, color: Colors.grey)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).cancel,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(00.0),
                            side: BorderSide(width: 0.5, color: Colors.grey)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).unFollow,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UnFavoriteDialog extends StatelessWidget {
  final String profilePhotoUrl;
  final String userName;

  const UnFavoriteDialog(
      {@required this.profilePhotoUrl, @required this.userName});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            Flexible(
              child: Card(
                child: ChachedNetwrokImageView(
                  imageUrl: profilePhotoUrl,
                  isCircle: true,
                  width: 50,
                  height: 50,
                  autoWidthAndHeigh: false,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              AppLocalizations.of(context).unFavorite,
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              userName,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).unFavoriteList +
                  userName +
                  AppLocalizations.of(context).favoriteList,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(00.0),
                            side: BorderSide(width: 0.5, color: Colors.grey)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).cancel,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(00.0),
                            side: BorderSide(width: 0.5, color: Colors.grey)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).submit,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
