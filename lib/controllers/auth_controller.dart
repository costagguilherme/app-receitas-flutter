// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/auth_service.dart';
import 'package:matc89_aplicativo_receitas/presentation/auth_check_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/home_screen.dart';

class AuthController {
  final AuthService authService = AuthService();

  Future<void> login(String email, String senha, BuildContext context) async {
    try {
      await authService.login(email, senha);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Usuário não encontrado'),
          backgroundColor: Colors.redAccent,
        ));
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Credenciais inválidas'),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  Future<void> register(
      String email, String senha, BuildContext context) async {
    try {
      await authService.register(email, senha);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthCheckScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Erro ao criar conta";
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Este e-mail já está em uso';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'E-mail inválido';
      } else if (e.code == 'weak-password') {
        errorMessage = 'A senha deve ter pelo menos 6 caracteres';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.redAccent,
      ));
    }
  }
}
