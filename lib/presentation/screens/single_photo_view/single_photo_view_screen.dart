import 'package:arachnoit/common/font_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../application/single_photo_view/single_photo_view_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../infrastructure/api/urls.dart';
import '../../../infrastructure/common_response/file_response.dart';
import '../../../injections.dart';

class SinglePhotoViewScreen extends StatefulWidget {
  static const routeName = '/single_photo_view_screen';

  SinglePhotoViewScreen({Key key, @required this.photo}) : super(key: key);

  final FileResponse photo;

  @override
  _SinglePhotoViewScreenState createState() => _SinglePhotoViewScreenState();
}

class _SinglePhotoViewScreenState extends State<SinglePhotoViewScreen> {
  SinglePhotoViewBloc singlePhotoViewBloc;

  @override
  void initState() {
    super.initState();
    singlePhotoViewBloc = serviceLocator<SinglePhotoViewBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            PhotoView(
                imageProvider: CachedNetworkImageProvider(
                    Urls.BASE_URL + widget.photo.url),
                maxScale: PhotoViewComputedScale.covered * 2.0,
                minScale: PhotoViewComputedScale.contained * 1,
                initialScale: PhotoViewComputedScale.contained),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, singlePhotoViewBloc);
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 35,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _showBottomSheet(BuildContext context,
      SinglePhotoViewBloc singlePhotoViewBloc) {
    return showModalBottomSheet<dynamic>(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return BlocProvider.value(
            value: singlePhotoViewBloc,
            child: BlocBuilder<SinglePhotoViewBloc, SinglePhotoViewState>(
              builder: (context, state) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white),
                  child: Wrap(children: [
                    Container(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(
                                    right: 10, bottom: 10, top: 10, left: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.circular(20)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.miscellaneous_services,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "More options",
                                      style: semiBoldMontserrat(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<SinglePhotoViewBloc>(context)
                                      .add(DownloadFileEvent(
                                      url: widget.photo.url,
                                      fileName: widget.photo.name));
                                  Navigator.of(context).pop();
                                  GlobalPurposeFunctions.showToast(
                                      'The file is dwonloading', context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.download_sharp,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Download photo",
                                        style: lightMontserrat(
                                          fontSize: 14,
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Share photo",
                                        style: lightMontserrat(
                                          fontSize: 14,
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                );
              },
            ),
          );
        });
  }
}
