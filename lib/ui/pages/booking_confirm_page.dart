import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/booking/booking_state.dart';
import '../../core/theme.dart';
import 'package:intl/intl.dart';

class BookingConfirmPage extends StatelessWidget {
  const BookingConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is! BookingSuccess) {
            return const Center(child: CircularProgressIndicator());
          }
          final b = state.booking;
          final fmt = DateFormat('d MMM yyyy');

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: const BoxDecoration(color: AppTheme.lightGreen, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 56),
                  ),
                  const SizedBox(height: 24),
                  const Text('Booking Confirmed!',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                  const SizedBox(height: 8),
                  const Text('Your campsite adventure is booked.',
                      style: TextStyle(color: AppTheme.greyText, fontSize: 15)),
                  const SizedBox(height: 36),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16)],
                    ),
                    child: Column(children: [
                      _row('Campsite', b.campsiteName),
                      _row('Check-in', fmt.format(b.startDate)),
                      _row('Check-out', fmt.format(b.endDate)),
                      _row('Duration', '${b.nights} night${b.nights > 1 ? 's' : ''}'),
                      _row('Guests', '${b.guests}'),
                      const Divider(height: 24),
                      _row('Total Paid', 'RM ${b.totalPrice.toStringAsFixed(0)}', highlight: true),
                    ]),
                  ),
                  const SizedBox(height: 36),

                  ElevatedButton(
                    onPressed: () => context.go('/my-bookings'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                    child: const Text('View My Bookings'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go('/home'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppTheme.forestGreen),
                    ),
                    child: const Text('Explore More', style: TextStyle(color: AppTheme.forestGreen)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.greyText, fontSize: 14)),
            Text(value,
                style: TextStyle(
                  fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
                  fontSize: highlight ? 16 : 14,
                  color: highlight ? AppTheme.forestGreen : AppTheme.darkText,
                )),
          ],
        ),
      );
}
