import 'package:dio/dio.dart';
import 'package:Fanga/networking/dio_connectivity_reques_retrier.dart';

class RetryOnAuthFailInterceptor extends Interceptor{
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnAuthFailInterceptor(this.requestRetrier);

/*@override
  Future onError(DioError err) async {
    if(_shouldRefresh(err)){
      try {
        return requestRetrier.scheduleRequestRetry(err.request);
      }catch(e){
        return e;
      }
    }
    return err;
  }
  bool _shouldRefresh(DioError err){
    return err.type  == DioErrorType.DEFAULT &&
    err.error != null &&
    err.error is SocketException;
  }*/
}