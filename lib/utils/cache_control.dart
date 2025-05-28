import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheControl {
  static final CacheControl _cacheControl = CacheControl._internal();
  static CacheControl get instance => _cacheControl;
  factory CacheControl() {
    return _cacheControl;
  }

  late CacheManager _cacheManager;

  CacheControl._internal() {
    _cacheManager = CacheManager(
      Config('cache_manager', stalePeriod: const Duration(days: 31)),
    );
  }

  void getFileStream(String url) {
    _cacheManager.getFileStream(
      url,
      withProgress: true,
    );
  }

  Future<void> putFileUint8List(String url, Uint8List data,
      {String fileExtension = "file"}) async {
    await _cacheManager.putFile(url, data,
        maxAge: const Duration(days: 365), fileExtension: fileExtension);
  }

  Future<File> getSingleFile(String url) async {
    return await _cacheManager.getSingleFile(url);
  }

  Future<FileInfo> downloadFile(String url) async {
    return await _cacheManager.downloadFile(url);
  }

  Future<String> getFileFromCache(String url) async {
    FileInfo? fileInfo = await _cacheManager.getFileFromCache(url);
    if (fileInfo != null) {
      return fileInfo.file.path;
      // Sử dụng
      // fileInfo.file để truy xuất đến tệp tin đã được lưu trữ trong cache.
    } else {
      return "";
    }
  }

  Future<void> removeFileCache(String url) async {
    await _cacheManager.removeFile(url);
  }

  Future<void> emptyCache() async {
    await _cacheManager.emptyCache();
  }
}
