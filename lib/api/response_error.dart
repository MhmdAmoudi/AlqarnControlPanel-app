class ResponseError {
  String error;
  ErrorType type;

  ResponseError({
    required this.error,
    required this.type,
  });
}

enum ErrorType { server, unauthorized, connection, custom, other }
