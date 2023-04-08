import 'package:flutter/material.dart';

class Errorhandling<S, E> {
  S? sucess;
  E? error;
  Errorhandling({this.sucess, this.error});

  bool get isSucess => sucess != null;

  bool get isError => error != null;

  execute(
      {required Function(S sucess) sucessFunc,
      required Function(E error) errorFunc}) {
    isSucess ? sucessFunc.call(this.sucess!) : errorFunc.call(this.error!);
  }

  exeDebug({String? identifyFunc}) {
    //String formated
    String identifyFuncFormated =
        identifyFunc != null ? "[$identifyFunc] " : "";

    //Print func result
    isSucess
        ? debugPrint("${identifyFuncFormated}SUCESS: ${this.sucess!}")
        : debugPrint("${identifyFuncFormated}ERROR: ${this.error!}");
  }
}

Errorhandling<S, E> sucess<S, E>(S sucess) => Errorhandling(sucess: sucess);

Errorhandling<S, E> error<S, E>(E error) => Errorhandling(error: error);
