import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CampsiteModel extends Equatable {
  final String id;
  final String name;
  final String location;
  final String state;
  final double price;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final List<String> amenities;
  final String description;
  final double latitude;
  final double longitude;

  const CampsiteModel({
    required this.id,
    required this.name,
    required this.location,
    required this.state,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.amenities,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory CampsiteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CampsiteModel(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      state: data['state'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      amenities: List<String>.from(data['amenities'] ?? []),
      description: data['description'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'location': location,
        'state': state,
        'price': price,
        'rating': rating,
        'reviewCount': reviewCount,
        'imageUrls': imageUrls,
        'amenities': amenities,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  List<Object?> get props => [id, name, location, state, price, rating];
}
