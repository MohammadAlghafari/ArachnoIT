import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/presentation/screens/single_photo_view/single_photo_view_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChachedNetwrokImageView extends StatelessWidget {
  final String imageUrl;
  final bool isCircle;
  final double width;
  final double height;
  final bool withBaseUrl;
  final bool showFullImageWhenClick;
  final bool autoWidthAndHeigh;
  final Function function;
  ChachedNetwrokImageView({
    this.height = 60,
    this.showFullImageWhenClick = true,
    this.width = 60,
    this.imageUrl = "",
    this.isCircle = false,
    this.withBaseUrl = true,
    this.autoWidthAndHeigh = false,
    this.function,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (showFullImageWhenClick && imageUrl != null)
          Navigator.of(context).pushNamed(SinglePhotoViewScreen.routeName,
              arguments: FileResponse(url: imageUrl, id: "123"));
        else
          function();
      },
      child: Container(
        width: (autoWidthAndHeigh) ? null : width,
        height: (autoWidthAndHeigh) ? null : height,
        child: ClipRRect(
          borderRadius: (isCircle)
              ? BorderRadius.circular(100)
              : BorderRadius.circular(0),
          child: CachedNetworkImage(
            imageUrl: (withBaseUrl)
                ? Urls.BASE_URL + ((imageUrl == null) ? "" : imageUrl)
                : "" + ((imageUrl == null) ? "" : imageUrl),
            imageBuilder: (context, imageProvider) => Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: (isCircle) ? BoxShape.circle : BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).accentColor,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            )),
            errorWidget: (context, url, error) =>
                new SvgPicture.asset("assets/images/ic_user_icon.svg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
//
