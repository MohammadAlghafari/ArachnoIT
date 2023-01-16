import 'package:arachnoit/application/profile_provider_skills/profile_provider_skills_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/start_and_end_time.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSkillScreen extends StatefulWidget {
  @override
  _AddSkillScreen createState() => new _AddSkillScreen();
}

class _AddSkillScreen extends State<AddSkillScreen> {
  bool checkBoxNoEnd = false;
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  ProfileProviderSkillsBloc profileProviderSkillsBloc;
  bool noEndDate = false;
  ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  @override
  void initState() {
    super.initState();
    profileProviderSkillsBloc = serviceLocator<ProfileProviderSkillsBloc>();
    startAndEndTimeWithExpire = StartAndEndTimeWithExpire(
      startTime: startTime,
      endTime: endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).add_new_skills),
      body: BlocProvider<ProfileProviderSkillsBloc>(
        create: (context) => profileProviderSkillsBloc,
        child:
            BlocListener<ProfileProviderSkillsBloc, ProfileProviderSkillsState>(
          listener: (contex, state) {
            if (state is SuccessAddNewSkill) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                Navigator.pop(context);
              });
            } else if (state is ErrorState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                GlobalPurposeFunctions.showToast(state.errorMessage, context);
              });
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
            //  if (state is SuccessAddNewProject) {
            //   GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
            //       .then((value) => {Navigator.pop(context)});
            // } else {
            //   GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            // }
          },
          child: BlocBuilder<ProfileProviderSkillsBloc,
              ProfileProviderSkillsState>(
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
                      showFiledOfStudy(),
                      SizedBox(height: 15),
                      startAndEndTimeWithExpire,
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).details+" * "),
                      SizedBox(height: 10),
                      showDetailView(),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      saveAndCancel(),
                      SizedBox(height: 10),
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
              profileProviderSkillsBloc.add(AddNewSkill(
                context: context,
                description: _detailController.text,
                endDate: endTime.text,
                startDate: startTime.text,
                name: _nameController.text,
                withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
              ));
              // profileProviderProjectsBloc.add(
              //   SetNewProject(
              //     context: context,
              //     withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
              //     description: _detailController.text,
              //     endDate: endTime.text,
              //     startDate: startTime.text,
              //     file: file,
              //     link: _urlController.text,
              //     name: _nameController.text,
              //   ),
              // );
            }),
      ],
    );
  }

  Widget showFiledOfStudy() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        controller: _nameController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              gapPadding: 15),
          labelText: AppLocalizations.of(context).skill_name+" * " ,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget showDetailView() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        maxLines: 3,
        controller: _detailController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              gapPadding: 15),
          labelText: AppLocalizations.of(context).details,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget urlPath() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        controller: _urlController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              gapPadding: 15),
          labelText: AppLocalizations.of(context).link,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget topImage() {
    return Hero(
      tag: ProfileProviderAddItemIcons.skills,
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
                    key: ProfileProviderAddItemIcons.skills),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
