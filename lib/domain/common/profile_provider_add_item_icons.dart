import 'package:arachnoit/main.dart';
import 'package:arachnoit/presentation/screens/profile_provider/certificate/add_certificate_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/courses/add_new_courses.dart';
import 'package:arachnoit/presentation/screens/profile_provider/educations/add_educations_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/experiance/add_experiance_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/language/add_language_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/lectures/add_lecture_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/licenses/add_licenses_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/projects/add_project.dart';
import 'package:arachnoit/presentation/screens/profile_provider/skills/add_skill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileProviderAddItemIcons {
  static String lecturesKey = 'Lectures';
  static String certificates = 'Certificates.png';
  static String courses = 'Courses';
  static String educations = 'Educations';
  static String languages = 'Languages';
  static String licenses = 'Licenses';
  static String patents = 'Patents';
  static String experiance = 'Experiance';
  static String projects = 'Projects';
  static String skills = 'Skills';
  static String trophies = 'Trophies';
  static String volunteering = 'Volunteering';
  static String profileUserId="1";
  ProfileProviderAddItemIcons(String userId) {
    print(" AppLocalizations.of(navigatorKey.currentContext).lectures ${AppLocalizations.of(navigatorKey.currentContext).lectures}");
    lecturesKey = AppLocalizations.of(navigatorKey.currentContext).lectures;
    certificates = AppLocalizations.of(navigatorKey.currentContext).certificate;
    courses = AppLocalizations.of(navigatorKey.currentContext).courses;
    educations = AppLocalizations.of(navigatorKey.currentContext).educations;
    languages = AppLocalizations.of(navigatorKey.currentContext).language;
    licenses = AppLocalizations.of(navigatorKey.currentContext).licenses;
    patents = AppLocalizations.of(navigatorKey.currentContext).patents;
    experiance = AppLocalizations.of(navigatorKey.currentContext).experience;
    projects = AppLocalizations.of(navigatorKey.currentContext).projects;
    skills = AppLocalizations.of(navigatorKey.currentContext).skills;
    userId=profileUserId;
// trophies = AppLocalizations.of(context).;
// volunteering = 'Volunteering';
  }
  static Map<String, String> _categoryItems = {
    certificates: 'assets/images/certificates.png',
    courses: 'assets/images/courses.png',
    educations: 'assets/images/educations.png',
    experiance: 'assets/images/products.png',
    languages: 'assets/images/languages.png',
    lecturesKey: 'assets/images/category.png',
    licenses: 'assets/images/licenses.png',
    projects: 'assets/images/projects.png',
    skills: 'assets/images/skills.png',
    // trophies: 'assets/images/trophies.png',
    // volunteering: 'assets/images/volunteering.png',
  };

  static Map<String, Widget> screens = {
    certificates: AddNewCertificateScreen(),
    courses: AddNewCoursesScreen(),
    educations: AddEducationsScreen(),
    experiance: AddExperianceScreen(),
    languages: AddLanguageScreen(userId: profileUserId),
    lecturesKey: AddLectureScreen(),
    licenses: AddLicensesScreen(),
    projects: AddProjectScreen(),
    skills: AddSkillScreen(),
    // trophies: AddLicensesScreen(),
    // volunteering: AddLicensesScreen(),
  };

  static Widget getScreenWidget({String widgetKey}) {
    return screens[widgetKey];
  }

  static String getIconByKeyValue({String key}) {
    return _categoryItems[key];
  }
}
