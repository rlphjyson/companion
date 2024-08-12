import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:companion/models/chat_message_model.dart';
import 'package:companion/repository/chat_repository.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }
  List<ChatMessageModel> messages = [];
  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    if (event.inlineData != null) {
      messages.add(ChatMessageModel(role: "user", parts: [
        ChatPartModel(inlineData: event.inlineData, text: event.inputMessage)
      ]));
      print(event.inlineData!.data);
    } else {
      messages.add(ChatMessageModel(
          role: "user", parts: [ChatPartModel(text: event.inputMessage)]));
    }

    emit(ChatSuccessState(messages: messages));
    String generatedText =
        await ChatRepository.chatTextGenerationRepo(messages);
    if (generatedText.length > 0) {
      messages.add(ChatMessageModel(
          role: 'model', parts: [ChatPartModel(text: generatedText)]));
      emit(ChatSuccessState(messages: messages));
    }
  }
}
