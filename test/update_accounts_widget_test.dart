import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_platform/auth/bloc/login/login_bloc.dart';
import 'package:rental_platform/auth/data-provider/auth-data-provider.dart';
import 'package:rental_platform/auth/repository/authRepository.dart';
import 'package:rental_platform/auth/screens/update_account.dart';

import 'package:rental_platform/rental/blocs/blocs.dart';
import 'package:rental_platform/rental/blocs/image/image_bloc.dart';
import 'package:rental_platform/rental/data_providers/rental-data-provider.dart';
import 'package:rental_platform/rental/repository/rental-repository.dart';
import 'package:rental_platform/rental/screens/rental_add_update.dart';
import 'package:rental_platform/routes.dart';

void main() {
  testWidgets('update account widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (context) => LoginBloc(
            authenticationRepository: AuthenticationRepository(
                dataProvider: AuthenticationDataProvider())),
        child: UpdateAccount(),
      ),
    ));

    var nameField = find.byIcon(Icons.person);
    expect(nameField, findsOneWidget);
    print(nameField);

    var emailField = find.byIcon(Icons.email);
    expect(emailField, findsOneWidget);

    var passwordField = find.byIcon(Icons.security);
    expect(passwordField, findsOneWidget);

    var phoneNumberField = find.byIcon(Icons.phone);

    expect(phoneNumberField, findsOneWidget);

    var updateButton = find.text("Update");
    expect(updateButton, findsOneWidget);
  });
}
