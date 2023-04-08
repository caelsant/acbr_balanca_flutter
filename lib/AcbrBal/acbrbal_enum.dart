library acbr_balanca_flutter;

enum AcbrFuncDoc {
  iniciar("BAL_Inicializar"),
  ativar("BAL_Ativar"),
  desativar("BAL_Desativar"),
  versao("BAL_Versao"),
  finalizar("BAL_Finalizar"),
  lePeso("BAL_LePeso");

  final String func;
  const AcbrFuncDoc(this.func);
}
