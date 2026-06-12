import 'package:equatable/equatable.dart';
import '../../data/models/booking_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override List<Object?> get props => [];
}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingSuccess extends BookingState {
  final BookingModel booking;
  const BookingSuccess(this.booking);
  @override List<Object?> get props => [booking];
}
class BookingsLoaded extends BookingState {
  final List<BookingModel> bookings;
  const BookingsLoaded(this.bookings);
  @override List<Object?> get props => [bookings];
}
class BookingCancelled extends BookingState {}
class BookingAvailable extends BookingState {}
class BookingUnavailable extends BookingState {}
class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override List<Object?> get props => [message];
}
