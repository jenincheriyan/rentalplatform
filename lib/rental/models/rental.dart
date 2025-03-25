import 'package:flutter/cupertino.dart';

class Rental {
  String? sId;
  bool? available;
  String? userId;
  String address;
  String? rentalImage;
  String? date;

  Rental({
    this.sId,
    this.available,
    this.userId,
    required this.address,
    this.rentalImage,
    this.date,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      sId: json['_id'] ?? '',
      available: json['available'] ?? false,
      userId: json['userId'] ?? '',
      address: json['address'] ?? 'No address',
      rentalImage: json['rentalImage'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'available': available,
      'userId': userId,
      'address': address,
      'rentalImage': rentalImage,
      'date': date,
    };
  }
}
