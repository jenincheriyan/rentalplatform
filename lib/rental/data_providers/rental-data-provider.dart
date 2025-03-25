import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:rental_platform/rental/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentalDataProvider {
    static final String _baseUrl = "http://127.0.0.1:3000/api/rental";

    // * Create rental property
    Future<int> create(Rental rental) async {
        if (rental.rentalImage == null || rental.rentalImage!.isEmpty) {
            throw Exception("Rental image path is missing");
        }

        File rentalImage = File(rental.rentalImage!);
        if (!rentalImage.existsSync()) {
            throw Exception("File does not exist at path: ${rentalImage.path}");
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('auth-token');
        print("Stored Token: $token"); // Debugging print
        if (token == null) {
            throw Exception("No token found in SharedPreferences");
        }


        var request = http.MultipartRequest('POST', Uri.parse("$_baseUrl/add"));
        request.headers.addAll({
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token",  // Correct way to send the token
        });


        request.fields["address"] = rental.address ?? "";

        String filename = rentalImage.path.split('/').last;
        var file = await http.MultipartFile.fromPath(
            "rentalImage",
            rentalImage.path,
            filename: filename,
            contentType: MediaType('image', 'jpeg'),
        );

        request.files.add(file);
        var response = await request.send();

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${await response.stream.bytesToString()}");

        if (response.statusCode == 201) {
            return response.statusCode;
        } else {
            throw Exception("Failed to create property");
        }
    }


    // * View all properties
    Future<List<Rental>> viewAll() async {
        try {
            final response = await http.get(Uri.parse("$_baseUrl/viewAll"));
            if (response.statusCode == 200) {
                final rentals = jsonDecode(response.body) as List;
                return rentals.map((c) => Rental.fromJson(c)).toList();
            } else {
                print("Could not view all");
                throw Exception("Could not fetch properties");
            }
        } on SocketException {
            throw Exception("Couldn't find connection");
        }
    }
//viewMyProperties
    Future<List<Rental>> viewMyProperties() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('auth-token');

        if (token == null || token.isEmpty) {
            throw Exception("No valid token found");
        }

        print("Stored Token: $token");  // Debugging


        try {
            final response = await http.get(Uri.parse("$_baseUrl/viewMyProperties"),
                headers: <String, String>{ "Authorization": "Bearer $token"});
            print("Sent Token: $token"); // Debugging print
            print("Response Status Code: ${response.statusCode}");
            print("Response Body: ${response.body}");

            if (response.statusCode == 200) {
                final rentals = jsonDecode(response.body) as List;
                return rentals.map((c) => Rental.fromJson(c)).toList();
            } else {
                print("Could not view my properties");
                throw Exception("Could not fetch properties");
            }
        } on SocketException {
            throw Exception("Couldn't find connection");
        }
    }

    // * Update rental property
    Future<int> update(String id, Rental rental) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('auth-token');
        if (token == null) {
            throw Exception("No token found");
        }

        print("From data provider print $id");

        File? rentalImage;
        if (rental.rentalImage != null && rental.rentalImage!.isNotEmpty) {
            rentalImage = File(rental.rentalImage!);
        }

        var request =
        http.MultipartRequest('PUT', Uri.parse("$_baseUrl/update/$id"));
        request.headers.addAll({"Content-Type":
        "multipart/form-data",
            "Authorization": "Bearer $token"});


        request.fields["address"] = rental.address;

        if (rentalImage != null) {
            String filename = rentalImage.path.split('/').last;
            var file = await http.MultipartFile.fromPath(
                "rentalImage",
                rentalImage.path,
                filename: filename,
                contentType: MediaType('image', 'jpeg'),
            );
            request.files.add(file);
        }

        var response = await request.send();
        print(response.request);
        print(response.statusCode);

        if (response.statusCode == 200) {
            return response.statusCode;
        } else {
            print("Error");
            throw Exception("Failed to update property");
        }
    }

    // * Delete rental property
    Future<void> delete(String id) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('auth-token');
        if (token == null) {
            throw Exception("No token found");
        }

        print(id);
        final response = await http.delete(Uri.parse("$_baseUrl/delete/$id"),
            headers: <String, String>{
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
            });

        if (response.statusCode != 204) {
            throw Exception("Failed to delete the property");
        }
    }
}
