object Form9: TForm9
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Form9'
  ClientHeight = 293
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 63
    Width = 102
    Height = 13
    Caption = 'Errors and Warnings:'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 330
    Height = 13
    Caption = 
      'The model you have opened was produced using an older version of' +
      ' '
  end
  object Label3: TLabel
    Left = 8
    Top = 21
    Width = 322
    Height = 13
    Caption = 'IDEAS Plug-In. It is strongly recommended you update your model.'
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 40
    Width = 334
    Height = 17
    TabOrder = 0
  end
  object Button1: TButton
    Left = 232
    Top = 255
    Width = 110
    Height = 25
    Caption = 'No Thanks'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 82
    Width = 334
    Height = 167
    TabOrder = 2
  end
  object Button2: TButton
    Left = 8
    Top = 255
    Width = 121
    Height = 25
    Caption = 'Update My Model'
    TabOrder = 3
    OnClick = Button2Click
  end
end
