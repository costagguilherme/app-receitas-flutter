import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> login(String email, String senha) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<UserCredential> register(String email, String senha) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  logout() async {
    await firebaseAuth.signOut();
  }
}
