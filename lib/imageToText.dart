import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageToText {
  Future<String> describeImage(XFile file) async {
    var url = Uri.https(
        "codewithsan.cognitiveservices.azure.com", "/vision/v3.0/ocr");
    String fileName = file.name;
    String imagePath = file.path;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Ocp-Apim-Subscription-Key": "cae20b0c96244b28b30775d9a9983cf4"
    };

    try {
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath(fileName, imagePath),
      );
      request.headers.addAll(headers);

      http.Response response =
          await http.Response.fromStream(await request.send());
      var jsonMap = json.decode(response.body);
      print(jsonMap.toString());
      if (response.statusCode == 200) {
        return getTextFromOcrResponse(jsonMap);
      }
      return "error";
    } catch (e) {
      print(e.toString());
    }
    return "error";
  }

  String getTextFromOcrResponse(var jsonResponse) {
    String text = "";
    if (jsonResponse != null && jsonResponse["regions"] != null) {
      for (var item in jsonResponse["regions"]) {
        for (var line in item["lines"]) {
          for (var word in line["words"]) {
            text = text + word["text"] + " ";
          }
        }
      }
    }
    return text;
  }
}
