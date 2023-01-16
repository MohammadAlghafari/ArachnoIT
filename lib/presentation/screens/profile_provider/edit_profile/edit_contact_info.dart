import 'dart:convert';
import 'dart:ui';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditContactInfoScreen extends StatefulWidget {
  final HealthCareProviderProfileDto info;
  final ProfileProviderBloc bloc;
  final ProfileInfoResponse profileInfoResponse;
  EditContactInfoScreen(
      {@required this.info,
      @required this.bloc,
      @required this.profileInfoResponse});
  @override
  State<StatefulWidget> createState() {
    return _EditGlobalInfoScreen();
  }
}

class _EditGlobalInfoScreen extends State<EditContactInfoScreen> {
  ProfileProviderBloc profileProviderBloc;
  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _workPhone = TextEditingController();
  TextEditingController _accountTagController = TextEditingController();
  TextEditingController _accountNameController = TextEditingController();
  List<SearchModel> seachItems = [];
  String countryId = "";
  String cityId = "";
  @override
  void initState() {
    super.initState();
    profileProviderBloc = serviceLocator<ProfileProviderBloc>();
    countryId = widget?.info?.countryId ?? "";
    cityId = widget?.info?.cityId ?? "";
    _countryController.text = widget?.info?.country ?? "";
    _cityController.text = widget?.info?.city ?? "";
    _addressController.text = widget?.info?.address ?? "";
    _emailController.text = widget?.info?.email ?? "";
    _mobileController.text = widget?.info?.mobile ?? "";
    _workPhone.text = widget?.info?.workPhone ?? "";
    _countryController.text =
        widget?.info?.country ?? AppLocalizations.of(context).country;
    _cityController.text =
        widget?.info?.city ?? AppLocalizations.of(context).city;
  }

  @override
  void dispose() {
    super.dispose();
    _accountNameController.dispose();
    _accountTagController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _workPhone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
          title: AppLocalizations.of(context).edit_contact_info),
      body: BlocProvider<ProfileProviderBloc>(
        create: (context) => profileProviderBloc,
        child: BlocListener<ProfileProviderBloc, ProfileProviderState>(
          listener: (context, state) {
            if (state is GetAllCountriesState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) => _handleGetAllCountriesState(state));
            } else if (state is GetAllCitiesByCountrySuccessState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) =>
                      _handleGetAllCitiesByCountrySuccessState(state));
            } else if (state is SuccessUpdateContactInfo) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then(
                (value) {
                  widget.bloc.add(UpdateHealthCareContactInfo(
                    newContactValue: state.contactResponse,
                    profileInfo: widget.profileInfoResponse,
                    city: _cityController.text,
                    country: _countryController.text,
                  ));
                  Navigator.pop(context);
                }, ////
              );
            } else {
              GlobalPurposeFunctions.showToast(
                  AppLocalizations.of(context).check_your_internet_connection,
                  context);
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderBloc, ProfileProviderState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18, left: 12, right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      showAddress(),
                      SizedBox(height: 20),
                      showCountryAndCity(),
                      SizedBox(height: 20),
                      emailTextFiled(AppLocalizations.of(context).email,
                          _emailController, true),
                      SizedBox(height: 20),
                      emailTextFiled(AppLocalizations.of(context).mobile,
                          _mobileController),
                      SizedBox(height: 20),
                      emailTextFiled(
                          AppLocalizations.of(context).land_line, _workPhone),
                      SizedBox(height: 20),
                      showCancelAndSaveButton()
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

  void _handleGetAllCitiesByCountrySuccessState(
      GetAllCitiesByCountrySuccessState state) {
    seachItems.clear();
    for (int i = 0; i < state.citiesList.length; i++) {
      seachItems.add(SearchModel(
          name: state.citiesList[i].name, id: state.citiesList[i].id));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: seachItems,
            )).then((val) {
      if (val != null) {
        _cityController.text = seachItems[val].name;
        cityId = seachItems[val].id.toString();
      }
    });
  }

  void _handleGetAllCountriesState(GetAllCountriesState state) {
    seachItems.clear();
    for (int i = 0; i < state.countriesList.length; i++) {
      seachItems.add(SearchModel(
          name: state.countriesList[i].name, id: state.countriesList[i].id));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: seachItems,
            )).then((val) {
      if (val != null) {
        _countryController.text = seachItems[val].name;
        countryId = seachItems[val].id.toString();
      }
    });
  }

  Widget showCancelAndSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
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
          onTap: () async {
            SharedPreferences _pref = serviceLocator<SharedPreferences>();
            LoginResponse userInfo = LoginResponse.fromMap(
                json.decode(_pref.get(PrefsKeys.LOGIN_RESPONSE)));
            profileProviderBloc.add(UpdateContactInfo(
                address: _addressController.text,
                cityId: cityId,
                mobile: _mobileController.text,
                personId: userInfo.userId,
                phone: _mobileController.text,
                workPhone: _workPhone.text,
                context: context));
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

  Widget emailTextFiled(String title, TextEditingController controller,
      [bool readOnly = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(flex: 2, child: Text(title)),
        SizedBox(width: 10),
        Flexible(
          flex: 5,
          child: Container(
            height: 35,
            child: TextField(
              readOnly: readOnly,
              controller: controller,
            ),
          ),
        )
      ],
    );
  }

  Widget showAddress() {
    return Row(
      children: [
        showTextField(
            controller: _addressController,
            title: AppLocalizations.of(context).address,
            fullWidth: true,
            maxLine: 3),
      ],
    );
  }

  Widget showCountryAndCity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: DropDownTextField(
            controller: _countryController,
            hintText: _countryController.text,
            errorText: "",
            handleTap: () {
              profileProviderBloc.add(GetCountry(context: context));
            },
            color: Colors.black,
          ),
        ),
        SizedBox(width: 3),
        Flexible(
          child: DropDownTextField(
            hintText: _cityController.text,
            errorText: "",
            handleTap: () {
              if (countryId.length == 0)
                GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).please_add +
                        " " +
                        AppLocalizations.of(context).country,
                    context);
              else {
                profileProviderBloc.add(GetAllCityByCountryEvent(
                    countryId: countryId, context: context));
              }
            },
            controller: _cityController,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget showImageAndName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(180),
          child: Container(
            color: Colors.grey.shade300,
            width: 100,
            height: 100,
            child: Icon(Icons.image, size: 40),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            showTextField(
                controller: _accountNameController,
                title: AppLocalizations.of(context).account_name),
            SizedBox(width: 10),
            showTextField(
                controller: _accountTagController,
                title: AppLocalizations.of(context).account_tag),
          ],
        ),
      ],
    );
  }

  Widget showTextField(
      {TextEditingController controller,
      String title,
      IconData icon,
      bool fullWidth = false,
      int maxLine = 1}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              width: (fullWidth)
                  ? MediaQuery.of(context).size.width - 30
                  : MediaQuery.of(context).size.width - 150,
              child: TextField(
                maxLines: maxLine,
                minLines: 1,
                decoration: InputDecoration(
                  suffixIcon: (Icon(icon) ?? null),
                ),
                cursorColor: Colors.grey,
                selectionWidthStyle: BoxWidthStyle.max,
                controller: controller,
              ),
            )
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
