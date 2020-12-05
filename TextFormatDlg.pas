(* RPlot dialog
   Insert plot formatted text

   © J. Rathlev, D-24222 Schwentinental, (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Jul. 2012
   last modified December 2020
   *)

unit TextFormatDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, RPlotObjects, RPlotUtils;

type
  TTextFormatDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    rgFormat: TRadioGroup;
    edText: TLabeledEdit;
    bbCharTab: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure rgFormatClick(Sender: TObject);
    procedure bbCharTabClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    function Execute (APos : TPoint; var fs : string) : boolean;
  end;

function EditTextFormat (APos : TPoint; var fs : string) : boolean;

var
  TextFormatDialog: TTextFormatDialog;

implementation

{$R *.dfm}

uses GnuGetText, CharTableDlg, WinUtils;

procedure TTextFormatDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TTextFormatDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TTextFormatDialog.rgFormatClick(Sender: TObject);
begin
  edText.SetFocus;
  end;

procedure TTextFormatDialog.bbCharTabClick(Sender: TObject);
var
  c : char;
begin
  c:=CharFromTable (TopRightPos(bbCharTab),edText.Font.Name);
  if c>#0 then with edText do begin
    SelText:=c; SetFocus;
    end;
  end;

function TTextFormatDialog.Execute (APos : TPoint; var fs : string) : boolean;
var
  c : char;
begin
  if APos.X<0 then Position:=poScreenCenter
  else with APos do begin
    Position:=poDesigned;
    if X<0 then X:=Left;
    if Y<0 then Y:=Top;
    y:=Y-Height;
    CheckScreenBounds(Screen,x,y,Width,Height);
    Left:=x; Top:=y;
    end;
  edText.Text:=fs;
  Result:=ShowModal=mrOK;
  if Result then begin
    c:=FormatMarker[TFormatType(rgFormat.ItemIndex)];
    if c=#0 then fs:=edText.Text else fs:=c+edText.Text+c;
    end;
  end;

function EditTextFormat (APos : TPoint; var fs : string) : boolean;
begin
  if not assigned(TextFormatDialog) then TextFormatDialog:=TTextFormatDialog.Create(Application);
  Result:=TextFormatDialog.Execute(APos,fs);
  FreeAndNil(TextFormatDialog);
  end;

end.
