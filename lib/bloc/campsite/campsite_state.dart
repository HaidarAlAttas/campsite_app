import 'package:equatable/equatable.dart';
import '../../data/models/campsite_model.dart';

abstract class CampsiteState extends Equatable {
  const CampsiteState();
  @override List<Object> get props => [];
}

class CampsiteInitial extends CampsiteState {}
class CampsiteLoading extends CampsiteState {}

class CampsitesLoaded extends CampsiteState {
  final List<CampsiteModel> campsites;
  final List<String> favorites;
  const CampsitesLoaded({required this.campsites, this.favorites = const []});
  @override List<Object> get props => [campsites, favorites];
}

class CampsiteDetailLoaded extends CampsiteState {
  final CampsiteModel campsite;
  final List<String> favorites;
  const CampsiteDetailLoaded(this.campsite, {this.favorites = const []});
  @override List<Object> get props => [campsite, favorites];
}

class CampsiteError extends CampsiteState {
  final String message;
  const CampsiteError(this.message);
  @override List<Object> get props => [message];
}
