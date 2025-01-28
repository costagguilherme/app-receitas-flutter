import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matc89_aplicativo_receitas/repositories/avaliacao_repository.dart';
import '../models/avaliacao.dart';

class AvaliacaoController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AvaliacaoRepository avaliacaoRepository = AvaliacaoRepository();

  Future<List<Avaliacao>> getAll(String recipeId) async {
    return await avaliacaoRepository.getAll(recipeId);
  }

  Future<void> createOrUpdate(String id, String recipeId, String comment, String score) async {
    await avaliacaoRepository.createOrUpdate(id, recipeId, comment, score);
  }

  Future<void> delete(String id, String recipeId) async {
    await avaliacaoRepository.delete(id, recipeId);
  }

  getAverageScore(List<Avaliacao> avaliacoes) {
    double soma = 0;
    for (Avaliacao avaliacao in avaliacoes) {
      soma = soma + avaliacao.score;
    }

    double averageScore = 0;
    if (avaliacoes.length > 0) {
      averageScore = soma / avaliacoes.length;
    }
    return averageScore;
  }
}
