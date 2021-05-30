
class CustomException implements Exception {

  final _message;

  final _prefix;



  CustomException([this._message, this._prefix]);



  String toString() {

    return "$_prefix$_message";

  }

}



class FetchDataException extends CustomException {

  FetchDataException([String message])

      : super(message, "Erreur pendant la communication avec nos services ");

}



class BadRequestException extends CustomException {

  BadRequestException([message]) : super(message, "Invalid Request: ");

}



class UnauthorisedException extends CustomException {

  UnauthorisedException([message]) : super(message, "Unauthorised: ");

}



class InvalidInputException extends CustomException {

  InvalidInputException([String message]) : super(message, "Invalid Input: ");

}