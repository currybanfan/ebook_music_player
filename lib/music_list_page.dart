import 'package:flutter/material.dart';
import 'music.dart';
import 'data.dart';

/// 使用 Navigator 導航的頁面
/// 透過傳入不同的 music list 建構 page
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
      // 顯示音樂清單
      body: Padding(
        padding: const EdgeInsets.only(
            bottom: musicControlPanelUnExpandHeight), // 增加足夠的底部內邊距
        child: MusicListWidget(musics: musics),
      ),
      // 底部為音樂控制面板
      bottomSheet: const MusicControlPanel(),
    );
  }
}
