import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AuthController authController = AuthController();
  bool isLogin = true;

  Future<void> login(String email, String senha) async {
    await authController.login(email, senha, context);
  }

  Future<void> register(String email, String senha) async {
    await authController.register(email, senha, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Login" : "Cadastro"),
        backgroundColor: const Color(0xFFFF9864),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => isLogin
                  ? login(emailController.text, passwordController.text)
                  : register(emailController.text, passwordController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9864),
              ),
              child: Text(isLogin ? "Entrar" : "Criar Conta"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? "Ainda não tem conta? Cadastre-se"
                    : "Já tem conta? Faça login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
