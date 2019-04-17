object ircMain: TircMain
  Left = 309
  Top = 169
  ActiveControl = ircStatusEdit
  Caption = 'PyroIRC'
  ClientHeight = 475
  ClientWidth = 826
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    826
    475)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = -1
    Top = 0
    Width = 829
    Height = 482
    ActivePage = ircStatus
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnChange = PageControl1Change
    OnMouseUp = PageControl1MouseUp
    object ircStatus: TTabSheet
      Caption = 'Status'
      DesignSize = (
        821
        454)
      object ircStatusList: TListBox
        Left = 665
        Top = -3
        Width = 157
        Height = 435
        Anchors = [akTop, akRight, akBottom]
        Enabled = False
        ItemHeight = 13
        TabOrder = 1
        Visible = False
      end
      object ircStatusEdit: TEdit
        Left = -3
        Top = 431
        Width = 827
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 0
        OnKeyDown = ParseInput
        OnKeyPress = EditKeyPress
      end
      object ircStatusMemo: TRichEdit
        Left = -3
        Top = -3
        Width = 828
        Height = 435
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
        OnChange = activeMemoChange
        OnClick = ircMemosClick
      end
    end
  end
  object IdIRC1: TIdIRC
    OnStatus = IdIRC1Status
    OnConnected = IdIRC1Connected
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    ReadTimeout = -1
    CommandHandlers = <>
    ExceptionReply.Code = '500'
    ExceptionReply.Text.Strings = (
      'Unknown Internal Error')
    Nickname = 'Anonymous'
    AltNickname = 'Anonymous2'
    Username = 'Anonymous'
    RealName = 'Anonymous'
    UserMode = []
    OnPrivateMessage = IdIRC1PrivateMessage
    OnNotice = IdIRC1Notice
    OnJoin = IdIRC1Join
    OnPart = IdIRC1Part
    OnTopic = IdIRC1Topic
    OnKick = IdIRC1Kick
    OnAdminInfoReceived = IdIRC1AdminInfoReceived
    OnNicknameChange = IdIRC1NicknameChange
    OnQuit = IdIRC1Quit
    OnRaw = IdIRC1Raw
    Left = 16
    Top = 32
  end
  object MainMenu1: TMainMenu
    Left = 72
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object Connect1: TMenuItem
        Caption = 'Connect'
        OnClick = Connect1Click
      end
      object Diconnect1: TMenuItem
        Caption = 'Disconnect'
        OnClick = Diconnect1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object ConnectionInfo1: TMenuItem
        Caption = 'Connection Info'
        OnClick = ConnectionInfo1Click
      end
      object Option1: TMenuItem
        Caption = 'Options'
        OnClick = Option1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Autojoin1: TMenuItem
        Caption = 'Auto Join'
        OnClick = Autojoin1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About PyroIRC'
      end
    end
  end
  object onJoinTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = onJoinTimerTimer
    Left = 136
    Top = 32
  end
  object onJoinTimer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = onJoinTimer2Timer
    Left = 200
    Top = 32
  end
  object onJoinTimer3: TTimer
    Enabled = False
    Interval = 500
    OnTimer = onJoinTimer3Timer
    Left = 264
    Top = 32
  end
  object BalloonHint1: TBalloonHint
    HideAfter = 3000
    Left = 336
    Top = 32
  end
  object Tray1: TTrayIcon
    Visible = True
    OnBalloonClick = Tray1BalloonClick
    OnClick = Tray1Click
    Left = 400
    Top = 32
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 440
    Top = 32
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer2Timer
    Left = 480
    Top = 32
  end
  object Timer3: TTimer
    Interval = 100
    OnTimer = Timer3Timer
    Left = 520
    Top = 32
  end
end
