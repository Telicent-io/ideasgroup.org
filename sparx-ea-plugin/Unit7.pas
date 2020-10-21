unit Unit7;

interface

uses
  Windows, Messages, EA_TLB, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EA_Ideas_Lib;

type
  TForm7 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    rep : iDualRepository;
    package : iDualPackage;
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
begin
//  if edit1.Text = '' then showmessage('Must Provide URL')
  if combobox1.ItemIndex < 0 then showmessage('Must Provide default NamingScheme')
  else
  begin
    package.Element.Stereotype := 'IDEAS:Model';
    setTaggedValue(package.Element,'defaultNamingScheme',combobox1.Text);
    setTaggedValue(package.Element,'baseURL',edit1.Text);

    package.Element.Update;
    Close;
  end;
end;

end.
