import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/application/profile_provider_language/profile_provider_language_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/language.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/response/language_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:arachnoit/presentation/custom_widgets/start_and_end_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateLanguageScreen extends StatefulWidget {
  final LanguageResponse language;
  final ProfileProviderLanguageBloc bloc;
  final int index;
  UpdateLanguageScreen({
    @required this.language,
    @required this.bloc,
    @required this.index,
  });
  @override
  _UpdateLanguageScreen createState() => new _UpdateLanguageScreen();
}

class _UpdateLanguageScreen extends State<UpdateLanguageScreen> {
  bool checkBoxNoEnd = false;
  List<ImageType> file = [];
  TextEditingController _languageController = TextEditingController();
  TextEditingController _levelController = TextEditingController();
  ProfileProviderLanguageBloc profileProviderLanguageBloc;
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  List<SearchModel> seachItems = [];
  bool noEndDate = false;
  ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  String languageId = "";
  String levelId = "";
  CommonLanguage commonLanguage;
  @override
  void initState() {
    super.initState();
    profileProviderLanguageBloc = serviceLocator<ProfileProviderLanguageBloc>();
    languageId = widget.language.id;
    _languageController.text = widget.language.englishName;

    levelId = widget.language.languageLevel.toString();
  }

  @override
  Widget build(BuildContext context) {
    commonLanguage = CommonLanguage(context);
    _levelController.text =
        commonLanguage.getLevelNameByID(widget.language.languageLevel);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarProject.showAppBar(
          title: AppLocalizations.of(context).update_language_skills),
      body: BlocProvider<ProfileProviderLanguageBloc>(
        create: (context) => profileProviderLanguageBloc,
        child: BlocListener<ProfileProviderLanguageBloc,
            ProfileProviderLanguageState>(
          listener: (contex, state) {
            // GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            if (state.status == ProfileProviderStatus.success) {
              _handleSuccessGetAllLanguage(state);
            } else if (state is SuccessAddNewLanguage) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                widget.bloc.add(UpdateListValue(
                  index: widget.index,
                  level: int.parse(levelId),
                ));
                Navigator.pop(context);
              });
            } else if (state is SuccessShowLevel) {
              _handleSuccessShowLevel();
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderLanguageBloc,
              ProfileProviderLanguageState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  margin:
                      EdgeInsets.only(top: 20, right: 17, left: 17, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      topImage(),
                      SizedBox(height: 10),
                      showLanguage(),
                      SizedBox(height: 8),
                      showLevel(),
                      SizedBox(height: 8),
                      saveAndCancel()
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleSuccessShowLevel() {
    seachItems.clear();
    CommonLanguage commonLanguage = CommonLanguage(context);
    seachItems = commonLanguage.getLanguageLevelAsSearchModel();
    GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
        .then((value) {
      showDialog(
          context: context,
          builder: (context) => SearchDialog(
                data: seachItems,
              )).then((val) {
        if (val != null) {
          _levelController.text = seachItems[val].name;
          levelId = seachItems[val].id.toString();
        }
      });
    });
  }

  void _handleSuccessGetAllLanguage(ProfileProviderLanguageState state) {
    seachItems.clear();
    for (int i = 0; i < state.posts.length; i++) {
      seachItems.add(
          SearchModel(name: state.posts[i].nativeName, id: state.posts[i].id));
    }
    GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
        .then((value) {
      showDialog(
          context: context,
          builder: (context) => SearchDialog(
                data: seachItems,
              )).then((val) {
        if (val != null) {
          _languageController.text = seachItems[val].name;
          languageId = seachItems[val].id.toString();
        }
      });
    });
  }

  Widget saveAndCancel() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
            color: Colors.transparent,
            child: Center(
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        SizedBox(
          width: 10,
        ),
        RaisedButton(
          color: Color(0XFFF65636),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Text(
              AppLocalizations.of(context).save,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onPressed: () {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            profileProviderLanguageBloc.add(AddNewLanguage(
                languageId: languageId,
                languageLevel: int.parse(levelId),
                context: context));
          },
        ),
      ],
    );
  }

  Widget showLevel() {
    return Container(
        margin: EdgeInsets.all(0.0),
        color: Color(0XFFEFEFEF),
        child: TextField(
          onTap: () {
            profileProviderLanguageBloc.add(ShowLanguageLevel());
          },
          readOnly: true,
          maxLines: 1,
          controller: _levelController,
          decoration: new InputDecoration(
            labelText: AppLocalizations.of(context).level+" * ",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                gapPadding: 15),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ));
  }

  Widget showLanguage() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        readOnly: true,
        controller: _languageController,
        decoration: new InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                gapPadding: 15),
            labelText: AppLocalizations.of(context).choose_language+" * ",
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded)),
        onChanged: (value) {},
      ),
    );
  }

  Widget topImage() {
    return Hero(
      tag: ProfileProviderAddItemIcons.languages,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Color(0XFFC4C4C4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                ProfileProviderAddItemIcons.getIconByKeyValue(
                    key: ProfileProviderAddItemIcons.languages),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
