import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EpisodesScreen extends StatelessWidget {
  final int id;

  const EpisodesScreen({super.key, required this.id});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Rick and morty Episodes'),
    ),
    body: FutureBuilder(
      future: fetchEpisodes(id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text(snapshot.data[index]));
            },
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

  Future<List<String>> fetchEpisodes(id) async {
        try {
      List<String> episodes = [];
      List<String> episodeNames = [];
      final response = await http
          .get(Uri.parse('https://rickandmortyapi.com/api/character/$id'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        episodes = List<String>.from(jsonData['episode'] as List);

        String idsString = getEpisodeIds(episodes).join(',');
        final resp = await http
        .get(Uri.parse('https://rickandmortyapi.com/api/episode/$idsString'));
        if (resp.statusCode == 200) {
          final jsonData2 = json.decode(resp.body);
          for (var element in jsonData2) {
            episodeNames.add(element['name'] as String);
          }
        }
        return episodeNames;
      } else {
        print('Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // print('Error caught: $e');
      throw Error();
    }
  }
  List<String> getEpisodeIds(List<String> episodeUrls) {
    List<String> ids = [];
    for (String url in episodeUrls) {
      List<String> segments = Uri.parse(url).pathSegments;
      String id = segments.last;
      ids.add(id);
    }
    return ids;
  }
}
