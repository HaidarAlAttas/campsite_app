import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthGoogleSignInRequested>(_onGoogle);
    on<AuthEmailSignInRequested>(_onEmail);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthSignOutRequested>(_onSignOut);
  }

  Future<void> _onCheck(AuthCheckRequested e, Emitter emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.getCurrentUserModel();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGoogle(AuthGoogleSignInRequested e, Emitter emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmail(AuthEmailSignInRequested e, Emitter emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signInWithEmail(e.email, e.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('Invalid email or password'));
    }
  }

  Future<void> _onRegister(AuthRegisterRequested e, Emitter emit) async {
    emit(AuthLoading());
    try {
      final user = await _repo.registerWithEmail(e.name, e.email, e.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested e, Emitter emit) async {
    await _repo.signOut();
    emit(AuthUnauthenticated());
  }
}
