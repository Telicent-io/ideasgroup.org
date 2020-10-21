object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 590
  ClientWidth = 766
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
    Left = 8
    Top = 365
    Width = 103
    Height = 13
    Caption = 'Fixed Table Structure'
  end
  object Label2: TLabel
    Left = 439
    Top = 365
    Width = 64
    Height = 13
    Caption = 'AutoNumber:'
  end
  object Label4: TLabel
    Left = 239
    Top = 8
    Width = 77
    Height = 13
    Caption = 'Generated SQL:'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Model Name:'
  end
  object Label5: TLabel
    Left = 8
    Top = 54
    Width = 23
    Height = 13
    Caption = 'URL:'
  end
  object Label6: TLabel
    Left = 8
    Top = 100
    Width = 102
    Height = 13
    Caption = 'Root NamingScheme:'
  end
  object Memo1: TMemo
    Left = 8
    Top = 384
    Width = 425
    Height = 169
    Color = clBtnFace
    Lines.Strings = (
      'DROP TABLE IDEAS_LongNames CASCADE CONSTRAINTS;'
      'DROP TRIGGER SET_IDEAS_Models_ID;'
      'DROP SEQUENCE IDEAS_Models_ID_SEQ;'
      'DROP TABLE IDEAS_Models CASCADE CONSTRAINTS;'
      'DROP TABLE IDEAS_RootNames CASCADE CONSTRAINTS;'
      'DROP TABLE IDEAS_ShortNames CASCADE CONSTRAINTS;'
      'DROP TABLE IDEAS_SS CASCADE CONSTRAINTS;'
      'DROP TRIGGER SET_IDEAS_Things_ID;'
      'DROP SEQUENCE IDEAS_Things_ID_SEQ;'
      'DROP TABLE IDEAS_Things CASCADE CONSTRAINTS;'
      'DROP TABLE IDEAS_PlaceableTypes CASCADE CONSTRAINTS;'
      'DROP TABLE IDEAS_WP CASCADE CONSTRAINTS;'
      ''
      'CREATE TABLE IDEAS_LongNames'
      '('
      #9'ID        NUMBER,'
      #9'nameText  CLOB'
      ');'
      ''
      'CREATE TABLE IDEAS_Models'
      '('
      #9'ID               NUMBER NOT NULL,'
      #9'modelName        CHAR(255),'
      #9'url              CHAR(255),'
      #9'createdDateTime  TIMESTAMP'
      ');'
      ''
      'CREATE TABLE IDEAS_RootNames'
      '('
      #9'ID        NUMBER,'
      #9'nameText  CHAR(255)'
      ');'
      ''
      'CREATE TABLE IDEAS_ShortNames'
      '('
      #9'ID        NUMBER,'
      #9'nameText  CHAR(255)'
      ');'
      ''
      'CREATE TABLE IDEAS_SS'
      '('
      #9'super  NUMBER,'
      #9'sub    NUMBER'
      ');'
      ''
      'CREATE TABLE IDEAS_Things'
      '('
      #9'ID                  NUMBER NOT NULL,'
      #9'isFoundation        NUMBER(3) NOT NULL,'
      #9'isPlaceableType     NUMBER(3) NOT NULL,'
      #9'place1              NUMBER,'
      #9'place2              NUMBER,'
      #9'place3              NUMBER,'
      #9'place4              NUMBER,'
      #9'place5              NUMBER,'
      #9'model               NUMBER,'
      #9'createdDateTime    TIMESTAMP,'
      #9'foundationCategory  NUMBER'
      ');'
      ''
      'CREATE TABLE IDEAS_PlaceableTypes'
      '('
      #9'ID          NUMBER,'
      #9'place1Name  CHAR(255),'
      #9'place2Name  CHAR(255),'
      #9'place3Name  CHAR(255),'
      #9'place4Name  CHAR(255),'
      #9'place5Name  CHAR(255),'
      #9'place1Type  NUMBER,'
      #9'place2Type  NUMBER,'
      #9'place3Type  NUMBER,'
      #9'place4Type  NUMBER,'
      #9'place5Type  NUMBER'
      ');'
      ''
      'CREATE TABLE IDEAS_WP'
      '('
      #9'whole  NUMBER,'
      #9'part   NUMBER'
      ');'
      ''
      'ALTER TABLE IDEAS_LongNames ADD CONSTRAINT PK_LongNames '
      #9'PRIMARY KEY (ID);'
      ''
      'ALTER TABLE IDEAS_Models ADD CONSTRAINT PK_Models '
      #9'PRIMARY KEY (ID);'
      ''
      'ALTER TABLE IDEAS_RootNames ADD CONSTRAINT PK_IdeasNames '
      #9'PRIMARY KEY (ID);'
      ''
      'ALTER TABLE IDEAS_ShortNames ADD CONSTRAINT PK_ShortNames '
      #9'PRIMARY KEY (ID);'
      ''
      'ALTER TABLE IDEAS_SS ADD CONSTRAINT PK_SS '
      #9'PRIMARY KEY (super, sub);'
      ''
      'ALTER TABLE IDEAS_Things ADD CONSTRAINT PK_Things '
      #9'PRIMARY KEY (ID);'
      ''
      
        'ALTER TABLE IDEAS_PlaceableTypes ADD CONSTRAINT PK_PlaceableType' +
        's '
      #9'PRIMARY KEY (ID);'
      ''
      'ALTER TABLE IDEAS_WP ADD CONSTRAINT PK_WP '
      #9'PRIMARY KEY (whole, part);'
      ''
      ''
      'CREATE UNIQUE INDEX IDX_Modelsurl ON IDEAS_Models'
      '(url ASC);'
      ''
      'CREATE UNIQUE INDEX IDX_IdeasNamesnameText ON IDEAS_RootNames'
      '(nameText ASC);'
      ''
      'CREATE INDEX IDX_ShortNamesnameText ON IDEAS_ShortNames'
      '(nameText ASC);'
      ''
      'CREATE INDEX IDX_SSsub ON IDEAS_SS'
      '(sub ASC);'
      ''
      'CREATE INDEX IDX_SSsuper ON IDEAS_SS'
      '(super ASC);'
      ''
      'CREATE INDEX IDX_ThingsfoundationCategory ON IDEAS_Things'
      '(foundationCategory ASC);'
      ''
      'CREATE INDEX IDX_ThingsID ON IDEAS_Things'
      '(ID ASC);'
      ''
      'CREATE INDEX IDX_Thingsplace1 ON IDEAS_Things'
      '(place1 ASC);'
      ''
      'CREATE INDEX IDX_Thingsplace2 ON IDEAS_Things'
      '(place2 ASC);'
      ''
      'CREATE INDEX IDX_Thingsplace3 ON IDEAS_Things'
      '(place3 ASC);'
      ''
      'CREATE INDEX IDX_Thingsplace4 ON IDEAS_Things'
      '(place4 ASC);'
      ''
      'CREATE INDEX IDX_Thingsplace5 ON IDEAS_Things'
      '(place5 ASC);'
      ''
      'CREATE INDEX IDX_WPpart ON IDEAS_WP'
      '(part ASC);'
      ''
      'CREATE INDEX IDX_WPwhole ON IDEAS_WP'
      '(whole ASC);'
      ''
      'ALTER TABLE IDEAS_RootNames ADD CONSTRAINT ThingsIdeasNames '
      #9'FOREIGN KEY (ID) REFERENCES IDEAS_Things (ID);'
      ''
      'ALTER TABLE IDEAS_ShortNames ADD CONSTRAINT ThingsNames '
      #9'FOREIGN KEY (ID) REFERENCES IDEAS_Things (ID);'
      ''
      'ALTER TABLE IDEAS_LongNames ADD CONSTRAINT ThingsLongNames '
      #9'FOREIGN KEY (ID) REFERENCES IDEAS_Things (ID);'
      ''
      'ALTER TABLE IDEAS_Things ADD CONSTRAINT ModelsThings '
      #9'FOREIGN KEY (Model) REFERENCES IDEAS_Models (ID);'
      ''
      
        'ALTER TABLE IDEAS_PlaceableTypes ADD CONSTRAINT ThingsPlaceableT' +
        'ypes '
      #9'FOREIGN KEY (ID) REFERENCES IDEAS_Things (ID);'
      '')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 439
    Top = 384
    Width = 319
    Height = 169
    Color = clBtnFace
    Lines.Strings = (
      'CREATE SEQUENCE IDEAS_Models_ID_SEQ'
      'INCREMENT BY 1'
      'START WITH 100'
      'NOMAXVALUE'
      'MINVALUE 100'
      'NOCYCLE'
      'NOCACHE'
      'NOORDER;'
      ''
      'CREATE OR REPLACE TRIGGER SET_IDEAS_Models_ID'
      'BEFORE INSERT'
      'ON IDEAS_Models'
      'FOR EACH ROW'
      'BEGIN'
      '  SELECT IDEAS_Models_ID_SEQ.NEXTVAL'
      '  INTO :NEW.ID'
      '  FROM DUAL;'
      'END;'
      ''
      'CREATE SEQUENCE IDEAS_Things_ID_SEQ'
      'INCREMENT BY 1'
      'START WITH 1000'
      'NOMAXVALUE'
      'MINVALUE 1000'
      'NOCYCLE'
      'NOCACHE'
      'NOORDER;'
      ''
      'CREATE OR REPLACE TRIGGER SET_IDEAS_Things_ID'
      'BEFORE INSERT'
      'ON IDEAS_Things'
      'FOR EACH ROW'
      'BEGIN'
      '  SELECT IDEAS_Things_ID_SEQ.NEXTVAL'
      '  INTO :NEW.ID'
      '  FROM DUAL;'
      'END;')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 156
    Width = 225
    Height = 25
    Caption = 'Export'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 683
    Top = 559
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Memo3: TMemo
    Left = 8
    Top = 187
    Width = 225
    Height = 142
    Color = clBtnFace
    TabOrder = 4
  end
  object Memo4: TMemo
    Left = 239
    Top = 27
    Width = 519
    Height = 302
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object Button3: TButton
    Left = 683
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Save As'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 27
    Width = 225
    Height = 21
    TabOrder = 7
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 8
    Top = 73
    Width = 225
    Height = 21
    TabOrder = 8
    Text = 'Edit2'
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 119
    Width = 225
    Height = 21
    TabOrder = 9
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.sql'
    Filter = 'SQL|*.sql|All Files|*.*'
    Title = 'Save SQL'
    Left = 248
    Top = 336
  end
end
