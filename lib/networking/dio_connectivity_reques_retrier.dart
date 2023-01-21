import 'dart:async';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;
  //final Connectivity connectivity;

  DioConnectivityRequestRetrier(
      {required this.dio, /*@required this.connectivity*/});

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    return new Response(requestOptions: RequestOptions(path: ''));
    /*StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();
    streamSubscription =
        //connectivity.onConnectivityChanged.listen((connectivityResult) {
      //if (connectivityResult != ConnectivityResult.none) {
        //streamSubscription.cancel();
        responseCompleter.complete(dio.request(requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
            queryParameters: requestOptions.queryParameters,
            options: requestOptions));
     // }
    });
    return responseCompleter.future;*/
  }
}
