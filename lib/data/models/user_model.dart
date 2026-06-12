import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final List<String> favorites;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.favorites,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      favorites: List<String>.from(data['favorites'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'favorites': favorites,
      };

  UserModel copyWith({List<String>? favorites}) => UserModel(
        uid: uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
        favorites: favorites ?? this.favorites,
      );

  @override
  List<Object?> get props => [uid, email, favorites];
}
