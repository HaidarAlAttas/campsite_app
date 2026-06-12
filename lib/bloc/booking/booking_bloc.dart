import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repo;
  final AuthRepository _authRepo;

  BookingBloc(this._repo, this._authRepo) : super(BookingInitial()) {
    on<CreateBooking>(_onCreate);
    on<LoadUserBookings>(_onLoad);
    on<CancelBooking>(_onCancel);
    on<CheckAvailability>(_onCheck);
    on<ResetBookingState>(_onReset);
  }

  Future<void> _onCreate(CreateBooking e, Emitter emit) async {
    emit(BookingLoading());
    try {
      final user = _authRepo.currentUser;
      if (user == null) throw Exception('Not authenticated');

      final nights = e.endDate.difference(e.startDate).inDays;
      final total = nights * e.pricePerNight;

      final booking = await _repo.createBooking(
        userId: user.uid,
        campsiteId: e.campsiteId,
        campsiteName: e.campsiteName,
        campsiteImage: e.campsiteImage,
        startDate: e.startDate,
        endDate: e.endDate,
        totalPrice: total,
        guests: e.guests,
      );
      emit(BookingSuccess(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onLoad(LoadUserBookings e, Emitter emit) async {
    emit(BookingLoading());
    try {
      final user = _authRepo.currentUser;
      if (user == null) throw Exception('Not authenticated');
      final bookings = await _repo.getUserBookings(user.uid);
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onCancel(CancelBooking e, Emitter emit) async {
    emit(BookingLoading());
    try {
      await _repo.cancelBooking(e.bookingId);
      emit(BookingCancelled());
      add(LoadUserBookings());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onCheck(CheckAvailability e, Emitter emit) async {
    emit(BookingLoading());
    try {
      final available = await _repo.isDateRangeAvailable(
        campsiteId: e.campsiteId,
        startDate: e.startDate,
        endDate: e.endDate,
      );
      emit(available ? BookingAvailable() : BookingUnavailable());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  void _onReset(ResetBookingState e, Emitter emit) => emit(BookingInitial());
}
