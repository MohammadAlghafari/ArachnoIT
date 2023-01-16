import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/api/urls.dart';
import '../../infrastructure/home_blog/response/get_blogs_response.dart';
import '../screens/blog_details/blog_details_screen.dart';

class SearchBlogListItem extends StatelessWidget {
  const SearchBlogListItem({Key key, @required this.blog}) : super(key: key);

  final GetBlogsResponse blog;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(BlogDetailsScreen.routeName,
              arguments: {
                "blog_id": blog.id,
                "user_id": blog.healthcareProviderId
              });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10, left: 10),
                  width: 50,
                  height: 50,
                  child: Container(
                    child: (blog.photoUrl != null && blog.photoUrl != "")
                        ? ChachedNetwrokImageView(
                      isCircle: true,
                      imageUrl: blog.photoUrl,
                    )
                        : SvgPicture.asset(
                      "assets/images/ic_user_icon.svg",
                      color: Theme.of(context).primaryColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                InkWell(
                  child: Text(
                    blog.inTouchPointName,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                    style: mediumMontserrat(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {},
                ),
                (blog.groupId != null && blog.groupId != "")
                    ? Icon(
                  Icons.play_arrow,
                  color: Theme.of(context).primaryColor,
                )
                    : Padding(padding: EdgeInsets.all(0)),
                (blog.groupId != null && blog.groupId != "")
                    ? Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    width: double.infinity,
                    height: 22,
                    child: InkWell(
                      child: Text(
                        blog.groupName,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: mediumMontserrat(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      onTap: () {},
                    ),
                  ),
                  flex: 1,
                )
                    : Padding(padding: EdgeInsets.all(0)),
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 60),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      blog.specification,
                      textAlign: TextAlign.start,
                      style: lightMontserrat(
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ))),
            SizedBox(
              height: 5,
            ),
            Container(
                margin: EdgeInsets.only(left: 60),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      blog.subSpecification,
                      textAlign: TextAlign.start,
                      style: lightMontserrat(
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ))),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: AutoDirection(
                  text: blog.title,
                  child: Text(
                    blog.title,
                    style: mediumMontserrat(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: AutoDirection(
                        text: blog.body,
                        child: Text(
                          blog.body,
                          textAlign: TextAlign.justify,
                          style: mediumMontserrat(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.visible,
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
