import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/auth/bloc/login/login_bloc.dart';
import 'package:rental_platform/auth/bloc/login/login_state.dart';
import 'package:rental_platform/auth/bloc/login/login_event.dart';
import 'package:rental_platform/auth/model/Auth.dart';
import 'package:rental_platform/rental/screens/HomeScreen.dart';
import 'package:rental_platform/auth/screens/sign_up_view.dart';
import 'package:rental_platform/rental/screens/rental_listall.dart';

class LoginView extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _user = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay for better contrast
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Login Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocConsumer<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state is LoggedInState) {
                            return Text("Logged In", style: TextStyle(color: Colors.white));
                          } else if (state is LoginFailureState) {
                            return Text("${state.exception.toString().substring(10)}",
                                style: TextStyle(color: Colors.red));
                          }
                          return Text("WELCOME BRO",
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold));
                        },
                        listener: (_, state) {
                          if (state is LoggedInState) {
                            Navigator.of(context).pushNamed(HomeScreen.routeName);
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      _emailField(),
                      SizedBox(height: 10),
                      _passwordField(),
                      SizedBox(height: 20),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (_, state) {
                          if (state is LoginLoading) {
                            return CircularProgressIndicator();
                          }
                          return _loginButton();
                        },
                      ),
                      _showSignUpButton(context),
                      _viewWithoutAccount(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      key: const ValueKey("loginemailfield"),
      decoration: InputDecoration(
        icon: Icon(Icons.person, color: Colors.white),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter username';
        }
        if (value!.length < 6) {
          return 'Length too short';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _user["email"] = value!;
        });
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      key: const ValueKey("loginpasswordfield"),
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.security, color: Colors.white),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please enter password';
        }
        if (value!.length < 8) {
          return 'Length too short';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _user["password"] = value!;
        });
      },
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      key: const ValueKey("loginbutton"),
      onPressed: () async {
        final form = _formKey.currentState;
        if (form != null && form.validate()) {
          form.save();
          BlocProvider.of<LoginBloc>(context).add(UserLogin(
            authentication: Authentication(
              email: _user["email"],
              password: _user["password"],
            ),
          ));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: Text('Login', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _showSignUpButton(BuildContext context) {
    return TextButton(
      key: const ValueKey("donthaveanaccount"),
      child: Text('Don\'t have an account? Sign up.', style: TextStyle(color: Colors.white)),
      onPressed: () => Navigator.of(context).popAndPushNamed(SignUpView.routeName),
    );
  }

  Widget _viewWithoutAccount(BuildContext context) {
    return Column(
      children: [
        TextButton(
          key: const ValueKey("viewwithoutaccount"),
          child: Text('View without an account', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RentalListAll(loggedIn: false))),
        ),
        SizedBox(height: 10), // 🔹 Add some spacing
        TextButton(
          key: const ValueKey("adminpanelbutton"),
          child: Text('Go to Admin Panel', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.pushNamed(context, '/admin-login'); // 🔹 Navigate to Admin Panel
          },
        ),
      ],
    );
  }

}
