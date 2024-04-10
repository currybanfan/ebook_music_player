class Music {
  String path; // 音樂文件的路徑
  String artist; // 藝術家名稱
  String album; // 專輯名稱
  String name; // 歌曲名稱

  Music({
    required this.path,
    required this.artist,
    required this.album,
    required this.name,
  });
}

// 存儲 Music 對象的清單
List<Music> musicData = [
  Music(
      path: 'sounds/Cold_Hearted.mp3',
      artist: 'Jay Chou',
      album: '最偉大的作品',
      name: '紅顏如霜'),
  Music(
      path: 'sounds/Greatest_Works_of_Art.mp3',
      artist: 'Jay Chou',
      album: '最偉大的作品',
      name: '最偉大的作品'),
  Music(
      path: 'sounds/If_You_Dont_Love_Me_Its_Fine.mp3',
      artist: 'Jay Chou',
      album: '最偉大的作品',
      name: '不愛我就拉倒'),
  Music(
      path: 'sounds/Wont_Cry.mp3',
      artist: 'Jay Chou',
      album: '最偉大的作品',
      name: '說好不哭'),
  Music(
      path: 'sounds/Dad_Im_home.mp3',
      artist: 'Jay Chou',
      album: '范特西',
      name: '爸 我回來了'),
  Music(
      path: 'sounds/Find_It_Hard_To_Say.mp3',
      artist: 'Jay Chou',
      album: '范特西',
      name: '開不了口'),
  Music(
      path: 'sounds/Sorry.mp3', artist: 'Jay Chou', album: '范特西', name: '對不起'),
  Music(
      path: 'sounds/Still_Wandering.mp3',
      artist: 'Jay Chou',
      album: '范特西',
      name: '還在流浪'),
  Music(
      path: 'sounds/Simple_Love.mp3',
      artist: 'Jay Chou',
      album: '范特西',
      name: '簡單愛'),
  Music(
      path: 'sounds/Love_before_AD.mp3',
      artist: 'Jay Chou',
      album: '范特西',
      name: '愛在西元前'),
  Music(
      path: 'sounds/Insane.mp3',
      artist: 'MC HotDog',
      album: '差不多先生',
      name: '我瘋了'),
  Music(
      path: 'sounds/Mr_Almost.mp3',
      artist: 'MC HotDog',
      album: '差不多先生',
      name: '差不多先生'),
  Music(
      path: 'sounds/King_Wasted.mp3',
      artist: 'MC HotDog',
      album: '差不多先生',
      name: '瞎王之王'),
  Music(
      path: 'sounds/I_Ha_You.mp3',
      artist: 'MC HotDog',
      album: '差不多先生',
      name: '我哈你'),
  Music(
      path: 'sounds/Thank_you.mp3',
      artist: 'MC HotDog',
      album: '差不多先生',
      name: '謝謝啞唬'),
  Music(
      path: 'sounds/Tomoshibi.mp3',
      artist: 'vaundy',
      album: 'strodo',
      name: '灯火'),
  Music(
      path: 'sounds/Tokyo_Flash.mp3',
      artist: 'vaundy',
      album: 'strodo',
      name: '東京フラッシュ'),
  Music(
      path: 'sounds/Kaiju_no_Hanauta.mp3',
      artist: 'vaundy',
      album: 'strodo',
      name: '怪獣の花唄'),
  Music(
      path: 'sounds/Fukakoryoku.mp3',
      artist: 'vaundy',
      album: 'strodo',
      name: '不可幸力'),
];

final Map<String, String> artistLocalPath = {
  'Jay Chou': 'assets/images/Jay_Chou.jpg',
  'MC HotDog': 'assets/images/MC_HotDog.jpg',
  'vaundy': 'assets/images/vaundy.jpg',
};
final Map<String, String> albumLocalPath = {
  '范特西': 'assets/images/Fantasy.jpg',
  '最偉大的作品': 'assets/images/Greatest_Works_of_Art.jpg',
  '差不多先生': 'assets/images/Mr_Almost.jpg',
  'strodo': 'assets/images/strodo.jpg',
};

// 從 musicData 清單中提取所有藝術家名稱，移除重複項，並轉換成清單
List<String> artists = musicData.map((m) => m.artist).toSet().toList();

// 從 musicData 清單中提取所有專輯名稱，移除重複項，並轉換成清單
List<String> albums = musicData.map((m) => m.album).toSet().toList();
