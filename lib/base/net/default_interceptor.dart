import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'api_result_exception.dart';

class DefaultInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    //同一个项目可以解析任意种 api json 字段返回形式,比如：
    //{"code":200,"message":"成功!","result":..}
    //{"resp_code":0,"resp_msg":"成功!","datas":..}
    var extra={
      "api_result_data":["result","datas"],
      "api_result_code":["code","resp_code"],
      "api_result_msg":["message","resp_msg"],
      "api_result_code_ok_state":["0","200"],
    };
    options.extra.addAll(extra);

  }


  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.type == DioErrorType.cancel) {
      Fluttertoast.showToast(msg: "连接取消!");
    }else if (err.type == DioErrorType.connectTimeout) {
      Fluttertoast.showToast(msg: "连接超时,请稍后再试!");
    } else if (err.type == DioErrorType.receiveTimeout) {
      Fluttertoast.showToast(msg: "接收超时,请稍后再试!");
    } else if (err.type == DioErrorType.sendTimeout) {
      Fluttertoast.showToast(msg: "发送超时,请稍后再试!");
    } else if (err.type == DioErrorType.response) {
      Response? response = err.response;
      if (response != null) {
        var statusCode = response.statusCode;
        if (statusCode == 401) {
          Fluttertoast.showToast(msg: "401身份认证过期,请重新登录");
        }else if (statusCode == 404) {
          Fluttertoast.showToast(msg: "404,请检查访问路径!");
        }
        return;
      }
      Fluttertoast.showToast(msg: "服务器繁忙,请稍后再试!${err.message}");
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
