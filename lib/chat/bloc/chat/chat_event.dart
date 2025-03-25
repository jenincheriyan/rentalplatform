import 'package:equatable/equatable.dart';
import 'package:rental_platform/chat/models/ChatModel.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateChat extends ChatEvent {
  final ChatModel chatModel;

  CreateChat({required this.chatModel});

  @override
  List<Object> get props => [chatModel];  // ✅ Ensure it's included in props
}

class LoadChats extends ChatEvent {
  @override
  List<Object> get props => [];
}
