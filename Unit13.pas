unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EA_TLB, EA_Ideas_Lib, StdCtrls, unit3;

type
  TForm13 = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    SaveDialog1: TSaveDialog;
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    rep : iDualRepository;
    package : iDualPackage;
  end;

var
  Form13: TForm13;

implementation

{$R *.dfm}

procedure TForm13.Button1Click(Sender: TObject);
var
  xml, names, supers : tStringList;
  myElem, myType, place1, place2 : iDualElement;
  myConn : iDualConnector;
  i,j : integer;
  fcat, typeName, xmlLine, p1Name, p2Name, defaultNS, st : string;
  isTuple, isTupleType : boolean;
begin
  names := tStringList.Create;
  xml := tStringList.Create;
  defaultNS := getTaggedValue(package.Element,'defaultNamingScheme');
  xml.Add('<?xml version="1.0" encoding="UTF-8"?>');
  xmlLine := '  <IdeasData XMLTagsBoundToNamingScheme="' + combobox1.text + '" Model="' + edit1.text + '"';
  if (defaultNS <> '') then
  begin
    if (combobox1.Items.IndexOf(defaultNS) < 0) then combobox1.Items.Add(defaultNS);

    xmlLine := xmlLine + ' defaultNamingScheme="NS' + vartostr(combobox1.Items.IndexOf(defaultNS)) + '"';
  end;

  xml.Add(xmlLine + '>');
  for i := 0 to combobox1.items.Count - 1 do
  begin
    xml.Add('    <NamingScheme id="NS' + vartostr(i) + '" ideas:FoundationCategory="NamingScheme" ideas:IdeasName="' + combobox1.Items[i] + '"/>' )
  end;
  xml.Add('');
  xml.Add('');
  if package.Elements.Count > 0 then
  for i := 0 to package.Elements.Count - 1 do
  begin
    myElem := package.Elements.GetAt(i) as iDualElement;
    st := myElem.Stereotype;
    if pos('IDEAS:',st) = 1 then
    begin
      myType := nil;
      p1Name := '';
      p2Name := '';
      place1 := nil;
      place2 := nil;
      isTuple := false;
      isTupleType := false;
      if myElem.Connectors.Count > 0 then
      for j := 0 to myElem.Connectors.Count - 1 do
      begin
        myConn := myElem.Connectors.GetAt(j) as iDualConnector;
        if myConn.ClientID = myElem.ElementID then
        begin
          if myConn.Stereotype = 'IDEAS:typeInstance' then
          begin
            if myType <> nil then showMessage(myElem.Name + ' appears to be an instance of more than one Type. PES does not support multiple classification');
           myType := rep.GetElementByID(myConn.supplierID);
          end;
          if (myConn.Stereotype = 'place1Type') or (myConn.Stereotype = 'tuplePlace1') then
          begin
            if place1 <> nil then showMessage(myElem.Name + ' appears to have more than one tuplePlace1 or place1Type');
            place1 := rep.GetElementByID(myConn.supplierID);
            p1Name := myConn.Name;
          end;
          if (myConn.Stereotype = 'place2Type') or (myConn.Stereotype = 'tuplePlace2') then
          begin
            if place2 <> nil then showMessage(myElem.Name + ' appears to have more than one tuplePlace2 or place2Type');
            place2 := rep.GetElementByID(myConn.supplierID);
            p2Name := myConn.Name;
          end;
        end;
      end;
      if myType <> nil then
      begin
        supers := tStringList.Create;
        fcat := stringReplace(getFoundationCategory(rep,myType,supers,nil),'ideas:','',[rfReplaceAll]);
        if supers.IndexOf('tuple') > -1 then isTuple := true;
        if supers.IndexOf('TupleType') > -1 then isTupleType := true;

        names := getNames(rep,myType,combobox1.Items,nil);
        typeName := names[combobox1.ItemIndex];
        xmlLine := '    <' + edit2.text + typeName + ' id="ID' + vartostr(myElem.ElementID) + '" ideas:FoundationCategory="' + fcat + '"';
        if defaultNS <> '' then xmlLine := xmlLine + ' ideas:defaultName="' + myElem.Name + '"';

        if isTuple then
        begin
          if place1 <> nil then xmlLine := xmlLine + ' tuplePlace1="ID' + vartostr(place1.ElementID) + '"' else showmessage('ERROR: ' + myElem.Name + ' has no place1 set');
          if place2 <> nil then xmlLine := xmlLine + ' tuplePlace2="ID' + vartostr(place2.ElementID) + '"' else showmessage('ERROR: ' + myElem.Name + ' has no place2 set');
        end;
        if isTupleType then
        begin
          if place1 <> nil then xmlLine := xmlLine + ' place1Type="ID' + vartostr(place1.ElementID) + '"' else showmessage('ERROR: ' + myElem.Name + ' has no place1Type set');
          if place2 <> nil then xmlLine := xmlLine + ' place2Type="ID' + vartostr(place2.ElementID) + '"' else showmessage('ERROR: ' + myElem.Name + ' has no place2Type set');
          if p1Name <> '' then xmlLine := xmlLine + ' place1Name="' + p1Name + '"';
          if p2Name <> '' then xmlLine := xmlLine + ' place2Name="' + p2Name + '"';
        end;
        xmlLine := xmlLine + '>';
        xml.Add(xmlLine);
        freeAndNil(names);
        names := getNames(rep,myElem,combobox1.Items,nil);
        if names.Count > 0 then
        for j := 0 to names.Count - 1 do
        begin
          if (names[j] <> '') and (combobox1.Items[j] <> defaultNS) then xml.Add('      <ideas:Name id="ID' + vartostr(myElem.ElementID) + 'Name' + vartostr(j) + '" namingScheme="NS' + vartostr(j) + '" exemplarText="' +  names[j] + '"/>');
        end;


        xml.Add('    </' + edit2.text + typeName + '>');
        xml.Add('');
      end else showmessage('Could not find a Type for ' + myElem.Name + ' - unable to export as XML');
    end;
  end;
  xml.Add('  </IdeasData>');
  saveDialog1.Title := 'Save PES File';
  if saveDialog1.Execute then xml.SaveToFile(saveDialog1.FileName);
  memo1.Lines.Add('Done!');
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm13.ComboBox1Change(Sender: TObject);
begin
  if combobox1.Text <> '' then button1.Enabled := true else button1.Enabled := false;

end;

end.
