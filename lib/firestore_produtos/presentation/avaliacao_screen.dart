import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../firestore/models/receita.dart';
import '../model/avaliacao.dart';
import 'widgets/list_tile_avaliacao.dart';

class AvaliacaoScreen extends StatefulWidget {
  final Receita listin;
  const AvaliacaoScreen({super.key, required this.listin});

  @override
  State<AvaliacaoScreen> createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  List<Avaliacao> listaAvaliacoes = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double soma = 0;
    for (Avaliacao avaliacao in this.listaAvaliacoes) {
      soma = soma + avaliacao.score;
    }

    double averageScore = 10;
    if (this.listaAvaliacoes.length > 0) {
      averageScore = soma / this.listaAvaliacoes.length;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.listin.name)),
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
                    remove(avaliacao);
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
                widget.listin.ingredients,  // Exibindo a string dos ingredientes
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
                widget.listin.preparation,  // Exibindo a string dos ingredientes
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
                      // Criar um objeto Avaliacao com as infos
                      Avaliacao avaliacao = Avaliacao(
                          id: const Uuid().v1(),
                          comment: commentController.text,
                          score: double.parse(scoreController.text));

                      // Caso edição, usar o id da avaliação em questão
                      if (model != null) {
                        avaliacao.id = model.id;
                      }

                      // Grava no Firestore
                      firestore
                          .collection("receitas")
                          .doc(widget.listin.id)
                          .collection("avaliacoes")
                          .doc(avaliacao.id)
                          .set(avaliacao.toMap());
                      // Atualizar a lista
                      refresh();

                      // Fechar o Modal
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

  void remove(Avaliacao model) async {
    await firestore
        .collection("receitas")
        .doc(widget.listin.id)
        .collection("avaliacoes")
        .doc(model.id)
        .delete();
    refresh();
  }

  refresh() async {
    List<Avaliacao> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("receitas")
        .doc(widget.listin.id)
        .collection("avaliacoes")
        .get();
    for (var doc in snapshot.docs) {
      Avaliacao avaliacao = Avaliacao.fromMap(doc.data());
      temp.add(avaliacao);
    }

    setState(() {
      listaAvaliacoes = temp;
    });
  }
}
