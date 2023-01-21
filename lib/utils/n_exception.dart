import 'package:dio/dio.dart';

class NException implements Exception {
  late String message;
  NException(e) {
    if (e is String)
      this.message = e;
    else if (e is DioError && e.response == null)
      this.message = "Sorry, we are unable to connect to internet at this time.";
    else {
      switch (e.response.statusCode) {
        case 404:
          this.message = "Sorry, no data were found.";
          break;
        case 502:
          this.message = "Sorry, the server is temporary unavailable.";
          break;
        case 500:
          this.message = "The server is currently down, please try again later.";
          break;
        default:
          this.message = "An unknown error occured.";
      }
    }
  }
}
