import 'package:flutter/material.dart';
import '../../../models/avaliacao.dart';

class ListTileAvaliacao extends StatelessWidget {
  final Avaliacao avaliacao;
  final Function showModal;

  const ListTileAvaliacao({
    super.key,
    required this.avaliacao,
    required this.showModal,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModal(model: avaliacao);
      },
      // leading: Icon(
      //   (condicao) ? Icons.shopping_basket : Icons.check,
      // ),
      title: Text(avaliacao.comment),
      subtitle: Text("Nota: ${avaliacao.score.toString()}"),
    );
  }
}
