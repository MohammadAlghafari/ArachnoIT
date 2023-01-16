import 'package:arachnoit/application/profile_follow_list/profile_follow_list_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/response/profile_follow_list_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/recreate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileFollowListInfoScreen extends StatefulWidget {
  final String profileTypeId;

  const ProfileFollowListInfoScreen({
    @required this.profileTypeId,
  }) : super();

  @override
  _ProfileFollowListInfoState createState() => _ProfileFollowListInfoState();
}

class _ProfileFollowListInfoState extends State<ProfileFollowListInfoScreen> {
  ProfileFollowListBloc profileFollowListBloc;

  @override
  void initState() {
    super.initState();
    profileFollowListBloc = serviceLocator<ProfileFollowListBloc>();
    profileFollowListBloc.add(
      GetProfileFollowListEvent(
        healthcareProviderId: widget.profileTypeId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(title: "Follow List", actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings,
          ),
        )
      ]),
      body: BlocProvider<ProfileFollowListBloc>(
        create: (context) => profileFollowListBloc,
        child: BlocBuilder<ProfileFollowListBloc, ProfileFollowListState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return LoadingBloc();
            } else if (state is RemoteServerErrorState) {
              return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.serverError,
                  function: () {
                    profileFollowListBloc.add(GetProfileFollowListEvent(
                      healthcareProviderId:
                      GlobalPurposeFunctions
                          .getUserObject()
                          .userId,
                    ));
                  });
            } else if (state is RemoteClientErrorState) {
              return BlocError(
                context: context,
                blocErrorState: BlocErrorState.userError,
                function: () {
                  profileFollowListBloc.add(GetProfileFollowListEvent(
                    healthcareProviderId:
                    widget.profileTypeId,
                  ));
                },
              );
            } else if (state is SuccessGetProfileFollowListState) {
              final followResponse = state.profileFollowListResponse;
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxHeight: 150.0),
                      child: Material(
                        color: Colors.white,
                        child: TabBar(
                          labelColor: Theme
                              .of(context)
                              .accentColor,
                          indicatorColor: Theme
                              .of(context)
                              .accentColor,
                          labelStyle: boldCircular(
                            color: Theme
                                .of(context)
                                .accentColor,
                            fontSize: 14,
                          ),
                          tabs: [
                            Tab(
                              text: AppLocalizations
                                  .of(context)
                                  .following,
                            ),
                            Tab(
                              text: AppLocalizations
                                  .of(context)
                                  .followers,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: TabBarView(children: [
                          RecreateWidget(
                            shouldRecreate: false,
                            child: _buildFollowingItem(followResponse),
                          ),
                          RecreateWidget(
                            shouldRecreate: false,
                            child: _buildFollowersItem(followResponse),
                          ),
                        ]))
                  ],
                ),
              );
            } else {
              return Container(
                color: Colors.red,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildFollowingItem(
      ProfileFollowListResponse profileFollowListResponse) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 7.0),
      itemBuilder: (context, index) {
        final following = profileFollowListResponse.following[index];
        return Container(
          height: 85.0,
          child: ListTile(
            tileColor: Colors.grey[200],
            leading: ChachedNetwrokImageView(
              width: 60,
              height: 60,
              imageUrl: following.photo,
              isCircle: true,
              showFullImageWhenClick: false,
            ),
            trailing: FlatButton(
              child: Text(
                following.isFollowing ?"UnFollow" : "Follow",
                style: regularMontserrat(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                following.isFollowing = !following.isFollowing;
                profileFollowListBloc.add(
                  GetProfileFollowListEvent(
                    healthcareProviderId:
                    GlobalPurposeFunctions
                        .getUserObject()
                        .userId,
                  ),
                );
              },
              shape: GlobalPurposeFunctions.buildButtonBorder(),
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                following.fullName,
                style: semiBoldMontserrat(
                  color: Theme
                      .of(context)
                      .accentColor,
                  fontSize: 13,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  following.specification,
                  style: regularMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 10,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  following.subSpecification,
                  style: regularMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: profileFollowListResponse.following.length,
    );
  }

  Widget _buildFollowersItem(
      ProfileFollowListResponse profileFollowListResponse) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 7.0),
      itemBuilder: (context, index) {
        final followers = profileFollowListResponse.followers[index];
        return Container(
          height: 85.0,
          child: ListTile(
            tileColor: Colors.grey[200],
            leading: ChachedNetwrokImageView(
              width: 60,
              height: 60,
              imageUrl: followers.photo,
              isCircle: true,
              showFullImageWhenClick: false,
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                followers.fullName,
                style: semiBoldMontserrat(
                  color: Theme
                      .of(context)
                      .accentColor,
                  fontSize: 13,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  followers.specification,
                  style: regularMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 10,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  followers.subSpecification,
                  style: regularMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: profileFollowListResponse.followers.length,
    );
  }
}
