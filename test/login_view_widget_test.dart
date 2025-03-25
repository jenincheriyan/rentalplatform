import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_platform/auth/bloc/login/login_bloc.dart';
import 'package:rental_platform/auth/data-provider/auth-data-provider.dart';
import 'package:rental_platform/auth/repository/authRepository.dart';
import 'package:rental_platform/auth/screens/login_view.dart';
import 'package:rental_platform/chat/data_providers/chat-data-provider.dart';
import 'package:rental_platform/chat/repository/chat-repository.dart';
import 'package:rental_platform/main.dart';
import 'package:rental_platform/rental/data_providers/rental-data-provider.dart';
import 'package:rental_platform/rental/repository/rental-repository.dart';

void main() {
  testWidgets('Login view widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (context) => LoginBloc(
            authenticationRepository: AuthenticationRepository(
                dataProvider: AuthenticationDataProvider())),
        child: LoginView(),
      ),
    ));

    var emailField = find.byIcon(Icons.person);
    expect(emailField, findsOneWidget);

    var passwordField = find.byIcon(Icons.security);

    expect(passwordField, findsOneWidget);

    var loginButton = find.text("Login");
    expect(loginButton, findsOneWidget);

    
  });
}
