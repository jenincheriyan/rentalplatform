import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/auth/bloc/login/login_bloc.dart';
import 'package:rental_platform/auth/bloc/signup/signup_bloc.dart';
import 'package:rental_platform/auth/data-provider/auth-data-provider.dart';
import 'package:rental_platform/auth/repository/authRepository.dart';
import 'package:rental_platform/chat/bloc/chat/chat_bloc.dart';
import 'package:rental_platform/chat/bloc/message/message_bloc.dart';
import 'package:rental_platform/chat/data_providers/chat-data-provider.dart';
import 'package:rental_platform/chat/repository/chat-repository.dart';
import 'package:rental_platform/rental/blocs/blocs.dart';
import 'package:rental_platform/rental/blocs/image/image_bloc.dart';
import 'package:rental_platform/rental/data_providers/rental-data-provider.dart';
import 'package:rental_platform/rental/repository/rental-repository.dart';
import 'package:rental_platform/routes.dart';
import 'package:rental_platform/bloc_observer.dart';
import 'screens/admin_dashboard.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter is initialized
  Bloc.observer = SimpleBlocObserver();

  final authenticationDataProvider = AuthenticationDataProvider();
  final authenticationRepository =
  AuthenticationRepository(dataProvider: authenticationDataProvider);

  final rentalRepository = RentalRepository(RentalDataProvider());
  final chatRepository = ChatRepository(dataProvider: ChatDataProvider());

  runApp(MyApp(
    authenticationRepository: authenticationRepository,
    rentalRepository: rentalRepository,
    chatRepository: chatRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final RentalRepository rentalRepository;
  final ChatRepository chatRepository;

  const MyApp({
    Key? key,
    required this.authenticationRepository,
    required this.rentalRepository,
    required this.chatRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LoginBloc(authenticationRepository: authenticationRepository),
        ),
        BlocProvider(
          create: (context) =>
              SignUpBloc(authenticationRepository: authenticationRepository),
        ),
        BlocProvider(
          create: (context) => RentalBloc(rentalRepository: rentalRepository),
        ),
        BlocProvider(
          create: (context) => ChatBloc(chatRepository: chatRepository),
        ),
        BlocProvider(
          create: (context) => MessageBloc(chatRepository: chatRepository),
        ),
        BlocProvider(
          create: (context) => ImageBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // ✅ Removes the DEBUG banner
        routes: {
          AdminDashboard.routeName: (context) => AdminDashboard(),
        },


        onGenerateRoute: AppRouter.generateRoute,

      ),
    );
  }
}
