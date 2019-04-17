unit PyroIRCSrc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdCmdTCPClient, IdIRC, IdContext, Menus, ComCtrls, ExtCtrls;

type
  TircMain = class(TForm)
    IdIRC1: TIdIRC;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    PageControl1: TPageControl;
    ircStatus: TTabSheet;
    ircStatusEdit: TEdit;
    onJoinTimer: TTimer;
    onJoinTimer2: TTimer;
    ircStatusList: TListBox;
    onJoinTimer3: TTimer;
    Connect1: TMenuItem;
    Diconnect1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Option1: TMenuItem;
    N2: TMenuItem;
    Autojoin1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    BalloonHint1: TBalloonHint;
    Tray1: TTrayIcon;
    ConnectionInfo1: TMenuItem;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    ircStatusMemo: TRichEdit;
    procedure IdIRC1AdminInfoReceived(ASender: TIdContext;
      AAdminInfo: TStrings);
    procedure IdIRC1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdIRC1Raw(ASender: TIdContext; AIn: Boolean;
      const AMessage: string);
    procedure FormCreate(Sender: TObject);
    procedure IdIRC1Join(ASender: TIdContext; const ANickname, AHost,
      AChannel: string);
    procedure IdIRC1Connected(Sender: TObject);
    procedure ParseInput(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure onJoinTimerTimer(Sender: TObject);
    procedure IdIRC1PrivateMessage(ASender: TIdContext; const ANicknameFrom,
      AHost, ANicknameTo, AMessage: string);
    procedure IdIRC1NicknameChange(ASender: TIdContext; const AOldNickname,
      AHost, ANewNickname: string);
    procedure IdIRC1Topic(ASender: TIdContext; const ANickname, AHost, AChannel,
      ATopic: string);
    procedure FormShow(Sender: TObject);
    procedure onJoinTimer2Timer(Sender: TObject);
    procedure IdIRC1Kick(ASender: TIdContext; const ANickname, AHost, AChannel,
      ATarget, AReason: string);
    procedure IdIRC1Quit(ASender: TIdContext; const ANickname, AHost,
      AReason: string);
    procedure IdIRC1Part(ASender: TIdContext; const ANickname, AHost,
      AChannel: string);
    procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageControl1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PageControl1Change(Sender: TObject);
    procedure onJoinTimer3Timer(Sender: TObject);
    procedure IdIRC1Notice(ASender: TIdContext; const ANicknameFrom, AHost,
      ANicknameTo, ANotice: string);
    procedure ircMemosClick(Sender: TObject);
    procedure PageControl1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Exit1Click(Sender: TObject);
    procedure Diconnect1Click(Sender: TObject);
    procedure Connect1Click(Sender: TObject);
    procedure Tray1BalloonClick(Sender: TObject);
    procedure ConnectionInfo1Click(Sender: TObject);
    procedure Option1Click(Sender: TObject);
    procedure Tray1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Autojoin1Click(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure activeMemoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TStrArray = array of string;

var
  ircMain: TircMain;
  window: TTabSheet;
  windMemo: TRichEdit;
  windEdit: TEdit;
  windList: TListBox;
  windSheets: TTabSheet;
  ircMemos: array of TRichEdit;
  ircEdits: array of TEdit;
  ircLists: array of TListBox;
  ircSheets: array of TTabSheet;
  ircMCount: integer;
  ircECount: integer;
  ircLCount: integer;
  ircSCount: integer;
  aParts: TStrArray;
  joinChan: string;
  aMessages: array [0..1] of string;
  activeMemo: TRichEdit;
  activeMemoID: integer;
  activeNickname: string;
  nickalertPage: TTabSheet;

implementation

uses connectInfo, optionsSrc;

{$R *.dfm}
var
  mHandle : THandle;

function Explode(var a: TStrArray; Border, S: string): Integer;
var
  S2: string;
begin
  Result  := 0;
  S2 := S + Border;
  repeat
    SetLength(A, Length(A) + 1);
    a[Result] := Copy(S2, 0,Pos(Border, S2) - 1);
    Delete(S2, 1,Length(a[Result] + Border));
    Inc(Result);
  until S2 = '';
end;

procedure TircMain.Autojoin1Click(Sender: TObject);
begin
  optionsForm.Show;
  optionsForm.PageControl1.ActivePage := optionsForm.TabSheet2;
end;

procedure TircMain.Connect1Click(Sender: TObject);
begin
  connectForm.Show;
end;

procedure TircMain.ConnectionInfo1Click(Sender: TObject);
begin
  connectForm.Show;
end;

procedure TircMain.Diconnect1Click(Sender: TObject);
begin
  if idirc1.Connected = true then begin
    idirc1.Disconnect();
  end else begin
    ircStatusMemo.Lines.Add('» You''re not even connected! «');
  end;
end;

procedure TircMain.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TircMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Action = caMinimize then begin
  // Minimize application instead of closing
  Application.Minimize;
  // Remove the main form from the Task bar
  Self.Hide;
  end;
end;

procedure TircMain.FormCreate(Sender: TObject);
begin
  ircMCount := 0;
  ircECount := 0;
  ircLCount := 0;
  ircSCount := 0;
  SetLength(ircMemos, 1);
  SetLength(ircEdits, 1);
  SetLength(ircLists, 1);
  SetLength(ircSheets, 1);
end;

procedure TircMain.FormShow(Sender: TObject);
begin
  ircEdits[0] := ircStatusEdit;
  ircMemos[0] := ircStatusMemo;
  ircLists[0] := ircStatusList;
  ircSheets[0] := ircStatus;
  SetLength(ircMemos, 2);
  SetLength(ircEdits, 2);
  SetLength(ircLists, 2);
  SetLength(ircSheets, 2);
  ircECount := ircECount+1;
  ircMCount := ircMCount+1;
  ircLCount := ircLCount+1;
  ircSCount := ircSCount+1;
  activeMemo := ircStatusMemo;
  activeMemoID := 0;
end;

procedure TircMain.IdIRC1AdminInfoReceived(ASender: TIdContext;
  AAdminInfo: TStrings);
var
  i: integer;
begin
  for i:= 0 to AAdminInfo.Count-1 do begin
    ircStatusMemo.lines.add(AAdminInfo.Strings[i]);
  end;
end;

procedure TircMain.IdIRC1Connected(Sender: TObject);
begin
  //Connected
  activeNickname := IdIRC1.Nickname;
  //Auto join chans
  Timer2.Enabled := true;
end;

procedure TircMain.PageControl1Change(Sender: TObject);
var
  i: integer;
begin
  for i := (Length(ircSheets) - 1) downto 0 do begin
    if ircSheets[i].Name = 'tab' + Copy(PageControl1.ActivePage.Caption, 2, Length(PageControl1.ActivePage.Caption)) then begin
      activeMemo := ircMemos[i];
      activeMemoID := i;
      break;
    end else if ircSheets[i].Name = 'ircStatus' then begin
      activeMemo := ircStatusMemo;
      activeMemoID := 0;
      break;
    end;
  end;
  activeMemo.SetFocus;
  activeMemo.SelStart := ircStatusMemo.GetTextLen;
  activeMemo.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TircMain.PageControl1DragDrop(Sender, Source: TObject; X, Y: Integer);
const
   TCM_GETITEMRECT = $130A;
var
   TabRect: TRect;
   j: Integer;
begin
   if (Sender is TPageControl) then
   for j := 0 to PageControl1.PageCount - 1 do
   begin
     PageControl1.Perform(TCM_GETITEMRECT, j, LParam(@TabRect)) ;
     if PtInRect(TabRect, Point(X, Y)) then
     begin
       if PageControl1.ActivePage.PageIndex <> j then
         PageControl1.ActivePage.PageIndex := j;
       Exit;
     end;
   end;
end;

procedure TircMain.PageControl1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Sender is TPageControl) then Accept := True;
end;

procedure TircMain.PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PageControl1.BeginDrag(False);
end;

procedure TircMain.PageControl1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if TTabSheet(Sender).Name = 'ircStatus' then begin
    ircMain.ActiveControl := ircStatusEdit;
  end else begin
    ircMain.ActiveControl := ircEdits[activeMemoID];
  end;
end;

procedure TircMain.ParseInput(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  cmd, args: string;
  i: integer;
begin
  if Key = VK_RETURN then begin
    try
      Explode(aParts, ' ', TEdit(Sender).Text);
      if Copy(TEdit(Sender).Text, 1, 1) = '/' then begin
        cmd := Copy(TEdit(Sender).Text, 2, Length(aParts[0])-1);
        args := Copy(TEdit(Sender).Text, Length(aParts[0])+2, Length(TEdit(Sender).Text));
        //Connect
        IdIRC1.Host := connectForm.ServerEdit.Text;
        IdIRC1.Port := strToInt(connectForm.PortEdit.Text);
        IdIRC1.Nickname := connectForm.NickNameEdit.Text;
        IdIRC1.AltNickname := connectForm.AltNickEdit.Text;
        IdIRC1.RealName := connectForm.RealNameEdit.Text;
        IdIRC1.Username := connectForm.NickNameEdit.Text;
        if cmd = 'connect' then begin
          try
            idirc1.Connect;
          except
            if not idIRC1.Connected then begin
              ircStatusMemo.Lines.Add('Error connecting to ' + idIRC1.Host);
            end;
          end;
        end;
        //Join, Part, Nick, Msg, Privmsg, Notice, Cs, Ns, Bs, Hs, Ms
        if (cmd = 'part') and (activeMemo.Name <> ircStatusMemo.Name) then begin
          try
            for i := 0 to Length(ircSheets) - 1 do begin
              if ircSheets[i].Name = 'tab' + Copy(activeMemo.Name, 5, Length(activeMemo.Name)) then begin
                IdIRC1.Raw(Uppercase(cmd) + ' #' + Copy(activeMemo.Name, 5, Length(activeMemo.Name)));
                ircEdits[i].Parent := ircMain;
                ircEdits[i].Free;
                ircMemos[i].Free;
                ircLists[i].Free;
                ircSheets[i].Free;
                ircECount := ircECount-1;
                ircMCount := ircMCount-1;
                ircLCount := ircLCount-1;
                ircSCount := ircSCount-1;
                SetLength(ircEdits, ircECount);
                SetLength(ircMemos, ircMCount);
                SetLength(ircLists, ircLCount);
                SetLength(ircSheets, ircSCount);
              end;
            end;
          except
          end;
        end;
        if (cmd = 'join') or (cmd = 'nick') then begin
          IdIRC1.Raw(Uppercase(cmd) + ' ' + args);
        end;
        if cmd = 'quit' then begin
          try
            for i := 1 to Length(ircSheets) - 1 do begin
                IdIRC1.Raw(Uppercase(cmd) + ' ' + args);
                ircEdits[i].Parent := ircMain;
                ircEdits[i].Free;
                ircMemos[i].Free;
                ircLists[i].Free;
                ircSheets[i].Free;
                ircECount := ircECount-1;
                ircMCount := ircMCount-1;
                ircLCount := ircLCount-1;
                ircSCount := ircSCount-1;
                SetLength(ircEdits, ircECount);
                SetLength(ircMemos, ircMCount);
                SetLength(ircLists, ircLCount);
                SetLength(ircSheets, ircSCount);
            end;
          except
          end;
        end;
        if (cmd = 'msg') then begin
          IdIRC1.Raw(Uppercase(cmd) + ' ' + aParts[1] + ' :' + Copy(TEdit(Sender).Text, Length(aParts[0]) + Length(aParts[1]) + 3, Length(TEdit(Sender).Text)));
          try
            for i := 0 to Length(ircMemos) - 1 do begin
              if ircMemos[i].Name = 'memo' + Copy(aParts[1], 2, Length(aParts[1])) then begin
                ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + '(' + activeNickname + ') ' + Copy(TEdit(Sender).Text, Length(aParts[0]) + Length(aParts[1]) + 4, Length(TEdit(Sender).Text)));
              end;
            end;
          except
          end;
        end;
        if (cmd = 'notice') then begin
          IdIRC1.Raw(Uppercase(cmd) + ' ' + aParts[1] + ' :' + Copy(TEdit(Sender).Text, Length(aParts[0]) + Length(aParts[1]) + 3, Length(TEdit(Sender).Text)));
          activeMemo.Lines.Add('(' + TimeToStr(Now) + ') ' + '» Notice to ' + aParts[1] + ': ' + Copy(TEdit(Sender).Text, Length(aParts[0]) + Length(aParts[1]) + 4, Length(TEdit(Sender).Text)) + ' «');
        end;
        if (cmd = 'chanserv') or (cmd = 'nickserv') or (cmd = 'botserv') or (cmd = 'hostserv') or
          (cmd = 'memoserv') then begin
          IdIRC1.Raw('PRIVMSG ' + cmd + ' :' + args);
        end;
        if (cmd = 'cs') or (cmd = 'ns') or (cmd = 'bs') or (cmd = 'hs') or (cmd = 'ms') then begin
          IdIRC1.Raw('PRIVMSG ' + cmd + ' :' + args);
        end;
        if (cmd = 'me') then begin
          IdIRC1.Raw('PRIVMSG #' + Copy(TEdit(Sender).Parent.Name, 4, Length(TEdit(Sender).Parent.Name)) + ' :' + Chr(1) + 'ACTION ' + Copy(TEdit(Sender).Text, Length(aParts[0]) + 1, Length(TEdit(Sender).Text)) + Chr(1));
          activeMemo.SelAttributes.Color := clBlue;
          activeMemo.Lines.Add('(' + TimeToStr(Now) + ') ' + '* ' + activeNickname + ' ' + Copy(TEdit(Sender).Text, 5, Length(TEdit(Sender).Text)));
          activeMemo.SelAttributes.Color := clBlack;
        end;
      end else begin
        if TEdit(Sender).Name <> ircStatusEdit.Name then begin
          if(trim(TEdit(Sender).Text) <> '') then begin
            IdIRC1.Raw('PRIVMSG #' + Copy(TEdit(Sender).Parent.Name, 4, Length(TEdit(Sender).Parent.Name)) + ' :' + TEdit(Sender).Text);
            activeMemo.Lines.Add('(' + TimeToStr(Now) + ') ' + '(' + activeNickname + ') ' + TEdit(Sender).Text);
          end;
        end;
      end;
    except
    end;
    TEdit(Sender).Clear;
  end;
  {if Key = VK_TAB then begin

  end;}
end;

procedure ForceForegroundWindow(hwnd: THandle);
var
  hlp: TForm;
begin
  hlp := TForm.Create(nil);
  try
    hlp.BorderStyle := bsNone;
    hlp.SetBounds(0, 0, 1, 1);
    hlp.FormStyle := fsStayOnTop;
    hlp.Show;
    mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    mouse_event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    SetForegroundWindow(hwnd);
  finally
    hlp.Free;
  end;
end;

procedure SwitchToThisWindow(h1: hWnd; x: bool); stdcall;
  external user32 Name 'SwitchToThisWindow';

procedure TircMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  //Show the connect info form
  if optionsForm.CheckBox1.Checked = true then begin
    connectForm.Show;
  end;
  //Reconnect to last server
  if optionsForm.CheckBox2.Checked = true then begin
    try
      IdIRC1.Connect;
    except
      if not  IdIRC1.Connected then begin
        ircStatusMemo.Lines.Add('connecting to ' +  IdIRC1.Host);
      end;
    end;
  end;
  //Enable nick alerting
  if optionsForm.CheckBox1.Checked = true then begin
    connectForm.Show;
  end;
  //Start PyroIRC when Windows starts
  {if optionsForm.CheckBox1.Checked = true then begin
    connectForm.Show;
  end;}
  //Minimize to tray
  if optionsForm.CheckBox1.Checked = true then begin
    connectForm.Show;
  end;
  //Auto connect
  if optionsForm.CheckBox2.Checked = true then begin
    IdIRC1.Host := connectForm.ServerEdit.Text;
    IdIRC1.Port := strToInt(connectForm.PortEdit.Text);
    IdIRC1.Nickname := connectForm.NickNameEdit.Text;
    IdIRC1.AltNickname := connectForm.AltNickEdit.Text;
    IdIRC1.RealName := connectForm.RealNameEdit.Text;
    IdIRC1.Username := connectForm.NickNameEdit.Text;
    try
      IdIRC1.Connect;
    except
      if not IdIRC1.Connected then begin
        ircStatusMemo.Lines.Add('Error connecting to ' +  IdIRC1.Host);
      end;
    end;
  end;
end;

procedure TircMain.Timer2Timer(Sender: TObject);
var
  i: integer;
begin
  Timer2.Enabled := false;
  //Auto join chans
  if optionsForm.CheckBox3.Checked = true then begin
    if idirc1.Connected = true then begin
      for i := 0 to optionsForm.Memo1.Lines.Count - 1 do begin
        idirc1.Join(trim(optionsForm.Memo1.Lines.Strings[i]));
      end;
    end;
  end;
end;

procedure TircMain.Timer3Timer(Sender: TObject);
begin
  if optionsForm.CheckBox6.Checked = true then begin
    if WindowState = wsMinimized then begin
      Visible := false;
      Timer3.Enabled := false;
    end;
  end;
end;

procedure TircMain.Tray1BalloonClick(Sender: TObject);
begin
  Application.Restore;
  SwitchToThisWindow(Self.Handle, True);
  PageControl1.ActivePage := nickalertPage;
end;

procedure TircMain.Tray1Click(Sender: TObject);
begin
  if WindowState = wsMinimized then begin
    WindowState := wsNormal;
    Visible := true;
    forms.application.BringToFront;
    Timer3.Enabled := true;
  end else begin
    WindowState := wsMinimized;
  end;
end;

procedure TircMain.onJoinTimerTimer(Sender: TObject);
begin
  onJoinTimer.Enabled := false;
  try
    window := TTabSheet.Create(PageControl1);
    window.Name := 'tab' + Copy(joinChan, 2, Length(joinChan));
    window.PageControl := PageControl1;
    PageControl1.ActivePage := window;
    window.Caption := joinChan;
    window.Parent := PageControl1;
    window.Visible := true;
    SetLength(ircSheets, ircSCount+1);
    ircSheets[ircSCount] := window;
    windMemo := TRichEdit.Create(window);
    windMemo.Parent := window;
    windMemo.Name := 'memo' + Copy(joinChan, 2, Length(joinChan));
    windMemo.ReadOnly := true;
    windMemo.ScrollBars := ssVertical;
    windMemo.Height := ircStatusMemo.Height;
    windMemo.Width := ircStatusMemo.Width-157;
    windMemo.Anchors := ircStatus.Anchors;
    windMemo.Top := ircStatusMemo.Top;
    windMemo.Left := ircStatusMemo.Left;
    windMemo.Lines.Clear;
    windMemo.WordWrap := true;
    windMemo.OnClick := ircMemosClick;
    windMemo.OnChange := activeMemoChange;
    windMemo.Visible := true;
    SetLength(ircMemos, ircMCount+1);
    ircMemos[ircMCount] := windMemo;
    windEdit := Tedit.Create(window);
    windEdit.Name := 'edit' + Copy(joinChan, 2, Length(joinChan));
    windEdit.Parent := window;
    windEdit.Height := ircStatusEdit.Height;
    windEdit.Width := ircStatusEdit.Width;
    windEdit.Anchors := ircStatusEdit.Anchors;
    windEdit.Top := ircStatusEdit.Top;
    windEdit.Left := ircStatusEdit.Left;
    windEdit.Clear;
    windEdit.OnKeyDown := ParseInput;
    windEdit.OnKeyPress := EditKeyPress;
    windEdit.Visible := true;
    SetLength(ircEdits, ircECount+1);
    ircEdits[ircECount] := windEdit;
    windList := TListBox.Create(window);
    windList.Name := 'list' + Copy(joinChan, 2, Length(joinChan));
    windList.Parent := window;
    windList.Left := 665;
    windList.Top := -3;
    windList.Anchors := [akTop, akRight, akBottom];
    windList.Width := 157;
    windList.Height := 435;
    windList.Color := clMenu;
    windList.Sorted := true;
    windList.Visible := true;
    SetLength(ircLists, ircLCount+1);
    ircLists[ircLCount] := windList;
    ircMain.ActiveControl := windEdit;
    ircMCount := ircMCount+1;
    ircECount := ircECount+1;
    ircLCount := ircLCount+1;
    ircSCount := ircSCount+1;
    activeMemo := windMemo;
    activeMemoID := ircMCount-1;
  except
  end;
end;

procedure TircMain.Option1Click(Sender: TObject);
begin
  optionsForm.Show;
  optionsForm.PageControl1.ActivePage := optionsForm.TabSheet1;
end;

procedure TircMain.IdIRC1Join(ASender: TIdContext; const ANickname, AHost,
  AChannel: string);
var
  i:integer;
begin
  if ANickname = activeNickname then begin
    joinChan := AChannel;
    onJoinTimer.Enabled := true;
  end else begin
    for i := 0 to Length(ircMemos) - 1 do begin
      if ircMemos[i].Name = 'memo' + Copy(AChannel, 2, Length(AChannel)) then begin
        ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + '» Join: ' + ANickname + ' (' + AHost + ') «');
      end;
    end;
  end;
end;

procedure TircMain.IdIRC1Kick(ASender: TIdContext; const ANickname, AHost,
  AChannel, ATarget, AReason: string);
var
  i: integer;
begin
  for i := 0 to Length(ircMemos) - 1 do begin
    if ircMemos[i].Name = 'memo' + Copy(AChannel, 2, Length(AChannel)) then begin
      ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + '» ' + ANickname + ' kicked ' + ATarget + ' (' + AReason + ') «');
      if ATarget = activeNickname then begin
        ircLists[i].Clear;
        ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + '» You were kicked «');
      end;
    end;
  end;
end;

procedure TircMain.IdIRC1NicknameChange(ASender: TIdContext; const AOldNickname,
  AHost, ANewNickname: string);
begin
  if AOldNickname = activeNickname then begin
    idirc1.Nickname := ANewNickname;
    activeNickname := ANewNickname;
  end;
  activeMemo.Lines.Add('(' + TimeToStr(Now) + ') ' + '» ' + AOldNickname + ' is now known as ' + ANewNickname + ' «')
end;

procedure TircMain.IdIRC1Notice(ASender: TIdContext; const ANicknameFrom, AHost,
  ANicknameTo, ANotice: string);
begin
  if ANicknameTo = activeNickname then begin
    activeMemo.Lines.Add('(' + TimeToStr(Now) + ') ' + '» Notice from ' + ANicknameFrom + ': ' + ANotice + ' «');
  end;
end;

procedure TircMain.IdIRC1Part(ASender: TIdContext; const ANickname, AHost,
  AChannel: string);
var
  i: integer;
begin
  for i := 0 to Length(ircMemos) - 1 do begin
    if ircMemos[i].Name = 'memo' + Copy(AChannel, 2, Length(AChannel)) then begin
      ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + '» Part: ' + ANickname + ' (' + AHost + ') «');
    end;
  end;
end;

procedure TircMain.IdIRC1PrivateMessage(ASender: TIdContext;
  const ANicknameFrom, AHost, ANicknameTo, AMessage: string);
var
  i: integer;
begin
  if ANicknameTo = activeNickname then begin
    if Copy(AMessage, 0, 8) = Chr(1) + 'VERSION' then begin
      ircStatusMemo.Lines.Add('(' + TimeToStr(Now) + ') ' + '» CTCP [VERSION] from ' + ANicknameFrom + ' «');
      IdIRC1.Raw('NOTICE ' + ANicknameFrom + ' :' + Chr(1) + 'VERSION PyroIRC 0.1 Alpha' + Chr(1));
    end;
  end;
  for i := 0 to Length(ircMemos) - 1 do begin
    if ircMemos[i].Name = 'memo' + Copy(ANicknameTo, 2, Length(ANicknameTo)) then begin
      if Copy(Amessage, 0, 7) = Chr(1) + 'ACTION' then begin
        ircMemos[i].SelAttributes.Color := clBlue;
        ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + '* ' + ANicknameFrom + ' ' + Copy(AMessage, 9, Length(AMessage)));
        ircMemos[i].SelAttributes.Color := clBlack;
      end else begin
        ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + '(' + ANicknameFrom + ') ' + AMessage);
      end;
      if optionsForm.CheckBox4.Checked = true then begin
        if Pos(activeNickname, AMessage) > 0 then begin
          Tray1.BalloonTitle := 'Nickalert in ' + ANickNameTo;
          Tray1.BalloonHint := Copy(AMessage, Pos(activeNickname, AMessage), 50)+ '...';
          Tray1.ShowBalloonHint;
          nickalertPage := ircSheets[i];
        end;
      end;
    end;
  end;
end;

procedure TircMain.IdIRC1Quit(ASender: TIdContext; const ANickname, AHost,
  AReason: string);
//var
  //i: integer;
begin
    {for i := 0 to Length(ircMemos) - 1 do begin
      if ircMemos[i].Name = 'memo' + Copy(AChannel, 2, Length(AChannel)) then begin
        ircMemos[i].Lines.Add('- Kicked -');
        ircLists[i].Clear;
      end;
    end;
    for i := 1 to Length(ircSheets) - 1 do begin
      ircSheets[i].Free;
      ircSCount := ircSCount-1;
    end;}
end;

procedure TircMain.onJoinTimer2Timer(Sender: TObject);
var
  i: integer;
begin
  onJoinTimer2.Enabled := false;
  Explode(aParts, ' ', aMessages[0]);
  if aParts[0] = '332' then begin
    for i := 0 to Length(ircMemos) - 1 do begin
      if ircMemos[i].Name = 'memo' + Copy(joinChan, 2, Length(joinChan)) then begin
        ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + 'Topic: ' + Copy(aMessages[0], Length(aParts[0]) + Length(aParts[1]) +
          Length(aParts[2]) + 5, Length(aMessages[0])));
      end;
    end;
  end;
end;

procedure TircMain.onJoinTimer3Timer(Sender: TObject);
var
  i: integer;
  j: integer;
  users: TStrArray;
begin
  onJoinTimer3.Enabled := false;
  Explode(aParts, ' ', aMessages[1]);
  if aParts[0] = '353' then begin
    Explode(users, ' ', Copy(aMessages[1], Length(aParts[0]) + Length(aParts[1]) + Length(aParts[2]) + Length(aParts[3]) + 6, Length(aMessages[1])));
    for i := 0 to Length(ircLists) - 1 do begin
      if ircLists[i].Name = 'list' + Copy(joinChan, 2, Length(joinChan)) then begin
        for j := 0 to Length(users) - 1 do begin
          if Length(users[j]) > 1 then begin
            ircLists[i].Items.Add(users[j]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TircMain.IdIRC1Raw(ASender: TIdContext; AIn: Boolean;
  const AMessage: string);
begin
  ircStatusMemo.Lines.Add(Amessage);
  Explode(aParts, ' ', AMessage);
  if aParts[0] = '332' then begin
    aMessages[0] := AMessage;
    onJoinTimer2.Enabled := true;
  end else if aParts[0] = '353' then begin
    aMessages[1] := AMessage;
    onJoinTimer3.Enabled := true;
  end;
end;

procedure TircMain.IdIRC1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  ircStatusMemo.Lines.Add(AStatusText);
end;

procedure TircMain.IdIRC1Topic(ASender: TIdContext; const ANickname, AHost,
  AChannel, ATopic: string);
var
  i: integer;
begin
  for i := 0 to Length(ircMemos) - 1 do begin
    if ircMemos[i].Name = 'memo' + Copy(AChannel, 2, Length(AChannel)) then begin
      ircMemos[i].Lines.Add('(' + TimeToStr(Now) + ') ' + ANickname + ' changed the topic to: ' + ATopic);
    end;
  end;
end;

procedure TircMain.ircMemosClick(Sender: TObject);
begin
  if TMemo(Sender).Name = 'ircStatusMemo' then begin
    ircMain.ActiveControl := ircStatusEdit;
  end else begin
    ircMain.ActiveControl := ircEdits[activeMemoID];
  end;
end;

procedure TircMain.activeMemoChange(Sender: TObject);
begin
  try
    activeMemo.SetFocus;
    activeMemo.SelStart := ircStatusMemo.GetTextLen;
    activeMemo.Perform(EM_SCROLLCARET, 0, 0);
    if TMemo(Sender).Name = 'ircStatusMemo' then begin
      ircMain.ActiveControl := ircStatusEdit;
    end else begin
      ircMain.ActiveControl := ircEdits[activeMemoID];
      ircEdits[activeMemoID].SelStart := Length(ircEdits[activeMemoID].Text);
    end;
  except
  end;
end;

procedure TircMain.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Key := #0;
end;

initialization
  mHandle := CreateMutex(nil, True, 'PyroIRC');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    halt;
  end;

finalization
  if mHandle <> 0 then CloseHandle(mHandle)

end.
