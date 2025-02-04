import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/controllers/avaliacao_controller.dart';
import 'package:matc89_aplicativo_receitas/presentation/widgets/comentario.dart';
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
      appBar: AppBar(title: Text("Voltar")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF9864),
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
                    widget.recipe.name,
                    style: TextStyle(
                      color: Color(0xFFFF9864),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xFF784E39),
                      ),
                      Text(
                        "Avaliação: ${averageScore.toStringAsFixed(2)}/5",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comentários",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF784E39),
                ),
              ),
            ),
            listaAvaliacoes.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Ainda não há comentários sobre essa receita.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
                : Column(
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
                  child: Comentario(
                    nota: avaliacao.score ?? 0.0,
                    comentario: avaliacao.comment,
                    onLongPress: () {
                      showFormModal(model: avaliacao);
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Ingredientes",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF784E39),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.recipe.ingredients,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Modo de preparo",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF784E39),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.recipe.preparation,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showFormModal({Avaliacao? model}) {
    String labelTitle = "Adicionar avaliação";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    TextEditingController commentController = TextEditingController();
    TextEditingController scoreController = TextEditingController();

    bool isComprado = false;

    if (model != null) {
      labelTitle = "Editando comentário";
      commentController.text = model.comment;

      if (model.score != null) {
        scoreController.text = model.score.toString();
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(32.0),
          child: ListView(
            children: [
              Text(
                "Avaliação",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF9864),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: commentController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  label: Text("Comentário"),
                  icon: Icon(Icons.abc_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: scoreController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  label: Text("Nota"),
                  icon: Icon(Icons.star),
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
                      labelSkipButton,
                      style: TextStyle(color: Color(0xFF784E39)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      var id = const Uuid().v1();
                      if (model != null) {
                        id = model.id;
                      }

                      avaliacaoController.createOrUpdate(
                          id, widget.recipe.id, commentController.text, scoreController.text);
                      refresh();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF9864),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(labelConfirmationButton),
                  ),
                ],
              ),
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
