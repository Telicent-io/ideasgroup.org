unit diagnosticsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ea_tlb;

type
  TForm15 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    rep : iDualRepository;
    { Public declarations }
  end;

var
  Form15: TForm15;

implementation

{$R *.dfm}

procedure TForm15.Button1Click(Sender: TObject);
begin
  memo1.Clear;
end;

procedure TForm15.Button2Click(Sender: TObject);
begin
  memo1.SelectAll;
  memo1.CopyToClipboard;
end;

procedure TForm15.Button3Click(Sender: TObject);
var
  i : integer;
  mySt: iDualStereotype;
begin
    if rep.Stereotypes.Count > 0 then
    for i  := 0 to rep.Stereotypes.Count - 1 do
    begin
      mySt := rep.Stereotypes.GetAt(i) as iDualStereotype;
      memo1.lines.Add(mySt.Name + ' - ' + mySt.StereotypeGUID);
    end;

end;

procedure TForm15.Button4Click(Sender: TObject);
begin
  close;
end;

end.
