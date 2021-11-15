(* Delphi date format dialog
   =========================
   
   © J. Rathlev, D-24222 Schwentinental (kontakt(a)rathlev-home.de))

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.
   
   Vers. 1 - June 2020
   last modified: Nov. 2021
   *)

unit DateFormatDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TDateFormatDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    cbDateFormats: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    function Execute (APos : TPoint; var AFormat: string; const UserFormats : string = '') : boolean;
  end;

function SelectDateFormat(APos : TPoint; var AFormat: string; const UserFormats : string = '') : boolean;

var
  DateFormatDialog: TDateFormatDialog;

{ ---------------------------------------------------------------- }
implementation

{$R *.DFM}

uses System.StrUtils, GnuGetText, WinUtils;

var
  IniFileName,SectionName   : string;

const
  nFormats = 15;
  DateFormats : array [0..nFormats-1] of string = ('yyyy-mm-dd','mm-dd',
                          'd.m.yyyy','d.m.yy','dd.mm.yyyy','dd.mm',
                          'd. mmm yyyy','d. mmmm yyyy','d mmm yyyy','d. mmm',
                          'm"/"d"/"yyyy','m"/"d"/"yy','mm"/"dd"/"yyyy',
                          'mmm d yyyy','mmm d');

{ ---------------------------------------------------------------- }
procedure TDateFormatDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TDateFormatDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

{ ---------------------------------------------------------------- }
function TDateFormatDialog.Execute (APos : TPoint; var AFormat: string; const UserFormats : string) : boolean;
var
  i,j1,j2,n : integer;
  sf  : string;
begin
  AdjustFormPosition(Screen,self,APos);
  with cbDateFormats do begin
    Clear; n:=-1;
    if length(UserFormats)=0 then begin // use default formats
      for i:=0 to nFormats-1 do begin
        Items.Add(FormatDateTime(DateFormats[i],Date)+' ('+AnsiReplaceText(DateFormats[i],'"','')+')');
        if AnsiSameText(AFormat,DateFormats[i]) then n:=i;
        end;
      end
    else begin
      j1:=1;
      repeat
        j2:=PosEx(';',UserFormats,j1);
        if j2>0 then begin
          sf:=copy(UserFormats,j1,j2-j1);
          i:=Items.Add(FormatDateTime(sf,Date)+' ('+AnsiReplaceText(sf,'"','')+')');
          if AnsiSameText(AFormat,sf) then n:=i;
          j1:=j2+1;
          end;
        until j2=0;
      end;
    if n>=0 then ItemIndex:=n else ItemIndex:=0;
    end;
  Result:=ShowModal=mrOK;
  if Result then AFormat:=DateFormats[cbDateFormats.ItemIndex];
  end;

function SelectDateFormat(APos : TPoint; var AFormat: string; const UserFormats : string) : boolean;
begin
  if not assigned(DateFormatDialog) then begin
    DateFormatDialog:=TDateFormatDialog.Create(Application);
    end;
  Result:=DateFormatDialog.Execute(APos,AFormat,UserFormats);
  FreeAndNil(DateFormatDialog);
  end;

end.
