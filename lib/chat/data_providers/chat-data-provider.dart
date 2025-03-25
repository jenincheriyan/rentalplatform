import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rental_platform/chat/models/ChatModel.dart';
import 'package:rental_platform/chat/models/MessageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rental_platform/auth/model/Auth.dart';
import 'package:http/http.dart' as http;

class ChatDataProvider {
  static final String _baseUrl = "http://127.0.0.1:3000/api/chat";
// static final String _baseUrl = "http://127.0.0.1:3000/api/user";

  // * Create chat
  Future<ChatModel> create(ChatModel chatModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    if (token == null) {
      throw Exception("No token found");
    } else {
      final Uri url = Uri.parse("$_baseUrl/createChat");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "auth-token": token
      };

      final Map<String, dynamic> body = {
        "user2Id": chatModel.user2Id,
      };

      print("🔵 Sending request to: $url");
      print("🟡 Headers: $headers");
      print("🟢 Body: $body");

      final http.Response response = await http.post(url,
          headers: headers, body: jsonEncode(body));

      print("🔴 Chat API Response: ${response.statusCode}");
      print("🟠 Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return ChatModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Chat creation failed: ${response.body}");
      }
    }
  }

  //* send messages
  Future<ChatModel> sendMessage(MessageModel messageModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');
    if (token == null) {
      throw Exception("No token found");
    } else {
      final http.Response response = await http.put(
          Uri.parse("$_baseUrl/sendMessage"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "auth-token": token
          },
          body: jsonEncode({
            "chatId": messageModel.chatId,
            "message": messageModel.message
          }));
      print("My response");
      print(response.statusCode);
      if (response.statusCode == 201) {
        print(response.statusCode);
        return ChatModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    }
  }

  Future<List<MessageModel>> loadMessages(String chatId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');
    if (token == null) {
      throw Exception("No token found");
    } else {
      try {
        final response = await http.get(
            Uri.parse("$_baseUrl/loadMessages/$chatId"),
            headers: <String, String>{"auth-token": token});
        print("asjdkalsdkasdjljadlk");
        print(response.statusCode);
        if (response.statusCode == 200) {
          final messages = jsonDecode(response.body) as List;
          print(messages.map((c) => MessageModel.fromJson(c)).toList());
          return messages.map((c) => MessageModel.fromJson(c)).toList();
        } else {
          print("Could not load chats");
          throw Exception("Could not load chats");
        }
      } catch (e) {
        throw Exception("Error");
      }
    }
  }

  Future<List<ChatModel>> loadChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');
    if (token == null) {
      throw Exception("No token found");
    } else {
      try {
        final response = await http.get(Uri.parse("$_baseUrl/loadChats"),
            headers: <String, String>{"auth-token": token});
        print(response.statusCode);
        if (response.statusCode == 200) {
          final chats = jsonDecode(response.body) as List;
          var q = chats.map((c) => ChatModel.fromJson(c)).toList();
          return chats.map((c) => ChatModel.fromJson(c)).toList();
        } else {
          print("Could not load chats");
          throw Exception("Could not load chats");
        }
      } catch (e) {
        throw Exception("Error");
      }
    }
  }
}