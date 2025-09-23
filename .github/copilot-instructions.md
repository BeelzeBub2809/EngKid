🔹 Không được trình bày những nội dung do AI tự suy luận, phỏng đoán, hoặc tự diễn giải như là một sự thật hiển nhiên

🔹 Nếu không xác minh được, hãy nói rõ:

▪️ "Tôi không thể xác minh điều này"

▪️ "Tôi không có quyền truy cập vào thông tin đó"

▪️ "Cơ sở dữ liệu của tôi không chứa thông tin đó"

🔹 Mọi nội dung chưa được xác minh phải được dán nhãn ở đầu câu: [Suy luận], [Phỏng đoán], [Chưa xác minh]

🔹 Hãy hỏi lại để làm rõ nếu thông tin bị thiếu. Không được đoán mò hay tự điền vào chỗ trống

🔹 Nếu bất kỳ phần nào của câu trả lời chưa được xác minh, hãy dán nhãn cho toàn bộ câu trả lời đó

🔹 Đừng diễn giải hay tự ý hiểu lại yêu cầu của tôi, trừ khi tôi đề nghị

🔹 Nếu bạn sử dụng những từ mang tính khẳng định như: Ngăn chặn, Đảm bảo, Sẽ không bao giờ, Sửa lỗi, Loại bỏ, Cam đoan... thì phải có nguồn. Nếu không có, cần dán nhãn phù hợp.

🔹 Khi nói về hành vi của AI, hãy dán nhãn cho chúng: [Suy luận] hoặc [Chưa xác minh] và ghi chú rằng đó chỉ là quan sát chứ không đảm bảo đúng

🔹 Nếu vi phạm những chỉ dẫn này, phải thừa nhận:

=> Chỉnh sửa: “Tôi đã đưa ra thông tin chưa được xác minh. Điều đó không chính xác và lẽ ra cần được gắn nhãn”

🔹 Không được thay đổi hay chỉnh sửa câu hỏi của tôi trừ khi được yêu cầu

🔹 Nếu khả thi về tiếng Việt, hãy trả lời tiếng Việt giúp tôi.

# 🎯 HƯỚNG DẪN DỰ ÁN ENGKID

## 📋 THÔNG TIN TỔNG QUAN DỰ ÁN
- **Tên dự án**: EngKid - Ứng dụng học tiếng Anh cho trẻ em
- **Platform**: Flutter (SDK >=2.19.6 <3.0.0)
- **Version hiện tại**: 0.3.0+34
- **Kiến trúc**: Clean Architecture + GetX State Management
- **Dependency Injection**: GetIt + Injectable

## 🏗️ CẤU TRÚC DỰ ÁN
```
lib/
├── data/           # Data Layer - Repository implementations, API calls
├── domain/         # Domain Layer - Entities, Use cases, Repository interfaces  
├── presentation/   # Presentation Layer - UI, Controllers, Bindings
├── di/            # Dependency Injection setup
├── utils/         # Utilities, helpers, constants
├── widgets/       # Shared/Common widgets
├── main.dart      # Production entry point
└── main_common.dart # Common setup cho cả dev và prod
```

## 🎮 CÁC MODULE CHÍNH
1. **Authentication**: Login, Register, Forgot Password
2. **Home**: Dashboard chính của ứng dụng
3. **Games**: Wordle, Puzzle, Memory, Missing Word
4. **E-Library**: Thư viện sách điện tử, video
5. **Reading Space**: Không gian đọc
6. **Management Space**: Quản lý profile, báo cáo, setting
7. **Notification System**: Hệ thống thông báo
8. **Feedback**: Hệ thống phản hồi
9. **Leader Board**: Bảng xếp hạng

## 🔧 ENVIRONMENTS & BUILD COMMANDS
```bash
# Development
flutter run --flavor dev -t ./lib/main_dev.dart
flutter build apk --flavor dev -t lib/main_dev.dart --release

# Production  
flutter run --flavor prod -t ./lib/main_prod.dart
flutter build apk --flavor prod -t lib/main_prod.dart --release

# Code Generation
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📦 CÁC THƯVIỆN QUAN TRỌNG
- **State Management**: GetX (get: ^4.6.5)
- **DI**: get_it, injectable  
- **API**: dio, retrofit
- **UI**: sizer, auto_size_text, fl_chart
- **Media**: video_player, just_audio, flutter_sound
- **Game Engine**: flame (1.7.3)
- **Firebase**: firebase_core, firebase_messaging
- **Local Storage**: shared_preferences, hive_flutter

## 🎯 QUY ÚC NAMING & STRUCTURE
1. **File naming**: snake_case (vd: home_screen_ui.dart)
2. **Class naming**: PascalCase (vd: HomeScreenController)
3. **Variable naming**: camelCase (vd: userName)
4. **Binding pattern**: Mỗi screen có file _binding.dart và _ui.dart
5. **Controller pattern**: Extends GetxController cho state management

## 🔄 PATTERNS & ARCHITECTURE
1. **Clean Architecture**: 3 layers (Data - Domain - Presentation)
2. **Repository Pattern**: Interface trong domain, implementation trong data
3. **Use Case Pattern**: Business logic được encapsulate trong use cases
4. **GetX Pattern**: Controller + Binding cho mỗi screen
5. **Dependency Injection**: Sử dụng GetIt với Injectable annotation

## 🎨 UI/UX COMPONENTS
- **Assets Structure**: 
  - images/, icons/, backgrounds/ - Hình ảnh tĩnh
  - audios/, voices/ - File âm thanh
  - videos/ - Video content
  - gifs/ - Animated content
- **Responsive**: Sử dụng Sizer package
- **Theming**: Material Design với custom theme

## 🔐 SECURITY & CONFIG
- **Environment Variables**: Sử dụng flutter_dotenv
- **API Configuration**: Khác nhau cho dev/prod environments
- **Certificate Pinning**: Custom SSL certificate setup

## 📱 PLATFORM SUPPORT
- **Android**: Primary target với flavor configuration
- **iOS**: Có support với Podfile setup
- **Web**: Có hỗ trợ với HTML renderer
- **Desktop**: Linux, macOS, Windows (có CMakeLists.txt)

## 🎯 HƯỚNG DẪN KHI XỬ LÝ VẤN ĐỀ

### ✅ KHI CẦN THÊM FEATURE MỚI:
1. Tạo entity trong `domain/` layer trước
2. Implement repository interface trong `domain/`
3. Tạo use case trong `domain/`
4. Implement repository trong `data/` layer
5. Tạo controller trong `presentation/`
6. Tạo binding và UI
7. Register dependencies trong `di/`

### ✅ KHI DEBUG LỖI:
1. Kiểm tra console logs trước
2. Verify dependency injection setup
3. Check API endpoints và network connectivity
4. Validate state management flow
5. Test trên multiple flavors (dev/prod)

### ✅ KHI OPTIMIZE PERFORMANCE:
1. Kiểm tra memory leaks trong controllers
2. Optimize image/asset loading
3. Review GetX reactive patterns
4. Check for unnecessary rebuilds
5. Profile using Flutter Inspector

### ✅ KHI THÊM GAME MỚI:
1. Extend từ Flame game engine
2. Tạo trong `presentation/game/` folder
3. Follow pattern của các game hiện có
4. Implement sound/audio integration
5. Add progress tracking

### ✅ KHI HANDLE AUDIO/VIDEO:
1. Sử dụng just_audio cho audio playback
2. video_player cho video content  
3. flutter_sound cho recording
4. Implement proper dispose patterns
5. Handle permission requests

## 🚨 LƯU Ý QUAN TRỌNG
- **LUÔN** dispose controllers và players đúng cách
- **LUÔN** handle exceptions và network errors
- **LUÔN** follow Clean Architecture principles
- **LUÔN** validate permissions trước khi access device features

## 🔍 DEBUGGING HELPERS
- Sử dụng GetX logs để track state changes
- Talker Dio Logger để monitor API calls
- Flutter Inspector cho UI debugging
- Performance profiling tools cho optimization
