unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, EA_TLB, EA_Ideas_Lib, unit3;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Memo2: TMemo;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Memo3: TMemo;
    Memo4: TMemo;
    Label4: TLabel;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Edit1: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    ComboBox1: TComboBox;
    procedure createThing(id : integer; rootName : string; fcat : integer; into : tStrings);
    procedure createPlaceableType(id : integer; rootName : string; fcat : integer; p1, p2, p3, p4, p5 : integer; p1Name, p2Name, p3Name, p4Name, p5Name : string; into : tStrings);
    procedure createTuple(id : integer; fcat : integer; p1, p2, p3, p4, p5 : integer; into : tStrings);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    selPackage : iDualPackage;
    rep : iDualRepository;
  end;

var
  Form2: TForm2;

implementation

uses unit1;

{$R *.dfm}

procedure TForm2.createThing(id : integer; rootName : string; fcat : integer; into : tStrings);
begin
  into.Add('INSERT INTO IDEAS_Things (ID, isFoundation, isPlaceableType, foundationCategory, createdDateTime, model)');
  into.Add('VALUES (' + vartostr(id) + ',1,0,' + vartostr(fcat) + ', CURRENT_TIMESTAMP, 1);');
  into.Add('INSERT INTO IDEAS_RootNames (ID, nameText)');
  into.Add('VALUES (' + vartostr(id) + ',''' + rootName + ''');');
  into.Add('');
end;

procedure TForm2.createPlaceableType(id : integer; rootName : string; fcat : integer; p1, p2, p3, p4, p5 : integer; p1Name, p2Name, p3Name, p4Name, p5Name : string; into : tStrings);
begin
  into.Add('INSERT INTO IDEAS_Things (ID, isFoundation, isPlaceableType, foundationCategory, createdDateTime, model)');
  into.Add('VALUES (' + vartostr(id) + ',1,1,' + vartostr(fcat) + ', CURRENT_TIMESTAMP,1);');
  into.Add('INSERT INTO IDEAS_RootNames (ID, nameText)');
  into.Add('VALUES (' + vartostr(id) + ',''' + rootName + ''');');
  into.Add('INSERT INTO IDEAS_PlaceableTypes (ID, place1Name, place2Name, place3Name, place4Name, place5Name, place1Type, place2Type, place3Type, place4Type, place5Type)');
  into.Add('VALUES (' + vartostr(id) + ',''' + p1Name + ''',''' + p2Name + ''',''' + p3Name + ''',''' + p4Name + ''',''' + p5Name + ''',' + vartostr(p1) + ',' + vartostr(p2) + ',' + vartostr(p3) + ',' + vartostr(p4) + ',' + vartostr(p5) + ');');
  into.Add('');
end;

procedure TForm2.createTuple(id : integer; fcat : integer; p1, p2, p3, p4, p5 : integer; into : tStrings);
begin
  into.Add('INSERT INTO IDEAS_Things (ID, isFoundation, isPlaceableType, foundationCategory, place1, place2, place3, place4, place5, createdDateTime, model)');
  into.Add('VALUES (' + vartostr(id) + ',1,0,' + vartostr(fcat) + ',' + vartostr(p1) + ',' + vartostr(p2) + ',' + vartostr(p3) + ',' + vartostr(p4) + ',' + vartostr(p5) + ', CURRENT_TIMESTAMP,1);');
  into.Add('');
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  allElements, elementsByName : tStringlist;
  errors : tStrings;
  connected : iDualElement;
  data, supers : tStringList;
  placeableID, i,j, index, tupleCount, relatedPos : integer;
  myHolder, relatedHolder : tElemHolder;
  connections : iDualCollection;
  myConnector : iDualConnector;
begin
  memo4.Visible := false;
  data := tStringlist.Create;
  placeableID := 0;
  memo4.Lines.Clear;
  memo4.Lines.AddStrings(memo1.Lines);
  memo4.Lines.Add('--  Insert Foundation ');
  errors := memo4.Lines;
  allElements := tStringList.Create;
  allElements.Sorted := true;
  elementsByName := tStringList.Create;
  elementsByName.Sorted := true;
  supers := tStringList.Create;
  supers.Sorted := true;
  //Add the Model...
  memo4.Lines.Add('INSERT INTO IDEAS_Models (ID, modelName, url, createdDateTime)');
  memo4.Lines.Add('VALUES (1,''' + edit1.text + ''',''' + edit2.text + ''', CURRENT_TIMESTAMP);');
  memo4.Lines.Add('');
  getElementsInPackage(selPackage,allElements,'',rep,true, errors,self);
  //first pass trhough elements, sort out the fcats
  if allElements.Count > 0 then
  for i := 0 to allElements.Count - 1 do
  begin
    myHolder := allElements.Objects[i] as tElemHolder;
    myHolder.st := stringreplace(myHolder.st,'IDEAS:','',[rfReplaceAll]);
    elementsByName.AddObject(myHolder.name,myHolder);
    if myHolder.name = 'PlaceableType' then placeableID := myHolder.ID;
  end;
  tupleCount := allElements.Count + 1;

  if elementsByName.Count > 0 then
  for i := 0 to elementsByName.Count - 1 do
  begin
    myHolder := elementsByName.Objects[i] as tElemHolder;
    if elementsByName.Find(myHolder.st,index) then myHolder.fcat := index else myHolder.fcat := 0;
    memo4.Lines.Add('-- ' + myHolder.st + ' : ' + myHolder.name + '(' + vartostr(i+1) + ')');
    createThing(i+1,myHolder.name,myHolder.fcat,memo4.Lines);
    connections := myHolder.element.Connectors;
    if connections.Count > 0 then
    for j := 0 to connections.Count - 1 do
    begin
      myConnector := connections.GetAt(j) as iDualConnector;
      connected := rep.GetElementByID(myConnector.SupplierID);
    //  memo4.Lines.Add('--' + myConnector.Stereotype + ' ID: ' + vartostr(myConnector.ConnectorID) + ' SupplierID ' + vartostr(myConnector.SupplierID) + ' ClientID ' + vartostr(myConnector.ClientID));
      if elementsByName.Find(connected.Name,relatedPos) and (myConnector.ClientID = myHolder.id) then
      begin
        relatedHolder := elementsByName.Objects[relatedPos] as tElemHolder;
        if elementsbyName.Find(stringreplace(myConnector.Stereotype,'IDEAS:','',[rfReplaceAll]), index) then
        begin
          memo4.Lines.Add('-- ' + myConnector.Stereotype + ' from ' + relatedHolder.name + '(' + vartostr(relatedPos+1)+ ') to ' + myHolder.name + '(' + vartostr(i+1) +')');
          createTuple(tupleCount,index,relatedPos+1,i+1,0,0,0,memo4.Lines);
          tupleCount := tupleCount + 1;
        end;
      end;
    end;
  end;


{  testElems := rep.GetElementsByQuery('findName','Thing');
  if testElems.Count > 0 then
  begin

  end else memo3.lines.add('Thing missing - check IDEAS Foundation is present');
  createThing(1,'Thing',2,memo4.Lines);
  createThing(2,'Type',2,memo4.Lines);
  createThing(3,'Powertype',2,memo4.Lines);
  createThing(4,'IndividualType',3,memo4.Lines);
  createThing(5,'Individual',4,memo4.Lines);
  createPlaceableType(6,'TupleType',3,2,2,2,2,2,'place1Type','place2Type','place3Type','place4Type','place5Type');
  createPlaceableType(7,'tuple',6,1,1,1,1,1,'place1','place2','place3','place4','place5');
  createPlaceableType(8,'couple',6,1,1,0,0,0,'place1','place2','','','');
  createPlaceableType(9,'wholePart',6,5,5,0,0,0,'whole','part','','','');
  createPlaceableType(10,'typeInstance',6,2,1,0,0,0,'type','instance','','','');
  createPlaceableType(11,'powertypeInstance',6,3,2,0,0,0,'powertype','instance','','','');     }
  memo4.Lines.Add('');
  memo4.Lines.Add('--  Create Packages ');
  memo4.Lines.Add('CREATE OR REPLACE PACKAGE IDEAS');
  memo4.Lines.Add('IS');
  memo4.Lines.Add('END IDEAS;');
  memo4.Lines.Add('');
  memo4.Lines.Add('CREATE OR REPLACE PACKAGE BODY IDEAS');
  memo4.Lines.Add('IS');

  memo4.Lines.AddStrings(memo2.lines);    // add the autonumber back in
  memo4.Visible := true;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if savedialog1.Execute then memo4.Lines.SaveToFile(savedialog1.FileName);
end;

end.
