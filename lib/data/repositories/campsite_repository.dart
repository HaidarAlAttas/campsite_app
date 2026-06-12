import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/campsite_model.dart';

class CampsiteRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<CampsiteModel>> getCampsites({String? state, double? maxPrice}) async {
    Query query = _db.collection('campsites');

    if (state != null && state.isNotEmpty) {
      query = query.where('state', isEqualTo: state);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => CampsiteModel.fromFirestore(doc)).toList();
  }

  Future<CampsiteModel> getCampsiteById(String id) async {
    final doc = await _db.collection('campsites').doc(id).get();
    if (!doc.exists) throw Exception('Campsite not found');
    return CampsiteModel.fromFirestore(doc);
  }

  Future<List<CampsiteModel>> searchCampsites(String query) async {
    final snapshot = await _db.collection('campsites').get();
    final all = snapshot.docs.map((doc) => CampsiteModel.fromFirestore(doc)).toList();
    final q = query.toLowerCase();
    return all
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.location.toLowerCase().contains(q) ||
            c.state.toLowerCase().contains(q))
        .toList();
  }

  Future<List<CampsiteModel>> getFeaturedCampsites() async {
    final snapshot = await _db
        .collection('campsites')
        .orderBy('rating', descending: true)
        .limit(6)
        .get();
    return snapshot.docs.map((doc) => CampsiteModel.fromFirestore(doc)).toList();
  }

  Future<List<CampsiteModel>> getCampsitesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final futures = ids.map((id) => getCampsiteById(id));
    return Future.wait(futures);
  }

  static List<String> get malaysiaCampsiteStates => [
        'Selangor',
        'Pahang',
        'Kelantan',
        'Terengganu',
        'Perak',
        'Johor',
        'Sabah',
        'Sarawak',
        'Kedah',
        'Perlis',
        'Negeri Sembilan',
        'Melaka',
        'Penang',
      ];
}
