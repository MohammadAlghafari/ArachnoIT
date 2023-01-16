import 'package:flutter/material.dart';

class AppConst {
  static dynamic CHECKED_VERSION_APP=null;
  static const ENTITY = "entity";
  static const ENUM_RESULT = "enumResult";
  static const ERROR_MESSAGES = "errorMessages";
  static const SUCCESS_ENUM = "successEnum";
  static const SUCCESS_MESSAGE = "successMessage";
  static const OPERATON_NAME = "opertationName";
  static const UNKNOWN = "UNKNOWN";
  static const BUSINESS = "BUSINESS";
  static const INDIVIDUAL = "INDIVIDUAL";
  static const ENUM_RESULT_NAME = 'enumResultName';
  static const Pattern EMAILPATTERN =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  static const Map<int, Color> PRIMARYCOLORMAP = {
    50: Color.fromRGBO(32, 39, 63, .1),
    100: Color.fromRGBO(32, 39, 63, .2),
    200: Color.fromRGBO(32, 39, 63, .3),
    300: Color.fromRGBO(32, 39, 63, .4),
    400: Color.fromRGBO(32, 39, 63, .5),
    500: Color.fromRGBO(32, 39, 63, .6),
    600: Color.fromRGBO(32, 39, 63, .7),
    700: Color.fromRGBO(32, 39, 63, .8),
    800: Color.fromRGBO(32, 39, 63, .9),
    900: Color.fromRGBO(32, 39, 63, 1),
  };

  static const PRIMARYSWATCH = MaterialColor(0xff20273F, PRIMARYCOLORMAP);

  static const int INVITE_MEMBER = 0;
  static const int CREATE_GROUP = 1;
  static const int EDIT_GROUP = 2;
  static const int REMOVE_MEMBER = 3;
  static const int REMOVE_GROUP = 4;
  static const int DISPLAY_NAMES = 5;
  static const int ADD_BLOG = 6;
  static const int EDIT_BLOG = 7;
  static const int REMOVE_BLOG = 8;
  static const int REMOVE_S_COMMENT = 9;
  static const int REMOVE_S_REPLY = 10;
  static const int ADD_RESEARCH = 11;
  static const int EDIT_RESEARCH = 12;
  static const int REMOVE_RESEARCH = 13;
  static const int ADD_QUESTION = 14;
  static const int EDIT_QUESTION = 15;
  static const int REMOVE_QUESTION = 16;
  static const int REMOVE_ANSWER = 17;
  static const int REMOVE_REPLY = 18;

  static const int ANSWER_ON_MY_QUESTION = 0;
  static const int COMMENT_ON_MY_ANSWER = 1;
  static const int NEW_FOLLOW = 2;
  static const int QUESTION_EMPHASIS = 3;
  static const int ANSWER_EMPHASIS = 4;
  static const int FOLLOWING_NEW_QUESTION = 5;
  static const int FOLLOWING_NEW_ANSWER = 6;
  static const int CATEGORY_NEW_QUESTION = 7;
  static const int SUB_CATEGORY_NEW_QUESTION = 8;
  static const int COMMENT_ON_MY_BLOG = 5000;
  static const int REPLY_ON_MY_COMMENT = 5001;
  static const int BLOG_EMPHASIS = 5002;
  static const int COMMENT_EMPHASIS = 5003;
  static const int QAA = 0;
  static const int SOCIAL = 0;
  static const int SUB_CATEGORY_NEW_BLOG = 5007;
  static const int APPROVE_TO_JOIN_DPARTMENT = 20000;
  static const int APPROVE_TO_JOIN_PATENT = 20001;
  static const int FOLLOWING_NEW_BLOG = 5004;
  static const int CATEGORY_NEW_BLOG = 5006;
  static const int FOLLOWING_NEW_COMMENT = 5005;
  static const int FOLLOWING_NEW_RESEARCH = 10000;
  static const int NEW_MESSAGE = 25000;
  static const int APPROVE_TO_JOIN_GROUP = 20002;
  static const int JOIN_IN_GROUP = 20003;
  static const int REQUEST_GROUP_MEMBER_TO_JOIN = 20004;
  static const int USER_LOGIN = 20005;
  static const String PERSON_ID = "personId";
  static const String TITLE = "title";
  static const String BODY = "body";
}
