unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EA_TLB, EA_Ideas_Lib;

type
  TForm14 = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    CheckBox2: TCheckBox;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    CheckBox3: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    rep : iDualRepository;
    elem : iDualElement;
    supertypes : tStringList;
    diagram : iDualDiagram;
    diagObj : iDualDiagramObject;
    { Public declarations }
  end;

var
  Form14: TForm14;

implementation

{$R *.dfm}

procedure TForm14.Button1Click(Sender: TObject);
var
  part,state,wp,wap,ws, super, partType,stateType,wpType,wapType,wsType : iDualElement;
  sst, pti : iDualConnector;
  myDO : iDualDiagramObject;
  l,r,t,b, tl, tr : string;
  holder : tElemHolder;
  elements : iDualCollection;
  ptDiag : iDualDiagram;
  package, ptPackage : iDualPackage;
begin
  l := vartostr(diagObj.left);
  r := vartostr(diagObj.right);
  tl := vartostr(diagObj.right + 200);
  tr := vartostr(diagObj.right + 350);
  t := vartostr(diagObj.top + 280);
  b := vartostr(diagObj.top + 240);
  package := rep.GetPackageByID(elem.PackageID);
  try
    ptPackage := package.Packages.GetByName(package.name + ' Powertypes') as iDualPackage;
  finally

  end;
  if ptPackage = nil then ptPackage := package.Packages.AddNew(package.name + ' Powertypes','Package') as iDualPackage;

  if checkbox3.Checked then
  begin
    ptDiag := createIdeasDiag(rep,elem.Name + ' Powertypes',ptPackage);
  end;
  if checkbox1.Checked then
  begin  //createPart
    part := createIndividualType(rep,edit1.Text, package,'',diagram,myDO,'l=' + l + ';r=' + r + ';t=' + t + ';b=' + b + ';');
    if checkbox3.Checked then  // Part powertype
    begin
      partType := createPowertype(rep,edit1.Text + 'Type', ptPackage,'The powertype of ' + edit1.text,ptDiag,myDO,'l=' + l + ';r=' + r + ';t=' + t + ';b=' + b + ';');
      pti := createPTI(rep,part,partType);
    end;
    if supertypes.Count = 1 then   //find the supertype Part and create the SST
    begin
      holder := supertypes.Objects[0] as tElemHolder;
      elements := rep.GetElementsByQuery('findName',holder.name + 'Part');
      if elements.Count = 1 then
      begin
        super := elements.GetAt(0) as iDualElement;
        sst := createSST(rep,part,super);
      end;
      if checkbox3.checked then    // Part powertype supertype
      begin
        elements := rep.GetElementsByQuery('findName',dropFirstLetterCase(holder.name) + 'Type');
        if elements.Count = 1 then
        begin
          super := elements.GetAt(0) as iDualElement;
          sst := createSST(rep,partType,super);
        end;
      end;
    end;
    if checkbox4.Checked then
    begin
      wp := createTupleType(rep,edit4.Text, package,'',diagram,myDO,'l=' + tl + ';r=' + tr + ';t=' + t + ';b=' + b + ';',elem,part,nil,nil,nil,'whole','part','','','');
      if checkbox3.Checked then
      begin
        wpType := createPowertype(rep,edit4.Text + 'Type', ptPackage,'The powertype of ' + edit4.text,ptDiag,myDO,'l=' + l + ';r=' + r + ';t=' + t + ';b=' + b + ';');
        pti := createPTI(rep,wp,wpType);
      end;
      if supertypes.Count = 1 then
      begin
        holder := supertypes.Objects[0] as tElemHolder;
        elements := rep.GetElementsByQuery('findName',dropFirstLetterCase(holder.name) + 'WholePart');
        if elements.Count = 1 then
        begin
          super := elements.GetAt(0) as iDualElement;
          sst := createSST(rep,wp,super);
        end;
        if checkbox3.checked then
        begin
          elements := rep.GetElementsByQuery('findName',dropFirstLetterCase(holder.name) + 'WholePartType');
          if elements.Count = 1 then
          begin
            super := elements.GetAt(0) as iDualElement;
            sst := createSST(rep,wpType,super);
          end;
        end;
      end;
    end;
  end; //create part
  if checkbox2.Checked then
  begin //create state
    t := vartostr(diagObj.top + 140);
    b := vartostr(diagObj.top + 100);
    state := createIndividualType(rep,edit2.Text, package,'',diagram,myDO,'l=' + l + ';r=' + r + ';t=' + t + ';b=' + b + ';');
    if supertypes.Count = 1 then
    begin
      holder := supertypes.Objects[0] as tElemHolder;
      elements := rep.GetElementsByQuery('findName',holder.name + 'State');
      if elements.Count = 1 then
      begin
        super := elements.GetAt(0) as iDualElement;
        sst := createSST(rep,state,super);
      end;
    end;
    if checkbox3.Checked then  // Part powertype
    begin
      stateType := createPowertype(rep,edit2.Text + 'Type', ptPackage,'The powertype of ' + edit2.text,ptDiag,myDO,'l=' + l + ';r=' + r + ';t=' + t + ';b=' + b + ';');
      pti := createPTI(rep,state,stateType);
    end;
    if checkbox6.Checked then
    begin
      ws := createTupleType(rep,edit6.Text, package,'',diagram,myDO,'l=' + tl + ';r=' + tr + ';t=' + t + ';b=' + b + ';',elem,state,nil,nil,nil,'whole','state','','','');
      if supertypes.Count = 1 then
      begin
        holder := supertypes.Objects[0] as tElemHolder;
        elements := rep.GetElementsByQuery('findName',dropFirstLetterCase(holder.name) + 'WholeState');
        if elements.Count = 1 then
        begin
          super := elements.GetAt(0) as iDualElement;
          sst := createSST(rep,ws,super);
        end;
      end;
    end;
    if checkbox1.Checked then
    begin
  //    memo1.lines.add('create sst from part to state');
      sst := createSST(rep,state,part);
      if checkbox4.Checked and checkbox6.Checked then
      begin
 //     memo1.lines.add('//create sst from wp to ws');
      sst := createSST(rep,ws,wp);
      end;
    end;
  end;  //create State
  if checkbox5.Checked then
  begin
    t := vartostr(diagObj.top);
    b := vartostr(diagObj.bottom);
    wap := createTupleType(rep,edit5.Text, package,'desc',diagram,myDO,'l=' + tl + ';r=' + tr + ';t=' + t + ';b=' + b + ';',elem,elem,nil,nil,nil,'whole','part','','','');
    if supertypes.Count = 1 then
    begin
      holder := supertypes.Objects[0] as tElemHolder;
      elements := rep.GetElementsByQuery('findName',dropFirstLetterCase(holder.name) + 'WholeAndPart');
      if elements.Count = 1 then
      begin
        super := elements.GetAt(0) as iDualElement;
        sst := createSST(rep,wap,super);
      end;
    end;
    if checkbox2.checked AND checkbox6.checked then
    begin
  //    memo1.lines.add('//create sst from wap to ws');
      sst := createSST(rep,wap,ws);
    end
    else
    if checkbox1.checked AND checkbox4.checked then
    begin
 //     memo1.lines.add('//create sst from wap to wp');
      sst := createSST(rep,wap,wp);
    end

  end;
  rep.ReloadDiagram(diagram.DiagramID);
  close;
end;

procedure TForm14.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm14.CheckBox1Click(Sender: TObject);
begin
 if checkbox1.Checked then edit1.Enabled := true else
 begin
   edit1.Enabled := false;
   checkbox4.Checked := false;
   edit4.Enabled := false;
 end;
end;

procedure TForm14.CheckBox2Click(Sender: TObject);
begin
 if checkbox2.Checked then edit2.Enabled := true else
 begin
   edit2.Enabled := false;
   checkbox6.Checked := false;
   edit6.Enabled := false;
 end;
end;

procedure TForm14.CheckBox4Click(Sender: TObject);
begin
 if checkbox4.Checked then edit4.Enabled := true else edit4.Enabled := false;
end;

procedure TForm14.CheckBox5Click(Sender: TObject);
begin
 if checkbox5.Checked then edit5.Enabled := true else edit5.Enabled := false;
end;

procedure TForm14.CheckBox6Click(Sender: TObject);
begin
 if checkbox6.Checked then edit6.Enabled := true else edit6.Enabled := false;
end;

end.
