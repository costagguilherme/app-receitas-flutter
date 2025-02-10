import 'package:flutter/material.dart';

class Comentario extends StatelessWidget {
  final double nota;
  final String comentario;
  final VoidCallback onLongPress;

  const Comentario({
    super.key,
    required this.nota,
    required this.comentario,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        onLongPress: onLongPress,
        contentPadding: const EdgeInsets.all(8.0),
        tileColor: const Color(0xFFFFF2EB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          comentario,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF584D48),
          ),
        ),
        subtitle: Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$nota/5',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFF9864),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
