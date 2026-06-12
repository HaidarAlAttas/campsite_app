import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override List<Object> get props => [];
}

class CreateBooking extends BookingEvent {
  final String campsiteId;
  final String campsiteName;
  final String campsiteImage;
  final DateTime startDate;
  final DateTime endDate;
  final double pricePerNight;
  final int guests;

  const CreateBooking({
    required this.campsiteId,
    required this.campsiteName,
    required this.campsiteImage,
    required this.startDate,
    required this.endDate,
    required this.pricePerNight,
    required this.guests,
  });

  @override List<Object> get props => [campsiteId, startDate, endDate];
}

class LoadUserBookings extends BookingEvent {}
class CancelBooking extends BookingEvent {
  final String bookingId;
  const CancelBooking(this.bookingId);
  @override List<Object> get props => [bookingId];
}
class CheckAvailability extends BookingEvent {
  final String campsiteId;
  final DateTime startDate;
  final DateTime endDate;
  const CheckAvailability(this.campsiteId, this.startDate, this.endDate);
  @override List<Object> get props => [campsiteId, startDate, endDate];
}
class ResetBookingState extends BookingEvent {}
