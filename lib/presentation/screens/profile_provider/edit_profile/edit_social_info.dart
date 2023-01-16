import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditSocialInfoScreen extends StatefulWidget {
  final HealthCareProviderProfileDto info;
  final ProfileProviderBloc bloc;
  final ProfileInfoResponse profileInfoResponse;
  EditSocialInfoScreen({
    @required this.bloc,
    @required this.info,
    @required this.profileInfoResponse,
  });
  @override
  State<StatefulWidget> createState() {
    return _EditSocialInfoScreen();
  }
}

///SuccessUpdateSocial
class _EditSocialInfoScreen extends State<EditSocialInfoScreen> {
  ProfileProviderBloc _profileProviderBloc;
  TextEditingController _faceBookController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _telegramController = TextEditingController();
  TextEditingController _whatsAppController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _youtbeController = TextEditingController();
  double spaceValue = 10;
  @override
  void initState() {
    super.initState();
    _faceBookController.text = widget?.info?.facebook ?? "";
    _instagramController.text = widget?.info?.instagram ?? "";
    _telegramController.text = widget?.info?.telegram ?? "";
    _whatsAppController.text = widget?.info?.whatsApp ?? "";
    _twitterController.text = widget?.info?.twiter ?? "";
    _youtbeController.text = widget?.info?.youtube ?? "";
    _profileProviderBloc = serviceLocator<ProfileProviderBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
          title: AppLocalizations.of(context).edit_social_medial_info),
      body: Padding(
        padding: const EdgeInsets.only(top: 18, left: 12, right: 12),
        child: BlocProvider<ProfileProviderBloc>(
          create: (context) => _profileProviderBloc,
          child: BlocListener<ProfileProviderBloc, ProfileProviderState>(
            listener: (context, state) {
              if (state is SuccessUpdateSocial) {
                widget.bloc.add(UpdateHealthCareSocailInfo(
                  facebook: _faceBookController.text,
                  instagram: _instagramController.text,
                  linkedIn: "",
                  telegram: _telegramController.text,
                  twiter: _twitterController.text,
                  whatsApp: _whatsAppController.text,
                  youtube: _youtbeController.text,
                  profileInfo: widget.profileInfoResponse,
                ));
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) {
                  Navigator.pop(context);
                });
              } else {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              }
            },
            child: BlocBuilder<ProfileProviderBloc, ProfileProviderState>(
              builder: (context, state) {
                return ListView(
                  children: [
                    SizedBox(height: spaceValue),
                    emailTextFiled(
                        AppLocalizations.of(context).face_book,
                        _faceBookController,
                        AppLocalizations.of(context)
                            .copy_your_profile_link_from_your_facebook_profile_page),
                    SizedBox(height: spaceValue),
                    emailTextFiled(
                        AppLocalizations.of(context).instagram,
                        _instagramController,
                        AppLocalizations.of(context)
                            .copy_your_profile_link_from_your_instagram_profilePage),
                    SizedBox(height: spaceValue),
                    emailTextFiled(
                        AppLocalizations.of(context).telegram,
                        _telegramController,
                        AppLocalizations.of(context)
                            .copy_your_telegram_username_from_your_telegram_profile_page),
                    SizedBox(height: spaceValue),
                    emailTextFiled(
                        AppLocalizations.of(context).whats_app,
                        _whatsAppController,
                        AppLocalizations.of(context).add_your_phone_number),
                    SizedBox(height: spaceValue),
                    emailTextFiled(
                        AppLocalizations.of(context).twitter,
                        _twitterController,
                        AppLocalizations.of(context)
                            .copy_your_twitter_name_from_your_twitter_profile_page_without_sympol),
                    SizedBox(height: spaceValue),
                    emailTextFiled(
                        AppLocalizations.of(context).youtube,
                        _youtbeController,
                        AppLocalizations.of(context)
                            .copy_your_channel_link_from_your_youtube_profile_page),
                    SizedBox(height: spaceValue),
                    SizedBox(height: spaceValue),
                    showCancelAndSaveButton(),
                    SizedBox(height: 30),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget showCancelAndSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 18, top: 12, bottom: 12),
                child: Text(
                  AppLocalizations.of(context).cancel,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () {
            _profileProviderBloc.add(UpdateSocailNetworkEvent(
              facebook: _faceBookController.text,
              instagram: _instagramController.text,
              linkedIn: "",
              telegram: _telegramController.text,
              twiter: _twitterController.text,
              whatsApp: _whatsAppController.text,
              youtube: _youtbeController.text,
              context: context,
            ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              color: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 18, top: 12, bottom: 12),
                child: Text(
                  AppLocalizations.of(context).save,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget emailTextFiled(
      String title, TextEditingController controller, String hint) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(offset: Offset(0, 10), child: Text(title)),
          SizedBox(width: 10),
          TextField(
            controller: controller,
          ),
          SizedBox(height: 4),
          AutoDirection(
            text: hint,
            child: Text(hint,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 12,
                )),
          ),
        ],
      ),
    );
  }
}
