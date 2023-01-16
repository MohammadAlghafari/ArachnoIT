import 'dart:convert';
import 'dart:io';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import '../infrastructure/api/urls.dart';
import '../injections.dart';
import 'app_const.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_cropper/image_cropper.dart';

class GlobalPurposeFunctions {
  static ProgressDialog progressDialog;

  static Future<List<ImageType>> cropListImage(result) async {
    List<ImageType> filess = [];
    for (int index = 0; index < result.paths.length; index++) {
      File item = await GlobalPurposeFunctions.cropImage(File(result.paths[index]));
      filess.add(ImageType(fileFromDevice: item, isFromDataBase: false));
    }
    return filess;
  }

  static Future<File> cropImage(File file) async {
    int length = file.path.length;
    String subString = file.path.substring(length - 3, length);
    if (subString == "png" || subString == "jpg" || subString == "peg") {
      File cropper;
      cropper = await ImageCropper.cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (cropper != null) return cropper;
      return file;
    }

    return file;
  }

  static Future<String> getIpAddress() async {
    try {
      String wifiIP = await WifiInfo().getWifiIP();
      return wifiIP;
    } catch (e) {
      print("the error happened is $e");
      return "";
    }
  }

  static Future<AndroidDeviceInfo> initPlatformState() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo mobileInfo = await deviceInfoPlugin.androidInfo;
        return mobileInfo;
      } else if (Platform.isIOS) {
        // deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
    }
  }

  static Future<File> compressImage(File file) async {
    if (file == null) return null;
    if (!fileTypeIsImage(filePath: file.path)) return file;
    final dir = await findLocalPath();
    final targetPath = dir + "/temp.jpg";
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );
    return result;
  }

  static Future<List<ImageType>> compressListOfImage(List<ImageType> file) async {
    List<ImageType> images = [];
    for (ImageType item in file) {
      ImageType imageType = new ImageType(
        fileFromDataBase: item.fileFromDataBase,
        fileFromDevice: item.fileFromDevice,
        imageID: item.imageID,
        isFromDataBase: item.isFromDataBase,
      );
      images.add(imageType);
    }
    int index = -1;
    for (ImageType item in images) {
      index++;
      if (item.isFromDataBase) continue;
      if (!fileTypeIsImage(filePath: item.fileFromDevice.path) || item.isFromDataBase) continue;
      final dir = await findLocalPath();
      final targetPath = dir + "/temp.jpg";
      final result = await FlutterImageCompress.compressAndGetFile(
        item.fileFromDevice.absolute.path,
        targetPath,
        quality: 90,
        minWidth: 1024,
        minHeight: 1024,
      );
      images[index].fileFromDevice = result;
    }

    return images;
  }

  static void share(BuildContext context, String url) {
    final RenderBox box = context.findRenderObject();
    final String text = url;
    Share.share(text, subject: "", sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  static LoginResponse getUserObject() {
    LoginResponse userInfo;
    SharedPreferences _prefs = serviceLocator<SharedPreferences>();
    if (_prefs.getString(PrefsKeys.LOGIN_RESPONSE) == null) {
      userInfo = null;
    } else
      userInfo = LoginResponse.fromMap(json.decode(_prefs.getString(PrefsKeys.LOGIN_RESPONSE)));
    return userInfo;
  }

  static bool isProfileOwner(String id) {
    SharedPreferences _prefs = serviceLocator<SharedPreferences>();
    if (_prefs.getString(PrefsKeys.LOGIN_RESPONSE) == null) {
      return false;
    }
    LoginResponse userInfo =
        LoginResponse.fromMap(json.decode(_prefs.getString(PrefsKeys.LOGIN_RESPONSE)));
    if (userInfo.userId == id) return true;
    return false;
  }

  static bool isHealthcareProvider() {
    LoginResponse userInfo = getUserObject();
    if (userInfo == null) return false;
    if (userInfo.userType != -1) return true;
    return false;
  }

  static void showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static ShapeBorder buildButtonBorder() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.zero,
          bottomRight: Radius.circular(25)),
    );
  }

  static changeStatusColor(Color color, bool backgroundWhite) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
      if (backgroundWhite) {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<String> buildDataPicker(BuildContext context) async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        builder: (context, child) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: AppConst.PRIMARYSWATCH,
              ),
            ),
            child: child));
    if (dateTime != null)
      return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    else
      return null;
  }

  static Future<void> showOrHideProgressDialog(BuildContext context, bool isShow) async {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );
    progressDialog.style(
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
        margin: EdgeInsets.all(15),
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation(
            Theme.of(context).accentColor,
          ),
        ),
      ),
      elevation: 10.0,
      padding: EdgeInsets.all(10),
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle:
          TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 19.0,
        fontWeight: FontWeight.w600,
      ),
      message: AppLocalizations.of(context).loading,
    );
    if (isShow) {
      await progressDialog.show();
    } else {
      await Future.delayed(const Duration(milliseconds: 500), () {
        progressDialog.hide();
      });
    }
  }

  static downloadFile(String url, String fileName) async {
    try {
      bool _permissionReady = await checkPermission();
      if (!_permissionReady) return;
      String _localPath = (await findLocalPath()) + Platform.pathSeparator + 'Download';
      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: _localPath,
        fileName: fileName,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    } catch (e) {
      print("the error insoder file donwlaod is $e");
    }
  }

  static Future<String> findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static Widget handleFileTypeIcon(
      {String fileExtension = "",
      String fileUrl = "",
      BuildContext context,
      double width = 15,
      double height = 15}) {
    String _extention = "";
    if (fileExtension.length == 0) {
      for (int i = fileUrl.length - 1; i >= 0; i--) {
        if (fileUrl[i] == '.') {
          _extention = fileUrl.substring(i);
          break;
        }
      }
    }
    if (fileExtension.length == 0) fileExtension = _extention;
    switch (fileExtension) {
      case '.jpg':
      case '.png':
      case '.jpeg':
        return Container(
          width: width,
          height: height,
          child: CachedNetworkImage(
            imageUrl: Urls.BASE_URL + fileUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        );
      case '.pdf':
        return SvgPicture.asset(
          "assets/images/ic_pdf_file.svg",
          color: Colors.red,
          fit: BoxFit.fill,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'doc':
        return SvgPicture.asset(
          "assets/images/ic_doc_file.svg",
          color: Colors.blue,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'docx':
        return SvgPicture.asset(
          "assets/images/ic_docx_file.svg",
          color: Colors.blue,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'pps':
        return SvgPicture.asset(
          "assets/images/ic_pps_file.svg",
          color: Colors.orange,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'ppt':
        return SvgPicture.asset(
          "assets/images/ic_ppt_file.svg",
          color: Colors.orange,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'pptx':
        return SvgPicture.asset(
          "assets/images/ic_pptx_file.svg",
          color: Colors.orange,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'xls':
        return SvgPicture.asset(
          "assets/images/ic_xls_file.svg",
          color: Colors.green,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'xlsx':
        return SvgPicture.asset(
          "assets/images/ic_xlsx_file.svg",
          color: Colors.green,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'tiff':
        return SvgPicture.asset(
          "assets/images/ic_tiff_file.svg",
          color: Theme.of(context).primaryColor,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'gif':
        return SvgPicture.asset(
          "assets/images/ic_gif_file.svg",
          color: Theme.of(context).primaryColor,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'odf':
        return SvgPicture.asset(
          "assets/images/ic_odf_file.svg",
          color: Theme.of(context).primaryColor,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
      case 'otf':
        return SvgPicture.asset(
          "assets/images/ic_otf_file.svg",
          color: Theme.of(context).primaryColor,
          fit: BoxFit.cover,
          width: width,
          height: height,
          alignment: Alignment.center,
        );
        break;
      default:
    }
  }

  static launchURL({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static copyToClipboard({@required String text}) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static fileTypeIsVideo({String filePath = "", String fileExtention = ""}) {
    String _extention = "";
    if (fileExtention.length != 0) {
      if (fileExtention == ".mp4") {
        return true;
      }
      return false;
    }
    for (int i = filePath.length - 1; i >= 0; i--) {
      if (filePath[i] == '.') {
        _extention = filePath.substring(i);
        break;
      }
    }
    if (_extention == ".mp4") {
      return true;
    }
    return false;
  }

  static fileTypeIsImage({String filePath = "", String fileExtention = ""}) {
    String _extention = "";
    if (fileExtention.length != 0) {
      if (fileExtention == ".jpg" || fileExtention == ".png" || fileExtention == ".jpeg")
        return true;
      else
        return false;
    }
    for (int i = filePath.length - 1; i >= 0; i--) {
      if (filePath[i] == '.') {
        _extention = filePath.substring(i);
        break;
      }
    }
    if (_extention == ".jpg" || _extention == ".png" || _extention == ".jpeg") return true;
    return false;
  }

  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        return true;
      } else {
        // Wifi detected but no internet connection found.
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      return false;
    }
  }
}
