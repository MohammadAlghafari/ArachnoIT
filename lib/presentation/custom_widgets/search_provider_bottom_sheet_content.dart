import 'package:arachnoit/application/search/search_bloc.dart';
import 'package:arachnoit/application/search_provider/search_provider_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/registration/response/account_types_response.dart';
import 'package:arachnoit/infrastructure/common_response/specification_response.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchProviderBottomSheetContent extends StatefulWidget {
  final SearchBloc searchBloc;
  SearchProviderBottomSheetContent({this.searchBloc});
  @override
  State<StatefulWidget> createState() {
    return _SearchProviderBottomSheetContent();
  }
}

class _SearchProviderBottomSheetContent
    extends State<SearchProviderBottomSheetContent> {
  SearchProviderBloc searchProviderBloc;
  int checkBoxSelectedValue;
  List<AccountTypesResponse> accountType = List<AccountTypesResponse>();
  List<SpecificationResponse> specification = List<SpecificationResponse>();
  List<SearchModel> seachItems = List<SearchModel>();
  String accountTypeId = "";
  String countryId = "";
  String cityId = "";
  String specificationId = "";
  String subSpecificationId = "";
  TextEditingController _typeEditingController = new TextEditingController();
  TextEditingController _subSpecificationEditingController =
      new TextEditingController();
  TextEditingController _countryEditingController = new TextEditingController();
  TextEditingController _cityEditingController = new TextEditingController();
  TextEditingController _servicesController = new TextEditingController();

  int selectedGenderType = -1;
  List<String> specificationsIds = List<String>();
  String servicesId = "";
  @override
  void initState() {
    super.initState();
    checkBoxSelectedValue = -1;
    searchProviderBloc = serviceLocator<SearchProviderBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: searchProviderBloc,
      child: BlocListener<SearchProviderBloc, SearchProviderState>(
        listener: (context, state) {
          if (state is LoadingState)
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          if (state is GetAccountTypeSuccessState)
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) => _handleGetAccountTypeSuccessState(state));
          else if (state is ChangeAccountTypeState)
            _handleChangeAccountTypeState(state);
          else if (state is GetSpecificationSuccessState)
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) => _handleGetSpecificationSuccessState(state));
          else if (state is ShowSubSpecificationState)
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) => _handleShowSubSpecificationState(state));
          else if (state is GetAllCountriesState)
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) => _handleGetAllCountriesState(state));
          else if (state is GetAllCitiesByCountrySuccessState)
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then(
                    (value) => _handleGetAllCitiesByCountrySuccessState(state));
          else if (state is ChangeMaleTypeSuccessState)
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) => _handleChangeMaleTypeSuccessState(state));
          else if (state is FetchProviderServicesSuccess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) => _handleFetchProviderServicesSuccess(state));
          } else if (state is RemoteClientErrorState) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            GlobalPurposeFunctions.showToast(
              AppLocalizations.of(context).check_your_internet_connection,
              context,
            );
          } else if (state is ResetAdvanceSearchValuesState) {
            _handleResetAdvanceSearchValuesState();
          }
        },
        child: BlocBuilder<SearchProviderBloc, SearchProviderState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
                child: Wrap(
                  children: [
                    Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Advanced Search:",
                              style: regularMontserrat(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Account Type:",
                              style: lightMontserrat(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            showTowRadioButton(context, state),
                            typeDropdownButton(context),
                            SizedBox(height: 10),
                            specialityDropdownButton(context),
                            SizedBox(height: 10),
                            countryDropdownButton(context),
                            SizedBox(height: 10),
                            cityDropdownButton(context),
                            SizedBox(height: 10),
                            serviceDropdownButton(context),
                            SizedBox(height: 10),
                            maleAndFemaleCheckBox(),
                            SizedBox(height: 10),
                            resetAndSearchButton(context),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleResetAdvanceSearchValuesState() {
    checkBoxSelectedValue = -1;
    accountType.clear();
    specification.clear();
    seachItems.clear();
    accountTypeId = "";
    countryId = "";
    cityId = "";
    specificationId = "";
    subSpecificationId = "";
    _typeEditingController.text = "";
    _subSpecificationEditingController.clear();
    _countryEditingController.text = "";
    _cityEditingController.text = "";
    _servicesController.text = "";
    selectedGenderType = -1;
    specificationsIds.clear();
    servicesId = "";
  }

  void _handleFetchProviderServicesSuccess(FetchProviderServicesSuccess state) {
    seachItems.clear();
    for (int i = 0; i < state.servicesList.length; i++) {
      seachItems.add(SearchModel(
          name: state.servicesList[i].name, id: state.servicesList[i].id));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: seachItems,
            )).then((val) {
      if (val != null) {
        _servicesController.text = seachItems[val].name;
        servicesId = seachItems[val].id.toString();
      }
    });
  }

  void _handleChangeMaleTypeSuccessState(ChangeMaleTypeSuccessState state) {
    selectedGenderType = state.genderId;
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
        _cityEditingController.text = seachItems[val].name;
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
        _countryEditingController.text = seachItems[val].name;
        countryId = seachItems[val].id.toString();
      }
    });
  }

  void _handleShowSubSpecificationState(ShowSubSpecificationState state) {
    seachItems.clear();
    for (int i = 0; i < state.subSpecificationList.length; i++) {
      seachItems.add(SearchModel(
          id: state.subSpecificationList[i].id,
          name: state.subSpecificationList[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: seachItems,
            )).then((val) {
      if (val != null) {
        _subSpecificationEditingController.text = seachItems[val].name;
        subSpecificationId = seachItems[val].id;
      }
    });
  }

  void _handleGetSpecificationSuccessState(GetSpecificationSuccessState state) {
    seachItems.clear();
    specification = state.specificationItems;
    for (int i = 0; i < specification.length; i++) {
      seachItems.add(
          SearchModel(id: specification[i].id, name: specification[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: seachItems,
            )).then((val) {
      if (val != null) {
        _typeEditingController.text = seachItems[val].name;
        specificationsIds.clear();
        specificationsIds.add(seachItems[val].id.toString());
        specificationId = seachItems[val].id.toString();
      }
    });
  }

  void _handleGetAccountTypeSuccessState(GetAccountTypeSuccessState state) {
    accountType = state.accountTypeList;
    searchProviderBloc.add(ChangeAccountTypeCheckValue(
        checkValue: state.changeValueIndex, accountType: accountType));
  }

  void _handleChangeAccountTypeState(ChangeAccountTypeState state) {
    checkBoxSelectedValue = state.selectedIndex;
    accountTypeId = accountType[state.selectedIndex].id;
    _typeEditingController.text = "";
    _subSpecificationEditingController.text = "";
  }

  Widget resetAndSearchButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              searchProviderBloc.add(ResetAdvanceSearchValues());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Text(
                    "RESET",
                    textAlign: TextAlign.center,
                    style: mediumMontserrat(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.settings_backup_restore,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              final param = {
                "accountTypeId": accountTypeId,
                "cityId": cityId,
                "countryId": countryId,
                "gender": selectedGenderType,
                "serviceId": servicesId,
                "isAdvanceSearch": true,
                "specificationsIds": specificationsIds,
                "subSpecificationId": subSpecificationId,
                "searchText": "",
              };
              widget.searchBloc.add(ProviderAdvanceSearch());
              Navigator.of(context).pop(param);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    "SEARCH",
                    textAlign: TextAlign.center,
                    style: mediumMontserrat(color: Colors.white, fontSize: 12),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget serviceDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: 'Service',
      controller: _servicesController,
      errorText: null,
      handleTap: () {
        searchProviderBloc.add(FetchProviderServices());
      },
    );
  }

  Widget maleAndFemaleCheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: (selectedGenderType == 0) ? true : false,
          onChanged: (value) {
            searchProviderBloc.add(ChangeGenderTypeEvent(genderId: 0));
            selectedGenderType = 0;
          },
        ),
        Text("Male"),
        SizedBox(
          width: 20,
        ),
        Checkbox(
            value: (selectedGenderType == 1) ? true : false,
            onChanged: (value) {
              searchProviderBloc.add(ChangeGenderTypeEvent(genderId: 1));
              selectedGenderType = 1;
            }),
        Text("Female"),
      ],
    );
  }

  Widget cityDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: 'City',
      controller: _cityEditingController,
      errorText: null,
      handleTap: () {
        searchProviderBloc.add(
            GetAllCityByCountryEvent(countryId: countryId, context: context));
      },
    );
  }

  Widget specialityDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: 'Speciality',
      controller: _subSpecificationEditingController,
      errorText: null,
      handleTap: () {
        searchProviderBloc.add(ShowSubSpecificationEvent(
            context: context, specificationId: specificationId));
      },
    );
  }

  Widget countryDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: 'Country',
      controller: _countryEditingController,
      errorText: null,
      handleTap: () {
        searchProviderBloc.add(GetALlCountryEvent());
      },
    );
  }

  Widget typeDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: 'Type',
      controller: _typeEditingController,
      errorText: null,
      handleTap: () {
        searchProviderBloc.add(GetAllSpecificationEvent(
            accountTypeId: accountTypeId, context: context));
      },
    );
  }

  Widget showTowRadioButton(BuildContext context, SearchProviderState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: 1,
          groupValue: checkBoxSelectedValue + 1,
          onChanged: (value) {
            if (accountType.length == 0) {
              searchProviderBloc.add(GetAccountTypeEvent(index: 0));
            } else
              searchProviderBloc.add(ChangeAccountTypeCheckValue(
                  checkValue: 0, accountType: accountType));
          },
          activeColor: Theme.of(context).accentColor,
        ),
        Text("Enterprise"),
        SizedBox(width: 20),
        Radio(
          value: 2,
          groupValue: checkBoxSelectedValue + 1,
          onChanged: (value) {
            if (accountType.length == 0) {
              searchProviderBloc.add(GetAccountTypeEvent(index: 1));
            } else
              searchProviderBloc.add(ChangeAccountTypeCheckValue(
                  checkValue: 1, accountType: accountType));
          },
          activeColor: Theme.of(context).accentColor,
        ),
        Text("Individual"),
      ],
    );
  }
}
