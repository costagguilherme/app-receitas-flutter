import 'package:flutter/material.dart';
import 'package:matc89_aplicativo_receitas/models/receita.dart';

class CardReceita extends StatelessWidget {
  final Receita receita;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavorite;

  const CardReceita({
    Key? key,
    required this.receita,
    required this.onTap,
    required this.onLongPress,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF2EB),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        title: Text(
          receita.name,
          style: const TextStyle(
            color: Color(0xFF584D48),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          receita.description.length > 35
              ? '${receita.description.substring(0, 35)}...'
              : receita.description,
          style: const TextStyle(
            color: Color(0xFF938981),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Icon(Icons.open_with, color: Colors.grey),
            IconButton(
              icon: Icon(
                receita.favorite == true ? Icons.favorite : Icons.favorite_border,
                color: receita.favorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavorite,
            ),
          ],
        ),
      ),
    );
  }
}


