object Form14: TForm14
  Left = 0
  Top = 0
  Caption = 'Form14'
  ClientHeight = 280
  ClientWidth = 389
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 372
    Height = 113
    Caption = 'Individual'
    TabOrder = 0
    object CheckBox1: TCheckBox
      Left = 16
      Top = 48
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object Edit1: TEdit
      Left = 32
      Top = 48
      Width = 329
      Height = 21
      TabOrder = 1
      Text = 'IndividualPart'
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 71
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CheckBox2Click
    end
    object Edit2: TEdit
      Left = 32
      Top = 71
      Width = 329
      Height = 21
      TabOrder = 3
      Text = 'IndividualState'
    end
    object Edit3: TEdit
      Left = 32
      Top = 21
      Width = 329
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = 'Edit3'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 127
    Width = 372
    Height = 106
    Caption = 'wholePart'
    TabOrder = 1
    object CheckBox4: TCheckBox
      Left = 16
      Top = 24
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox4Click
    end
    object CheckBox5: TCheckBox
      Left = 16
      Top = 47
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBox5Click
    end
    object CheckBox6: TCheckBox
      Left = 16
      Top = 70
      Width = 17
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CheckBox6Click
    end
    object Edit4: TEdit
      Left = 32
      Top = 24
      Width = 329
      Height = 21
      TabOrder = 3
      Text = 'individualWholePart'
    end
    object Edit5: TEdit
      Left = 32
      Top = 47
      Width = 329
      Height = 21
      TabOrder = 4
      Text = 'individualWholeAndPart'
    end
    object Edit6: TEdit
      Left = 32
      Top = 70
      Width = 329
      Height = 21
      TabOrder = 5
      Text = 'individualWholeState'
    end
  end
  object Button1: TButton
    Left = 224
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 305
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 239
    Width = 97
    Height = 17
    Caption = 'Add Powertypes'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
