object VisioForm: TVisioForm
  Left = 0
  Top = 0
  Caption = 'Export to Visio'
  ClientHeight = 363
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 391
    Top = 18
    Width = 72
    Height = 13
    Caption = 'Default Shape:'
  end
  object Button1: TButton
    Left = 388
    Top = 327
    Width = 75
    Height = 25
    Caption = 'Export'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 539
    Top = 327
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 18
    Width = 354
    Height = 337
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ComboBox1: TComboBox
    Left = 469
    Top = 15
    Width = 145
    Height = 21
    ItemIndex = 0
    TabOrder = 3
    Text = 'Rectangle'
    Items.Strings = (
      'Rectangle'
      'Rounded Rectangle'
      'Ellipse'
      'Square'
      'Diamond')
  end
  object RadioGroup1: TRadioGroup
    Left = 391
    Top = 42
    Width = 223
    Height = 95
    Caption = 'Border Colour'
    ItemIndex = 0
    Items.Strings = (
      'Use Border Colour'
      'Use Fill Colour'
      'Use This Colour:')
    TabOrder = 4
  end
  object RadioGroup2: TRadioGroup
    Left = 391
    Top = 143
    Width = 223
    Height = 90
    Caption = 'Fill Colour'
    ItemIndex = 0
    Items.Strings = (
      'Use Fill Colour'
      'Use Border Colour'
      'Use This Colour:')
    TabOrder = 5
  end
  object ColorBox1: TColorBox
    Left = 501
    Top = 107
    Width = 105
    Height = 22
    TabOrder = 6
  end
  object ColorBox2: TColorBox
    Left = 501
    Top = 203
    Width = 105
    Height = 22
    Selected = clWhite
    TabOrder = 7
  end
  object RadioGroup3: TRadioGroup
    Left = 391
    Top = 239
    Width = 223
    Height = 74
    Caption = 'Font Colour'
    ItemIndex = 0
    Items.Strings = (
      'Use Font Colour'
      'Use This Colour:')
    TabOrder = 8
  end
  object ColorBox3: TColorBox
    Left = 501
    Top = 284
    Width = 105
    Height = 22
    TabOrder = 9
  end
end
