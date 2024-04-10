import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'data.dart';

// TODO: clean architecture

/// 使用 Provider 和 ChangeNotifier 來建立一個全域音樂播放器模型
/// 管理播放清單、目前播放音樂、播放狀態等
/// 通過將 MusicService 包裝在 ChangeNotifier 中，任何需要該數據的 Widget 都可以訪問當前的 MusicService 實例
class MusicService extends ChangeNotifier {
  // 音樂播放器實例，使用 audioplayers: ^6.0.0
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 動態傳入撥放列表
  List<Music>? _playlist;
  int _currentIndex = -1; // 目前播放音樂的索引
  Music? _currentMusic; // 目前播放的音樂
  bool _isPlaying = false; // 目前是否正在播放音樂

  //音樂持續時間
  Duration _duration = Duration.zero;
  //目前播放進度
  Duration _currentPosition = Duration.zero;

  Duration get duration => _duration;
  Duration get currentPosition => _currentPosition;
  Music? get currentMusic => _currentMusic;
  bool get isPlaying => _isPlaying;

  // 使用 AudioPlayer 播放指定的音樂
  Future<void> _play(Music music) async {
    await _audioPlayer.play(AssetSource(music.path));
  }

  // 使用 AudioPlayer 暫停播放
  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  // 使用 AudioPlayer 跳到指定播放進度
  Future<void> _seek(Duration duration) async {
    await _audioPlayer.seek(duration);
  }

  // 設定播放列表
  setPlaylist(List<Music> newPlaylist) {
    _playlist = newPlaylist;
  }

  // 播放/繼續放目前選擇的音樂
  void playMusic() {
    if (_currentMusic == null) {
      return;
    }
    _isPlaying = true;
    notifyListeners(); // 通知監聽者狀態變更:_isPlaying 的狀態改變
    _play(_currentMusic!);
  }

  // 根據索引播放音樂
  void playMusicAtIndex(int index) {
    if (_playlist == null ||
        _playlist!.isEmpty ||
        index < 0 ||
        index >= _playlist!.length) {
      return;
    }
    _currentIndex = index;
    _currentMusic = _playlist![_currentIndex];
    _isPlaying = true;
    notifyListeners(); // 通知監聽者狀態變更:_isPlaying、_currentMusic、_currentIndex 的狀態改變
    _play(_currentMusic!);
  }

  // 播放下一首音樂
  void playNext() {
    if (_playlist != null && _currentIndex < _playlist!.length - 1) {
      playMusicAtIndex(_currentIndex + 1);
    }
  }

  // 播放上一首音樂
  void playPrevious() {
    if (_currentIndex > 0) {
      playMusicAtIndex(_currentIndex - 1);
    }
  }

  // 暫停音樂
  void pauseMusic() {
    _isPlaying = false;
    notifyListeners();
    _pause();
  }

  // 設定目前播放進度
  void setCurrentPosition(Duration position) {
    _currentPosition = position;
    notifyListeners();
  }

  // 跳到指定播放進度
  void seek(Duration position) {
    _seek(position);
  }

  // 監聽音樂播放器的狀態變化
  MusicService() {
    // 取得音樂總時長
    _audioPlayer.onDurationChanged.listen((Duration newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    // 音樂播放完成時自動播放下一首
    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });

    // 更新播放進度
    _audioPlayer.onPositionChanged.listen((position) {
      setCurrentPosition(position);
    });
  }
}

// 音樂清單，使用 provider 來取得全局的音樂撥放器狀態，在不同的 page 中正確顯示或更新
class MusicListWidget extends StatefulWidget {
  final List<Music> musics;
  const MusicListWidget({super.key, required this.musics});

  @override
  MusicListWidgetState createState() => MusicListWidgetState();
}

class MusicListWidgetState extends State<MusicListWidget> {
  bool hasUpdatePlaylist = false; // 標記是否已更新播放清單，避免重複更新

  // 更新播放列表，作為子 Widget 的 Callback
  void updatePlaylist(int index) {
    if (!hasUpdatePlaylist) {
      hasUpdatePlaylist = true;

      // 透過 Provider 更新全域播放器模型的播放列表
      Provider.of<MusicService>(context, listen: false)
          .setPlaylist(widget.musics);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 使用 Consumer 來建立 UI，以回應 MusicService 中的變化
    return Consumer<MusicService>(builder: (context, musicService, child) {
      return ListView.builder(
        itemCount: widget.musics.length,
        itemBuilder: (context, index) {
          // 判斷當前項目是否正在播放
          bool isPlaying = musicService.currentMusic == widget.musics[index] &&
              musicService.isPlaying;

          // 傳回每個 item
          return MusicItemWidget(
            music: widget.musics[index],
            index: index,
            isPlaying: isPlaying,
            onPlay: updatePlaylist,
          );
        },
      );
    });
  }
}

// 表示音樂清單的 item
class MusicItemWidget extends StatelessWidget {
  final Music music; // 音樂對象
  final int index; // 清單索引
  final bool isPlaying; // 目前項目是否正在播放
  final Function(int) onPlay; // 播放時，呼叫 callback 去更新撥放清單

  const MusicItemWidget({
    super.key,
    required this.music,
    required this.index,
    required this.isPlaying,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final globalPlayer = Provider.of<MusicService>(context, listen: false);

    const titleColor = Color.fromARGB(255, 255, 237, 237);
    const subtitleColor = Color.fromARGB(255, 151, 150, 150);
    const iconColor = titleColor;
    const indexColor = titleColor;
    const selectedColor = Color.fromARGB(255, 0, 255, 119);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          // 依播放狀態調整顏色，如過世正在撥放的 music 的 item 則為 selectedColor
          child: ListTile(
            leading: Text(
              '${index + 1}',
              style: TextStyle(color: isPlaying ? selectedColor : indexColor),
            ),
            title: Text(
              music.name,
              style: TextStyle(color: isPlaying ? selectedColor : titleColor),
            ),
            subtitle: Text(
              '${music.artist} - ${music.album}',
              style:
                  TextStyle(color: isPlaying ? selectedColor : subtitleColor),
            ),
            trailing: IconButton(
              color: isPlaying ? selectedColor : iconColor,
              // 依照播放狀態調整圖標，撥放/暫停
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () async {
                if (isPlaying) {
                  // 如果正在播放，則暫停

                  globalPlayer.pauseMusic();
                } else {
                  // 否則，播放目前音樂

                  onPlay(index); // 更新撥放清單
                  globalPlayer.playMusicAtIndex(index);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// 定義一個有狀態的底部音樂控制面板
/// 透過使用 Provider，此控制面板能夠存取和控制全域的音樂播放狀態
class MusicControlPanel extends StatefulWidget {
  const MusicControlPanel({super.key});

  @override
  State<MusicControlPanel> createState() => _MusicControlPanelState();
}

class _MusicControlPanelState extends State<MusicControlPanel> {
  bool isExpanded = true; // 控制面板是否展开

  @override
  Widget build(BuildContext context) {
    // 透過 Provider 取得全域音樂服務實例
    final musicService = Provider.of<MusicService>(context);
    return GestureDetector(
      onTap: () {
        // 點擊時切換展開狀態
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      // 根據控制面板的展開狀態，選擇展示完整或簡化的面板
      child: isExpanded
          ? buildExpandPanel(musicService)
          : buildUnExpandPanel(musicService),
    );
  }

  // 建置展開狀態下的控制面板
  Widget buildExpandPanel(musicService) {
    // 定義文字顏色和滑桿啟動顏色
    const titleColor = Color.fromARGB(255, 255, 237, 237);
    const subtitleColor = Color.fromARGB(255, 151, 150, 150);
    const activeColor = Color.fromARGB(255, 32, 225, 122);
    const iconColor = Colors.white;

    // 取得全域播放狀態和當前音樂訊息
    final isPlaying = musicService.isPlaying;
    final currentMusic = musicService.currentMusic;
    final duration = musicService.duration.inSeconds.toDouble();
    final currentPosition = musicService.currentPosition.inSeconds.toDouble();

    return Container(
      height: 150,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 39, 46),
        // 圆角
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
        children: [
          // 如果有當前音樂，展示音樂訊息
          if (currentMusic != null) ...[
            // 音樂名稱
            Text(currentMusic.name, style: const TextStyle(color: titleColor)),
            // 作者、專輯名稱
            Text('${currentMusic.artist} - ${currentMusic.album}',
                style: const TextStyle(color: subtitleColor)),
          ],
          // 播放控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 水平等間距排列
            children: [
              // 播放上一首
              IconButton(
                color: iconColor,
                icon: const Icon(Icons.skip_previous),
                onPressed: musicService.playPrevious,
              ),

              // 播放/暫停
              IconButton(
                color: iconColor,
                // 根據是否正在撥放決定要顯示撥放 icon 還是暫停 icon
                icon: isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                onPressed: () {
                  if (isPlaying) {
                    // 如果正在播放，暫停音樂
                    musicService.pauseMusic();
                  } else {
                    // 否則，播放音樂
                    musicService.playMusic();
                  }
                },
              ),

              // 播放下一首
              IconButton(
                color: iconColor,
                icon: const Icon(Icons.skip_next),
                onPressed: musicService.playNext,
              ),
            ],
          ),

          // 播放進度滑桿
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: currentPosition, // 目前播放進度
              min: 0.0,
              max: duration == 0.0 ? 1.0 : duration,
              activeColor: activeColor,
              inactiveColor: Colors.grey,
              // 跳到指定播放位置
              onChanged: (value) {
                final newPosition = Duration(seconds: value.toInt());
                musicService.seek(newPosition);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 建立收起狀態下的控制面板
  Widget buildUnExpandPanel(musicService) {
    // 文字顏色定義
    const titleColor = Color.fromARGB(255, 255, 237, 237);
    const subtitleColor = Color.fromARGB(255, 151, 150, 150);
    const iconColor = Colors.white;

    // 取得全域播放狀態和當前音樂訊息
    final isPlaying = musicService.isPlaying;
    final currentMusic = musicService.currentMusic;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 39, 46),
        // 圆角
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 水平等間距排列
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 文字靠左對齊
                mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
                children: [
                  // 音樂名稱
                  Text(currentMusic.name,
                      style: const TextStyle(color: titleColor, fontSize: 16)),
                  // 作者、專輯名稱
                  Text('${currentMusic.artist} - ${currentMusic.album}',
                      style: const TextStyle(color: subtitleColor)),
                ],
              ),
            ),
            // 播放控制按钮
            Row(
              mainAxisSize: MainAxisSize.min, // 寬度僅足以容納子 widget
              children: [
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: musicService.playPrevious,
                ),
                IconButton(
                  color: iconColor,
                  icon: isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  onPressed: () {
                    if (isPlaying) {
                      musicService.pauseMusic();
                    } else {
                      musicService.playMusic();
                    }
                  },
                ),
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.skip_next),
                  onPressed: musicService.playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
