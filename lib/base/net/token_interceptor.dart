import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'api_result_exception.dart';

class TokenInterceptor extends Interceptor {
  final String token = "b3dd4d05-0ada-4ce0-8a7d-03713679d450";


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    //https://api.apiopen.top/api/getHaoKanVideo?page=0&size=20
    //由于好看视频api不需要token啥的，可以直接访问，不需要另外添加header
    /*options.baseUrl = "https://api.vmeshou.com/";
    options.headers = {
      "Authorization": "Bearer $token",
      "client_id": "vlook-android",
      "client_secret": "FoRpyL8UCYuddiLA",
      "Content-Type": "application/json;charset=UTF-8",
      "Connection": "close",
    };*/
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.type == DioErrorType.connectTimeout) {
      Fluttertoast.showToast(msg: "连接超时,请稍后再试!");
    } else if (err.type == DioErrorType.receiveTimeout) {
      Fluttertoast.showToast(msg: "接收超时,请稍后再试!");
    } else if (err.type == DioErrorType.sendTimeout) {
      Fluttertoast.showToast(msg: "发送超时,请稍后再试!");
    } else if (err.type == DioErrorType.response) {
      Response? response = err.response;
      if (response != null) {
        var statusCode = response.statusCode;
        if (statusCode == 404) {
          Fluttertoast.showToast(msg: "404,请检查访问路径!");
        }
        return;
      }
      Fluttertoast.showToast(msg: "服务器繁忙,请稍后再试!");
    } else if (err.type == DioErrorType.other) {
      var otherError = err.error;
      if (otherError != null) {
        if (otherError is ApiResultException) {
          ApiResultException resultException = otherError;
          if (resultException.code == 401||resultException.code=="401") {
            //todo 退出登录
            Fluttertoast.showToast(msg: "401身份认证过期,请重新登录");
           /* var channel= const MethodChannel(Constants.methodChannel);
            channel.invokeMethod("needLogin");*/
            return;
          }
          Fluttertoast.showToast(msg: resultException.message);
        }else if(otherError is SocketException){
          Fluttertoast.showToast(msg: "网络连接异常,请检查网络设置");
        }
      }
    }else{
      Fluttertoast.showToast(msg: err.message);
    }
  }
}
