import 'package:rental_platform/rental/blocs/blocs.dart';
import 'package:rental_platform/rental/models/rental.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/chat/models/ChatModel.dart';
import 'package:rental_platform/chat/screens/chat_page.dart';
import 'package:rental_platform/chat/bloc/chat/chat_event.dart';
import 'package:rental_platform/chat/bloc/chat/chat_state.dart';
import 'package:rental_platform/chat/bloc/chat/chat_bloc.dart';
import 'package:rental_platform/rental/screens/HomeScreen.dart';

import 'rental_add_update.dart';
import '../../routes.dart';
import 'rental_list.dart';

class RentalDetailNoEdit extends StatelessWidget {
  static const routeName = 'rentalDetailNoedit';
  final Rental rental;
  final bool loggedIn;

  RentalDetailNoEdit({required this.rental, this.loggedIn = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${rental.address}'),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (ctx, state) {
          if (state is ChatCreated) {
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(  // Centering the entire content
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),  // Added padding inside the card
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,  // Vertical centering
                    crossAxisAlignment: CrossAxisAlignment.center, // Horizontal centering
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            'Title: ${rental.address}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: (rental.rentalImage ?? '').isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 16 / 9, // Adjust aspect ratio based on your image
                            child: Image.network(
                              "http://127.0.0.1:3000/${rental.rentalImage}",
                              width: double.infinity,
                              fit: BoxFit.contain, // Prevents stretching
                            ),
                          ),
                        )
                            : SizedBox.shrink(),

                      ),

                      SizedBox(height: 20),
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        rental.date ?? "",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (loggedIn) {
                              BlocProvider.of<ChatBloc>(context).add(CreateChat(
                                  chatModel: ChatModel(user2Id: rental.userId)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("You must login"),
                                duration: Duration(seconds: 2),
                              ));
                            }
                          },
                          child: Text("Start Chat"),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
