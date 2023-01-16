import 'package:arachnoit/application/blogs_vote_item/blogs_vote_item_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/blogs_vote_respose.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/user_dialog_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'doctor_dialog_info.dart';

///BlogsVoteItemBloc
class BlogsVoteListItem extends StatelessWidget {
  final BlogsVoteItemBloc blogsVoteItemBloc =
      serviceLocator<BlogsVoteItemBloc>();
  final BlogsVoteResponse item;
  BlogsVoteListItem({this.item});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlogsVoteItemBloc>(
        create: (context) => blogsVoteItemBloc,
        child: BlocListener<BlogsVoteItemBloc, BlogsVoteItemState>(
          listener: (context, state) {
            if (state is GetBriedProfileSuceess) {
              if (state.profileInfo.accountType == 0 ||
                  state.profileInfo.accountType == 1) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) {
                  showDialog(
                    context: context,
                    builder: (context) => DoctorDialogInfo(
                      info: state.profileInfo,
                    ),
                  );
                });
              } else {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) {
                  showDialog(
                    context: context,
                    builder: (context) => UserDialogInfo(
                      info: state.profileInfo,
                    ),
                  );
                });
              }
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<BlogsVoteItemBloc, BlogsVoteItemState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  blogsVoteItemBloc.add(
                      GetProfileBridEvent(userId: item.id, context: context));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ChachedNetwrokImageView(
                            imageUrl: item.photo,
                            height: 50,
                            width: 50,
                            isCircle: true,
                          ),
                          SizedBox(width: 8),
                          Text(
                            (item.isHealthcareProvider &&
                                    item.isHealthcareProvider != null)
                                ? item.inTouchPointName
                                : item.fullName.length == 0
                                    ? AppLocalizations.of(context).remove
                                    : item.fullName,
                            style: regularMontserrat(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
