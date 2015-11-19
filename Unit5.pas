unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EA_TLB, ComObj, IdeasLib, DB, unit3, unit1, EA_Ideas_Lib,
  ComCtrls, TabNotBk;

type
  TForm5 = class(TForm)
    Label6: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    TabbedNotebook1: TTabbedNotebook;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure Button1Click(Sender: TObject);
    function CompactAndRepair(DB: string): Boolean;
 //   procedure setFCat(id, fcat : integer);
    function createThing(holder : tElemHolder; namingScheme : tIdeasDBNamingScheme) : tIdeasDbTHing;
    procedure Button2Click(Sender: TObject); {DB = Path to Access Database}
 //   function createTuple(fcat,p1,p2,p3,p4,p5 : integer) : integer;
    function createCouple(category : string; p1,p2 : tElemHolder) : integer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    modelID : integer;
    defaultNS : string;
    newDb : boolean;
    fElems : tStringlist;
 //   db : tIdeasDatabase;
    iSess : tIdeasDBSession;
    selPackage : iDualPackage;
    rep : iDualRepository;
    filename : string;
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation


{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
end;
{
function TForm5.createThing(rootName : string) : integer;
var
  index : integer;
begin
  db.things.Append;
  if fElems.find(rootName,index) then db.things.FieldByName('IsFoundation').AsBoolean := true else db.things.FieldByName('IsFoundation').AsBoolean := false;
  if fElems.find(rootName,index) then memo1.lines.add(rootName + ' is Foundation');
  db.things.FieldByName('model').AsInteger := modelID;
  db.things.FieldByName('foundationCategory').AsInteger := 0;
  db.things.Post;
  db.ideasNames.Append;
  db.ideasNames.FieldByName('ID').AsInteger := db.things.FieldByName('ID').AsInteger;
  db.ideasNames.FieldByName('nameText').AsString := rootName;
  db.ideasNames.Post;
  createThing := db.things.FieldByName('ID').AsInteger;
end;

procedure TForm5.setFCat(id, fcat : integer);
begin
  if db.things.Locate('ID',id,[]) then
  begin
    db.things.Edit;
    db.things.FieldByName('foundationCategory').AsInteger := fcat;
    db.things.Post;
  end else memo1.Lines.Add('ERROR - Cannot find Thing Record ID:' + vartostr(id));
end;


function TForm5.createTuple(fcat,p1,p2,p3,p4,p5 : integer) : integer;
begin
  db.things.Append;
  db.things.FieldByName('IsFoundation').AsBoolean := true;
  db.things.FieldByName('model').AsInteger := modelID;
  db.things.FieldByName('place1').AsInteger := p1;
  db.things.FieldByName('foundationCategory').AsInteger := fcat;
  db.things.FieldByName('place2').AsInteger := p2;
  db.things.FieldByName('place3').AsInteger := p3;
  db.things.FieldByName('place4').AsInteger := p4;
  db.things.FieldByName('place5').AsInteger := p5;
  db.things.Post;
end;  }

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if iSess <> nil then
  begin
    iSess.disconnect;
    iSess.destroy;
  end;
end;

procedure TForm5.FormShow(Sender: TObject);
var
  filePath : string;
begin
  iSess := nil;
  Cursor := crHourGlass;
  if edit2.Text = '' then
  begin
    showmessage('Need to set a Model URL');
    close;
  end
  else
  begin
    if newDB and savedialog1.execute then
    begin
      filePath := extractFilePAth(application.ExeName)+'\blank.ideas';
      copyFile(pchar(filePath),pchar(savedialog1.filename),false);
      try
        iSess := tIdeasDbSession.create('','');
        iSess.primeDB(savedialog1.filename);
        iSess.connectToDatabase(savedialog1.filename,edit2.text);
      except
        showmessage('Could not create database');
        iSess := nil;
        close;
      end;
      filename := savedialog1.filename;
    end;
    if (not newDB) and opendialog1.execute then
    begin
      filePath := extractFilePAth(application.ExeName)+'\blank.ideas';
      try
        iSess := tIdeasDbSession.create(opendialog1.filename,edit2.text);
      except
        showmessage('Could not open database');
        iSess := nil;
        close;
      end;
      filename := opendialog1.filename;
    end;
  end;
  Cursor := crDefault;
end;

function TForm5.createCouple(category : string; p1,p2 : tElemHolder) : integer;
var
  p1Thing, p2Thing : tIdeasDbThing;
  p1Type, p2Type : tIdeasDbType;
  p1Ind, p2Ind : tIdeasDbIndividual;
  p1PT : tIdeasDbPowertype;
  p1NS : tIdeasDbNamingScheme;
  p2N : tIdeasDbName;
  myCouple : tIdeasDbCouple;
begin
  p1Thing := p1.thing;
  if p1Thing = nil then memo2.Lines.Add('IDEAS Item for ' + p1.name + ' not found');
  p2Thing := p2.thing;
  if p2Thing = nil then memo2.Lines.Add('IDEAS Item for ' + p2.name + ' not found');

  memo1.Lines.Add(p1Thing.idStr + '--' + p2Thing.idStr);

  if (category = 'superSubtype') and (p1Thing <> nil) and (p2Thing <> nil) then
  begin
    if (p1Thing is tIdeasDbType) and (p2Thing is tIdeasDbType) then
    begin
      p1Type := p1Thing as tIdeasDbType;
      p2Type := p2Thing as tIdeasDbType;
      myCouple := tIdeasDBSuperSubtype.create(p1Type,P2Type,iSess);
    end else memo2.Lines.Add('SuperSubtype connected to non-Type: ' + p1.name + ' to ' + p2.name);
  end;

  if (category = 'wholePart') and (p1Thing <> nil) and (p2Thing <> nil) then
  begin
    if (p1Thing is tIdeasDbIndividual) and (p2Thing is tIdeasDbIndividual) then
    begin
      p1Ind := p1Thing as tIdeasDbIndividual;
      p2Ind := p2Thing as tIdeasDbIndividual;
      myCouple := tIdeasDBWholePart.create(p1Ind,p2Ind,iSess);
    end else memo2.Lines.Add('WholePart connected to non-Individual: ' + p1.name + ' to ' + p2.name);
  end;

  if (category = 'typeInstance') and (p1Thing <> nil) and (p2Thing <> nil) then
  begin
    if (p1Thing is tIdeasDbType) then
    begin
      p1Type := p1Thing as tIdeasDbType;
      myCouple := tIdeasDbTypeInstance.create(p1Type,p2Thing,iSess);
    end else memo2.Lines.Add('TypeInstance connected from non-type: ' + p1.name);
  end;

  if (category = 'powertypeInstance') and (p1Thing <> nil) and (p2Thing <> nil) then
  begin
    if (p1Thing is tIdeasDbPowertype) and (p2Thing is tIdeasDbType) then
    begin
      p1PT := p1Thing as tIdeasDbPowertype;
      p2Type := p2Thing as tIdeasDbType;
      myCouple := tIdeasDbPowertypeInstance.create(p1Pt,p2Type,iSess);
    end else memo2.Lines.Add('PowerTypeInstance not connected from powertype to type: ' + p1.name + ' to ' + p2.name);
  end;

  if (category = 'namingSchemeInstance') and (p1Thing <> nil) and (p2Thing <> nil) then
  begin
    if (p1Thing is tIdeasDbNamingScheme) and (p2Thing is tIdeasDbName) then
    begin
      p1NS := p1Thing as tIdeasDbNamingScheme;
      p2N := p2Thing as tIdeasDbName;
      myCouple := tIdeasDbNamingSchemeInstance.create(p1NS,p2N,iSess);
    end else memo2.Lines.Add('NamingSchemeInstance not connected from NamingScheme to Name: ' + p1.name + ' to ' + p2.name);
  end;

  memo1.Lines.Add('--' + category + ' from ' + p1.name + '[id=' + vartostr(p1thing.idStr) + '] to ' + p2.name + '[id=' + vartostr(p2thing.idStr) + ']');
end;

function tForm5.createThing(holder : tElemHolder; namingScheme : tIdeasDBNamingScheme) : tIdeasDbThing;
var
  myThing : tIdeasDbThing;
  exText : string;
begin
  myThing := nil;
  if holder.st = 'Individual' then myThing := tIdeasDbIndividual.create(iSess,'');
  if holder.st = 'Type' then myThing := tIdeasDbType.create(iSess,'',nil);
  if holder.st = 'TupleType' then myThing := tIdeasDbTupleType.create(iSess,'','','','','','',nil,nil,nil,nil,nil,nil);
  if holder.st = 'Powertype' then myThing := tIdeasDbPowertype.create(iSess,'',nil);
  if holder.st = 'Name' then
  begin
  //  myThing := tIdeasDbName.create(iSess,'');
  end;
  if holder.st = 'NamingScheme' then myThing := tIdeasDbNamingScheme.create(iSess,'');
  if holder.st = 'UniqueNamingScheme' then myThing := tIdeasDbUniqueNamingScheme.create(iSess,'');
  if holder.st = 'IndividualType' then myThing := tIdeasDbIndividualType.create(iSess,'');
  if myThing = nil then myThing := tIdeasDbThing.create(iSess,'');
  if namingScheme <> nil then myThing.addName(holder.name,namingScheme);
  holder.thing := myTHing;
  memo1.lines.Add('  --New ' + holder.st + ' created. Internal ID: ' + myThing.idStr);
  createThing := myThing;
end;

procedure TForm5.Button2Click(Sender: TObject);
var
  allElements, elementsByName, disambiguateList, elementNames : tStringlist;
  testElems : IDualCollection;
  testElem, connected : iDualElement;
  data, supers : tStringList;
  placeableID, i,j,k, index, relatedPos : integer;
  myHolder, fcatHolder, relatedHolder, rootNameHolder, nsHolder : tElemHolder;
  supercomma : string;
  p1, p2, p3, p4, p5 : integer;
  p1n,p2n,p3n,p4n,p5n : string;
  connections : iDualCollection;
  myConnector : iDualConnector;
  t,ti,ss, nti, nb, n, rn, ns : tElemHolder;
  myThing, otherThing, testThing : tIdeasDbThing;
  NSs, testThings, relatedThings : tIdeasDBTHingList;
  rootNS, myNS, connectedNS : tIdeasDbNamingScheme;
  myAttr : iDualAttribute;
  name, connectedNSName : string;
  errors : tStrings;
begin
  screen.Cursor := crHourGlass;
  errors := memo2.Lines;
  memo2.Lines.Clear;
  rootNS := nil;
  //Have we got all these names in the database ?
  //Need to create a model for each of them...
  memo1.Lines.Add('-----------------------------------');
  memo1.Lines.Add('Adding NamingSchemes to database...');
  if combobox1.Items.Count > 0 then
  for i := 0 to combobox1.Items.Count - 1 do
  begin
    ns := combobox1.Items.Objects[i] as tElemHolder;
    name := getIdeasName(ns.element,rep);
    if name = '' then memo2.Lines.Add('No IDEAS Name for: ' + ns.name)
    else
    begin
      memo1.Lines.Add('--Processing: ' + name);
      myThing := iSess.getObjectByIdeasName(name);
      if myThing <> nil then
      begin
        memo1.Lines.Add('--Found: ' + name);
        if (myThing.foundationTypeName = 'NamingScheme') or (myThing.foundationTypeName = 'UniqueNamingScheme') then
        begin
          ns.thing := myThing;
        end else memo2.Lines.Add('ERROR - ' + ns.name + ' already found, but is not a NamingScheme');
      end
      else
      begin
        memo1.Lines.Add('--Creating new NamingScheme: ' + name);
        if ns.st = 'IDEAS:UniqueNamingScheme' then ns.thing := tIdeasDbUniqueNamingScheme.create(iSess,name)
          else ns.thing := tIdeasDbNamingScheme.create(iSess,name);
      end;
      if i = combobox1.ItemIndex then rootNS := ns.thing as tIdeasDbNamingScheme;
    end;
  end;
  memo1.Lines.Add('-----------------------------------');

  //first pass through elements
  allElements := tStringList.Create;
  allElements.Sorted := true;
  elementsByName := tStringList.Create;
  elementsByName.Sorted := true;
  disambiguateList := tStringList.Create;
  disambiguateList.Sorted := true;
  memo1.Lines.Add('First Pass - adding Things and their names');
  getElementsInPackage(selPackage,allElements,'',rep, true, errors,self);
  if allElements.Count > 0 then
  for i := 0 to allElements.Count - 1 do
  begin
    myHolder := allElements.Objects[i] as tElemHolder;
    myHolder.st := stringreplace(myHolder.st,'IDEAS:','',[rfReplaceAll]);
    memo1.Lines.Add('--' + myHolder.guid);
    elementsByName.AddObject(myHolder.name,myHolder);
    myThing := nil;
    testThing := nil;
    if myHolder.element.Attributes.Count < 1 then
    begin
      if rootNS <> nil then setDefaultNameForElement(myHolder.element,rep);  //no attributes on this element, so add its name(s)
    end;

    elementNames := getNames(rep,myHolder.element,combobox1.Items,errors);
    if elementNames.Count > 0 then
    for j := 0 to elementNames.Count - 1 do
    begin
      nsHolder := combobox1.Items.objects[j] as tElemHolder;
      myNs := nsHolder.thing as tIdeasDbNamingScheme;
      if elementNames[j] <> '' then
      begin
        memo1.Lines.Add('  --NAME::' + combobox1.Items[j] + '="' + elementNames[j] + '"');
        if myNs.foundationTypeName = 'UniqueNamingScheme' then
        begin
          //got a unique naming scheme
          testThings := iSess.getObjectsByNameAndNamingScheme(elementNames[j],myNS);
          //is there anything in the db with that unique name ?
          if testThings.Count > 0 then
          begin
            if testThings.Count > 1 then memo2.Lines.Add('ERROR: more than one element with name "' + elementNames[j] + 'in NamingScheme: ' + combobox1.Items[j])
            else
            begin
              //got one thing that matches - let's assume that's our baby !
              if myThing = nil then myTHing := testThings[0]
              else if testTHing = nil then
              begin
                //is this the same thing we got last time ?
                testThing := testThings[0];
                if testThing.id <> myThing.id then memo2.Lines.Add('ERROR: more than one element with name"' + elementNames[j] + 'in NamingScheme: ' + combobox1.Items[j]);
                testThing := nil;
              end;
            end;
          end;
        end;
      end;
    end;

{    for j := 0 to (myHolder.element.Attributes.Count - 1) do
    begin
      myAttr := myHolder.element.Attributes.GetAt(j) as iDualAttribute;
      memo1.Lines.Add('  --NAME::' + myAttr.Name + '="' + myAttr.Default + '"');
      if combobox1.Items.IndexOf(myAttr.name) > -1 then
      begin
        nsHolder := combobox1.Items.objects[combobox1.Items.IndexOf(myAttr.name)] as tElemHolder;
        myNs := nsHolder.thing as tIdeasDbNamingScheme;
        if myNs.foundationTypeName = 'UniqueNamingScheme' then
        begin
          //got a unique naming scheme
          testThings := iSess.getObjectsByNameAndNamingScheme(myAttr.Default,myNS);
          //is there anything in the db with that unique name ?
          if testThings.Count > 0 then
          begin
            if testThings.Count > 1 then memo2.Lines.Add('ERROR: more than one element with name "' + myAttr.Default + 'in NamingScheme: ' + myAttr.name)
            else
            begin
              //got one thing that matches - let's assume that's our baby !
              if myThing = nil then myTHing := testThings[0]
              else if testTHing = nil then
              begin
                //is this the same thing we got last time ?
                testThing := testThings[0];
                if testThing.id <> myThing.id then memo2.Lines.Add('ERROR: more than one element with name"' + myAttr.Default + 'in NamingScheme: ' + myAttr.name);
                testThing := nil;
              end;
            end;
          end;
        end;
      end;
    end;}

    if myThing = nil then
    begin
      memo1.Lines.Add('  --Item not found in database, adding it now');
      myThing := createTHing(myHolder,nil);
    end;
    myHolder.thing := myThing;

    memo1.Lines.Add('  --adding ' + vartostr(myHolder.element.Attributes.Count) + ' names');
    if elementNames.Count > 0 then
    for j := 0 to elementNames.Count - 1 do
    begin
      nsHolder := combobox1.Items.objects[j] as tElemHolder;
      myNs := nsHolder.thing as tIdeasDbNamingScheme;
      if elementNames[j] <> '' then
      begin
        myTHing.addName(elementNames[j],myNS);
      end
    end;


  {  if myHolder.element.Attributes.Count > 0 then
    for j := 0 to (myHolder.element.Attributes.Count - 1) do
    begin
      myAttr := myHolder.element.Attributes.GetAt(j) as iDualAttribute;
      if combobox1.Items.IndexOf(myAttr.name) > -1 then
      begin
        nsHolder := combobox1.Items.objects[combobox1.Items.IndexOf(myAttr.name)] as tElemHolder;
        myNs := nsHolder.thing as tIdeasDbNamingScheme;
        myTHing.addName(myAttr.Default,myNS);
      end;
    end; }
  end;

  memo1.Lines.Add('Second Pass - adding foundation categories and tuples');
  if elementsByName.Count > 0 then
  for i := 0 to elementsByName.Count - 1 do
  begin
    myHolder := elementsByName.Objects[i] as tElemHolder;
    myThing := myHolder.thing;
    memo1.Lines.Add('--' + myHolder.name);
    connections := myHolder.element.Connectors;
    if connections.Count > 0 then
    for j := 0 to connections.Count - 1 do
    begin
      myConnector := connections.GetAt(j) as iDualConnector;
      connected := rep.GetElementByID(myConnector.SupplierID);
    // memo4.Lines.Add('--' + myConnector.Stereotype + ' ID: ' + vartostr(myConnector.ConnectorID) + ' SupplierID ' + vartostr(myConnector.SupplierID) + ' ClientID ' + vartostr(myConnector.ClientID));
      if (myConnector.ClientID = myHolder.id) then
      begin
        connectedNSName := getDefaultNamingSchemeNameForElement(connected,rep);
        connectedNS := iSess.getObjectByIdeasName(connectedNSName) as tIdeasDbNamingScheme;
        relatedHolder := nil;
        if connectedNS <> nil then
        begin
          relatedThings := iSess.getObjectsByNameAndNamingScheme(connected.Name,connectedNS);
          if relatedThings.count > 0 then
          begin
            if relatedThings.Count > 1 then memo3.Lines.Add('More than element in DB called "' + connected.Name + '"')
            else
            begin
              relatedHolder := tElemHolder.Create(rep,connected);
              relatedHolder.thing := relatedThings.things[0];
              if relatedHolder.thing <> nil then memo1.lines.Add('' + connected.Name + '[id=' + relatedHolder.thing.idStr + '] found in DB relating ' + myHolder.name + '[id=' + myHolder.thing.idStr + '] to it') else relatedHolder := nil;
            end;
          end
          else
          begin
            memo2.Lines.Add('Cannot find related element from ' + myHolder.Element.name + ' via ' + stringreplace(myConnector.Stereotype,'IDEAS:','',[rfReplaceAll]));
          end;
        end;
        if relatedHolder <> nil then
        begin
          if (myConnector.type_ = 'Aggregation') or (myConnector.type_ = 'Generalization') or (myConnector.type_ = 'Dependency') then createCouple(stringreplace(myConnector.Stereotype,'IDEAS:','',[rfReplaceAll]),relatedHolder,myHolder);
        end else memo3.lines.Add('Cannot find target for ' + stringreplace(myConnector.Stereotype,'IDEAS:','',[rfReplaceAll]) + ' from ' + myHolder.element.Name);
      end;
    end;
  end;



  button2.Enabled := false;
  screen.Cursor := crDefault;
  if memo2.Lines.Count > 0 then tabbednotebook1.PageIndex := 1;

  //close;
end;

procedure TForm5.Button4Click(Sender: TObject);
begin
  close;
end;

function TForm5.CompactAndRepair(DB: string): Boolean; {DB = Path to Access Database}
var
  v: OLEvariant;
begin
  Result := True;
  try
    v := CreateOLEObject('JRO.JetEngine');
    try
      V.CompactDatabase('Provider=Microsoft.Jet.OLEDB.4.0;Jet OLEDB:Database Password=m0nKey74t3nN1S;Data Source='+DB,
                        'Provider=Microsoft.Jet.OLEDB.4.0;Jet OLEDB:Database Password=m0nKey74t3nN1S;Data Source='+DB+'x;Jet OLEDB:Engine Type=5');
      DeleteFile(DB);
      RenameFile(DB+'x',DB);
    finally
      V := Unassigned;
    end;
  except
    Result := False;
  end;
end;


end.
