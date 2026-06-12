import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<BookingModel> createBooking({
    required String userId,
    required String campsiteId,
    required String campsiteName,
    required String campsiteImage,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
    required int guests,
  }) async {
    final id = _uuid.v4();
    final booking = BookingModel(
      id: id,
      userId: userId,
      campsiteId: campsiteId,
      campsiteName: campsiteName,
      campsiteImage: campsiteImage,
      startDate: startDate,
      endDate: endDate,
      totalPrice: totalPrice,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
      guests: guests,
    );

    await _db.collection('bookings').doc(id).set(booking.toMap());
    return booking;
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    final snapshot = await _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
  }

  Future<BookingModel?> getBookingById(String id) async {
    final doc = await _db.collection('bookings').doc(id).get();
    if (!doc.exists) return null;
    return BookingModel.fromFirestore(doc);
  }

  Future<void> cancelBooking(String bookingId) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': BookingStatus.cancelled.name,
    });
  }

  Future<bool> isDateRangeAvailable({
    required String campsiteId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final snapshot = await _db
        .collection('bookings')
        .where('campsiteId', isEqualTo: campsiteId)
        .where('status', whereIn: ['confirmed', 'pending']).get();

    for (final doc in snapshot.docs) {
      final booking = BookingModel.fromFirestore(doc);
      if (startDate.isBefore(booking.endDate) && endDate.isAfter(booking.startDate)) {
        return false;
      }
    }
    return true;
  }
}
