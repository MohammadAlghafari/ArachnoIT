import 'package:arachnoit/application/search_provider/search_provider_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/doctor_dialog_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchProviderListItem extends StatelessWidget {
  AdvanceSearchResponse advanceSearchResponse = new AdvanceSearchResponse();
  SearchProviderListItem({Key key, this.advanceSearchResponse})
      : super(key: key);
  SearchProviderBloc searchProviderBloc;
  @override
  Widget build(BuildContext context) {
    searchProviderBloc = serviceLocator<SearchProviderBloc>();
    return BlocProvider<SearchProviderBloc>(
      create: (context) => searchProviderBloc,
      child: BlocListener<SearchProviderBloc, SearchProviderState>(
        listener: (context, state) {
          if (state is GetBriedProfileSuceess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) {
              showDialog(
                context: context,
                builder: (context) => DoctorDialogInfo(
                  info: state.profileInfo,
                ),
              );
            });
          }
        },
        child: InkWell(
          onTap: () {
            searchProviderBloc.add(
                GetProfile(context: context, userId: advanceSearchResponse.id));
          },
          child: Card(
            elevation: 0.0,
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: ChachedNetwrokImageView(
                          isCircle: true,
                          imageUrl: ((advanceSearchResponse.photo == null)
                              ? ""
                              : advanceSearchResponse.photo),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              advanceSearchResponse.inTouchPointName ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              style: semiBoldMontserrat(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              (advanceSearchResponse.accountType == 0)
                                  ? "individual"
                                  : "enterprise",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              style: lightMontserrat(
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            advanceSearchResponse.specification,
                            textAlign: TextAlign.start,
                            style: mediumMontserrat(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ))),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        advanceSearchResponse.subSpecification,
                        textAlign: TextAlign.start,
                        style: mediumMontserrat(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
