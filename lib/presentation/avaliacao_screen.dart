import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/controllers/avaliacao_controller.dart';
import 'package:uuid/uuid.dart';
import '../models/receita.dart';
import '../models/avaliacao.dart';
import '../presentation/widgets/list_tile_avaliacao.dart';

class AvaliacaoScreen extends StatefulWidget {
  final Receita recipe;
  const AvaliacaoScreen({super.key, required this.recipe});

  @override
  State<AvaliacaoScreen> createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  List<Avaliacao> listaAvaliacoes = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AvaliacaoController avaliacaoController = new AvaliacaoController();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double averageScore = avaliacaoController.getAverageScore(this.listaAvaliacoes);

    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return refresh();
        },
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    "${averageScore.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 42),
                  ),
                  Text(
                    "Nota média dessa receita",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 2),
            ),
            const Text(
              "Avaliações dos usuários",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: List.generate(listaAvaliacoes.length, (index) {
                Avaliacao avaliacao = listaAvaliacoes[index];
                return Dismissible(
                  key: ValueKey<Avaliacao>(avaliacao),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.only(right: 8.0),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                  ),
                  onDismissed: (direction) {
                    avaliacaoController.delete(avaliacao.id, widget.recipe.id);
                    refresh();
                  },
                  child: ListTileAvaliacao(
                    avaliacao: avaliacao,
                    showModal: showFormModal,
                  ),
                );
              }),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 2),
            ),
            const Text(
              "Ingredientes",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.recipe.ingredients,  // Exibindo a string dos ingredientes
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,  // Para alinhamento à esquerda
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 2),
            ),
            const Text(
              "Modo de preparo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.recipe.preparation,  // Exibindo a string dos ingredientes
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,  // Para alinhamento à esquerda
              ),
            ),
          ],
        ),
      ),
    );
  }

  showFormModal({Avaliacao? model}) {
    // Labels à serem mostradas no Modal
    String labelTitle = "Adicionar avaliação";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    // Controlador dos campos de avaliacao
    TextEditingController commentController = TextEditingController();
    TextEditingController scoreController = TextEditingController();

    bool isComprado = false;

    // Caso esteja editando
    if (model != null) {
      labelTitle = "Editando comentário";
      commentController.text = model.comment;

      if (model.score != null) {
        scoreController.text = model.score.toString();
      }
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(32.0),

          // Formulário para adicionar nova avaliação
          child: ListView(
            children: [
              Text(labelTitle,
                  style: Theme.of(context).textTheme.headlineLarge),
              TextFormField(
                controller: commentController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  label: Text("Comentário"),
                  icon: Icon(Icons.abc_rounded),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: scoreController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  label: Text("Nota"),
                  icon: Icon(Icons.attach_money_rounded),
                ),
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
                    child: Text(labelSkipButton),
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

                      avaliacaoController.createOrUpdate(id, widget.recipe.id, commentController.text, scoreController.text);
                      refresh();
                      Navigator.pop(context);
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    final avalicacoes = await avaliacaoController.getAll(widget.recipe.id);
    setState(() {
      listaAvaliacoes = avalicacoes;
    });
  }
}


