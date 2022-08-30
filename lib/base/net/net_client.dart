import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../generated/json/base/json_convert_content.dart';
import 'api_result_exception.dart';
import 'default_interceptor.dart';

class NetClient {
  late Dio _dio;
  static final NetClient _netClient = NetClient._internal();
  final DefaultInterceptor _defaultInterceptor = DefaultInterceptor();
  final LogInterceptor _logInterceptor = LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: true);

  NetClient._internal() {
    _dio = Dio();
    //默认配置
    _dio.options.connectTimeout = 30 * 1000;
    _dio.options.receiveTimeout = 30 * 1000;
    _dio.options.sendTimeout = 30 * 1000;
    _dio.interceptors.add(_defaultInterceptor);
    _dio.interceptors.add(_logInterceptor);
  }

  factory NetClient() {
    return _netClient;
  }

  void get<T>(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? extra,
      Map<String, dynamic>? headers,
      VoidCallback? onStart,
      ValueChanged<T>? onSuccess,
      VoidCallback? onComplete,
      ValueChanged<Exception>? onError}) {
    RequestOptions requestOptions = RequestOptions(
        path: url,
        method: "get",
        queryParameters: queryParameters,
        headers: headers,
        extra: extra);
    fetch(requestOptions,
        onStart: onStart,
        onSuccess: onSuccess,
        onComplete: onComplete,
        onError: onError);
  }

  void post<T>(String url,
      {dynamic data,
      Map<String, dynamic>? extra,
      Map<String, dynamic>? headers,
      VoidCallback? onStart,
      ValueChanged<T>? onSuccess,
      VoidCallback? onComplete,
      ValueChanged<Exception>? onError}) {

    RequestOptions requestOptions = RequestOptions(
        path: url, method: "post", data: data, headers: headers, extra: extra);

    fetch(
      requestOptions,
      onStart: onStart,
      onSuccess: onSuccess,
      onComplete: onComplete,
      onError: onError,
    );
  }

  void fetch<T>(RequestOptions requestOptions,
      {VoidCallback? onStart,
      ValueChanged<T>? onSuccess,
      VoidCallback? onComplete,
      ValueChanged<Exception>? onError}) async {
    if (onStart != null) {
      onStart();
    }
    Response? response;
    try {
      response = await _dio.fetch(requestOptions);
      var statusCode = response.statusCode;
      if (statusCode != null && statusCode == 200) {
        var data = response.data;
        if (data != null) {
          var extra = requestOptions.extra;
          var apiResultDataList=extra["api_result_data"];
          var apiResultCode=extra["api_result_code"];
          var apiResultMsg=extra["api_result_msg"];
          var apiResultCodeOkState=extra["api_result_code_ok_state"];

          //解析 code字段
          dynamic  respCode;
          for(String s in apiResultCode){
            respCode=data[s];
            if(respCode!=null){
              break;
            }
          }
          //解析 msg字段
          dynamic  respMsg;
          for(String s in apiResultMsg){
            respMsg=data[s];
            if(respCode!=null){
              break;
            }
          }

          //解析 data字段
          dynamic  responseData;
          for(String s in apiResultDataList){
            responseData=data[s];
            if(responseData!=null){
              break;
            }
          }

          //解析返回成功状态码
          bool isOk=false;
          for(String s in apiResultCodeOkState){
            if(respCode.toString()==s){
              isOk=true;
              break;
            }
          }

          if (!isOk) {
            var are = ApiResultException(respMsg);
            are.code = respCode;
            throw are;
          } else {
            T? t = JsonConvert.fromJsonAsT<T>(responseData);
            if (t == null) {
              if (onComplete != null) {
                onComplete();
              }
            } else {
              if (onSuccess != null) {
                onSuccess(t);
              }
            }
          }

        } else {
          throw ApiResultException("response data is null");
        }
      } else {
        throw Exception(response.statusMessage);
      }
    } on Exception catch (e) {
      //单独处理异常
      if (onError != null) {
        onError(e);
      } else {
        //统一处理异常
        DioError dioError = DioError(
            requestOptions: requestOptions, response: response, error: e);
        _defaultInterceptor.onError(dioError, ErrorInterceptorHandler());
      }
    }
  }
}
