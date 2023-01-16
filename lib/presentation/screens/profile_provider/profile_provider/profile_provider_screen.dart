import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/screens/home_blog/home_blog_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/collapsing_tab_provider/collapsing_tab_provider.dart';
import 'package:arachnoit/presentation/screens/profile_provider/my_blogs/my_blogs.dart';
import 'package:arachnoit/presentation/screens/profile_provider/personal_info/personal_info_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/qualifications/qualifications_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileProviderScreen extends StatefulWidget {
  static const routeName = '/profile_provider';
  final String userId;
  ProfileProviderScreen({this.userId});
  @override
  State<StatefulWidget> createState() {
    return _ProfileProviderScreen();
  }
}

class _ProfileProviderScreen extends State<ProfileProviderScreen>
    with AutomaticKeepAliveClientMixin {
  ProfileProviderBloc profileProviderBloc;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    ProfileProviderAddItemIcons(widget.userId);
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
                  profileProviderBloc.add(GetProfileInfoEvent(userId: widget.userId));
                });
          } else if (state is RemoteUserClientErrorState) {
            return BlocError(
              context: context,
              blocErrorState: BlocErrorState.userError,
              function: () {
                profileProviderBloc.add(GetProfileInfoEvent(userId: widget.userId));
              },
            );
          } else if (state is SuccessGetProviderProfile) {
            scrollController = ScrollController();
            return CollapsingTabProvider(
              profileInfoResponse: state.profileInfoResponse,
              scrollController: scrollController,
              userId: widget.userId,
              profileProviderBloc: profileProviderBloc,
              tabs: [
                Tab(text: AppLocalizations.of(context).your_personal_information),
                Tab(text: AppLocalizations.of(context).qualification),
                Tab(text: AppLocalizations.of(context).posts),
              ],
              tabsBody: [
                PersonalInfoTab(
                  scrollController: scrollController,
                  profileInfoResponse: state.profileInfoResponse,
                  profileProviderBloc: profileProviderBloc,
                ),
                QualificationsTab(
                  controller: scrollController,
                  userId: widget.userId,
                ),
                HomeBlogScreen(userId: widget.userId, shouldReloadData: false),
              ],
            );
          } else
            return Container(
              color: Colors.yellow,
            );
        },
      ),
    ));
  }
}
