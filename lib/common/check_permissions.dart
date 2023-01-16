import 'app_const.dart';

class CheckPermissions {
  static bool checkInviteMemberPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.INVITE_MEMBER) return true;
    return false;
  }

  static bool checkEditGroupPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.EDIT_GROUP) return true;
    return false;
  }

  static bool checkRemoveMemberPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_MEMBER) return true;
    return false;
  }

  static bool checkRemoveGroupPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_GROUP) return true;
    return false;
  }

  static bool checkDisplayNamesPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.DISPLAY_NAMES) return true;
    return false;
  }

  static bool checkAddBlogPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.ADD_BLOG) return true;
    return false;
  }

  static bool checkEditBlogPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.EDIT_BLOG) return true;
    return false;
  }

  static bool checkRemoveBlogPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_BLOG) return true;
    return false;
  }

  static bool checkRemoveSCommentPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_S_COMMENT)
          return true;
    return false;
  }

  static bool checkRemoveSReplyPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_S_REPLY) return true;
    return false;
  }

  static bool checkAddResearchPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.ADD_RESEARCH) return true;
    return false;
  }

  static bool checkEditResearchPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.EDIT_RESEARCH) return true;
    return false;
  }

  static bool checkRemoveResearchPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_RESEARCH)
          return true;
    return false;
  }

  static bool checkAddQuestionPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.ADD_QUESTION) return true;
    return false;
  }

  static bool checkEditQuestionPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.EDIT_QUESTION) return true;
    return false;
  }

  static bool checkRemoveQuestionPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_QUESTION)
          return true;
    return false;
  }

  static bool checkRemoveAnswerPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_ANSWER) return true;
    return false;
  }

  static bool checkRemoveReplyPermission(List<int> permissionList) {
    if (permissionList != null)
      for (int i = 0; i < permissionList.length; i++)
        if (permissionList.elementAt(i) == AppConst.REMOVE_REPLY) return true;
    return false;
  }
}