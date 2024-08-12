// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatMessageModel {
  final String role;
  final List<ChatPartModel> parts;

  ChatMessageModel({required this.role, required this.parts});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'parts': parts.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      role: map['role'] as String,
      parts: List<ChatPartModel>.from(
        (map['parts'] as List<int>).map<ChatPartModel>(
          (x) => ChatPartModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ChatPartModel {
  final String text;
  InlineData? inlineData;

  ChatPartModel({required this.text, this.inlineData});

  Map<String, dynamic> toMap() {
    if (inlineData?.data != null) {
      return {
        'text': text,
        'inlineData': inlineData?.toMap(),
      };
    } else {
      return {
        'text': text,
      };
    }
  }

  factory ChatPartModel.fromMap(Map<String, dynamic> map) {
    if (map['inlineData']['data'] != null) {
      return ChatPartModel(
        text: map['text'] ?? '',
        inlineData: map['inlineData'] != null
            ? InlineData.fromMap(map['inlineData'])
            : null,
      );
    } else {
      return ChatPartModel(
        text: map['text'] as String,
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory ChatPartModel.fromJson(String source) =>
      ChatPartModel.fromMap(json.decode(source));
}

class InlineData {
  String mimeType;
  String? data;

  InlineData({
    required this.mimeType,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'mimeType': mimeType,
      'data': data,
    };
  }

  factory InlineData.fromMap(Map<String, dynamic> map) {
    return InlineData(
      mimeType: map['mimeType'] ?? '',
      data: map['data'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory InlineData.fromJson(String source) =>
      InlineData.fromMap(json.decode(source));
}
// class ChatPartModel {
//   final String text;
//   ChatPartModel({
//     required this.text,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'text': text,
//     };
//   }

//   factory ChatPartModel.fromMap(Map<String, dynamic> map) {
//     return ChatPartModel(
//       text: map['text'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ChatPartModel.fromJson(String source) =>
//       ChatPartModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }
