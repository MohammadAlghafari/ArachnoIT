import 'dart:convert';
import 'dart:ui';
import 'dart:math' as math;
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/doctor_dialog_info.dart';
import 'package:arachnoit/presentation/custom_widgets/report_dialog.dart';
import 'package:arachnoit/presentation/screens/add_blog/add_blog_screen.dart';
import 'package:arachnoit/presentation/custom_widgets/video_player.dart';
import 'package:arachnoit/presentation/screens/blogs_vote/blogs_vote_screen.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/blog_list_item/blog_list_item_bloc.dart';
import '../../common/check_permissions.dart';
import '../../common/global_prupose_functions.dart';
import '../../common/pref_keys.dart';
import '../../infrastructure/api/urls.dart';
import '../../infrastructure/home_blog/response/get_blogs_response.dart';
import '../../infrastructure/login/response/login_response.dart';
import '../../injections.dart';
import '../screens/blog_details/blog_details_screen.dart';
import 'document_file_item.dart';
import 'needs_login_dialog.dart';
import 'post_tag_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlogPostListItem extends StatefulWidget {
   BlogPostListItem({@required this.post, @required this.play, @required this.function});
  GetBlogsResponse post;
  final bool play;
  final Function function;
  @override
  _BlogPostListItemState createState() => _BlogPostListItemState();
}

class _BlogPostListItemState extends State<BlogPostListItem> {
  BlogListItemBloc blogListItemBloc;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    blogListItemBloc = serviceLocator<BlogListItemBloc>();
  }

  Future<String> getLoginResponse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String response = pref.getString(PrefsKeys.LOGIN_RESPONSE);
    final body = json.decode(response);
    String photoUrl = body["photoUrl"];
    print('photoUrl is $photoUrl');
    return photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => blogListItemBloc,
      child: BlocListener<BlogListItemBloc, BlogListItemState>(
        listener: (context, state) {
          if (state is SuccessUpdateObject) {
            widget.post = state.newBlogItem;
          } else if (state is SendReportSuccess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is FailedSendReport) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            GlobalPurposeFunctions.showToast(
                AppLocalizations.of(context).check_your_internet_connection, context);
          } else if (state is GetBriedProfileSuceess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
              showDialog(
                context: context,
                builder: (context) => DoctorDialogInfo(
                  info: state.profileInfo,
                ),
              );
            });
          } else if (state is VoteEmphasisState) {
            if (widget.post.markedAsEmphasis) {
              widget.post.emphasisCount -= 1;
              widget.post.markedAsEmphasis = !widget.post.markedAsEmphasis;
            } else {
              widget.post.emphasisCount += 1;
              widget.post.markedAsEmphasis = !widget.post.markedAsEmphasis;
              if (!widget.post.markedAsUseful) {
                widget.post.usefulCount += 1;
                widget.post.markedAsUseful = !widget.post.markedAsUseful;
              }
            }
          } else if (state is VoteUsefulState) {
            if (widget.post.markedAsUseful) {
              widget.post.usefulCount -= 1;
              widget.post.markedAsUseful = !widget.post.markedAsUseful;
              if (widget.post.markedAsEmphasis) {
                widget.post.emphasisCount -= 1;
                widget.post.markedAsEmphasis = !widget.post.markedAsEmphasis;
              }
            } else {
              widget.post.usefulCount += 1;
              widget.post.markedAsUseful = !widget.post.markedAsUseful;
            }
          } else if (state is UpdateEmphasesAndUsefulManulaState) {
            if (state.usefulCount > widget.post.usefulCount) {
              widget.post.markedAsUseful = true;
            } else {
              widget.post.markedAsUseful = false;
            }

            if (state.emphasesCount > widget.post.emphasisCount) {
              widget.post.markedAsEmphasis = true;
            } else {
              widget.post.markedAsEmphasis = false;
            }
            widget.post.usefulCount = state.usefulCount;
            widget.post.emphasisCount = state.emphasesCount;
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          }
        },
        child: BlocBuilder<BlogListItemBloc, BlogListItemState>(builder: (context, state) {
          return Card(
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                LoginResponse userInfo = GlobalPurposeFunctions.getUserObject();
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => BlogDetailsScreen(
                              blogId: widget.post.id,
                              userId: widget.post.healthcareProviderId,
                            )))
                    .then((value) {
                  if (value["emphases"] != -1)
                    blogListItemBloc.add(UpdateEmphasesAndUsefulManula(
                        emphasesCount: value["emphases"], usefulCount: value["like"]));
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10, left: 10, top: 12),
                        width: 50,
                        height: 50,
                        child: Container(
                          child: (widget.post.photoUrl != null && widget.post.photoUrl != "")
                              ? ChachedNetwrokImageView(
                                  autoWidthAndHeigh: true,
                                  imageUrl: widget.post.photoUrl.substring(1),
                                  isCircle: true,
                                )
                              : SvgPicture.asset(
                                  "assets/images/ic_user_icon.svg",
                                  color: Theme.of(context).primaryColor,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: InkWell(
                                            child: Text(
                                              widget.post.inTouchPointName,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.visible,
                                              style: boldCircular(
                                                fontSize: 16,
                                                color: Theme.of(context).primaryColor,
                                              ),
//
                                            ),
                                            onTap: () {
                                              blogListItemBloc.add(GetProfileBridEvent(
                                                  userId: widget.post.healthcareProviderId,
                                                  context: context));
                                            },
                                          ),
                                        ),
                                        (widget.post.groupId != null && widget.post.groupId != "")
                                            ? Transform.rotate(
                                                angle: 90 * math.pi / 180,
                                                child: Transform.scale(
                                                  scale: 1.5,
                                                  child: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              )
                                            : Padding(padding: EdgeInsets.all(0)),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                                      var isVisitor, isMyBlog, response, loginUserGroupPermissions;
                                      if (loginResponse != null) {
                                        isVisitor = false;
                                        response = LoginResponse.fromJson(loginResponse);
                                        if (response.userId == widget.post.healthcareProviderId)
                                          isMyBlog = true;
                                        else
                                          isMyBlog = false;
                                        loginUserGroupPermissions =
                                            widget.post.loginUserGroupPermissions;
                                      } else {
                                        isVisitor = true;
                                        isMyBlog = false;
                                      }
                                      _showBottomSheet(
                                        context: context,
                                        isVisitor: isVisitor,
                                        isMyBlog: isMyBlog,
                                        loginUserGroupPermissions: loginUserGroupPermissions,
                                        blogId: widget.post.id,
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 12, right: 12),
                                      child: Icon(
                                        Icons.more_horiz,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 75,
                      right: 75,
                    ),
                    child: Transform.translate(
                      offset: Offset(0, -12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.post.groupId != null && widget.post.groupId != "")
                            InkWell(
                              child: Text(
                                widget.post.groupName,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                                style: mediumMontserrat(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {},
                            ),
                          Container(
                              child: AutoDirection(
                            text: widget.post.specification ?? '',
                            child: Text(
                              widget.post.specification,
                              textAlign: TextAlign.start,
                              style: lightMontserrat(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          )),
                          Container(
                              child: AutoDirection(
                            text: widget.post.subSpecification,
                            child: Text(
                              widget.post.subSpecification,
                              textAlign: TextAlign.start,
                              style: lightMontserrat(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  _handleAttachment(widget.post.blogType, widget.play),
                  if (widget.post.blogType != 0) SizedBox(height: 8),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: AutoDirection(
                        text: widget.post.title,
                        child: Text(
                          widget.post.title,
                          style: semiBoldMontserrat(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        DateFormat.yMd('en').format(DateTime.parse(widget.post.creationDate)),
                        style: lightMontserrat(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        widget.post.category,
                        style: regularMontserrat(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        widget.post.subCategory,
                        style: regularMontserrat(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      )),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: AutoDirection(
                              text: widget.post.body,
                              child: Html(
                                  data: widget.post.body.length >= 50
                                      ? widget.post.body.substring(0, 49) +
                                          " " +
                                          AppLocalizations.of(context).read_more
                                      : widget.post.body +
                                          " " +
                                          AppLocalizations.of(context).read_more),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.post.tags.length != 0)
                    Container(
                      height: 40,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return PostTagItem(
                            tagName: widget.post.tags[index].name,
                          );
                        },
                        itemCount: widget.post.tags.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlogsVoteScreen(
                                itemID: widget.post.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              widget.post.usefulCount.toString() +
                                  '\t' +
                                  AppLocalizations.of(context).useful,
                              style: lightMontserrat(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.visible,
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlogsVoteScreen(
                                itemID: widget.post.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              widget.post.emphasisCount.toString() +
                                  '\t' +
                                  AppLocalizations.of(context).emphasis,
                              style: lightMontserrat(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.visible,
                            )),
                      ),
                      Spacer(),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            widget.post.commentsCount.toString() +
                                '\t' +
                                AppLocalizations.of(context).comments,
                            style: lightMontserrat(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.visible,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 0.5,
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                            if (loginResponse != null) {
                              BlocProvider.of<BlogListItemBloc>(context).add(VoteUsefulEvent(
                                itemId: widget.post.id,
                                status: !widget.post.markedAsUseful,
                              ));
                            } else
                              showDialog(
                                context: context,
                                builder: (context) => NeedsLoginDialog(),
                              );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 2),
                                child: SvgPicture.asset(
                                  widget.post.markedAsUseful
                                      ? "assets/images/ic_useful_clicked.svg"
                                      : "assets/images/ic_useful_not_clicked.svg",
                                  color: Theme.of(context).primaryColor,
                                  fit: BoxFit.cover,
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                ///AppLocalizations.of(context).
                                AppLocalizations.of(context).useful,
                                style: lightMontserrat(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 3),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/ic_comment.svg",
                                color: Theme.of(context).primaryColor,
                                fit: BoxFit.cover,
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 7),
                              Text(
                                AppLocalizations.of(context).comments,
                                style: lightMontserrat(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 2)
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                            if (loginResponse != null) {
                              var response = LoginResponse.fromJson(loginResponse);
                              if (response.userType == 0 || response.userType == 1)
                                BlocProvider.of<BlogListItemBloc>(context).add(VoteEmphasisEvent(
                                  itemId: widget.post.id,
                                  status: !widget.post.markedAsEmphasis,
                                ));
                              else
                                GlobalPurposeFunctions.showToast(
                                    AppLocalizations.of(context).only_health_care_can_set_emphasis,
                                    context);
                            } else
                              showDialog(
                                context: context,
                                builder: (context) => NeedsLoginDialog(),
                              );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
                                child: SvgPicture.asset(
                                  widget.post.markedAsEmphasis
                                      ? "assets/images/fill_favorite.svg"
                                      : "assets/images/favorite.svg",
                                  color: Theme.of(context).primaryColor,
                                  fit: BoxFit.cover,
                                  width: 25,
                                  height: 25,
                                  alignment: Alignment.center,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                AppLocalizations.of(context).emphasis,
                                style: lightMontserrat(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 4)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _handleAttachment(int blogType, bool play) {
    switch (blogType) {
      case 1:
        return _handleAttachmentImages();
        break;
      case 2:
        return _handleAttachmentVideos(play);
        break;
      case 3:
        return _handleAttachmentSounds();
        break;
      case 4:
        return _handleAttachmentDocuments();
        break;
      case 5:
        return _handleAttachmentAll();
        break;
      default:
        return Padding(padding: EdgeInsets.all(0));
    }
  }

  Widget _handleAttachmentImages() {
    return (widget.post.files.length == 1)
        ? CachedNetworkImage(
            imageUrl: Urls.BASE_URL + widget.post.files.elementAt(0).url,
            progressIndicatorBuilder: (context, url, downloadProgress) => Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              child: CircularProgressIndicator(value: downloadProgress.progress),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          )
        : (widget.post.files.length == 2)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CachedNetworkImage(
                    imageUrl: Urls.BASE_URL + widget.post.files.elementAt(0).url,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: (MediaQuery.of(context).size.width / 2.1),
                  ),
                  CachedNetworkImage(
                    imageUrl: Urls.BASE_URL + widget.post.files.elementAt(1).url,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: (MediaQuery.of(context).size.width / 2.1),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CachedNetworkImage(
                    imageUrl: Urls.BASE_URL + widget.post.files.elementAt(0).url,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: (MediaQuery.of(context).size.width / 2.1),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter:
                            ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                        child: CachedNetworkImage(
                          imageUrl: Urls.BASE_URL + widget.post.files.elementAt(1).url,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: (MediaQuery.of(context).size.width / 2.1),
                        ),
                      ),
                      Text(
                        '+' + (widget.post.files.length - 2).toString(),
                        style: boldCircular(
                          fontSize: 50.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              );
  }

  Widget _handleAttachmentVideos(bool play) {
    return (widget.post.files.elementAt(0).fileType == 0)
        ? VideoWidget(
            play: play,
            url: Urls.BASE_URL + widget.post.files.elementAt(0).url,
          )
        : Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ChachedNetwrokImageView(
                    showFullImageWhenClick: false,
                    function: () {
                      GlobalPurposeFunctions.launchURL(url: widget.post.files.elementAt(0).url);
                    },
                    withBaseUrl: false,
                    imageUrl: widget.post.files.elementAt(0).url.contains('?v')
                        ? "http://img.youtube.com/vi/" +
                            widget.post.files.elementAt(0).url.substring(
                                widget.post.files.elementAt(0).url.lastIndexOf('=') + 1) +
                            "/hqdefault.jpg"
                        : "http://img.youtube.com/vi/" +
                            widget.post.files.elementAt(0).url.substring(
                                widget.post.files.elementAt(0).url.lastIndexOf('/') + 1) +
                            "/hqdefault.jpg",
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      "assets/images/ic_youtube.svg",
                      color: Colors.white,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 1.0, left: 4.0, right: 4.0),
                    child: Text("Youtube",
                        style: boldCircular(
                          color: Colors.white,
                          fontSize: 14,
                        )),
                  ),
                ),
              ),
            ],
          );
  }

  Widget _handleAttachmentSounds() {
    return Container(
      child: Text("Sounds"),
      height: 200,
      alignment: Alignment.center,
    );
  }

  Widget _handleAttachmentDocuments() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file_sharp,
                color: Theme.of(context).primaryColor,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Blog files:',
                style: lightMontserrat(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {
                BlocProvider.of<BlogListItemBloc>(context).add(DownloadFileEvent(
                    url: Urls.BASE_URL + widget.post.files[index].url,
                    fileName: widget.post.files[index].name));
                GlobalPurposeFunctions.showToast("the file is downloading", context);
              },
              child: DocumentFileItem(
                  file: widget.post.files[index],
                  index: index,
                  filesLength: widget.post.files.length),
            ),
            itemCount: widget.post.files.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ],
    );
  }

  Widget _handleAttachmentAll() {
    return Container(
      child: Text("All"),
      height: 200,
      alignment: Alignment.center,
    );
  }

  Future _showBottomSheet({
    @required BuildContext context,
    @required bool isVisitor,
    @required bool isMyBlog,
    @required List<int> loginUserGroupPermissions,
    @required String blogId,
  }) {
    return showModalBottomSheet<dynamic>(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                          padding: EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 10),
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
                                AppLocalizations.of(context).more_options,
                                style: mediumMontserrat(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: ((!isVisitor &&
                                    CheckPermissions.checkEditBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: ((!isVisitor &&
                                    CheckPermissions.checkEditBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushNamed(AddBlogPage.routeName, arguments: {
                                    'blogId': blogId,
                                    'getBlogsResponse': widget.post,
                                    'groupId':widget.post.groupId,
                                  }).then((value) {
                                    if(value!=null)
                                    blogListItemBloc.add(UpdateBlogPostObject(newBlogItem: value));
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context).edit_blog,
                                      style: lightMontserrat(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                        padding: ((!isVisitor &&
                                    CheckPermissions.checkRemoveBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: ((!isVisitor &&
                                    CheckPermissions.checkRemoveBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ? InkWell(
                                onTap: widget.function,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context).delete_blog,
                                      style: lightMontserrat(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                        padding: !isVisitor
                            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: !isVisitor
                            ? InkWell(
                                onTap: () {
                                  _controller.text = "";
                                  showDialog(
                                    context: context,
                                    builder: (context) => ReportDialog(
                                      userInfo: GlobalPurposeFunctions.getUserObject(),
                                      reportFunction: () {
                                        GlobalPurposeFunctions.showOrHideProgressDialog(
                                            context, true);
                                        blogListItemBloc.add(SendReport(
                                            blogId: widget.post.id, description: _controller.text));
                                      },
                                      reportController: _controller,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context).report_about_this_blog,
                                      style: lightMontserrat(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            GlobalPurposeFunctions.share(
                                context, Urls.SHARE_HOME_BLOGS + widget.post.id);
                          },
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
                                AppLocalizations.of(context).share_blog_link,
                                style: lightMontserrat(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        });
  }
}

/// BlocBuilder<BlogListItemBloc, BlogListItemState>
