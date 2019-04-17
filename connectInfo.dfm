object connectForm: TconnectForm
  Left = 463
  Top = 281
  BorderStyle = bsSingle
  Caption = 'Connection Info'
  ClientHeight = 256
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    480
    256)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 464
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Connection'
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 19
      Width = 32
      Height = 13
      Caption = 'Server'
    end
    object Label2: TLabel
      Left = 16
      Top = 46
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object ServerEdit: TEdit
      Left = 91
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object PortEdit: TEdit
      Left = 91
      Top = 43
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '6667'
    end
    object Button1: TButton
      Left = 376
      Top = 34
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 95
    Width = 464
    Height = 109
    Anchors = [akLeft, akTop, akRight]
    Caption = 'User Info'
    TabOrder = 3
    object Label3: TLabel
      Left = 16
      Top = 20
      Width = 45
      Height = 13
      Caption = 'Nickname'
    end
    object Label4: TLabel
      Left = 16
      Top = 73
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object Label5: TLabel
      Left = 16
      Top = 46
      Width = 61
      Height = 13
      Caption = 'Alt Nickname'
    end
    object NicknameEdit: TEdit
      Left = 91
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object RealNameEdit: TEdit
      Left = 91
      Top = 70
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object AltNickEdit: TEdit
      Left = 91
      Top = 43
      Width = 121
      Height = 21
      TabOrder = 1
    end
  end
  object Button2: TButton
    Left = 296
    Top = 216
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button2Click
    ExplicitTop = 200
  end
  object Button3: TButton
    Left = 384
    Top = 216
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button3Click
    ExplicitTop = 200
  end
end
