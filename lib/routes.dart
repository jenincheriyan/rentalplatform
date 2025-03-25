import 'package:rental_platform/auth/screens/login_view.dart';
import 'package:rental_platform/auth/screens/sign_up_view.dart';
import 'package:rental_platform/auth/screens/update_account.dart';
import 'package:rental_platform/chat/screens/chat_page.dart';
import 'package:rental_platform/chat/screens/message_page.dart';
import 'package:rental_platform/rental/models/rental.dart';
import 'package:flutter/material.dart';
import 'package:rental_platform/rental/screens/HomeScreen.dart';
import 'package:rental_platform/rental/screens/rental_detail_noedit.dart';
import 'package:rental_platform/rental/screens/rental_listall.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rental_platform/auth/screens/user_settings.dart';
import 'rental/screens/rental_add_update.dart';
import 'rental/screens/rental_detail.dart';
import 'rental/screens/rental_list.dart';
import 'package:rental_platform/auth/screens/admin_login.dart';
import 'package:rental_platform/admin/screens/admin_panel.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => LoginView());
    }

    if (settings.name == AdminPanelScreen.routeName) {
      return MaterialPageRoute(
        builder: (context) => FutureBuilder<bool>(
          future: _isAdminLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == true) {
              return AdminPanelScreen();
            } else {
              return AdminLogin();
            }
          },
        ),
      );
    }

    if (settings.name == AdminLogin.routeName) {
      return MaterialPageRoute(builder: (context) => AdminLogin());
    }

    if (settings.name == SignUpView.routeName) {
      return MaterialPageRoute(builder: (context) => SignUpView());
    }

    if (settings.name == HomeScreen.routeName) {
      return MaterialPageRoute(builder: (context) => HomeScreen());
    }

    if (settings.name == UpdateAccount.routeName) {
      return MaterialPageRoute(builder: (context) => UpdateAccount());
    }

    if (settings.name == UserSettingsScreen.routeName) {
      return MaterialPageRoute(builder: (context) => UserSettingsScreen());
    }

    if (settings.name == ChatPage.routeName) {
      return MaterialPageRoute(builder: (context) => ChatPage());
    }

    if (settings.name == IndividualPage.routeName) {
      ChatArguments args = settings.arguments as ChatArguments;
      return MaterialPageRoute(
        builder: (context) => IndividualPage(chatArguments: args),
      );
    }

    if (settings.name == AddUpdateRental.routeName) {
      RentalArguments args = settings.arguments as RentalArguments;
      return MaterialPageRoute(
        builder: (context) => AddUpdateRental(args: args),
      );
    }

    if (settings.name == RentalList.routeName) {
      return MaterialPageRoute(builder: (context) => RentalList());
    }

    if (settings.name == RentalListAll.routeName) {
      return MaterialPageRoute(builder: (context) => RentalListAll());
    }

    if (settings.name == RentalDetail.routeName) {
      Rental rental = settings.arguments as Rental;
      return MaterialPageRoute(
        builder: (context) => RentalDetail(rental: rental),
      );
    }

    if (settings.name == RentalDetailNoEdit.routeName) {
      Rental rental = settings.arguments as Rental;
      return MaterialPageRoute(
        builder: (context) => RentalDetailNoEdit(rental: rental),
      );
    }

    return null;
  }

  static Future<bool> _isAdminLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdminLoggedIn') ?? false;
  }
}

class RentalArguments {
  final Rental? rental;
  final bool edit;
  final bool? myProperty;
  RentalArguments({this.rental, required this.edit, this.myProperty});
}

class ChatArguments {
  final String chatId;
  final String user1Id;
  final String user2Id;
  final String user1Name;
  final String user2Name;
  List<dynamic>? messages;
  ChatArguments({
    required this.chatId,
    required this.user1Id,
    required this.user2Id,
    required this.user1Name,
    required this.user2Name,
    this.messages,
  });
}
