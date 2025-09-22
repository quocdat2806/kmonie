import 'dart:io';

class FileUtils {
  FileUtils._();
  static const double fileSizeLimited = 10;

  static double getFileSize(File file) {
    final int sizeInBytes = file.lengthSync();
    final double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }
}
