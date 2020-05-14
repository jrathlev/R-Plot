(* Postscript export for RPlot

   © J. Rathlev, D-24222 Schwentinental, (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Apr. 2012
   last modified January 2020
   *)

unit PsPlot;

interface

uses RPlotObjects, RplotUtils, System.SysUtils, Winapi.Windows,
  System.Types, Vcl.Graphics;

type
  TPsFonts = (pfHelvetica,pfTimes,pfCourier,pfSymbol);
  TPsStyle = (psNormal,psBold,psItalic,psBoldItalic);
  TPsFontNames = array[TPsStyle] of string;

  TPsFont = record
    Index    : TPsFonts;
    Size,Rot : integer;
    Style    : TPsStyle;
    end;

const
  // Windows-Schriftarten ersetzen
  WinFonts : array [TPsFonts] of string =
    ('Arial','Times New Roman','Courier New','Symbol');

  PsFonts : array[TPsFonts] of TPsFontNames =
    (('Helvetica','Helvetica-Bold','Helvetica-Oblique','Helvetica-BoldOblique'),
     ('Times','Times-Bold','Times-Italic','Times-BoldItalic'),
     ('Courier','Courier-Bold','Courier-Oblique','Courier-BoldOblique'),
     ('Symbol','Symbol','Symbol','Symbol'));

type
  TSheetToPs = class (TSheetToPrinter)
  private
    FOutEPS  : boolean;
    FOutFile : TextFile;
    FBitmap  : TBitmap;
    FIsPath  : boolean;
    CurCol      : TColor;     // aktuelle Farbe
    CurWdt      : integer;    // aktuelle Linienbreite
    CurFont,
    NewFont     : TPsFont;    // aktueller Schriftart-Index (s.o.)
    procedure DrawPath;
    procedure SetFont;
    function FontHasChanged : boolean;
  protected
    // Basic routines for output to Postscript
    procedure NewTextFont (AFont : TPlotFont); override;
    procedure NewTextHeight (AHeight : double); override;
    procedure NewTextColor (AColor : TColor); override;
    procedure NewTextStyle (AStyle : TFontStyles); override;
    procedure NewTextRot (Angle : integer); override;
    procedure UseSymbolFont; override;
    function OffsetScale (n : integer) : double; override;

    procedure MovePenTo (APoint : TPoint); override;
    procedure DrawLineTo (APoint : TPoint); override;
    procedure DrawCircle (ACenter : TPoint; Radius : integer; Fill : boolean); override;
    procedure DrawRectangle (ACenter : TPoint; Dist : integer; Fill : boolean);override;
    procedure DrawPolygon (const Points: array of TPoint; Fill : boolean); override;
    procedure FillRectangle (ARect : TRect); override;

    procedure NewLineWidth (wd : integer); override;
    procedure NewLineColor (AColor : TColor); override;
    procedure NewFillColor (AColor : TColor); override;

    procedure BeginTextAt (x,y,dx,dy : double); override;
    procedure OutputText (Pos,Offs : TPoint; const AText : string); override;
    procedure OutputImage (ARect : TRect; AImage : TBitmap); override;


    procedure OpenPostscript (const AFilename : string);
    procedure InitPostscript (Metric : boolean);
    procedure ClosePostScript;
  public
    constructor Create (const AFilename : string; AOutEps : boolean = true);
    destructor Destroy; override;
    procedure InitSheet(ASheet: TSheet); override;
  end;

implementation

uses Eps;

const
{ ------------------------------------------------------------------- }
  // EPS-Header
  psBCm = '%!PS-Adobe-3.0 EPSF-3.0';
  psBbx = '%%%%BoundingBox: 0 0 %u %u';
  psTit = '%%%%Title: %s';
  psDte = '%%%%CreationDate: %s';
  psCre = '%%Creator: RPlot by J. Rathlev';
  psDat = '%%DocumentData: Clean7Bit';
  psLev = '%%%%LanguageLevel: %s';
  psPgs = '%%Pages: 1';
  psECm = '%%EndComments';
  psBPl = '%%BeginProlog';

  psEPl = '%%EndProlog';
  psPage = '%%Page: 0 1';

  pcLnStyle = '1 setlinejoin 1 setlinecap';
  psData   = 'BeginImg';

  psRst = 'showpage currentdict /pgsave get restore end';

type
  TRGBColor = record
  case integer of
  0 : (Color : TColor);
  1 : (R,G,B,T : byte);
  end;

{ ------------------------------------------------------------------- }
function PtToStr (Pt : TPoint) : string;
begin
  with Pt do Result:=IntToStr(X)+' '+IntToStr(Y);
  end;

function NegPt (Pt : TPoint) : TPoint;
begin
  with Result do begin
    x:=-Pt.X; y:=-Pt.Y;
    end;
  end;

function XYToStr (x,y : integer) : string;
begin
  Result:=IntToStr(X)+' '+IntToStr(Y);
  end;

function Intensity (c : byte) : string;
begin
  Result:=FloatToString(c/255,ffFixed,5,3);
  end;

function ColorToStr(AColor : TColor) : string;
begin
  with TRGBColor(AColor) do Result:=Intensity(R)+' '+Intensity(G)+' '+Intensity(B);
  end;

{ ------------------------------------------------------------------- }
constructor TSheetToPs.Create (const AFilename : string; AOutEps : boolean);
begin
  FBitmap:=TBitmap.Create;   // Dummy canvas
  inherited Create (FBitmap.Canvas);
  FOutEps:=AOutEps;
  OpenPostscript(AFilename);
  CurCol:=-1; CurWdt:=-1;
  with NewFont do begin
    Index:=pfHelvetica; Size:=12; Rot:=0; Style:=psNormal;
    end;
  CurFont:=NewFont;
  end;

destructor TSheetToPs.Destroy;
begin
  ClosePostScript;
  inherited Destroy;
  FBitmap.Free;
  end;

procedure TSheetToPs.InitSheet(ASheet: TSheet);
begin
  inherited InitSheet(ASheet);
  InitPostscript(ASheet.PlotUnit=puMetric);
  with FBitmap do begin
    Height:=PrintField.Height; Width:=PrintField.Width;
//    Height:=round(Size.Width*UnitToPixel); Width:=round(Size.Height*UnitToPixel);
    end;
  end;

function UnitToPt (Metric : boolean; Value : double) : integer;
begin
  if Metric then Result:=round(28.3465*Value) else Result:=round(72*Value);
  end;

procedure TSheetToPs.OpenPostscript(const AFilename : string);
begin
  AssignFile(FOutFile,AFilename); Rewrite(FOutFile);
  WriteLn (FOutFile,psBCm);      // Comments
  WriteLn (FOutFile,Format(psTit,[ExtractFileName(AFilename)]));
  WriteLn (FOutFile,Format(psDte,[FormatDateTime('yyyy-mm-dd hh:nn',Now)]));
  WriteLn (FOutFile,psCre);
  WriteLn (FOutFile,psDat);
  WriteLn (FOutFile,Format(psLev,['2']));
  end;

procedure TSheetToPs.InitPostscript (Metric : boolean);
begin
  with FSheet.Size do WriteLn (FOutFile,Format(psBbx,[UnitToPt(Metric,Width),UnitToPt(Metric,Height)]));
  WriteLn (FOutFile,psECm);
  WriteLn (FOutFile,psBPl);
  WriteLn (FOutFile,'/RpDict 200 dict def');
  WriteLn (FOutFile,'RpDict begin');
  WriteLn (FOutFile,'currentdict /pgsave save put');
  WriteLn (FOutFile,'/StEnc ISOLatin1Encoding 256 array copy def');
  WriteLn (FOutFile,'/SyEnc SymbolEncoding 256 array copy def');
  WriteLn (FOutFile,'/RpEnc StEnc def');
  WriteLn (FOutFile,'/Inifont {/rpf exch def findfont dup length dict /nf exch def'+sLineBreak+
                    '  {1 index /FID ne {nf 3 1 roll put} {pop pop} ifelse } forall'+sLineBreak+
                    '  nf /Encoding RpEnc put rpf nf definefont pop} def');
  WriteLn (FOutFile,'/selfont {exch /RpFont Inifont /RpFont /rpf exch def'+sLineBreak+
                    '  plun rpf findfont exch scalefont setfont} def');
  WriteLn (FOutFile,'/enc {/RpEnc exch def} def');
  if Metric then Writeln(FOutFile,'/plun {0.283465 mul} def')  // Plotter-Unit = 0.01 cm
  else Writeln(FOutFile,'/plun {0.72 mul} def');               // Plotter-Unit = 0.01 inch
//  Writeln(FOutFile,'/np newpath def /cp closepath def');
  Writeln(FOutFile,'/linewidth {plun setlinewidth} def');      // Linienbreite ändern
  Writeln(FOutFile,'/move {newpath plun exch plun exch moveto} def');
  Writeln(FOutFile,'/rmove {plun exch plun exch rmoveto} def');
  Writeln(FOutFile,'/plot {plun exch plun exch lineto} def');
  Writeln(FOutFile,'/trans {plun exch plun exch translate} def');
  Writeln(FOutFile,'/circle {newpath /rad exch def plun exch plun exch rad plun 0 360 arc closepath} def');

  WriteLn (FOutFile,'/text {/t exch def /w exch def w rotate t show w neg rotate} def');
///text {/t exch def /w exch def w rotate t show currentpoint /y exch def /x exch def  x y moveto} def
  WriteLn (FOutFile,psEPl);      // End Prolog
  WriteLn (FOutFile,psPage);
  WriteLn (FOutFile,pcLnStyle);
  FIsPath:=false;
  end;

 procedure TSheetToPs.ClosePostscript;
begin
  DrawPath;
  WriteLn (FOutFile,psRst);
  CloseFile(FOutFile);
//  FBitmap.SaveToFile('test.bmp');
  end;

{------------------------------------------------------------------}
function GetFontIndex (AFont : TPlotFont) : TPsFonts;
begin
  with AFont do begin
    for Result:=Low(TPsFonts) to High(TPsFonts) do if AnsiSameText(WinFonts[Result],FontName) then Break;
    if Result>High(TPsFonts) then begin  // unbekannte Schrift, verwende passende PS-Schrift
      if FontType=ftRoman then Result:=pfTimes
      else if FontType=ftFixed then Result:=pfCourier
      else Result:=pfHelvetica;
      end;
    end;
  end;

procedure TSheetToPs.SetFont;
begin
  with NewFont do begin
    if (Index<>CurFont.Index) and ((Index>=pfSymbol) or (CurFont.Index>=pfSymbol)) then
      if Index>=pfSymbol then Write(FOutFile,'SyEnc enc ')
      else Write(FOutFile,'StEnc enc ');
    if (Index<>CurFont.Index) or (Size<>CurFont.Size) or (Style<>CurFont.Style) then
      Writeln(FOutFile,'/'+PsFonts[Index][Style]+' '+IntToStr(Size)+' selfont');
    end;
  CurFont:=NewFont;
  end;

function TSheetToPs.FontHasChanged : boolean;
begin
  end;

//Schriftart
procedure TSheetToPs.NewTextFont (AFont : TPlotFont);
begin
  with NewFont,AFont do begin
    Index:=GetFontIndex(AFont);
    if fsBold in FontStyle then begin
      if fsItalic in FontStyle then Style:=psBoldItalic
      else Style:=psBold;
      end
    else if fsItalic in FontStyle then Style:=psItalic
    else Style:=psNormal;
    Rot:=FontAngle;
    Size:=round(FontSize*UnitToPixel);
    end;
  inherited NewTextFont(AFont);
  end;

procedure TSheetToPs.NewTextHeight (AHeight : double);
begin
  NewFont.Size:=round(AHeight*UnitToPixel);
  inherited NewTextHeight(AHeight);
  end;

procedure TSheetToPs.NewTextColor (AColor : TColor);
begin
  if AColor<>CurCol then begin
    DrawPath;                                       // draw last path if required
    Writeln(FOutFile,ColorToStr(AColor)+' setrgbcolor');
    CurCol:=AColor;
    end;
  inherited NewTextColor(AColor);
  end;

procedure TSheetToPs.NewTextStyle (AStyle : TFontStyles);
begin
  with NewFont do begin
    if fsBold in AStyle then begin
      if fsItalic in AStyle then Style:=psBoldItalic
      else Style:=psBold;
      end
    else if fsItalic in AStyle then Style:=psItalic
    else Style:=psNormal;
    end;
  inherited NewTextStyle(AStyle);
  end;

procedure TSheetToPs.NewTextRot (Angle : integer);
begin
  NewFont.Rot:=Angle;
  inherited NewTextRot(Angle);
  end;

procedure TSheetToPs.UseSymbolFont;
begin
  NewFont.Index:=pfSymbol;
  inherited UseSymbolFont;
  end;

function TSheetToPs.OffsetScale (n : integer) : double;
begin
  case n of
  1 : Result:=0.5;    // hoch
  2 : Result:=-0.3;   // tief
  3 : Result:=0.0;    // Symbol
  else Result:=0.0;
    end;
  end;

procedure TSheetToPs.BeginTextAt (x,y,dx,dy : double);
// x,y - upper left position of string
// dx,dy - offset to lower left position of string
begin
  MovePenTo(Scale(x+dx,y+dy));
  end;

procedure TSheetToPs.OutputText (Pos,Offs : TPoint; const AText : string);
begin
  SetFont;
  with Offs do x:=x+5;
  Writeln(FOutFile,PtToStr(Offs)+' rmove');
  if length(AText)>0 then Writeln(FOutFile,IntToStr(NewFont.Rot)+' ('+AText+')'+' text');
  Writeln(FOutFile,PtToStr(NegPt(Offs))+' rmove');
  inherited OutputText(Pos,Offs,AText);
  end;

{ ------------------------------------------------------------------- }
procedure TSheetToPs.DrawPath;
begin
  if FIsPath then Writeln(FOutFile,'stroke');      // draw last path
  FIsPath:=false;
  end;

procedure TSheetToPs.NewLineWidth (wd : integer);
begin
  if wd<>CurWdt then begin
    DrawPath;                                       // draw last path if required
    Writeln(FOutFile,IntToStr(wd)+' linewidth');
    CurWdt:=wd;
    end;
  inherited NewLineWidth(wd);
  end;

procedure TSheetToPs.NewLineColor (AColor : TColor);
begin
  if AColor<>CurCol then begin
    DrawPath;                                       // draw last path if required
    Writeln(FOutFile,ColorToStr(AColor)+' setrgbcolor');
    CurCol:=AColor;
    end;
  inherited NewLineColor(AColor);
  end;

procedure TSheetToPs.NewFillColor (AColor : TColor);
begin
  if AColor<>CurCol then begin
    DrawPath;                                       // draw last path if required
    Writeln(FOutFile,ColorToStr(AColor)+' setrgbcolor');
    CurCol:=AColor;
    end;
  inherited NewFillColor(AColor);
  end;

procedure TSheetToPs.MovePenTo (APoint : TPoint);
begin
  DrawPath;                                       // draw last path if required
  Writeln(FOutFile,PtToStr(APoint)+' move');
  inherited MovePenTo(APoint);
  end;

procedure TSheetToPs.DrawLineTo (APoint : TPoint);
begin
  Writeln(FOutFile,PtToStr(APoint)+' plot');
  FIsPath:=true;
  inherited DrawLineTo(APoint);
  end;

procedure TSheetToPs.DrawCircle (ACenter : TPoint; Radius : integer; Fill : boolean);
var
  s : string;
begin
  DrawPath;                                       // draw last path if required
  s:=PtToStr(ACenter)+' '+IntToStr(Radius)+' circle';
//  s:='newpath '+PtToStr(ACenter)+' plun exch plun exch '+IntToStr(Radius)+' plun 0 360 arc closepath';
  if Fill then s:=s+' fill' else s:=s+' stroke';
  Writeln(FOutFile,s);
  inherited DrawCircle(ACenter,Radius,Fill);
  end;

procedure TSheetToPs.DrawRectangle (ACenter : TPoint; Dist : integer; Fill : boolean);
var
  s : string;
begin
  DrawPath;                                       // draw last path if required
  with ACenter do
    s:='newpath '+XyToStr(x-Dist,y-Dist)+' move '+XyToStr(x-Dist,y+Dist)+' plot '
      +XyToStr(x+Dist,y+Dist)+' plot '+XyToStr(x+Dist,y-Dist)+' plot closepath';
  if Fill then s:=s+' fill' else s:=s+' stroke';
  Writeln(FOutFile,s);
  inherited DrawRectangle(ACenter,Dist,Fill);
  end;

procedure TSheetToPs.DrawPolygon (const Points: array of TPoint; Fill : boolean);
var
  s : string;
  i : integer;
begin
  DrawPath;                                       // draw last path if required
  if length(Points)>0 then begin
    s:=PtToStr(Points[0])+' move ';
    for i:=1 to High(Points) do s:=s+PtToStr(Points[i])+' plot ';
    end;
  s:=s+'closepath';
  if Fill then s:=s+' fill' else s:=s+' stroke';
  Writeln(FOutFile,s);
  inherited DrawPolygon(Points,Fill);
  end;

procedure TSheetToPs.FillRectangle (ARect : TRect);
var
  s : string;
begin
  DrawPath;                                       // draw last path if required
  with ARect do
    s:='newpath '+XyToStr(Left,Bottom)+' move '+XyToStr(Left,Top)+' plot '
      +XyToStr(Right,Top)+' plot '+XyToStr(Right,Bottom)+' plot closepath fill';
  Writeln(FOutFile,s);
  inherited FillRectangle(ARect);
  end;

procedure TSheetToPs.OutputImage (ARect : TRect; AImage : TBitmap);
var
  sx,sy : double;
begin
  Writeln(FOutFile,'save');
  Writeln(FOutFile,'/copypage {} bind def /showpage {} bind def /erasepage {} bind def');
  with ARect do begin
    Writeln(FOutFile,PtToStr(Point(Left,Bottom))+' trans');
    sx:=(Right-Left)/AImage.Width; sy:=(Top-Bottom)/AImage.Height;
    Writeln(FOutFile,FloatToString(sx,ffFixed,6,3)+' plun '+FloatToString(sy,ffFixed,6,3)+' plun scale');
    end;
  with TEpsGraphic.Create(emColor+emCompress,trNone) do begin
    Creator:='ImageToEps by J. Rathlev';
    Output(FOutFile,AImage);
    Free;
    end;
  Writeln(FOutFile,'restore');
  end;

end.
