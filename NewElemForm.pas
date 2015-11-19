unit NewElemForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, IdeasLib, EA_TLB, ValEdit, EA_Ideas_Lib,
  ImgList;

type
  TForm6 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    ValueListEditor1: TValueListEditor;
    ImageList1: TImageList;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ValueListEditor1Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ValueListEditor1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    defaultNS : string;
    lastST : string;
    rep : iDualRepository;
    element : iDualElement;
    originalName : string;
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.Button2Click(Sender: TObject);
begin
  if checkbox1.Checked then element.Abstract := '1' else element.Abstract := '0';
  element.Refresh;
  close;
end;

procedure TForm6.Edit1Change(Sender: TObject);
begin
  if (form6.ActiveControl = edit1) and (defaultNS <> '') then
  begin
    valuelisteditor1.Values[defaultNS] := edit1.Text;
  end;
end;

procedure TForm6.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i,j : integer;
  myAttr, testAttr : iDualAttribute;
  tagName : string;
begin
  element.Name := edit1.Text;
  element.Update;
  if memo1.Text <> '' then element.Notes := memo1.Text;
  element.Update;
  canclose := true;
  if valuelisteditor1.RowCount > 1 then
  for i := 1 to valuelisteditor1.RowCount - 1 do
  begin
    if valuelisteditor1.Cells[1,i] <> '' then
    begin

      setThingName(element, valuelisteditor1.Cells[1,i], valuelisteditor1.Cells[0,i]);
    end else
    begin
      tagName := '';
      if valuelisteditor1.Cells[0,i] = 'IDEASName' then tagName := 'IDEASName' else tagName := 'IDEASName::' + valuelisteditor1.Cells[0,i];
      if tagName <> '' then deleteTag(element,tagName);
    end;
    if (element.Stereotype = 'IDEAS:UniqueNamingScheme') or (element.Stereotype = 'IDEAS:NamingScheme') then
    begin
      if (valuelisteditor1.Cells[0,i] = 'IDEASName') then
      begin
        if  (valuelisteditor1.Cells[1,i] = '') then
        begin
          canclose := false;
          showmessage('All NamingSchemes must have an IDEAS Name ');
          valuelisteditor1.Cells[1,i] := element.ElementGUID;
        end;
      end;
    end;
  end;
end;

procedure TForm6.FormShow(Sender: TObject);
var
  i,j : integer;
  NSs : iDualCollection;
  myNS : iDualElement;
  myTag : iDualTaggedValue;
  nameText, rootName : string;
  ideasFound : boolean;
  errors : tStringList;
begin
  ideasFound := false;
  label1.Caption := defaultNS + ' name:';
  caption := element.Stereotype + ': ' + element.Name;
  edit1.Text := element.Name;
  memo1.Clear;
  memo1.Lines.Clear;
  memo1.Text := element.Notes;
  edit1.SelectAll;
  errors := tStringList.Create;
  valuelisteditor1.Strings.Text := '';
  NSs := rep.GetElementsByQuery('findByST','IDEAS:UniqueNamingScheme');
  if NSs.Count > 0 then
  for i := 0 to NSs.Count - 1 do
  begin
    nameText := '';
    myNS := NSs.GetAt(i) as iDualElement;
    if element.TaggedValues.Count > 0 then
    for j := 0 to (element.TaggedValues.Count - 1) do
    begin
      myTag := element.TaggedValues.GetAt(j) as iDualTaggedValue;
      if (myTag.Name = 'IDEASName::' + myNS.name) or ((myTag.Name = 'IDEASName') and (myTag.Name = myNS.name)) then
      begin
        nameText := myTag.Value;
        if (myNS.Name = defaultNS) then
        begin
          if (nameText <> element.name) and (nametext <> '') then showmessage('Mismatch for ' + defaultNS + ' name');
        end;
      end;
    end;
    if (nameText = '') and (myNS.Name = defaultNS) then nameText := element.Name;
    valueListEditor1.InsertRow(myNS.Name, nameText,true);
  end;
  NSs := rep.GetElementsByQuery('findByST','IDEAS:NamingScheme');
  if NSs.Count > 0 then
  for i := 0 to NSs.Count - 1 do
  begin
    nameText := '';
    myNS := NSs.GetAt(i) as iDualElement;
    if element.TaggedValues.Count > 0 then
    for j := 0 to (element.TaggedValues.Count - 1) do
    begin
      myTag := element.TaggedValues.GetAt(j) as iDualTaggedValue;
      if (myTag.Name = 'IDEASName::' + myNS.name) or ((myTag.Name = 'IDEASName') and (myTag.Name = myNS.name)) then
      begin
        nameText := myTag.Value;
        if (myNS.Name = defaultNS) then
        begin
          if (nameText <> element.name) and (nametext <> '') then showmessage('Mismatch for ' + defaultNS + ' name');
        end;
      end;
    end;
    if (nameText = '') and (myNS.Name = defaultNS) then nameText := element.Name;
    valueListEditor1.InsertRow(myNS.Name, nameText,true);
  end;
//  if (not ideasFound) and ((element.Stereotype = 'IDEAS:NamingScheme') or (element.Stereotype = 'IDEAS:UniqueNamingScheme')) then valueListEditor1.InsertRow('IDEASName', element.Name,true);

  self.ActiveControl := edit1;
  FocusControl(edit1);
end;

procedure TForm6.ValueListEditor1Exit(Sender: TObject);
begin
  if (defaultNS <> '') and (valuelisteditor1.Values[defaultNS] <> '') then
  begin
    edit1.Text := valuelisteditor1.Values[defaultNS];
  end;
end;

procedure TForm6.ValueListEditor1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  if (form6.ActiveControl = ValueListEditor1) and (aCol = 1) and (defaultNS <> '') and (valuelisteditor1.Cells[0,ARow] = defaultNS) then
  begin
    edit1.Text := valuelisteditor1.Values[defaultNS];
  end;

end;

end.
