object Form10: TForm10
  Left = 0
  Top = 0
  Caption = 'Form10'
  ClientHeight = 376
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 472
    Height = 64
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 384
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 288
      Top = 6
      Width = 90
      Height = 25
      Caption = 'Run Checks'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 8
      Top = 6
      Width = 137
      Height = 25
      Caption = 'Copy Errors to Clipboard'
      TabOrder = 2
      OnClick = Button3Click
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 37
      Width = 217
      Height = 17
      Caption = 'Check for ISO15926 Description Rules'
      TabOrder = 3
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 472
    Height = 312
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitHeight = 296
  end
end
