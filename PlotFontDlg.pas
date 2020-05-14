(* RPlot dialog
   Select a text font

   © J. Rathlev, D-24222 Schwentinental, (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Jul. 2012
   last modified January 2020
   *)

unit PlotFontDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs,
  RPlotObjects, RPlotUtils;

type
  TPlotFontDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    lbFonts: TListBox;
    cbBold: TCheckBox;
    cbItalic: TCheckBox;
    edPreview: TEdit;
    ColorDialog: TColorDialog;
    bbColor: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bbColorClick(Sender: TObject);
    procedure lbFontsClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure UpdateView;
  public
    { Public-Deklarationen }
    function Execute (APos : TPoint; var APlotFont : TPlotFont) : boolean;
  end;

function EditPlotFont (APos : TPoint; var APlotFont : TPlotFont) : boolean;

var
  PlotFontDialog: TPlotFontDialog;

implementation

{$R *.dfm}

uses GnuGetText, WinUtils;

{ ------------------------------------------------------------------- }
function EnumFontsProc(var EnumLogFont: TEnumLogFont; var TextMetric: TNewTextMetric;
           FontType: Integer; Data: LPARAM): Integer; stdcall;
var
   FontName: string;
   lb      : TListBox;
begin
  lb:=TListBox(Data);
  FontName:=StrPas(EnumLogFont.elfLogFont.lfFaceName);
  if (lb.Items.IndexOf(FontName)<0) and (FontType=TRUETYPE_FONTTYPE)
    and (ord(TextMetric.tmCharSet)=ANSI_CHARSET) and (copy(FontName,1,1)<>'@') then
    lb.Items.AddObject(FontName,pointer(EnumLogFont.elfLogFont.lfPitchAndFamily));
  Result:=1;
  end;

function GetFontType (lfQuality : byte) : TFontType;
begin
  if lfQuality and $FC = FF_ROMAN then Result:=ftRoman
  else if (lfQuality and $FC = FF_MODERN) or (lfQuality and 3 = FIXED_PITCH) then Result:=ftFixed
  else Result:=ftSwiss;
  end;

{ ------------------------------------------------------------------- }
procedure TPlotFontDialog.FormCreate(Sender: TObject);
var
  dc : HDC;
  lf : TLogFont;
begin
  TranslateComponent(self);
  // Build font list
  dc:=GetDC(0);
  with lf do begin
    lfCharset:=DEFAULT_CHARSET; lfFaceName:=''; lfPitchAndFamily:=0;
    end;
  try
    EnumFontFamiliesEx(dc,lf,@EnumFontsProc,LongInt(lbFonts),0);
  finally
    ReleaseDC(0,dc);  { release device context }
    end;
  end;

procedure TPlotFontDialog.lbFontsClick(Sender: TObject);
begin
  UpdateView;
  end;

procedure TPlotFontDialog.UpdateView;
var
  s : string;
begin
  with lbFonts do s:=Items[ItemIndex];
  with edPreview do begin
    with Font do begin
      Name:=s;
      Color:=bbColor.Tag;
      Style:=[];
      if cbBold.Checked then Style:=Style+[fsBold];
      if cbItalic.Checked then Style:=Style+[fsItalic];
      end;
    Text:='The quick brown fox jumps ..';
    end;
  end;

procedure TPlotFontDialog.bbColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbColor.Tag;
    if Execute then begin
      bbColor.Tag:=Color;
      UpdateView;
      end;
    end;
  end;

function TPlotFontDialog.Execute (APos : TPoint; var APlotFont : TPlotFont) : boolean;
var
  i : integer;
begin
  if APos.X<0 then Position:=poScreenCenter
  else with APos do begin
    Position:=poDesigned;
    if X<0 then X:=Left;
    if Y<0 then Y:=Top;
    CheckScreenBounds(Screen,x,y,Width,Height);
    Left:=x; Top:=y;
    end;
  with APLotFont do begin
    i:=lbFonts.Items.IndexOf(FontName);
    if i<0 then i:=lbFonts.Items.IndexOf(defFontName);
    lbFonts.ItemIndex:=i;
    bbColor.Tag:=FontColor;
    cbBold.Checked:=fsBold in FontStyle;
    cbItalic.Checked:=fsItalic in FontStyle;
    ColorDialog.CustomColors.CommaText:=UserColors;
    Result:=ShowModal=mrOK;
    UserColors:=ColorDialog.CustomColors.CommaText;
    if Result then begin
      with lbFonts do FontName:=Items[ItemIndex];
      FontColor:=bbColor.Tag;
      FontStyle:=[];
      if cbBold.Checked then Include(FontStyle,fsBold);
      if cbItalic.Checked then Include(FontStyle,fsItalic);
      with lbFonts do FontType:=GetFontType(byte(Items.Objects[ItemIndex]));
      end;
    end;
  end;

function EditPlotFont (APos : TPoint; var APlotFont : TPlotFont) : boolean;
begin
  if not assigned(PlotFontDialog) then PlotFontDialog:=TPlotFontDialog.Create(Application);
  Result:=PlotFontDialog.Execute(APos,APlotFont);
  FreeAndNil(PlotFontDialog);
  end;

end.
