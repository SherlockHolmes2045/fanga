import 'dart:io';

  Map<String, double> dirStatSync(String dirPath) {
    double fileNum = 0;
    double totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir.listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
    totalSize = (totalSize / 1024)/1024;
    return {'fileNum': fileNum, 'size': totalSize};
  }
