import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matc89_aplicativo_receitas/firestore_service.dart';
import 'package:matc89_aplicativo_receitas/models/receita.dart';

class ReceitaRepository {

  FirebaseFirestore firestore = FirestoreService.instance;

  getAll() async {
    List<Receita> receitas = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection("receitas").get();
    for (var doc in snapshot.docs) {
      receitas.add(Receita.fromMap(doc.data()));
    }

    return receitas;
  }

  Future<List<Receita>> getFavorites() async {
    List<Receita> receitasFavoritas = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection("receitas").where("favorite", isEqualTo: true).get();
    for (var doc in snapshot.docs) {
      receitasFavoritas.add(Receita.fromMap(doc.data()));
    }

    return receitasFavoritas;
  }

  createOrUpdate(String id, String name, String description, String ingredients, String prepration, bool favorite) async {
    Receita receita = Receita(
        id: id,
        name: name,
        description: description,
        ingredients: ingredients,
        preparation: prepration,
      favorite: favorite

    );

    firestore
        .collection("receitas")
        .doc(receita.id)
        .set(receita.toMap());
  }

  delete(String id) async {
    await firestore.collection("receitas").doc(id).delete();
  }
}