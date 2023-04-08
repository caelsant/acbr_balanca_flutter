/* library acbr_balanca_flutter;

import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:acbr_balanca_flutter/AcbrBal/acbrbal_native_func.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;
import '../acbr_balanca.dart';
import 'Lybrary.dart';
import 'acbrbal_enum.dart';

class AcbrBallImpl extends IAcbrBal {
  String iniPath = path.join(Directory.current.path, "assets", "ACBrLib.ini");
  AcbrBallLibrary lib = AcbrBallLibrary();

  @override
  int inicializar() {
    Function init = lib.library
        .lookup<ffi.NativeFunction<NATIVE_INITBAL>>(AcbrFuncDoc.iniciar.func)
        .asFunction<int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>();

    int callInit = init.call(iniPath.toNativeUtf8(), "".toNativeUtf8());
    return callInit;
  }

  @override
  String lePesoString({int? timeOutMilliseconds}) {
    //String que recebe o peso da dll
    ffi.Pointer<ffi.Int> referenceIntMilliseconds =
        calloc.allocate<ffi.Int>(200);
    ffi.Pointer<ffi.Double> referenceDoublePeso =
        calloc.allocate<ffi.Double>(256);

    final lePesoStirng = lib.library
        .lookup<ffi.NativeFunction<NATIVE_LEPESO>>(AcbrFuncDoc.lePeso.func)
        .asFunction<
            int Function(ffi.Pointer<ffi.Int>, ffi.Pointer<ffi.Double>)>();

    int callLePesoString =
        lePesoStirng.call(referenceIntMilliseconds, referenceDoublePeso);

    print("Lendo peso: $callLePesoString | ${referenceDoublePeso.value}");

    calloc.free(referenceIntMilliseconds);
    calloc.free(referenceDoublePeso);
    return "";
  }

  getVersao() {
    final versao = lib.library.lookup(AcbrFuncDoc.versao.func);
  }

  @override
  int finalizar() {
    final finalizarFunc = lib.library
        .lookup<ffi.NativeFunction<ffi.Int Function()>>(
            AcbrFuncDoc.finalizar.func)
        .asFunction<int Function()>();
    int callFinalizarFunc = finalizarFunc.call();

    print("Finalziando lib: $callFinalizarFunc");
    return 0;
  }

  @override
  int desativar() {
    // TODO: implement desativar
    throw UnimplementedError();
  }

  @override
  int ativar() {
    // TODO: implement ativar
    throw UnimplementedError();
  }

  @override
  double lePeso({int? timeOutMilliseconds}) {
    // TODO: implement lePeso
    throw UnimplementedError();
  }
}
 */