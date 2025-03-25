import 'package:rental_platform/rental/data_providers/rental-data-provider.dart';
import 'package:rental_platform/rental/models/rental.dart';

class RentalRepository {
  final RentalDataProvider dataProvider;

  RentalRepository(this.dataProvider);

  Future<int> create(Rental rental) async {
    print("Creating rental in repository...");
    try {
      return await dataProvider.create(rental);
    } catch (e) {
      print("Error creating rental: $e");
      return Future.error("Failed to create rental.");
    }
  }

  Future<int> update(String id, Rental rental) async {
    print("Updating rental: $id");
    try {
      return await dataProvider.update(id, rental);
    } catch (e) {
      print("Error updating rental: $e");
      return Future.error("Failed to update rental.");
    }
  }

  Future<List<Rental>> viewAll() async {
    try {
      return await dataProvider.viewAll();
    } catch (e) {
      print("Error fetching rentals: $e");
      return Future.error("Failed to fetch rentals.");
    }
  }

  Future<List<Rental>> viewMyProperties() async {
    try {
      return await dataProvider.viewMyProperties();
    } catch (e) {
      print("Error fetching user properties: $e");
      return Future.error("Failed to fetch properties.");
    }
  }

  Future<void> delete(String id) async {
    print("Deleting rental: $id");
    try {
      await dataProvider.delete(id);
      print("Rental deleted successfully.");
    } catch (e) {
      print("Error deleting rental: $e");
      return Future.error("Failed to delete rental.");
    }
  }
}
