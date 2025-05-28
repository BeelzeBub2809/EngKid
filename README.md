# Các lệnh run trong app:

run dev web: flutter run -d chrome ./lib/main_dev.dart --web-renderer html
run dev mode: flutter run --flavor dev -t ./lib/main_dev.dart
build dev apk: flutter build apk --flavor dev -t lib/main_dev.dart --release (Dùng để tạo file apk)

run prod web: flutter run -d chrome ./lib/main_prod.dart --web-renderer html
run prod mode: flutter run --flavor prod -t ./lib/main_prod.dart
build prod apk: flutter build apk --flavor prod -t lib/main_prod.dart --release (Dùng để tạo file apk)

generate code once: flutter pub run build_runner build --delete-conflicting-outputs
generate code every save file: flutter pub run build_runner watch --delete-conflicting-outputs

#flutter version: 3.13.6
