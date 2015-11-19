object Form12: TForm12
  Left = 0
  Top = 0
  Caption = 'Form12'
  ClientHeight = 367
  ClientWidth = 584
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
    Width = 546
    Height = 13
    Caption = 
      'NOTE:  The OWL Language is designed for inference and reasoning,' +
      ' and its XML encoding is based on RDF triples.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 48
    Top = 35
    Width = 520
    Height = 13
    Caption = 
      'For these reasons, it is not possible to convert an IDEAS ontolo' +
      'gy to OWL and still maintain the built-in OWL '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 48
    Top = 54
    Width = 471
    Height = 13
    Caption = 
      'properties such as rdf:type and rdfs:subClassOf. In addition, on' +
      'ly IDEAS couples can be exported'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 110
    Height = 13
    Caption = 'Default NamingScheme'
  end
  object Label5: TLabel
    Left = 40
    Top = 136
    Width = 77
    Height = 13
    Caption = 'XML Namespace'
  end
  object Label6: TLabel
    Left = 424
    Top = 136
    Width = 43
    Height = 13
    Caption = 'NS Name'
  end
  object Label7: TLabel
    Left = 48
    Top = 73
    Width = 474
    Height = 13
    Caption = 
      'The development of this OWL export functionality was partially s' +
      'ponsored by Lockheed Martin inc. '
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 176
    Width = 568
    Height = 138
    Color = clBtnFace
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object ComboBox1: TComboBox
    Left = 128
    Top = 104
    Width = 448
    Height = 21
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 128
    Top = 133
    Width = 281
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 473
    Top = 133
    Width = 103
    Height = 21
    TabOrder = 3
  end
  object Button1: TButton
    Left = 420
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Export'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 501
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 5
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 320
    Width = 177
    Height = 17
    Caption = 'Trace to IDEAS Foundation'
    TabOrder = 6
  end
  object CheckBox2: TCheckBox
    Left = 237
    Top = 319
    Width = 113
    Height = 17
    Caption = 'This Model is DM2'
    TabOrder = 7
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 237
    Top = 342
    Width = 148
    Height = 17
    Caption = 'I like my OWL first-order'
    TabOrder = 8
  end
  object CheckBox4: TCheckBox
    Left = 8
    Top = 343
    Width = 223
    Height = 17
    Caption = 'Trace to elements external to  package'
    TabOrder = 9
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.owl'
    Filter = 'OWL Files|*.owl|RDF Files|*.rdf|All Files|*.*'
    Title = 'Save OWL File'
    Left = 336
    Top = 256
  end
end
