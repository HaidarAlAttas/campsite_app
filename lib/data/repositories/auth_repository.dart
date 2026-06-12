import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _google = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user!;

    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newUser = UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        favorites: [],
      );
      await docRef.set(newUser.toMap());
      return newUser;
    }

    return UserModel.fromFirestore(doc);
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    return UserModel.fromFirestore(doc);
  }

  Future<UserModel> registerWithEmail(String name, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    await user.updateDisplayName(name);

    final newUser = UserModel(
      uid: user.uid,
      name: name,
      email: email,
      photoUrl: '',
      favorites: [],
    );
    await _db.collection('users').doc(user.uid).set(newUser.toMap());
    return newUser;
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<List<String>> getFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return [];
    return List<String>.from((doc.data() as Map)['favorites'] ?? []);
  }

  Future<void> updateFavorites(List<String> favorites) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).update({'favorites': favorites});
  }
}
