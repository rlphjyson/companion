part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ChatGenerateNewTextMessageEvent extends ChatEvent {
  final String inputMessage;
  final InlineData? inlineData;

  ChatGenerateNewTextMessageEvent(
      {required this.inputMessage, this.inlineData});
}
