import 'dart:developer';

import 'package:companion/constants.dart';
import 'package:companion/models/chat_message_model.dart';
import 'package:dio/dio.dart';

class ChatRepository {
  static Future<String> chatTextGenerationRepo(
      List<ChatMessageModel> previousMessages) async {
    Dio dio = Dio();
    try {
      print({
        "contents": previousMessages.map((e) => e.toJson()).toList(),
        "generationConfig": {
          "temperature": 1,
          "topK": 64,
          "topP": 0.95,
          "maxOutputTokens": 8192,
          "responseMimeType": "text/plain"
        },
      });
      final response = await dio.post(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}",
          data: {
            "contents": previousMessages.map((e) => e.toJson()).toList(),
            "generationConfig": {
              "temperature": 1,
              "topK": 64,
              "topP": 0.95,
              "maxOutputTokens": 8192,
              "responseMimeType": "text/plain"
            },
          });
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        log(response.data.toString());
        return response
            .data['candidates'].first['content']['parts'].first['text'];
      }
      return '';
    } catch (e) {
      log(e.toString());
      return '';
    }
  }
}
