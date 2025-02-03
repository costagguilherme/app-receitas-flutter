import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Comentario extends StatelessWidget {
  final double nota;
  final String comentario;
  final VoidCallback onLongPress;  // Parâmetro onLongPress

  const Comentario({
    Key? key,
    required this.nota,
    required this.comentario,
    required this.onLongPress,  // Recebe o onLongPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        onLongPress: onLongPress,  // Usando onLongPress do ListTile
        contentPadding: EdgeInsets.all(16.0),
        tileColor: const Color(0xFFFFF2EB), // Cor de fundo igual ao CardReceita
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          comentario,
          style: const TextStyle(
            fontSize: 18,  // Aumentando o tamanho do texto
            color: Color(0xFF584D48),  // Cor do texto igual ao título do CardReceita
          ),
        ),
        subtitle: Align(
          alignment: Alignment.centerRight,  // Alinha a nota à direita
          child: Text(
            '$nota/5',
            style: const TextStyle(
              fontSize: 18, // Aumentando o tamanho da nota
              color: Color(0xFFFF9864),  // Cor da nota
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


