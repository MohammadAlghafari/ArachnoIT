import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/video_image_file_item.dart';
import 'package:arachnoit/presentation/custom_widgets/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arachnoit/presentation/custom_widgets/delete_item_dialog.dart';
import 'document_file_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileQualificationShowMoreListItem extends StatelessWidget {
  final String titleItemName;
  final String name;
  final String duration;
  final String itemDetail;
  final List<String> imageUrl;
  final List<FileResponse> files;
  final List<String> videosList;
  final Function deleteFunction;
  final Function updateFunction;
  final bool canMakeUpdate;
  ProfileQualificationShowMoreListItem({
    this.name,
    this.titleItemName,
    this.duration = "",
    this.itemDetail = "",
    this.imageUrl = const <String>[],
    this.files = const <FileResponse>[],
    this.deleteFunction,
    this.updateFunction,
    this.videosList = const <String>[],
    @required this.canMakeUpdate,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 40,
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: Color(0XFF19444C),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(0))),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        myPopMenu(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(name.length!=0)IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.drive_file_rename_outline,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(color: Color(0XFF19444C)),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(
                      titleItemName,
                      style: TextStyle(color: Color(0XFFC4C4C4), fontSize: 16),
                    ),
                    subtitle: Text(
                      name,
                      style: TextStyle(color: Colors.black , fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          ((duration != ""))
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        padding: EdgeInsets.only(top: 5),
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.alarm_add_outlined,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(color: Color(0XFF19444C)),
                      ),
                      Flexible(
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context).duration,
                            style: TextStyle(color: Color(0XFFC4C4C4) , fontSize: 16),
                          ),
                          subtitle: Text(
                            duration,
                            style: TextStyle(
                                color:Colors.black, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          if(itemDetail.length!=0)IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(color: Color(0XFF19444C)),
                ),
                Flexible(
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context).item_detail,
                      style: TextStyle(color:  Color(0XFFC4C4C4), fontSize: 16),
                    ),
                    subtitle: Text(
                      itemDetail,
                      style: TextStyle(color:Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.topCenter,
                  child: (files.length != 0)
                      ? Icon(
                          Icons.folder,
                          color: Colors.white,
                        )
                      : Container(),
                  decoration: BoxDecoration(color: Color(0XFF19444C)),
                ),
                (files.length != 0)
                    ? Flexible(
                        child: ListTile(
                            title: Text(
                              AppLocalizations.of(context).files,
                              style:
                                  TextStyle(color:  Color(0XFFC4C4C4), fontSize: 16),
                            ),
                            subtitle: Container(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                children: files
                                    .map(
                                      (e) => InkWell(
                                        onTap: () {
                                          GlobalPurposeFunctions.downloadFile(
                                              e.url, e.name);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              child: Column(
                                            children: [
                                              GlobalPurposeFunctions
                                                  .handleFileTypeIcon(
                                                      fileUrl: e.url,
                                                      height: 30,
                                                      width: 30),
                                              Text(
                                                e.name.length > 10
                                                    ? e.name.substring(0, 6) +
                                                        ".."
                                                    : e.name,
                                              )
                                            ],
                                          )),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )),
                      )
                    : Container()
              ],
            ),
          ),
          _showVideosInfo(context),
          _showImages(context)
        ],
      ),
    );
  }

  Widget _showImages(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.topCenter,
            child: (imageUrl.length != 0)
                ? Icon(
                    Icons.picture_as_pdf,
                    color: Colors.white,
                  )
                : Container(height: 10),
            decoration: BoxDecoration(
                color: Color(0XFF19444C),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(15))),
          ),
          (imageUrl.length != 0)
              ? (imageUrl.length == 1)
                  ? Flexible(
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context).photo,
                          style: TextStyle(color: Color(0XFFC4C4C4), fontSize: 16),
                        ),
                        subtitle: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              color: Color(0XFFC4C4C4),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              )),
                          height: 150,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: ChachedNetwrokImageView(
                                  imageUrl: imageUrl[0])),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Text(
                            AppLocalizations.of(context).photos,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        subtitle: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8, top: 8),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              children: imageUrl
                                  .map((e) => ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: ChachedNetwrokImageView(
                                          imageUrl: e,
                                          height: 60,
                                          width: 60,
                                          isCircle: false,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    )
              : Container()
        ],
      ),
    );
  }

  Widget _showVideosInfo(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.topCenter,
            child: (videosList.length != 0)
                ? Icon(
                    Icons.folder,
                    color: Colors.white,
                  )
                : Container(),
            decoration: BoxDecoration(color: Color(0XFF19444C)),
          ),
          (videosList.length != 0)
              ? Flexible(
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context).videos,
                      style: TextStyle(color: Color(0XFFC4C4C4), fontSize: 16),
                    ),
                    subtitle: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Wrap(
                          direction: Axis.vertical,
                          children: videosList
                              .map((e) => InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => VideoWidget(
                                            play: true,
                                            url: Urls.BASE_URL + e,
                                          ),
                                        ),
                                      );
                                    },
                                    child: VideoIageFileItem(
                                      videoFromInternet: true,
                                      videoName: e,
                                      height: 60,
                                      width: 60,
                                      withClipprect: true,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget myPopMenu(BuildContext context) {
    if (!(canMakeUpdate)) {
      return Container();
    } else {
      return PopupMenuButton(
        padding: EdgeInsets.only(left: 16,top: 8,right: 16),
          onSelected: (value) {
            if (value == 1) {
              updateFunction();
            } else {
              showDialog(
                context: context,
                builder: (context) => DeleteItemDialog(
                  deleteFunction: deleteFunction,
                ),
              );
            }
          },
          itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(Icons.edit),
                        ),
                        Text(AppLocalizations.of(context).edit)
                      ],
                    )),
                PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(Icons.delete),
                        ),
                        Text(AppLocalizations.of(context).delete)
                      ],
                    )),
              ]);
    }
  }
}
