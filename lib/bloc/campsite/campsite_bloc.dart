import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/campsite_repository.dart';
import 'campsite_event.dart';
import 'campsite_state.dart';

class CampsiteBloc extends Bloc<CampsiteEvent, CampsiteState> {
  final CampsiteRepository _repo;
  final AuthRepository _authRepo;

  CampsiteBloc(this._repo, this._authRepo) : super(CampsiteInitial()) {
    on<LoadCampsites>(_onLoad);
    on<LoadCampsiteDetail>(_onDetail);
    on<ToggleFavorite>(_onToggleFav);
    on<FilterCampsites>(_onFilter);
    on<SearchCampsites>(_onSearch);
    on<LoadFavoriteCampsites>(_onLoadFavorites);
  }

  Future<void> _onLoad(LoadCampsites e, Emitter emit) async {
    emit(CampsiteLoading());
    try {
      final campsites = await _repo.getCampsites();
      final favs = await _authRepo.getFavorites();
      emit(CampsitesLoaded(campsites: campsites, favorites: favs));
    } catch (e) {
      emit(CampsiteError(e.toString()));
    }
  }

  Future<void> _onDetail(LoadCampsiteDetail e, Emitter emit) async {
    emit(CampsiteLoading());
    try {
      final c = await _repo.getCampsiteById(e.id);
      final favs = await _authRepo.getFavorites();
      emit(CampsiteDetailLoaded(c, favorites: favs));
    } catch (e) {
      emit(CampsiteError(e.toString()));
    }
  }

  Future<void> _onToggleFav(ToggleFavorite e, Emitter emit) async {
    List<String> currentFavs = [];
    if (state is CampsitesLoaded) {
      currentFavs = List<String>.from((state as CampsitesLoaded).favorites);
    } else if (state is CampsiteDetailLoaded) {
      currentFavs = List<String>.from((state as CampsiteDetailLoaded).favorites);
    }

    currentFavs.contains(e.campsiteId)
        ? currentFavs.remove(e.campsiteId)
        : currentFavs.add(e.campsiteId);
    await _authRepo.updateFavorites(currentFavs);

    if (state is CampsitesLoaded) {
      final s = state as CampsitesLoaded;
      emit(CampsitesLoaded(campsites: s.campsites, favorites: currentFavs));
    } else if (state is CampsiteDetailLoaded) {
      final s = state as CampsiteDetailLoaded;
      emit(CampsiteDetailLoaded(s.campsite, favorites: currentFavs));
    }
  }

  Future<void> _onFilter(FilterCampsites e, Emitter emit) async {
    emit(CampsiteLoading());
    try {
      final all = await _repo.getCampsites(state: e.state, maxPrice: e.maxPrice);
      final favs = await _authRepo.getFavorites();
      emit(CampsitesLoaded(campsites: all, favorites: favs));
    } catch (e) {
      emit(CampsiteError(e.toString()));
    }
  }

  Future<void> _onSearch(SearchCampsites e, Emitter emit) async {
    emit(CampsiteLoading());
    try {
      final results = await _repo.searchCampsites(e.query);
      final favs = await _authRepo.getFavorites();
      emit(CampsitesLoaded(campsites: results, favorites: favs));
    } catch (e) {
      emit(CampsiteError(e.toString()));
    }
  }

  Future<void> _onLoadFavorites(LoadFavoriteCampsites e, Emitter emit) async {
    emit(CampsiteLoading());
    try {
      final favIds = await _authRepo.getFavorites();
      final campsites = await _repo.getCampsitesByIds(favIds);
      emit(CampsitesLoaded(campsites: campsites, favorites: favIds));
    } catch (e) {
      emit(CampsiteError(e.toString()));
    }
  }
}
