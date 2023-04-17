import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

String _basicAuth = 'Basic ${base64Encode(utf8.encode('Ali:ali12345'))}';

Map<String, String> mHeaders = {'authorization': _basicAuth};

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: mHeaders);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  postFileRequest(String url, Map data, File? file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var length = await file!.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile(
      "image",
      stream,
      length,
      filename: basename(file.path),
    );
    request.headers.addAll(mHeaders);
    request.files.add(multipartFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myRequest = await request.send();

    var response = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error ${myRequest.statusCode}");
    }
  }
}
