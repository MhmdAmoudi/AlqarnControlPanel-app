import 'dart:convert';
import 'dart:io';

import '../api/api.dart';

Future<File> fileFromBytes({
  required String source,
  required String name,
}) async {
  return await File('${API.tempPath}/$name').writeAsBytes(
    base64Decode(source),
  );
}
