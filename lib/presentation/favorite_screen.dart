import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/controllers/receita_controller.dart';
import 'package:matc89_aplicativo_receitas/presentation/avaliacao_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/home_screen.dart';
import 'package:matc89_aplicativo_receitas/presentation/widgets/card_receita.dart';
import '../models/receita.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Receita> listaReceitas = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ReceitaController receitaController = ReceitaController();

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
              "Receitas Favoritas",
              style: TextStyle(
                color: Color(0xFFFF9864),
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              "Aqui estão as receitas que você mais ama!",
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
                    "Nenhuma receita favoritada ainda.\nExplore e adicione suas preferidas!",
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
                            print("caiu aq");
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
    final formKey = GlobalKey<FormState>();
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
          child: Form(
            key: formKey,
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
                  maxLength: 30,
                  decoration: const InputDecoration(
                    label: Text("Título da receita"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Preencha o título da receita';
                    }
                    if (value.length < 4) {
                      return 'O título deve ter no mínimo 5 caracteres';
                    }
                    if (value.length > 30) {
                      return 'O título deve ter menos de 30 caracteres';
                    }
                    return null;

                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Preencha a descrição da receita';
                    }
                    if (value.length < 10) {
                      return 'A descrição deve ter no mínimo 10 caracteres';
                    }
                    if (value.length > 50) {
                      return 'A descrição deve ter menos de 50 caracteres';
                    }
                    return null;

                  },
                  decoration: const InputDecoration(
                    label: Text("Descrição da receita"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 255,
                  controller: ingredientsController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Preencha a lista de ingredientes';
                    }
                    if (value.length < 15) {
                      return 'A lista de ingredientes deve ter no mínimo 15 caracteres';
                    }
                    if (value.length > 255) {
                      return 'A lista de ingredientes deve ter menos de 255 caracteres';
                    }
                    return null;

                  },
                  decoration: const InputDecoration(
                    label: Text("Lista de ingredientes"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 450,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Preencha o modo de preparo';
                    }
                    if (value.length < 20) {
                      return 'O modo de preparo deve ter no mínimo 20 caracteres';
                    }
                    if (value.length > 450) {
                      return 'O modo de preparo deve ter menos de 450 caracteres';
                    }
                    return null;

                  },
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
                        if (formKey.currentState!.validate()) {
                          var id = model!.id;
                          receitaController.createOrUpdate(
                              nameController.text,
                              descriptionController.text,
                              ingredientsController.text,
                              preparationController.text,
                              id,
                              model.favorite);
                          refresh();
                          Navigator.pop(context);
                        }
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
          ),
        );
      },
    );
  }

  refresh() async {
    final receitas = await receitaController.getFavorites();
    setState(() {
      listaReceitas = receitas;
    });
  }
}
