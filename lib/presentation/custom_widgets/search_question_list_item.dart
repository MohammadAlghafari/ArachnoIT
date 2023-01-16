import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/question_details/question_details_screen.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchQuestionListItem extends StatelessWidget {
  const SearchQuestionListItem({Key key, @required this.question})
      : super(key: key);

  final QaaResponse question;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(QuestionDetailsScreen.routeName,
              arguments: question.questionId);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10, top: 10, left: 10),
                    width: 50,
                    height: 50,
                    child: Container(
                      child:
                      (question.photoUrl != null && question.photoUrl != "")
                          ? ChachedNetwrokImageView(
                        imageUrl: question.photoUrl,
                        isCircle: true,
                      )
                          : SvgPicture.asset(
                        "assets/images/ic_user_icon.svg",
                        color: Theme.of(context).primaryColor,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: InkWell(
                      child: Text(
                        question.askAnonymously
                            ? 'Anonymous'
                            : question.firstName + question.lastName,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        style: mediumMontserrat(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      onTap: () {},
                    ),
                  ),
                  (question.groupId != null && question.groupId != "")
                      ? Icon(
                    Icons.play_arrow,
                    color: Theme.of(context).primaryColor,
                  )
                      : Padding(padding: EdgeInsets.all(0)),
                  (question.groupId != null && question.groupId != "")
                      ? Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      width: double.infinity,
                      height: 22,
                      child: InkWell(
                        child: Text(
                          question.groupName,
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
            ),
            if (!question.askAnonymously && question.specification != null)
              Container(
                  margin: EdgeInsets.only(left: 60),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        question.specification,
                        textAlign: TextAlign.start,
                        style: lightMontserrat(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ))),
            if (!question.askAnonymously)
              SizedBox(
                height: 5,
              ),
            if (!question.askAnonymously && question.subSpecification != null)
              Container(
                  margin: EdgeInsets.only(left: 60),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        question.subSpecification,
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
                  text: question.questionTitle,
                  child: Text(
                    question.questionTitle,
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
                        text: question.questionBody,
                        child: Text(
                          question.questionBody,
                          textAlign: TextAlign.justify,
                          style: mediumMontserrat(
                            fontSize: 14,
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
