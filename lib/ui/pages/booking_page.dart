import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/booking/booking_event.dart';
import '../../bloc/booking/booking_state.dart';
import '../../bloc/campsite/campsite_bloc.dart';
import '../../bloc/campsite/campsite_event.dart';
import '../../bloc/campsite/campsite_state.dart';
import '../../core/theme.dart';

class BookingPage extends StatefulWidget {
  final String campsiteId;
  const BookingPage({super.key, required this.campsiteId});
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _guests = 2;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<CampsiteBloc>().add(LoadCampsiteDetail(widget.campsiteId));
  }

  int get _nights => (_startDate != null && _endDate != null)
      ? _endDate!.difference(_startDate!).inDays
      : 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          context.go('/booking/confirm');
        }
        if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Book Campsite'), leading: BackButton(onPressed: () => context.pop())),
        body: BlocBuilder<CampsiteBloc, CampsiteState>(
          builder: (context, cs) {
            if (cs is! CampsiteDetailLoaded) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.forestGreen));
            }
            final campsite = cs.campsite;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.warmBeige,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.landscape, color: AppTheme.lightGreen, size: 30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(campsite.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text('${campsite.location}, ${campsite.state}',
                                  style: const TextStyle(color: AppTheme.greyText, fontSize: 13)),
                              Text('RM ${campsite.price.toStringAsFixed(0)}/night',
                                  style: const TextStyle(color: AppTheme.forestGreen, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text('Select Dates', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      rangeStartDay: _startDate,
                      rangeEndDay: _endDate,
                      rangeSelectionMode: RangeSelectionMode.toggledOn,
                      onFormatChanged: (f) => setState(() => _calendarFormat = f),
                      onDaySelected: (selected, focused) {
                        setState(() => _focusedDay = focused);
                      },
                      onRangeSelected: (start, end, focused) {
                        setState(() {
                          _startDate = start;
                          _endDate = end;
                          _focusedDay = focused;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        rangeHighlightColor: AppTheme.lightGreen.withOpacity(0.3),
                        rangeStartDecoration: const BoxDecoration(color: AppTheme.forestGreen, shape: BoxShape.circle),
                        rangeEndDecoration: const BoxDecoration(color: AppTheme.forestGreen, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(color: AppTheme.lightGreen.withOpacity(0.5), shape: BoxShape.circle),
                        selectedDecoration: const BoxDecoration(color: AppTheme.forestGreen, shape: BoxShape.circle),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Guests
                  const Text('Guests', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(children: [
                          Icon(Icons.group_outlined, color: AppTheme.greyText),
                          SizedBox(width: 8),
                          Text('Number of guests', style: TextStyle(fontSize: 15)),
                        ]),
                        Row(children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppTheme.forestGreen),
                            onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                          ),
                          Text('$_guests', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppTheme.forestGreen),
                            onPressed: _guests < 20 ? () => setState(() => _guests++) : null,
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Price breakdown
                  if (_nights > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.forestGreen.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.forestGreen.withOpacity(0.2)),
                      ),
                      child: Column(children: [
                        _priceRow('RM ${campsite.price.toStringAsFixed(0)} x $_nights nights',
                            'RM ${(campsite.price * _nights).toStringAsFixed(0)}'),
                        const Divider(height: 20),
                        _priceRow('Total', 'RM ${(campsite.price * _nights).toStringAsFixed(0)}',
                            bold: true),
                      ]),
                    ),
                    const SizedBox(height: 24),
                  ],

                  BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, bs) {
                      final loading = bs is BookingLoading;
                      return ElevatedButton(
                        onPressed: (_startDate != null && _endDate != null && !loading) ? _confirm : null,
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                        child: loading
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(_startDate == null ? 'Select dates to continue' : 'Confirm Booking'),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 16 : 14)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14, color: bold ? AppTheme.forestGreen : AppTheme.darkText)),
        ],
      );

  void _confirm() {
    final cs = context.read<CampsiteBloc>().state;
    if (cs is! CampsiteDetailLoaded) return;
    context.read<BookingBloc>().add(CreateBooking(
      campsiteId: cs.campsite.id,
      campsiteName: cs.campsite.name,
      campsiteImage: cs.campsite.imageUrls.isNotEmpty ? cs.campsite.imageUrls.first : '',
      startDate: _startDate!,
      endDate: _endDate!,
      pricePerNight: cs.campsite.price,
      guests: _guests,
    ));
  }
}
