// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class ChatMessageModel {
//   final String role;
//   final List<ChatPartModel> parts;

//   ChatMessageModel({required this.role, required this.parts});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'role': role,
//       'parts': parts.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
//     return ChatMessageModel(
//       role: map['role'] as String,
//       parts: List<ChatPartModel>.from(
//         (map['parts'] as List<int>).map<ChatPartModel>(
//           (x) => ChatPartModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ChatMessageModel.fromJson(String source) =>
//       ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

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

// import 'dart:convert';

// class ChatMessageModel {
//   final String role;
//   final List<ChatPartModel> parts;

//   ChatMessageModel({required this.role, required this.parts});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'role': role,
//       'parts': parts.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
//     return ChatMessageModel(
//       role: map['role'] as String,
//       parts: List<ChatPartModel>.from(
//         (map['parts'] as List<int>).map<ChatPartModel>(
//           (x) => ChatPartModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory ChatMessageModel.fromJson(String source) =>
//       ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// class ChatPartModel {
//   final String text;
//   InlineData? inlineData;

//   ChatPartModel({required this.text, this.inlineData});

//   Map<dynamic, dynamic> toMap() {
//     if (inlineData?.data != null) {
//       return {
//         'inlineData': inlineData?.toMap(),
//         'text': text,
//       };
//     } else {
//       return {
//         'text': text,
//       };
//     }
//   }

//   factory ChatPartModel.fromMap(Map<String, dynamic> map) {
//     if (map['inlineData']['data'] != null) {
//       return ChatPartModel(
//         inlineData: map['inlineData'] != null
//             ? InlineData.fromMap(map['inlineData'])
//             : null,
//         text: map['text'] ?? '',
//       );
//     } else {
//       return ChatPartModel(
//         text: map['text'] as String,
//       );
//     }
//   }

//   String toJson() => json.encode(toMap());

//   factory ChatPartModel.fromJson(String source) =>
//       ChatPartModel.fromMap(json.decode(source));
// }

// class InlineData {
//   String? mimeType;
//   String? data;

//   InlineData({
//     this.mimeType,
//     this.data,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'mimeType': mimeType,
//       'data': data,
//     };
//   }

//   factory InlineData.fromMap(Map<String, dynamic> map) {
//     return InlineData(
//       mimeType: map['mimeType'],
//       data: map['data'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory InlineData.fromJson(String source) =>
//       InlineData.fromMap(json.decode(source));
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

// class ChatMessageModel {
//   String role;
//   List<ChatPartModel> parts;

//   ChatMessageModel({
//     required this.role,
//     required this.parts,
//   });

//   factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
//       ChatMessageModel(
//         role: json["role"],
//         parts: List<ChatPartModel>.from(
//             json["parts"].map((x) => ChatPartModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "role": role,
//         "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
//       };
// }

// class ChatPartModel {
//   InlineData? inlineData;
//   String? text;

//   ChatPartModel({
//     this.inlineData,
//     this.text,
//   });

//   factory ChatPartModel.fromJson(Map<String, dynamic> json) => ChatPartModel(
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


// class InlineData {
//   String mimeType;
//   String? data;

//   InlineData({
//     required this.mimeType,
//     required this.data,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'mimeType': mimeType,
//       'data': data,
//     };
//   }

//   factory InlineData.fromMap(Map<String, dynamic> map) {
//     return InlineData(
//       mimeType: map['mimeType'] ?? '',
//       data: map['data'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory InlineData.fromJson(String source) =>
//       InlineData.fromMap(json.decode(source));
// }
