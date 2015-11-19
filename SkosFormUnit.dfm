object SkosForm: TSkosForm
  Left = 0
  Top = 0
  Caption = 'SkosForm'
  ClientHeight = 373
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 256
    Top = 8
    Width = 91
    Height = 13
    Caption = 'SKOS Scheme URI:'
  end
  object Label2: TLabel
    Left = 256
    Top = 146
    Width = 80
    Height = 13
    Caption = 'Namespace URI:'
  end
  object Label3: TLabel
    Left = 256
    Top = 51
    Width = 64
    Height = 13
    Caption = 'Scheme Title:'
  end
  object Label4: TLabel
    Left = 256
    Top = 80
    Width = 41
    Height = 13
    Caption = 'Creator:'
  end
  object Label5: TLabel
    Left = 256
    Top = 107
    Width = 47
    Height = 13
    Caption = 'Language'
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 16
    Width = 217
    Height = 17
    Caption = 'Export Sub-Classes (superSubtype)'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 39
    Width = 217
    Height = 17
    Caption = 'Export Typical Parts (WholePartType)'
    Enabled = False
    TabOrder = 1
  end
  object CheckBox3: TCheckBox
    Left = 16
    Top = 62
    Width = 217
    Height = 17
    Caption = 'Export Parts'
    TabOrder = 2
    Visible = False
  end
  object Button1: TButton
    Left = 8
    Top = 325
    Width = 75
    Height = 25
    Caption = 'Export'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 198
    Width = 519
    Height = 121
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 256
    Top = 24
    Width = 258
    Height = 21
    TabOrder = 5
    Text = 'http://www.modelfutures.com/skos/MyScheme'
  end
  object Edit2: TEdit
    Left = 256
    Top = 165
    Width = 258
    Height = 21
    TabOrder = 6
    Text = 'http://www.modelfutures.com/skos/'
  end
  object Button2: TButton
    Left = 452
    Top = 325
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 7
    OnClick = Button2Click
  end
  object CheckBox4: TCheckBox
    Left = 89
    Top = 333
    Width = 97
    Height = 17
    Caption = 'Recurse'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object Edit3: TEdit
    Left = 326
    Top = 51
    Width = 188
    Height = 21
    TabOrder = 9
    Text = 'My Scheme'
  end
  object Edit4: TEdit
    Left = 326
    Top = 78
    Width = 188
    Height = 21
    TabOrder = 10
    Text = 'Ian Bailey'
  end
  object Edit5: TEdit
    Left = 326
    Top = 105
    Width = 188
    Height = 21
    TabOrder = 11
    Text = 'EN'
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.skos'
    Title = 'Export SKOS'
    Left = 216
    Top = 248
  end
end
