import 'package:flutter/material.dart';
import 'music.dart';
import 'data.dart';

class MusicListPage extends StatelessWidget {
  final List<Music> musics;
  final String title;

  const MusicListPage({super.key, required this.musics, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 8, 38, 42),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white), // 為副標題文字設置TextStyle並指定顏色
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 16, 55, 60),
      body: MusicListWidget(musics: musics),
      bottomSheet: const MusicControlPanel(),
    );
  }
}
