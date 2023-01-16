import 'dart:ui';

import 'package:arachnoit/application/provider_list_item/provider_list_item_bloc.dart';
import 'package:arachnoit/application/providers_all/providers_all_bloc.dart';
import 'package:arachnoit/application/providers_favorite/providers_favorite_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/common_response/provider_item_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/doctor_dialog_info.dart';
import 'package:arachnoit/presentation/custom_widgets/user_dialog_info.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProvidersProviderListItem extends StatefulWidget {
  final int index;

  const ProvidersProviderListItem({Key key,
    @required this.provider,
    @required this.deleteItemFunction,
    this.index})
      : super(key: key);

  final ProviderItemResponse provider;
  final Function deleteItemFunction;

  @override
  _ProvidersProviderListItemState createState() =>
      _ProvidersProviderListItemState();
}

class _ProvidersProviderListItemState extends State<ProvidersProviderListItem> {
  ProviderListItemBloc providerListItemBloc;
  ProvidersFavoriteBloc providersFavoriteBloc;
  ProvidersAllBloc providersAllBloc;
  @override
  void initState() {
    super.initState();
    providerListItemBloc = serviceLocator<ProviderListItemBloc>();
    providersFavoriteBloc = serviceLocator<ProvidersFavoriteBloc>();
    providersAllBloc = serviceLocator<ProvidersAllBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(bottom: 4),
      child: InkWell(
          onTap: () {
            providerListItemBloc.add(GetProfileBridEvent(
                userId: widget.provider.id, context: context));
          },
          child: BlocProvider.value(
            value: providerListItemBloc,
            child: BlocListener<ProviderListItemBloc, ProviderListItemState>(
              listener: (context, state) {
                if (state is SetFavoriteProviderState) {
                  widget.provider.addedToFavoriteList =
                  !widget.provider.addedToFavoriteList;
                  if (!widget.provider.addedToFavoriteList) {
                    widget.deleteItemFunction();
                    providersFavoriteBloc.add(RemoveItemFromFavouriteMap(
                        id: widget.provider.id, index: widget.index));
                    providersAllBloc
                        .add(RemoveItemFromMap(id: widget.provider.id));
                  } else {
                    providersFavoriteBloc.add(
                        AddItemToArray(providerItemResponse: widget.provider));
                  }
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false);
                } else if (state is GetBriedProfileSuceess) {
                  if (widget.provider.accountType == 0 ||
                      widget.provider.accountType == 1) {
                    GlobalPurposeFunctions.showOrHideProgressDialog(
                        context, false)
                        .then((value) {
                      showDialog(
                        context: context,
                        builder: (context) => DoctorDialogInfo(
                          info: state.profileInfo,
                        ),
                      );
                    });
                  }
                } else {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false);
                }
              },
              child: BlocBuilder<ProviderListItemBloc, ProviderListItemState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin:
                              EdgeInsets.only(right: 10, top: 10, left: 10),
                              width: 60,
                              height: 60,
                              child: Container(
                                child: (widget.provider.photo != null &&
                                    widget.provider.photo != "")
                                    ? ChachedNetwrokImageView(
                                        isCircle: true,
                                        imageUrl: widget.provider.photo,
                                      )
                                    : SvgPicture.asset(
                                        "assets/images/ic_user_icon.svg",
                                        color: Theme.of(context).primaryColor,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget?.provider?.inTouchPointName
                                        ?.trim() ??
                                        "",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '(' +
                                        (widget.provider.profileType == 1
                                            ?AppLocalizations
                                            .of(context)
                                            .enterprise +
                                            ')'
                                            : AppLocalizations
                                            .of(context)
                                            .individual +
                                            ')'),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .accentColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              widget.provider.specification,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  widget.provider.subSpecification,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ))),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.3,
                        ),
                        if (widget.provider.summary != null)
                          if (widget.provider.summary.trim() != '')
                            IntrinsicHeight(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: AutoDirection(
                                  text: widget.provider.summary,
                                  child: Row(
                                    children: [
                                      VerticalDivider(
                                        color: Theme.of(context).primaryColor,
                                        thickness: 2,
                                      ),
                                      Expanded(
                                        child: Text(widget.provider.summary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.phone_android_outlined,
                                  color: Theme.of(context).primaryColor,
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.provider.mobile,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.provider.email,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                    ))),
                          ],
                        ),
                        Divider(
                          thickness: 0.3,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton.icon(
                              onPressed: () {
                                BlocProvider.of<ProviderListItemBloc>(context)
                                    .add(SetFavoriteProviderEvent(
                                  favoritePersonId: widget.provider.id,
                                  favoriteStatus:
                                  !widget.provider.addedToFavoriteList,
                                  context: context,
                                ));
                              },
                              icon: Icon(
                                widget.provider.addedToFavoriteList
                                    ?Icons.star
                                    : Icons.star_outline,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                              label: Text(
                                AppLocalizations.of(context).fav,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                            FlatButton.icon(
                                onPressed: () {
                                  GlobalPurposeFunctions.share(
                                      context,
                                      Urls.USER_SHARE_BLOGS +
                                          widget.provider.id);
                                },
                                icon: Icon(
                                  Icons.share_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                label: Text(
                                  AppLocalizations.of(context).share,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                )),
                            FlatButton.icon(
                                onPressed: () {
                                  BlocProvider.of<ProviderListItemBloc>(context)
                                      .add(CopyToClipboardEvent(
                                      text: Urls.PROVIDER_PROFILE_LINK +
                                          widget.provider.id));
                                  GlobalPurposeFunctions.showToast(
                                      'Profile link copied to clipboard',
                                      context);
                                },
                                icon: Icon(
                                  Icons.copy_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                label: Text(
                                  AppLocalizations.of(context).copy,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ))
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }
}
