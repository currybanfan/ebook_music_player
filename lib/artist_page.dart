import 'package:flutter/material.dart';
import 'music_list_page.dart';
import 'data.dart';

/// 歌手頁面，根據歌手來分類音樂
/// 使用了 GridView.builder 來動態產生格狀佈局
/// 每個格子都是可點擊的，點擊後根據歌手過濾音樂數據，並導航到 MusicListPage
class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(flex: 1, child: SizedBox()), // 用於佔位
        const Expanded(
          flex: 1,
          child: Text(
            '歌手',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 每行兩列
              childAspectRatio: 0.8, // 子項目的寬高比
            ),
            itemCount: artists.length, // 歌手數量
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // 根據選中的歌手過濾音樂數據
                  List<Music> filteredByArtist = musicData
                      .where((music) => music.artist == artists[index])
                      .toList();
                  String title = artists[index]; // 歌手名稱

                  // 導航到音樂列表頁面，傳遞過濾後的音樂列表
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MusicListPage(
                        musics: filteredByArtist,
                        title: title,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(8.0), // 為項目增加一些間距
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1, // 確保圖片區域是正方形
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20), // 容器圓角
                            color: Colors.green, // 容器背景顏色
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20), // 圖片圓角
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(48), // 圖片尺寸
                              // 根據歌手名稱載入對應的圖片資源，並填滿容器
                              child: Image.asset(
                                  artistLocalPath[artists[index]]!,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        // 文字內容部分
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Text(
                            artists[index], // 顯示項目索引
                            style: const TextStyle(
                                fontSize: 16, // 文字大小
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
