import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 引入 Provider 套件
import 'music.dart'; // 引入 Music 類
import 'artist_page.dart'; // 引入歌手分頁組件
import 'album_page.dart'; // 引入專輯分頁組件
import 'song_page.dart'; // 引入歌曲清單分頁組件

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => MusicService()), // 在應用範圍內提供 MusicService 實例
    ],
    child: const MusicPlayerApp(),
  ));
}

// 主要的音樂播放器應用程式組件
class MusicPlayerApp extends StatefulWidget {
  const MusicPlayerApp({super.key});

  @override
  MusicPlayerAppState createState() => MusicPlayerAppState();
}

class MusicPlayerAppState extends State<MusicPlayerApp> {
  int _currentIndex = 0; // 目前選擇的頁面索引

  // 應用內的頁面組件列表
  final List<Widget> _children = [
    const ArtistPage(), // 歌手分頁
    const AlbumPage(), // 專輯分頁
    const SongPage(), // 歌曲清單分頁
  ];

  // 處理底部導航欄點擊事件，更新頁面索引
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 16, 55, 60), // 設定背景顏色
        body: _children[_currentIndex], // 根據當前索引顯示對應的頁面
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent, // 移除點擊時的水波紋效果
          ),
          child: BottomNavigationBar(
            backgroundColor:
                const Color.fromARGB(255, 12, 28, 31), // 設定底部導航欄背景色
            selectedItemColor:
                const Color.fromARGB(255, 0, 255, 119), // 設定選中項目的顏色
            unselectedItemColor:
                const Color.fromARGB(255, 196, 219, 226), // 設定未選中項目的顏色
            onTap: onTabTapped, // 點擊時的處理函數
            currentIndex: _currentIndex, // 當前選擇的頁面索引
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: '歌手',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.album),
                label: '專輯',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.queue_music),
                label: '歌曲清單',
              ),
            ],
          ),
        ),
        bottomSheet: const MusicControlPanel(), // 底部音樂控制面板
      ),
    );
  }
}
