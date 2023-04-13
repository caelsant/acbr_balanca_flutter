// ignore_for_file: file_names
library acbr_balanca_flutter;

import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart';

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

  String getPath() {
    String path = join("C:", "Windows", is64bits ? "System32" : "SysWOW64");
    return path;
  }

  @override
  String get libraryPath =>
      join(getPath(), is64bits ? "ACBrBAL64.dll" : "ACBrBAL32.dll");
}
