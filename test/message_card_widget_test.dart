import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_platform/auth/bloc/login/login_bloc.dart';
import 'package:rental_platform/auth/data-provider/auth-data-provider.dart';
import 'package:rental_platform/auth/repository/authRepository.dart';
import 'package:rental_platform/auth/screens/update_account.dart';
import 'package:rental_platform/chat/Custom/MessageCard.dart';
import 'package:rental_platform/chat/bloc/chat/chat_bloc.dart';
import 'package:rental_platform/chat/data_providers/chat-data-provider.dart';
import 'package:rental_platform/chat/repository/chat-repository.dart';
import 'package:rental_platform/chat/screens/chat_page.dart';

import 'package:rental_platform/rental/blocs/blocs.dart';
import 'package:rental_platform/rental/blocs/image/image_bloc.dart';
import 'package:rental_platform/rental/data_providers/rental-data-provider.dart';
import 'package:rental_platform/rental/repository/rental-repository.dart';
import 'package:rental_platform/rental/screens/rental_add_update.dart';
import 'package:rental_platform/routes.dart';

void main() {
  testWidgets('Message card widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
          home: Scaffold(
        body: Center(
          child: MessageCard(
              message: "message",
              time: "timjkhkjhkhkjhkhkjkhke",
              senderName: "senderName"),
        ),
      )),
    );

    var text = find.byType(Text);
    expect(text, findsWidgets);
    var stack = find.byType(Stack);
    expect(stack, findsWidgets);
    var align = find.byType(Align);
    expect(align, findsOneWidget);
  });
}
