import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/const.dart';
import 'app_exception.dart';

class NetworkAPICall {
  static final NetworkAPICall _networkAPICall = NetworkAPICall._internal();

  factory NetworkAPICall() => _networkAPICall;

  NetworkAPICall._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<dynamic> multiPartPostRequest(
      String url, Map<String, dynamic> body) async {
    try {
      var formData = FormData();
      body.forEach((key, value) {
        if (key.toString().contains("profile_pic")) {
          formData.files.add(MapEntry(
            'profile_pic',
            MultipartFile.fromFileSync(value),
          ));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      Response response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: _getHeaders()),
      );

      return _checkResponse(response);
    } catch (exception) {
      throw AppException.exceptionHandler(exception);
    }
  }

  Future<dynamic> get(String apiUrl,
      {bool isToken = true, bool isAddBaseUrl = true}) async {
    try {
      Response response = await _dio.get(
        isAddBaseUrl ? apiUrl : baseUrl + apiUrl,
        options: Options(
            headers:
                isToken ? _getHeaders() : {'Content-Type': 'application/json'}),
      );
      return _checkResponse(response);
    } catch (exception) {
      throw AppException.exceptionHandler(exception);
    }
  }

  Future<dynamic> post(String apiName, dynamic request,
      {bool isToken = true}) async {
    try {
      Response response = await _dio.post(
        apiName,
        data: jsonEncode(request),
        options: Options(
            headers:
                isToken ? _getHeaders() : {'Content-Type': 'application/json'}),
      );
      return _checkResponse(response);
    } catch (exception) {
      throw AppException.exceptionHandler(exception);
    }
  }

  Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer'};
  }

  _checkResponse(Response response) {
    switch (response.statusCode) {
       case 201 || 200:
        try {
          var json = response.data;
          if (json is List) return json;
          if (json['status'] == 'error') {
            throw AppException(
                message: json['message'], errorCode: response.statusCode ?? 0);
          }
          return json;
        } catch (e, stackTrace) {
          throw AppException.exceptionHandler(e, stackTrace);
        }
      case 400:
        throw AppException(
            message: response.data['message'][1],
            errorCode: response.data['statusCode']);
      case 401:
      case 403:
      case 405:
        throw AppException(
            message: "Unauthorized", errorCode: response.statusCode ?? 0);

      case 101:
      case 102:
        throw AppException(
            message: "Internet not available",
            errorCode: response.statusCode ?? 0);
      case 422:
        throw AppException(
            message: "Server maintenance, please try again later.",
            errorCode: response.statusCode ?? 0);
      case 500:
      case 502:
        throw AppException(
            message: "Server maintenance, please try again later.",
            errorCode: response.statusCode ?? 0);
      default:
        throw AppException(
            message: "Unable to communicate with the server.",
            errorCode: response.statusCode ?? 0);
    }
  }
}
