import 'package:flutter/material.dart';
import 'music.dart';
import 'data.dart';

// 定義一個呈現所有歌曲的頁面
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
            '所有歌曲', // 頁面標題
            style: TextStyle(
              color: Colors.white, // 文字顏色
              fontSize: 30, // 文字大小
              fontWeight: FontWeight.bold, // 文字粗細
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: musicControlPanelUnExpandHeight), // 增加足夠的底部內邊距
            child: MusicListWidget(musics: musicData),
          ),
        ), // 使用MusicListWidget顯示所有歌曲
      ],
    );
  }
}
