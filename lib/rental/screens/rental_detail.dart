import 'package:rental_platform/rental/blocs/blocs.dart';
import 'package:rental_platform/rental/models/rental.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/rental/screens/HomeScreen.dart';

import 'rental_add_update.dart';
import '../../routes.dart';
import 'rental_list.dart';

class RentalDetail extends StatefulWidget {
  static const routeName = 'rentalDetail';
  final Rental rental;

  RentalDetail({required this.rental});

  @override
  _RentalDetailState createState() => _RentalDetailState();
}

class _RentalDetailState extends State<RentalDetail> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Property'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this property?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                if (widget.rental.sId != null) {
                  BlocProvider.of<RentalBloc>(context)
                      .add(RentalDelete(widget.rental.sId!));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (route) => false);
                }
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rental.address ?? "Rental Property"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).pushNamed(
              AddUpdateRental.routeName,
              arguments:
              RentalArguments(rental: widget.rental, edit: true),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showMyDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Title: ${widget.rental.address ?? "No Address"}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.rental.rentalImage != null && widget.rental.rentalImage!.isNotEmpty
                          ? Container(
                        width: double.infinity,
                        height: 200, // Fixed height for consistency
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200], // Background color while loading
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "http://127.0.0.1:3000/${widget.rental.rentalImage}",
                            fit: BoxFit.contain, // Ensures full image is visible
                            width: double.infinity, // Takes full width of container
                            height: 200, // Consistent height
                            errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Text('Image not available')),
                          ),
                        ),

                      )
                          : const Text('No Image Available'),
                      const SizedBox(height: 10),
                    ],
                  ),


                ),
                SizedBox(height: 10),
                Text(
                  'Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(widget.rental.date ?? "No Date Available"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
