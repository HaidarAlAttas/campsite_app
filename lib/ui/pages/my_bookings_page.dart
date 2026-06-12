import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/booking/booking_event.dart';
import '../../bloc/booking/booking_state.dart';
import '../../core/theme.dart';
import '../../data/models/booking_model.dart';
import '../widgets/bottom_nav.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});
  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadUserBookings());
  }

  Color _statusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.confirmed: return Colors.green;
      case BookingStatus.cancelled: return Colors.red;
      case BookingStatus.completed: return Colors.blue;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM yyyy');
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.forestGreen));
          }
          if (state is BookingsLoaded && state.bookings.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.backpack_outlined, size: 64, color: AppTheme.greyText),
                const SizedBox(height: 16),
                const Text('No bookings yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Start exploring campsites!',
                    style: TextStyle(color: AppTheme.greyText)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => context.go('/home'), child: const Text('Explore')),
              ]),
            );
          }
          if (state is BookingsLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.bookings.length,
              itemBuilder: (_, i) {
                final b = state.bookings[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(b.campsiteName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(b.status).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(b.status.name.toUpperCase(),
                                style: TextStyle(
                                    color: _statusColor(b.status),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        _infoChip(Icons.calendar_today_outlined,
                            '${fmt.format(b.startDate)} → ${fmt.format(b.endDate)}'),
                      ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        _infoChip(Icons.nights_stay_outlined, '${b.nights} night${b.nights > 1 ? 's' : ''}'),
                        const SizedBox(width: 16),
                        _infoChip(Icons.group_outlined, '${b.guests} guests'),
                      ]),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('RM ${b.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.forestGreen)),
                          if (b.status == BookingStatus.confirmed)
                            TextButton(
                              onPressed: () => _cancelConfirm(context, b.id),
                              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),
                    ]),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) => Row(children: [
    Icon(icon, size: 14, color: AppTheme.greyText),
    const SizedBox(width: 4),
    Text(label, style: const TextStyle(color: AppTheme.greyText, fontSize: 13)),
  ]);

  void _cancelConfirm(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingBloc>().add(CancelBooking(bookingId));
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
