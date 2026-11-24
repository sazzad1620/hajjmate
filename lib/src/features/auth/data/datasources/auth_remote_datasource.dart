import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/core/errors/exceptions.dart';
import 'package:hajjmate/src/features/auth/data/models/user_model.dart';
import 'package:hajjmate/src/features/auth/domain/entities/forgot_password_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/login_params.dart';
import 'package:hajjmate/src/features/auth/domain/entities/sign_up_params.dart';

class AuthRemoteDatasource {
  static const String _usersCollection = 'users';

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDatasource(this._auth, this._firestore);

  Future<UserModel> signUp(SignUpParams params) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    final model = UserModel(
      // Firebase returns a user whenever creating the account succeeds.
      id: credential.user!.uid,
      name: params.name,
      phone: params.phone,
      email: params.email,
      groupId: AppConstants.defaultGroupId,
      role: params.role,
    );
    await _firestore
        .collection(_usersCollection)
        .doc(model.id)
        .set(model.toMap());
    return model;
  }

  Future<UserModel> signIn(LoginParams params) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    return _fetchProfile(credential.user!.uid);
  }

  Future<UserModel?> getCurrentUser() async {
    // The first event carries the session Firebase restored from the phone.
    final firebaseUser = await _auth.authStateChanges().first;
    if (firebaseUser == null) return null;
    return _fetchProfile(firebaseUser.uid);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordReset(ForgotPasswordParams params) {
    return _auth.sendPasswordResetEmail(email: params.email);
  }

  Future<UserModel> _fetchProfile(String uid) async {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .get();
    final data = snapshot.data();
    if (data == null) throw const ProfileNotFoundException();
    return UserModel.fromMap(snapshot.id, data);
  }
}
