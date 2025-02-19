import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int errorCode;
  final String? tag;

  AppException({required this.message, required this.errorCode, this.tag});

  @override
  String toString() {
    return jsonEncode({"message": message, "errorCode": errorCode});
  }

  static AppException decodeExceptionData({required String jsonString}) {
    try {
      final decodedData = jsonDecode(jsonString);
      return AppException(
        message: decodedData['message'],
        errorCode: decodedData['errorCode'],
      );
    } catch (e) {
      return AppException(
        message:
            "Unable to communicate with the server at the moment.\n\nPlease try again later",
        errorCode: 105,
      );
    }
  }

  static dynamic exceptionHandler(dynamic exception, [StackTrace? stackTrace]) {
    print('Exception Message ==> ${exception ?? 'no message'}');

    if (exception is AppException) {
      throw exception;
    } else if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AppException(
            message: "The request has timed out.\n\nPlease try again!!!",
            errorCode: 102,
          );
        case DioExceptionType.badResponse:
          throw AppException(
            message: "Received an invalid response from the server.",
            errorCode: exception.response?.statusCode ?? 103,
          );
        case DioExceptionType.cancel:
          throw AppException(
            message: "Request was cancelled.",
            errorCode: 106,
          );
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          throw AppException(
            message:
                "Internet not available.\n\nCross check your connectivity and try again later.",
            errorCode: 101,
          );
        case DioExceptionType.badCertificate:
        // TODO: Handle this case.
      }
    } else if (exception is SocketException) {
      throw AppException(
        message:
            "Internet not available.\n\nCross check your connectivity and try again later.",
        errorCode: 101,
      );
    } else if (exception is TimeoutException) {
      throw AppException(
        message: "The request has timed out.\n\nPlease try again!!!",
        errorCode: 102,
      );
    } else if (exception is HttpException) {
      throw AppException(
        message: "Couldn't find the requested data.",
        errorCode: 103,
      );
    } else if (exception is FormatException) {
      throw AppException(
        message:
            "Looks like our server is down for maintenance.\n\nPlease try again later.",
        errorCode: 104,
      );
    }

    throw AppException(
      message:
          "Unable to communicate with the server at the moment.\n\nPlease try again later.",
      errorCode: 105,
    );
  }
}
