import 'response_type.dart';

class ResponseWrapper<T> {
  int successEnum;
  T data;
  int enumResult;
  String errorMessage;
  ResponseType responseType;
  String successMessage;
  String opertationName;

  @override
  String toString() {
    return 'ResponseWrapper{successEnum: $successEnum, data: $data, enumResult: $enumResult, errorMessage: $errorMessage, responseType: $responseType, successMessage: $successMessage, opertationName: $opertationName}';
  }
}
