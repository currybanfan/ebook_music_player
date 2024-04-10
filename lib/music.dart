import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class GlobalMusicPlayerModel extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Music>? _playlist;
  int _currentIndex = -1;
  Music? _currentMusic;
  bool _isPlaying = false;

  //音樂持續時間
  Duration _duration = Duration.zero;
  //目前播放進度
  Duration _currentPosition = Duration.zero;

  Duration get duration => _duration;
  Duration get currentPosition => _currentPosition;

  Music? get currentMusic => _currentMusic;
  bool get isPlaying => _isPlaying;

  Future<void> _play(Music music) async {
    await _audioPlayer.play(AssetSource(music.path));
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  Future<void> _seek(Duration duration) async {
    await _audioPlayer.seek(duration);
  }

  setPlaylist(List<Music> newPlaylist) {
    _playlist = newPlaylist;
  }

  void playMusic() {
    if (_currentMusic == null) {
      return;
    }
    _isPlaying = true;
    notifyListeners();
    _play(_currentMusic!);
  }

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
    notifyListeners();
    _play(_currentMusic!);
  }

  void playNext() {
    if (_playlist != null && _currentIndex < _playlist!.length - 1) {
      playMusicAtIndex(_currentIndex + 1);
    }
  }

  void playPrevious() {
    if (_currentIndex > 0) {
      playMusicAtIndex(_currentIndex - 1);
    }
  }

  void pauseMusic() {
    _isPlaying = false;
    notifyListeners();
    _pause();
  }

  void setCurrentPosition(Duration position) {
    _currentPosition = position;
    notifyListeners();
  }

  void seek(Duration position) {
    _seek(position);
  }

  GlobalMusicPlayerModel() {
    _audioPlayer.onDurationChanged.listen((Duration newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setCurrentPosition(position);
    });
  }
}

class MusicListWidget extends StatefulWidget {
  final List<Music> musics;
  const MusicListWidget({super.key, required this.musics});

  @override
  MusicListWidgetState createState() => MusicListWidgetState();
}

class MusicListWidgetState extends State<MusicListWidget> {
  bool hasUpdatePlaylist = false;

  void updatePlaylist(int index) {
    if (!hasUpdatePlaylist) {
      hasUpdatePlaylist = true;

      Provider.of<GlobalMusicPlayerModel>(context, listen: false)
          .setPlaylist(widget.musics);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalMusicPlayerModel>(
        builder: (context, globalPlayer, child) {
      return ListView.builder(
        itemCount: widget.musics.length,
        itemBuilder: (context, index) {
          bool isPlaying = globalPlayer.currentMusic == widget.musics[index] &&
              globalPlayer.isPlaying;

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

class MusicItemWidget extends StatelessWidget {
  final Music music;
  final int index;
  final bool isPlaying;
  final Function(int) onPlay;

  const MusicItemWidget({
    super.key,
    required this.music,
    required this.index,
    required this.isPlaying,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final globalPlayer =
        Provider.of<GlobalMusicPlayerModel>(context, listen: false);

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
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () async {
                if (isPlaying) {
                  globalPlayer.pauseMusic();
                } else {
                  onPlay(index);
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

class MusicControlPanel extends StatefulWidget {
  const MusicControlPanel({super.key});

  @override
  State<MusicControlPanel> createState() => _MusicControlPanelState();
}

class _MusicControlPanelState extends State<MusicControlPanel> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final globalPlayer = Provider.of<GlobalMusicPlayerModel>(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: isExpanded
          ? buildExpandPanel(globalPlayer)
          : buildUnExpandPanel(globalPlayer),
    );
  }

  Widget buildExpandPanel(globalPlayer) {
    const titleColor = Color.fromARGB(255, 255, 237, 237);
    const subtitleColor = Color.fromARGB(255, 151, 150, 150);
    const activeColor = Color.fromARGB(255, 32, 225, 122);

    final isPlaying = globalPlayer.isPlaying;
    final currentMusic = globalPlayer.currentMusic;
    final duration = globalPlayer.duration.inSeconds.toDouble();
    final currentPosition = globalPlayer.currentPosition.inSeconds.toDouble();

    const iconColor = Colors.white;
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 39, 46),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentMusic != null) ...[
            Text(currentMusic.name, style: const TextStyle(color: titleColor)),
            Text('${currentMusic.artist} - ${currentMusic.album}',
                style: const TextStyle(color: subtitleColor)),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: iconColor,
                icon: const Icon(Icons.skip_previous),
                onPressed: globalPlayer.playPrevious,
              ),
              IconButton(
                color: iconColor,
                icon: isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                onPressed: () {
                  if (isPlaying) {
                    globalPlayer.pauseMusic();
                  } else {
                    globalPlayer.playMusic();
                  }
                },
              ),
              IconButton(
                color: iconColor,
                icon: const Icon(Icons.skip_next),
                onPressed: globalPlayer.playNext,
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: currentPosition,
              min: 0.0,
              max: duration == 0.0 ? 1.0 : duration,
              activeColor: activeColor,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                final newPosition = Duration(seconds: value.toInt());
                globalPlayer.seek(newPosition);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUnExpandPanel(globalPlayer) {
    const titleColor = Color.fromARGB(255, 255, 237, 237);
    const subtitleColor = Color.fromARGB(255, 151, 150, 150);
    const iconColor = Colors.white;

    final isPlaying = globalPlayer.isPlaying;
    final currentMusic = globalPlayer.currentMusic;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 24, 39, 46),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentMusic.name,
                      style: const TextStyle(color: titleColor, fontSize: 16)),
                  Text('${currentMusic.artist} - ${currentMusic.album}',
                      style: const TextStyle(color: subtitleColor)),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min, // 让 Row 占用的宽度仅足以容纳其子部件
              children: [
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: globalPlayer.playPrevious,
                ),
                IconButton(
                  color: iconColor,
                  icon: isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  onPressed: () {
                    if (isPlaying) {
                      globalPlayer.pauseMusic();
                    } else {
                      globalPlayer.playMusic();
                    }
                  },
                ),
                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.skip_next),
                  onPressed: globalPlayer.playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
