import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/rental/blocs/blocs.dart';
import 'package:rental_platform/rental/screens/rental_detail_noedit.dart';
import 'rental_add_update.dart';
import 'rental_detail.dart';
import '../../routes.dart';

class RentalListAll extends StatefulWidget {
  static const routeName = 'rentalListAll';
  final bool loggedIn;

  const RentalListAll({Key? key, this.loggedIn = true}) : super(key: key);

  @override
  _RentalListAllState createState() => _RentalListAllState();
}

class _RentalListAllState extends State<RentalListAll> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RentalBloc>(context).add(RentalLoadAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.loggedIn
            ? Container()
            : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('All Gadgets'),
      ),
      body: BlocBuilder<RentalBloc, RentalState>(
        builder: (_, state) {
          if (state is RentalOperationSuccess) {
            final rentals = state.rentals;

            return ListView.builder(
              itemCount: rentals.length,
              itemBuilder: (_, idx) {
                final rental = rentals.elementAt(idx);
                final String? imagePath = rental.rentalImage;

                Widget imageWidget;

                if (imagePath == null || imagePath.isEmpty) {
                  imageWidget = const Center(
                      child: Text("No image available",
                          style: TextStyle(color: Colors.grey)));
                } else if (imagePath.startsWith("http") ||
                    imagePath.startsWith("https")) {
                  imageWidget = _buildImage(imagePath);
                } else if (File(imagePath).existsSync()) {
                  imageWidget = _buildImage(File(imagePath).path, isFile: true);
                } else {
                  imageWidget =
                      _buildImage("http://127.0.0.1:3000/$imagePath");
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  elevation: 3,
                  child: ListTile(
                    key: const ValueKey("singlerental"),
                    contentPadding: const EdgeInsets.all(8), // Adjust padding
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 60, // Adjust width as needed
                            height: 60, // Ensure consistent height
                            child: imageWidget, // Image widget
                          ),
                        ),
                        const SizedBox(width: 12), // Space between image and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rental.address,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text("Tap to view details", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      print(rental);
                      print(widget.loggedIn);
                      if (widget.loggedIn) {
                        Navigator.of(context).pushNamed(
                          RentalDetailNoEdit.routeName,
                          arguments: rental,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalDetailNoEdit(
                              rental: rental,
                              loggedIn: false,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );



              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  /// Helper function to build images with proper size and fit
  Widget _buildImage(String imagePath, {bool isFile = false}) {
    return Container(
      height: 180, // Fixed height
      width: double.infinity, // Full width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200], // Background color while loading
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isFile
            ? Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
        )
            : Image.network(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print("Image error: $error");
            return const Center(
              child: Text(
                "Image failed to load",
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}