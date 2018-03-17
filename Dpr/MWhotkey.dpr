program MWhotkey;

uses
  Forms,
  MainF in '..\Pas\MainF.pas' {MainForm},
  KeyCodeU in '..\Pas\KeyCodeU.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.ShowMainForm := false;
  Application.Title := 'MWhotkey 0.1.1a';
  Application.CreateForm(TMainForm, MainForm);
  
  Application.Run;
end.
