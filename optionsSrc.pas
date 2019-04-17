unit optionsSrc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, INIFiles;

type
  ToptionsForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBox4: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBox5: TCheckBox;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    CheckBox6: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  optionsForm: ToptionsForm;
  ini: TINIFile;

implementation

uses PyroIRCSrc, connectInfo;

{$R *.dfm}

procedure ToptionsForm.Button1Click(Sender: TObject);
var
  i: integer;
begin
  if ircMain.idirc1.Connected = true then begin
    for i := 0 to optionsForm.Memo1.Lines.Count - 1 do begin
      ircMain.idirc1.Join(trim(optionsForm.Memo1.Lines.Strings[i]));
    end;
  end;
end;

procedure ToptionsForm.Button2Click(Sender: TObject);
begin
  ini := TIniFile.Create(exePath + 'PyroIRC.ini');
  ini.WriteBool('Options', 'ShowConnect', CheckBox1.Checked);
  ini.WriteBool('Options', 'AutoJoinServer', CheckBox2.Checked);
  ini.WriteBool('Options', 'AutoJoinChans', CheckBox3.Checked);
  ini.WriteBool('Options', 'NickAlerting', CheckBox4.Checked);
  ini.WriteBool('Options', 'LaunchOnWindows', CheckBox5.Checked);
  ini.WriteBool('Options', 'MinimizeToTray', CheckBox6.Checked);
  ini.Free;
  Self.Close;
end;

procedure ToptionsForm.Button3Click(Sender: TObject);
begin
  Self.Close;
end;

procedure ToptionsForm.Button4Click(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'autoJoins.txt');
  Self.Close;
end;

procedure ToptionsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ircMain.Enabled := true;
end;

procedure ToptionsForm.FormCreate(Sender: TObject);
begin
  ini := TIniFile.Create(exePath + 'PyroIRC.ini');
  if ini.ValueExists('Options', 'ShowConnect') then begin
    CheckBox1.Checked := ini.ReadBool('Options', 'ShowConnect', true);
  end;
  if ini.ValueExists('Options', 'AutoJoinServer') then begin
    CheckBox2.Checked := ini.ReadBool('Options', 'AutoJoinServer', false);
  end;
  if ini.ValueExists('Options', 'AutoJoinChans') then begin
    CheckBox3.Checked := ini.ReadBool('Options', 'AutoJoinChans', true);
  end;
  if ini.ValueExists('Options', 'NickAlerting') then begin
    CheckBox4.Checked := ini.ReadBool('Options', 'NickAlerting', true);
  end;
  if ini.ValueExists('Options', 'LaunchOnWindows') then begin
    CheckBox5.Checked := ini.ReadBool('Options', 'LaunchOnWindows', false);
  end;
  if ini.ValueExists('Options', 'MinimizeToTray') then begin
    CheckBox6.Checked := ini.ReadBool('Options', 'MinimizeToTray', true);
  end;
  ini.Free;
  if not FileExists(ExtractFilePath(Application.ExeName) + 'autoJoins.txt') then begin
    Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'autoJoins.txt');
  end;
  Memo1.Lines.LoadFromFile(ExtractFilePath(Application.ExeName) + 'autoJoins.txt');
end;

procedure ToptionsForm.FormShow(Sender: TObject);
begin
  ircMain.Enabled := false;
end;

end.
