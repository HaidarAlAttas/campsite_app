import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/campsite/campsite_bloc.dart';
import 'bloc/booking/booking_bloc.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/campsite_repository.dart';
import 'data/repositories/booking_repository.dart';

class CampsiteApp extends StatefulWidget {
  const CampsiteApp({super.key});
  @override
  State<CampsiteApp> createState() => _CampsiteAppState();
}

class _CampsiteAppState extends State<CampsiteApp> {
  final _authRepo = AuthRepository();
  final _campsiteRepo = CampsiteRepository();
  final _bookingRepo = BookingRepository();
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(_authRepo)..add(AuthCheckRequested());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => CampsiteBloc(_campsiteRepo, _authRepo)),
        BlocProvider(create: (_) => BookingBloc(_bookingRepo, _authRepo)),
      ],
      child: Builder(builder: (context) {
        final router = createRouter(_authBloc);
        return MaterialApp.router(
          title: 'Campsite MY',
          theme: AppTheme.theme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
