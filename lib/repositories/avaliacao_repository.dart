import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matc89_aplicativo_receitas/firestore_service.dart';
import 'package:matc89_aplicativo_receitas/models/avaliacao.dart';

class AvaliacaoRepository {
  FirebaseFirestore firestore = FirestoreService.instance;

  getAll(String recipeId) async {
    List<Avaliacao> avaliacoes = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("receitas")
        .doc(recipeId)
        .collection("avaliacoes")
        .get();
    for (var doc in snapshot.docs) {
      Avaliacao avaliacao = Avaliacao.fromMap(doc.data());
      avaliacoes.add(avaliacao);
    }

    return avaliacoes;
  }

  createOrUpdate(
      String id, String recipeId, String comment, String score) async {
    Avaliacao avaliacao =
        Avaliacao(id: id, comment: comment, score: double.parse(score));
    firestore
        .collection("receitas")
        .doc(recipeId)
        .collection("avaliacoes")
        .doc(avaliacao.id)
        .set(avaliacao.toMap());
  }

  delete(String id, String recipeId) async {
    await firestore
        .collection("receitas")
        .doc(recipeId)
        .collection("avaliacoes")
        .doc(id)
        .delete();
  }
}
