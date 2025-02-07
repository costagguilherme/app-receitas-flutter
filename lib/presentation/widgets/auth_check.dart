import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/presentation/home_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/login_screen.dart';
import 'package:matc89_aplicativo_receitas/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    print('AUTH CHECK');
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if(auth.usuario == null) {
      return LoginScreen();
    } else {
      return HomeScreen(nomeUsuario: auth.usuario!.email ?? "Usuário");
    }
  }

  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
