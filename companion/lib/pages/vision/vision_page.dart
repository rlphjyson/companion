import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:companion/bloc/chat_bloc.dart';
import 'package:companion/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VisionPage extends StatefulWidget {
  const VisionPage({super.key});

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  final chatBloc = ChatBloc();
  TextEditingController textController = TextEditingController();
  String imgb64 = '';
  final FlutterTts _flutterTts = FlutterTts();
  bool _initialMessagesRemoved = false;
  String selectedImagePath = '';
  bool speaked = false;
  bool micMode = true;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordSpoken = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    initSpeech();
    chatBloc.add(ChatGenerateNewTextMessageEvent(
        inputMessage:
            "keep your response short, circa one paragraph. If I asked you to read the content of an image, do not summarize it, read the whole content"));
    super.initState();
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void initTTS() {
    _flutterTts.setVoice({"name": "en-US-language", "locale": "en-US"});
    setState(() {});
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: Duration(seconds: 30), // Set a maximum listening duration
      pauseFor: Duration(seconds: 5),
    );

    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordSpoken = "${result.recognizedWords}";
    });
  }

  void _stopListening() async {
    await _speechToText.stop();

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              if (messages.isNotEmpty && messages.length > 1) {
                messages = messages.sublist(2);

                _initialMessagesRemoved = true;
              }
              if (_initialMessagesRemoved && messages.isNotEmpty) {
                if (messages.last.role != 'user' && speaked) {
                  if (micMode) {
                    _flutterTts.speak(messages.last.parts.first.text ?? '');
                  }
                  speaked = false;
                  _scrollToBottom();
                }
              }

              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(143, 23, 105, 182)),
                      child: Row(
                        children: [
                          const Text(
                            'Input Mode: ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            micMode ? "Voice" : "Chat",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            width: 80.0,
                            height: 40.0,
                            toggleSize: 45.0,
                            value: micMode,
                            borderRadius: 30.0,
                            padding: 2.0,
                            activeToggleColor: Color(0xFF6E40C9),
                            inactiveToggleColor: Color(0xFF2F363D),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFF3C1E70),
                              width: 6.0,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFD1D5DA),
                              width: 6.0,
                            ),
                            activeColor: Color(0xFF271052),
                            inactiveColor: Colors.white,
                            activeIcon: const Icon(
                              Icons.mic,
                              color: Color(0xFFF8E3A1),
                            ),
                            inactiveIcon: const Icon(
                              Icons.chat,
                              color: Color(0xFFFFDF5D),
                            ),
                            onToggle: (val) {
                              setState(() {
                                micMode = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    _initialMessagesRemoved
                        ? Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: messages[index].role ==
                                                    'user'
                                                ? Colors.blue.withOpacity(0.2)
                                                : Colors.yellow
                                                    .withOpacity(0.2)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (messages[index]
                                                    .parts
                                                    .first
                                                    .inlineData !=
                                                null)
                                              Image.memory(const Base64Decoder()
                                                  .convert(messages[index]
                                                      .parts
                                                      .first
                                                      .inlineData!
                                                      .data)),
                                            Text(
                                              messages[index].role == 'user'
                                                  ? 'User'
                                                  : 'Gemini',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              messages[index].parts.first.text!,
                                              textAlign: TextAlign.start,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        )),
                                  );
                                }))
                        : const Expanded(child: SizedBox()),
                    if (micMode && _speechEnabled)
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 20, right: 20, top: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Center(
                                  child: Text(
                                _speechToText.isListening
                                    ? " listening..."
                                    : _speechEnabled
                                        ? "Hold the mic button to start speaking"
                                        : "Mic is not Available",
                                style: const TextStyle(fontSize: 16),
                              )),
                            ),
                            if (_wordSpoken.isNotEmpty)
                              Container(
                                height: 100,
                                padding: EdgeInsets.all(5),
                                width: double.infinity,
                                child: Text(
                                  _wordSpoken,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                          ],
                        ),
                      ),
                    if (imgb64.isNotEmpty && selectedImagePath.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 50,
                          shadowColor: Colors.black,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 300,
                              child: Image.file(
                                File(
                                    selectedImagePath), // You can access it with . operator and path property
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (micMode)

                      ///MIC MODE
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 210,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? file = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (file != null) {
                                      //convert img to base64 add inlineData
                                      selectedImagePath = file.path;
                                      Uint8List img =
                                          File(file.path).readAsBytesSync();
                                      setState(() {
                                        imgb64 = base64.encode(img);
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue),
                                    height: 85,
                                    child: const Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: InkWell(
                                  onTap: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? file = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if (file != null) {
                                      //convert img to base64 add inlineData
                                      selectedImagePath = file.path;
                                      Uint8List img =
                                          File(file.path).readAsBytesSync();
                                      setState(() {
                                        imgb64 = base64.encode(img);
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green),
                                    height: 85,
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onLongPressStart: (details) {
                                _startListening();
                              },
                              onLongPressEnd: (details) {
                                Future.delayed(const Duration(seconds: 2), () {
                                  _stopListening();
                                  if (_wordSpoken.isNotEmpty) {
                                    String text = _wordSpoken;

                                    if (imgb64.isNotEmpty) {
                                      InlineData inlineData = InlineData(
                                          mimeType: "image/png", data: imgb64);
                                      chatBloc.add(
                                          ChatGenerateNewTextMessageEvent(
                                              inlineData: inlineData,
                                              inputMessage: text));
                                    } else {
                                      chatBloc.add(
                                          ChatGenerateNewTextMessageEvent(
                                              inputMessage: text));
                                    }
                                    imgb64 = '';
                                    speaked = true;
                                    _wordSpoken = '';
                                  }
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red),
                                height: 85,
                                child: const Icon(
                                  Icons.mic,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else

                      ///CHAT MODE
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: textController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ),
                            )),

                            // camera
                            InkWell(
                              onTap: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? file = await picker.pickImage(
                                    source: ImageSource.camera);
                                if (file != null) {
                                  //convert img to base64 add inlineData
                                  selectedImagePath = file.path;
                                  Uint8List img =
                                      File(file.path).readAsBytesSync();
                                  setState(() {
                                    imgb64 = base64.encode(img);
                                  });
                                }
                              },
                              child: const SizedBox(
                                height: 50,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.green,
                                  child: Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //gallery
                            InkWell(
                              onTap: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? file = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (file != null) {
                                  //convert img to base64 add inlineData
                                  selectedImagePath = file.path;
                                  Uint8List img =
                                      File(file.path).readAsBytesSync();
                                  setState(() {
                                    imgb64 = base64.encode(img);
                                  });
                                }
                              },
                              child: const SizedBox(
                                height: 50,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (textController.text.isNotEmpty) {
                                  String text = textController.text;
                                  textController.clear();
                                  if (imgb64.isNotEmpty) {
                                    InlineData inlineData = InlineData(
                                        mimeType: "image/png", data: imgb64);
                                    chatBloc.add(
                                        ChatGenerateNewTextMessageEvent(
                                            inlineData: inlineData,
                                            inputMessage: text));
                                  } else {
                                    chatBloc.add(
                                        ChatGenerateNewTextMessageEvent(
                                            inputMessage: text));
                                  }
                                  imgb64 = '';
                                  speaked = true;
                                }
                              },
                              child: const SizedBox(
                                height: 50,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.red,
                                  child: Center(
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
