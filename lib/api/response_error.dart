class ResponseError {
  String message;
  ErrorType type;

  ResponseError({
    required this.message,
    required this.type,
  });
}

enum ErrorType { server, unauthorized, connection, custom, other }
