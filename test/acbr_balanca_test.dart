// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:acbr_balanca_flutter/AcbrBal/Lybrary.dart';
import 'package:acbr_balanca_flutter/ErrorHandling.dart';
import 'package:path/path.dart';
import 'package:acbr_balanca_flutter/acbr_balanca.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:developer' as dev;

void main() async {
  AcbrBalanca lib = AcbrBalanca();
  test("Criando ini file", () async {
    bool verificarArquivoIniBalanca(File iniFile) {
      String arquivo = iniFile.readAsStringSync();

      bool verificarSeContemChaves = arquivo.contains("BAL") &&
          arquivo.contains("BAL_Device") &&
          arquivo.contains("ACBrLibBAL");
      if (verificarSeContemChaves == false) {
        return false;
      }
      return iniFile.path.contains(".ini");
    }

    String path = "C:\\";
    //Primeiro verificar se há o arquivo

    if (path.isEmpty || !path.contains("\\") || !path.contains(":")) {
      print("Caminho invalido");
      return;
    }

    File iniFile = File(path);

    if (!iniFile.existsSync()) {
      print("Arquivo ini criando um novo");
      File createIniFile = File(join(iniFile.path, "ACBrLib.ini"));
      File arquivoCriado = await createIniFile.create();
      print(createIniFile.path);
      return;
    }

    if (!verificarArquivoIniBalanca(iniFile)) {
      print("Arquivo ini exite, mas é invalido, configurar ele");
      return;
    }

    print("Arquivo ini pronto pra ser usado");
    //iniFIle.parent é o diretorio
    //Se houver verificar a veracidade
    //Se não houver, criar um novo vazio no diretorio passado
  });

  test("Inicializando bliblioteca corretamente", () async {
    AcbrBalanca lib = AcbrBalanca();
    Errorhandling<int, String> inicializar =
        await lib.inicializar("C:\\ASNSOFTWARE\\CONFIG\\ACBrLib.ini");

    inicializar.exeDebug(identifyFunc: "Inicializar bliblioteca");

    expect(inicializar.isSucess, true);

    Errorhandling<int, String> finalizar = await lib.finalizar();

    finalizar.exeDebug(identifyFunc: "Finalizar bliblioteca");

    expect(finalizar.isSucess, true);
  });

  test("Lendo peso bliblioteca corretamente", () async {
    AcbrBalanca lib = AcbrBalanca();
/*     Errorhandling<int, String> inicializar =
        await lib.inicializar("C:\\ASNSOFTWARE\\CONFIG\\ACBrLib.ini");
    inicializar.exeDebug(identifyFunc: "Inicializar bliblioteca"); */

    // Errorhandling<int, String> ativar = await lib.ativar();
    // ativar.exeDebug(identifyFunc: "Ativando balanca");

    Errorhandling<double, String> lepeso = await lib.lePeso();
    lepeso.exeDebug(identifyFunc: "Lendo peso balanca");

/*     Errorhandling<int, String> desativar = await lib.desativar();
    desativar.exeDebug(identifyFunc: "Desativando bliblioteca");

    Errorhandling<int, String> finalizar = await lib.finalizar();
    finalizar.exeDebug(identifyFunc: "Finalizar bliblioteca"); */
  });

  test("Ler o peso", () async {
    AcbrBalanca lib = AcbrBalanca();
    Errorhandling<double, String> lepeso = await lib.lePesoAutomaticamente(
        arquivoIni: "C:\\ASNSOFTWARE\\CONFIG\\ACBrLib.ini");
    lepeso.exeDebug(identifyFunc: "Lendo peso balanca");
  });

  test("Desativar lib", () async {
    AcbrBalanca lib = AcbrBalanca();
    Errorhandling<int, String> desativar = await lib.desativar();
    desativar.exeDebug(identifyFunc: "Desativando bliblioteca");

    Errorhandling<int, String> finalizar = await lib.finalizar();
    finalizar.exeDebug(identifyFunc: "Finalizar bliblioteca");
  });
}
