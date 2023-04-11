library acbr_balanca_flutter;

import 'dart:async';

import 'package:path/path.dart';
import 'dart:io';

import 'package:acbr_balanca_flutter/AcbrBal/Lybrary.dart';
import 'package:acbr_balanca_flutter/AcbrBal/acbrbal_enum.dart';
import 'package:acbr_balanca_flutter/ErrorHandling.dart';
import 'package:acbr_balanca_flutter/Exceptions/AcbrBalException.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;
import 'AcbrBal/acbrbal_native_func.dart';

abstract class IAcbrBal {
  Future<Errorhandling<int, String>> inicializar(String arquivoIni,
      {String? chaveCrypt});
  Future<Errorhandling<int, String>> finalizar();
  Future<Errorhandling<int, String>> ativar();
  Future<Errorhandling<int, String>> desativar();
  Future<Errorhandling<double, String>> lePeso({int? timeOutMilliseconds});
  Future<Errorhandling<double, String>> lePesoAutomaticamente(
      {required String arquivoIni, int? timeOutMilliseconds});
}

class AcbrBalanca implements IAcbrBal {
  final lib = AcbrBallLibrary();

  Future<Errorhandling<String, String>> _iniFile(String path) async {
    Future<bool> verificarArquivoIniBalanca(File iniFile) async {
      String arquivo = iniFile.readAsStringSync();

      bool verificarSeContemChaves = arquivo.contains("BAL") &&
          arquivo.contains("BAL_Device") &&
          arquivo.contains("ACBrLibBAL");
      if (verificarSeContemChaves == false) {
        return false;
      }
      return iniFile.path.contains(".ini");
    }

    //Primeiro verificar se há o arquivo

    if (path.isEmpty || !path.contains("\\") || !path.contains(":")) {
      return error("Caminho invalido");
    }

    File iniFile = File(path);

    if (!iniFile.existsSync()) {
      File createIniFile = File(join(iniFile.path, "ACBrLib.ini"));
      try {
        File arquivoCriado = await createIniFile.create();
      } catch (e) {
        return error(e.toString());
      }

      return error(
          "Arquivo ini, inexistente, criando um novo em: ${createIniFile.path}");
    }

    if (await verificarArquivoIniBalanca(iniFile) == false) {
      return error("Arquivo ini exite, porém é invalido, configurar ele");
    }

    return sucess(iniFile.path);
  }

  @override
  Future<Errorhandling<int, String>> ativar() async {
    final ativarBalancaNativeFunc = lib.library
        .lookup<ffi.NativeFunction<ffi.Int Function()>>(AcbrFuncDoc.ativar.func)
        .asFunction<int Function()>();
    int callAtivarBalancaFunc = ativarBalancaNativeFunc.call();

    if (callAtivarBalancaFunc == 0) {
      return sucess(0);
    }

    if (callAtivarBalancaFunc == -1) {
      return error("Bliblioteca não foi iniciada");
    }

    if (callAtivarBalancaFunc == -10) {
      return error("Houve erro ao ativar ACBrBAL");
    }
    return error("Erro interno COD-0");
  }

  @override
  Future<Errorhandling<int, String>> desativar() async {
    final desativarBalancaNativeFunc = lib.library
        .lookup<ffi.NativeFunction<ffi.Int Function()>>(
            AcbrFuncDoc.desativar.func)
        .asFunction<int Function()>();
    int callAtivarBalancaFunc = desativarBalancaNativeFunc.call();

    if (callAtivarBalancaFunc == 0) {
      return sucess(0);
    }

    if (callAtivarBalancaFunc == -1) {
      return error("Bliblioteca não foi iniciada");
    }

    if (callAtivarBalancaFunc == -10) {
      return error("Houve erro ao desativar ACBrBAL");
    }
    return error("Erro interno COD-0");
  }

  @override
  Future<Errorhandling<int, String>> finalizar() async {
    Function finalizarFunc = lib.library
        .lookup<ffi.NativeFunction<ffi.Int Function()>>(
            AcbrFuncDoc.finalizar.func)
        .asFunction<int Function()>();
    int callFinalizarFunc = finalizarFunc.call();

    if (callFinalizarFunc == 0) {
      return sucess(callFinalizarFunc);
    }

    if (callFinalizarFunc == -2) {
      return error("Houve falha na finalização da bliblioteca");
    }

    return error("Erro interno COD-0");
  }

  @override
  Future<Errorhandling<int, String>> inicializar(String arquivoIni,
      {String? chaveCrypt}) async {
    Function inicializarNativeFunc = lib.library
        .lookup<ffi.NativeFunction<NATIVE_INITBAL>>(AcbrFuncDoc.iniciar.func)
        .asFunction<int Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>)>();

    Errorhandling<String, String> iniFile = await _iniFile(arquivoIni);

    if (iniFile.isError) {
      return error(iniFile.error!);
    }

    int initializar = inicializarNativeFunc.call(
        iniFile.sucess!.toNativeUtf8(), (chaveCrypt ?? "").toNativeUtf8());

    if (initializar == 0) {
      return sucess(0);
    }

    if (initializar == -1) {
      return error("Falha na inicialização da bliblioteca");
    }

    if (initializar == -5) {
      return error("Não foi possível localizar o arquivo INI");
    }

    if (initializar == -6) {
      return error("Não foi possivel encontrar o diretório  do arquivo INI");
    }
    return error("Erro interno COD-0");
  }

  @override
  Future<Errorhandling<double, String>> lePeso(
      {int? timeOutMilliseconds}) async {
    double peso = 0.00;

    ffi.Pointer<ffi.Double> referenceDoublePeso =
        calloc.allocate<ffi.Double>(256);

    final lePesoStirng = lib.library
        .lookup<ffi.NativeFunction<NATIVE_LEPESO>>(AcbrFuncDoc.lePeso.func)
        .asFunction<int Function(int, ffi.Pointer<ffi.Double>)>();

    int callLePesoString = lePesoStirng.call(200, referenceDoublePeso);

    if (callLePesoString == 0) {
      peso = referenceDoublePeso.value;
    }

    if (callLePesoString == -1) {
      return error("Bliblioteca não foi iniciada");
    }

    if (callLePesoString == -10) {
      return error("Houve erro ao ler peso da balanca ACBrBAL");
    }

    calloc.free(referenceDoublePeso);
    return sucess(peso);
  }

  @override
  Future<Errorhandling<double, String>> lePesoAutomaticamente(
      {required String arquivoIni, int? timeOutMilliseconds}) async {
    AcbrBalanca lib = AcbrBalanca();
    Errorhandling<int, String> inicializar = await lib.inicializar(arquivoIni);

    inicializar.exeDebug(identifyFunc: "Iniciando bliblioteca");

    Errorhandling<int, String> ativar = await lib.ativar();
    ativar.exeDebug(identifyFunc: "Ativando balanca");

    Errorhandling<double, String> lepeso = await lib.lePeso();
    lepeso.exeDebug(identifyFunc: "Lendo peso balanca");

    Errorhandling<int, String> desativar = await lib.desativar();
    desativar.exeDebug(identifyFunc: "Desativando leitor balanca");

    Errorhandling<int, String> finalizar = await lib.finalizar();
    finalizar.exeDebug(identifyFunc: "Finalizando bliblioteca bliblioteca");

    if (inicializar.isError) {
      return error(inicializar.error!);
    }

    if (ativar.isError) {
      return error(ativar.error!);
    }

    if (lepeso.isError) {
      return error(lepeso.error!);
    }

    if (desativar.isError) {
      return error(desativar.error!);
    }

    if (finalizar.isError) {
      return error(finalizar.error!);
    }

    return sucess(lepeso.sucess!);
  }
}
