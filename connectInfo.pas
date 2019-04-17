unit connectInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, INIFiles;

type
  TconnectForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    ServerEdit: TEdit;
    PortEdit: TEdit;
    GroupBox2: TGroupBox;
    NicknameEdit: TEdit;
    RealNameEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    AltNickEdit: TEdit;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  connectForm: TconnectForm;
  exePath: string;
  ini: TINIFile;

implementation

uses
  PyroIRCSrc;

{$R *.dfm}

procedure TconnectForm.Button1Click(Sender: TObject);
begin
  if (trim(ServerEdit.Text) <> '') and (trim(PortEdit.Text) <> '') and
  (trim(NickNameEdit.Text) <> '') and (trim(RealNameEdit.Text) <> '') and
  (trim(AltNickEdit.Text) <> '') then begin
    ini := TIniFile.Create(exePath + 'PyroIRC.ini');
    ini.WriteString('Connection', 'Server', ServerEdit.Text);
    ini.WriteInteger('Connection', 'Port', strToInt(PortEdit.Text));
    ini.WriteString('UserInfo', 'Nickname', NickNameEdit.Text);
    ini.WriteString('UserInfo', 'AltNick', AltNickEdit.Text);
    ini.WriteString('UserInfo', 'RealName', RealNameEdit.Text);
    ini.Free;
    ircMain.IdIRC1.Host := ServerEdit.Text;
    ircMain.IdIRC1.Port := strToInt(PortEdit.Text);
    ircMain.IdIRC1.Nickname := NickNameEdit.Text;
    ircMain.IdIRC1.AltNickname := AltNickEdit.Text;
    ircMain.IdIRC1.RealName := RealNameEdit.Text;
    ircMain.IdIRC1.Username := NickNameEdit.Text;
    try
      ircMain.IdIRC1.Connect;
    except
      if not ircMain.IdIRC1.Connected then begin
        ircMain.ircStatusMemo.Lines.Add('Error connecting to ' +  ircMain.IdIRC1.Host);
      end;
    end;
    Self.Close;
   end else begin
    ShowMessage('No fields can be left empty');
   end;
end;

procedure TconnectForm.Button2Click(Sender: TObject);
begin
  if (trim(ServerEdit.Text) <> '') and (trim(PortEdit.Text) <> '') and
  (trim(NickNameEdit.Text) <> '') and (trim(RealNameEdit.Text) <> '') then begin
    ini := TIniFile.Create(exePath + 'PyroIRC.ini');
    ini.WriteString('Connection', 'Server', ServerEdit.Text);
    ini.WriteInteger('Connection', 'Port', strToInt(PortEdit.Text));
    ini.WriteString('UserInfo', 'Nickname', NickNameEdit.Text);
    ini.WriteString('UserInfo', 'AltNick', AltNickEdit.Text);
    ini.WriteString('UserInfo', 'RealName', RealNameEdit.Text);
    ini.Free;
    Self.Close;
   end else begin
    ShowMessage('No fields can be left empty');
   end;
end;

procedure TconnectForm.Button3Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TconnectForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ircMain.Enabled := true;
end;

procedure TconnectForm.FormCreate(Sender: TObject);
begin
  exePath := ExtractFilePath(Application.ExeName);
  ini := TIniFile.Create(exePath + 'PyroIRC.ini');
  if not FileExists(exePath + 'PyroIRC.ini') then begin
    ini.WriteString('Connection', 'Server', '');
    ini.WriteInteger('Connection', 'Port', 6667);
    ini.WriteString('UserInfo', 'Nickname', '');
    ini.WriteString('UserInfo', 'AltNick', '');
    ini.WriteString('UserInfo', 'RealName', '');
    ini.WriteBool('Options', 'ShowConnect', true);
    ini.WriteBool('Options', 'AutoJoinServer', false);
    ini.WriteBool('Options', 'AutoJoinChans', true);
    ini.WriteBool('Options', 'NickAlerting', true);
    ini.WriteBool('Options', 'LaunchOnWindows', false);
    ini.WriteBool('Options', 'MinimizeToTray', true);
  end else begin
    if ini.ValueExists('Connection', 'Server') then begin
      ServerEdit.Text := ini.ReadString('Connection', 'Server', '');
    end;
    if ini.ValueExists('Connection', 'Port') then begin
      PortEdit.Text := intToStr(ini.ReadInteger('Connection', 'Port', 6667));
    end;
    if ini.ValueExists('UserInfo', 'Nickname') then begin
      NicknameEdit.Text := ini.ReadString('UserInfo', 'Nickname', '');
    end;
    if ini.ValueExists('UserInfo', 'AltNick') then begin
      AltNickEdit.Text := ini.ReadString('UserInfo', 'AltNick', '');
    end;
    if ini.ValueExists('UserInfo', 'RealName') then begin
      RealnameEdit.Text := ini.ReadString('UserInfo', 'RealName', '');
    end;
  end;
  ini.Free;
end;

procedure TconnectForm.FormShow(Sender: TObject);
begin
  ircMain.Enabled := false;
end;

end.
