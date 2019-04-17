program PyroIRC;

uses
  Forms,
  PyroIRCSrc in 'PyroIRCSrc.pas' {Form1},
  connectInfo in 'connectInfo.pas' {connectForm},
  optionsSrc in 'optionsSrc.pas' {optionsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TircMain, ircMain);
  Application.CreateForm(TconnectForm, connectForm);
  Application.CreateForm(ToptionsForm, optionsForm);
  Application.Run;
end.
