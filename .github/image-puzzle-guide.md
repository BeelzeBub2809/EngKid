# 🧩 HƯỚNG DẪN IMAGE PUZZLE GAME - ENGKID

## 📋 TỔNG QUAN
Image Puzzle Game là một trò chơi xếp hình ảnh giáo dục trong ứng dụng EngKid, giúp trẻ em học từ vựng tiếng Anh thông qua việc ghép các mảnh ảnh thành bức tranh hoàn chỉnh.

## 🎯 GAME LOGIC
### Cách chơi:
1. **Hiển thị tranh hoàn chỉnh**: Game sẽ hiển thị bức tranh hoàn chỉnh trong 10 giây đầu
2. **Chia nhỏ tranh**: Tranh được chia thành các mảnh tương ứng với số chữ cái trong từ
3. **Shuffle mảnh**: Các mảnh được xáo trộn ngẫu nhiên 
4. **Kéo thả**: Người chơi kéo thả các mảnh để ghép thành tranh hoàn chỉnh
5. **Hiển thị từ**: Mỗi mảnh có chữ cái tương ứng hiển thị bên dưới
6. **Hoàn thành**: Khi ghép đúng, hiển thị từ hoàn chỉnh và phát âm

### Kỹ thuật xác định hoàn thành:
- So sánh vị trí hiện tại của từng mảnh với vị trí đúng
- Sử dụng threshold (khoảng cách cho phép) để xác định mảnh đã đúng vị trí
- Kiểm tra tất cả mảnh đều ở vị trí đúng

## 🏗️ CẤU TRÚC FILE

### 📁 lib/presentation/game/image_puzzle/
```
image_puzzle/
├── image_puzzle_binding.dart     # Dependency injection setup
├── image_puzzle_controller.dart  # Game logic và state management  
└── image_puzzle_ui.dart         # UI components và layout
```

### 📁 lib/domain/core/entities/
```
entities/
└── image_puzzle/
    ├── puzzle_piece.dart         # Entity cho từng mảnh puzzle
    ├── puzzle_game_data.dart     # Entity cho data game
    └── puzzle_word.dart          # Entity cho từ vựng
```

## 🎮 CONTROLLER STRUCTURE

### ImagePuzzleGameController extends GetxController
```dart
class ImagePuzzleGameController extends GetxController {
  // Observable states
  final RxList<PuzzlePiece> puzzlePieces = <PuzzlePiece>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCompleted = false.obs;
  final RxBool showPreview = true.obs;
  final RxInt previewTimer = 10.obs;
  
  // Game data
  late PuzzleGameData currentPuzzle;
  
  // Methods
  void initGame(PuzzleGameData gameData);
  void shufflePieces();
  void onPieceDragged(int pieceIndex, Offset newPosition);
  bool checkGameCompletion();
  void playWordPronunciation();
  void resetGame();
}
```

### Key Methods:
- **initGame()**: Khởi tạo game với data từ API
- **shufflePieces()**: Xáo trộn vị trí các mảnh
- **onPieceDragged()**: Xử lý khi người dùng kéo mảnh
- **checkGameCompletion()**: Kiểm tra game đã hoàn thành chưa
- **playWordPronunciation()**: Phát âm từ vựng

## 🎨 UI COMPONENTS

### Main Layout Structure:
```dart
class ImagePuzzleGameUI extends GetView<ImagePuzzleGameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header với timer và điểm số
          _buildHeader(),
          
          // Preview area (hiện trong 10s đầu)
          Obx(() => controller.showPreview.value 
            ? _buildPreviewArea() 
            : _buildGameArea()),
          
          // Draggable pieces area
          _buildPuzzlePiecesArea(),
        ],
      ),
    );
  }
}
```

### Key UI Components:
- **PreviewArea**: Hiển thị tranh hoàn chỉnh trong 10s
- **GameArea**: Khu vực chính để ghép tranh
- **DraggablePieces**: Các mảnh có thể kéo thả
- **DropTargets**: Vị trí đích để thả mảnh
- **WordDisplay**: Hiển thị từ vựng khi hoàn thành

## 🔧 ENTITIES STRUCTURE

### PuzzlePiece
```dart
@freezed
class PuzzlePiece with _$PuzzlePiece {
  const factory PuzzlePiece({
    required int id,
    required String imageUrl,
    required String letter,
    required int correctPosition,
    required Offset currentPosition,
    required bool isPlaced,
    required Size pieceSize,
  }) = _PuzzlePiece;
  
  factory PuzzlePiece.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePieceFromJson(json);
}
```

### PuzzleGameData  
```dart
@freezed
class PuzzleGameData with _$PuzzleGameData {
  const factory PuzzleGameData({
    required int id,
    required String word,
    required String fullImageUrl,
    required String audioUrl,
    required List<String> pieceImageUrls,
    required int difficulty,
    required String category,
  }) = _PuzzleGameData;
  
  factory PuzzleGameData.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGameDataFromJson(json);
}
```

## 🌐 API INTEGRATION

### Endpoints:
```dart
// Lấy danh sách puzzle games
GET /api/puzzle-games?difficulty={level}&category={category}

// Lấy chi tiết một puzzle
GET /api/puzzle-games/{id}

// Submit kết quả game
POST /api/puzzle-games/{id}/complete
Body: {
  "completed_time": int,
  "attempts": int,
  "score": int
}
```

### Service Methods:
```dart
class PuzzleGameService {
  Future<List<PuzzleGameData>> getPuzzleGames();
  Future<PuzzleGameData> getPuzzleGameById(int id);
  Future<bool> submitGameResult(int gameId, GameResult result);
}
```

## 🎵 AUDIO INTEGRATION

### Audio Components:
- **Background Music**: Nhạc nền trong game
- **Sound Effects**: Âm thanh khi kéo thả, hoàn thành
- **Word Pronunciation**: Phát âm từ vựng

### Implementation:
```dart
class AudioManager {
  late AudioPlayer _audioPlayer;
  late AudioPlayer _sfxPlayer;
  
  Future<void> playBackgroundMusic();
  Future<void> playPiecePlacedSound();
  Future<void> playCompletionSound();
  Future<void> playWordPronunciation(String audioUrl);
}
```

## 🎮 GAME STATES

### State Management với GetX:
```dart
enum GameState {
  preview,      // Hiển thị tranh hoàn chỉnh
  playing,      // Đang chơi
  completed,    // Đã hoàn thành
  paused,       // Tạm dừng
}

final Rx<GameState> gameState = GameState.preview.obs;
```

## 🔍 DEBUGGING & TROUBLESHOOTING

### Common Issues:

1. **Pieces not draggable**
   - Check if Draggable widget is properly wrapped
   - Verify onDragEnd callback is implemented

2. **Game completion not detected**
   - Check threshold values for position comparison
   - Verify all pieces have correct target positions

3. **Audio not playing**
   - Check audio file paths and permissions
   - Verify AudioPlayer initialization

4. **Performance issues**
   - Optimize image loading with caching
   - Use RepaintBoundary for better performance

### Debug Commands:
```bash
# Enable debug mode
flutter run --debug

# Profile performance
flutter run --profile

# Check widget tree
flutter inspector
```

## 🚀 SETUP & INSTALLATION

### Dependencies Required:
```yaml
dependencies:
  flame: ^1.7.3          # Game engine
  just_audio: ^0.9.34    # Audio playback
  cached_network_image: ^3.2.3  # Image caching
  get: ^4.6.5            # State management
```

### File Generation:
```bash
# Generate freezed classes
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch
```

## 📱 TESTING

### Unit Tests:
```dart
// Test game logic
testWidgets('should complete game when all pieces in correct position', (tester) async {
  // Test implementation
});

// Test audio integration
test('should play word pronunciation when game completed', () async {
  // Test implementation  
});
```

### Integration Tests:
- Test complete game flow
- Test API integration
- Test audio playback
- Test state management

## 🎯 PERFORMANCE OPTIMIZATION

### Best Practices:
1. **Image Caching**: Use CachedNetworkImage cho remote images
2. **Memory Management**: Dispose controllers properly
3. **Lazy Loading**: Load puzzle pieces on demand
4. **Animation Optimization**: Use RepaintBoundary
5. **State Optimization**: Minimize rebuilds với GetX

### Memory Management:
```dart
@override
void onClose() {
  _audioPlayer.dispose();
  _animationController.dispose();
  super.onClose();
}
```

## 🔐 SECURITY CONSIDERATIONS

1. **API Security**: Validate game data from server
2. **Asset Security**: Secure image and audio URLs
3. **Input Validation**: Validate user interactions
4. **Data Privacy**: Don't store sensitive user data locally

## 📋 CHECKLIST KHI IMPLEMENT

### ✅ Setup Phase:
- [ ] Tạo entities với Freezed
- [ ] Setup controller với GetX
- [ ] Tạo binding cho dependency injection
- [ ] Setup routing trong AppRoute

### ✅ Development Phase:
- [ ] Implement game logic trong controller
- [ ] Tạo UI components responsive
- [ ] Integrate audio system
- [ ] Add animations và transitions
- [ ] Handle loading states

### ✅ Testing Phase:
- [ ] Unit test cho game logic
- [ ] Widget test cho UI components
- [ ] Integration test cho complete flow
- [ ] Performance testing
- [ ] Audio testing on different devices

### ✅ Deployment Phase:
- [ ] Optimize assets size
- [ ] Test trên multiple devices
- [ ] Verify audio permissions
- [ ] Check memory usage
- [ ] Validate API integration

## 🐛 KNOWN ISSUES & SOLUTIONS

### Issue 1: Dragging performance
**Problem**: Lag khi kéo nhiều pieces
**Solution**: Use RepaintBoundary và optimize rebuild logic

### Issue 2: Audio delay
**Problem**: Delay khi phát âm thanh
**Solution**: Preload audio files trong initState

### Issue 3: Memory leaks
**Problem**: Memory tăng sau nhiều lần chơi
**Solution**: Proper dispose của controllers và players

## 📚 REFERENCES

- [Flame Engine Documentation](https://docs.flame-engine.org/)
- [GetX State Management](https://pub.dev/packages/get)
- [Just Audio Documentation](https://pub.dev/packages/just_audio)
- [Flutter Draggable Widget](https://api.flutter.dev/flutter/widgets/Draggable-class.html)

---

**📝 Note**: Đây là hướng dẫn chi tiết cho Image Puzzle Game. Khi gặp vấn đề, hãy tham khảo phần Debugging & Troubleshooting hoặc kiểm tra Known Issues section.
