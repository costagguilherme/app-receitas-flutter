import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/presentation/avaliacao_screen.dart';
import 'package:matc89_aplicativo_receitas/repositories/receita_repository.dart';
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
  ReceitaRepository receitaRepository = new ReceitaRepository();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receitas"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listaReceitas.isEmpty)
          ? const Center(
              child: Text(
                "Nenhuma receita ainda.\nVamos criar a primeira?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView(
                children: List.generate(
                  listaReceitas.length,
                  (index) {
                    Receita model = listaReceitas[index];
                    return Dismissible(
                      key: ValueKey<Receita>(model),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: EdgeInsets.only(right: 8.0),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                        alignment: Alignment.centerRight,
                      ),
                      onDismissed: (direction) {
                        remove(model);
                      },
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AvaliacaoScreen(recipe: model)));
                        },
                        onLongPress: () {
                          showFormModal(model: model);
                        },
                        leading: const Icon(Icons.list_alt_rounded),
                        title: Text(model.name),
                        subtitle: Text(model.description),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  showFormModal({Receita? model}) {
    // Labels à serem mostradas no Modal
    String title = "Adicionar Receita";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    // Controlador do campo que receberá o nome da Receita
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController preparationController = TextEditingController();

    // Caso esteja editando
    if (model != null) {
      title = "Editando '${model.name}'";
      nameController.text = model.name;
      descriptionController.text = model.description;
      ingredientsController.text = model.ingredients;
      preparationController.text = model.preparation;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,

      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(label: Text("Título da receita")),
              ),
              TextFormField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(label: Text("Descrição da receita")),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: ingredientsController,
                decoration:
                  const InputDecoration(label: Text("Lista de ingredientes")),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: preparationController,
                decoration:
                const InputDecoration(label: Text("Modo de preparo")),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        var id = const Uuid().v1();
                        if (model != null) {
                          id = model.id;
                        }
                        createOrUpdate(nameController.text, descriptionController.text, ingredientsController.text, preparationController.text, id);
                        //refresh();
                        Navigator.pop(context);
                      },
                      child: Text(confirmationButton)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void createOrUpdate(String name, String description, String ingredients, String preparation, String id) async {
    receitaRepository.createOrUpdate(id, name, description, ingredients, preparation);
    refresh();
  }

  void remove(Receita model) async {
    await receitaRepository.delete(model.id);
    refresh();
  }

  refresh() async {
    final receitas = await receitaRepository.getAll();
    setState(() {
      listaReceitas = receitas;
    });
  }
}
