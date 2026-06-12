import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, cancelled, completed }

class BookingModel extends Equatable {
  final String id;
  final String userId;
  final String campsiteId;
  final String campsiteName;
  final String campsiteImage;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final int guests;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.campsiteId,
    required this.campsiteName,
    required this.campsiteImage,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.guests,
  });

  int get nights => endDate.difference(startDate).inDays;

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      campsiteId: data['campsiteId'] ?? '',
      campsiteName: data['campsiteName'] ?? '',
      campsiteImage: data['campsiteImage'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      guests: data['guests'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'campsiteId': campsiteId,
        'campsiteName': campsiteName,
        'campsiteImage': campsiteImage,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'totalPrice': totalPrice,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
        'guests': guests,
      };

  @override
  List<Object?> get props => [id, userId, campsiteId, startDate, endDate, status];
}
