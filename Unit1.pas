unit Unit1;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, windows, StdCtrls, IdeasAddIn_TLB, StdVcl, DiagnosticsForm, Dialogs, SysUtils,
  strUtils, IdHTTP, owl_lib, Classes, EA_TLB, unit2, unit3, unit4, IdeasLib, NewElemForm, unit9, unit10,
  unit11, unit12, unit13, unit14, EA_Ideas_Lib, unit16, SkosFormUnit;


type
  TAddin = class(TAutoObject, IAddin)
  protected
    function IAddin.EA_Connect = EA_Connect;
    function EA_Connect(const Repository: IDispatch): WideString; safecall;

    procedure EA_Disconnect; safecall;

    procedure IAddin.EA_GetMenuState = EA_GetMenuState;
    procedure EA_GetMenuState(const Repository: IDispatch; const Location,
      MenuName, ItemName: WideString; var IsEnabled, IsChecked: WordBool);
      safecall;

    function IAddin.EA_GetMenuItems = EA_GetMenuItems;
    function EA_GetMenuItems(const Repository: IDispatch; const Location,
      MenuName: WideString): OleVariant; safecall;

    procedure IAddin.EA_MenuClick = EA_MenuClick;
    procedure EA_MenuClick(const Repository: IDispatch; const Location,
      MenuName, ItemName: WideString); safecall;

    procedure IAddin.EA_ShowHelp = EA_ShowHelp;
    procedure EA_ShowHelp(const Repository: IDispatch; const Location,
      MenuName, ItemName: WideString); safecall;

    procedure createDBClassesForPackage(package : olevariant; session : tIdeasDbSession; connectors : tStringList; recurse : boolean);
    procedure createRDFClassesForPackage(package : olevariant; session : tIdeasSession; connectors : tStringList; recurse : boolean);
    procedure EA_OnContextItemChanged(const Repository: IDispatch; const GUID: WideString; ot: OleVariant); safecall;
    procedure exportRDF; safecall;
    procedure exportMySqlScript; safecall;
    procedure populateDB; safecall;
    procedure diagsToIdeas; safecall;
    procedure addGUIDs; safecall;
    function CompactAndRepair(DB: string): Boolean;
    procedure individualType; safecall;
    procedure setElementStereotype(element : oleVariant; stereotype : string; recurseSubtypes : boolean);
    procedure IAddIn.addGUIDs = IAddIn_addGUIDs;
    procedure IAddIn_addGUIDs; safecall;
    procedure setFoundationStuff(element : oleVariant; stereotype : string);
    procedure EA_FileOpen(const Repository: IDispatch); safecall;
    procedure exportOracle; safecall;
    procedure exportXSD; safecall;
    procedure exportAccess(newDB : boolean); safecall;
   // procedure getElementsInPackage(package : iDualPackage; var elements : tStringList);
    procedure exportExcel(package : iDualPackage); safecall;
    function EA_OnPostNewConnector(const Repository, Info: IDispatch): WordBool; safecall;

    function EA_OnPostNewElement(const Repository, Info: IDispatch): WordBool; safecall;
    procedure setElementDefaultStyle(element: IDualElement);
    procedure setSmallest;
    procedure MoveSelectedToDiagPackage;
    function EA_OnContextItemDoubleClicked(const Repository: IDispatch; const GUID: WideString;
          ot: OleVariant): WordBool; stdcall;
    function EA_OnPreNewElement(const Repository, Info: IDispatch): WordBool; safecall;

   // procedure importMIP;


    {DB = Path to Access Database}
  end;

implementation

uses ComServ,variants, unit5;

var
	Rep: IDualRepository;
	m_IsEnabled: boolean;
  m_Control: IIdeasForm;
  saveDialog1 : tSaveDialog;
  openDialog1 : tOpenDialog;
  reservedNames : tStringList;
  form2 : tForm2;
  //ideasDB : tIdeasDatabase;
  ControlInt : IUnknown;
  baseURL : string;
  selPackGUID : string;
  oXL, oWB, oSheet, oRng, VArray : oleVariant;
  ideasFoundation : iDualPackage;
  IdHTTP1: TIdHTTP;

const debug : boolean = true;

const build : integer = 24;

const IID_IDualRepository: TGUID = '{4CD2CE1E-C301-4C16-9CA2-5A7EC4478C55}';  // These two entries manually created, numbers copied from _TLB.pas files


function TAddin.EA_Connect(const Repository: IDispatch): WideString;
var
  searchStr : string;
  buttonSelected : integer;
  newVer, code : integer;
begin
  Repository.QueryInterface(IID_IDualRepository,Rep);
  searchStr := '<RootSearch><Search Name="GetByType" GUID="{23003D18-855B-4aaa-8402-50306835164F}" PkgGUID="-1" Type="0" LnksToObj="0" CustomSearch="0" AddinAndMethodName=""><SrchOn><RootTable Type="0"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="" Hierarchy="t_object"/><Field Filter="t_object.Object_Type = ''&lt;Search Term&gt;''" Text="&lt;Search Term&gt;" IsDateField="0" Type="1" Required="1" Active="1"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="Element" Hierarchy="t_object"/><Condition Display="Equal To" Type="="/><FieldName Display="ObjectType" Name="t_object.Object_Type"/></Field></RootTable></SrchOn><LnksTo/></Search></RootSearch>';
  rep.AddDefinedSearches(searchStr);
  searchStr := '<RootSearch><Search Name="findName" GUID="{675546CF-30CA-4c3a-9465-BDA2777D94E0}" PkgGUID="-1" Type="0" LnksToObj="0" CustomSearch="0" AddinAndMethodName=""><SrchOn><RootTable Type="0"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="" Hierarchy="t_object"/><Field Filter="t_object.Name = ''&lt;Search Term&gt;''" Text="&lt;Search Term&gt;" IsDateField="0" Type="1" Required="1" Active="1"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="Element" Hierarchy="t_object"/><Condition Display="Equal To" Type="="/><FieldName Display="Name" Name="t_object.Name"/></Field></RootTable></SrchOn><LnksTo/></Search></RootSearch>';
  rep.AddDefinedSearches(searchStr);
  searchStr := '<RootSearch><Search Name="likeName" GUID="{675546CF-30CA-4c3a-9465-BDB2777D94E0}" PkgGUID="-1" Type="0" LnksToObj="0" CustomSearch="0" AddinAndMethodName=""><SrchOn><RootTable Type="0"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="" Hierarchy="t_object"/><Field Filter="t_object.Name like ''&lt;Search Term&gt;''" Text="&lt;Search Term&gt;" IsDateField="0" Type="1" Required="1" Active="1"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="Element" Hierarchy="t_object"/><Condition Display="Contains" Type="like"/><FieldName Display="Name" Name="t_object.Name"/></Field></RootTable></SrchOn><LnksTo/></Search></RootSearch>';
  rep.AddDefinedSearches(searchStr);
  searchStr := '<RootSearch><Search Name="findByST" GUID="{675546CF-30CA-4f3a-9465-BDA2777D94E3}" PkgGUID="-1" Type="0" LnksToObj="0" CustomSearch="0" AddinAndMethodName=""><SrchOn><RootTable Type="0"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="" Hierarchy="t_object"/><Field Filter="t_object.Name = ''&lt;Search Term&gt;''" Text="&lt;Search Term&gt;" IsDateField="0" Type="1" Required="1" Active="1"><TableName Display="Element" Name="t_object"/>';
  searchStr := searchStr + '<TableHierarchy Display="Element" Hierarchy="t_object"/><Condition Display="Equal To" Type="="/><FieldName Display="Stereotype" Name="t_object.Stereotype"/></Field></RootTable></SrchOn><LnksTo/></Search></RootSearch>';
  rep.AddDefinedSearches(searchStr);
  searchStr := '<RootSearch><Search Name="GetDiagsByName" GUID="{9F1E45D0-2308-4a53-946B-C79C627CA315}" PkgGUID="-1" Type="0" LnksToObj="0" CustomSearch="0" AddinAndMethodName=""><SrchOn><RootTable Type="0"><TableName Display="Diagram" Name="t_diagram"/>';
  searchStr := searchStr + '<TableHierarchy Display="" Hierarchy="t_diagram"/><Field Filter="t_diagram.Name Like ''*&lt;Search Term&gt;*''" Text="&lt;Search Term&gt;" IsDateField="0" Type="1" Required="0" Active="1"><TableName Display="Diagram" Name="t_diagram"/>';
  searchStr := searchStr + '<TableHierarchy Display="Diagram" Hierarchy="t_diagram"/><Condition Display="Contains" Type="Like"/><FieldName Display="Name" Name="t_diagram.Name"/></Field></RootTable></SrchOn><LnksTo/></Search></RootSearch>';
  rep.AddDefinedSearches(searchStr);
	m_IsEnabled := false;
  try
    if idhttp1 = nil then idhttp1 := tIdHttp.Create(nil);
    val(idhttp1.Get('http://modelfutures.com/eaIdeasVersion.txt'),newVer,code);
    if (code=0) and (newVer > build) then
    begin
  //  buttonSelected := MessageDlg('A new version of the Model Futures IDEAS AddIn is available, do you want to download it ?',mtCustom,[mbYes,mbNo], 0);
    showmessage('A new version of the Model Futures IDEAS AddIn is available - www.modelfutures.com/software. Remember to exit EA before installing');
//  if buttonSelected = mrYes    then ShowMessage('Yes pressed');
//  if buttonSelected = mrAll    then ShowMessage('All pressed');
//  if buttonSelected = mrCancel then ShowMessage('Cancel pressed');
    end;
  except

  end;

  if form4 = nil then form4 := tForm4.create(nil);
  form4.Label1.Caption := vartostr(build);
  form4.show;
  if form9 = nil then form9 := tForm9.Create(nil);

  rep.SuppressEADialogs := true;
end;

function TAddin.EA_GetMenuItems(const Repository: IDispatch; const Location,
  MenuName: WideString): OleVariant;
var
	Menu: Variant;
  selected : iDispatch;
  selVar : oleVariant;
  selDiag : iDualDiagram;
  myDO : iDualDiagramObject;
  myElem : iDualElement;
begin
 	if MenuName = '' then Result := '-&IDEAS'
  else
  begin
    if Location = 'Diagram' then
    begin
      selDiag := rep.GetCurrentDiagram;
      if MenuName = '-&IDEAS' then
      begin
        if selDiag.SelectedObjects.Count > 0 then
        begin
  	      Menu := VarArrayCreate([0,4],varOleStr);
          if selDiag.SelectedObjects.Count =1 then Menu[0] := '-&Design Patterns' else Menu[0] := '';
          Menu[1] := '&Set Heights of Selected Elements to smallest';
          Menu[2] := '&Move Selected Elements into Diagram''s Package';
          Menu[3] := '-&Convert Selected Element(s) To';
          Menu[4] := '&About';
        end
        else
        begin
          Menu := VarArrayCreate([0,3],varOleStr);
          Menu[0] := '&Diagram Info';
          Menu[1] := '&Convert to IDEAS Diagram';
          Menu[2] := '&Export Diagram to Visio';
          Menu[3] := '&About';
        end;
      end;
      if (MenuName = '-&Design Patterns') then
      begin
        myDO := selDiag.SelectedObjects.GetAt(0) as iDualDiagramObject;
        myElem := rep.GetElementByID(myDO.ElementID);
 	      Menu := VarArrayCreate([0,1],varOleStr);
        Menu[0] := '&Add Powertype';
        if myElem.Stereotype = 'IDEAS:IndividualType' then
        begin
          Menu[1] := '&Whole-Part Pattern';
        end;
      end;
      if (MenuName = '-&Convert Selected Element(s) To') then
      begin
 	     	Menu := VarArrayCreate([0,6],varOleStr);
        Menu[0] := '&IDEAS:Individual';
        Menu[1] := '&IDEAS:IndividualType';
        Menu[2] := '&IDEAS:Type';
        Menu[3] := '&IDEAS:Powertype';
        Menu[4] := '&IDEAS:TupleType';
        Menu[5] := '&IDEAS:NamingScheme';
        Menu[6] := '&IDEAS:UniqueNamingScheme';
      end;
    end;
    if Location = 'TreeView' then
    begin
      selPackGUID := '';
      rep.GetTreeSelectedItem(selected);
      selVar := selected;
      if selVar.objectType = otPackage then
      begin
     		Menu := VarArrayCreate([0,11],varOleStr);
        Menu[0] := '&Add IDEAS Model';
        Menu[1] := '&Carry Out Checks';
        Menu[2] := '&Export XSD';
        Menu[3] := '&Export OWL';
        Menu[4] := '&Export as RDF Schema';
        Menu[5] := '&Export MySQL Script';
        Menu[6] := '&Export to Excel';
        Menu[7] := '&Create IDEAS DB';
        Menu[8] := '&Add to Existing IDEAS DB';
        Menu[9] := '&Export as Example PES XML';
        Menu[10] := '&Diagnostics';
        Menu[11] := '&About';
        selPackGUID := selVar.packageGUID;
      end
      else
      if selVar.objectType = otElement then
      begin
     		Menu := VarArrayCreate([0,1],varOleStr);
        Menu[0] := '&Export to SKOS';
        Menu[1] := '&About';
        selPackGUID := selVar.elementGUID;
      end
    end;
    Result := Menu;
 	end;
end;

procedure TAddin.EA_Disconnect;
begin
	//ShowMessage('Delphi Demo Disconnect');
end;

procedure TAddin.EA_GetMenuState(const Repository: IDispatch;
  const Location, MenuName, ItemName: WideString; var IsEnabled,
  IsChecked: WordBool);
begin
end;

procedure TAddin.EA_FileOpen(const Repository: IDispatch); safecall;
const
	// These two entries manually created, numbers copied from _TLB.pas files
    IID_IIdeasForm: TGUID = 		 '{B1BD4841-DEAA-4C27-8096-D4BAF4826CCF}';
    IID_IIdeasAddIn: TGUID = 		 '{229E35FA-65BA-4E87-8CAF-5476140FF19C}';
var
  searchStr : wideString;
  ideasModels : iDualCollection;
  i,j : integer;
  myElement : oleVariant;
  repSTs : iDualCollection;
  mySt : iDUalStereotype;
  errors : tStringList;
  myModel : iDualElement;
  authors : iDualCollection;
  myAuthor : iDualAuthor;
  ideasAuthor : iDualAuthor;
  authVersion, code : integer;
begin
  Repository.QueryInterface(IID_IDualRepository,Rep);


  repSTs := rep.Stereotypes;
  i := 0;
  repeat
    myST := repSTs.GetAt(i) as iDualStereotype;
    if (leftStr(myST.Name,6) = 'IDEAS:')
    or (leftStr(myST.Name,10) = 'tuplePlace')
    or ((leftStr(myST.Name,5) = 'place') and (rightStr(myST.Name,4) = 'Type'))
    then
    begin
      repSTs.Delete(i);
      repSTs.Refresh;
    end else i := i + 1;
  until i >= repSTs.Count;
  ideasFoundation := nil;
  ideasModels := rep.GetElementsByQuery('findByST','IDEAS:Model');
  if ideasModels.Count > 0 then
  begin
    authors := rep.Authors;
    ideasAuthor := nil;
    if authors.Count > 0 then
    for i := 0 to authors.Count - 1 do
    begin
      myAuthor := authors.GetAt(i) as iDualAuthor;
      if myAuthor.Name = 'IdeasGod' then ideasAuthor := myAuthor
    end;
    if ideasAuthor = nil then
    begin
      ideasAuthor := authors.AddNew('IdeasGod','Writer') as IDualAuthor;

      ideasAuthor.Notes := '0';
      ideasAuthor.Update;
      authors.Refresh;
    end;

    val(ideasAuthor.Notes,authVersion,code);

    if (code <> 0) or (authVersion < 14) then
    begin
      if form9 = nil then form9 := tForm9.Create(nil);
      form9.rep := rep;
      form9.build := build;
      form9.ideasAuthor := ideasAuthor;
      form9.authversion := authversion;
      form9.Caption := 'Updating IDEAS Model to Latest Profile';
      form9.Show;
    end;
    for i := 0 to ideasModels.Count - 1 do
    begin
      myModel := ideasModels.GetAt(i) as iDualElement;
      if myModel.Name = 'IDEAS Foundation' then
      begin
        ideasFoundation := rep.GetPackageByGuid(myModel.ElementGUID);
      end;
    end;
    if ideasFoundation = nil then showMessage('IDEAS Foundation could not be found');

  end;

  //Now check to see if names were all stored as attributes

{  elements := rep.GetElementsByQuery('GetByType','Package');
  if elements.Count > 0 then
  for i := 0 to elements.Count - 1 do
  begin
    myElement := elements.GetAt(i);
    if myElement.stereotype = 'IDEASModel' then
    begin
      ControlInt := Rep.AddTab('IDEAS', 'IdeasAddIn.IdeasForm');
	    ControlInt.QueryInterface(IID_IIdeasForm, m_Control);
      m_Control.setRepository(Rep);
      m_Control.setAddIn(self as iDispatch);
      exit;
    end;
  end;
  stereotypes := rep.Stereotypes;
  if stereotypes.count > 0 then
  for i := 0 to stereotypes.Count - 1 do
  begin
    st := stereotypes.getat(i) as iStereotype;
    if lowercase(st.Name) = 'powertype' then
    begin
      st.name := 'Powertype';
      st.notes := 'This is the IDEAS Powertype';
      st.Update;
    end;
  end;   }
end;

procedure TAddin.EA_MenuClick(const Repository: IDispatch; const Location,
  MenuName, ItemName: WideString);
const
	// These two entries manually created, numbers copied from _TLB.pas files
    IID_IDualRepository: TGUID = '{4CD2CE1E-C301-4C16-9CA2-5A7EC4478C55}';
    IID_IIdeasForm: TGUID = 		 '{B1BD4841-DEAA-4C27-8096-D4BAF4826CCF}';
    IID_IIdeasAddIn: TGUID = 		 '{229E35FA-65BA-4E87-8CAF-5476140FF19C}';
var
  searchStr : wideString;
  selected : iDispatch;
  selVar : oleVariant;
  convStr, xmlNS, xmlNSID : string;
  sxStr : widestring;
  myDO : iDualDiagramObject;
  myElem, pt, pti : iDualElement;
  ptiConn : iDualConnector;
  name, camelCaseName, lowercasename : string;
begin
  if leftstr(ItemName,7) = '&IDEAS:' then
  begin
    convStr := stringReplace(ItemName,'&','',[rfReplaceAll]);
    convertElements(rep,rep.GetCurrentDiagram.SelectedObjects, convStr);
  end;
  if ItemName = '&Diagnostics'  then
  begin
    if form15 =  nil then form15 := tForm15.Create(nil);
    form15.rep := rep;
    form15.Caption := 'Diagnostics';
    form15.ShowModal;
  end;
  if ItemName = '&Tools'  then
  begin
   	Repository.QueryInterface(IID_IDualRepository,Rep);
    ControlInt := Rep.AddTab('IDEAS', 'IdeasAddIn.IdeasForm');
	  ControlInt.QueryInterface(IID_IIdeasForm, m_Control);
    m_Control.setRepository(Rep);
    m_Control.setAddIn(self as iDispatch);
   	Repository.QueryInterface(IID_IDualRepository,Rep);
    searchStr := '<RootSearch><Search Name="findName" GUID="{675546CF-30CA-4c3a-9465-BDA2777D94E0}" PkgGUID="-1" Type="0" LnksToObj="0" CustomSearch="0" AddinAndMethodName=""><SrchOn><RootTable Type="0"><TableName Display="Element" Name="t_object"/>';
    searchStr := searchStr + '<TableHierarchy Display="" Hierarchy="t_object"/><Field Filter="t_object.Name = ''&lt;Search Term&gt;''" Text="&lt;Search Term&gt;" IsDateField="0" Type="1" Required="1" Active="1"><TableName Display="Element" Name="t_object"/>';
    searchStr := searchStr + '<TableHierarchy Display="Element" Hierarchy="t_object"/><Condition Display="Equal To" Type="="/><FieldName Display="Name" Name="t_object.Name"/></Field></RootTable></SrchOn><LnksTo/></Search></RootSearch>';
    rep.AddDefinedSearches(searchStr);
  end;
	if ItemName = '&Add IDEAS Model' then
  begin
    if form11 = nil then form11 := tForm11.create(nil);
    form11.rep := rep;
    form11.memo1.clear;
    form11.parentPackage := rep.GetPackageByGUID(selPackGUID);
  //Need to check that the parent package is not an IDEAS model, or any of the ones above it
    if form11.parentPackage.Element.Stereotype = 'IDEAS:Model' then
    begin
      showmessage('Cannot Create an IDEAS Model inside another IDEAS Model');
    end
    else
    begin
      form11.Caption := 'Add New IDEAS Model in ' + form11.parentPackage.name;
      form11.edit1.clear;
      form11.combobox1.clear;
      populateComboWithNS(rep,form11.combobox1,'');
      form11.package := nil;
      form11.oldNS := '';
      form11.show;
    end;
  end;
	if ItemName = '&About' then
  begin
    if form4 = nil then form4 := tForm4.create(nil);
    form4.Label1.Caption := vartostr(build);
    form4.show;
  end;
	if ItemName = '&Diagram Info' then
  begin
    rep.GetTreeSelectedItem(selected);
    selVar := selected;
    showMessage(selVar.metaType);
  end;

	if ItemName = '&Export XSD' then exportXSD;

  if ItemName = '&Whole-Part Pattern' then
  begin
    if form14 = nil then form14 := tForm14.Create(nil);
    form14.diagObj := rep.GetCurrentDiagram.SelectedObjects.GetAt(0) as iDualDiagramObject;
    myElem := rep.GetElementByID(form14.diagObj.ElementID);
    name := myElem.Name;
    form14.rep := rep;
    form14.diagram := rep.GetCurrentDiagram;
    form14.supertypes := tStringList.Create;
    form14.supertypes := getAllSupertypes(rep,myElem);
    form14.elem := myElem;
    form14.Caption := 'Whole-Part Pattern for ' + myElem.Name;
    form14.edit3.text := name;
    form14.Edit1.text := name + 'Part';
    form14.Edit2.text := name + 'State';
    camelCaseName := dropFirstLetterCase(name);
    form14.Edit4.text := camelCaseName + 'WholePart';
    form14.Edit5.text := camelCaseName + 'WholeAndPart';
    form14.Edit6.text := camelCaseName + 'WholeState';
    form14.ShowModal;
  end;
  if ItemName = '&Add Powertype' then
  begin
    myDO := rep.GetCurrentDiagram.SelectedObjects.GetAt(0) as iDualDiagramObject;
    rep.SaveDiagram(rep.GetCurrentDiagram.DiagramID);
    myElem := rep.GetElementByID(myDO.ElementID);
    pt := createPowertype(rep,raiseFirstLetterCase(myElem.name) + 'Type', rep.GetPackageByID(rep.GetCurrentDiagram.PackageID) as iDualPackage ,'The powertype of ' + myElem.Name,rep.GetCurrentDiagram,myDO,'l=' + vartostr(myDO.right + 200) + ';r=' + vartostr(myDO.right + 350) + ';t=' + vartostr(myDO.top) + ';b=' + vartostr(myDO.bottom) + ';');
    ptiConn := createPTI(rep,myElem,pt);
    rep.reloadDiagram(rep.GetCurrentDiagram.DiagramID);
  end;

	if ItemName = '&Export OWL' then
  begin
    if form12 = nil then form12 := tForm12.Create(nil);
    form12.rep := rep;
    form12.package := rep.GetPackageByGUID(selPackGUID);
    form12.ComboBox1.Clear;
    populateComboWithNS(rep,form12.combobox1,'');
    form12.Edit1.text := getTaggedValue(form12.package.Element,'owlXmlNS');
    form12.Edit2.text := getTaggedValue(form12.package.Element,'owlXmlNSID');
    form12.Show;
   // showmessage('This feature is not available in the free version');
  end;

	if ItemName = '&Export as RDF Schema' then
  begin
    if form12 = nil then form12 := tForm12.Create(nil);
    form12.rep := rep;
    form12.package := rep.GetPackageByGUID(selPackGUID);
    form12.ComboBox1.Clear;
    populateComboWithNS(rep,form12.combobox1,'');
    form12.Edit1.text := getTaggedValue(form12.package.Element,'owlXmlNS');
    form12.Edit2.text := getTaggedValue(form12.package.Element,'owlXmlNSID');
    form12.Show;
   // showmessage('This feature is not available in the free version');
  end;



	if ItemName = '&Export to Excel' then exportExcel(rep.GetPackageByGUID(selPackGUID));

 //	if ItemName = '&Export MySQL Script' then exportMySqlScript;
 	if ItemName = '&Export MySQL Script' then showmessage('Sorry ! We''re still working on this');;
  if ItemName = '&Import from JC3IEDM MDB' then showmessage('I couldn''t agree more - MIP is an ideal candidate for re-engineering under IDEAS...if you want to sponsor us to to do it mail info@modelfutures.com ;)');

 	if ItemName = '&Create IDEAS DB' then exportAccess(true);
 	if ItemName = '&Add to Existing IDEAS DB' then exportAccess(false);
	if ItemName = '&Move Selected Elements into Diagram''s Package' then MoveSelectedToDiagPackage;
	if ItemName = '&Convert to IDEAS Diagram' then
  begin
    sxStr := 'ExcludeRTF=0;DocAll=0;HideQuals=0;AttPkg=1;ShowTests=0;ShowMaint=0;SuppressFOC=1;MatrixActive=0;SwimlanesActive=1;MatrixLineWidth=1;MatrixLocked=0;TConnectorNotation=UML 2.1;TExplicitNavigability=0;AdvancedElementProps=1;AdvancedFeatureProps=1;';
    sxStr := sxStr + 'AdvancedConnectorProps=1;ProfileData=;STBLDgm=;ShowNotes=0;VisibleAttributeDetail=0;ShowOpRetType=1;SuppressBrackets=0;SuppConnectorLabels=0;PrintPageHeadFoot=0;ShowAsList=0;';
    sxStr := sxStr + 'MDGDgm=IDEAS::IDEAS;';
    rep.GetCurrentDiagram.StyleEx := sxStr;
    rep.GetCurrentDiagram.Update;
    rep.ReloadDiagram(rep.GetCurrentDiagram.DiagramID);
  end;
	if ItemName = '&Export Diagram to Visio' then
  begin
    if VisioForm = nil then VisioForm := tVisioForm.create(nil);
    VisioForm.rep := rep;
    VisioForm.diag := rep.GetCurrentDiagram as iDualDiagram;
    VisioForm.show;

  end;
	if ItemName = '&Export to SKOS' then
  begin
    if SkosForm = nil then SkosForm := tSkosForm.create(nil);
    SkosForm.rep := rep;
    SkosForm.rootElem := rep.GetElementByGUID(selPackGUID);
    SkosForm.show;
  end;
	if ItemName = '&Set Heights of Selected Elements to smallest' then setSmallest;
  if ItemName = '&Carry Out Checks' then
  begin
    if form10 = nil then form10 := tForm10.create(nil);
    form10.package := rep.GetPackageByGUID(selPackGUID);
    form10.Caption := 'Errors and Warnings for ' + form10.package.name;
    form10.Memo1.Clear;
    form10.rep := rep;
    if form10.package.Element.Stereotype = 'IDEAS:Model' then form10.Show
       else showmessage('Selected Package is not an IDEAS Model');
  end;
  //&Export as Example PES XML
  if ItemName = '&Export as Example PES XML' then
  begin
    if form13 = nil then form13 := tForm13.create(nil);
    form13.button1.enabled := false;
    form13.memo1.clear;
    form13.package := rep.GetPackageByGUID(selPackGUID);
    form13.Caption := 'Errors and Warnings for ' + form13.package.name;
    form13.rep := rep;
    populateComboWithNS(rep,form13.combobox1,'IDEASName');
    form13.Show;
  end;

end;


procedure TAddin.EA_ShowHelp(const Repository: IDispatch; const Location,
  MenuName, ItemName: WideString);
begin

end;

procedure TAddin.createDBClassesForPackage(package : olevariant; session : tIdeasDbSession; connectors : tStringList; recurse : boolean);
var
  i,j, index : integer;
  myElement, myConnector, tags, st : oleVariant;
  myIdeasThing : tIdeasDbThing;
  testItem : tIdeasDbThing;
  extElem : tExternalResource;
  el : iDualElement;
  oldName, text : string;
begin
  m_Control.AddError('Package: ' + package.name);
  if (package.elements.count > 0) and ((pos(m_Control.ExcludeText, package.Name) < 1) or (m_Control.ExcludeText = '')) then
  begin
    for i := 0 to package.elements.count - 1 do
    begin
      myElement := package.elements.getAt(i);
      myIdeasThing := nil;
      //Is element named ?
      if (myElement.name = '') and m_Control.CreateNames then
      begin
        myElement.name := 't' + varToStr(myElement.elementid);
        myElement.update;
        m_Control.AddError('-WARNING: element had no name - now called: ' + myElement.name);
      end else if myElement.name = '' then m_Control.AddError('ERROR: element: ' + myElement.name + ' has no name');
      testItem := nil;

      //check uniquenesses
      testItem := session.getObjectByIdeasName(myElement.name);
      if m_Control.RenameNonUnique and (testItem <> nil) then
      begin
        oldName := myElement.name;
        while testItem <> nil do
        begin
          myElement.name := myElement.name + '_';
          myElement.update;
          testItem := session.getObjectByIdeasName(myElement.name);
        end;
        m_Control.AddError('-WARNING: Element: ' + oldName + ' had non-unique name - now renamed to:' + myElement.name);
      end else if testItem <> nil then m_Control.AddError('ERROR: Element: ' + myElement.name + ' has non-unique name');

      if debug then m_Control.AddError('-Element: <<' + myElement.stereotype + '>>' + myElement.name);
      if (VarToStr(myElement.type) <> '') and (myElement.name <> '') and (testItem = nil) then
      begin
        if session.getObjectByIdeasName(myElement.name) = nil then
        begin
          if (myElement.stereotype = '') and m_Control.SetStereotypes then
          begin
         //   st := myRepository.Stereotypes.GetByName(combobox1.text);
         //   if not varisnull(st) then myElement.stereotype := st;
            myElement.stereotype := m_Control.DefaultStereotype;
            myElement.update;
          end;
          if reservedNames.find(myElement.name,index) and m_Control.FoundationIncluded then
          begin
            m_Control.AddError('-WARNING: IDEAS Foundation Element encountered: ' + myElement.name);
          end
          else
          if myElement.stereotype <> '' then
          begin
            myIdeasThing := nil;
            //if user requires it, reset all unset stereotypes

            if myElement.stereotype = 'Thing' then myIdeasThing := tIdeasDbThing.create(session, myElement.name);
            if lowercase(myElement.stereotype) = 'type' then myIdeasThing := tIdeasDbType.create(session, myElement.name,nil);
            if myElement.stereotype = 'IndividualType' then myIdeasThing := tIdeasDbIndividualType.create(session, myElement.name);
            if lowercase(myElement.stereotype) = 'powertype' then myIdeasThing := tIdeasDbPowertype.create(session, myElement.name,nil);
            if myElement.stereotype = 'TupleType' then
            begin
              myIdeasThing := tIdeasDbTupleType.create(session, myElement.name,'','','','','',nil,nil,nil,nil,nil,nil);
            end;
            if myElement.stereotype = 'Individual' then myIdeasThing := tIdeasDbIndividual.create(session, myElement.name);
            if myElement.stereotype = 'NamingScheme' then myIdeasThing := tIdeasDbNamingScheme.create(session, myElement.name);
            if myElement.stereotype = 'Name' then
            begin
              text := myElement.taggedValues.getbyname('exemplarText').value;
              myIdeasThing := tIdeasDbName.create(text,nil,session);
//              if myElement.name <> '' then  myIdeasThing.rootName := myElement.name;
            end;
            if myElement.stereotype = 'ExternalElement' then
            begin
              if debug then m_Control.AddError('-External element :' + extElem.rdfID);
            end;
            if myElement.stereotype = 'tuple' then
            begin
              myIdeasThing := tIdeasDbTuple.create(nil,nil,nil,nil,nil,session);
              if myElement.name <> '' then  myIdeasThing.rootName := myElement.name;
            end;
            if myElement.stereotype = 'couple' then
            begin
              myIdeasThing := tIdeasDbCouple.create(nil,nil,session);
              if myElement.name <> '' then  myIdeasThing.rootName := myElement.name;
            end;

            //The element is not a recognised IDEAS thing...so let them know !
            if (myIdeasThing = nil) and (myElement.stereotype <> 'ExternalElement') then
              m_Control.AddError('-WARNING: Class: ' + myElement.name + ' in package: ' + package.name + ' has unrecognised stereotype: ' + myElement.stereotype)
            else
            begin
              if myElement.connectors.count > 0 then
              for j := 0 to myElement.connectors.Count - 1 do
              begin
                myConnector := myElement.connectors.getat(j);
                connectors.Add(myConnector.connectorGUID);
              end;
            end;
          end else m_Control.AddError('-WARNING: Class: ' + myElement.name + ' in package: ' + package.name + ' has no stereotype');
        end else m_Control.AddError('ERROR: Class: ' + myElement.name + ' in package: ' + package.name + ' has a non-unique name');
      end;
    end;
  end;
  if recurse and (package.packages.count > 0 ) then
  for i := 0 to package.packages.count - 1 do createDBClassesForPackage(package.packages.getAt(i),session, connectors,recurse);
end;

procedure TAddin.createRDFClassesForPackage(package : olevariant; session : tIdeasSession; connectors : tStringList; recurse : boolean);
var
  i,j, index : integer;
  myElement, myConnector, tags, st : oleVariant;
  myIdeasThing : tIdeasThing;
  testItem : tRdfsResource;
  extElem : tExternalResource;
  oldName, text, id : string;
begin
  m_Control.AddError('Package: ' + package.name);
  if (package.elements.count > 0) and ((pos(m_Control.ExcludeText, package.Name) < 1) or (m_Control.ExcludeText = '')) then
  begin
    for i := 0 to package.elements.count - 1 do
    begin
      myElement := package.elements.getAt(i);
      myIdeasThing := nil;
      //Is element named ?
      if (myElement.name = '') and m_Control.CreateNames then
      begin
        myElement.name := 't' + varToStr(myElement.elementid);
        myElement.update;
        m_Control.AddError('-WARNING: element had no name - now called: ' + myElement.name);
      end else if myElement.name = '' then m_Control.AddError('ERROR: element: ' + myElement.name + ' has no name');
      testItem := nil;

      //check uniqueness
      testItem := session.getItemByRdfID(myElement.name);
      if m_Control.RenameNonUnique and (testItem <> nil) then
      begin
        oldName := myElement.name;
        while testItem <> nil do
        begin
          myElement.name := myElement.name + '_';
          myElement.update;
          testItem := session.getItemByRdfID(myElement.name);
        end;
        m_Control.AddError('-WARNING: Element: ' + oldName + ' had non-unique name - now renamed to:' + myElement.name);
      end else if testItem <> nil then m_Control.AddError('ERROR: Element: ' + myElement.name + ' has non-unique name');

      if debug then m_Control.AddError('-Element: <<' + myElement.stereotype + '>>' + myElement.name);
      if (VarToStr(myElement.type) <> '') and (myElement.name <> '') and (testItem = nil) then
      begin
        if session.getItemByRdfID(myElement.name) = nil then
        begin
          if (myElement.stereotype = '') and m_Control.SetStereotypes then
          begin
         //   st := myRepository.Stereotypes.GetByName(combobox1.text);
         //   if not varisnull(st) then myElement.stereotype := st;
            myElement.stereotype := m_Control.DefaultStereotype;
            myElement.update;
          end;
          if reservedNames.find(myElement.name,index) and m_Control.FoundationIncluded then
          begin
            m_Control.AddError('-WARNING: IDEAS Foundation Element encountered: ' + myElement.name + ' adding as external reference');
            extElem := tExternalResource.create('http://www.ideasgroup.org/IDEAS_Foundation.rdf#' + myElement.name,session, myElement.created);
          end
          else
          if myElement.stereotype <> '' then
          begin
            myIdeasThing := nil;
            //if user requires it, reset all unset stereotypes
            id := baseURL+'#'+ myElement.name;
            if myElement.stereotype = 'Thing' then myIdeasThing := tIdeasThing.create(id,session, myElement.created);
            if lowercase(myElement.stereotype) = 'type' then myIdeasThing := tIdeasType.create(id,session, myElement.created);
            if myElement.stereotype = 'TupleType' then myIdeasThing := tIdeasTupleType.create(id,session, myElement.created);
            if myElement.stereotype = 'Individual' then myIdeasThing := tIdeasIndividual.create(id,session, myElement.created);
            if myElement.stereotype = 'NameType' then myIdeasThing := tIdeasNameType.create(id,session, myElement.created);
            if myElement.stereotype = 'IndividualType' then myIdeasThing := tIdeasIndividualType.create(id,session, myElement.created);
            if lowercase(myElement.stereotype) = 'powertype' then myIdeasThing := tIdeasPowertype.create(id,session, myElement.created);
            if myElement.stereotype = 'Name' then
            begin
              myIdeasThing := tIdeasName.create(id,session, myElement.created);
              text := myElement.taggedValues.getbyname('exemplarText').value;
              if debug then m_Control.AddError('-Creating name: ' + id + ' with text: ' + text);
              with (myIdeasThing as tIdeasName) do setExemplarText(text);
            end;
            if myElement.stereotype = 'ExternalElement' then
            begin
              extElem := tExternalResource.create(myElement.taggedValues.getbyname('url').value,session, myElement.created);
              if debug then m_Control.AddError('-External element :' + extElem.rdfID);
            end;
            if myElement.stereotype = 'tuple' then
            begin
              myIdeasThing := tIdeastuple.create(id,session, myElement.created);
            end;
            if myElement.stereotype = 'couple' then
            begin
              if debug then m_Control.AddError('creating couple');
              myIdeasThing := tIdeascouple.create(id,session, myElement.created);
            end;

            //The element is not a recognised IDEAS thing...so let them know !
            if (myIdeasThing = nil) and (myElement.stereotype <> 'ExternalElement') then
              m_Control.AddError('-WARNING: Class: ' + id + ' in package: ' + package.name + ' has unrecognised stereotype: ' + myElement.stereotype)
            else
            begin
              if myElement.connectors.count > 0 then
              for j := 0 to myElement.connectors.Count - 1 do
              begin
                myConnector := myElement.connectors.getat(j);
                connectors.Add(myConnector.connectorGUID);
              end;
            end;
          end else m_Control.AddError('-WARNING: Class: ' + id + ' in package: ' + package.name + ' has no stereotype');
        end else m_Control.AddError('ERROR: Class: ' + id + ' in package: ' + package.name + ' has a non-unique name');
      end;
    end;
  end;
  if recurse and (package.packages.count > 0 ) then
  for i := 0 to package.packages.count - 1 do createRDFClassesForPackage(package.packages.getAt(i),session, connectors,recurse);
end;

procedure TAddin.EA_OnContextItemChanged(const Repository: IDispatch; const GUID: WideString; ot: OleVariant);
var
  selected : iDispatch;
  element : iDualElement;
  package : iPackage;
  TVs : iCollection;
  myTV : iTaggedValue;
  st : string;
begin
 // rep.SuppressEADialogs := false;
  if ot = otElement then
  begin
    element := rep.GetElementByGuid(GUID) as iDualElement;
    st := element.Stereotype;
    if pos('IDEAS:',st) > 0 then rep.SuppressEADialogs := true;
  end;
  if m_Control <> nil then
  begin
    if rep.GetTreeSelectedItem(selected) = otPackage then
    begin
      m_Control.EnableRDFButton;
      package := selected as iPackage;
      element := package.element as iDualElement;
      if element.stereotype = 'IDEASModel' then
      begin
        TVs := element.taggedValues as iCollection;
        myTV := TVs.getbyname('baseURL') as iTaggedValue;
        m_Control.SetURL(myTV.value);
      end else m_Control.SetURL('');
    end else m_Control.DisableRDFButton;
  end;
end;

procedure TAddIN.exportMySqlScript;
var
  script, elements, nsList, names : tStringList;
  namingSchemes : iDualCollection;
  myNs : iDualElement;
  selected : iDispatch;
  i, j : integer;
  myElem : tElemHolder;
  modelURL, ideasName : string;
  myPackage : iDualPackage;
begin
  if SaveDialog1 = nil then
  begin
    SaveDialog1 := tSaveDialog.create(nil);
    SaveDialog1.Title := 'Save MySQL Script';
    SaveDialog1.DefaultExt := '*.sql';
    SaveDialog1.Filter := 'SQL Files|*.sql|All Files|*.*';
  end;
  rep.GetTreeSelectedItem(selected);
  myPackage := selected as iDualPackage;
  if SaveDialog1.execute and (not VarIsNull(selected)) and (mypackage.objectType = otPackage) then
  begin
    script := tStringList.Create;
    elements := tStringList.Create;
    script.Add('-- This script id Copyright Model Futures Limited 2007-2010');
    script.Add('-- It may be used for non-commercial purposes. Anyone wishing to use the script to generate a database that is for commercial use should contact info@modelfutures.com to purchase a license');
    script.Add('');
    script.Add('delimiter $$');
    script.Add('');
    script.Add('DROP PROCEDURE IF EXISTS ideasLoad;');
    script.Add('');
    script.Add('CREATE PROCEDURE ideasLoad()');
    script.Add('BEGIN');
    modelUrl := getTaggedValue(myPackage.Element,'baseURL');
    script.Add('  DECLARE modelID INT;');

    script.Add('  DECLARE sparxNS BIGINT;');

    getElementsInPackage(mypackage,elements,'',rep,true, nil,nil);
    if elements.Count > 0 then
    for i := 0 to elements.Count - 1 do
    begin
      myElem := elements.Objects[i] as tElemHolder;
      script.Add('  DECLARE id' + vartostr(myElem.id) + ' BIGINT;');
    end;

    nsList := tStringList.create;

    NamingSchemes := rep.GetElementsByQuery('findByST','IDEAS:NamingScheme');
    if NamingSchemes.Count > 0 then
    for i := 0 to NamingSchemes.Count - 1 do
    begin
      myNS := NamingSchemes.GetAt(i) as iDualElement;
      ideasName := getIdeasName(myNS,rep);
      if ideasName = '' then showMessage('NamingScheme: ' + myNS.Name + ' has no IDEAS Name set')
      else
      begin
        script.Add('  DECLARE ' + sanitiseName(ideasName) + 'NSID BIGINT;');
        nsList.Add(ideasName);
      end;
    end;

    NamingSchemes := rep.GetElementsByQuery('findByST','IDEAS:UniqueNamingScheme');
    if NamingSchemes.Count > 0 then
    for i := 0 to NamingSchemes.Count - 1 do
    begin
      myNS := NamingSchemes.GetAt(i) as iDualElement;
      ideasName := getIdeasName(myNS,rep);
      if ideasName = '' then showMessage('UniqueNamingScheme: ' + myNS.Name + ' has no IDEAS Name set')
      else
      begin
        script.Add('  DECLARE ' + sanitiseName(ideasName) + 'NSID BIGINT;');
        nsList.Add(ideasName);
      end;
    end;

    script.Add('');
    script.Add('  set modelID = addModel(''' + myPackage.Name + ''',''' + modelURL + ''');');
    script.Add('');
    script.Add('  set sparxNS = addUniqueNamingScheme(''SparxGUID'',modelID);');
    script.Add('');

    NamingSchemes := rep.GetElementsByQuery('findByST','IDEAS:NamingScheme');
    if NamingSchemes.Count > 0 then
    for i := 0 to NamingSchemes.Count - 1 do
    begin
      myNS := NamingSchemes.GetAt(i) as iDualElement;
      ideasName := getIdeasName(myNS,rep);
      if ideasName = '' then showMessage('NamingScheme: ' + myNS.Name + ' has no IDEAS Name set')
      else
      begin
        script.Add('  set ' + sanitiseName(ideasName) + 'NSID = addNamingScheme('''+ ideasName +''',modelID);');
      end;
    end;

    NamingSchemes := rep.GetElementsByQuery('findByST','IDEAS:UniqueNamingScheme');
    if NamingSchemes.Count > 0 then
    for i := 0 to NamingSchemes.Count - 1 do
    begin
      myNS := NamingSchemes.GetAt(i) as iDualElement;
      ideasName := getIdeasName(myNS,rep);
      if ideasName = '' then showMessage('UniqueNamingScheme: ' + myNS.Name + ' has no IDEAS Name set')
      else
      begin
        script.Add('  set ' + sanitiseName(ideasName) + 'NSID = addUniqueNamingScheme('''+ ideasName +''',modelID);');
      end;
    end;

    getElementsInPackage(mypackage,elements,'',rep,true, nil,nil);
    if elements.Count > 0 then
    for i := 0 to elements.Count - 1 do
    begin
      myElem := elements.Objects[i] as tElemHolder;
      ideasName := getIdeasName(myElem.element,rep);
      if myElem.element.Stereotype = 'IDEAS:Type' then script.Add('  set id' + vartostr(myElem.id) + ' = addType(''' + ideasName + ''',modelID);');
      if myElem.element.Stereotype = 'IDEAS:IndividualType' then script.Add('  set id' + vartostr(myElem.id) + ' = addIndividualType(''' + ideasName + ''',modelID);');
      if myElem.element.Stereotype = 'IDEAS:Powertype' then script.Add('  set id' + vartostr(myElem.id) + ' = addPowertype(''' + ideasName + ''',modelID);');
      if myElem.element.Stereotype = 'IDEAS:Individual' then script.Add('  set id' + vartostr(myElem.id) + ' = addIndividual(''' + ideasName + ''',modelID);');

      names := getNames(rep,myElem.element,nsList,nil);
      if nsList.count > 0 then
      for j := 0 to nsList.Count - 1 do
      if (names[j] <> '') AND (nsList[j] <> 'IDEASName') then
      begin
        script.Add('  CALL setName(''id' + names[j] + ''',' + vartostr(myElem.id) + ',' + sanitiseName(nsList[j]) + 'NSID,modelID)');

      end;


    end;



    script.Add('END$$');
    script.Add('');
    script.Add('delimiter ;');
    script.Add('');
    script.Add('CALL ideasLoad;');
    script.SaveToFile(saveDialog1.FileName);
  end;
end;



procedure TAddin.populateDB;
var
  selected : iDispatch;
  element, packElem : iElement;
  package : iPackage;
  myConnector, client, supplier : oleVariant;
  i, index : integer;
  connectors : tStringList;
  session : tIdeasDbSession;
  place1, place2 : tIdeasDbThing;
  myTypeInstance : tIdeasDbTypeInstance;
  extElem : tExternalResource;
  mySuperSub : tIdeasDbSuperSubtype;
  myWholePart : tIdeasDbWholePart;
  myTuple : tIdeasDbTuple;
  myNamedBy : tIdeasDbNamedBy;
  isError : boolean;
  clientName, supplierName, placeString : string;
  myNamingSchemeInstance : tIdeasDbNamingSchemeInstance;
  TVs : iCollection;
  myTV : iTaggedValue;
begin
 { if OpenDialog1 = nil then
  begin
    OpenDialog1 := tSaveDialog.create(nil);
    OpenDialog1.Title := 'Open IDEAS Database';
    OpenDialog1.DefaultExt := '*.mdb';
    OpenDialog1.Filter := 'IDEAS Files|*.mdb|All Files|*.*';
  end;
  rep.GetTreeSelectedItem(selected);
  package := selected as iPackage;
  reservedNames := tStringList.create;
  reservedNames.Sorted := true;
  reservedNames.CommaText := m_Control.GetReservedWords;
  m_Control.ClearErrors;
  if OpenDialog1.execute and (not VarIsNull(package)) and (package.objectType = otPackage) then
  begin
    packElem := package.element as iElement;
    TVs := packElem.taggedValues as iCollection;
    myTV := TVs.getbyname('baseURL') as iTaggedValue;
    ideasDb := tIdeasDatabase.create(OPenDialog1.FileName);
    ideasDb.activate;
    connectors := tStringList.create;
    connectors.Sorted := true;
    m_Control.AddError('Creating session for Model URL: ' + myTV.Value);
    session := tIdeasDbSession.Create(ideasDb,myTV.Value);
    m_Control.AddError('Session Created Root Name ID: ' + VarToStr(session.rootNamingSchemeID));

    createDbClassesForPackage(package,session, connectors,m_Control.Recurse);
    m_Control.AddError('Exporting Connectors');
    if connectors.count > 0 then
    for i := 0 to connectors.Count - 1 do
    begin
      myConnector := rep.GetConnectorByGuid(connectors[i]);
      if (pos('Source',myConnector.direction) < 1) then
      begin
        if m_Control.ResetDirections then
        begin
          myConnector.SupplierEnd.IsNavigable := False;
          myConnector.SupplierEnd.Update;
          myConnector.ClientEnd.IsNavigable := True;
          myConnector.ClientEnd.Update;
          m_Control.AddError('-WARNING: Direction of connector between ' + client.name + ' and ' + supplier.name + ' has been set to "Source->Destination"');
        end
        else
        begin
          if myConnector.direction = 'Unspecified' then m_Control.AddError('ERROR: Direction of connector between ' + client.name + ' and ' + supplier.name + ' is unspecified');
          if myConnector.direction = 'Bi-Directional' then m_Control.AddError('ERROR: Connector between ' + client.name + ' and ' + supplier.name + ' is bi-directional');
        end;
      end;
      client := rep.GetElementByID(myConnector.clientID);
      supplier := rep.GetElementByID(myConnector.supplierID);
      if client.stereotype = 'ExternalElement' then clientName := client.taggedValues.getbyname('url').value else clientName := client.name;
      if supplier.stereotype = 'ExternalElement' then supplierName := supplier.taggedValues.getbyname('url').value else supplierName := supplier.name;

     //MAKE SURE place1 is at the ARROW END
      if myConnector.direction = 'Source -> Destination' then
      begin
        place2 := session.getObjectByIdeasName(clientName);
        place1 := session.getObjectByIdeasName(supplierName);
        m_Control.AddError('<<' + myCOnnector.stereotype + '>>place1=' + supplierName + '   place2=' + clientName);
      end;
      if myConnector.direction = 'Destination -> Source' then
      begin
        place1 := session.getObjectByIdeasName(clientName);
        place2 := session.getObjectByIdeasName(supplierName);
        m_Control.AddError('<<' + myCOnnector.stereotype + '>>place1=' + clientName + '   place2=' + supplierName);
      end;

      //if requested, change gens to supersubs and make them blue
      if m_Control.FillInSuperSub and (myConnector.type = 'Generalization') and (myConnector.stereotype <> 'superSubtype') then
      begin
        myConnector.stereotype := 'superSubtype';
        myConnector.update;
        myConnector.color := 16711680;
        myConnector.update;
        m_Control.AddError('-WARNING: Generalisation: ' + varToStr(myConnector.connectorID) + ' stereotype set to "superSubtype"');
      end;
      //unset direction - if user has requested a reset then do it

      if debug and (place1 = nil) then m_Control.AddError('Place1 unset');
      if debug and (place2 = nil) then m_Control.AddError('Place2 unset');


      //if we've got two real ends to the connector (i.e. they could be found in the repository) then make the IDEAS RDF
      if (place1 <> nil) and (place2 <> nil) then
      begin
        if myConnector.type = 'Generalization' then
        begin
          if (place1 is tIdeasDbType) and (place2 is tIdeasDbType) then
          begin
            if debug then m_Control.AddError('-generalisation colour: ' + varToStr(myConnector.color));
            mySuperSub := tIdeasDbSuperSubtype.create(place1 as tIdeasDbType,place2 as tIdeasDbType,session);
            if myConnector.stereotype <> 'superSubtype' then  m_Control.AddError('-WARNING: Generalisation used with no stereotype between ' + place1.rootName + ' and ' + place2.rootName);
          end else m_Control.AddError('-ERROR: One end is not an ideas Type in Generalization between ' + place1.rootName + ' and ' + place2.rootName);
        end;

        //*********************Association****************************//
        if myConnector.type = 'Association' then
        if debug then m_Control.AddError('-Association Found');
        begin
          if myConnector.stereotype = 'namedBy' then mynamedBy := tIdeasDbnamedBy.create(place1,place2 as tIdeasDbName,session);

          if pos('tuplePlace', myConnector.stereotype) = 1 then
          begin
            if (place2 is tIdeasDbtuple) then
            begin
              if myConnector.stereotype = 'tuplePlace1' then (place2 as tIdeasDbtuple).place1 := place1;
              if myConnector.stereotype = 'tuplePlace2' then (place2 as tIdeasDbtuple).place2 := place1;
              if myConnector.stereotype = 'tuplePlace3' then (place2 as tIdeasDbtuple).place3 := place1;
              if myConnector.stereotype = 'tuplePlace4' then (place2 as tIdeasDbtuple).place4 := place1;
              if myConnector.stereotype = 'tuplePlace5' then (place2 as tIdeasDbtuple).place5 := place1;
            end;
          end;

          if (pos('place', myConnector.stereotype) = 1) then
          begin
            if debug then m_Control.AddError('-PlaceType Found - Basetype:' + place2.ClassName + ' - relates to item of type:' + place1.className);
            if place2 is tIdeasDbTupleType then
            begin
              if place1 is tIdeasDbType then
              begin
                if myConnector.stereotype = 'place1Type' then with (place2 as tIdeasDbTupleType) do setPlaceTypeAndName(1,place1 as tIdeasDbType,myConnector.name);
                if myConnector.stereotype = 'place2Type' then with (place2 as tIdeasDbTupleType) do setPlaceTypeAndName(2,place1 as tIdeasDbType,myConnector.name);
                if myConnector.stereotype = 'place3Type' then with (place2 as tIdeasDbTupleType) do setPlaceTypeAndName(3,place1 as tIdeasDbType,myConnector.name);
                if myConnector.stereotype = 'place4Type' then with (place2 as tIdeasDbTupleType) do setPlaceTypeAndName(4,place1 as tIdeasDbType,myConnector.name);
                if myConnector.stereotype = 'place5Type' then with (place2 as tIdeasDbTupleType) do setPlaceTypeAndName(5,place1 as tIdeasDbType,myConnector.name);
              end else m_Control.AddError('-ERROR: Tuple Place Type does not connect to a Type between ' + place1.rootName + ' and ' + place2.rootName);
            end else m_Control.AddError('-ERROR: Tuple Place Type does not connect from a TupleType between ' + place1.rootName + ' and ' + place2.rootName);
          end;
        end;



        //*********************Aggregation****************************//
        if myConnector.type = 'Aggregation' then
        begin
          if (place1 is tIdeasDbIndividual) and (place2 is tIdeasDbIndividual) then myWholePart := tIdeasDbWholePart.create(place1 as tIdeasDbIndividual,place2 as tIdeasDbIndividual,session)
             else m_Control.AddError('-ERROR: wholePart does not connect from two individuals between ' + place1.rootName + ' and ' + place2.rootName);
        end;

        //*********************Dependency****************************//
        if myConnector.type = 'Dependency' then
        begin
          if (place1 is tIdeasDbType) then
          begin
            if myConnector.stereotype = 'typeInstance' then myTypeInstance := tIdeasDbtypeInstance.create(place1 as tIdeasDbType,place2,session);
            if myConnector.stereotype = 'namingSchemeInstance' then  myTypeInstance := tIdeasDbNamingSchemeInstance.create(place1 as tIdeasDbNamingScheme,place2 as tIdeasDbName,session);
            if myConnector.stereotype = 'powertypeInstance' then myTypeInstance := tIdeasDbpowertypeInstance.create(place1 as tIdeasDbType,place2 as tIdeasDbType,session);
          end else m_Control.AddError('-ERROR: Type end is not an ideas Type in Dependency between ' + place1.rootName + ' and ' + place2.rootName);
        end;
      end;
    end;
  end;  }
end;



procedure TAddin.AddGUIDs;
var
  selected : iDispatch;
  element, packElem : iElement;
  package : iPackage;
  myConnector, client, supplier : oleVariant;
  i, index : integer;
  connectors : tStringList;
  session : tIdeasDbSession;
  place1, place2 : tIdeasDbThing;
  myTypeInstance : tIdeasDbTypeInstance;
  extElem : tExternalResource;
  mySuperSub : tIdeasDbSuperSubtype;
  myWholePart : tIdeasDbWholePart;
  myTuple : tIdeasDbTuple;
  myNamedBy : tIdeasDbNamedBy;
  isError : boolean;
  clientName, supplierName, placeString : string;
  myNameTypeInstance : tIdeasDbNamingSchemeInstance;
  TVs : iCollection;
  myTV : iTaggedValue;
  guidNT : tIdeasDbNamingScheme;
begin
  if OpenDialog1 = nil then
  begin
    OpenDialog1 := tSaveDialog.create(nil);
    OpenDialog1.Title := 'Open IDEAS Database';
    OpenDialog1.DefaultExt := '*.ideas';
    OpenDialog1.Filter := 'IDEAS Files|*.ideas|All Files|*.*';
  end;
  rep.GetTreeSelectedItem(selected);
  package := selected as iPackage;
  reservedNames := tStringList.create;
  reservedNames.Sorted := true;
  reservedNames.CommaText := m_Control.GetReservedWords;
  m_Control.ClearErrors;
  if OpenDialog1.execute and (not VarIsNull(package)) and (package.objectType = otPackage) then
  begin
    packElem := package.element as iElement;
    TVs := packElem.taggedValues as iCollection;
    myTV := TVs.getbyname('baseURL') as iTaggedValue;
  //  ideasDb := tIdeasDatabase.create(OPenDialog1.FileName);
 //   ideasDb.activate;
    connectors := tStringList.create;
    connectors.Sorted := true;
    m_Control.AddError('Creating session for Model URL: ' + myTV.Value);
    session := tIdeasDbSession.Create(OPenDialog1.FileName,myTV.Value);
    m_Control.AddError('Session Created Root Name ID: ' + VarToStr(session.rootNamingSchemeID));
    guidNT := tIdeasDbNamingScheme.create(session,'Sparx_GUIDs');

    createDbClassesForPackage(package,session, connectors,m_Control.Recurse);
  end;
end;


procedure TAddin.exportRDF;
var
  selected : iDispatch;
  element : iElement;
  package : iPackage;
  myConnector, client, supplier : oleVariant;
  i, index : integer;
  connectors : tStringList;
  ideasSession : tIdeasSession;
  place1, place2 : tRdfsResource;
  myTypeInstance : tIdeasTypeInstance;
  extElem : tExternalResource;
  mySuperSub : tIdeasSuperSubtype;
  myWholePart : tIdeasWholePart;
  myTuple : tIdeasTuple;
  myNamedBy : tIdeasNamedBy;
  isError, reversed : boolean;
  clientName, supplierName, placeString : string;
  //myNameTypeInstance : tIdeasnameTypeInstance;
begin
  baseURL := m_Control.getURL;
  m_Control.ClearErrors;
  rep.GetTreeSelectedItem(selected);
  package := selected as iPackage;
  reservedNames := tStringList.create;
  reservedNames.Sorted := true;
  reservedNames.CommaText := m_Control.GetReservedWords;
  if (not VarIsNull(package)) and (package.objectType = otPackage) then
  begin
    connectors := tStringList.create;
    connectors.Sorted := true;
    ideasSession := tIdeasSession.Create(baseURL);
    m_Control.AddError('Exporting Elements');
    createRdfClassesForPackage(package,ideasSession, connectors,m_Control.Recurse);
  //  ideasSession.chuck;
    m_Control.AddError('Exporting Connectors');
    if connectors.count > 0 then
    for i := 0 to connectors.Count - 1 do
    begin
     // if debug then ideasSession.saveAs('c:\temp\ideasout.xml');
      
      reversed := false;
      myConnector := rep.GetConnectorByGuid(connectors[i]);
      if (pos('Source',myConnector.direction) < 1) then
      begin
        if m_Control.ResetDirections then
        begin
          myConnector.SupplierEnd.IsNavigable := False;
          myConnector.SupplierEnd.Update;
          myConnector.ClientEnd.IsNavigable := True;
          myConnector.ClientEnd.Update;
          m_Control.AddError('-WARNING: Direction of connector between ' + client.name + ' and ' + supplier.name + ' has been set to "Source->Destination"');
        end
        else
        begin
          if myConnector.direction = 'Unspecified' then m_Control.AddError('ERROR: Direction of connector between ' + client.name + ' and ' + supplier.name + ' is unspecified');
          if myConnector.direction = 'Bi-Directional' then m_Control.AddError('ERROR: Connector between ' + client.name + ' and ' + supplier.name + ' is bi-directional');
        end;
      end;
      client := rep.GetElementByID(myConnector.clientID);
      supplier := rep.GetElementByID(myConnector.supplierID);
      if client.stereotype = 'ExternalElement' then clientName := client.taggedValues.getbyname('url').value else clientName := client.name;
      if supplier.stereotype = 'ExternalElement' then supplierName := supplier.taggedValues.getbyname('url').value else supplierName := supplier.name;

      //Check for case where user has just put the IDEAS foundation in their model
      if reservedNames.Find(client.name,index) and m_Control.FoundationIncluded then
      begin
        clientName := 'http://www.ideasgroup.org/IDEAS_Foundation.rdf#' + clientName;
        if ideasSession.getItemByRdfID(clientName) = nil then extElem := tExternalResource.create(clientName,ideasSession, myConnector.created);
      end;
      if reservedNames.Find(supplier.name,index) and m_Control.FoundationIncluded then
      begin
        supplierName := 'http://www.ideasgroup.org/IDEAS_Foundation.rdf#' + supplierName;
        if ideasSession.getItemByRdfID(supplierName) = nil then extElem := tExternalResource.create(supplierName,ideasSession, myConnector.created);
      end;

      if debug then m_Control.AddError('-Connector: <<' + myConnector.stereotype + '>>' + MyConnector.type + ' -> ClientName:' + clientname + '  SupplierName:' + suppliername);
     // listbox1.items.add(client.type + '-' + supplier.type);

     //MAKE SURE place1 is at the ARROW END
      if myConnector.direction = 'Source -> Destination' then
      begin
        place2 := ideasSession.getItemByRdfID(baseURL+'#'+clientName);
        place1 := ideasSession.getItemByRdfID(baseURL+'#'+supplierName);
      end;
      if myConnector.direction = 'Destination -> Source' then
      begin
        place1 := ideasSession.getItemByRdfID(baseURL+'#'+clientName) as tIdeasThing;
        place2 := ideasSession.getItemByRdfID(baseURL+'#'+supplierName) as tIdeasThing;
        reversed := true;
      end;

      //if requested, change gens to supersubs and make them blue
      if m_Control.FillInSuperSub and (myConnector.type = 'Generalization') and (myConnector.stereotype <> 'superSubtype') then
      begin
        myConnector.stereotype := 'superSubtype';
        myConnector.update;
        myConnector.color := 16711680;
        myConnector.update;
        m_Control.AddError('-WARNING: Generalisation: ' + varToStr(myConnector.connectorID) + ' stereotype set to "superSubtype"');
      end;
      //unset direction - if user has requested a reset then do it

      if debug and (place1 = nil) then m_Control.AddError('Place1 unset');
      if debug and (place2 = nil) then m_Control.AddError('Place2 unset');


      //if we've got two real ends to the connector (i.e. they could be found in the repository) then make the IDEAS RDF
      if (place1 <> nil) and (place2 <> nil) then
      begin
        if myConnector.type = 'Generalization' then
        begin
          if ((place1 is tIdeasType) or (place1 is tExternalResource)) and ((place2 is tIdeasType) or (place2 is tExternalResource)) then
          begin
            if debug then m_Control.AddError('-generalisation colour: ' + varToStr(myConnector.color));
            mySuperSub := tIdeassuperSubtype.create(place2.rdfID + 'SubTypeOf' + place1.rdfID,ideasSession, myConnector.created);
            if place1 is tExternalResource then mySuperSub.setExternalRefProperty('ideasf:supertype', place1 as tExternalResource) else mySuperSub.setSuperType(place1 as tIdeasType);
            if place2 is tExternalResource then mySuperSub.setExternalRefProperty('ideasf:subtype', place2 as tExternalResource) else mySuperSub.setSubType(place2 as tIdeasType);
            if myConnector.stereotype <> 'superSubtype' then  m_Control.AddError('-WARNING: Generalisation used with no stereotype between ' + place1.rdfID + ' and ' + place2.rdfID);
          end else m_Control.AddError('-ERROR: One end is not an ideas Type in Generalization between ' + place1.rdfID + ' and ' + place2.rdfID);
        end;

        //*********************Association****************************//
        if myConnector.type = 'Association' then
        if debug then m_Control.AddError('-Association Found');
        begin
          if myConnector.stereotype = 'namedBy' then
          begin
            mynamedBy := tIdeasnamedBy.create(place2.rdfID + 'namedBy' + place1.rdfID,ideasSession, myConnector.created);
          end;

          if pos('tuplePlace', myConnector.stereotype) = 1 then
          begin
            if (place2 is tIdeastuple) then
            begin
              if place1 is tExternalResource then
              begin
                if myConnector.stereotype = 'tuplePlace1' then with (place2 as tIdeastuple) do setExternalRefProperty('ideasf:' + myConnector.stereotype, place1 as tExternalResource);
              end
              else
              begin
                if myConnector.stereotype = 'tuplePlace1' then with (place2 as tIdeastuple) do setPlace1(place1 as tIdeasThing);
                if myConnector.stereotype = 'tuplePlace2' then with (place2 as tIdeastuple) do setPlace2(place1 as tIdeasThing);
                if myConnector.stereotype = 'tuplePlace3' then with (place2 as tIdeastuple) do setPlace3(place1 as tIdeasThing);
                if myConnector.stereotype = 'tuplePlace4' then with (place2 as tIdeastuple) do setPlace4(place1 as tIdeasThing);
                if myConnector.stereotype = 'tuplePlace5' then with (place2 as tIdeastuple) do setPlace5(place1 as tIdeasThing);
              end;
            end else m_Control.AddError('-ERROR: TuplePlace does not connect from a tuple between ' + place1.rdfID + ' and ' + place2.rdfID);
          end;

          if (pos('place', myConnector.stereotype) = 1) then
          begin
            if debug then m_Control.AddError('-PlaceType Found - Basetype:' + place2.ClassName + ' - relates to item of type:' + place1.className);
            if place2 is tIdeasTupleType then
            begin
              if place1 is tIdeasType then
              begin
                if myConnector.stereotype = 'place1Type' then with (place2 as tIdeasTupleType) do setPlaceType1(place1 as tIdeasType,myConnector.name);
                if myConnector.stereotype = 'place2Type' then with (place2 as tIdeasTupleType) do setPlaceType2(place1 as tIdeasType,myConnector.name);
                if myConnector.stereotype = 'place3Type' then with (place2 as tIdeasTupleType) do setPlaceType3(place1 as tIdeasType,myConnector.name);
                if myConnector.stereotype = 'place4Type' then with (place2 as tIdeasTupleType) do setPlaceType4(place1 as tIdeasType,myConnector.name);
                if myConnector.stereotype = 'place5Type' then with (place2 as tIdeasTupleType) do setPlaceType5(place1 as tIdeasType,myConnector.name);
              end else m_Control.AddError('-ERROR: Tuple Place Type does not connect to a Type between ' + place1.rdfID + ' and ' + place2.rdfID);
            end else m_Control.AddError('-ERROR: Tuple Place Type does not connect from a TupleType between ' + place1.rdfID + ' and ' + place2.rdfID);
          end;
        end;



        //*********************Aggregation****************************//
        if myConnector.type = 'Aggregation' then
        begin
          if (place1 is tIdeasIndividual) and (place2 is tIdeasIndividual) then
          begin


          end else m_Control.AddError('-ERROR: wholePart does not connect from two individuals between ' + place1.rdfID + ' and ' + place2.rdfID);
        end;

        //*********************Dependency****************************//
        if myConnector.type = 'Dependency' then
        begin
          if (place1 is tIdeasType) then
          begin
            if myConnector.stereotype = 'typeInstance' then myTypeInstance := tIdeastypeInstance.create(place2.rdfID + 'InstanceOf' + place1.rdfID,ideasSession, myConnector.created);
            if myConnector.stereotype = 'nameTypeInstance' then
            begin
              myTypeInstance := tIdeasnameTypeInstance.create(place2.rdfID + 'InstanceOf' + place1.rdfID,ideasSession, myConnector.created);
            end;
            if myConnector.stereotype = 'powertypeInstance' then
            begin
              myTypeInstance := tIdeaspowertypeInstance.create(place2.rdfID + 'InstanceOf' + place1.rdfID,ideasSession, myConnector.created);
              //if reversed place1=client else place1=ideasSession
              if reversed and (client.stereotypeEX <> 'Powertype') then
              begin
                m_Control.AddError('-WARNING: ' + client.name + ' should be a Powertype');
                client.stereotypeEX := 'Powertype';
                client.update;
              end;
              if (not reversed) and (supplier.stereotypeEX <> 'Powertype') then
              begin
                m_Control.AddError('-WARNING: ' + supplier.name + ' should be a Powertype');
                supplier.stereotypeEX := 'Powertype';
                supplier.update;
              end;
            end;
            if myTypeInstance = nil then m_Control.AddError('-ERROR: Dependency used with no stereotype between ' + place2.rdfID + ' and ' + place1.rdfID)
              else
            begin
              if place1 is tExternalResource then myTypeInstance.setExternalRefProperty('ideasf:type', place1 as tExternalResource) else myTypeInstance.setType(place1 as tIdeasType);
              if place2 is tExternalResource then myTypeInstance.setExternalRefProperty('ideasf:instance', place2 as tExternalResource) else  myTypeInstance.setInstance(place2 as tIdeasThing);
            end;
          end else m_Control.AddError('-ERROR: Type end is not an ideas Type in Dependency between ' + place1.rdfID + ' and ' + place2.rdfID);
        end;
      end;
    end;
  //  if debug then ideasSession.saveAs('c:\Development\test.rdf')
 //   else
    begin
      if SaveDialog1 = nil then
      begin
        SaveDialog1 := tSaveDialog.create(nil);
        SaveDialog1.Title := 'Save RDF';
        SaveDialog1.DefaultExt := '*.rdf';
        SaveDialog1.Filter := 'RDF Files|*.rdf|All Files|*.*';
      end;
      if SaveDialog1.execute then
      begin
        ideasSession.saveAs(saveDialog1.FileName);
      end;
    end;
  end;  
end;

function TAddin.CompactAndRepair(DB: string): Boolean; {DB = Path to Access Database}
var
  v: OLEvariant;
begin
  Result := True;
  try
    v := CreateOLEObject('JRO.JetEngine');
    try
      V.CompactDatabase('Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+DB,
                        'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+DB+'x;Jet OLEDB:Engine Type=5');
      DeleteFile(DB);
      RenameFile(DB+'x',DB);
    finally
      V := Unassigned;
    end;
  except
    Result := False;
  end;
end;




procedure TAddin.setFoundationStuff(element : oleVariant; stereotype : string);
var
  connectors : oleVariant;
  subElement, myConnector, client, supplier : oleVariant;
  i: Integer;
begin
  m_Control.AddError('-INDIVIDUAL: Processing: ' + element.name);
  connectors := element.connectors;
  m_Control.AddError('  ' + vartostr(connectors.Count) + ' connectors');
  if connectors.Count >0 then
  for i := 0 to connectors.Count - 1 do
  begin
    myConnector := connectors.getAt(i);
    client := rep.GetElementByID(myConnector.clientID);
    supplier := rep.GetElementByID(myConnector.supplierID);
    if myConnector.type = 'Generalization' then
    begin
      m_Control.AddError('  Supertype of: ' + client.name);
      if client.stereotype <> stereotype then
      begin
        m_Control.AddError('  -WARNING: Stereotype of ' + client.name + ' was ' + client.stereotype + ' now: ' + stereotype);
        myConnector.stereotype := stereotype;
        myConnector.update;
      end;
      if myConnector.stereotype <> 'superSubtype' then
      begin
        myConnector.stereotype := 'superSubtype';
        myConnector.update;
        m_Control.AddError('-WARNING: Generalisation from ' + supplier.name + ' to ' + client.name + ' had not stereotype');
      end;
      if client.elementID <> element.elementID then setFoundationStuff(client,stereotype);
    end;
  end;
end;


procedure TAddIn.setElementStereotype(element : oleVariant; stereotype : string; recurseSubtypes : boolean);
var
  i : integer;
  subtype, connector : oleVariant;
begin
  m_Control.AddError('-setting stereotype of ' + element.name + ' to <<' + stereotype + '>>');
  element.stereotypeEx := stereotype;
  element.update;
  if recurseSubtypes and element.connectors.count > 0 then
  for i := 0 to element.connectors.Count - 1 do
  begin
    connector := element.connectors.getAt(i);
    if connector.type = 'Generalization' then
    begin
      subtype := rep.GetElementByID(connector.clientID);
      if subtype.ElementID <> element.ElementID then setElementStereotype(subtype,stereotype,recurseSubtypes);
    end;
  end;
end;


procedure TAddin.IAddIn_addGUIDs;
begin

end;

procedure TAddin.diagsToIdeas;
var
  diags : iDualCollection;
  myDiag : olevariant;
  i: Integer;
begin
  m_control.AddError('setting query');
  diags := rep.GetElementsByQuery('GetDiagsByName','*');
  m_control.AddError('query set - count = ' + vartostr(diags.Count));
  if diags.Count > 0 then
  for i := 0 to diags.Count - 1 do
  begin
    myDiag := diags.GetAt(i);
    m_control.AddError(vartostr(i));
    m_control.AddError(myDiag.Name + ' - ' + myDiag.MetaType);
  end;
end;


procedure TAddin.exportXSD;
begin
  //does the XSD export form exist ? If not, create it.
  if form3 = nil then
  begin
    form3 := tForm3.create(nil);
    form3.rep := rep;
  end;
  //if this procedure has been called, the user has clicked on a package, so SelPackGUID is set
  form3.selPackage := rep.GetPackageByGUID(selPackGUID);
  //Get all the naming schemes present in the whole EA model (not just the package selected)
  //Set caption etc. on export form
  form3.Caption := 'Export ' + form3.selPackage.Name + ' to XML Schema';
  form3.Edit1.Text := 'http://www.ideasgroup.org/' + form3.selPackage.Name;
  //Add the naming schemes to the form
  populateComboWithNS(rep,form3.combobox1,'IDEASName');
  //clear the progress report memo on the export form
  form3.Memo1.Lines.Clear;
  //show the form
  form3.show;
end;

procedure TAddin.exportOracle;
var
  NamingSchemes : iDualCollection;
  myNS : iDualElement;
  defaultNS : string;
  i : integer;
begin
  NamingSchemes := rep.GetElementsByQuery('findByST','IDEAS:NamingScheme');
  if form2 = nil then
  begin
    form2 := tForm2.create(nil);
    form2.rep := rep;
  end;
  //if this procedure has been called, the user has clicked on a package, so SelPackGUID is set
  form2.selPackage := rep.GetPackageByGUID(selPackGUID);
  defaultNS := getTaggedValue(form2.selPackage.Element,'defaultNamingScheme');
  form2.Caption := 'Export Oracle DDL for '+ form2.selPackage.Name;
  form2.Edit1.Text := form2.selPackage.Name;
  form2.Edit2.Text := getTaggedValue(form2.selPackage.Element,'baseURL');
  form2.Memo3.Lines.Clear;
  if NamingSchemes.Count > 0 then
  for i := 0 to NamingSchemes.Count - 1 do
  begin
    myNS := NamingSchemes.GetAt(i) as iDualElement;
    form2.combobox1.items.add(myNS.Name);
    if myNS.Name = defaultNS then form2.combobox1.itemIndex := i;
  end;
  if form2.Edit2.Text = '' then showmessage('Model URL not set for package') else form2.show;
end;



procedure TAddin.exportAccess(newDB : boolean);
var
  NamingSchemes : iDualCollection;
  myNS : iDualElement;
  i, itemindex : integer;
  myHolder : tElemHolder;
begin
  if form5 = nil then
  begin
    form5 := tForm5.create(nil);
    form5.rep := rep;
  end;
  form5.selPackage := rep.GetPackageByGUID(selPackGUID);
  if form5.selPackage.Element.Stereotype = 'IDEAS:Model' then
  begin
    form5.defaultNS := '';
    form5.defaultNS := getTaggedValue(form5.selPackage.Element,'defaultNamingScheme');
    form5.Caption := 'Export ' + form5.selPackage.Name + ' to IDEAS Database';
    form5.Edit1.Text := form5.selPackage.Name;
    form5.Memo1.Lines.Clear;
    populateComboWithNS(rep,form5.ComboBox1,form5.defaultNS);
    form5.newDb := newDB;
    form5.Edit2.Text := getTaggedValue(form5.selPackage.Element,'baseURL');
    NamingSchemes := rep.GetElementsByQuery('findByST','IDEAS:NamingScheme');
    if (form5.Edit2.Text = '') or (form5.defaultNS = '') then
    begin
      if (form5.Edit2.Text = '') then showmessage('Error - This IDEAS Model has no Base URL Set');
      if (form5.defaultNS = '') then showmessage('Error - This IDEAS Model has no Default Naming Scheme');
      if form11 = nil then
      begin
        form11 := tForm11.create(nil);
        form11.rep := rep;
        form11.Caption := 'IDEAS Model';
      end;
      populateComboWithNS(rep,form11.ComboBox1,'');
      form11.Edit2.Text := form5.Edit2.Text;
      form11.ComboBox1.Clear;
      itemindex := -1;
      form11.ShowModal;
      form5.Edit1.Text := form5.selPackage.Name;
      form5.Edit2.text := form11.Edit1.Text;
      form5.defaultNS := form11.ComboBox1.Text;
    end;
    if form5.defaultNS = '' then form5.Memo1.Lines.add('No default NamingScheme found for this model')
    else
    begin
      NamingSchemes := rep.GetElementsByQuery('findByST','IDEAS:NamingScheme');
      if  (NamingSchemes.Count > 0) then
      for i := 0 to NamingSchemes.Count - 1 do
      begin
        myNS := NamingSchemes.GetAt(i) as iDualElement;
        myHolder := tElemHolder.Create(rep,myNS);
        form5.combobox1.items.addObject(myNS.Name, myHolder);
      end;
      if  (NamingSchemes.Count > 0) then
      for i := 0 to NamingSchemes.Count - 1 do
      begin
        myNS := NamingSchemes.GetAt(i) as iDualElement;
        myHolder := tElemHolder.Create(rep,myNS);
        form5.combobox1.items.addObject(myNS.Name, myHolder);
      end;
      form5.ComboBox1.Sorted := true;
      if form5.defaultNS = '' then form5.defaultNS := 'IDEASName';
      form5.ComboBox1.ItemIndex := form5.ComboBox1.Items.IndexOf(form5.defaultNS);
      form5.show;
    end;
  end else showmessage('Package is not an <<IDEAS:Model>>');
end;

procedure TAddin.exportExcel(package : iDualPackage);
var
  elements, supers, errors : tstringlist;
  i,code, testCol, id : integer;
  xmlStr, p1, p2, m3 : string;
  partOf, typPartOf, subtypeOf, instanceOf, superComma : wideString;
  holder : tElemHolder;
  connectors, superConnectors : iDualCollection;
  myConn, superConn : iDualConnector;
  connectedElem, supertype : iDualElement;
  j,k,l, index : Integer;
begin
  elements := tStringList.Create;
  errors := tStringList.Create;
  getElementsInPackage(package,elements,'',rep,true,errors,nil);

  if elements.Count > 0 then
  begin
    oXL := CreateOleObject('Excel.Application');

    // Get a new workbook
    oWB := oXL.Workbooks.Add;
    oSheet := oWB.ActiveSheet;
    oSheet.Rows[1].font.bold := true;
    oSheet.Rows[1].interior.color := 0;
    oSheet.Rows[1].font.color := 16777215;
    oSheet.Cells[1,1] := 'Name';
    oSheet.Cells[1,2] := 'GUID';
    oSheet.Cells[1,3] := 'Category';
    oSheet.Cells[1,4] := 'Description';
    oSheet.Cells[1,5] := 'Part Of';
    oSheet.Cells[1,6] := 'Subtype Of';
    oSheet.Cells[1,7] := 'Instance Of';
    oSheet.Cells[1,8] := 'place1Type';
    oSheet.Cells[1,9] := 'place2Type';
    oSheet.Columns[4].Autofit;
    oSheet.Columns[5].Autofit;
    oSheet.Columns[6].Autofit;
    oSheet.Columns[7].Autofit;
    for i := 0 to elements.Count - 1 do
    begin
      holder := elements.Objects[i] as tElemHolder;
      if holder.element.type_ = 'Class' then
      begin
        oSheet.Cells[i+2,1] := holder.name;
        oSheet.Cells[i+2,1].font.bold := true;
        oSheet.Cells[i+2,1].borderaround;
        oSheet.Cells[i+2,2] := holder.GUID;
        oSheet.Cells[i+2,2].borderaround;
        oSheet.Cells[i+2,3] := stringreplace(holder.st,'IDEAS:','',[rfReplaceAll]);
        oSheet.Cells[i+2,3].borderaround;
        oSheet.Cells[i+2,4] := holder.element.Notes;
        oSheet.Cells[i+2,4].borderaround;
        xmlStr := Rep.SQLQuery('SELECT Backcolor FROM t_object WHERE Object_ID = ' + vartostr(holder.id) + ';');
        xmlStr := RightStr(xmlStr,length(xmlStr) - pos('<Backcolor>',xmlStr)-10);
        xmlStr := LeftStr(xmlStr,pos('</Backcolor>',xmlStr)-1);
        val(xmlStr,testCol,code);
        if code = 0 then oSheet.Rows[i+2].interior.color := testCol;
        xmlStr := Rep.SQLQuery('SELECT Fontcolor FROM t_object WHERE Object_ID = ' + vartostr(holder.id) + ';');
        xmlStr := RightStr(xmlStr,length(xmlStr) - pos('<Fontcolor>',xmlStr)-10);
        xmlStr := LeftStr(xmlStr,pos('</Fontcolor>',xmlStr)-1);
        val(xmlStr,testCol,code);
        if code = 0 then oSheet.Rows[i+2].font.color := testCol;


        partOf := '';
        p1 := '';
        p2 := '';
        subtypeOf := '';
        instanceOf := '';
        connectors := holder.element.Connectors;
        m3 := '';
        superComma := holder.element.GetRelationSet(rsGeneralizeStart);

        if supers = nil then supers := tStringList.Create;
        supers.CommaText := superComma;
        supers.Sorted := true;
        if supers.Count > 0 then
        for j := 0 to supers.Count - 1 do
        begin
          val(supers[j],id,code);
          if code = 0 then
          begin
            supertype := rep.GetElementByID(id);
            if (supertype.Name = 'Resource') and (m3='') then m3:='ResourceType';
            if (supertype.Name = 'Organization') and ((m3='') or (m3='ResourceType')) then m3:='OrganisationType';
            if supertype.Name = 'Role' then m3:='RoleType';
            if supertype.Name = 'PostState' then m3:='PostType';
            if supertype.Name = 'Artefact' then m3:='Artefact';
            if supertype.Name = 'Software' then m3:='Software';
            if supertype.Name = 'GeoPoliticalArea' then m3:='LocationType';
            if supertype.Name = 'Process' then m3:='Function';
            if supertype.Name = 'Sign' then m3:='InformationElement';

          end;
        end;
        supers.Sorted := false;
        freeandnil(supers);


        if connectors.Count > 0 then
        for j := 0 to connectors.Count - 1 do
        begin
          myConn := connectors.GetAt(j) as iDualConnector;
          if (myConn.ClientID = holder.element.ElementID) then
          begin
            connectedElem := rep.GetElementByID(myConn.SupplierID);
            if myConn.Stereotype = 'IDEAS:wholePart' then
            begin
              if partOf <> '' then partOf := partOf + ', ';
              partOf := partOf + connectedElem.Name;
            end;
            if myConn.Stereotype = 'IDEAS:superSubtype' then
            begin
              if subtypeOf <> '' then subtypeOf := subtypeOf + ', ';
              subtypeOf := subtypeOf + connectedElem.Name;
            end;
            if (myConn.Stereotype = 'IDEAS:typeInstance') or (myConn.Stereotype = 'IDEAS:powertypeInstance') then
            begin
              if instanceOf <> '' then instanceOf := instanceOf + ', ';
              instanceOf := instanceOf + connectedElem.Name;
              if connectedElem.Name = 'PostState' then m3:='ActualPost';
              if connectedElem.Name = 'Organization' then m3:='ActualOrganisation';
              if connectedElem.Name = 'GeoPoliticalArea' then m3:='ActualLocation';
              if connectedElem.Name = 'Standard' then m3:='Standard';
              if m3 = '' then
              begin
                superComma := connectedElem.GetRelationSet(rsGeneralizeStart);
                if supers = nil then supers := tStringList.Create;
                supers.Sorted := true;
                supers.CommaText := superComma;
                for k := 0 to supers.Count - 1 do
                begin
                  val(supers[k],id,code);
                  if code = 0 then
                  begin
                    supertype := rep.GetElementByID(id);
                    if (supertype.Name = 'Organization') and (m3='') then m3:='ActualOrganisation';
                    if supertype.Name = 'PostState' then m3:='ActualPost';
                    if supertype.Name = 'GeoPoliticalArea' then m3:='ActualLocation';
                    if supertype.Name = 'Standard' then m3:='Standard';
                  end;
                end;
                supers.Sorted := false;
                freeandnil(supers);
              end;
            end;
            if (myConn.Stereotype = 'place1Type') then p1 := connectedElem.Name;
            if (myConn.Stereotype = 'place2Type') then p2 := connectedElem.Name;
            if (holder.element.Stereotype = 'IDEAS:TupleType') and ((p1='') or (p2='')) then
            begin
              k := 0;
              superComma := holder.element.GetRelationSet(rsGeneralizeStart);
              if supers = nil then supers := tStringList.Create;
              supers.CommaText := superComma;
     //         showmessage('super count = ' + vartostr(supers.Count));
              while (supers.Count > 0) and (p1='') and (k < supers.Count) do
              begin
              //    showmessage('tuple types: k=' + vartostr(k));
                val(supers[k],id,code);
                if code = 0 then
                begin
                  supertype := rep.GetElementByID(id);
                  if supertype.Stereotype = 'IDEAS:TupleType' then
                  begin
                    superConnectors := supertype.Connectors;
                    if superConnectors.Count > 0 then
                    for l := 0 to superConnectors.Count - 1 do
                    begin
                      superConn := superConnectors.GetAt(l) as iDualCOnnector;
                      if (superConn.Stereotype = 'place1Type') and (p1='') then p1 := rep.GetElementByID(superConn.SupplierID).Name;
                      if (superConn.Stereotype = 'place2Type') and (p2='') then p2 := rep.GetElementByID(superConn.SupplierID).Name;

                    end;
                  end;
                end;
                k := k + 1;
              end;
            end;
          end;
       {   if (myConn.SupplierID = holder.element.ElementID) then
          begin
            connectedElem := rep.GetElementByID(myConn.ClientID);
            if (myConn.Stereotype = 'place2Type') and (connectedElem.Stereotype = 'IDEAS:TupleType') and (myConn.Name = 'part') then
            begin
             onwardConnectors := holder.element.Connectors;
             if onwardConnectors.Count > 0 then
             for k := 0 to onwardConnectors.Count - 1 do
             begin
               onwardConn := onwardConnectors.GetAt(k) as iDualConnector;
               if (onwardConn.ClientID = connectedElem.ElementID) and (onwardConn.Stereotype = 'place1Type') then
               begin
                 onwardConnectedElem := rep.GetElementByID(onwardConn.SupplierID);
                 typPartOf := onwardConnectedElem.Name;
               end;
             end;

            end;
          end;  }
        end;
        oSheet.Cells[i+2,5] := partOf;
        oSheet.Cells[i+2,6] := subtypeOf;
        oSheet.Cells[i+2,7] := instanceOf;
        oSheet.Cells[i+2,8] := p1;
        oSheet.Cells[i+2,9] := p2;
    //    oSheet.Cells[i+2,10] := m3;

      end;
    end;
    oSheet.Columns[1].Autofit;
    oSheet.Columns[2].Autofit;
    oXL.Visible := True;

  end;
end;



function TAddin.EA_OnPostNewConnector(const Repository, Info: IDispatch): WordBool;
var
  connector : iDualConnector;
  eps : iEventProperties;
  ep : iEventProperty;
  clientElem, supplierElem : iDualElement;
  myArse : iDualConnectorEnd;
  st : string;
begin
  eps := Info as iEventProperties;
  ep := eps.Get(0) as iEventProperty;
  connector := rep.GetConnectorByID(ep.Value);
  st := connector.Stereotype;
  if (leftstr(st,5) = 'IDEAS:') or (leftstr(st,5) = 'place') or (leftstr(st,10) = 'tuplePlace') then
  begin
    if pos('lace',st) > 0 then
    begin
      myArse := connector.ClientEnd; //source
      myArse.Cardinality := '0..*';
      myArse.Update;
      myArse := connector.SupplierEnd; //source
      myArse.Cardinality := '1';
      myArse.Update;
      connector.Update;
    end;
    connector.Direction := 'Source -> Destination';
    connector.Update;
    clientElem := rep.GetElementByID(connector.ClientID);
    supplierElem := rep.GetElementByID(connector.SupplierID);
  end;
end;

function TAddin.EA_OnPostNewElement(const Repository, Info: IDispatch): WordBool;
var
  element : iDualElement;
  id : integer;
  eps : iEventProperties;
  myConn : iDualConnector;
  ep : iEventProperty;
  st, noteStr : string;
  i : integer;
  myHolder : tElemHolder;
  supers, pts : tStringList;
  NS, packageST : string;
  package, ideasPackage : iDualPackage;
begin
  rep.SuppressEADialogs := true;
  eps := Info as iEventProperties;
  ep := eps.Get(0) as iEventProperty;
  element := rep.GetElementByID(ep.Value);
  package := rep.GetPackageByID(element.PackageID);
  packageST := package.element.stereotype;
  st := element.Stereotype;
  if pos('IDEAS:',st) > 0 then
  begin
    ideasPackage := getIdeasPackageForPackage(package, rep);
    if ideasPackage = nil then ideasPackage := package;

    NS := getDefaultNamingSchemeNameForElement(element,rep);
    if (NS = '') then
    begin
      if form11 = nil then
      begin
        form11 := tForm11.Create(nil);
      end;
      form11.rep := rep;
      form11.Edit1.Text := ideasPackage.Name;
      form11.package := ideasPackage;
      form11.parentPackage := nil;
      form11.Caption := 'IDEAS Model is not correctly set up';
      form11.Edit2.Text := gettaggedvalue(element,'baseURL');
      populateComboWithNS(rep,form11.combobox1,'');
      if NS <> '' then
      begin
        form11.ComboBox1.ItemIndex := form11.ComboBox1.items.indexOf(NS);
        if form11.ComboBox1.ItemIndex <> -1 then form11.ComboBox1.Text := NS;
      end else form11.ComboBox1.ItemIndex := -1;
      form11.ShowModal;

      NS := getDefaultNamingSchemeNameForElement(element,rep);
    end;
    if form6 = nil then
    begin
      form6 := tForm6.Create(nil);
    end;
    form6.rep := rep;
    form6.defaultNS := NS;
    form6.element := element;
    form6.originalName := element.Name;
    if element.Abstract = '1' then form6.CheckBox1.Checked := true else form6.CheckBox1.Checked := false;
    form6.ActiveControl := form6.edit1;
    form6.Edit1.SelectAll;
    form6.ShowModal;
    setElementDefaultStyle(element);
  end;// else rep.SuppressEADialogs := false;
end;

function TAddin.EA_OnPreNewElement(const Repository, Info: IDispatch): WordBool;
begin
  EA_OnPreNewElement := true;
end;



procedure tAddIn.setElementDefaultStyle(element: IDualElement);
var
  ideasType : string;
begin
    ideasType := element.Stereotype;
    if ideasType = 'IDEAS:Individual' then
    begin
      element.SetAppearance(1,0,5263440);        //0x505050
      element.SetAppearance(1,1,16777215);       //0xFFFFFF
    end;
    if ideasType = 'IDEAS:Type' then  element.SetAppearance(1,0,16764057);       //0xFFCC99
    if ideasType = 'IDEAS:IndividualType' then element.SetAppearance(1,0,6008319);       //0x5BADFF
    if ideasType = 'IDEAS:TupleType' then element.SetAppearance(1,0,13434828);       //0xCCFFCC
    if ideasType = 'IDEAS:Powertype' then element.SetAppearance(1,0,16751052);       //0xFF99CC
    if (ideasType = 'IDEAS:NameType') or (ideasType = 'IDEAS:NamingScheme') or (ideasType = 'IDEAS:UniqueNamingScheme') or (ideasType = 'IDEAS:NameSpace') then
    begin
      element.SetAppearance(1,0,65535);       //0x00FFFF
    end;
    if ideasType = 'IDEAS:Name' then element.SetAppearance(1,0,10092287);       //0x99FEFF
    element.Update;
end;

procedure tAddIn.MoveSelectedToDiagPackage;
var
  i: Integer;
  myDO : iDualDiagramObject;
  myElem : iDualElement;
begin
  if rep.GetCurrentDiagram.SelectedObjects.Count > 0 then
  for i := 0 to rep.GetCurrentDiagram.SelectedObjects.Count - 1 do
  begin
    myDo := rep.GetCurrentDiagram.SelectedObjects.GetAt(i) as iDualDiagramObject;
    myElem := rep.GetElementByID(myDo.ElementID);
    myElem.PackageID := rep.GetCurrentDiagram.PackageID;
    myElem.Update;
  end;
  rep.ReloadDiagram(rep.GetCurrentDiagram.DiagramID);
end;

procedure tAddIn.setSmallest;
var
  myDiag : iDualDiagram;
  myDO : iDualDiagramObject;
  i, smallest : Integer;
begin
  smallest := 0;
  myDiag := rep.GetCurrentDiagram;
  rep.SaveDiagram(myDiag.DiagramID);
  if myDiag.SelectedObjects.Count > 0 then
  for i := 0 to myDiag.SelectedObjects.Count - 1 do
  begin
    myDO := myDiag.SelectedObjects.GetAt(i) as iDualDiagramObject;
    if smallest = 0 then smallest := myDo.bottom - myDo.top
    else if (myDo.bottom - myDo.top) > smallest then smallest := myDo.bottom - myDo.top;
  end;
  if (myDiag.SelectedObjects.Count > 0) and (smallest <> 0) then
  for i := 0 to myDiag.SelectedObjects.Count - 1 do
  begin
    myDO := myDiag.SelectedObjects.GetAt(i) as iDualDiagramObject;
    myDo.bottom := myDo.top + smallest;
    myDo.Update;
    rep.AdviseElementChange(myDo.ElementID);
  end;
  rep.ReloadDiagram(myDiag.DiagramID);
end;

procedure TAddin.individualType;
var
  selected : iDispatch;
  element, package : oleVariant;
  i : integer;
  elements : iDualCollection;
begin
{    elements := rep.GetElementsByQuery('findName','tuple');
    if elements.Count = 1 then
    begin
      setFoundationStuff(elements.GetAt(0),'TupleType');
    end else showmessage('Found ' + varToStr(elements.Count) + ' elements called "tuple"');  }
end;



function TAddin.EA_OnContextItemDoubleClicked(const Repository: IDispatch; const GUID: WideString;
          ot: OleVariant): WordBool;
var
  element : iDualElement;
  id : integer;
  eps : iEventProperties;
  myConn : iDualConnector;
  ep : iEventProperty;
  st,ns : string;
  i : integer;
  myHolder : tElemHolder;
  package : iDualPackage;
begin
  EA_OnContextItemDoubleClicked := false;
  if ot = otElement then
  begin
    element := rep.GetElementByGuid(GUID) as iDualElement;
    if form6 = nil then
    begin
      form6 := tForm6.Create(nil);
    end;
    form6.rep := rep;
    form6.originalName := element.Name;

    st := element.Stereotype;
    if pos('IDEAS:',st) > 0 then
    begin
      EA_OnContextItemDoubleClicked := true;
      form6.defaultNS := getDefaultNamingSchemeNameForElement(element,rep);
      form6.element := element;
      if element.Abstract = '1' then form6.CheckBox1.Checked := true else form6.CheckBox1.Checked := false;
      form6.ActiveControl := form6.edit1;
      form6.Edit1.SelectAll;
      if not form6.showing then form6.ShowModal else form6.BringToFront;
    end;
  end else
  if ot = otPackage then
  begin
    package := rep.GetPackageByGuid(GUID) as iDualPackage;
    if form11 = nil then
    begin
      form11 := tForm11.Create(nil);
    end;
    ns := getTaggedValue(package.Element,'defaultNamingScheme');
    populateComboWithNS(rep,form11.ComboBox1,ns);
    st := package.element.Stereotype;
    if pos('IDEAS:Model',st) > 0 then
    begin
      EA_OnContextItemDoubleClicked := true;
      form11.Caption := 'Editing ' + package.Name;
      form11.rep := rep;
      form11.package := package;
      form11.parentPackage := nil;
      form11.Edit1.Text := package.Name;
      form11.Edit2.Text := getTaggedvalue(package.Element,'baseURL');
  //    form11.ComboBox1.Text := ns;
      form11.RadioButton1.Checked := true;
      form11.RadioButton2.Checked := false;
      form11.RadioButton2.visible := false;
      form11.edit3.visible := false;
      form11.Show;
    end;
  end;
end;





initialization
  TAutoObjectFactory.Create(ComServer, TAddIn, Class_AddIn,
    ciMultiInstance, tmApartment);
end.
