import 'package:arachnoit/common/font_style.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/home_qaa/response/qaa_response.dart';
import '../screens/question_details/question_details_screen.dart';

class DiscoverCategoryQuestionItem extends StatelessWidget {
  const DiscoverCategoryQuestionItem({Key key, @required this.question})
      : super(key: key);

  final QaaResponse question;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(QuestionDetailsScreen.routeName,
            arguments: question.questionId);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 150,
                      child: AutoDirection(
                          text: question.questionTitle,
                          child: Text(
                            question.questionTitle,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: mediumMontserrat(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                            ),
                          ))),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                  width: 150,
                  child: AutoDirection(
                      text: question.questionBody,
                      child: Text(
                        question.questionBody,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          height: 1,
                        ),
                      ))),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: AutoDirection(
                  text: question.askAnonymously
                      ? 'Anonymous'
                      : question.firstName + question.lastName,
                  child: Text(
                    'by:' +
                        (question.askAnonymously
                            ? 'Anonymous'
                            : question.firstName + question.lastName),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      height: 1,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
