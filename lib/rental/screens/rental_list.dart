import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/rental/blocs/blocs.dart';
import 'rental_add_update.dart';
import 'rental_detail.dart';
import '../../routes.dart';

class RentalList extends StatefulWidget {
  static const routeName = 'rentalList';

  @override
  _RentalListState createState() => _RentalListState();
}

class _RentalListState extends State<RentalList> {
  bool hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<RentalBloc>(context).add(RentalLoadMyProperties());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('My Gadgets'),
      ),
      body: BlocBuilder<RentalBloc, RentalState>(
        builder: (_, state) {
          if (state is RentalOperationFailure && !hasError) {
            hasError = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Couldn't complete rental operation"),
                  duration: Duration(seconds: 2),
                ),
              );
            });
          }

          if (state is RentalOperationSuccess) {
            final rentals = state.rentals;

            if (rentals.isEmpty) {
              return const Center(
                  child: Text(
                    "You don't have any properties",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ));
            }

            return ListView.builder(
              itemCount: rentals.length,
              itemBuilder: (_, idx) {
                final rental = rentals.elementAt(idx);
                final String imageUrl =
                    "http://127.0.0.1:3000/${rental.rentalImage}";

                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RentalDetail.routeName,
                      arguments: rental,
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display Image with a fixed size
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: rental.rentalImage != null && rental.rentalImage!.isNotEmpty
                                ? Image.network(
                              imageUrl,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                                : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          ),
                          const SizedBox(width: 12), // Add spacing
                          // Display Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rental.address,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Tap to view details",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );


              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddUpdateRental.routeName,
            arguments: RentalArguments(edit: false),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Helper function to build images with proper size and fit
  Widget _buildImage(String imageUrl) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
          },
        ),
      ),
    );
  }
}
