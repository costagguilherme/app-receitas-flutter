import 'package:matc89_aplicativo_receitas/repositories/receita_repository.dart';
import 'package:matc89_aplicativo_receitas/models/receita.dart';

class ReceitaController {
  final ReceitaRepository receitaRepository = new ReceitaRepository();


  Future<List<Receita>> getAll() async {
    return await receitaRepository.getAll();
  }

  Future<void> createOrUpdate(String nome, String descricao, String ingredientes, String preparo, String id) async {
    await receitaRepository.createOrUpdate(id, nome, descricao, ingredientes, preparo);
  }

  Future<void> delete(String id) async {
    await receitaRepository.delete(id);
  }
}
