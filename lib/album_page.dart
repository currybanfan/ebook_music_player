import 'package:flutter/material.dart';
import 'music_list_page.dart';
import 'data.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        const Expanded(
          flex: 1,
          child: Text(
            '專輯',
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
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  List<Music> filteredByAlbum = musicData
                      .where((music) => music.album == albums[index])
                      .toList();
                  String title = albums[index];

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MusicListPage(
                        musics: filteredByAlbum,
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
                              child: Image.asset(albumLocalPath[albums[index]]!,
                                  fit: BoxFit.cover), // 載入並顯示圖片
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        // 文字內容部分
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: Text(
                            albums[index], // 顯示項目索引
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
