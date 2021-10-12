import 'dart:async';
// import 'package:alakefak/Helper/user_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_log/quick_log.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

const String BASE_URL = "https://alatareqak.elsaed.aait-d.com/api";

class ServerGate {
  Dio dio = Dio();
  Logger log = Logger('--------- Server Gate Logger -------- ');

  Map<String, dynamic> _header() {
    return {
      "Accept": "application/json",
      // "locale": localization.currentLanguage,
      // if (UserHelper.accessToken != null)
      //   "Authorization": "Bearer ${UserHelper.accessToken}",
      // if (UserHelper.schoolDatum != null &&
      //     UserHelper.schoolDatum.apiToken != null)
      // "Authorization": "Bearer ${UserHelper.schoolDatum.apiToken}",
    };
  }

  void addInterceptors() {
    dio.interceptors.add(CustomApiInterceptor());
  }

  // ------- POST DATA TO SERVER -------//
  Future<CustomResponse> sendToServer({
    @required String url,
    Map<String, dynamic> headers,
    Map<String, dynamic> body,
  }) async {
    // remove nulls from body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
    }
    if (headers != null) {
      headers.addAll(_header());
    } else {
      headers = _header();
    }
    print(headers);
    print("url == > $url");
    try {
      Response response = await dio.post(
        "$BASE_URL/$url",
        data: FormData.fromMap(body),
        options: Options(
          // responseType: ResponseType.plain,
          contentType:
              "multipart/form-data; boundary=<calculated when request is sent>",
          headers: headers,
        ),
      );
      print(response);
      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: response.data["message"] ?? "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------- POST delete TO SERVER -------//
  Future<CustomResponse> deleteFromServer({
    @required String url,
    Map<String, dynamic> headers,
    Map<String, dynamic> body,
  }) async {
    // remove nulls from body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
    }
    if (headers != null) {
      headers.addAll(_header());
    } else {
      headers = _header();
    }
    try {
      Response response = await dio.delete(
        "$BASE_URL/$url",
        data: FormData.fromMap(body),
        options: Options(
          headers: headers,
        ),
      );

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------- PUT DATA TO SERVER -------//
  Future<CustomResponse> putToServer({
    @required String url,
    Map<String, dynamic> headers,
    Map<String, dynamic> body,
  }) async {
    // remove nulls from body
    // if (body != null) {
    //   body.removeWhere(
    //     (key, value) => body[key] == null || body[key] == "",
    //   );
    // }
    if (headers != null) {
      headers.addAll(_header());
    } else {
      headers = _header();
    }
    try {
      Response response = await dio.put(
        "$BASE_URL/$url",
        data: FormData.fromMap(body),
        options: Options(
          headers: headers,
        ),
      );

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------ GET DATA FROM SERVER -------//
  Future<CustomResponse> getApi({
    @required String url,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
  }) async {
    try {
      if (params != null) {
        params.removeWhere(
          (key, value) => params[key] == null || params[key] == "",
        );
      }
      if (headers != null) {
        headers.addAll(_header());
      } else {
        headers = _header();
      }
      Response response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: params,
      );

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: response.data["message"] ?? "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------ GET DATA FROM SERVER -------//
  Future<CustomResponse> getFromServer({
    @required String url,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
  }) async {
    try {
      if (params != null) {
        params.removeWhere(
          (key, value) => params[key] == null || params[key] == "",
        );
      }
      if (headers != null) {
        headers.addAll(_header());
      } else {
        headers = _header();
      }

      print("==========>>>>>>>>>>>>> headers : $headers");
      print("url == > $url");
      Response response = await dio.get(
        "$BASE_URL/$url",
        options: Options(
          headers: headers,
        ),
        queryParameters: params,
      );
      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------ Download DATA FROM SERVER -------//

  Future<CustomResponse> downloadFromServer({
    @required String url,
    @required String path,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
  }) async {
    if (headers != null) {
      headers.addAll(_header());
    } else {
      headers = _header();
    }
    try {
      CancelToken cancelToken = CancelToken();
      Response response = await dio.download(url, path,
          cancelToken: cancelToken, onReceiveProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      });

      print("response from download =-=-=> ${response.data.toString()}");

      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        error: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // -------- HANDLE ERROR ---------//
  CustomResponse handleServerError(DioError err) {
    print(err.response.data);
    if (err.response == null) {
      // PLEASE CHECK YOUR NETWORK CONNECTION .
      return CustomResponse(
        success: false,
        errType: 0,
        msg: "Please Check Your network Connection.",
        error: null,
        response: null,
        statusCode: 0,
      );
    } else if (err.response.statusCode == 401) {
      // FlashHelper.errorBar(message: "you are not logedin");
      // UserHelper.logout();
      // pushAndRemoveUntil(SchoolDetilesPage());
      return CustomResponse(
        success: false,
        statusCode: 0,
        errType: 2,
        msg: "login firist",
        error: null,
        response: null,
      );
    } else if (err.response.data["exception"] == null &&
        err.type == DioErrorType.RESPONSE) {
      log.error(err.response.data.toString());
      return CustomResponse(
        success: false,
        statusCode: err.response.statusCode,
        errType: 1,
        msg: "Please cheack these errors and try again.",
        error: err.response.data["message"],
        response: err.response,
      );
    } else if (err.type == DioErrorType.values.first) {
      print("xcxcxcxcxcxcxcxcxcxcxcxcxcxcx${DioErrorType.values.first}");
      print("print error =>>> ${err.error}");
      print("print error =>>> ${err.message}");
      return CustomResponse(
        success: false,
        statusCode: err.response.statusCode,
        errType: 2,
        msg: "Server Error, Please try again later.",
        error: null,
        response: null,
      );
    } else {
      print("xcxcxcxcxcxcxcxcxcxcxcxcxcxcx${DioErrorType.values.first}");
      return CustomResponse(
        success: false,
        statusCode: 0,
        errType: 2,
        msg: "Server Error, Please try again later.",
        error: null,
        response: null,
      );
    }
  }
}

class CustomApiInterceptor extends Interceptor {}

class CustomResponse {
  bool success;
  int errType;
  // 0 => network error
  // 1 => error from the server
  // 2 => other error
  String msg;
  int statusCode;
  Response response;
  dynamic error;

  CustomResponse({
    this.success,
    this.errType,
    this.msg,
    this.statusCode,
    this.response,
    this.error,
  });
}

class CustomError {
  int type;
  String msg;
  dynamic error;

  CustomError({
    this.type,
    this.msg,
    this.error,
  });
}
