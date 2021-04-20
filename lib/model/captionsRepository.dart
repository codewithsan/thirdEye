import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:third_eye/model/captionsModel.dart';
import 'package:http/http.dart' as http;
import 'package:third_eye/util/config.dart';
import 'package:third_eye/util/enum.dart';

class CaptionsRepository {
  static Future<Captions> describeImage(XFile file, ImageType imageType) async {
    var url = Uri.https(
        URL, imageType == ImageType.image ? DESCRIBE_ENDPOINT : OCR_ENDPOINT);
    String fileName = file.name;
    String imagePath = file.path;
    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Ocp-Apim-Subscription-Key": API_KEY
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
        if (imageType == ImageType.document)
          return Captions(text: getTextFromOcrResponse(jsonMap), confidence: 1);
        return Captions.fromJson(jsonMap["description"]["captions"][0]);
      }
      return Captions(text: jsonMap["message"], confidence: 0);
    } catch (e) {
      print("from repo" + e.toString());
    }
    return Captions(text: "Some error occured", confidence: 0);
  }
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
