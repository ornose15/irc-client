object optionsForm: ToptionsForm
  Left = 463
  Top = 281
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 246
  ClientWidth = 392
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
    392
    246)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 394
    Height = 247
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    ExplicitWidth = 384
    ExplicitHeight = 202
    object TabSheet1: TTabSheet
      Caption = 'General Options'
      ExplicitLeft = 28
      ExplicitTop = 40
      ExplicitWidth = 281
      ExplicitHeight = 165
      DesignSize = (
        386
        219)
      object GroupBox1: TGroupBox
        Left = 3
        Top = 3
        Width = 378
        Height = 70
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Startup'
        TabOrder = 0
        ExplicitWidth = 368
        object CheckBox1: TCheckBox
          Left = 16
          Top = 16
          Width = 209
          Height = 17
          Caption = 'Show Connection Info dialog'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CheckBox2: TCheckBox
          Left = 16
          Top = 32
          Width = 209
          Height = 17
          Caption = 'Auto connect to last server'
          TabOrder = 1
        end
        object CheckBox3: TCheckBox
          Left = 16
          Top = 48
          Width = 209
          Height = 17
          Caption = 'Auto join channels'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 79
        Width = 378
        Height = 42
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Nick Alert'
        TabOrder = 1
        ExplicitWidth = 368
        object CheckBox4: TCheckBox
          Left = 16
          Top = 16
          Width = 209
          Height = 17
          Caption = 'Enable nick alerting'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
      end
      object GroupBox3: TGroupBox
        Left = 3
        Top = 127
        Width = 378
        Height = 58
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Other'
        TabOrder = 2
        ExplicitWidth = 368
        object CheckBox5: TCheckBox
          Left = 16
          Top = 16
          Width = 209
          Height = 17
          Caption = 'Launch PyroIRC when Windows starts'
          TabOrder = 0
        end
        object CheckBox6: TCheckBox
          Left = 16
          Top = 32
          Width = 209
          Height = 17
          Caption = 'Minimize PyroIRC to tray'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object Button2: TButton
        Left = 243
        Top = 191
        Width = 61
        Height = 25
        Caption = 'OK'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 310
        Top = 191
        Width = 61
        Height = 25
        Caption = 'Cancel'
        TabOrder = 4
        OnClick = Button3Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Auto Joins'
      ImageIndex = 1
      ExplicitWidth = 376
      ExplicitHeight = 174
      DesignSize = (
        386
        219)
      object Label1: TLabel
        Left = 3
        Top = 3
        Width = 160
        Height = 13
        Caption = 'Each auto join goes on a new line'
      end
      object Memo1: TMemo
        Left = 3
        Top = 24
        Width = 378
        Height = 162
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 368
        ExplicitHeight = 161
      end
      object Button1: TButton
        Left = 310
        Top = 191
        Width = 61
        Height = 25
        Caption = 'Join Now'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button4: TButton
        Left = 243
        Top = 191
        Width = 61
        Height = 25
        Caption = 'OK'
        TabOrder = 2
        OnClick = Button4Click
      end
    end
  end
end
