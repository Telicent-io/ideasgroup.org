unit UpdateModelForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvSmoothLabel, AdvSmoothProgressBar, StdCtrls;

type
  TUpdateModelForm = class(TForm)
    Edit1: TEdit;
    AdvSmoothProgressBar1: TAdvSmoothProgressBar;
    AdvSmoothLabel1: TAdvSmoothLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateModelForm: TUpdateModelForm;

implementation

{$R *.dfm}

end.
