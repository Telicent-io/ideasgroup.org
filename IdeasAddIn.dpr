library IdeasAddIn;
    //AddIn for Sparx EA
uses
  ComServ,
  IdeasAddIn_TLB in 'IdeasAddIn_TLB.pas',
  Unit1 in 'Unit1.pas' {AddIn: CoClass},
  IdeasFormImpl in 'IdeasFormImpl.pas' {IdeasForm: TActiveForm} {IdeasForm: CoClass},
  Unit2 in 'Unit2.pas' {Form2},
  IdeasLib in 'Q:\lib\IdeasLib.pas',
  owl_lib in 'Q:\lib\owl_lib.pas',
  MSXML2_TLB in 'Q:\lib\MSXML2_TLB.pas',
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit5 in 'Unit5.pas' {Form5},
  NewElemForm in 'NewElemForm.pas' {Form6},
  Unit7 in 'Unit7.pas' {Form7},
  Unit9 in 'Unit9.pas' {Form9},
  Unit10 in 'Unit10.pas' {Form10},
  Unit11 in 'Unit11.pas' {Form11},
  Unit12 in 'Unit12.pas' {Form12},
  Unit13 in 'Unit13.pas' {Form13},
  Unit14 in 'Unit14.pas' {Form14},
  diagnosticsForm in 'diagnosticsForm.pas' {Form15},
  EA_TLB in 'Q:\lib\EA_TLB.pas',
  EA_Ideas_Lib in 'Q:\lib\EA_Ideas_Lib.pas',
  Unit16 in 'Unit16.pas' {VisioForm},
  Visio_TLB in 'Q:\lib\Visio_TLB.pas',
  SkosFormUnit in 'SkosFormUnit.pas' {SkosForm},
  skos_lib in 'Q:\lib\skos_lib.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

{$E ocx}


begin
end.
