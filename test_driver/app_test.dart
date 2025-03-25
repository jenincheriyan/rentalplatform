// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  late FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    await driver.close();
  });

  group('View without login', () {
    final viewWithoutAccount = find.byValueKey("viewWithoutAccount");
    final singleRental = find.text('France');

    test("View posts without logging in", () async {
      await driver.tap(viewWithoutAccount);
      await driver.waitFor(find.text("All properties"));

      await driver.tap(singleRental);
      await driver.waitFor(find.text("Start chat"));

      await driver.tap(find.byType("Icon"));
      await driver.waitFor(find.text("All properties"));

      await driver.tap(find.byType("IconButton"));
    });
  });

  group('Login and signup', () {
    // Signup Fields
    final nameField = find.byValueKey('signupNameField');
    final emailField = find.byValueKey('signupEmailField');
    final phoneNumberField = find.byValueKey('signupPhoneNumberField');
    final passwordField = find.byValueKey('signupPasswordField');
    final signUpButton = find.byValueKey('signupButton');

    // Login Fields
    final loginEmailField = find.byValueKey('loginEmailField');
    final loginPasswordField = find.byValueKey('loginPasswordField');
    final loginButton = find.byValueKey('loginButton');
    final dontHaveAccount = find.byValueKey("dontHaveAccount");

    test("Sign up and login", () async {
      // Login Test
      await driver.tap(loginEmailField);
      await driver.enterText("squa@gmail.com");

      await driver.tap(loginPasswordField);
      await driver.enterText("password");

      await driver.tap(loginButton);
      await driver.waitFor(find.text("Login"));

      // Signup Test
      await driver.tap(dontHaveAccount);

      await driver.tap(nameField);
      await driver.enterText("IamGhost");

      await driver.tap(emailField);
      await driver.enterText("ghost@gmail.com");

      await driver.tap(phoneNumberField);
      await driver.enterText("0912322321");

      await driver.tap(passwordField);
      await driver.enterText("password");

      await driver.tap(signUpButton);
      await driver.waitFor(find.text("Login"));

      // Login after Signup
      await driver.tap(loginEmailField);
      await driver.enterText("ghost@gmail.com");

      await driver.tap(loginPasswordField);
      await driver.enterText("password");

      await driver.tap(loginButton);
      await driver.waitFor(find.text("Post"));
    });
  });

  group('Rental', () {
    test("Add rental", () async {
      await driver.tap(find.byType("FloatingActionButton"));
      await driver.waitFor(find.text("Add New property"));

      await driver.tap(find.byValueKey("address"));
      await driver.enterText("My home");

      await driver.tap(find.byValueKey("addImage"));
      await driver.waitFor(find.text("Add New property"));

      await driver.tap(find.byType("IconButton"));
      await driver.waitFor(find.byValueKey("Post"));
    });

    test("View posts", () async {
      await driver.tap(find.byValueKey("Home"));
      await driver.waitFor(find.text("All properties"));
      await driver.tap(find.text('France'));
    });
  });

  group('Chat', () {
    test("Start chat", () async {
      await driver.tap(find.text("Start chat"));
      await driver.waitFor(find.text("Post"));

      await driver.tap(find.byValueKey("Chats"));
      await driver.tap(find.text("IamGhost"));

      await driver.tap(find.byType("TextFormField"));
      await driver.enterText("Hello");

      await driver.tap(find.byValueKey("sendButton"));
      await driver.waitFor(find.text("Hello"));

      await driver.tap(find.byValueKey("backButton"));
      await driver.waitFor(find.text("Chats"));
    });
  });

  group('User Settings', () {
    test("Settings", () async {
      await driver.tap(find.byValueKey("Account"));
      await driver.waitFor(find.text("User Account"));

      await driver.tap(find.text("Update Account"));
      await driver.waitFor(find.text("Update"));

      await driver.tap(find.byValueKey("nameField"));
      await driver.enterText("IamGhosts");

      await driver.tap(find.byValueKey("emailField"));
      await driver.enterText("ghosts@gmail.com");

      await driver.tap(find.byValueKey("passwordField"));
      await driver.enterText("password");

      await driver.tap(find.byValueKey("phoneNumberField"));
      await driver.enterText("0000000000");

      await driver.tap(find.text('Update'));

      await driver.tap(find.byValueKey("Account"));
      await driver.tap(find.text("Delete Account"));
      await driver.tap(find.text('Yes'));
    });
  });
}
