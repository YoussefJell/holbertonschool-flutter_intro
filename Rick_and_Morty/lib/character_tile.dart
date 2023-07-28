import 'package:flutter/material.dart';
import 'episodes_screen.dart';
import 'models.dart';

class CharacterTile extends StatelessWidget {
  final Character character;

  const CharacterTile({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EpisodesScreen(id: character.id),
          ),
        );
      },
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            character.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        child: Image.network(character.img),
      ),
    );
  }
}
