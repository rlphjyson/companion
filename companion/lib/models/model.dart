// class Content {
//   String role;
//   List<Part> parts;

//   Content({
//     required this.role,
//     required this.parts,
//   });

//   factory Content.fromJson(Map<String, dynamic> json) => Content(
//         role: json["role"],
//         parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "role": role,
//         "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
//       };
// }

// class Part {
//   InlineData? inlineData;
//   String? text;

//   Part({
//     this.inlineData,
//     this.text,
//   });

//   factory Part.fromJson(Map<String, dynamic> json) => Part(
//         inlineData: json["inlineData"] == null
//             ? null
//             : InlineData.fromJson(json["inlineData"]),
//         text: json["text"],
//       );

//   Map<String, dynamic> toJson() => {
//         "inlineData": inlineData?.toJson(),
//         "text": text,
//       };
// }

// class InlineData {
//   String mimeType;
//   String data;

//   InlineData({
//     required this.mimeType,
//     required this.data,
//   });

//   factory InlineData.fromJson(Map<String, dynamic> json) => InlineData(
//         mimeType: json["mimeType"],
//         data: json["data"],
//       );

//   Map<String, dynamic> toJson() => {
//         "mimeType": mimeType,
//         "data": data,
//       };
// }

// class GenerationConfig {
//   int temperature;
//   int topK;
//   double topP;
//   int maxOutputTokens;
//   String responseMimeType;

//   GenerationConfig({
//     required this.temperature,
//     required this.topK,
//     required this.topP,
//     required this.maxOutputTokens,
//     required this.responseMimeType,
//   });

//   factory GenerationConfig.fromJson(Map<String, dynamic> json) =>
//       GenerationConfig(
//         temperature: json["temperature"],
//         topK: json["topK"],
//         topP: json["topP"]?.toDouble(),
//         maxOutputTokens: json["maxOutputTokens"],
//         responseMimeType: json["responseMimeType"],
//       );

//   Map<String, dynamic> toJson() => {
//         "temperature": temperature,
//         "topK": topK,
//         "topP": topP,
//         "maxOutputTokens": maxOutputTokens,
//         "responseMimeType": responseMimeType,
//       };
// }

class ChatMessageModel {
  String role;
  List<ChatPartModel> parts;

  ChatMessageModel({required this.role, required this.parts});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: json['role'],
      parts: List<ChatPartModel>.from(
          json['parts'].map((x) => ChatPartModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'parts': List<dynamic>.from(parts.map((x) => x.toJson())),
    };
  }
}

class ChatPartModel {
  InlineData? inlineData;
  String? text;

  ChatPartModel({this.inlineData, this.text});

  factory ChatPartModel.fromJson(Map<String, dynamic> json) {
    return ChatPartModel(
      inlineData: json['inlineData'] != null
          ? InlineData.fromJson(json['inlineData'])
          : null,
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    if (inlineData != null) {
      return {'inlineData': inlineData!.toJson()};
    } else if (text != null) {
      return {'text': text};
    }
    return {};
  }
}

class InlineData {
  String mimeType;
  String data;

  InlineData({required this.mimeType, required this.data});

  factory InlineData.fromJson(Map<String, dynamic> json) {
    return InlineData(
      mimeType: json['mimeType'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mimeType': mimeType,
      'data': data,
    };
  }
}
