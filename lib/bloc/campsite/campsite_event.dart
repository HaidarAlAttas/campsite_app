import 'package:equatable/equatable.dart';

abstract class CampsiteEvent extends Equatable {
  const CampsiteEvent();
  @override List<Object> get props => [];
}

class LoadCampsites extends CampsiteEvent {}
class LoadCampsiteDetail extends CampsiteEvent {
  final String id;
  const LoadCampsiteDetail(this.id);
  @override List<Object> get props => [id];
}
class ToggleFavorite extends CampsiteEvent {
  final String campsiteId;
  const ToggleFavorite(this.campsiteId);
  @override List<Object> get props => [campsiteId];
}
class FilterCampsites extends CampsiteEvent {
  final String? state;
  final double? maxPrice;
  const FilterCampsites({this.state, this.maxPrice});
  @override List<Object> get props => [state ?? '', maxPrice ?? 0];
}
class SearchCampsites extends CampsiteEvent {
  final String query;
  const SearchCampsites(this.query);
  @override List<Object> get props => [query];
}
class LoadFavoriteCampsites extends CampsiteEvent {}
