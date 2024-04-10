import 'package:ebook_app/music.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'artist_page.dart';
import 'album_page.dart';
import 'song_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GlobalMusicPlayerModel()),
    ],
    child: const MusicPlayerApp(),
  ));
}

class MusicPlayerApp extends StatefulWidget {
  const MusicPlayerApp({super.key});

  @override
  MusicPlayerAppState createState() => MusicPlayerAppState();
}

class MusicPlayerAppState extends State<MusicPlayerApp> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const ArtistPage(), // 歌手分類的頁面
    const AlbumPage(), // 專輯分類的頁面
    const SongPage(), // 所有歌曲的頁面
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 16, 55, 60), // 淺藍色背景，提供清新感
        body: _children[_currentIndex], // 根據目前的索引值顯示對應的頁面
        bottomNavigationBar: Theme(
          data: ThemeData(
            // 去掉水波纹效果
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor:
                const Color.fromARGB(255, 12, 28, 31), // 底部導航欄使用稍深一點的藍色
            selectedItemColor:
                const Color.fromARGB(255, 0, 255, 119), // 選中項目使用鮮艷的藍色
            unselectedItemColor:
                const Color.fromARGB(255, 196, 219, 226), // 未選中項目使用灰色，保持低調
            onTap: onTabTapped, // 設置點擊事件的處理函數
            currentIndex: _currentIndex, // 目前選擇的索引值
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music), // 使用音樂庫圖標，表示歌手分類
                label: '歌手', // 標籤
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.album), // 使用專輯圖標，表示專輯分類
                label: '專輯', // 標籤
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.queue_music), // 使用音樂列表圖標，表示歌曲清單
                label: '歌曲清單', // 標籤
              ),
            ],
          ),
        ),
        bottomSheet: const MusicControlPanel(),
      ),
    );
  }
}
