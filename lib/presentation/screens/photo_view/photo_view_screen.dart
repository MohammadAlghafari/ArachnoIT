import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/screens/single_photo_view/single_photo_view_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoViewScreen extends StatelessWidget {
  static const routeName = '/photo_view_screen';
  const PhotoViewScreen({Key key, @required this.photos}) : super(key: key);

  final List<FileResponse> photos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: "",
      ),
      backgroundColor: Colors.grey[300],
      body:
          /* Stack(children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(
                    Urls.BASE_URL + photos[index].url,
                  ),
                  initialScale: PhotoViewComputedScale.contained * 0.9,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: photos[index].id),
                  tightMode: true);
            },
            itemCount: photos.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
          ),
          Positioned(
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 35,
            ),
            top: 10,
            left: 10,
          )
        ]) */

          Container(
        margin: EdgeInsets.only(top: 5),
        child: ListView.separated(
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SinglePhotoViewScreen.routeName,
                  arguments: photos[index]);
            },
            child: Hero(
              tag: photos[index].id,
              child: CachedNetworkImage(
                imageUrl: Urls.BASE_URL + photos[index].url,
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(
            height: 5,
          ),
          itemCount: photos.length,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
