import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/urls.dart';
import '../../infrastructure/home_blog/response/get_blogs_response.dart';
import '../screens/blog_details/blog_details_screen.dart';

class DiscoverCategoryBlogItem extends StatelessWidget {
  const DiscoverCategoryBlogItem({Key key, @required this.blog})
      : super(key: key);

  final GetBlogsResponse blog;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(BlogDetailsScreen.routeName,
            arguments: {
              "blog_id": blog.id,
              "user_id": blog.healthcareProviderId
            });
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                height: 75,
                child: Center(
                  child: _handleAttachment(
                    blog.blogType,
                    context,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Container(
                      width: 150,
                      child: AutoDirection(
                          text: blog.title,
                          child: Text(
                            blog.title,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: mediumMontserrat(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                            ),
                          ))),
                )),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: AutoDirection(
                  text: blog.inTouchPointName,
                  child: Text(
                    'by:' + blog.inTouchPointName,
                    textAlign: TextAlign.start,
                    style: mediumMontserrat(
                      color: Theme.of(context).accentColor,
                      fontSize: 14,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _handleAttachment(int blogType,
      BuildContext context,) {
    switch (blogType) {
      case 1:
        return _handleAttachmentImages(context);
        break;
      case 2:
        return _handleAttachmentVideos(context);
        break;
      default:
        return Image.asset("assets/images/no_photos.png");
    }
  }

  Widget _handleAttachmentImages(BuildContext context) {
    return ChachedNetwrokImageView(
      imageUrl: blog.files.elementAt(0).url,
      showFullImageWhenClick: false,
      function: () {
        Navigator.of(context).pushNamed(BlogDetailsScreen.routeName,
            arguments: {
              "blog_id": blog.id,
              "user_id": blog.healthcareProviderId
            });
      },
    );
  }

  Widget _handleAttachmentVideos(BuildContext context) {
    if (blog.files.elementAt(0).fileType == 1)
      return Align(
        alignment: Alignment.center,
        child: ChachedNetwrokImageView(
          showFullImageWhenClick: false,
          function: () {
            Navigator.of(context).pushNamed(BlogDetailsScreen.routeName,
                arguments: {
                  "blog_id": blog.id,
                  "user_id": blog.healthcareProviderId
                });
          },
          imageUrl: blog.files.elementAt(0).url.contains('?v')
              ? "http://img.youtube.com/vi/" +
              blog.files
                  .elementAt(0)
                  .url
                  .substring(
                  blog.files
                      .elementAt(0)
                      .url
                      .lastIndexOf('=') + 1) +
              "/hqdefault.jpg"
              : "http://img.youtube.com/vi/" +
              blog.files
                  .elementAt(0)
                  .url
                  .substring(
                  blog.files
                      .elementAt(0)
                      .url
                      .lastIndexOf('/') + 1) +
              "/hqdefault.jpg",
        ),
      );
  }
}
