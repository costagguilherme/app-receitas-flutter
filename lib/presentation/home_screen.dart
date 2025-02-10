import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/auth_service.dart';
import 'package:matc89_aplicativo_receitas/controllers/receita_controller.dart';
import 'package:matc89_aplicativo_receitas/presentation/auth_check_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/avaliacao_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/favorite_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/widgets/card_receita.dart';
import 'package:uuid/uuid.dart';
import '../models/receita.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Receita> listaReceitas = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ReceitaController receitaController = ReceitaController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              "Livro de Receitas.",
              style: TextStyle(
                color: Color(0xFFFF9864),
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Color(0xFFFF9864)),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              "Coloque aqui somente as melhores",
              style: TextStyle(
                color: Color(0xFF784E39),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          (listaReceitas.isEmpty)
              ? const Center(
                  child: Text(
                    "Nenhuma receita ainda.\nVamos criar a primeira?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: listaReceitas.length,
                    itemBuilder: (context, index) {
                      final receita = listaReceitas[index];
                      return Dismissible(
                        key: ValueKey<Receita>(receita),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.only(right: 8.0),
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          receitaController.delete(receita.id);
                          refresh();
                        },
                        child: CardReceita(
                          receita: receita,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AvaliacaoScreen(recipe: receita),
                              ),
                            );
                          },
                          onLongPress: () {
                            showFormModal(model: receita);
                          },
                          onFavorite: () {
                            receitaController.createOrUpdate(
                              receita.name,
                              receita.description,
                              receita.ingredients,
                              receita.preparation,
                              receita.id,
                              receita.favorite == true ? false : true,
                            );
                            refresh();
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        backgroundColor: const Color(0xFFFF9864),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFFFF9864)),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Color(0xFFFF9864)),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  showFormModal({Receita? model}) {
    String confirmationButton = "Adicionar receita";
    String skipButton = "Cancelar";

    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController preparationController = TextEditingController();

    if (model != null) {
      nameController.text = model.name;
      descriptionController.text = model.description;
      ingredientsController.text = model.ingredients;
      preparationController.text = model.preparation;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            children: [
              const Text(
                "Receita",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF9864),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text("Título da receita"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  label: Text("Descrição da receita"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: ingredientsController,
                decoration: const InputDecoration(
                  label: Text("Lista de ingredientes"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: preparationController,
                decoration: const InputDecoration(
                  label: Text("Modo de preparo"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      skipButton,
                      style: const TextStyle(color: Color(0xFF784E39)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var id = const Uuid().v1();
                      if (model != null) {
                        id = model.id;
                      }
                      receitaController.createOrUpdate(
                          nameController.text,
                          descriptionController.text,
                          ingredientsController.text,
                          preparationController.text,
                          id,
                          false);
                      refresh();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9864),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(confirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  logout() async {
    await authService.logout().then((user) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const AuthCheckScreen())));
  }

  refresh() async {
    final receitas = await receitaController.getAll();
    if (mounted) {
      setState(() {
        listaReceitas = receitas;
      });
    }
  }
}
