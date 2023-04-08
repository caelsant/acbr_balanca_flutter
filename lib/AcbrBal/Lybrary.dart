// ignore_for_file: file_names
library acbr_balanca_flutter;

import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

abstract class Lybrary {
  String get libraryPath;
  DynamicLibrary _getMyLibrary() {
    return DynamicLibrary.open(libraryPath);
  }

  DynamicLibrary get library => _getMyLibrary();
}

class AcbrBallLibrary extends Lybrary {
  bool get is64bits =>
      Platform.isWindows ? Platform.version.contains("x64") : false;

  @override
  String get libraryPath => path.join(Directory.current.path, "lib", "dll",
      is64bits ? "ACBrBAL64.dll" : "ACBrBAL32.dll");
}
