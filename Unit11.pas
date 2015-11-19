unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EA_Ideas_Lib, EA_TLB, StdCtrls, ComCtrls;

type
  TForm11 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Edit2: TEdit;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    rep : iDualRepository;
    package, parentPackage : iDualPackage;
    oldNS : string;
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

procedure TForm11.Button1Click(Sender: TObject);
var
  myDiag : iDualDiagram;
  elements, nsList, names : tStringList;
  errors : tStrings;
  sxStr : wideString;
  oldNS, newNS, newName : string;
  i : integer;
  myElem : tElemHolder;
  namesPackage : iDualPackage;
  namesDiag : iDualDiagram;
  nameDo : iDualDiagramObject;
  ns : iDualElement;
begin
  errors := memo1.Lines;

  if edit1.Text = '' then showmessage('No name specified')
  else
  if ((combobox1.Text = '') and (radiobutton1.Checked)) or ((edit3.Text = '') and (radiobutton2.Checked)) then showmessage('No NamingScheme specified')
  else
  begin
    if package = nil then
    begin
      package := parentPackage.packages.AddNew(edit1.Text,'Nothing') as iDualPackage;
      package.Update;
      myDiag := package.Diagrams.AddNew(edit1.Text,'Diagram') as iDualDiagram;
      myDiag.Update;
      sxStr := 'ExcludeRTF=0;DocAll=0;HideQuals=0;AttPkg=1;ShowTests=0;ShowMaint=0;SuppressFOC=1;MatrixActive=0;SwimlanesActive=1;MatrixLineWidth=1;MatrixLocked=0;TConnectorNotation=UML 2.1;TExplicitNavigability=0;AdvancedElementProps=1;AdvancedFeatureProps=1;';
      sxStr := sxStr + 'AdvancedConnectorProps=1;ProfileData=;STBLDgm=;ShowNotes=0;VisibleAttributeDetail=0;ShowOpRetType=1;SuppressBrackets=0;SuppConnectorLabels=0;PrintPageHeadFoot=0;ShowAsList=0;';
      sxStr := sxStr + 'MDGDgm=IDEAS::IDEAS;';
      myDiag.StyleEx := sxStr;
      myDiag.Update;
    end;
    if edit2.Text <> '' then setTaggedValue(package.Element,'baseURL',edit2.Text);
    package.Element.StereotypeEx := 'IDEAS:Model';
    package.Update;
    oldNS := getTaggedValue(package.Element,'defaultNamingScheme');
    package.Name := edit1.Text;
    if radiobutton1.Checked then newNS := combobox1.Text else newNS := edit3.Text;
    setTaggedValue(package.Element,'defaultNamingScheme',newNS);
    package.Element.Update;
    package.Update;
    if radiobutton2.Checked then
    begin
      namesPackage := package.Packages.AddNew('Namespace','Nothing') as iDualPackage;
      namesPackage.Update;
      namesDiag := createIdeasDiag(rep,'Namespace',namesPackage);
      namesDiag.Update;
      ns := createNamingScheme(rep,edit3.Text,namesPackage,'',namesDiag,nameDo,'',checkbox1.checked);
      setThingName(ns,edit3.Text,'IDEASName');
    end;
    if newNS <> oldNS then
    begin
      nsList := tstringlist.Create;
      nsList.Add(combobox1.Text);
      Memo1.Lines.Add('Updating Names');
      elements := tStringList.Create;
      getElementsInPackage(package,elements,'',rep,true,errors,self);
      if elements.Count > 0 then
      for i := 0 to elements.Count - 1 do
      begin
        myElem := elements.Objects[i] as tElemHolder;
        Memo1.Lines.Add('Updating ' + myElem.name);
        refresh;
        if oldNS <> '' then setThingName(myElem.element,myElem.name,oldNS)
        else
        begin
          names := getNames(rep,myElem.element,nsList,nil);
          if names[0] = '' then setThingName(myElem.element,myElem.name,newNS) else setThingName(myElem.element,names[0],newNS);

        end;

      end;
    end;
  end;
  RadioButton2.visible := true;
  edit3.visible := true;
  close;
end;

procedure TForm11.Button2Click(Sender: TObject);
begin
  RadioButton2.visible := true;
  edit3.visible := true;
  close;
end;

procedure TForm11.ComboBox1CloseUp(Sender: TObject);
begin
  if combobox1.ItemIndex > -1 then
  begin
    radiobutton1.checked := true;
    radiobutton2.checked := false;
  end;
end;

procedure TForm11.Edit3Click(Sender: TObject);
begin
  radiobutton2.checked := true;
  radiobutton1.checked := false;
end;

procedure TForm11.RadioButton1Click(Sender: TObject);
begin
  radiobutton2.Checked := not radiobutton1.Checked;
  if radiobutton1.Checked then combobox1.Enabled := true else combobox1.Enabled := false;

end;

procedure TForm11.RadioButton2Click(Sender: TObject);
begin
  radiobutton1.Checked := not radiobutton2.Checked;
  if radiobutton2.Checked then
  begin
    edit3.Enabled := true;
    if (edit1.Text <> '') and (edit3.Text = '') then edit3.Text := stringreplace(edit1.Text + 'Names',' ','',[rfReplaceAll]);

  end else edit3.Enabled := false;
end;

end.
