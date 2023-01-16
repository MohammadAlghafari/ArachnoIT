import 'package:arachnoit/infrastructure/active_session/response/active_session_model.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';

abstract class ActiveSessionInterface {
  Future<ResponseWrapper<List<ActiveSessionModel>>> getAllActiveSession();
  Future<ResponseWrapper<bool>> sendReport(
      {String itemId,String message});
}
