object Form11: TForm11
  Left = 0
  Top = 0
  Caption = 'Form11'
  ClientHeight = 282
  ClientWidth = 391
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
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 58
    Height = 13
    Caption = 'Model Name'
  end
  object Label3: TLabel
    Left = 8
    Top = 46
    Width = 45
    Height = 13
    Caption = 'Base URL'
  end
  object Edit1: TEdit
    Left = 127
    Top = 16
    Width = 253
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 224
    Top = 246
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 305
    Top = 246
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 151
    Width = 372
    Height = 89
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 127
    Top = 43
    Width = 253
    Height = 21
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 70
    Width = 372
    Height = 75
    Caption = 'Naming Scheme'
    TabOrder = 5
    object ComboBox1: TComboBox
      Left = 104
      Top = 19
      Width = 257
      Height = 21
      TabOrder = 0
      Text = 'ComboBox1'
      OnCloseUp = ComboBox1CloseUp
    end
    object RadioButton1: TRadioButton
      Left = 16
      Top = 23
      Width = 82
      Height = 17
      Caption = 'use existing'
      TabOrder = 1
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 46
      Width = 113
      Height = 17
      Caption = 'create new'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = RadioButton2Click
    end
    object Edit3: TEdit
      Left = 104
      Top = 46
      Width = 193
      Height = 21
      TabOrder = 3
      OnClick = Edit3Click
    end
    object CheckBox1: TCheckBox
      Left = 303
      Top = 46
      Width = 58
      Height = 17
      Caption = 'Unique'
      TabOrder = 4
    end
  end
end
