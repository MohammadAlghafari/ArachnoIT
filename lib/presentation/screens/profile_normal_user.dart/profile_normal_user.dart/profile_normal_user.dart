import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/collapsing_normal_user.dart/collapsing_normal_user.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/normal_user_personal_info_screen.dart/normal_user_personal_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileNormalUser extends StatefulWidget {
  final String userId;
  ProfileNormalUser({this.userId});
  @override
  State<StatefulWidget> createState() {
    return _ProfileNormalUser();
  }
}

class _ProfileNormalUser extends State<ProfileNormalUser>
    with AutomaticKeepAliveClientMixin {
  ProfileProviderBloc profileProviderBloc;
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    profileProviderBloc = serviceLocator<ProfileProviderBloc>();
    profileProviderBloc.add(GetProfileInfoEvent(userId: widget.userId));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: BlocProvider<ProfileProviderBloc>(
      create: (context) => profileProviderBloc,
      child: BlocBuilder<ProfileProviderBloc, ProfileProviderState>(
        builder: (context, state) {
          if (state is LoadingProviderInfo) {
            return LoadingBloc();
          } else if (state is RemoteUserProviderServerErrorState) {
            return BlocError(
              context: context,
                blocErrorState: BlocErrorState.serverError,
                function: () {
                  profileProviderBloc
                      .add(GetProfileInfoEvent(userId: widget.userId));
                });
          } else if (state is RemoteUserClientErrorState) {
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.userError,
              function: () {
                profileProviderBloc
                    .add(GetProfileInfoEvent(userId: widget.userId));
              },
            );
          } else if (state is SuccessGetProviderProfile) {
            scrollController = ScrollController();
            return CollapsingNoramlUSer(
              profileInfoResponse: state.profileInfoResponse,
              scrollController: scrollController,
              userId: widget.userId,
              profileProviderBloc: profileProviderBloc,
              tabs: [
                Tab(text: AppLocalizations.of(context).your_personal_information),
              ],
              tabsBody: [
                NormalUserPersonalInfo(
                  profileInfoResponse: state.profileInfoResponse,
                  profileProviderBloc: profileProviderBloc,
                  scrollController: scrollController,
                ),
              ],
            );
          } else
            return Container();
        },
      ),
    ));
  }
}
