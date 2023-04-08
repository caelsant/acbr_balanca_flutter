// ignore_for_file: file_names, camel_case_types

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

//Métodos nativos da bliblioteca

// Método usado para inicializar o componente para uso da biblioteca, este método recebe dois parâmetros do tipo Strings
typedef NATIVE_INITBAL = ffi.Int Function(
    ffi.Pointer<Utf8> eArqConfig, ffi.Pointer<Utf8> eChaveCrypt);

// Método usado para remover o componente ACBrBAL e suas classes da memoria.
typedef NATIVE_FINALIZAR = ffi.Int Function();

// Método usado retornar o ultimo retorno processado pela biblioteca.
typedef NATIVE_ULTIMORETORNO = ffi.Int Function();

// Método que retornar o nome da biblioteca.
typedef NATIVE_NOMELIB = ffi.Int Function();

// Método usado para ler o peso na balança no componente ACBrBAL.
typedef NATIVE_LEPESO = ffi.Int Function(
    ffi.Pointer<ffi.Int> millisecTimeOut, ffi.Pointer<ffi.Double> peso);
