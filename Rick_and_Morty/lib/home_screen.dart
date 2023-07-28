import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'character_tile.dart';
import 'models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
      ),
      body: FutureBuilder(
        future: fetchBbCharacters(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final character = snapshot.data[index];
                return CharacterTile(character: character);
              }
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Character>> fetchBbCharacters() async {
    try {
      List<Character> char = [];
      final response = await http
          .get(Uri.parse('https://rickandmortyapi.com/api/character'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> characters = jsonData['results'];

        for (final character in characters) {
          char.add(Character.fromJson(character));
        }
        return (char);
      } else {
        // print('Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // print('Error caught: $e');
      return [];
    }
  }
}
