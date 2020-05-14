(* Plot routines for RPlot
   =======================

   © J. Rathlev, D-24222 Schwentinental, (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Sep. 2012
   last modified January 2020
   *)

unit RPlotUtils;

interface

uses System.Sysutils, System.Classes, Winapi.Windows, Vcl.Graphics, System.Contnrs,
  System.IniFiles, Vcl.Buttons, System.Types, Vcl.Forms, Vcl.Controls,
  Vcl.ExtCtrls, RWinFit, RPlotObjects, WinUtils;

type
  TFormatType = (ftNormal,ftBold,ftItalic,ftSuper,ftSub,ftSymbol);

const
  FormatMarker: array [TFormatType] of char = (#0,'*','\','^','_','!');

type
  TSheetPlot = class (TObject)
  private
    FChart         : TChart;
    FPlotCanvas    : TCanvas;
    ChartField     : TFRect;      // Bereich für Koord.syst. in cm/inch
    PlotField      : TFRect;      // Bereich des Sheets in cm/inch (ohne Rand)
    FSheetField,
    FScreenField   : TRect;       // anzuzeigender Bereich in Pixel
    FShowRulers    : boolean;
    FRuler         : TRuler;
    FPenStat       : TPenStat;
    FOrientation   : integer;
    FClipWin       : TFRect;
    FClip          : boolean;
    SinTextRot,CosTextRot,        // sin und cos des Textrotationswinkels
    FMinDist,                     // Mindestabstand zweier zu verbindender Punkte
    FLastX,FLastY  : double;
    FPrintOut,
    FontChange,
    FTransText     : boolean;     // transparenter Texthintergrund
    FShMargin      : boolean;
    FVpSize        : TIntSize;
    FLastColor     : TColor;
    FLastOutline   : TOutline;
    function GetLineWidth : double;                    // in cm/inch
    procedure SetLineWidth (Width : double);
    function GetLineColor : TColor;

    function GetTextFont : TPlotFont;              // Textfonts
    function GetTxtHeight : double;               // Texthöhe in cm/inch
    function GetTextColor : TColor;
    function GetTextRot : integer;
    function GetTextStyle : TFontStyles;
    procedure GetTextOrigin(Align : TTextAlign; xd,yd : double; Invers : boolean; var x,y : double);

  protected
    FSheet         : TSheet;
    HitPoints      : integer;
    HitDelta,
    UnitToPixel    : double;      // Skal.faktoren cm/inch in Pixel
    PrintField     : TIntSize;    // zu druckender Bereich in Pixel
    // Umrechnung cm/inch in Pixel und umgekehrt
    procedure Scale (x,y : double; var gx,gy : integer); overload;
    function Scale (x,y : double) : TPoint; overload;
    function Scale (ap : TFPoint) : TPoint; overload;
    function ScaleArea (ar : TFloatArea) : TRect;
    function ScaleRect (r : TFRect) : TRect;

    procedure InvScale (gx,gy : integer; var x,y : double); overload;
    procedure InvScale (ap : TPoint; var x,y : double); overload;
    function InvScale (gx,gy : integer) : TFPoint; overload;
    function InvScale (ap : TPoint) : TFPoint; overload;
    function InvScaleRect (r : TRect) : TFRect;

    procedure InitLines;
    procedure InitBackground (AColor : TColor);

    // Basic routines for output to canvas
    procedure NewTextFont (AFont : TPlotFont); virtual;
    procedure NewTextHeight (AHeight : double); virtual;
    procedure NewTextColor (AColor : TColor); virtual;
    procedure NewTextStyle (AStyle : TFontStyles); virtual;
    procedure NewTextRot (Angle : integer); virtual;
    procedure UseSymbolFont; virtual;
    function OffsetScale (n : integer) : double; virtual;

    procedure NewLineWidth (wd : integer); virtual;
    procedure NewLineColor (AColor : TColor); virtual;

    procedure NewFillColor (AColor : TColor); virtual;
    procedure MovePenTo (APoint : TPoint); virtual;
    procedure DrawLineTo (APoint : TPoint); virtual;
    procedure DrawCircle (ACenter : TPoint; Radius : integer; Fill : boolean); virtual;
    procedure DrawRectangle (ACenter : TPoint; Dist : integer; Fill : boolean);virtual;
    procedure DrawPolygon (const Points: array of TPoint; Fill : boolean); virtual;
    procedure FillRectangle (ARect : TRect); virtual;
    procedure BeginTextAt (x,y,dx,dy : double); virtual;
    procedure OutputText (Pos,Offs : TPoint; const AText : string); virtual;
    procedure OutputImage (ARect : TRect; AImage : TBitmap); virtual;

    procedure MovePen (X,Y : integer); overload;
    procedure MovePen (Pt : TPoint); overload;
    procedure MovePen (X,Y : double); overload;
    procedure DrawPen (X,Y : integer); overload;
    procedure DrawPen (Pt : TPoint); overload;
    procedure DrawPen (X,Y : double); overload;

    procedure InitTextFont;
    function GetTextHeight (s : string; Formatted : boolean = false) : double;
    function GetTextWidth (s : string; Formatted : boolean = false) : double;

    function GetFormattedTextWidth (S : string) : double;
    function GetFormattedTextHeight (S : string) : double;

    procedure InitChartArea (AbsPos    : boolean;
                             x,y,dx,dy : double); overload;
    procedure InitChartArea (AbsPos    : boolean;
                             Area      : TFloatArea); overload;

    procedure PlotAxis (AAxis : TAxisItem);
    procedure InitPlot; virtual;

  public
    constructor Create (ACanvas : TCanvas);

    // nur für Bildschirm
    procedure PlotFrame (ABorder : TRect; ACol : TColor;
                         AStyle : TPenStyle = psSolid; AMode : TPenMode = pmCopy);
    procedure PlotWay (ABorder : TRect; ACol : TColor;
                         AStyle : TPenStyle = psSolid; AMode : TPenMode = pmCopy);

    procedure SetClipWin (AClipWin : TFRect);
    procedure NoClipWin;

    procedure PlotLineTo (x,y : double; APenStat : TPenStat); overload;
    procedure PlotLineTo (pt : TFPoint; APenStat : TPenStat); overload;

    procedure PlotLine (x1,y1,x2,y2 : double); overload;
    procedure PlotLine (Pt1,Pt2 : TFPoint); overload;
    procedure PlotLine (x1,y1,x2,y2,LnWidth : double); overload;
    procedure PlotLine(x1,y1,x2,y2,LnWidth : double; Style : TLineStyle); overload;
    procedure PlotLine (Pt1,Pt2 : TFPoint; LnWidth : double; Style : TLineStyle); overload;

    procedure PlotMark (x,y : double; Mark : TSymbolType; MarkSz,LnWidth  : double;
                        AColor,BColor : TColor); overload;
    procedure PlotMark (pt : TFPoint; Mark : TSymbolType;
                        MarkSz,LnWidth : double; AColor,BColor : TColor); overload;

    procedure PlotDot (x,y : double; AColor : TColor);

    procedure PlotErrorBar (Dir : TErrBarDirection; Position,PError,MError,Size,LnWidth : double); overload;
    procedure PlotErrorBar (Dir : TErrBarDirection; Position,PError,MError,Size : double); overload;

    procedure PlotArea (x1,y1,x2,y2 : double; AColor : TColor; AStyle : TBrushStyle = bsSolid); overload;
    procedure PlotArea (ARect : TFRect; AColor : TColor; AStyle : TBrushStyle = bsSolid); overload;
    procedure PlotArea (AArea : TFloatArea; AColor : TColor; AStyle : TBrushStyle = bsSolid); overload;

    procedure PlotBorder (AArea : TFloatArea); overload;
    procedure PlotBorder (AArea : TFloatArea; AColor : TColor); overload;
    procedure PlotBorder (AArea : TFloatArea; ALnWidth : double; AColor : TColor); overload;
    procedure PlotBorder (ARect : TFRect); overload;
    procedure PlotBorder (ARect : TFRect; AColor : TColor); overload;
    procedure PlotBorder (x1,y1,x2,y2 : double; ALnWidth : double; AColor : TColor); overload;
    procedure PlotBorder (ARect : TFRect; ALnWidth : double; AColor : TColor;
                          AStyle : TLineStyle = lsSolid; AMode : TPenMode = pmCopy); overload;

    procedure PlotRect (x1,y1,x2,y2 : double; ALnWidth : double; AColor,BColor : TColor); overload;
    procedure PlotRect (ARect : TFRect; ALnWidth : double; AColor,BColor : TColor); overload;

    procedure PlotImage(AArea : TFloatArea; AImage : TBitmap);
    procedure PlotDrawingLine(AStart,AEnd : TFPoint; AProperties : TDrawingProperties);
    procedure PlotDrawingRect(ARect : TFRect; AProperties : TDrawingProperties);

    function PlotText (X,Y : double; AText : string; Align : TTextAlign) : TFPoint; overload;
    function PlotText (APos : TFPoint; AText : string; Align : TTextAlign) : TFPoint; overload;

    procedure PlotComment (APos : TFPoint; AText : string; Properties : TTextProperties);
    procedure PlotTextLines (APos : TFPoint; const AText : string; Properties : TTextProperties);
    procedure PlotLegend (APos : TFPoint; const AText : string; ShowSymbol : boolean;
                        BColor : TColor; AProps : TTextProperties; AItem : TChartItem);

    procedure InitExport(ARect : TRect);

    procedure InitSheet(ASheet: TSheet); virtual;
    procedure ClearSheet;
    procedure InitChart (AChart : TChart);
    procedure PlotSheet (AScreen : boolean);

    property PlotCanvas : TCanvas read FPlotCanvas; // write FPlotCanvas;

    // Linien
    property LineWidth : double read GetLineWidth write SetLineWidth;    // in cm/inch
    property LineColor : TColor read GetLineColor write NewLineColor;

    // Schrift
    property TextFont : TPlotFont read GetTextFont write NewTextFont;
    property TextHeight : double read GetTxtHeight write NewTextHeight;  // in cm/inch
    property TextColor : TColor read GetTextColor write NewTextColor;
    property TextOrientation : integer read GetTextRot write NewTextRot;  // in °, math.-pos. Sinn
    property TextStyle : TFontStyles read GetTextStyle write NewTextStyle;
    property TextTransparency : boolean read FTransText write FTransText;

    property Clip : boolean read FClip write FClip;
    property SheetField : TRect read FSheetField;
    end;

  TSheetToWindow = class (TSheetPlot)
  protected
    procedure PlotRuler(Vert : boolean);
    procedure InitPlot; override;

  public
    constructor Create (ACanvas : TCanvas);
    function ViewToWindow (Pt : TPoint) : TPoint;
    function WindowToView (Pt : TPoint) : TPoint;
    procedure ViewToUnit (Pt : TPoint; var X,Y : double); overload;
    function ViewToUnit (Pt : TPoint) : TFPoint overload;
    procedure UnitToView (X,Y : double; var Pt : TPoint); overload;
    function UnitToView (UPos : TFPoint) : TPoint; overload;

    procedure InitView (ASize : TIntSize; ShowMargin : boolean); overload;
    procedure InitView (ASize : TIntSize; Origin  : TPoint; Zoom : double); overload;

    procedure PlotOutline (ChartNdx,ItemNdx : integer);
    function GetItemFromPos (APos : TFPoint; var AItemIndex : TChartItemIndex) : TItemAction;
    function IsItemAt (APos : TFPoint; AItemIndex : TChartItemIndex) : boolean;
    function GetNextItemAt (APos : TFPoint; var AItemIndex : TChartItemIndex) : boolean;
    procedure MoveItem(Pos1,Pos2 : TFPoint; AItemIndex : TChartItemIndex;  ItemAction : TItemAction);
    function GetFrame (AItemIndex : TChartItemIndex; var AFrame : TRect) : boolean;
    function GetLine (AItemIndex : TChartItemIndex; var AFrame : TRect) : boolean;
    function GetRect (AItemIndex : TChartItemIndex; var AFrame : TRect) : boolean;

    end;

  TSheetToPrinter = class (TSheetPlot)
  public
    procedure InitPrint (ShowMargin : boolean);
    end;

  TSheetToClipBoard = class (TSheetToPrinter)
  private
    procedure CreateNewFont (var NewFont,OldFont : HFont);
    procedure DeleteNewFont (var NewFont,OldFont : HFont);
  protected
    procedure OutputText (Pos,Offs : TPoint; const AText : string); override;
    end;

function StringToFloat (const s : string; Default : extended) : extended;
function FloatToString (Value : extended; Format: TFloatFormat; Precision, Digits: Integer) : string;

procedure ResetMinMax (var PMin,PMax : TFPoint);
procedure MinMax (Val : TFPoint; var PMin,PMax : TFPoint); overload;
procedure MinMax (Val : TFuncSet; var PMin,PMax : TFPoint); overload;

function GetSize(AControl : TControl) : TIntSize;
procedure FillImage(AImage : TImage; AColor : TColor);
procedure FillBtnGlyph (Bitmap : TBitmap; Button : TSpeedButton; AColor: TColor); overload;
procedure FillBtnGlyph (Bitmap : TBitmap; Button : TBitBtn; AColor: TColor); overload;

function GetColorString(col : TColor) : string;

function GetItemName (ItemType : TItemType) : string; overload;
function GetItemName (ItemType : TItemType; TextType : TTextType) : string; overload;
function GetItemName (ItemType : TItemType; GraphType : TGraphType) : string; overload;

implementation

uses GnuGetText, ExtSysUtils, MathUtils, MathExp, StrUtils, XMLUtils, NumberUtils,
  System.DateUtils, System.Math, Vcl.Imaging.jpeg;

{ ------------------------------------------------------------------- }
function StringToFloat (const s : string; Default : extended) : extended;
var
  fs : TFormatSettings;
  v  : extended;
begin
  fs:=FormatSettings; fs.DecimalSeparator:=DecSep;
  if TryStrToFloat(s,v,fs) then Result:=v else Result:=Default;
  end;

// Double-Zahl in String mit Punkt als Dezimaltrenner
function FloatToString (Value : extended; Format: TFloatFormat; Precision, Digits: Integer) : string;
begin
  Result:=FloatToStrG(Value,Format,Precision,Digits,DecSep);
  end;

{ ------------------------------------------------------------------- }
function PlusOrigin (ARect : TFRect) : TFPoint; overload;
begin
  with Result do begin
    X:=ARect.Left; Y:=ARect.Bottom;
    end;
  end;

function PlusOrigin (AArea: TFloatArea) : TFPoint; overload;
begin
  with Result do begin
    X:=AArea.Left; Y:=AArea.Bottom;
    end;
  end;

function MinusOrigin (ARect : TFRect) : TFPoint; overload;
begin
  with Result do begin
    X:=-ARect.Left; Y:=-ARect.Bottom;
    end;
  end;

function MinusOrigin (AArea: TFloatArea) : TFPoint; overload;
begin
  with Result do begin
    X:=-AArea.Left; Y:=-AArea.Bottom;
    end;
  end;

function DiffPoint (pt1,pt2 : TFPoint) : TFPoint;   // pt1 - pt2
begin
  with Result do begin
    x:=pt1.x-pt2.X; y:=pt1.y-pt2.Y;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure ResetMinMax (var PMin,PMax : TFPoint);
begin
  with pmin do begin
    x:=MaxDouble; y:=MaxDouble;
    end;
  with pmax do begin
    x:=MinDouble; y:=MinDouble;
    end;
  end;

procedure MinMax (Val : TFPoint; var PMin,PMax : TFPoint);
begin
  with Val do begin
    if X<pmin.X then pmin.X:=X;
    if Y<pmin.Y then pmin.Y:=Y;
    if X>pmax.X then pmax.X:=X;
    if Y>pmax.Y then pmax.Y:=Y;
    end;
  end;

procedure MinMax (Val : TFuncSet; var PMin,PMax : TFPoint);
begin
  with Val do if Valid then MinMax(FloatPoint(X,Y),PMin,PMax);
  end;

{ ------------------------------------------------------------------- }
function GetSize(AControl : TControl) : TIntSize;
begin
  with Result do begin
    Width:=AControl.Width; Height:=AControl.Height;
    end;
  end;

procedure FillImage(AImage : TImage; AColor : TColor);
begin
  with AImage,Canvas do begin
    Brush.Color:=AColor;
    FillRect(Rect(0,0,Width,Height));
    end;
  end;

procedure FillBitMap (Bitmap : TBitmap; AColor: TColor);
begin
  with Bitmap,Canvas do begin
    if AColor=clWhite then TransparentColor:=clBlack else TransparentColor:=clWhite;
    Brush.Color:=TransparentColor;
    Brush.Style:=bsSolid;
    FillRect(Rect(0,0,Width-1,Height-1)); // transparenter Rahmen
    Brush.Color:=AColor;
    FillRect(Rect(2,2,Width-3,Height-3));
    end;
  end;

procedure FillBtnGlyph (Bitmap : TBitmap; Button : TSpeedButton; AColor: TColor);
begin
  FillBitmap(Bitmap,AColor);
  with Button do begin
    Glyph:=Bitmap; NumGlyphs:=1; Tag:=AColor;
    end;
  end;

procedure FillBtnGlyph (Bitmap : TBitmap; Button : TBitBtn; AColor: TColor);
begin
  FillBitmap(Bitmap,AColor);
  with Button do begin
    Glyph:=Bitmap; NumGlyphs:=1; Tag:=AColor;
    end;
  end;

function GetColorString(col : TColor) : string;
begin
  with TLongWord(col) do begin
    Result:='R: '+IntToStr(LoL)+', G: '+IntToStr(LoH)+', B: '+IntToStr(HiL);
    end;
  end;

function GetShortDayOfWeek (dt : TDateTime) : string;
begin                // kurzer Name des Wochentags in der Sprache der Programmoberfl.
  case DayOfTheWeek(dt) of
  1 : Result:=_('Mo');
  2 : Result:=_('Tu');
  3 : Result:=_('We');
  4 : Result:=_('Th');
  5 : Result:=_('Fr');
  6 : Result:=_('Sa');
  else Result:=_('Su');
    end;
  end;

function GetItemName (ItemType : TItemType) : string;
begin
  Result:='['+ItemTypeNames[ItemType]+'] ';
  end;

function GetItemName (ItemType : TItemType; TextType : TTextType) : string;
begin
  if ItemType=itText then Result:='['+TextTypeNames[TextType]+'] '
  else Result:=GetItemName(ItemType);
  end;

function GetItemName (ItemType : TItemType; GraphType : TGraphType) : string;
begin
  if ItemType=itText then Result:='['+GraphTypeNames[GraphType]+'] '
  else Result:=GetItemName(ItemType);
  end;

{ =================================================================== }
// Object: TSheetPlot - Zeichnen eines Sheets
constructor TSheetPlot.Create (ACanvas : TCanvas);
begin
  UnitToPixel:=100;     // 0.1 mm oder 0.01 inch
  FPlotCanvas:=ACanvas;
  FShowRulers:=false;
  FTransText:=false; FLastColor:=PlotCanvas.Pen.Color;
  FontChange:=true; FPrintOut:=false;
  FLastOutline.Valid:=false;
  FClip:=false; FShMargin:=false;
  end;

procedure TSheetPlot.InitSheet(ASheet : TSheet);
begin
  FSheet:=ASheet;
  if FSheet.PlotUnit=puInch then begin
    FMinDist:=0.001; // inch
    FRuler:=InchRuler;
    end
  else begin
    FMinDist:=0.01; // cm
    FRuler:=MetricRuler;
    end;
  with PlotField,FSheet do begin    // verfügbares Zeichenfeld in cm/inch
    Left:=Margin.Left;
    Top:=Size.Height-Margin.Top;
    Bottom:=Margin.Bottom;
    Right:=Size.Width-Margin.Right;
    end;
  FClipWin:=PlotField;
  with FSheetField do begin          // verfügbares Zeichenfeld in Pixel
    Top:=round(PlotField.Top*UnitToPixel); Bottom:=round(PlotField.Bottom*UnitToPixel);
    Left:=round(PlotField.Left*UnitToPixel); Right:=round(PlotField.Right*UnitToPixel);
    end;
  with FScreenField do begin          // verfügbares Zeichenfeld mit Lineal in Pixel
    if FShowRulers then with FRuler do  begin
      Top:=round((PlotField.Top+0.5*Space)*UnitToPixel);
      Bottom:=round((PlotField.Bottom-Space)*UnitToPixel);
      Left:=round((PlotField.Left-Space)*UnitToPixel);
      Right:=round((PlotField.Right+0.5*Space)*UnitToPixel);
      end
    else begin
      Top:=round(PlotField.Top*UnitToPixel); Bottom:=round(PlotField.Bottom*UnitToPixel);
      Left:=round(PlotField.Left*UnitToPixel); Right:=round(PlotField.Right*UnitToPixel);
      end;
    end;
  with PrintField,FSheet do begin  // verfügbares Druckerfeld in Pixel
    Width:=round((Size.Width)*UnitToPixel);
    Height:=round((Size.Height)*UnitToPixel);
    end;
//  FontChange:=true;
  HitPoints:=50; HitDelta:=0.1;
  end;

{------------------------------------------------------------------}
// Linienbreite in cm/inch
procedure TSheetPlot.InitLines;
begin
  with FSheet do begin
    NewLineWidth(round(UnitToPixel*DefaultLineWidth));
    NewLineColor(DefaultLineColor);
    end;
  end;

procedure TSheetPlot.InitBackground (AColor : TColor);
begin
  NewFillColor(AColor);
  end;

procedure TSheetPlot.InitTextFont;
begin
  NewTextFont(FSheet.DefTextFont);
  end;

{ ------------------------------------------------------------------- }
procedure TSheetPlot.NewLineWidth (wd : integer);
begin
  PlotCanvas.Pen.Width:=wd;
  end;

procedure TSheetPlot.NewLineColor (AColor : TColor);
begin
  PlotCanvas.Pen.Color:=AColor;
  end;

procedure TSheetPlot.NewFillColor (AColor : TColor);
begin
  PlotCanvas.Brush.Color:=AColor;
  end;

procedure TSheetPlot.MovePenTo (APoint : TPoint);
begin
  with APoint do FPlotCanvas.MoveTo (X,Y);
  end;

procedure TSheetPlot.DrawLineTo (APoint : TPoint);
begin
  with APoint do FPlotCanvas.LineTo (X,Y);
  end;

procedure TSheetPlot.DrawCircle (ACenter : TPoint; Radius : integer; Fill : boolean);
begin
  with FPlotCanvas do begin
    with Brush do if Fill then Style:=bsSolid else Style:=bsClear;
    with ACenter do Ellipse(x-Radius,y-Radius,x+Radius,y+Radius);
    end;
  end;

procedure TSheetPlot.DrawRectangle (ACenter : TPoint; Dist : integer; Fill : boolean);
begin
  with FPlotCanvas do begin
    with Brush do if Fill then Style:=bsSolid else Style:=bsClear;
    with ACenter do Rectangle(x-Dist,y-Dist,x+Dist,y+Dist);
    end;
  end;

procedure TSheetPlot.DrawPolygon (const Points: array of TPoint; Fill : boolean);
begin
  with FPlotCanvas do begin
    with Brush do if Fill then Style:=bsSolid else Style:=bsClear;
    Polygon(Points);
    end;
  end;

procedure TSheetPlot.FillRectangle (ARect : TRect);
begin
  PlotCanvas.FillRect(ARect);
  end;

// Nur für Postscript-Ausgabe (links-oben -> links unten)
procedure TSheetPlot.BeginTextAt (x,y,dx,dy : double);
begin
  end;

procedure TSheetPlot.OutputText (Pos,Offs : TPoint; const AText : string);
begin
  PlotCanvas.TextOut (Pos.X+Offs.x,Pos.Y+Offs.y,AText);
  end;

procedure TSheetPlot.OutputImage (Arect : TRect; AImage : TBitmap);
begin
  PlotCanvas.StretchDraw(ARect,AImage);
  end;

{ ------------------------------------------------------------------- }
// Linienbreite in cm/inch
function TSheetPlot.GetLineWidth : double;
begin
  Result:=PlotCanvas.Pen.Width/UnitToPixel;
  end;

procedure TSheetPlot.SetLineWidth (Width : double);
begin
  NewLineWidth(round(UnitToPixel*Width));
  end;

// Stiftfarbe setzen
function TSheetPlot.GetLineColor : TColor;
begin
  Result:=PlotCanvas.Pen.Color;
  end;

{ ------------------------------------------------------------------- }
//   Umrechnung von cm/inch auf Bildschirmkoord.
//   mit Prüfung auf Begrenzung durch SheetField
procedure TSheetPlot.Scale (x,y       : double;
                            var gx,gy : integer);
begin
  with FSheetField do begin
    gx:=round(x*UnitToPixel);
//    if gx<Left then gx:=Left; if gx>Right then gx:=Right;
    gy:=round(y*UnitToPixel);
//    if gy<Bottom then gy:=Bottom; if gy>Top then gy:=Top;
    end;
  end;

function TSheetPlot.Scale (x,y : double) : TPoint;
begin
  Scale(x,y,Result.X,Result.Y);
  end;

function TSheetPlot.Scale (ap : TFPoint) : TPoint;
begin
  with ap do Scale(x,y,Result.X,Result.Y);
  end;

function TSheetPlot.ScaleArea (ar : TFloatArea) : TRect;
begin
  with ar do begin
    Scale(Left,Bottom,Result.Left,Result.Bottom);
    Scale(Left+Width,Bottom+Height,Result.Right,Result.Top);
    end;
  end;

function TSheetPlot.ScaleRect (r : TFRect) : TRect;
begin
  with r do begin
    Scale(Left,Bottom,Result.Left,Result.Bottom);
    Scale(Right,Top,Result.Right,Result.Top);
    end;
  end;

//   Umrechnung von Pixel in cm/inch
procedure TSheetPlot.InvScale (gx,gy : integer; var x,y : double);
begin
  x:=gx/UnitToPixel; y:=gy/UnitToPixel;
  end;

function TSheetPlot.InvScale (gx,gy : integer) : TFPoint;
begin
  with Result do InvScale(gx,gy,x,y);
  end;

procedure TSheetPlot.InvScale (ap : TPoint; var x,y : double);
begin
  InvScale(ap.X,ap.Y,x,y);
  end;

function TSheetPlot.InvScale (ap : TPoint) : TFPoint;
begin
  with Result do InvScale(ap.X,ap.Y,x,y);
  end;

function TSheetPlot.InvScaleRect (r : TRect) : TFRect;
begin
  with r do begin
    InvScale(Left,Bottom,Result.Left,Result.Bottom);
    InvScale(Right,Top,Result.Right,Result.Top);
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TSheetPlot.MovePen (X,Y : integer);
begin
  MovePenTo(Point(X,Y));
  end;

procedure TSheetPlot.MovePen (Pt : TPoint);
begin
  MovePenTo(Pt);
  end;

procedure TSheetPlot.MovePen (X,Y : double);
var
  IX,IY : integer;
begin
  Scale (X,Y,IX,IY); MovePen(IX,IY)
  end;

{ ------------------------------------------------------------------- }
procedure TSheetPlot.DrawPen (X,Y : integer);
begin
  DrawLineTo (Point(X,Y));
  end;

procedure TSheetPlot.DrawPen (Pt : TPoint);
begin
  DrawLineTo(Pt);
  end;

procedure TSheetPlot.DrawPen (X,Y : double);
var
  IX,IY : integer;
begin
  Scale (X,Y,IX,IY);
  end;

{ ------------------------------------------------------------------- }
procedure TSheetPlot.PlotFrame (ABorder : TRect; ACol : TColor;
             AStyle : TPenStyle = psSolid; AMode : TPenMode = pmCopy);
var
  OldPen  : TPen;
begin
  with PlotCanvas do begin
    OldPen:=Pen;
    with Pen do begin
      Mode:=AMode; Style:=AStyle; Width:=1;
      end;
    with ABorder do begin
      MoveTo (Left,Top); LineTo (Right,Top); LineTo (Right,Bottom);
      MoveTo (Left,Top); LineTo (Left,Bottom); LineTo (Right,Bottom);
      end;
    Pen:=OldPen;
    end;
  end;

procedure TSheetPlot.PlotWay(ABorder : TRect; ACol : TColor;
             AStyle : TPenStyle = psSolid; AMode : TPenMode = pmCopy);
var
  OldPen  : TPen;
begin
  with PlotCanvas do begin
    OldPen:=Pen;
    with Pen do begin
      Mode:=AMode; Style:=AStyle; Width:=1;
      end;
    with ABorder do begin
      MoveTo (Left,Bottom); LineTo (Right,Top);
      end;
    Pen:=OldPen;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TSheetPlot.SetClipWin (AClipWin : TFRect);
begin
  FClipWin:=AClipWin;
  FClip:=true;
  end;

procedure TSheetPlot.NoClipWin;
begin
  FClip:=false;
  end;

// Zeichnen einer Linie
procedure TSheetPlot.PlotLineTo (x,y : double; APenStat : TPenStat);
(* x und y : Koordinaten in cm/inch
   PenStat:  psLast  = alter Pen-Modus
             psLine  = sichtbare Linie
             psMove  = unsichtbare Linie  *)
type
  TPointPos = (ppTop,ppLeft,ppInside,ppRight,ppBottom);
var
  npos,lpos : TPointPos;

  function CheckPos (x1,y1,x2,y2 : double) : TPointPos;
  var
    f : double;
    inv : boolean;
  begin
    x2:=x2-x1; y2:=y2-y1;
    inv:=abs(x2)<abs(y2);
    if inv then f:=x2/y2 else f:=y2/x2;
    if FClip then with FClipWin do begin
      if y1>Top then begin
        Result:=ppTop;
        if x1<Left then begin
          if Inv then begin
            if (Top-y1)*f+x1<Left then Result:=ppLeft
            end
          else if (Left-x1)*f+y1<=Top then Result:=ppLeft;
          end
        else if x1>Right then begin
          if Inv then begin
            if (Top-y1)*f+x1>Right then Result:=ppRight
            end
          else if (Right-x1)*f+y1<=Top then Result:=ppRight
          end
        end
      else if y1<Bottom then begin
        Result:=ppBottom;
        if x1<Left then begin
          if Inv then begin
            if (Bottom-y1)*f+x1<Left then Result:=ppLeft
            end
          else if (Left-x1)*f+y1>=Bottom then Result:=ppLeft;
          end
        else if x1>Right then begin
          if Inv then begin
            if (Bottom-y1)*f+x1>Right then Result:=ppRight
            end
          else if (Right-x1)*f+y1>=Bottom then Result:=ppRight
          end;
        end
      else begin
        if x1<Left then Result:=ppLeft
        else if x1>Right then Result:=ppRight
        else Result:=ppInside;
        end;
      end
    else Result:=ppInside;
    end;

begin
  with PlotCanvas.Pen do begin
    Style:=psSolid; Mode:=pmCopy;
    end;
  if APenStat<>psLast then FPenStat:=APenStat;
  if (FPenStat=psDraw) and FClip then with FClipWin do begin  // an Rand interpolieren
    if (abs(x-FLastX)<FMinDist) and (abs(y-FLastY)<FMinDist) then Exit; // zu kleiner Abstand
    lpos:=CheckPos(FLastX,FLastY,x,y);
    npos:=CheckPos(x,y,FLastX,FLastY);
    if (lpos=ppInside) and (npos=ppInside) then DrawPen(Scale(x,y))
    else begin
      if (lpos=ppInside) then begin
        if (npos=ppLeft) then DrawPen(Scale(Left,(Left-FLastX)/(x-FLastX)*(y-FLastY)+FLastY))
        else if (npos=ppRight) then DrawPen(Scale(Right,(Right-FLastX)/(x-FLastX)*(y-FLastY)+FLastY))
        else if (npos=ppTop) then DrawPen(Scale((Top-FLastY)/(y-FLastY)*(x-FLastX)+FLastX,Top))
        else DrawPen(Scale((Bottom-FLastY)/(y-FLastY)*(x-FLastX)+FLastX,Bottom));
        end
      else if (npos=ppInside) then begin
        if (lpos=ppLeft) then MovePen(Scale(Left,(Left-FLastX)/(x-FLastX)*(y-FLastY)+FLastY))
        else if (lpos=ppRight) then MovePen(Scale(Right,(Right-FLastX)/(x-FLastX)*(y-FLastY)+FLastY))
        else if (lpos=ppTop) then MovePen(Scale((Top-FLastY)/(y-FLastY)*(x-FLastX)+FLastX,Top))
        else MovePen(Scale((Bottom-FLastY)/(y-FLastY)*(x-FLastX)+FLastX,Bottom));
        DrawPen(Scale(x,y));
        end;
      end;
    end
  else begin
    if FPenStat=psMove then MovePen(Scale(x,y)) else DrawPen(Scale(x,y));
    end;
  FLastX:=x; FLastY:=y;
  end;

procedure TSheetPlot.PlotLineTo (pt : TFPoint; APenStat : TPenStat);
begin
  with pt do PlotLineTo(x,y,APenStat);
  end;

procedure TSheetPlot.PlotLine (x1,y1,x2,y2 : double);
begin
  PlotLineTo(x1,y1,psMove); PlotLineTo(x2,y2,psDraw);
  end;

procedure TSheetPlot.PlotLine (Pt1,Pt2 : TFPoint);
begin
  PlotLine(Pt1.X,Pt1.Y,Pt2.X,Pt2.Y);
  end;

procedure TSheetPlot.PlotLine (x1,y1,x2,y2,LnWidth : double);
begin
  SetLineWidth(LnWidth);
  PlotLineTo(x1,y1,psMove); PlotLineTo(x2,y2,psDraw);
  end;

procedure TSheetPlot.PlotLine(x1,y1,x2,y2,LnWidth : double; Style : TLineStyle);
var
  i,n,w   : integer;
  d,f,t   : double;
begin
  if Style=lsNone then Exit;   // keine Linie
  if Style=lsSolid then PlotLine (x1,y1,x2,y2,LnWidth)
  else begin
    w:=round(UnitToPixel*LnWidth);
    if w=0 then w:=1;
    NewLineWidth(w);
    d:=sqrt(sqr(x2-x1)+sqr(y2-y1));  // Länge der Linie in cm/inch
    if Style=lsDotted then begin
      n:=round(d/(3*LnWidth)); t:=0.3;
      end
    else begin
      n:=round(d/(10*LnWidth)); t:=0.5;
      end;
    if n>0 then begin
      if abs(x2-x1)>abs(y2-y1) then begin
        d:=(x2-x1)/n; f:=(y2-y1)/(x2-x1);
        for i:=0 to n-1 do PlotLine(x1+i*d,y1+i*d*f,x1+(i+t)*d,y1+(i+t)*d*f);
        end
      else begin
        d:=(y2-y1)/n; f:=(x2-x1)/(y2-y1);
        for i:=0 to n-1 do PlotLine(x1+i*d*f,y1+i*d,x1+(i+t)*d*f,y1+(i+t)*d);
        end;
      end;
    end;
  end;

procedure TSheetPlot.PlotLine (Pt1,Pt2 : TFPoint; LnWidth : double; Style : TLineStyle);
begin
  PlotLine(Pt1.X,Pt1.Y,Pt2.X,Pt2.Y,LnWidth,Style);
  end;

// Zeichen Fehlerbalken
procedure TSheetPlot.PlotErrorBar (Dir : TErrBarDirection; Position,PError,MError,Size : double);
begin
  if Dir=ebHorz then begin
    PlotLine(PError,Position,MError,Position);
    PlotLine(PError,Position-Size,PError,Position+Size);
    PlotLine(MError,Position-Size,MError,Position+Size);
    end
  else begin
    PlotLine(Position,PError,Position,MError);
    PlotLine(Position-Size,PError,Position+Size,PError);
    PlotLine(Position-Size,MError,Position+Size,MError);
    end;
  end;

procedure TSheetPlot.PlotErrorBar (Dir : TErrBarDirection; Position,PError,MError,Size,LnWidth : double);
var
  w : integer;
begin
  w:=round(UnitToPixel*LnWidth);
  if w=0 then w:=1;
  NewLineWidth(w);
  PlotErrorBar(Dir,Position,PError,MError,Size);
  end;

// Zeichnen einer Marke
procedure TSheetPlot.PlotMark (x,y : double; Mark : TSymbolType;
                               MarkSz,LnWidth : double; AColor,BColor : TColor);
(* x und y : Koordinaten in cm/inch
   Mark     : Markierung am Endpunkt
   MarkSz   : Größe der Marken in cm/inch
   LnWidth  : Liniendicke in cm/inch
   AColor   : Farbe der Marke *)
var
  ix,iy,d,q,w : integer;
begin
  if FClip then with FClipWin do begin  // keine Marken außerhalb
    if (x<Left) or (x>Right) or (y<Bottom) or (y>Top) then Exit;
    end;
  w:=round(UnitToPixel*LnWidth);
  if w=0 then w:=1;
  NewLineWidth(w);
  Scale(x,y,ix,iy);
  if BColor<0 then with FSheet do begin
    NewFillColor(SheetColor); NewLineColor(SheetColor);
    end
  else begin
    NewFillColor(BColor); NewLineColor(BColor);
    end;
  d:=round(UnitToPixel*0.6*MarkSz);
  DrawCircle(Point(ix,iy),d,true);            // Bereich löschen
  NewFillColor(AColor); NewLineColor(AColor);
  d:=round(UnitToPixel*0.5*MarkSz);
// plot marks: mmDot,mmDiamond,mmTriangle,mmSquare,mmDel,mmCircle,mmODiamond,
//             mmOTriangle,mmOSquare,mmODel,mmPlus,mmCross);
  case Mark of
  stDot,stCircle  : DrawCircle(Point(ix,iy),d,Mark=stDot);
  stDiamond,stODiamond : DrawPolygon([Point(ix-d,iy),Point(ix,iy-d),Point(ix+d,iy),Point(ix,iy+d)],Mark=stDiamond);
  stTriangle,stOTriangle : begin // Dreieck
      d:=round(UnitToPixel*0.333*MarkSz);
      q:=round(UnitToPixel*0.577*MarkSz);
      DrawPolygon([Point(ix-q,iy-d),Point(ix,iy+2*d),Point(ix+q,iy-d)],Mark=stTriangle);
      end;
  stSquare,stOSquare : DrawRectangle(Point(ix,iy),d,Mark=stSquare);
  stDelta,stODelta : begin  // auf der Spitze stehendes Dreieck
      d:=round(UnitToPixel*0.333*MarkSz);
      q:=round(UnitToPixel*0.577*MarkSz);
      DrawPolygon([Point(ix-q,iy+d),Point(ix,iy-2*d),Point(ix+q,iy+d)],Mark=stDelta);
      end;
  stPlus : begin // Kreuz (+)
      MovePen(ix-d,iy); DrawPen(ix+d,iy);
      MovePen(ix,iy+d); DrawPen(ix,iy-d);
      end;
  stCross : begin // Kreuz (x)
      MovePen(ix-d,iy-d); DrawPen(ix+d,iy+d);
      MovePen(ix-d,iy+d); DrawPen(ix+d,iy-d);
      end;
    end;
  MovePen(ix,iy);
  end;

procedure TSheetPlot.PlotMark (pt : TFPoint; Mark : TSymbolType;
                               MarkSz,LnWidth : double; AColor,BColor : TColor);
begin
  with pt do PlotMark(x,y,Mark,MarkSz,LnWidth,AColor,BColor);
  end;

procedure TSheetPlot.PlotDot (x,y : double; AColor : TColor);
var
  ix,iy     : integer;
begin
  Scale (x,y,ix,iy);
  NewLineColor(AColor);
  MovePen(ix,iy); DrawPen(ix+1,iy);
  end;

// Rahmen
procedure TSheetPlot.PlotBorder (AArea : TFloatArea);
begin
  with AArea do begin
    PlotLineTo (Left,Bottom,psMove);
    PlotLineTo (Left,Bottom+Height,psDraw);
    PlotLineTo (Left+Width,Bottom+Height,psDraw);
    PlotLineTo (Left+Width,Bottom,psDraw);
    PlotLineTo (Left,Bottom,psDraw);
    end;
  end;

procedure TSheetPlot.PlotBorder (AArea : TFloatArea; AColor : TColor);
begin
  NewLineColor(AColor);
  PlotBorder (AArea);
  end;

procedure TSheetPlot.PlotBorder (AArea : TFloatArea; ALnWidth : double; AColor : TColor);
begin
  NewLineWidth(round(UnitToPixel*ALnWidth));
  PlotBorder(AArea,AColor);
  end;

procedure TSheetPlot.PlotBorder (ARect : TFRect);
begin
  with ARect do begin
    PlotLineTo (Left,Bottom,psMove);
    PlotLineTo (Left,Top,psDraw);
    PlotLineTo (Right,Top,psDraw);
    PlotLineTo (Right,Bottom,psDraw);
    PlotLineTo (Left,Bottom,psDraw);
    end;
  end;

procedure TSheetPlot.PlotBorder (ARect : TFRect; AColor : TColor);
begin
  NewLineColor(AColor);
  PlotBorder (ARect);
  end;

procedure TSheetPlot.PlotBorder(x1,y1,x2,y2 : double; ALnWidth : double; AColor : TColor);
begin
  NewLineWidth(round(UnitToPixel*ALnWidth));
  PlotBorder(FloatRect(x1,y1,x2,y2),AColor);
  end;

procedure TSheetPlot.PlotBorder (ARect : TFRect; ALnWidth : double; AColor : TColor;
  AStyle : TLineStyle = lsSolid; AMode : TPenMode = pmCopy);
begin
  PlotCanvas.Pen.Mode:=AMode;
  NewLineColor(AColor);
  with ARect do begin
    PlotLine(Left,Bottom,Left,Top,ALnWidth,AStyle);
    PlotLine(Left,Top,Right,Top,ALnWidth,AStyle);
    PlotLine(Right,Top,Right,Bottom,ALnWidth,AStyle);
    PlotLine(Right,Bottom,Left,Bottom,ALnWidth,AStyle);
    end;
  PlotCanvas.Pen.Mode:=pmCopy;
  end;


// mit Farbe gefülltes Rechteck
procedure TSheetPlot.PlotArea (x1,y1,x2,y2 : double; AColor : TColor;
                               AStyle : TBrushStyle = bsSolid);
var
  Feld : TRect;
begin
  PlotCanvas.Brush.Style:=AStyle;
  NewFillColor(AColor);
  with Feld do begin
    Scale (x1,y1,Left,Bottom); Scale (x2,y2,Right,Top);
    end;
  FillRectangle(Feld);
  end;

procedure TSheetPlot.PlotArea (ARect : TFRect; AColor : TColor;
                               AStyle : TBrushStyle = bsSolid);
begin
  with ARect do PlotArea(Left,Bottom,Right,Top,AColor,AStyle);
  end;

procedure TSheetPlot.PlotArea (AArea : TFloatArea; AColor : TColor;
                               AStyle : TBrushStyle = bsSolid);
begin
  with AArea do PlotArea(Left,Bottom,Left+Width,Bottom+Height,AColor,AStyle);
  end;

procedure TSheetPlot.PlotRect (x1,y1,x2,y2 : double; ALnWidth : double; AColor,BColor : TColor);
begin
  PlotArea(x1,y1,x2,y2,BColor);
  PlotBorder(x1,y1,x2,y2,ALnWidth,AColor);
  end;

procedure TSheetPlot.PlotRect (ARect : TFRect; ALnWidth : double; AColor,BColor : TColor);
begin
  with ARect do PlotArea(Left,Bottom,Right,Top,BColor);
  PlotBorder(ARect,ALnWidth,AColor);
  end;

{------------------------------------------------------------------}
procedure TSheetPlot.PlotImage(AArea : TFloatArea; AImage : TBitmap);
begin
  OutputImage(ScaleArea(AArea),AImage);
  end;

(* ------------------------------------------------------------------------ *)
procedure TSheetPlot.PlotDrawingLine (AStart,AEnd : TFPoint; AProperties : TDrawingProperties);
var
  xw,xl,m,m2 : double;
  pt1,pt2    : TFPoint;

  function PlotArrow (pa,pe : TFPoint) : TFPoint;  // Pfeilspitze
  var
    pt : array [0..2] of TPoint;
    x1,x2,y1,y2 : double;
  begin
    x1:=pa.X; y1:=pa.Y;
    x2:=pe.X; y2:=pe.Y;
    with pt[0] do begin   // Pfeilspitze
      x:=round(UnitToPixel*x2); y:=round(UnitToPixel*y2);
      end;
    if abs(x2-x1)>abs(y2-y1) then begin
      m:=(y2-y1)/(x2-x1); m2:=asign(sqrt(1+sqr(m)),x1-x2);   // tan
      with pt[1] do begin
        x:=round(UnitToPixel*(x2-(xl-xw*m)/m2));
        y:=round(UnitToPixel*(y2-(xl*m+xw)/m2));
        end;
      with pt[2] do begin
        x:=round(UnitToPixel*(x2-(xl+xw*m)/m2));
        y:=round(UnitToPixel*(y2-(xl*m-xw)/m2));
        end;
      with Result do begin
        x:=x2-xl/m2; y:=y2-xl*m/m2;
        end;
      end
    else begin
      m:=(x2-x1)/(y2-y1); m2:=asign(sqrt(1+sqr(m)),y2-y1);   // cot
      with pt[1] do begin
        x:=round(UnitToPixel*(x2+(xl*m-xw)/m2));
        y:=round(UnitToPixel*(y2+(xl+xw*m)/m2));
        end;
      with pt[2] do begin
        x:=round(UnitToPixel*(x2+(xl*m+xw)/m2));
        y:=round(UnitToPixel*(y2+(xl-xw*m)/m2));
        end;
      with Result do begin
        x:=x2+xl*m/m2; y:=y2+xl/m2;
        end;
      end;
    DrawPolygon(pt,true);
    end;

begin
  pt1:=AStart; pt2:=AEnd;
  PlotCanvas.Brush.Style:=bsSolid;
  with AProperties do begin
    xl:=-HdLength; xw:=-HdWidth/2;
    NewFillColor(LColor);
    NewLineColor(LColor);
    NewLineWidth(5);
    if (ArrowStyle=asBoth) or (ArrowStyle=asEnd) then pt2:=PlotArrow (AStart,AEnd);
    if (ArrowStyle=asBoth) or (ArrowStyle=asBegin) then pt1:=PlotArrow (AEnd,AStart);
    end;
  NoClipWin;
  NewLineWidth(round(UnitToPixel*AProperties.LWidth)); // Linie
  with AProperties do PlotLine(pt1,pt2,LWidth,Style);
  end;

procedure TSheetPlot.PlotDrawingRect(ARect : TFRect; AProperties : TDrawingProperties);
begin
  with AProperties do begin
    if not Transparent then PlotArea(ARect,BgColor);
    if Border then PlotBorder(ARect,LWidth,LColor,Style);
    end;
  end;

{------------------------------------------------------------------}
//Schriftart
function TSheetPlot.GetTextFont : TPlotFont;              // Textfonts
begin
  with FPlotCanvas.Font do begin
    Result.FontName:=Name;
    Result.FontStyle:=Style;
    Result.FontAngle:=-round(Orientation/10);
    Result.FontSize:=abs(Height)/UnitToPixel;
    Result.FontColor:=Color;
    end;
//  FPlotFont:=Result;
  end;

procedure TSheetPlot.NewTextFont (AFont : TPlotFont);
begin
  with FPlotCanvas.Font do begin
    if Name<>AFont.FontName then Name:=AFont.FontName;
    Style:=AFont.FontStyle;
    Orientation:=-AFont.FontAngle*10;
    Height:=-round(AFont.FontSize*UnitToPixel);
    NewTextColor(AFont.FontColor);
    FontChange:=true;
    end;
  GetTextRot;
//  FPlotFont:=AFont;
  end;

procedure TSheetPlot.NewTextHeight (AHeight : double);
begin
  FPlotCanvas.Font.Height:=-round(AHeight*UnitToPixel);
  FontChange:=true;
  end;

procedure TSheetPlot.NewTextColor (AColor : TColor);
begin
  FPlotCanvas.Font.Color:=AColor;
  end;

procedure TSheetPlot.NewTextStyle (AStyle : TFontStyles);
begin
  with FPlotCanvas.Font do begin
    Style:=AStyle;
    FontChange:=true;
    end;
  end;

procedure TSheetPlot.NewTextRot (Angle : integer);
begin
  FPlotCanvas.Font.Orientation:=-Angle*10;
  FontChange:=true;
  FOrientation:=Angle;
  SinTextRot:=sin(Pi180*FOrientation); CosTextRot:=cos(Pi180*FOrientation);
  end;

procedure TSheetPlot.UseSymbolFont;
begin
  FPlotCanvas.Font.Name:=defSymbolName;
  FontChange:=true;
  end;

function TSheetPlot.OffsetScale (n : integer) : double;
begin
  case n of
  1 : Result:=0.2;    // hoch
  2 : Result:=-0.6;   // tief
  3 : Result:=0.1;    // Symbol
  else Result:=0.0;
    end;
  end;

// Texthöhe in cm/inch
function TSheetPlot.GetTxtHeight : double;
begin
  Result:=abs(FPlotCanvas.Font.Height)/UnitToPixel;
  end;

// Textfarbe
function TSheetPlot.GetTextColor : TColor;
begin
  Result:=FPlotCanvas.Font.Color;
  end;

// Schriftstil
function TSheetPlot.GetTextStyle : TFontStyles;
begin
  Result:=FPlotCanvas.Font.Style;
  end;

// Textrichtung
function TSheetPlot.GetTextRot : integer;
begin
  Result:=-round(FPlotCanvas.Font.Orientation/10);
  FOrientation:=Result;
  SinTextRot:=sin(Pi180*FOrientation); CosTextRot:=cos(Pi180*FOrientation);
  end;

{------------------------------------------------------------------}
// Textausgabe
{ Formatierungen:
  \<text>\ = kursiv
  *<text>* = fett
  ^<text>^ = hochgestellt
  _<text>_ = tiefgestellt
  doppelte Formatierungszeichen werden als Einzelzeichen interpretiert:
     : \\ = \, ** = *, ^^ = ^, __ = _
  }

type
  TCharSet =  set of char;

const
  FormatChars : TCharSet = ['*','\','^','_','!'];
  ReducedHeight = 0.6;       // Größe für hoch- und tiefgestellte Zeichen

function RemoveDoubleFormChars (const s : string) : string;
var
  i  : integer;
  cf : char;
begin
  Result:=''; cf:=#0;
  for i:=1 to length(s) do if s[i] in FormatChars then begin
    if cf<>s[i] then begin
      cf:=s[i]; Result:=Result+cf;
      end
    else cf:=#0;
    end
  else begin
    Result:=Result+s[i]; cf:=#0;
    end;
  end;

function FindNextFormChar (const s : string; n : integer; FChars : TCharSet) : integer;
begin
  while (n<=length(s)) do begin
    if (s[n] in FChars) then begin
      if (n<length(s)) and (s[n]=s[n+1]) then inc(n) else Break;
      end;
    inc(n);
    end;
  Result:=n;
  end;

function GetFormat (c : char) : TFormatType;
begin
  for Result:=Low(TFormatType) to High(TFormatType) do if FormatMarker[Result]=c then Exit;
  Result:=ftNormal;
  end;

procedure ReadNextStringSection (var s,t : string; var ft : TFormatType);
var
  n  : integer;
begin
  if length(s)>0 then begin
    ft:=GetFormat(s[1]);
    if ft<>ftNormal then begin
      n:=FindNextFormChar(s,2,[s[1]]);
      t:=RemoveDoubleFormChars(copy(s,2,n-2));
      Delete(s,1,n);
      end
    else begin
      n:=FindNextFormChar(s,1,FormatChars);
      t:=RemoveDoubleFormChars(copy(s,1,n-1));
      Delete(s,1,n-1);
      end;
    end
  else begin
    t:=''; ft:=ftNormal;
    end;
  end;

{------------------------------------------------------------------}
// Breite eines formatierten Textes in cm/inch
function TSheetPlot.GetFormattedTextWidth (S : string) : double;
var
  t  : string;
  ft : TFormatType;
  pf : TPlotFont;
  tm : TTextMetric;
begin
  pf:=TextFont; Result:=0;
  repeat
    ReadNextStringSection(s,t,ft);
    case ft of
    ftItalic : TextStyle:=[fsItalic];
    ftBold   : TextStyle:=[fsBold];
    ftSuper,ftSub : TextHeight:=ReducedHeight*TextHeight;
    ftSymbol : UseSymbolFont;
      end;
    GetTextMetrics(FPlotCanvas.Handle,tm);
    Result:=Result+(FPlotCanvas.TextWidth(t)-tm.tmOverhang)/UnitToPixel;
    TextFont:=pf;  // Standardfont
    until length(s)=0;
  end;

// Höhe eines Textes in cm/inch
function TSheetPlot.GetFormattedTextHeight (S : string) : double;
var
  h,d : integer;
  t   : string;
  ft  : TFormatType;
begin
  h:=0; d:=0;
  repeat
    ReadNextStringSection(s,t,ft);
    if (ft=ftSuper) then h:=1
    else if (ft=ftSub) then d:=1;
    until length(s)=0;
//  n:=FPlotCanvas.TextHeight('X');
  Result:=(1.2*abs(FPlotCanvas.Font.Height)/UnitToPixel)*IntPower(1.1,h)*IntPower(1.05,d);
  end;

{------------------------------------------------------------------}
// Breite eines Textes in cm/inch
function TSheetPlot.GetTextWidth (S : string; Formatted : boolean = false) : double;
var
  ii : integer;
begin
  if Formatted then begin
    ii:=1;
    if length(s)>0 then repeat
      if (S[ii]='_') or (S[ii]='^') then delete(S,ii,1)
      else inc(ii);
      until ii>length(s);
    end;
  Result:=FPlotCanvas.TextWidth(S)/UnitToPixel;
  end;

// Höhe eines Textes in cm/inch
function TSheetPlot.GetTextHeight (S : string; Formatted : boolean = false) : double;
var
  i,n,h,d : integer;
begin
  n:=0; h:=-5; d:=5;
  if length(s)=0 then s:='x';
  for i:=1 to length(s) do begin
    if (s[i]='_') then dec(n)
    else if (s[i]='^') then inc(n);
    if n>h then h:=n;
    if n<d then d:=n;
    end;
  Result:=(FPlotCanvas.TextHeight(s)/UnitToPixel)*pwr(1.1,h)*pwr(1.05,abs(d));
  end;

{------------------------------------------------------------------}
procedure TSheetPlot.GetTextOrigin(Align : TTextAlign; xd,yd : double; Invers : boolean; var x,y : double);
var
  dx,dy : double;
begin
  case Align of
  alLeftBottom : begin
      dx:=-SinTextRot*yd; dy:=CosTextRot*yd;
      end;
  alLeftCenter : begin
      dx:=-0.55*SinTextRot*yd; dy:=0.55*CosTextRot*yd;
      end;
  alLeftTop : begin
      dx:=-0.1*SinTextRot*yd; dy:=0.1*CosTextRot*yd;
      end;
  alCenterBottom : begin
      dx:=-0.5*CosTextRot*xd-SinTextRot*yd; dy:=-0.5*SinTextRot*xd+CosTextRot*yd;
      end;
  alCenterAll : begin
      dx:=-0.5*CosTextRot*xd-0.55*SinTextRot*yd; dy:=-0.5*SinTextRot*xd+0.55*CosTextRot*yd;
      end;
  alCenterTop : begin
      dx:=-0.5*CosTextRot*xd-0.1*SinTextRot*yd; dy:=-0.5*SinTextRot*xd+0.1*CosTextRot*yd;
      end;
  alRightBottom : begin
      dx:=-CosTextRot*xd-SinTextRot*yd; dy:=-SinTextRot*xd+CosTextRot*yd;
      end;
  alRightCenter : begin
      dx:=-CosTextRot*xd-0.55*SinTextRot*yd; dy:=-SinTextRot*xd+0.55*CosTextRot*yd;
      end;
  alRightTop : begin
      dx:=-CosTextRot*xd-0.1*SinTextRot*yd; dy:=-SinTextRot*xd+0.1*CosTextRot*yd;
      end;
    end;
  if Invers then begin
    x:=x-dx; y:=y-dy;
    end
  else begin
    x:=x+dx; y:=y+dy;
    end;
  end;

function TSheetPlot.PlotText (X,Y : double; AText : string; Align : TTextAlign) : TFPoint;
var
  xd,yd,
  dx,yoff    : double;
  t          : string;
  ft         : TFormatType;
  pf         : TPlotFont;
  n          : integer;
begin
  pf:=TextFont;
  xd:=GetFormattedTextWidth(AText);
  yd:=GetTxtHeight*0.9; (* Durchschuss beachten - abhängig vom Font ?? *)
  GetTextOrigin(align,xd,yd,false,x,y);
  BeginTextAt(x,y,SinTextRot*yd,-CosTextRot*yd);
  if length(AText)>0 then begin
    repeat
      ReadNextStringSection(AText,t,ft);
      n:=0;
      case ft of
      ftItalic : TextStyle:=[fsItalic];
      ftBold   : TextStyle:=[fsBold];
      ftSuper,ftSub : begin
          TextHeight:=ReducedHeight*TextHeight;
          if ft=ftSuper then n:=1 else n:=2;
          end;
      ftSymbol : begin
          UseSymbolFont;
          n:=3;  // Korrektur für Symbol-Zeichensatz
          end;
        end;
      yoff:=OffsetScale(n)*yd;
      with PlotCanvas do begin
        if FTransText then SetBkMode(Handle,TRANSPARENT) else SetBkMode(Handle,OPAQUE);
        OutputText (Scale(x,y),Scale(-SinTextRot*yoff,CosTextRot*yoff),t);
        end;
      dx:=GetTextWidth(t,false); //+0.02;
      TextFont:=pf;  // Standardfont
      x:=x+CosTextRot*dx; y:=y+SinTextRot*dx;
      until length(AText)=0;
    end;
  GetTextOrigin(align,xd,yd,true,x,y);
  Result:=FloatPoint(x,y);
  end;

function TSheetPlot.PlotText (APos : TFPoint; AText : string; Align : TTextAlign) : TFPoint;
begin
  with APos do PlotText(X,Y,AText,Align);
  end;

procedure TSheetPlot.PlotComment (APos : TFPoint; AText : string; Properties : TTextProperties);
var
  x0,y0,w,h : double;
  rp : array[1..3] of TFPoint;
  i  : integer;
begin
  with Properties do begin
    TextFont:=Font;
    TextTransparency:=true;
    with PlotField,APos do begin
      x:=Left+X; y:=Bottom+Y;
      x0:=x; y0:=y;
      end;
    end;
  w:=GetFormattedTextWidth(AText);
  h:=GetFormattedTextHeight(AText);
  GetTextOrigin(Properties.Align,w,h,false,x0,y0);
  with rp[1] do begin
    x:=x0+CosTextRot*w; y:=y0+SinTextRot*w;
    end;
  with rp[2] do begin
    x:=x0+CosTextRot*w+SinTextRot*h; y:=y0+SinTextRot*w-CosTextRot*h;
    end;
  with rp[3] do begin
    x:=x0+SinTextRot*h; y:=y0-CosTextRot*h;
    end;
//  with rp[0]
  with FLastOutline do begin     // Umrandung
    Valid:=true;
    with Rect do begin
      Left:=x0; Right:=x0; Top:=y0; Bottom:=y0;
      for i:=1 to 3 do with rp[i] do begin
        if x<Left then Left:=x;
        if x>Right then Right:=x;
        if y<Bottom then Bottom:=y;
        if y>Top then Top:=y;
        end;
      end;
    with PlotField do Rect:=MoveRect(Rect,FloatPoint(-Left,-Bottom));
    end;
  NewTextColor(Properties.Font.FontColor);
  with APos do PlotText(x,y,AText,Properties.Align);
  end;

procedure TSheetPlot.PlotTextLines (APos : TFPoint; const AText : string; Properties : TTextProperties);
var
  h,w,x,y,d : double;
  i         : integer;
  sl        : TStringList;
  tm        : TTextMetric;
begin
  if length(AText)=0 then Exit;
  GetTextMetrics(FPlotCanvas.Handle,tm);
  sl:=TStringList.Create;
  with sl,Properties do begin
    Text:=AText;
    TextFont:=Font;
    TextTransparency:=true;
    with PlotField do begin
      x:=Left+APos.X; y:=Bottom+APos.Y;
      end;
    w:=0; h:=0;
    for i:=0 to Count-1 do begin
      d:=GetFormattedTextWidth(Strings[i]);
      if d>w then w:=d;
      d:=GetFormattedTextHeight(Strings[i]);
      if d>h then h:=d;
      end;
    d:=0.5*TextHeight;
//    w:=w+d;
    with FLastOutline do begin     // Umrandung
      Valid:=true; Rect:=FloatRect(x-d,y-d,x+w+d,y+Count*h);
      if not Transparent then PlotArea(Rect,BgColor);
      if Border then PlotBorder(Rect,LWidth,LColor);
      with Rect do begin
        Left:=Left-Plotfield.Left; Bottom:=Bottom-PlotField.Bottom;
        Right:=Right-Plotfield.Left; Top:=Top-PlotField.Bottom;
        end;
      end;
    NewTextColor(Properties.Font.FontColor);
    for i:=0 to Count-1 do PlotText(x,y+(Count-1-i)*h,Strings[i],alLeftBottom);
    end;
  sl.Free;
  end;

procedure TSheetPlot.PlotLegend (APos : TFPoint; const AText : string; ShowSymbol : boolean;
                      BColor : TColor; AProps : TTextProperties; AItem : TChartItem);
var
  x,y,ds,dl,d,
  h,lw          : double;
  bc,lc,ac      : TColor;
  ls            : TLineStyle;
  ShowLine,
  ShowRect      : boolean;
begin
  TextFont:=AProps.Font;
  TextTransparency:=true;
  with PlotField do begin
    x:=Left+APos.X; y:=Bottom+APos.Y;
    end;
  ds:=GetTextWidth(' '); ShowLine:=true; ShowRect:=false; dl:=GetTextWidth('XXX');
  case AItem.Itemtype of
  itCurve : with (AItem as TCurveItem).Properties do begin
            ShowLine:=JoinMode<>jmNone;
            if not ShowLine then dl:=SymSize;
            lc:=LColor; lw:=LWidth; ls:=LStyle;
            end;
  itFit   : with (AItem as TFitItem).Properties do begin
            lc:=LColor; lw:=LWidth; ls:=LStyle;
            end;
  itFunction : with (AItem as TFunctionItem).Properties do begin
            lc:=LColor; lw:=LWidth; ls:=LStyle;
            end;
  itGraph : with (AItem as TGraphItem).Properties do begin
            lc:=LColor; lw:=LWidth; ac:=BColor; ShowRect:=true;
            end;
  else Exit;
    end;
  h:=GetTextHeight(AText,true);
  d:=0.5*TextHeight;
  with AProps,FLastOutline do begin    // Umrandung
    Valid:=true; Rect:=FloatRect(x-d,y-d,x+2*ds+dl+GetTextWidth(AText,true)+d,y+h);
    if Transparent then bc:=BColor
    else begin
      PlotArea(Rect,BgColor); bc:=BgColor;
      end;
    if Border then PlotBorder(Rect,LWidth,LColor);
    with Rect do begin
      Left:=Left-Plotfield.Left; Bottom:=Bottom-PlotField.Bottom;
      Right:=Right-Plotfield.Left; Top:=Top-PlotField.Bottom;
      end;
    end;
  NewLineColor(lc); d:=0.7*d;
  if ShowRect then begin
    PlotRect (x+ds,y,x+ds+dl,y+2*d,lw,lc,ac);
    end
  else begin
    if ShowLine then PlotLine(x+ds,y+d,x+ds+dl,y+d,lw,ls);
    if ShowSymbol then with (AItem as TCurveItem).Properties do
      PlotMark(x+ds,y+d,SymType,SymSize,LWidth,MColor,bc);
    end;
  NewTextColor(AProps.Font.FontColor);
  PlotText(x+2*ds+dl,y,AText,alLeftBottom);
  end;

(* ------------------------------------------------------------------------ *)
procedure TSheetPlot.PlotAxis (AAxis : TaxisItem);
(*  AxNr:      Nummer der Achse für diese Achse *)
var
  NDek,ND,ifein,md,
  TickCount,Decades                 : integer;
  AxisLength,
  ZWG,ZWF,FEIN,Delta,
  c1,c2,f1,f2,Grid,axbl,axtr,
  XX,AFEIN,XS,YS,Y,axp              : double;
  ScText,Rot,Frame,tmm,LBU,
  VSW,RSW,ATR,MSW,Txt,ShowLn        : boolean;
  Align                             : TTextAlign;

  function MakeLabel (x : double; np : integer; nt : TNotation) : string;
  begin
    if nt=noPrefix then Result:=FloatToPrefixStr(X,np,'')
    else if nt=noEng then Result:=NumberToPlotString(FloatToStrE(X,np))
    else if nt=noSci then Result:=NumberToPlotString(FloatToStrS(X,np))
    else Result:=FloatToFixStr(X,np);
    end;

  function XInside(X : double) : boolean;
  begin
    with ChartField do Result:=(abs(Left-X)>FMinDist) and (abs(Right-X)>FMindist);
    end;

  function YInside(Y : double) : boolean;
  begin
    with ChartField do Result:=(abs(Bottom-Y)>FMinDist) and (abs(Top-Y)>FMindist);
    end;

  procedure GetTickMarkPos (TmStyle : TTickMarks; AxBottomLeft : boolean; CTmSize : double; var d1,d2 : double);
  begin
    case TmStyle of
    tmInner : begin
        if AxBottomLeft then begin
          d1:=0; d2:=CTmSize;
          end
        else begin
          d1:=0; d2:=-CTmSize;
          end
        end;
    tmOuter : begin
        if AxBottomLeft then begin
          d1:=0; d2:=-CTmSize;
          end
        else begin
          d1:=0; d2:=CTmSize;
          end
        end;
    else begin
        d1:=-CTmSize; d2:=CTmSize;
        end;
      end;
    end;

type
  TLogScale = record
     MajorTicks : integer;
     TickWidth      : double;
     end;
const
  LogScale : array[0..6] of TLogScale = (
    (MajorTicks : 89; TickWidth :0.1),
    (MajorTicks : 44; TickWidth :0.2),
    (MajorTicks : 17; TickWidth :0.5),
    (MajorTicks :  8; TickWidth :1.0),
    (MajorTicks :  1; TickWidth :4.0),
    (MajorTicks :  0; TickWidth :9.0),
    (MajorTicks :  0; TickWidth :9.0));

  procedure LogAxis(Mode : integer; xp : double; cm1,cm2,fm1,fm2 : double; ShowText,ShowGrid,Mirror : boolean);
  var
    i,j,k,kk    : integer;
    xx,wd       : double;
    lp1,lp2     : TFPoint;
    s           : string;
    pu          : integer;
  begin
    with AAxis,Properties do begin
      if Mirror and (TmStyle<>tmBoth) then begin  // Markierungen an der Achse spiegeln
        cm1:=-cm1; cm2:=-cm2; fm1:=-fm1; fm2:=-fm2;
        end;
      lp1:=FloatPoint(0,0); pu:=0;
      with LogScale[Mode] do begin
        TickCount:=MajorTicks; Delta:=TickWidth;
        end;
      for i:=NDek downto 0 do begin
        for j:=TickCount downto 0 do begin   (* Raster *)
          Txt:=true;
          if TickCount=89 then begin
            if j<25 then begin
              kk:=3; Fein:=0.025;
              end
            else begin
              kk:=1; Fein:=0.05;
              Txt:=(j mod 2)=0;
              end;
            end
          else if TickCount=44 then begin
            if j<12 then begin
              kk:=3; Fein:=0.05;
              end
            else begin
              kk:=1; Fein:=0.1;
              Txt:=(j mod 5)=0;
              end;
            end
          else if TickCount=17 then begin
            if j<5 then begin
              kk:=4; Fein:=0.1;
              end
            else begin
              kk:=1; Fein:=0.25;
              Txt:=(j mod 2)=0;
              end;
            end
          else if TickCount=8 then begin
            if NDek=2 then begin
              if j<5 then begin
                kk:=4; Fein:=0.2;
                end
              else begin
                kk:=1; Fein:=0.5;
                Txt:=false;
                end;
              end
            else begin
              if j<5 then begin
                kk:=9; Fein:=0.1;
                end
              else begin
                kk:=4; Fein:=0.2;
                end;
              end;
            end
          else if TickCount=3 then begin
            if j<2 then begin
              kk:=4; Fein:=0.05;
              end
            else begin
              kk:=2; Fein:=0.1;
              end;
            end
          else if TickCount=1 then begin
            if j=0 then begin
              kk:=7; Fein:=0.5;
              end
            else begin
              kk:=4; Fein:=1;
              end;
            end
          else if Mode=6 then kk:=0 else kk:=2;
          Txt:=Txt and ShowText;
          for k:=0 to kk do begin
            if kk=2 then begin
              case k of
              1 : xx:=1;
              2 : xx:=4;
              else xx:=0;
                end;
              end
            else xx:=Fein*k;
            xx:=(1.0+Delta*j+xx)*Pwr(10.0,i+Decades);
            if (xx>=MinVal) and (xx<=MaxVal) then begin
              Y:=Scale(XX);
              NewLineColor(LnColor);
              if NOT VSW then begin
              (* HORIZONTAL AXIS *)
                if k=0 then begin
                  if ShowGrid and XInside(Y) then with ChartField do begin
                    PlotLine (Y,Bottom,Y,Top,GrWidth,GrStyle);
                    end;
                  if TmStyle<>tmNone then PlotLine (Y,xp+cm1,Y,xp+cm2,IvWidth);     // major tick marks
                  if Txt then begin
                    NewTextColor(LabFont.FontColor);
                    s:=MakeLabel(XX,nd,Notation);
                    wd:=GetFormattedTextWidth(s);
                    lp2:=lp1;
                    lp1:=FloatPoint(Y+XS,xp+YS);
                    if ((pu=0) or (abs(lp1.X-lp2.X)>wd)) and not ((asNoEdgeText in AxStyles) and (i+j+k=0)) then begin
                      if (pu=1) and LBU then begin
                        pu:=2;
                        if abs(lp1.X-lp2.X)-wd<GetFormattedTextWidth(AUnit) then PlotText (lp1,AUnit,Align)
                        else begin
                          PlotText ((lp1.X+lp2.X)/2,lp1.Y,AUnit,Align);
                          PlotText (lp1,s,Align);
                          end;
                        end
                      else begin
                        PlotText (lp1,s,Align);
                        if pu=0 then pu:=1;
                        end;
                      end;
                    end;
                  end
                else if TmStyle<>tmNone then PlotLine (Y,xp+fm1,Y,xp+fm2,TmWidth);
                end
              else begin
              (* VERTICAL AXIS *)
                if k=0 then begin
                  if ShowGrid and YInside(Y) then with ChartField do begin
                    PlotLine (Left,Y,Right,Y,GrWidth,GrStyle);
                    end;
                  if TmStyle<>tmNone then PlotLine (xp+cm1,Y,xp+cm2,Y,IvWidth);    // major tick marks
                  if Txt then begin
                    NewTextColor(LabFont.FontColor);
                    s:=MakeLabel(XX,nd,Notation);
                    wd:=GetFormattedTextWidth(s);
                    lp2:=lp1;
                    lp1:=FloatPoint(xp+XS,Y+YS);
                    if ((pu=0) or not rot or (abs(lp1.Y-lp2.Y)>wd)) and not ((asNoEdgeText in AxStyles) and (i+j+k=0)) then begin
                      if (pu=1) and LBU then begin
                        pu:=2;
                        if rot and (abs(lp1.Y-lp2.Y)-wd<GetFormattedTextWidth(AUnit)) then PlotText (lp1,AUnit,Align)
                        else begin
                          PlotText (lp1.X,(lp1.Y+lp2.Y)/2,AUnit,Align);
                          PlotText (lp1,s,Align);
                          end;
                        end
                      else begin
                        PlotText (lp1,s,Align);
                        if pu=0 then pu:=1;
                        end;
                      end;
                    end;
                  end
                else if TmStyle<>tmNone then PlotLine (xp+fm1,Y,xp+fm2,Y,TmWidth);
                end;
              end;
            end;
          end;
        end;
      NewLineColor(LnColor);             // axis line
      with ChartField do if VSW then PlotLine (xp,Bottom,xp,Top,LnWidth)
      else PlotLine (Left,xp,Right,xp,LnWidth);
      end;
    end;

  procedure TimeGrid (Anf,Ende : TDateTime);
  (*  Anf,Ende  : Zeitbereich im TDateTime-Format
      Ende muß größer sein als Anf
      es wird berechnet:
      Grid  - 1. Rasterpunkt
      Zwg   - Abstand der Rasterpunkte
      AFein - 1. Feinrasterpunkt
      Zwf   - Feinrasterabstand
      IFein - Anzahl der Feinrasterpunkte *)
  var
    Delta,XG,XF,Fein : TDateTime;
    xa,xb,dec        : double;
  begin
    Delta:=Ende-Anf+0.5*OneSecond;
    if Delta<0 then Delta:=1.0;
    if Delta>10 then begin   (* mehr als 10 Tage *)
      dec:=pwr(10.0,aint(lg(Delta)-0.05)); xa:=Anf/dec;
      if xa<=2.1 then xb:=0.5 else
        if xa<=5.1 then xb:=1.0 else xb:=2.0;
      Zwg:=round(xb*dec);
      if Delta<=20 then Zwf:=0.25      (* 6 h *)
      else if Delta<=50 then Zwf:=0.5  (* 12 h *)
        else Zwf:=Zwg/10.0;
      end
    else if Delta>5 then begin
      Zwg:=1.0; Zwf:=2*OneHour;   (* 1 d, 2 h *)
      end
    else if Delta>2 then begin
      Zwg:=0.5; Zwf:=OneHour;   (* 12 h, 1 h *)
      end
    else if Delta>1 then begin
      Zwg:=6*OneHour; Zwf:=30*OneMinute;   (* 6 h, 30 min *)
      end
    else if Delta>0.5 then begin   (* mehr als 12 h *)
      Zwg:=3*OneHour; Zwf:=15*OneMinute;   (* 3 h, 15 min *)
      end
    else if Delta>0.25 then begin   (* mehr als 6 h *)
      Zwg:=OneHour; Zwf:=5*OneMinute;   (* 1 h, 5 min *)
      end
    else if Delta>3*OneHour then begin   (* mehr als 3 h *)
      Zwg:=30*OneMinute; Zwf:=2*OneMinute;   (* 30 min, 2 min *)
      end
    else if Delta>OneHour then begin   (* mehr als 1 h *)
      Zwg:=15*OneMinute; Zwf:=OneMinute;   (* 15 min, 1 min *)
      end
    else if Delta>30*OneMinute then begin   (* mehr als 30 min *)
      Zwg:=5*OneMinute; Zwf:=30*OneSecond;   (* 5 min, 30 s *)
      end
    else if Delta>15*OneMinute then begin   (* mehr als 15 min *)
      Zwg:=2*OneMinute; Zwf:=15*OneSecond;   (* 2 min, 15 s *)
      end
    else if Delta>5*OneMinute then begin   (* mehr als 5 min *)
      Zwg:=OneMinute; Zwf:=5*OneSecond;   (* 1 min, 5 s *)
      end
    else if Delta>2*OneMinute then begin   (* mehr als 2 min *)
      Zwg:=30*OneSecond; Zwf:=2*OneSecond;   (* 30 s, 2 s *)
      end
    else if Delta>OneMinute then begin   (* mehr als 1 min *)
      Zwg:=15*OneSecond; Zwf:=OneSecond;   (* 15 s, 1 s *)
      end;
    XG:=AInt((Anf-0.5*OneSecond)/Zwg+1.0);
    XF:=AInt((Anf-0.5*OneSecond)/Zwf+1.0);
    Fein:=AInt(Ende/Zwf-0.1)-XF;
    Grid:=XG*Zwg; Zwg:=ASIGN(Zwg,Delta);
    AFein:=XF*Zwf; Zwf:=ASIGN(Zwf,Fein);
    IFein:=round(abs(Fein));
    end;

  function PlotTime (X,Y : double;
                     dt  : TDateTime) : boolean;
  var
    XL : double;
    S  : String;
  begin
    if Zwg<1 then begin  (* Raster feiner als 1 Tag *)
      if Zwg>=1/24.0 then s:='hh:00'
      else if Zwg>=OneSecond then s:='hh:nn'
        else s:='hh:nn:ss';
      s:=FormatDateTime (s,dt);
      XL:=0.5*GetTextWidth(S,false);
      if NOT VSW then begin (* horizontale Achse *)
        with ChartField do if X+XL>Right then X:=Right-XL;
        PlotText (X,Y,S,Align);
        end
      else begin     // vertikale Achse
        with ChartField do if Y+XL>Top then Y:=Top-XL;
        PlotText (X,Y,S,Align);
        end;
      Result:=true;
      end
    else Result:=false;
    end;

  procedure PlotDate (X,Y         : double;
                      dt          : TDateTime;
                      wd          : boolean);
  var
    XL : double;
    S  : String;
  begin
    s:=FormatDateTime ('yyyy-mm-dd',dt);
    if Wd then s:=s+' ('+GetShortDayOfWeek(dt)+')';
    XL:=0.5*GetTextWidth(S,false);
    if NOT VSW then begin (* horizontale Achse *)
      with ChartField do if X+XL>Right then X:=Right-XL;
      PlotText (X,Y,S,Align);
      end
    else begin     // vertikale Achse
      with ChartField do if Y+XL>Top then Y:=Top-XL;
      PlotText (X,Y,S,Align);
      end;
    PlotText (X,Y,S,Align);
    end;

  procedure TimeAxis(xp : double; cm1,cm2,fm1,fm2 : double; ShowText,ShowGrid,Mirror : boolean);
  var
    I            : integer;
    XT           : TDateTime;
    X,Y,ng       : double;
    first        : boolean;
  begin
    with AAxis,Properties do begin
      if Mirror and (TmStyle<>tmBoth) then begin  // Markierungen an der Achse spiegeln
        cm1:=-cm1; cm2:=-cm2; fm1:=-fm1; fm2:=-fm2;
        end;
      first:=true; ng:=Grid;
      for i:=0 to IFein do begin
        XT:=AFein+i*Zwf; X:=Scale(XT);
        NewLineColor(LnColor);
        if ABS((XT-ng)/Zwf) <= 0.5 then begin
          if NOT VSW then begin (* horizontale Achse *)
         (*  zeichne die groben Skalierungen mit Beschriftung und
            das vertikale Raster der Hor. Achse *)
            if ShowGrid and XInside(X) then with ChartField do begin
            (* vert. Raster *)
              PlotLine (X,Bottom,X,Top,GrWidth,GrStyle);
              end;
          (* grobe Skalenmarken und Beschriftung *)
            if TmStyle<>tmNone then PlotLine (x,xp+cm1,X,xp+cm2,IvWidth);
            if ShowText then begin
              y:=xp+ys;
              NewTextColor(LabFont.FontColor);
              if PlotTime (X+xs,y,ng) then y:=y-1.2*LabFont.FontSize;
              if (asDate in AxStyles) and (First or (abs(frac(ng))<OneSecond)) then begin
                PlotDate (x+xs,y,ng,asWeekday in AxStyles);
                first:=false;
                end;
              end;
            end
          else begin // vertikale Achse
         (*  zeichne die groben Skalierungen mit Beschriftung und
            das vertikale Raster der Hor. Achse *)
            if ShowGrid and YInside(X) then with ChartField do begin
            (* vert. Raster *)
              PlotLine (Left,X,Right,X,GrWidth,GrStyle);
              end;
          (* grobe Skalenmarken und Beschriftung *)
            if TmStyle<>tmNone then PlotLine (xp+cm1,x,xp+cm2,X,IvWidth);
            if ShowText then begin
              y:=x+ys; x:=xp+xs;
              NewTextColor(LabFont.FontColor);
              if PlotTime (x,y,ng) then begin
                if asRotate in AxStyles then x:=x-1.2*LabFont.FontSize else y:=y-1.2*LabFont.FontSize;
                end;
              if (asDate in AxStyles) and (First or (abs(frac(ng))<OneSecond)) then begin
                PlotDate (x,y,ng,asWeekday in AxStyles);
                first:=false;
                end;
              end;
            end;
          ng:=ng+Zwg;
          end;
        end;
    (* feine Skalenmarken *)
      ng:=ng-ZWG;
      NewLineColor(LnColor);
      if TmStyle<>tmNone then for i:=IFein downto 0 do begin
        XT:=AFEIN+i*ZWF;
        if ABS((XT-ng)/ZWF) <= 0.5 then ng:=ng-ZWG
        else begin
          X:=Scale(XT);
          if NOT VSW then PlotLine (X,xp+fm1,X,xp+fm2,TmWidth)
          else PlotLine (xp+fm1,X,xp+fm2,X,TmWidth);
          end;
        end;
      (* Achsenlinie*)
      with ChartField do if VSW then PlotLine (xp,Bottom,xp,Top,LnWidth)
      else PlotLine (Left,xp,Right,xp,LnWidth);
      end;
    end;

  procedure InvAxis(xp : double; cm1,cm2,fm1,fm2 : double; ShowText,ShowGrid,Mirror : boolean);
  var
    i,j,kk,pu : integer;
    xa,xb,XX  : double;
    lp1,lp2   : TFPoint;
    long      : boolean;

    procedure PlotTickMarks;
    var
      k    : integer;
      s    : string;
      wd   : double;
    begin
      with AAxis,Properties do begin
        Txt:=Txt and ShowText;
        for k:=0 to kk do begin
          if (xx>=xa) and (xx<=xb) then begin
            Y:=Scale(XX);
            NewLineColor(LnColor);
            if NOT VSW then begin
            (* HORIZONTAL AXIS *)
              if (k=0) and Long then begin
                if ShowGrid and XInside(Y) then with ChartField do begin
                (* vert. Raster *)
                  PlotLine (Y,Bottom,Y,Top,GrWidth,GrStyle);
                  end;
                if TmStyle<>tmNone then PlotLine (Y,xp+cm1,Y,xp+cm2,IvWidth);
                if Txt then begin
                  NewTextColor(LabFont.FontColor);
                  s:=MakeLabel(XX,nd,Notation);
                  wd:=GetFormattedTextWidth(s);
                  lp2:=lp1;
                  lp1:=FloatPoint(Y+XS,xp+YS);
                  if (pu=0) and (((NDek<2) and (i=NDek)) or (i=1)) then begin
                    if (NDek<2) then begin
                      PlotText ((lp1.X+lp2.X)/2,lp1.Y,AUnit,Align);
                      PlotText (lp1,s,Align);
                      end
                    else PlotText (lp1,AUnit,Align);
                    pu:=1;
                    end
                  else if lp2.X+wd<lp1.X then begin
                    PlotText (lp1,s,Align);
                    end;
                  end;
                end
              else if TmStyle<>tmNone then PlotLine (Y,xp+fm1,Y,xp+fm2,TmWidth);
              end
            else begin  // vert. Achse
              if (k=0) and Long then begin
                if ShowGrid and YInside(Y) then with ChartField do begin
                (* hor. Raster *)
                  PlotLine (Left,Y,Right,Y,GrWidth,GrStyle);
                  end;
                if TmStyle<>tmNone then PlotLine (xp+cm1,Y,xp+cm2,Y,IvWidth);
                if Txt then begin
                  NewTextColor(LabFont.FontColor);
                  s:=MakeLabel(XX,nd,Notation);
                  wd:=GetFormattedTextWidth(s);
                  lp2:=lp1;
                  lp1:=FloatPoint(xp+XS,Y+YS);
                  if (pu=0) and (((NDek<2) and (i=NDek)) or (i=1)) then begin
                    if (NDek<2) then begin
                      PlotText (lp1.X,(lp1.Y+lp2.Y)/2,AUnit,Align);
                      PlotText (lp1,s,Align);
                      end
                    else PlotText (lp1,AUnit,Align);
                    pu:=1;
                    end
                  else if not rot or (lp2.Y+wd<lp1.Y) then begin
                    PlotText (lp1,s,Align);
                    end;
                  end;
                end
              else if TmStyle<>tmNone then PlotLine (xp+fm1,Y,xp+fm2,Y,TmWidth);
              end;
            end;
          xx:=xx+Fein;
          end;
        end;
      end;

  begin
    with AAxis,Properties do begin
      if Mirror and (TmStyle<>tmBoth) then begin  // Markierungen an der Achse spiegeln
        cm1:=-cm1; cm2:=-cm2; fm1:=-fm1; fm2:=-fm2;
        end;
      lp1:=FloatPoint(0,0);
      if LBU then pu:=0 else pu:=-1;
      xx:=zwg; xa:=MinVal; xb:=MaxVal;
      for i:=0 to NDek do begin
        Txt:=true; Long:=true;
        if i=0 then begin
          for j:=0 to 9 do begin   (* Raster *)
            if j<2 then begin
              kk:=3; Fein:=0.025*zwg;
              end
            else if j<4 then begin
              kk:=1; Fein:=0.05*zwg;
              end
            else begin
              kk:=0; Fein:=0.1*zwg;
              Txt:=(j mod 2)=0; Long:=Txt;
              end;
            PlotTickMarks;
            end;
          for j:=0 to 4 do begin
            kk:=1; Fein:=0.1*zwg;
            Txt:=j<4; Long:=Txt;
            PlotTickMarks;
            end;
          for j:=0 to 6 do begin
            if j<2 then begin
              kk:=1; Fein:=0.5*zwg;
              end
            else begin
              kk:=0; Fein:=zwg;
              end;
            Txt:=j<3; Long:=Txt;
            PlotTickMarks;
            end;
          end
        else begin
          kk:=0; Fein:=10*zwg;
          Txt:=i<3; long:=true;
          PlotTickMarks;
          end;
        end;
      if pu=0 then PlotText ((lp1.X+lp2.X)/2,lp1.Y,AUnit,Align);
      (* Achsenlinie*)
      NewLineColor(LnColor);
      with ChartField do if VSW then PlotLine (xp,Bottom,xp,Top,LnWidth)
      else PlotLine (Left,xp,Right,xp,LnWidth);
      end;
    end;

  procedure LinAxis(xp : double; cm1,cm2,fm1,fm2 : double; ShowText,ShowGrid,Mirror : boolean);
  var
    i,n : integer;
    XX  : double;
  begin
    with AAxis,Properties do begin
      if Mirror and (TmStyle<>tmBoth) then begin  // Markierungen an der Achse spiegeln
        cm1:=-cm1; cm2:=-cm2; fm1:=-fm1; fm2:=-fm2;
        end;
      n:=0;
      for i:=0 to TickCount do begin
        XX:=AFein+i*ZWF;
        if (XX>=MinVal) and (XX<=MaxVal) then begin
          Y:=Scale(XX);
          NewLineColor(LnColor);
          if abs(rmod(xx,Zwg))<0.5*Zwf then begin
            if abs(XX)<0.1*ZwF then XX:=0;
          (* grobe Skalenmarken, Raster und Beschriftung *)
            if NOT VSW then begin (* horizontale Achse *)
              if ShowGrid and XInside(Y) then with ChartField do begin
              (* vert. Raster *)
                PlotLine (Y,Bottom,Y,Top,GrWidth,GrStyle);
                end;
              (* grobe Skalenmarken und Beschriftung *)
              if TmStyle<>tmNone then PlotLine (Y,xp+cm1,Y,xp+cm2,IvWidth);
              if ShowText then begin
                NewTextColor(LabFont.FontColor);
                if not ((asNoEdgeText in AxStyles) and (abs(XX)<ZwF)) then begin
                  if ShowLabels then begin
                    PlotText (Scale(XX+Zwg*LabPos/100)+XS,xp+YS,Labels[n],Align);
                    inc(n);
                    end
                  else PlotText (Y+XS,xp+YS,MakeLabel(XX,nd,Notation),Align);
                  end;
                if (XX+ZWG>MaxVal) and LBU then
                  PlotText (Scale(XX-ZWG/2)+XS,xp+YS,AUnit,Align);
                end;
              end
            else begin (* vertikale Achse *)
              if ShowGrid and YInside(Y) then with ChartField do begin
              (* hor. Raster *)
                PlotLine(Left,Y,Right,Y,GrWidth,GrStyle);
                end;
              (* grobe Skalenmarken und Beschriftung *)
              if TmStyle<>tmNone then PlotLine (xp+cm1,Y,xp+cm2,Y,IvWidth);
              if ShowText then begin
                NewTextColor(LabFont.FontColor);
                if not ((asNoEdgeText in AxStyles) and (abs(XX)<ZwF)) then begin
                  if ShowLabels then begin
                    PlotText (xp+XS,Scale(XX+Zwg*LabPos/100)+YS,Labels[n],Align);
                    inc(n);
                    end
                  else PlotText (xp+XS,Y+YS,MakeLabel(XX,nd,Notation),Align);
                  end;
                if (XX+ZWG>MaxVal) and LBU then
                  PlotText (xp+XS,Scale(XX-ZWG/2)+YS,AUnit,Align);
                end;
              end;
            end
          else if TmStyle<>tmNone then begin
          (* feine Skalenmarken *)
            if VSW then PlotLine (xp+fm1,Y,xp+fm2,Y,TmWidth)
            else PlotLine (Y,xp+fm1,Y,xp+fm2,TmWidth);
            end;
          end;
        end;
      (* Achsenlinie*)
      NewLineColor(LnColor);
      with ChartField do if VSW then PlotLine (xp,Bottom,xp,Top,LnWidth)
      else PlotLine (Left,xp,Right,xp,LnWidth);
      end
    end;

  function AppendUnit (const ca,au : string) : string;
  begin
    Result:=ca;
    if (length(au)>0) and not LBU then begin
      if au[1]=#32 then Result:=Result+au
      else Result:=Result+' / '+au;
      end;
    end;

begin
  with AAxis,Properties do begin
    ScText:=not (asNoText in AxStyles);
    ShowLn:=not (asHidden in AxStyles);
    Frame:=asBorder in AxStyles;
    LBU:=(asLabelUnit in AxStyles) and (length(AUnit)>0);
    Rot:=false;
    NewLineColor(LnColor);
    if ScText then begin  // Beschriftung
      TextFont:=LabFont;
      Rot:=(asRotate in AxStyles) and (AxType=atVert);
      if Rot then begin
//        if FInvRot then TextOrientation:=-90 else
        TextOrientation:=90;
        // Hinweise: inv. Textrotation ist erforderlich beim Kopieren
        // über die Zwischenablage
        end
      else TextOrientation:=0;
      end;
    VSW:=not (AxType=atHorz);
    RSW:=GrStyle<>lsNone;
    ATR:=AxPos=apTopRight;
    MSW:=asMirror in AxStyles;
    if TickCount=0 then TickCount:=5;
    if VSW then begin       // vertikale Achse
      AxisLength:=FChart.InnerArea.Height;  // in cm/inch
      if ATR then begin // rechts
        if Rot then begin
          if MSW then Align:=alCenterBottom else Align:=alCenterTop;
          end
        else begin
          if MSW then Align:=alRightCenter else Align:=alLeftCenter;
          end;
        if MSW then XS:=-LabDist else XS:=LabDist;
        end
      else begin   // links oder andere
        if Rot then begin
          if MSW then Align:=alCenterTop else Align:=alCenterBottom;
          end
        else begin
          if MSW then Align:=alLeftCenter else Align:=alRightCenter;
          end;
        if MSW then XS:=LabDist else XS:=-LabDist;
        end;
      YS:=0.0;
      end
    else begin   // horizontale Achse
      AxisLength:=FChart.InnerArea.Width;   // in cm/inch
      if ATR then begin // oberhalb
        if MSW then begin
          Align:=alCenterTop; YS:=-LabDist;
          end
        else begin
          Align:=alCenterBottom; YS:=LabDist;
          end;
        end
      else begin // unterhalb
        if MSW then begin
          Align:=alCenterBottom; YS:=LabDist;
          end
        else begin
          Align:=alCenterTop; YS:=-LabDist;
          end;
        end;
      XS:=0.0;
      end;
    with ChartField do begin
      if AxPos=apBottomLeft then begin
        if VSW then axp:=Left+AxOffset else axp:=Bottom+AxOffset;
        end
      else begin
        if VSW then axp:=Right+AxOffset else axp:=Top+AxOffset;
        end;
      if VSW then begin
        axbl:=Left; axtr:=Right;
        end
      else begin
        axbl:=Bottom; axtr:=Top;
        end;
      tmm:=false; //(axp<(axbl+axtr)/2);  // Seite für Skalenstriche
      end;
(* Stil der Skalenmarkierungen *)
    GetTickMarkPos (TmStyle,AxPos=apBottomLeft,CTmSize,c1,c2);
    GetTickMarkPos (TmStyle,AxPos=apBottomLeft,FTmSize,f1,f2);
    if ScaleType=stTime then begin // Zeitskala
      TimeGrid (MinVal,MaxVal);
      if ShowLn then TimeAxis(axp,c1,c2,f1,f2,ScText,RSW,tmm);
      if Frame then begin
        if AxPos<>apBottomLeft then TimeAxis(axbl,c1,c2,f1,f2,false,false,ATR);
        if AxPos<>apTopRight then TimeAxis(axtr,c2,c1,f2,f1,false,false,not ATR);
        end;
      end
    else if ScaleType=stLog then begin // log. Skalierung
     (* Länge der Skalenbeschriftung - nd = signifikante Stellen *)
//      if Precision=AutoPrec then nd:=0 else
      nd:=Precision;
      XX:=MaxVal/MinVal; NDek:=succ(trunc(lg(XX)-0.01));
      Decades:=round(AInt(lg(MinVal)+0.001));
      XX:=XX*15/AxisLength;
      if XX<=2.0 then md:=0
      else if XX<=5.0 then md:=1
      else if XX<=50.0 then md:=2
      else if XX<=200.0 then md:=3
      else if XX<=5E5 then md:=4
      else md:=5;
      if asLessTicks in AxStyles then inc(md);
      if ShowLn then LogAxis(md,axp,c1,c2,f1,f2,ScText,RSW,tmm);
      if Frame then begin
        if AxPos<>apBottomLeft then LogAxis(md,axbl,c1,c2,f1,f2,false,false,ATR);
        if AxPos<>apTopRight then LogAxis(md,axtr,c2,c1,f2,f1,false,false,not ATR);
        end;
      end
    else if ScaleType=stInv then begin   // inverse Skala
      XX:=abs((1/MinVal-1/MaxVal)*MaxVal);
      zwg:=Pwr(10.0,lg(abs(MinVal)));    // Anfangswert
      if XX<=10 then NDek:=1
      else if XX<=100 then NDek:=2
      else NDek:=3;
      nd:=Precision;
      if ShowLn then InvAxis(axp,c1,c2,f1,f2,ScText,RSW,tmm);
      if Frame then begin
        if AxPos<>apBottomLeft then InvAxis(axbl,c1,c2,f1,f2,false,false,ATR);
        if AxPos<>apTopRight then InvAxis(axtr,c2,c1,f2,f1,false,false,not ATR);
        end;
      end
    else begin // lin. Skalierung
  (* Lin. Skala - Skalierungsmarken berechnen *)
      ZWG:=GridWidth; ZWF:=ZWG/abs(GridTicks);
      XX:=AInt(MinVal/ZWF-0.01);
      Fein:=AInt(MaxVal/ZWF+0.1)-XX;
      AFEIN:=XX*ZWF;
      TickCount:=round(ABS(FEIN));
  (* Länge der Skalenbeschriftung - nd = signifikante Stellen *)
//      if Precision=AutoPrec then nd:=round(lg(abs(2*(MinVal+MaxVal)/ZWG))+1) else
      nd:=Precision;
      if ShowLn then LinAxis(axp,c1,c2,f1,f2,ScText,RSW,tmm);
      if Frame then begin
        if (AxPos<>apBottomLeft) or (AxOffset>FSpace) then LinAxis(axbl,c1,c2,f1,f2,false,false,ATR);
        if (AxPos<>apTopRight) or (-AxOffset>FSpace)  then LinAxis(axtr,c2,c1,f2,f1,false,false,not ATR);
        end;
      end;
    // Legende
    TextFont:=CapFont;
    if VSW then begin
//      if FInvRot then TextOrientation:=-90 else
      TextOrientation:=90;
      Align:=alCenterBottom;
      if AxPos=apTopRight then begin
        xs:=axp+CapDist; Align:=alCenterTop;
        end
      else xs:=axp-CapDist;
      xx:=GetTextWidth(Caption,true);
      with ChartField do xx:=0.01*CapPos*(Top-Bottom-xx)+Bottom+0.5*xx;
      PlotText (xs,xx,AppendUnit(Caption,AUnit),Align);
      end
    else begin
      TextOrientation:=0; Align:=alCenterTop;
      if AxPos=apTopRight then begin
        ys:=axp+CapDist; Align:=alCenterBottom;
        end
      else ys:=axp-CapDist;
      xx:=GetTextWidth(Caption,true);
      with ChartField do xx:=0.01*CapPos*(Right-Left-xx)+Left+0.5*xx;
      PlotText (xx,ys,AppendUnit(Caption,AUnit),Align);
      end;
    end;
  TextOrientation:=0;
  end;

{ ------------------------------------------------------------------- }
procedure TSheetPlot.InitExport(ARect : TRect);
begin
  with PlotCanvas do begin
    if FSheet.PlotUnit=puInch then SetMapMode (Handle,MM_LOENGLISH)
    else SetMapMode (Handle,MM_LOMETRIC);
    with ARect do begin
      SetWindowOrgEx (Handle,Left,Top,nil);
      SetWindowExtEx (Handle,Right-Left,Bottom-Top,nil);
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
//   Vorgabe des Feldes für das Koordinatensystem *)
procedure TSheetPlot.InitChartArea (AbsPos    : boolean;
                                    x,y,dx,dy : double);
(* AbsPos = true: absolut
          = false: rel. zum linken unteren Rand
    XL   =     linker Rand
    YU   =     unterer Rand
    XW   =     Breite
    YW   =     Höhe
    alle Werte in cm/inch *)
begin
  with ChartField do if AbsPos then begin
    Left:=x; Right:=Left+dx;
    Bottom:=y; Top:=Bottom+dy;
    end
  else begin
    Left:=PlotField.Left+x; Right:=Left+dx;
    Bottom:=PlotField.Bottom+y; Top:=Bottom+dy;
    end;
  SetClipWin(ChartField);
  end;

procedure TSheetPlot.InitChartArea (AbsPos : boolean; Area : TFloatArea);
begin
  with Area do InitChartArea(AbsPos,Left,Bottom,Width,Height);
  end;

procedure TSheetPlot.InitChart (AChart : TChart);
begin
  FChart:=AChart;
  if assigned(FChart) then InitChartArea(false,FChart.InnerArea);
  end;

procedure TSheetPlot.InitPlot;
begin
  InitLines; InitTextFont;
  InitBackground(FSheet.SheetColor);
  PlotArea(PlotField,FSheet.SheetColor);
//  FPlotCanvas.FillRect(FSheetField);
  FPenStat:=psMove;
  MovePen (0,0);
  end;

procedure TSheetPlot.ClearSheet;
begin
  InitBackground(FSheet.SheetColor);
  PlotArea(PlotField,FSheet.SheetColor);
//  FPlotCanvas.FillRect(FSheetField);
  end;

procedure TSheetPlot.PlotSheet (AScreen : boolean);
var
  ix,iy,
  i,j,k,k0,k1 : integer;
  xl,yl,xn,yn,
  x0,y0,sw,ym : double;
  ps          : TPenStat;
  s           : string;
  ok          : boolean;
  mmvalid     : boolean;
  pt,pmin,pmax: TFPoint;     // Min und Max
begin
  InitPlot;
//  ClearSheet;
//  with PlotField do PlotBorder(FloatRect(Left+0.1,Bottom+0.1,Right-0.1,Top-0.1),clRed);
  with FSheet do begin
   (* Feld und Skalierung für Daten definieren*)
    for i:=0 to ChartCount-1 do if assigned(Chart[i]) then with Chart[i] do if Visible and not Deleted then begin
      InitChart(Chart[i]);
      with Chart[i] do begin
        if ChartColor>=0 then PlotArea(ChartField,ChartColor);
        with Border do if Visible then PlotBorder(ChartField,LnWidth,LColor);
        end;
      for j:=0 to ItemCount-1 do with Item[j] do with Item[j] do begin
        case ItemType of
        itAxis  : (Item[j] as TAxisItem).InitScale(ChartField);
        itCurve : with Item[j] as TCurveItem do
                    if Properties.JoinMode=jmSpline then ComputeSplineFit;
        itFit   : (Item[j] as TFitItem).ComputeFit;
        itGraph : with Item[j] as TGraphItem do
                    if GraphType=gtHisto then ComputeHistogram;
        itFunction : (Item[j] as TFunctionItem).ComputeFunction;
          end;
        end;
      for j:=0 to ItemCount-1 do with Item[j] do if Visible and not Deleted then begin
        ResetMinMax(pmin,pmax); mmvalid:=false;
        Clip:=false;
        case ItemType of
        itAxis  : with Item[j] as TAxisItem do if Visible then begin
                  TextTransparency:=true;
                  PlotAxis(Item[j] as TAxisItem);
                  end;
        itCurve : with Item[j] as TCurveItem,Properties do if Visible then begin
                  Clip:=true;
                  ix:=IndexOf(XAxID); iy:=IndexOf(YAxID);
                  if (ix<0) or (iy<0) then Continue;  // no valid axis
                  if JoinMode<>jmNone then begin
                    LineWidth:=LWidth; LineColor:=LColor;
                    if JoinMode=jmLine then begin
                      with DataTable do if Count>0 then begin
                        with Data[0].Val do begin
                          xl:=Scale(ix,X); yl:=Scale(iy,Y);
                          end;
                        for k:=0 to Count-1 do with Data[k].Val do begin
                          xn:=Scale(ix,X); yn:=Scale(iy,Y);
                          PlotLine(xl,yl,xn,yn,LWidth,LStyle);
                          xl:=xn; yl:=yn;
                          end;
                        end;
                      end
                    else begin
                      with SplineData do if length(Data)>0 then begin
                        k0:=0; ok:=false;
                        repeat
                          with Data[k0] do if Valid then begin
                            xl:=Scale(ix,X); yl:=Scale(iy,Y); ok:=true;
                            end;
                          inc(k0);
                          until ok or (k0>High(Data));
                        for k:=k0 to High(Data) do with Data[k] do if Valid then begin
                          xn:=Scale(ix,X); yn:=Scale(iy,Y);
                          PlotLine(xl,yl,xn,yn,LWidth,LStyle);
                          xl:=xn; yl:=yn;
                          end;
                        end;
                      end;
                    end;
                // Fehlerbalken
                  Clip:=false;
                  if Errorbars<>[] then begin
                    LineWidth:=EWidth; LineColor:=EColor;
                    with DataTable do for k:=0 to Count-1 do with Data[k] do begin
                      if ebShowX in ErrorBars then begin
                        if dcErrSX in DataCols then
                          PlotErrorBar (ebHorz,Scale(iy,Val.Y),Scale(ix,Val.X+PErr.X),Scale(ix,Val.X-PErr.X),0.5*SymSize)
                        else if dcErrAX in DataCols then
                          PlotErrorBar (ebHorz,Scale(iy,Val.Y),Scale(ix,Val.X+PErr.X),Scale(ix,Val.X-MErr.X),0.5*SymSize);
                        end;
                      if ebShowY in ErrorBars then begin
                        if dcErrSY in DataCols then
                          PlotErrorBar (ebVert,Scale(ix,Val.X),Scale(iy,Val.Y+PErr.Y),Scale(iy,Val.Y-PErr.Y),0.5*SymSize)
                        else if dcErrAY in DataCols then
                          PlotErrorBar (ebVert,Scale(ix,Val.X),Scale(iy,Val.Y+PErr.Y),Scale(iy,Val.Y-MErr.Y),0.5*SymSize);
                        end;
                      end;
                    end;
                  // Punkte
                  with DataTable do for k:=0 to Count-1 do with Data[k].Val do begin
                    pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                    MinMax(pt,pmin,pmax); mmvalid:=true;
                    if SymType<>stNone then PlotMark(pt,SymType,SymSize,LWidth,MColor,ChartColor);
                    end;
                  if mmvalid then Outline:=MoveRect(FloatRect(pmin.X,pmin.Y,pmax.X,pmax.Y),MinusOrigin(PlotField));
                  // Positionen für Erkennung bei Mausbewegung berechnen
                  if (JoinMode=jmSpline) then begin
                    if length(SplineData.Data)>0 then with SplineData do begin
                      HitData.Available:=true; SetLength(HitData.Data,length(Data));
                      k0:=0; ok:=false;
                      repeat
                        with Data[k0] do if Valid then ok:=true else inc(k0);
                        until ok or (k0>High(Data));
                      k1:=0;
                      for k:=k0 to High(Data) do with Data[k] do if Valid then begin
                        pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                        HitData.Data[k1]:=MovePoint(pt,MinusOrigin(PlotField));
                        inc(k1);
                        end;
                      SetLength(HitData.Data,k1);
                      end
                    else HitData.Available:=false;
                    end
                  else with DataTable do if Count>0 then begin
                    HitData.Available:=true;
                    if length(Data)>HitPoints then begin
                      SetLength(HitData.Data,HitPoints);
                      k0:=0; xl:=Count/HitPoints;
                      for k:=0 to Count-1 do with DataTable.Data[k].Val do begin
                        pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                        HitData.Data[k1]:=MovePoint(pt,MinusOrigin(PlotField));
                        end;
                      end
                    else begin
                      SetLength(HitData.Data,Count);
                      for k:=0 to Count-1 do with DataTable.Data[k].Val do begin
                        pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                        HitData.Data[k]:=MovePoint(pt,MinusOrigin(PlotField));
                        end;
                      end;
                    end
                  else HitData.Available:=false;
                  end;
        itFit   : with Item[j] as TFitItem,Properties do if Visible and FitData.Computed then begin
                  Clip:=true;
                  ix:=IndexOf(CurveID);
                  if (ix<0) or (Item[ix].ItemType<>itCurve) then Continue;  // no valid curve
                  with Item[ix] as TCurveItem do begin
                    ix:=IndexOf(XAxID); iy:=IndexOf(YAxID);
                    end;
                  if (ix<0) or (iy<0) then Continue;  // no valid axis
                  LineColor:=LColor;
                  with FitData do if length(Data)>0 then begin
                    with Data[0] do if Valid then begin
                      xl:=Scale(ix,X); yl:=Scale(iy,Y);
                      MinMax(FloatPoint(xl,yl),pmin,pmax); mmvalid:=true;
                      end;
                    for k:=1 to High(Data) do with Data[k] do if Valid then begin
                      xn:=Scale(ix,X); yn:=Scale(iy,Y);
                      PlotLine(xl,yl,xn,yn,LWidth,LStyle);
                      xl:=xn; yl:=yn;
                      MinMax(FloatPoint(xl,yl),pmin,pmax); mmvalid:=true;
                      end;
                    end;
                  if mmvalid then Outline:=MoveRect(FloatRect(pmin.X,pmin.Y,pmax.X,pmax.Y),MinusOrigin(PlotField));
                  if length(FitData.Data)>0 then with FitData do begin
                    HitData.Available:=true; SetLength(HitData.Data,length(Data));
                    k1:=0;
                    for k:=0 to High(Data) do with Data[k] do if Valid then begin
                      pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                      HitData.Data[k1]:=MovePoint(pt,MinusOrigin(PlotField));
                      inc(k1);
                      end;
                    SetLength(HitData.Data,k1);
                    end
                  else HitData.Available:=false;
                  end;
        itGraph : with Item[j] as TGraphItem,Properties do if Visible then begin
                  ix:=IndexOf(XAxID); iy:=IndexOf(YAxID);
                  if (ix<0) or (iy<0) then Continue;  // no valid axis
                  if GraphType=gtBar then begin  // Balken
                    with DataTable do for k:=0 to Count-1 do with Data[k].Val do begin
                      pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                      MinMax(pt,pmin,pmax); mmvalid:=true;
                      if Transparent then
                        PlotBorder(pt.X-BWidth/2+BOffset,ChartField.Bottom+LWidth/2,pt.X+BWidth/2+BOffset,pt.Y,
                               LWidth,LColor)
                      else PlotRect(pt.X-BWidth/2+BOffset,ChartField.Bottom+LWidth/2,pt.X+BWidth/2+BOffset,pt.Y,
                               LWidth,LColor,BColor);
                      end;
                    if mmvalid then
                      Outline:=MoveRect(FloatRect(pmin.X-BWidth/2+BOffset,ChartField.Bottom,
                                   pmax.X+BWidth/2+BOffset,pmax.Y),MinusOrigin(PlotField));
                    with DataTable do if Count>0 then begin
                      HitData.Available:=true;
                      SetLength(HitData.Data,Count);
                      for k:=0 to Count-1 do with DataTable.Data[k].Val do begin
                        pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                        HitData.Data[k]:=MovePoint(pt,MinusOrigin(PlotField));
                        end;
                      end;
                    end
                  else if GraphType=gtHisto then begin  // Histogramm
                    y0:=Scale(iy,0); k0:=0;
                    with InnerArea do begin
                      if y0<=Bottom then y0:=Bottom;
                      x0:=Left; xl:=x0; yl:=y0;
                      sw:=Width/Stripes;
                      end;
                    if not Transparent then for k:=0 to Stripes-1 do begin     // Flächen
                      PlotArea(k*sw+x0,y0,(k+1)*sw+x0+LWidth/2,Scale(iy,HistData.Data[k]),BColor);
                      end;
                    LineColor:=LColor; ym:=y0;
                    with InnerArea do if y0>Bottom then PlotLine(Left,y0,Left+Width,y0,LWidth);  // Grundlinie
                    SetLength(HitData.Data,2*Stripes+2);
                    HitData.Data[k0]:=FloatPoint(xl,yl); inc(k0);
                    for k:=0 to Stripes-1 do begin     // Linien
                      yn:=Scale(iy,HistData.Data[k]);
                      PlotLine(xl,yl,xl,yn,LWidth);
                      HitData.Data[k0]:=FloatPoint(xl,yn); inc(k0);
                      xn:=(k+1)*sw+x0;
                      PlotLine(xl,yn,xn,yn,LWidth);
                      HitData.Data[k0]:=FloatPoint(xn,yn); inc(k0);
                      xl:=xn; yl:=yn;
                      if yn>ym then ym:=yn;
                      end;
                    PlotLine(xl,yl,xl,y0,LWidth);
                    HitData.Data[k0]:=FloatPoint(xl,y0);
                    HitData.Available:=true;
                    Outline:=MoveRect(FloatRect(x0,y0,xl,ym),MinusOrigin(PlotField));
                    end
                  else begin                // Torte
                    end;
                  end;
        itFunction : with Item[j] as TFunctionItem,Properties do if Visible and FuncData.Computed then begin
                  Clip:=true;
                  ix:=IndexOf(XAxID); iy:=IndexOf(YAxID);
                  if (ix<0) or (iy<0) then Continue;  // no valid axis
                  LineColor:=LColor; LineWidth:=LWidth;
                  with FuncData do if length(Data)>0 then begin
                    with Data[0] do if Valid then begin
                      xl:=Scale(ix,X); yl:=Scale(iy,Y);
                      MinMax(FloatPoint(xl,yl),pmin,pmax); mmvalid:=true;
                      end;
                    for k:=1 to High(Data) do with Data[k] do if Valid then begin
                      xn:=Scale(ix,X); yn:=Scale(iy,Y);
                      PlotLine(xl,yl,xn,yn,LWidth,LStyle);
                      xl:=xn; yl:=yn;
                      MinMax(FloatPoint(xl,yl),pmin,pmax); mmvalid:=true;
                      end;
                    end;
                  if mmvalid then Outline:=MoveRect(FloatRect(pmin.X,pmin.Y,pmax.X,pmax.Y),MinusOrigin(PlotField));
                  if length(FuncData.Data)>0 then with FuncData do begin
                    HitData.Available:=true; SetLength(HitData.Data,length(Data));
                    k1:=0;
                    for k:=0 to High(Data) do with Data[k] do if Valid then begin
                      pt:=FloatPoint(Scale(ix,X),Scale(iy,Y));
                      HitData.Data[k1]:=MovePoint(pt,MinusOrigin(PlotField));
                      inc(k1);
                      end;
                    SetLength(HitData.Data,k1);
                    end
                  else HitData.Available:=false;
                  end;
        itText  : with Item[j] as TTextItem do if Visible then begin
                  if TextType=ttText then begin
                    PlotTextLines(Position,Text,Properties);
                    with FLastOutline do if Valid then Outline:=Rect;
                    end
                  else if TextType=ttComment then begin
                    PlotComment(Position,Text,Properties);
                    with FLastOutline do if Valid then Outline:=Rect;
                    end
                  else if TextType=ttFitResult then begin
                    ix:=IndexOf(CurveID); s:='';
                    if (ix>=0) and (ix<ItemCount) and (Item[ix].ItemType=itFit) then
                        with (Item[ix] as TFitItem) do begin
                      if FitResult.Degree=0 then s:=TryFormat(_('No best-fit from %s available!'),[Description])
                      else s:=GetFitString(Options);
                      end;
                    if length(s)>0 then begin
                      PlotTextLines(Position,s,Properties);
                      with FLastOutline do if Valid then Outline:=Rect;
                      end;
                    end
                  else if TextType=ttLegend then begin
                    ix:=IndexOf(CurveID); s:='';
                    if (ix>=0) and (ix<ItemCount) then
                      PlotLegend(Position,Text,toSymbol in Options,
                                 ChartColor,Properties,Item[ix]);
                    with FLastOutline do if Valid then Outline:=Rect;
                    end;
                  end;
        itImage : with Item[j] as TImageItem do if Visible then begin
                  PlotImage(MoveArea(Area,PlusOrigin(PlotField)),Image);
                  if Border then PlotBorder(MoveArea(Area,PlusOrigin(PlotField)),LWidth,LColor);
                  end;
        itDrawing : with Item[j] as TDrawingItem do if Visible then begin
                  if DrawingType=dtLine then PlotDrawingLine(MovePoint(StartPoint,PlusOrigin(PlotField)),
                            MovePoint(EndPoint,PlusOrigin(PlotField)),Properties)
                  else PlotDrawingRect(MoveRect(Rectangle,PlusOrigin(PlotField)),Properties);
                  end;
          end;
        end;
      end;
    end;
  NoClipWin;
  end;


{ ------------------------------------------------------------------- }
// Sheet auf dem Bildschirm anzeigen
constructor TSheetToWindow.Create (ACanvas : TCanvas);
begin
  inherited Create (ACanvas);
  FShowRulers:=true;
  end;

(* Bildschirmkoordinaten umrechnen *)
function TSheetToWindow.ViewToWindow (Pt : TPoint) : TPoint;
begin
  DPToLP (FPlotCanvas.Handle,Pt,1);
  Result:=Pt;
  end;

procedure TSheetToWindow.ViewToUnit (Pt : TPoint; var X,Y : double);
begin
  InvScale(ViewToWindow(Pt),x,y);
  end;

function TSheetToWindow.ViewToUnit (Pt : TPoint) : TFPoint;
begin
  Result:=InvScale(ViewToWindow(Pt));
  end;

function TSheetToWindow.WindowToView (Pt : TPoint) : TPoint;
begin
  LPToDP (FPlotCanvas.Handle,Pt,1);
  Result:=Pt;
  end;

procedure TSheetToWindow.UnitToView (X,Y : double; var Pt : TPoint);
begin
  Scale (x,y,Pt.X,Pt.y);
  WindowToView(Pt);
  end;

function TSheetToWindow.UnitToView (UPos : TFPoint) : TPoint;
begin
  Result:=Scale(UPos);
  WindowToView(Result);
  end;

(* Abbildung der Zeichenfläche auf das Bildschirmfenster
   ASize      : Bildschirmfenstergröße (X x Y) in Pixeln
   ShowMargin : Rand anzeigen *)
procedure TSheetToWindow.InitView(ASize : TIntSize; ShowMargin : boolean);
begin
  FShMargin:=ShowMargin;
  FVpSize:=ASize;
  with FPlotCanvas do begin
    SetMapMode (Handle,MM_ISOTROPIC);
    if ShowMargin then with PrintField do begin
      SetWindowOrgEx (Handle,0,Height,nil);
      SetWindowExtEx (Handle,Width,-Height,nil);
      end
    else with FScreenField do begin
      SetWindowOrgEx (Handle,Left,Top,nil);
      SetWindowExtEx (Handle,Right-Left,Bottom-Top,nil);
      end;
    SetViewportOrgEx (Handle,0,0,nil);
    with ASize do SetViewportExtEx (Handle,Width,Height,nil);
    end;
  end;

(* Abbildung der Zeichenfläche auf das Bildschirmfenster
   ASize     : Bildschirmfenstergröße (X x Y) in Pixeln
   Origin    : linke obere Ecke (X,Y) des darzustellenden Fensters auf der
               Zeichenfläche
   Zoom      : Vergrößerungs-/ Verkleinerungsmaßstab *)
procedure TSheetToWindow.InitView (ASize   : TIntSize;
                               Origin  : TPoint;
                               Zoom    : double);
var
  x,y,dx,dy : integer;
begin
  with PlotCanvas do begin
    SetMapMode (Handle,MM_ISOTROPIC);
    with FScreenField do begin
      x:=Right-Left;
      dx:=round(x/Zoom);
      if dx<x then x:=x-dx else x:=0;
      x:=round(Origin.X/100*x);
      y:=Bottom-Top;
      dy:=round(y/Zoom);
      if dy>y then y:=y-dy else y:=0;
      y:=round(Origin.Y/100*y);
      SetWindowOrgEx (Handle,Left+x,Top+y,nil);
      SetWindowExtEx (Handle,dx,dy,nil);
      end;
    SetViewportOrgEx (handle,0,0,nil);
    with ASize do SetViewportExtEx (handle,Width,Height,nil);
    end;
  HitDelta:=abs(ViewToUnit(Point(5,0)).X-ViewToUnit(Point(0,0)).X);
  HitPoints:=round(FSheet.Size.Width/HitDelta);
  end;

{ ------------------------------------------------------------------- }
procedure TSheetToWindow.PlotRuler(Vert : boolean);
var
  i,tc,p : integer;
  Zwg,Zwf,xf,
  xg,xp,x1,x2,h : double;

  function GetRulerGrid (dx : double) : double;
  var
    d : double;
  begin
    d:=pwr(10.0,aint(lg(abs(dx))-0.05)); dx:=dx/d;
    if dx<=2.1 then Result:=0.2 else
    if dx<=5.1 then Result:=0.5 else Result:=1.0;
    Result:=Result*d;
    end;

  function GetRulerTicks (dx : double) : integer;
  begin
    dx:=dx/FRuler.TmLength;
    if dx<=4.4 then Result:=2 else
    if dx<=9.9 then Result:=5 else Result:=10;
    end;

begin
  with FSheet do begin
    TextFont:=FRuler.Font;
    LineWidth:=FRuler.LineWidth;
    h:=FRuler.TmLength;
    p:=FRuler.Precision;
    TextTransparency:=true;
    end;
  with PlotField do if Vert then begin
    xp:=Left;
    x1:=Bottom; x2:=Top;
    TextOrientation:=90;
    end
  else begin
    xp:=Bottom;
    x1:=Left; x2:=Right;
    TextOrientation:=0;
    end;
  zwg:=GetRulerGrid(x2-x1); zwf:=zwg/GetRulerTicks(zwg);
  tc:=round(AInt((x2-x1)/zwf+0.1));
  for i:=0 to tc do begin
    xg:=i*zwf; xf:=x1+xg;
    if (xf>=x1) and (xf<=x2) then begin
      if abs(rmod(xg,zwg))<0.5*zwf then begin  // grobe Marken
        if abs(xg)<0.1*zwf then xg:=0;
        if Vert then begin
          PlotLine (xp,xf,xp-h,xf);
          PlotText (xp-1.5*h,xf,FloatToFixStr(xg,p),alCenterBottom);
          end
        else begin
          PlotLine (xf,xp,xf,xp-h);
          PlotText (xf,xp-1.5*h,FloatToFixStr(xg,p),alCenterTop);
          end;
        end
      else begin                               // feine Marken
        if Vert then PlotLine (xp,xf,xp-0.5*h,xf)
        else PlotLine (xf,xp,xf,xp-0.5*h);
        end;
      end;
    end;
  if Vert then PlotLine (xp,x1,xp,x2) else PlotLine (x1,xp,x2,xp);
  end;

procedure TSheetToWindow.PlotOutline (ChartNdx,ItemNdx : integer);
var
  lw : double;
begin
  with FSheet do if (CharTndx>=0) and (ChartNdx<ChartCount) then with Chart[ChartNdx] do begin
    lw:=DefaultLineWidth;
    if (ItemNdx>=0) and (ItemNdx<ItemCount) then with Item[ItemNdx] do begin
      PlotBorder(MoveRect(Outline,PlusOrigin(PlotField)),lw,clRed,lsDashed,pmNotXor);
      end
    else
      PlotBorder(MoveRect(AreaToRect(InnerArea),PlusOrigin(PlotField)),lw,clRed,lsDashed,pmNotXor);
    end;
  end;

function TSheetToWindow.GetItemFromPos (APos : TFPoint; var AItemIndex : TChartItemIndex) : TItemAction;
var
  i,j : integer;
  ia  : TItemAction;
begin
  Result:=iaNone;
  APos:=MovePoint(APos,MinusOrigin(PlotField));
  with AItemIndex,FSheet do begin
    for i:=0 to ChartCount-1 do with Chart[i] do if Visible and not Deleted and IsInChart(APos) then Break;
    if i<ChartCount then begin
      ChartNr:=i;
      with Chart[i] do for j:=ItemCount-1 downto 0 do with Item[j] do if Visible and not Deleted then begin
        ia:=HitsItem(APos,HitDelta);
        if ia>Result then begin
//        if ((Result=iaNone) and (a1>iaNone)) or ((Result=iaFixed) and (a1>iaFixed)) then begin
          Result:=ia; ItemNr:=j;
          end;
        end;
      end
    else ChartNr:=-1;
    end;
  end;

function TSheetToWindow.IsItemAt (APos : TFPoint; AItemIndex : TChartItemIndex) : boolean;
begin
  Result:=false;
  APos:=MovePoint(APos,MinusOrigin(PlotField));
  with AItemIndex,FSheet do begin
    if (ChartNr<0) or (ChartNr>=ChartCount) then Exit;
    with Chart[ChartNr] do begin
      if (ItemNr<0) or (ItemNr>=ItemCount) then Exit;
      Result:=Item[ItemNr].IsInItem(APos);
      end;
    end;
  end;

function TSheetToWindow.GetNextItemAt (APos : TFPoint; var AItemIndex : TChartItemIndex) : boolean;
var
  i,j : integer;
begin
  APos:=MovePoint(APos,MinusOrigin(PlotField));
  with AItemIndex,FSheet do begin
{    if ChartNr>=ChartCount-1 then begin
      ChartNr:=-1; ItemNr:=-1;
      end;        }
    if (ChartNr>=0) and (ItemNr>=Chart[ChartNr].ItemCount-1) then ItemNr:=-1;
    if ItemNr<0 then begin
      inc(ChartNr);
      if ChartNr>=ChartCount-1 then ChartNr:=0;
      end;
    for i:=ChartNr to ChartCount-1 do with Chart[i] do if Visible then begin
      for j:=ItemNr+1 to ItemCount-1 do with Item[j] do if Visible and IsInItem(APos) then Break;
      if j<ItemCount then begin
        ChartNr:=i; ItemNr:=j; Break;
        end
      else ItemNr:=-1;
      end;
    Result:=i<ChartCount;
    if not Result then begin
      for i:=ChartNr to ChartCount-1 do with Chart[i] do if Visible and IsInChart(APos) then Break;
      Result:=i<ChartCount;
      if Result then ChartNr:=i else ChartNr:=-1;
      ItemNr:=-1;
      end;
    end;
  end;

procedure TSheetToWindow.MoveItem (Pos1,Pos2 : TFPoint; AItemIndex : TChartItemIndex; ItemAction : TItemAction);
var
  Offset : TFPoint;
begin
  Offset:=DiffPoint(Pos2,Pos1);
  with AItemIndex,FSheet do begin
    with FSheet.Chart[ChartNr].Item[ItemNr] do if IsMoveable then begin
      case ItemAction of
      iaMoveStart,iaMoveSS : MoveStart(Offset);
      iaMoveEnd,iaMoveEE   : MoveEnd(Offset);
      iaMoveSE    : MoveStartEnd(Offset);
      iaMoveES    : MoveEndStart(Offset);
      else MovePos(Offset);
        end;
      end;
    end;
  end;

function TSheetToWindow.GetFrame (AItemIndex : TChartItemIndex; var AFrame : TRect) : boolean;
begin
  Result:=false;
  with FSheet,AItemIndex do if (ChartNr>=0) and (ChartNr<ChartCount) then with Chart[ChartNr] do begin
    if (ItemNr>=0) and (ItemNr<ItemCount) then Result:=Item[ItemNr].IsMoveable;
    if Result then AFrame:=ScaleRect(MoveRect(Item[ItemNr].Outline,PlusOrigin(PlotField)));
    end;
  end;

function TSheetToWindow.GetLine (AItemIndex : TChartItemIndex; var AFrame : TRect) : boolean;
begin
  Result:=false;
  with FSheet,AItemIndex do if (ChartNr>=0) and (ChartNr<ChartCount) then with Chart[ChartNr] do begin
    if (ItemNr>=0) and (ItemNr<ItemCount) then Result:=Item[ItemNr].Itemtype=itDrawing;
    if Result then with (Item[ItemNr] as TDrawingItem) do begin
      Result:=DrawingType=dtLine;
      if Result then AFrame:=ScaleRect(MoveRect(FloatRect(StartPoint,EndPoint),PlusOrigin(PlotField)));
      end;
    end;
  end;

function TSheetToWindow.GetRect (AItemIndex : TChartItemIndex; var AFrame : TRect) : boolean;
begin
  Result:=false;
  with FSheet,AItemIndex do if (ChartNr>=0) and (ChartNr<ChartCount) then with Chart[ChartNr] do begin
    if (ItemNr>=0) and (ItemNr<ItemCount) then Result:=Item[ItemNr].Itemtype=itDrawing;
    if Result then with (Item[ItemNr] as TDrawingItem) do begin
      Result:=DrawingType=dtRect;
      if Result then AFrame:=ScaleRect(MoveRect(FloatRect(StartPoint,EndPoint),PlusOrigin(PlotField)));
      end;
    end;
  end;

procedure TSheetToWindow.InitPlot;
begin
  InitLines; InitTextFont;
  if FShowRulers then begin
    InitBackground(clBtnFace);
    FPlotCanvas.FillRect(FScreenField);
    end;
  InitBackground(FSheet.SheetColor);
  FPlotCanvas.FillRect(FSheetField);
  if FShowRulers then begin
    PlotRuler(true); PlotRuler(false);
    end;
  FPenStat:=psMove;
  MovePen (0,0);
  end;

{ ------------------------------------------------------------------- }
// Sheet ausdrucken oder exportieren
procedure TSheetToPrinter.InitPrint(ShowMargin : boolean);
begin
  with PlotCanvas do begin
    if FSheet.PlotUnit=puInch then SetMapMode (Handle,MM_LOENGLISH)
    else SetMapMode (Handle,MM_LOMETRIC);
    if ShowMargin then with PrintField do begin
      SetWindowOrgEx (Handle,0,Height,nil);
      SetWindowExtEx (Handle,Width,-Height,nil);
      end
    else with FSheetField do begin
      SetWindowOrgEx (Handle,Left,Top,nil);
      SetWindowExtEx (Handle,Right-Left,Bottom-Top,nil);
      end;
    end;
//  FPrintOut:=true;
  end;

{-----------------------------------------------------------------------}
(* neuen Font (Größe, Stil, Richtung) erzeugen *)
procedure TSheetToClipboard.CreateNewFont (var NewFont,OldFont : HFont);
var
  FontName : PChar;
  CSize,
  Angle,
  Weight   : integer;
  Italic   : byte;
begin
  FontName:=StrAlloc (LF_FACESIZE);
  with PlotCanvas.Font do begin
    StrPCopy(FontName,Name);
    CSize:=Height;
    if fsBold in Style then Weight:=FW_DEMIBOLD else Weight:=FW_NORMAL;
    if fsItalic in Style then Italic:=1 else Italic:=0;
    Angle:=-Orientation;
    end;
  NewFont:=CreateFont (CSize,0,Angle,Angle,
                       Weight,Italic,0,0,
                       DEFAULT_CHARSET,
                       OUT_DEFAULT_PRECIS,
                       CLIP_LH_ANGLES	,
                       ANTIALIASED_QUALITY,
                       DEFAULT_PITCH or FF_DONTCARE,
                       FontName);
  OldFont:=SelectObject(PlotCanvas.Handle,NewFont);
  StrDispose(FontName);
  end;

(* neuen Font entfernen *)
procedure TSheetToClipboard.DeleteNewFont (var NewFont,OldFont : HFont);
begin
  SelectObject(PlotCanvas.Handle,OldFont);
  DeleteObject (NewFont);
  end;

procedure TSheetToClipboard.OutputText (Pos,Offs : TPoint; const AText : string);
var
  OldFont,NewFont : HFont;  (* Handle auf Font *)
begin
  with PlotCanvas do begin
    if Font.Orientation=0 then TextOut (Pos.X+Offs.x,Pos.Y+Offs.y,AText)
    else begin
      CreateNewFont (NewFont,OldFont);
      TextOut (Pos.X+Offs.x,Pos.Y+Offs.y,AText);
      DeleteNewFont (NewFont,OldFont);
      end;
    end;
  end;


end.
