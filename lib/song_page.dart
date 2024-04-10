import 'package:flutter/material.dart';
import './music.dart';
import './data.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        const Expanded(
          flex: 1,
          child: Text(
            '所有歌曲',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(flex: 10, child: MusicListWidget(musics: musicData)),
      ],
    );
  }
}
