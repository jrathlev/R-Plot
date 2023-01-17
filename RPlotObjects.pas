(* Common objects for RPlot
   ========================

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

unit RPlotObjects;

interface

uses System.Classes, System.SysUtils, Winapi.Windows, System.Contnrs, System.IniFiles,
  Vcl.Graphics, Vcl.Buttons, Types, Xml.XMLIntf, Xml.XMLDoc, RWinFit, Vcl.Forms,
  Vcl.Controls, Vcl.ExtCtrls, System.Zip, WinUtils, StringUtils, MathExp;

const
  DecSep = Period;

  XrpExt   = 'xrp';  // Sheet mit Daten - gepackt als Zip
  XrdExt   = 'rpd';  // Chartvorlage (ohne Daten)
  XraExt   = 'rpa';  // Achsenvorlage
  XrcExt   = 'rpc';  // Kurvenvorlage (ohne Daten)
  XriExt   = 'rpi';  // Vorlage für Fits
  XrgExt   = 'rpg';  // Graphenvorlage (ohne Daten)
  XrfExt   = 'rpf';  // Funktionenvorlage
//  XmlExt   = 'xml';
  PshExt   = 'rsh';  // Vorgaben für Sheet (Ini-Format)
  IniExt   = 'ini';
  TxtExt   = 'txt';
  CsvExt   = 'csv';
  EmfExt   = 'emf';
  JpgExt   = 'jpg';
  BmpExt   = 'bmp';
  EpsExt   = 'eps';

  RpDataName = 'RPlotData.xml';

  // Parameter für Ini-Datei und XML-Daten
  GlobalSekt  = 'Global';
  MetricSekt  = 'MetricPreferences';
  InchSekt    = 'InchPreferences';
  HistSekt    = 'History';
  ImpSekt     = 'Import';
  ViewSekt    = 'View';
  SheetSekt   = 'Sheet';
  ChartSekt   = 'Chart';
  ItemSekt    = 'Item';
  AxisSekt    = 'Axis';
  CurveSekt   = 'Curve';
  FitSekt     = 'Fit';
  GraphSekt   = 'Graph';
  FuncSekt    = 'Function';
  TextSekt    = 'Text';
  ImgSekt     = 'Image';

  iniProgram  = 'Program';
  iniVersion  = 'Version';
  iniUColors  = 'CustomColors';
  iniSheet    = 'Sheet';
  iniFormat   = 'PageFormat';
  iniLeft     = 'Left';
  iniRight    = 'Right';
  iniTop      = 'Top';
  iniBottom   = 'Bottom';
  iniWidth    = 'Width';
  iniHeight   = 'Height';
  iniLast     = 'LastSheet';
  iniEps      = 'EpsDirectory';
  iniPrinter  = 'Printer';
  iniZoom     = 'Zoom';
  iniSHorz    = 'HorzPos';
  iniSVert    = 'VertPos';
  iniDir      = 'Directory';
  iniExtn     = 'Extension';
  iniDecSep   = 'DecSeparator';
  iniColSep   = 'ColSeparator';
  iniQuote    = 'QuoteCharacter';
  iniTpl      = 'Template';
  iniBakCol   = 'Background';
  iniChartCol = 'ChartColor';
  iniLnWidth  = 'LineWidth';
  iniLnStyle  = 'LineStyle';
  iniLnCol    = 'LineColor';
  iniFillCol  = 'FillColor';
  iniBold     = 'Bold';
  iniItalic   = 'Italic';
  iniSymSize  = 'SymbolSize';
  iniChSpace  = 'ChartSpace';
  iniXChSpace  = 'XChartSpace';
  iniYChSpace  = 'YChartSpace';
  iniAxSpace  = 'AxisSpace';
  iniAxLnWdt  = 'AxisLine';
  iniAxTickMk = 'AxisTickMark';
  iniXAxSpace  = 'XAxisSpace';
  iniYAxSpace  = 'YAxisSpace';
  iniAxFrame  = 'AxisFrame';
  iniCapSize  = 'CaptionSize';
  iniCapDist  = 'CaptionDistance';
  iniLabSize  = 'LabelSize';
  iniLabDist  = 'LabelDist';
  iniSymStyle = 'SymbolStyle';
  iniSymCol   = 'SymbolColor';
  iniOffs     = 'Offset';
  iniUnit     = 'Unit';    // TPlotUnit

  iniFontName = 'FontName';
  iniFontType = 'FontType';
  iniFontSize = 'FontSize';
  iniFontStyle = 'FontStyle';
  iniFontColor = 'FontColor';

  defRPlotPath = 'RPlot';
  defTemplPath = 'Templates';
  defImgPath   = 'Images';

  UserColors : string = '';

var
  TemplPath,           // path with RPLot templates
  ImagePath,           // path with RPLot images
  SheetPath    : string;  // path with RPlot sheets

{ ------------------------------------------------------------------- }
type
  TItemAction = (iaNone,iaFixed,iaMoveRect,iaMoveBox,iaMoveLine,
                 iaMoveSS,iaMoveSE,iaMoveES,iaMoveEE,iaMoveStart,iaMoveEnd);

  TFloatSize = record
    Width,Height : double;
    end;

  TIntSize = record
    Width,Height : integer;
    end;

  TIntArea = record
    Left,Bottom,Width,Height : integer;
    end;

  TFloatArea = record
  public
    procedure Offset(const DX, DY : double); overload;
    procedure Offset(const Point: TFPoint); overload;
    function AsFRect : TFRect;
    case integer of
    0: (Left,Bottom,Width,Height : double);
    1: (BottomLeft, Size: TFPoint);
    end;

  TOffset = record
    BottomLeft,TopRight : double;
    end;

  TPapFormat = record
    Name : string;
    MSize,ISize : TFloatSize;
    end;

  TPageFormat = (pfUser,pfA3,pfA4,pfA5,pfA6,pfLetter,pfLegal);

const
  defSize = pfA4;  // A4
  PaperSizes : array[TPageFormat] of TPapFormat =
          ((Name : 'User';   MSize : (Width : 10.0; Height : 10.0);
                             ISize : (Width : 4.0; Height : 4.0)),
           (Name : 'ISO A3'; MSize : (Width : 29.7; Height : 42.0);
                             ISize : (Width : 11.69; Height : 16.54)),
           (Name : 'ISO A4'; MSize : (Width : 21.0; Height : 29.7);
                             ISize : (Width : 8.27; Height : 11.69)),
           (Name : 'ISO A5'; MSize : (Width : 14.8; Height : 21.0);
                             ISize : (Width : 5.83; Height : 8.27)),
           (Name : 'ISO A6'; MSize : (Width : 10.5; Height : 14.8);
                             ISize : (Width : 4.13; Height : 5.83)),
           (Name : 'Letter'; MSize : (Width : 21.6; Height : 27.9);
                             ISize : (Width : 8.50; Height : 11.00)),
           (Name : 'Legal';  MSize : (Width : 21.6; Height : 35.6);
                             ISize : (Width : 8.50; Height : 14.00)));

  MaxConst = 6;
  defConstName : array [0..MaxConst-1] of TConstString = ('a','b','c','d','u','v');

type
  TPlotUnit = (puMetric,puInch);
  TLineStyle = (lsNone,lsSolid,lsDashed,lsDotted);
  TSymbolType = (stDot,stDiamond,stTriangle,stSquare,stDelta,
                 stCircle,stODiamond,stOTriangle,stOSquare,stODelta,
                 stPlus,stCross,stNone);

  TFontType = (ftRoman,ftSwiss,ftFixed);

  TPlotFont = record
    FontName   : string;
    FontSize   : double;              // Fontgröße in cm/inch
    FontAngle  : integer;             // Drehwinkel in °
    FontStyle  : TFontStyles;         // Stil
    FontColor  : TColor;
    FontType   : TFontType;
    end;

  TSheetProperties = record
    FPageFormat    : TPageFormat;
    FSize          : TFloatSize;      // Größe des Sheets in cm/ich
    FMargin        : TFRect;          // Ränder in cm/inch
    FBakColor,
    FChartColor    : TColor;
    FDecSep        : char;
    FPlotFont      : TPlotFont;
    FLineWidth,
    FSymSize,
    FChartSpace,
    FAxisSpace,
    FAxLnWidth,
    FTickLength,
    FLabSize,
    FLabDist,
    FCapSize,
    FCapDist       : double;
    FLineStyle     : TLineStyle;
    FLineColor,
    FSymColor,
    FFillColor     : TColor;
    FSymType       : TSymbolType;
    FAxisFrame     : boolean;
    end;

  TRuler =record
    Font                     : TPlotFont;
    Space,LineWidth,TmLength : double;
    Precision                : integer; // 100*Digits+Precision
    end;

  TTickMarks = (tmInner,tmOuter,tmBoth,tmNone);
  TAxPos = (apBottomLeft,apTopRight,apZero,apAll);
  TScaleType = (stLin,stLog,stInv,stTime);   //  Skalierungstypen (lin/log/invers/Zeit)
  TAxisType  = (atHorz,atVert);        // Achsentypen (hor/vert)

  (* Achsenstile
   asNoText      = ohne Beschriftung
   asMirror      = Beschriftung an Achse spiegeln
   asNoEdgeText  = kein Beschriftung auf Randposition
   asDate        = Zeitachse mit Datum
   asWeekday     = Zeitachse mit Wochentag
   asRotate      = Text in Achsenrichtung drehen
   asFrame       = Achsen auf beiden Rändern
   asHidden      = keine Achse, nur Legende
   *)
  TAxisStyle = (asNoText,asMirror,asNoEdgeText,asDate,asWeekday,asRotate,asBorder,
                asHidden,asLessTicks,asLabelUnit);
  TAxisStyles = set of TAxisStyle;
  TNotation = (noFixed,noSci,noEng,noPrefix);

  // alle Größenangaben in der vorgegeben Einheit (cm oder inch)
  TAxisProperties = record       // Eigenschaften einer Achse
    CapFont,                     // Legende: Schriftart, Farbe, Größe, Stil
    LabFont       : TPlotFont;   // Beschriftung: Schriftart, Farbe, Größe, Stil
    CapDist       : double;      // Legende: Abstand von der Achse
    CapPos,                      // Legende: Pos. in %
    LabPos        : integer;     // Label zwischen Skalenstr. in %
    ShowLabels    : boolean;     // benutzerdefinierte Labels anzeigen
    Precision     : integer;     // Anzahl signif. Stellen bei der Beschriftung
    Notation      : TNotation;   // Schreibweise der Zahlen
    DateFormat    : string;      // Datumsformat
    LnColor       : TColor;      // Linienfarbe
    LabDist,                     // Abstand der Beschriftung von der Achse
    LnWidth,                     // Dicke der Achsen-Linien
    GrWidth,                     // Dicke der Rasterlinien
    IvWidth,                     // Dicke der groben Skalisierungsstriche
    TmWidth,                     // Dicke der feinen Skalierungsstriche
    CTmSize,                     // Länge der Grobskalierungsstriche
    FTmSize       : double;      // Länge der Feinskalierungsstriche
    TmStyle       : TTickMarks;  // Art der Skalierungsstriche
    GrStyle       : TLineStyle;  // Stil der Rasterlinien
    AxStyles      : TAxisStyles; // Achsenstil, s.o.
    end;

  TJoinMode = (jmNone,jmLine,jmSpline);

  TErrorBar = (ebShowX,ebShowY);
  TErrorBars = set of TErrorBar;

  TCurveProperties = record         // Eigenschaften einer Kurve
    JoinMode         : TJoinMode;   // Punkte-Verbindungen
    ErrorBars        : TErrorBars;  // Fehlerbalkenanzeige (x und/oder y)
    SmoothFactor     : integer;     // Grad der Pol.-Approximation         *
    SymType          : TSymbolType; // Form der Markierungen
    SymSize          : double;      // Größe der Punktmarkierungen
    LStyle           : TLineStyle;  // Linienstil
    LWidth,                         // Linienbreite - Linien
    EWidth           : double;      // Linienbreite - Fehlerbalken
    LColor,                         // Farbe - Linien
    MColor,                         // Farbe - Markierungen
    EColor           : TColor;      // Farbe - Fehlerbalken
    end;

  TFitProperties = record           // Eigenschaften einer Approximation
    FitOrder         : integer;     // Grad der Pol.-Approximation
    FitMin,FitMax    : double;      // X-Bereich für Fit-Funktion
    FitAll,ViewAll   : boolean;     // Fit über ges. X-Bereich oder Teil
    XScale,YScale    : TScaleType;  // Skalierung (lin, log, reziprok oder ?)
    LStyle           : TLineStyle;  // Linienstil
    LWidth           : double;      // Linienbreite - Linien
    LColor           : TColor;      // Farbe - Linie
    end;

  TGraphProperties = record         // Eigenschaften von Diagrammen
    Transparent      : boolean;     // transparente Balken
    LWidth           : double;      // Linienbreite - Linien
    LColor,                         // Farbe - Linien
    BColor           : TColor;      // Farbe - Balken
    case integer of
    1 : (BWidth,                    // Balkenbreite
         BOffset     : double);     // Balkenoffset
    2 : (Stripes     : integer);    // Anzahl Streifen für Histogramm
    end;

  TAngularUnit = (auRadiant,auDegree,auGradian);

  TFunctionProperties = record      // Egenschaften einer Funktion
    FuncAll          : boolean;     // Funktion über ges. X-Bereich oder Teil
    Min,Max          : double;      // X-Bereich für Funktion
    LStyle           : TLineStyle;  // Linienstil
    LWidth           : double;      // Linienbreite - Linien
    LColor           : TColor;      // Farbe - Linien
    AngularUnit      : TAngularUnit;// Winkeleinheiten der Formel
    Formula          : string;      // Formel
    Constants        : TConstArr;   // Konstanten
    end;

  // Textausrichtungen in PlotText
  TTextAlign = (alLeftBottom,alLeftCenter,alLeftTop,alCenterBottom,alCenterAll,
                alCenterTop,alRightBottom,alRightCenter,alRightTop);

  TTextProperties = record          // Eigenschaften von Textobjekten
    Font             : TPlotFont;   // FName, Größe, Stil, Winkel und Farbe
    Align            : TTextAlign;  // Ausrichtung
    Transparent,                    // transparenter Hintergrund
    Border           : boolean;     // mit Umrahmung
    LWidth           : double;      // Linienbreite - Rahmen
    LColor           : TColor;      // Farbe - Linien
    BgColor          : TColor;      // Farbe - Hintergrund
    end;

  // Linien mit Pfeilspitzen
  TArrowStyle = (asNone,asBegin,asEnd,asBoth);

  TDrawingProperties = record       // Eigenschaften von Grafikobjekten
    HdWidth,HdLength,               // Breite und Länge der Spitze
    LWidth           : double;      // Linienbreite
    ArrowStyle       : TArrowStyle; // Pfeilspitzen
    Style            : TLineStyle;  // Linienstil
    Transparent,                    // transparenter Hintergrund
    Border           : boolean;     // mit Umrahmung
    LColor,                         // Farbe - Linien / Umrandung
    BgColor          : TColor;      // Farbe - Hintergrund
    end;

  TDefaultObjectProperties = record  // Default properties of sheet
    AxisProps     : TAxisProperties;
    CurveProps    : TCurveProperties;
    FitProps      : TFitProperties;
    FunctionProps : TFunctionProperties;
    DrawingProps  : TDrawingProperties;
    PlotFont      : TPlotFont;
    FillColor     : TColor;
    end;

  TRange = record
    Min,Max : double;
    Dec     : integer;
    end;

const
  RpIdent  = 'RPlot-Data';
  RpChTpId = 'RPlot-Chart-Template';     // chart template id
  RpAxTpId = 'RPlot-Axis-Template';      // axis template id
  RpCuTpId = 'RPlot-Curve-Template';     // curve template id
  RpFiTpId = 'RPlot-Fit-Template';       // fit template id
  RpGrTpId = 'RPlot-Graph-Template';     // Graph template id
  RpFuTpId = 'RPlot-Function-Template';  // function template id

  ValDelim = #32;            // delimiter between values

  Units : array[TPlotUnit] of string = ('cm','inch');

  OneInch = 2.54;

  FuncPoints = 199;
  defPrec = 3;

  MetricLineWidth = 0.05;        // Linienbreite in cm
  InchLineWidth = 0.02;          // Linienbreite in inch
  defSym       = stDot;
  MetricSymSize   = 0.3;
  InchSymSize   = 0.12;
  MetricAxisLine = 0.025;        // Linienbreite der Achsen in cm
  InchAxisLine = 0.01;           // Linienbreite der Achsen in inch
  MetricTickLength = 0.2;        // Länge der Skalierungsmarke
  InchTickLength = 0.08;
  MetricChartSpace = 0.25;       // Mindestabstand Chart - Rand
  InchChartSpace = 0.1;
  MetricAxisSpace = 0.8;         // Bereich für Achsenbeschriftung
  InchAxisSpace = 0.32;
  MetricTextSize = 0.4;
  InchTextSize = 0.16;
  MetricCapSize = 0.35;
  InchCapSize = 0.14;
  MetricLabSize = 0.25;
  InchLabSize = 0.1;
  MetricLabDist = 0.2;           // Abstand Achse - Beschriftung
  InchLabDist = 0.08;
  MetricCapDist = 0.5;           // Abstand Achse - Legende
  InchCapDist = 0.2;

  defBColor = clWhite;        // Hintergrund
  defLColor = clBlack;        // Linien
  defPColor = clBlue;         // Marken
  defEColor = clRed;          // Fehlerbalken
  defFColor = clGreen;        // Fitkurve
  defCColor = clPurple;       // Vergleichskurve

  // Beschriftung der Achsen
  AutoPrec = 0;       // automatische Bestimmung der signif. Stellen bei
                      // Precision = 0 -> automatisch
                      //           = 1 -> integer
                      //           > 1 -> Anzahl der sign. Stellen

// Plotfont
  defFontName = 'Arial';
  defSymbolName = 'Symbol';

// Standardränder für Quer- und Hochformat in cm/inch
  MetricPoMargin : TFRect = (Left : 1.5; Top : 1.0; Right : 1.0; Bottom : 1.0);
  MetricLsMargin : TFRect = (Left : 1.0; Top : 1.5; Right : 1.0; Bottom : 1.0);
  InchPoMargin : TFRect = (Left : 0.6; Top : 0.4; Right : 0.4; Bottom : 0.4);
  InchLsMargin : TFRect = (Left : 0.4; Top : 0.6; Right : 0.4; Bottom : 0.4);
  NoMargin  : TFRect = (Left : 0.0; Top : 0.0; Right : 0.0; Bottom : 0.0);

  // Vorgaben für sheet
  MetricSheetProps : TSheetProperties = (
    FPageFormat    : pfUser;
    FSize          : (Width : 10; Height: 10);     // Größe des Sheets in cm
    FMargin        : (Left : 0.0; Top : 0.0; Right : 0.0; Bottom : 0.0);
    FBakColor      : defBColor;
    FChartColor    : -1;        // transparent
    FDecSep        : ',';
    FPlotFont      : (FontName : 'Arial'; FontSize : MetricTextSize; FontAngle : 0;
                      FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
    FLineWidth     : MetricLineWidth;
    FSymSize       : MetricSymSize;
    FChartSpace    : MetricChartSpace;
    FAxisSpace     : MetricAxisSpace;
    FAxLnWidth     : MetricAxisLine;
    FTickLength    : MetricTickLength;
    FLabSize       : MetricLabSize;
    FLabDist       : MetricLabDist;
    FCapSize       : MetricCapSize;
    FCapDist       : MetricCapDist;
    FLineStyle     : lsSolid;
    FLineColor     : defLColor;
    FSymColor      : defLColor;
    FFillColor     : defBColor;
    FSymType       : defSym;
    FAxisFrame     : true);

  InchSheetProps : TSheetProperties = (
    FPageFormat    : pfUser;
    FSize          : (Width : 4; Height : 4);     // Größe des Sheets in inch
    FMargin        : (Left : 0.0; Top : 0.0; Right : 0.0; Bottom : 0.0);
    FBakColor      : defBColor;
    FChartColor    : -1;        // transparent
    FDecSep        : '.';
    FPlotFont      : (FontName : 'Arial'; FontSize : InchTextSize; FontAngle : 0;
                      FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
    FLineWidth     : InchLineWidth;
    FSymSize       : InchSymSize;
    FChartSpace    : InchChartSpace;
    FAxisSpace     : InchAxisSpace;
    FAxLnWidth     : InchAxisLine;
    FTickLength    : InchTickLength;
    FLabSize       : InchLabSize;
    FLabDist       : InchLabDist;
    FCapSize       : InchCapSize;
    FCapDist       : InchCapDist;
    FLineStyle     : lsSolid;
    FLineColor     : defLColor;
    FSymColor      : defLColor;
    FFillColor     : defBColor;
    FSymType       : defSym;
    FAxisFrame     : true);

  // Vorgaben für Lineale
  MetricRuler : TRuler
     = (Font       : (FontName : 'Arial'; FontSize : 0.2; FontAngle : 0;
                      FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
        Space      : 0.6;   // Randbreite
        LineWidth  : 0.025;  // Linienstärke
        TmLength   : 0.2;   // Länge der Grobskalierungsstriche
        Precision  : 103);  // 3 Stellen mit 1 Stelle hinter dem Komma
  InchRuler : TRuler
     = (Font       : (FontName : 'Arial'; FontSize : 0.08; FontAngle : 0;
                      FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
        Space      : 0.25;  // Randbreite
        LineWidth  : 0.01; // Linienstärke
        TmLength   : 0.08;  // Länge der Grobskalierungsstriche
        Precision  : 103);  // 3 Stellen mit 1 Stelle hinter dem Komma

  // Vorgaben für Dialogfelder
  MetricRanges : array[0..5] of TRange = (
    (Min : 0.01; Max : 0.5; Dec : 3),      // line widths
    (Min : 0.02; Max : 1.0; Dec : 2),      // tick length
    (Min : -100.0; Max : 100.0; Dec : 2),  // distances
    (Min : 0.1; Max : 2.0; Dec : 2),       // symbol sizes
    (Min : -100.0; Max : 100.0; Dec: 2),   // positions
    (Min : 2.5; Max : 100.0; Dec: 2));     // chart sizes
  InchRanges : array[0..5] of TRange = (
    (Min : 0.004; Max : 0.2; Dec : 3),     // line widths
    (Min : 0.008; Max : 0.4; Dec : 3),     // tick length
    (Min : -40.0; Max : 40.0; Dec : 2),    // distances
    (Min : 0.08; Max : 0.8; Dec : 2),      // symbol sizes
    (Min : -40.0; Max : 40.0; Dec: 2),     // positions
    (Min : 1.0; Max : 400.0; Dec: 2));     // chart sizes

  //Standarddefinitionen für Achsen
  MetricAxis : TAxisProperties  // in cm
             = (CapFont    : (FontName : 'Arial'; FontSize : 0.35; FontAngle : 0;
                              FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
                LabFont    : (FontName : 'Arial'; FontSize : 0.25; FontAngle : 0;
                       			  FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
                CapDist    : MetricCapDist;  // Legende: Abstand von der Achse
                CapPos     : 50;       // Legende.in %
                LabPos     : 0;        // Label zwischen Skalenstr. in %
                ShowLabels : false;    // benutzerdefinierte Labels anzeigen
                Precision  : AutoPrec; // autom. Auswahl der sign. Stellen der
                Notation   : noFixed;   // Schreibweise der Zahlen
                DateFormat : 'yyyy-mm-dd'; // Datumsformat
                LnColor    : clBlack;   // Linienfarbe
                LabDist    : MetricLabDist;  // Abstand der Beschriftung von der Achse
                LnWidth    : 0.025;     // Dicke der Achsen-Linien
                GrWidth    : 0.025;     // Dicke der Rasterlinien
                IvWidth    : 0.025;     // Dicke der groben Skalisierungsstriche
                TmWidth    : 0.025;     // Dicke der feinen Skalierungsstriche
                CTmSize    : 0.2;      // Länge der Grobskalierungsstriche
                FTmSize    : 0.1;      // Länge der Feinskalierungsstriche
                TmStyle    : tmInner;  // Skalierungsstrich nur innen
                GrStyle    : lsNone;   // kein Raster
                AxStyles   : []);

  InchAxis : TAxisProperties  // in inch
             = (CapFont    : (FontName : 'Arial'; FontSize : 0.14; FontAngle : 0;
                       			  FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
                LabFont    : (FontName : 'Arial'; FontSize : 0.1; FontAngle : 0;
                      			  FontStyle : []; FontColor : clBlack; FontType : ftSwiss);
                CapDist    : InchCapDist;      // Legende: Abstand von der Achse
                CapPos     : 50;       // Legende.in %
                LabPos     : 0;        // Label zwischen Skalenstr. in %
                ShowLabels : false;    // benutzerdefinierte Labels anzeigen
                Precision  : AutoPrec; // autom. Auswahl der sign. Stellen der
                Notation   : noFixed;  // Schreibweise der Zahlen
                DateFormat : 'yyyy-mm-dd'; // Datumsformat
                LnColor    : clBlack;  // Linienfarbe
                LabDist    : InchLabDist;   // Abstand der Beschriftung von der Achse
                LnWidth    : 0.01;    // Dicke der Achsen-Linien
                GrWidth    : 0.01;    // Dicke der Rasterlinien
                IvWidth    : 0.01;    // Dicke der groben Skalisierungsstriche
                TmWidth    : 0.01;    // Dicke der feinen Skalierungsstriche
                CTmSize    : 0.08;     // Länge der Grobskalierungsstriche
                FTmSize    : 0.04;     // Länge der Feinskalierungsstriche
                TmStyle    : tmInner;  // Skalierungsstrich nur innen
                GrStyle    : lsNone;   // kein Raster
                AxStyles   : []);

// Standardränder für Diagramme (Charts)
  MetricChart : TFRect  = (Left : 1.0; Top : 0.5; Right : 0.5; Bottom : 1.0);
  InchChart : TFRect  = (Left : 0.4; Top : 0.2; Right : 0.2; Bottom : 0.4);

// Standardgraphikobjekt
  MetricDrawing : TDrawingProperties  // in cm
             = (HdWidth    : 0.15;         // Spitzenbreite
                HdLength   : 0.3;          // Spitzenlänge
                LWidth     : MetricLineWidth; // Linienbreite
                ArrowStyle : asNone;       // Pfeilspitzen
                Style      : lsSolid;      // durchgezogene Linie
                Transparent : true;        // transparenter Hintergrund
                Border     : true;         // mit Umrahmung
                LColor     : clBlack;      // Farbe - Linien
                BgColor    : clWhite);     // Farbe - Hintergrund
  InchDrawing : TDrawingProperties  // in inch
             = (HdWidth    : 0.06;         // halbe Spitzenbreite
                HdLength   : 0.12;         // Spitzenlänge
                LWidth     : InchLineWidth;   // Linienbreite
                ArrowStyle : asNone;       // Pfeilspitzen
                Style      : lsSolid;      // durchgezogene Linie
                Transparent : true;        // transparenter Hintergrund
                Border     : true;         // mit Umrahmung
                LColor     : clBlack;      // Farbe - Linien
                BgColor    : clWhite);     // Farbe - Hintergrund

type
  TPenStat = (psLast,psMove,psDraw);

  TDataCol = (dcValX,dcValY,dcErrSX,dcErrAX,dcErrSY,dcErrAY,dcTime); // Daten + symm./asymm. Fehler
  TDataCols = set of TDataCol;
  TErrBarDirection = (ebHorz,ebVert);

  TData = record
    Val,PErr,MErr : TFPoint;  // X-, Y-Wert, pos. Fehler, neg. Fehler
    end;

  TDataArray = array of TData;
  TDataTable = record
    DataCols  : TDataCols; // etErrSX oder etErrAX + etErrSY oder etErrAY
    Count     : integer;
    Data      : TDataArray;
    end;

  THitData = record
    Available : boolean;
    Data : array of TFPoint;
    end;

  TFitType = (ftNone,ftLin,ftPoly);

  TFuncSet = record
    Valid : boolean;
    x,y   : double;
    end;

  TFuncData = record
    Computed : boolean;
    Data : array of TFuncSet;
    end;

  TUserAxis = record
    MinVal,MaxVal : double;      // Achsenbereich in Benutzerkoordinaten
    AxPos         : TAxPos;      // Achsenposition
    OAxSelect     : integer;     // Y- bzw. X-Achse für 0-Position
    Caption,Units : string;      // Achsenbeschriftung
    CapPos        : integer;     // Beschriftungsposition in %
    AxLen         : double;      // Achsenlänge
    end;

const
  MetricCurve : TCurveProperties = (
    JoinMode     : jmLine;          // Punkte verbinden
    ErrorBars    : [];              // Fehlerbalken
    SmoothFactor : 5;               // Splineglättung
    SymType      : defSym;          // Form der Markierungen
    SymSize      : MetricSymSize;   // Größe der Punktmarkierungen
    LStyle       : lsSolid;         // Linienstil
    LWidth       : MetricLineWidth; // Linienbreite - Linien
    EWidth       : MetricLineWidth; // Linienbreite - Fehlerbalken
    LColor       : defLColor;       // Farbe - Linien
    MColor       : defLColor;       // Farbe - Markierungen
    EColor       : defLColor);      // Farbe - Fehlerbalken

  InchCurve : TCurveProperties = (
    JoinMode     : jmLine;          // Punkte verbinden
    SymType      : defSym;          // Form der Markierungen
    SymSize      : InchSymSize;     // Größe der Punktmarkierungen
    LStyle       : lsSolid;         // Linienstil
    LWidth       : InchLineWidth;   // Linienbreite - Linien
    EWidth       : InchLineWidth;   // Linienbreite - Fehlerbalken
    LColor       : defLColor;       // Farbe - Linien
    MColor       : defLColor;       // Farbe - Markierungen
    EColor       : defLColor);      // Farbe - Fehlerbalken

  MetricFit : TFitProperties =  (
    FitOrder       : 1;             // Grad der Pol.-Approximation
    FitMin         : 0;
    FitMax         : 10;            // X-Bereich für Fit-Funktion
    FitAll         : true;          // Fit über ges. X-Bereich oder Teil
    ViewAll        : false;         // Anzeige Fit ganz oder Wertebereich
    XScale         : stLin;         // Skalierung (lin, log, reziprok oder ?)
    YScale         : stLin;
    LStyle         : lsSolid;       // Linienstil
    LWidth         : MetricLineWidth; // Linienbreite - Linien
    LColor         : defLColor);    // Farbe - Linie

  InchFit : TFitProperties =  (
    FitOrder       : 1;             // Grad der Pol.-Approximation
    FitMin         : 0;
    FitMax         : 10;            // X-Bereich für Fit-Funktion
    FitAll         : true;          // Fit über ges. X-Bereich oder Teil
    ViewAll        : false;         // Anzeige Fit ganz oder Wertebereich
    XScale         : stLin;         // Skalierung (lin, log, reziprok oder ?)
    YScale         : stLin;
    LStyle         : lsSolid;       // Linienstil
    LWidth         : InchLineWidth; // Linienbreite - Linien
    LColor         : defLColor);    // Farbe - Linie

  MetricFunction : TFunctionProperties = (
    FuncAll      : true;       // Funktion über ges. X-Bereich oder Teil
    LStyle       : lsSolid;       // Linienstil
    LWidth       : MetricLineWidth; // Linienbreite - Linien
    LColor       : defLColor;  // Farbe - Linien
    AngularUnit  : auRadiant;  // Winkeleinheiten der Formel
    Formula      : '');        // Formel

  InchFunction : TFunctionProperties = (
    FuncAll      : true;       // Funktion über ges. X-Bereich oder Teil
    LStyle       : lsSolid;       // Linienstil
    LWidth       : InchLineWidth; // Linienbreite - Linien
    LColor       : defLColor;  // Farbe - Linien
    AngularUnit  : auRadiant;  // Winkeleinheiten der Formel
    Formula      : '');        // Formel

type
  TBoxTyp = (btFrame,btFitStd,btFitUser,btText,btLine);

  TDataOption = (doData,doChart);
  TDataOptions = set of TDataOption;

const
  doAll = [doData,doChart];

{ ------------------------------------------------------------------- }
type
  TChartItemIndex = record
    ChartNr,ItemNr : integer;
    end;

{  Item-IDs: 256.. Axis
             512.. Curve
             768.. Fit
            1024.. Graph
            1280.. Function
            1536.. Text
            1792.. Image
            2048.. Drawing
  }

  TItemType = (itNone,itAxis,itCurve,itFit,itGraph,itFunction,itText,itImage,itDrawing);
  TGraphType = (gtBar,gtHisto,gtPie);
  TTextType = (ttText,ttFitResult,ttLegend,ttComment);
  TDrawingType = (dtLine,dtRect);

const
  ItemTypeNames : array[TItemType] of string = ('','Axis','Curve','Fit','Graph','Function',
                          'Text','Image','Drawing');
  TextTypeNames : array[TTextType] of string = ('Text','FitResult','Legend','Comment');
  GraphTypeNames : array[TGraphType] of string = ('Barchart','Histogram','Piechart');
  DrawingTypeNames : array[TDrawingType] of string = ('Line','Rectangle');

type
  TChart = class;

  TChartItem = class  (TObject)
  private
    FItemType     : TItemType;
    FDesc         : string;
    FChart        : TChart;
    FIndex,FID    : integer;
    FOutline      : TFRect;
    function GetStatus : boolean;
    function GetDecSep : Char;
  protected
    FDeleted,                   // wurde gelöscht
    FVisible      : boolean;    // Item anzeigen
    function GetDesc : string; virtual;
    function GetTypeName : string; virtual;
    function GetOutline : TFRect; virtual;
    procedure SetOutLine (Value : TFRect);
    function GetIsMoveable : boolean;
    function DataToStr(ADataCols : TDataCols; Data : TData) : string;
    function StrToData (ADataCols: TDataCols; s : string) : TData;
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); virtual;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); virtual;
  public
    constructor Create (AItemType : TItemType; AChart : TChart);
    procedure Assign (AChartItem : TChartItem);
    function AddToList (AList : TObjectList) : integer;
    procedure LoadTemplate (const AName,Id,Section : string);
    procedure SaveTemplate (const AName,Id,Section : string);
    procedure Reset; virtual;            // reset all computations in items
    function IsInItem (APos : TFPoint) : boolean; virtual;
    function HitsItem (APos : TFPoint; Delta : double) : TItemAction; virtual;
    procedure MovePos (Offset : TFPoint); virtual;
    procedure MoveStart (Offset : TFPoint); virtual;
    procedure MoveEnd (Offset : TFPoint); virtual;
    procedure MoveStartEnd (Offset : TFPoint); virtual;
    procedure MoveEndStart (Offset : TFPoint); virtual;
    property DecimalSeparator : Char read GetDecSep;
    property Deleted : boolean read FDeleted write FDeleted;
    property Description : string read GetDesc write FDesc;
    property TypeName : string read GetTypeName;
    property ItemID : integer read FID;
    property Index : integer read FIndex;
    property IsMoveable : boolean read GetIsMoveable;
    property IsNew : boolean read GetStatus;
    property Itemtype : TItemType read FItemType;
    property OutLine : TFRect read GetOutline write SetOutline;
    property ParentChart : TChart read FChart;
    property Visible : boolean read FVisible write FVisible;
    end;

  TAxisItem = class (TChartItem)
  private
    FFactor,FOffset  : double;
  protected
    function GetDesc : string; override;
    function GetAxPos : double;   // abs. Position
    function GetOutline : TFRect; override;
  public
    AxType        : TAxisType;
    FSpace,
    MinVal,MaxVal,
    GridWidth     : double;      // Bereich
    GridTicks     : integer;
    AxPos         : TAxPos;      // Position links/unten, rechts/oben oder benutzerdefiniert
    AxOffset      : double;      // Offset der Achsenposition in cm/inch rel. zu Rand
    ScaleType     : TScaleType;  // Skalierung (lin, log, reziprok oder Zeit)
    Caption,AUnit : string;      // Legendentext, Einheit der Werte
    Labels        : TStringList; // benutzerdef. Beschriftung
    Properties    : TAxisProperties;  // Achseneigenschaften
    constructor Create (AChart : TChart; AAxType : TAxisType; AProps : TAxisProperties);
    constructor CreateFrom (AAxis : TaxisItem);
    destructor Destroy; override;
    procedure Assign (AAxis : TAxisItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
//    function IsInItem (APos : TFPoint) : boolean; override;
    procedure InitScale (AField : TFRect);
    function GetGrid : double;
    function GetFGrid (Grid : double) : integer;
    procedure AlignLimits;
    function Scale (Val : double) : double;
    function InvUserScale (Val : double) : double;
    property AxisPosition : double read GetAxPos;
    end;

  TTextOption = (toDesc,toSigma,toSymbol,toUnits);
  TTextOptions = set of TTextOption;

  TCurveItem = class (TChartItem)
  protected
    function GetDesc : string; override;
    function GetOutline : TFRect; override;
    function CompareVals (const arg1,arg2) : boolean;
  public
    XAxID,YAxID   : integer;     // IDs der zugeordneten Achsen
    DataTable     : TDataTable;
    HitData       : THitData;    // skalierte Werte für Mauslokalisierung
    SplineData    : TFuncData;
    Properties    : TCurveProperties;
    constructor Create (AChart : TChart; AProps : TCurveProperties);
    constructor CreateFrom (ACurve : TCurveItem);
    procedure Assign (ACurve : TCurveItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    function HitsItem (APos : TFPoint; Delta : double) : TItemAction; override;
    procedure Reset; override;
    procedure ComputeSplineFit;
//    function GetFitString (Options : TTextOptions) : string;
    end;

  TFitItem = class (TChartItem)
  protected
    function GetDesc : string; override;
    function GetOutline : TFRect; override;
  protected
  public
    CurveID       : integer;
    XUnit,YUnit   : string;
    Precision     : integer;
    HitData       : THitData;    // skalierte Werte für Mauslokalisierung
    FitData       : TFuncData;
    FitResult     : TFitResult;
    Properties    : TFitProperties;
    constructor Create (AChart : TChart; AProps : TFitProperties);
    constructor CreateFrom (AFit : TFitItem);
    procedure Assign (AFit : TFitItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    function HitsItem (APos : TFPoint; Delta : double) : TItemAction; override;
    procedure Reset; override;
    procedure ComputeFit;
    function GetFitString (Options : TTextOptions) : string;
    end;

  THistData = record
    Computed : boolean;
    Data : array of cardinal;
    end;

  TGraphItem = class (TChartItem)
  protected
    function GetDesc : string; override;
    function GetTypeName : string; override;
    function GetOutline : TFRect; override;
  public
    GraphType     : TGraphType;
    XAxID,YAxID   : integer;     // IDs der zugeordneten Achsen
    DataTable     : TDataTable;
    HistData      : THistData;
    HitData       : THitData;    // skalierte Werte für Mauslokalisierung
    Properties    : TGraphProperties;
    constructor Create (AChart : TChart; AProps : TCurveProperties; AType : TGraphType);
    constructor CreateFrom (AGraph : TGraphItem);
    procedure Assign (AGraph : TGraphItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    function HitsItem (APos : TFPoint; Delta : double) : TItemAction; override;
    procedure Reset; override;
    procedure ComputeHistogram;
    end;

  TFunctionItem = class (TChartItem)
  protected
    function GetDesc : string; override;
    function GetOutline : TFRect; override;
  public
    XAxID,YAxID   : integer;     // IDs der zugeordneten Achsen
    HitData       : THitData;    // skalierte Werte für Mauslokalisierung
    FuncData      : TFuncData;
    Properties    : TFunctionProperties;
    constructor Create (AChart : TChart; AProps : TFunctionProperties);
    constructor CreateFrom (AFunction : TFunctionItem);
    procedure Assign (AFunction : TFunctionItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    function HitsItem (APos : TFPoint; Delta : double) : TItemAction; override;
    procedure Reset; override;
    procedure ComputeFunction;
    end;

  TTextItem = class (TChartItem)
  private
    FPosition        : TFPoint;
  protected
    function GetDesc : string; override;
    function GetTypeName : string; override;
    function GetOutline : TFRect; override;
    function GetPos  : TFPoint;
    procedure SetPos (APos : TFPoint);
  public
    TextType      : TTextType;
    Text          : string;
    CurveID       : integer;
    Options       : TTextOptions;
    Properties    : TTextProperties;
    constructor Create (AChart : TChart; AFont : TPlotFont; AType : TTextType);
    constructor CreateFrom (AText : TTextItem);
    procedure Assign (AText : TTextItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure MovePos (Offset : TFPoint); override;
    property Position : TFPoint read GetPos write SetPos;
    end;

  TImageItem = class (TChartItem)
  private
    FArea            : TFloatArea;
    FImage           : TBitmap;
  protected
    function GetDesc : string; override;
    function GetOutline : TFRect; override;
    function GetArea : TFloatArea;
    procedure SetArea (AArea : TFloatArea);
    function LoadImage (const FName : string; ATrans : boolean) : boolean;
    procedure SaveImage (const FName : string);
  public
    ImgName          : string;
    Transparent,                    // transparenter Hintergrund
    Border           : boolean;     // mit Umrahmung
    Ratio,                          // originales Seitenverhältnis
    LWidth           : double;      // Linienbreite - Rahmen
    LColor           : TColor;      // Farbe - Linien
    constructor Create (AChart : TChart);
    constructor CreateFrom (AImage : TImageItem);
    destructor Destroy; override;
    procedure Assign (AImage : TImageItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure MovePos (Offset : TFPoint); override;
    function CreateFilename : string;
    property Area : TFloatArea read GetArea write SetArea;
    property Image : TBitMap read FImage write FImage;
    end;

  TDrawingItem = class (TChartItem)
  private
    FStartPt,FEndPt  : TFPoint;
  protected
    function GetDesc : string; override;
    function GetOutline : TFRect; override;
    function GetPoint (Index : integer) : TFPoint;
    function GetRect : TFRect;
    procedure SetPoint (Index : integer; APos : TFPoint);
  public
    DrawingType : TDrawingType;
    Properties : TDrawingProperties;
    constructor Create (AChart : TChart; AProps : TDrawingProperties; AType : TDrawingType = dtLine);
    constructor CreateFrom (ADrawing : TDrawingItem);
    procedure Assign (ADrawing : TDrawingItem);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions); override;
    function HitsItem (APos : TFPoint; Delta : double) : TItemAction; override;
    procedure MovePos (AOffset : TFPoint); override;
    procedure MoveStart (AOffset : TFPoint); override;
    procedure MoveEnd (AOffset : TFPoint); override;
    procedure MoveStartEnd (AOffset : TFPoint); override;
    procedure MoveEndStart (AOffset : TFPoint); override;
    property StartPoint : TFPoint index 0 read GetPoint write SetPoint;
    property EndPoint : TFPoint index 2 read GetPoint write SetPoint;
    property RectPoint[Index : integer] : TFPoint read GetPoint write SetPoint;
    property Rectangle : TFRect read GetRect;
    end;

{ ------------------------------------------------------------------- }
  TSheet = class;

  TItemIndexes = array [TItemType] of integer;

  TChartBorder = record
    Visible : boolean;
    LnWidth : double;
    LColor  : TColor;
    LStyle  : TLineStyle;
    end;

  TChart = class (TObject)
  private
    FSheet         : TSheet;
    FIndex,FID     : integer;
    FInnerArea,                     // innerer Bereich des Koordinatensystems
    FArea          : TFloatArea;    // äußere Begrenzung
    FBorder        : TChartBorder;
    FBColor        : TColor;
    FDeleted,
    FVisible       : boolean;       // Chart anzeigen
    FUserClip      : boolean;
    FItems         : TObjectList;
    LastIndex      : TItemIndexes;
    FChartDesc     : string;
    function GetChartDesc : string;
    function GetChartItemCount : integer;
    function GetChartItem (AIndex : integer) : TChartItem;
  public
    XChartSpace,YChartSpace,           // Breite des Randes ohne Achse
    XAxisSpace,YAxisSpace  : double;   // Platz für Achsenbeschriftung
    constructor Create (ASheet : TSheet; AArea : TFloatArea);
    constructor CreateAsNew (ASheet : TSheet);        // add new chart
    constructor CreateFrom (AChart : TChart);         // duplicate chart
    destructor Destroy; override;
    procedure Assign (AChart : TChart; WithArea : boolean);
    procedure LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
    procedure SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
    procedure LoadTemplate (const AName,Id : string);
    procedure SaveTemplate (const AName,Id : string);
    procedure SetInnerArea;
    function ScaleFromID (AxID : integer; Value : double) : double;
    function Scale (AxNdx : integer; Value : double) : double;
    function AddToList (AList : TObjectList) : integer;
    procedure Clear;
    procedure ResetItems;             // reset all items
    function IndexOf (AID : integer) : integer;
    function GetAxisOffset (AAxType : TAxisType) : TOffset;
    procedure SetAxesOffset (AAxType : TAxisType; Value : double);
    function GetAxisCount (AAxType : TAxisType; AAxPos : TAxPos) : integer;
    function GetFirstAxisID (AAxType : TAxisType) : integer;
    function GetItemOffset : TFPoint;
    function GetCenterPos : TFPoint;
    function GetItemTypeCount (AItemType : TItemType) : integer;
    function GetFirstItemID (AItemType : TItemType) : integer;
    function GetFirstItem (AItemType : TItemType) : TChartItem;
    function GetNextItem (AItemType : TItemType) : TChartItem;
    function GetItemFromID (AID : integer) : TChartItem;
    function AddNewItem (AItemType : TItemType) : TChartItem;
    function AddItemByName (const AItemName : string) : TChartItem;
    function AddItem (AItem : TChartItem) : integer;
    procedure ExchangeItems(AIndex1,AIndex2 : integer);
    procedure DeleteItem (AIndex : integer);
    function AddAxis (AAxType : TAxisType) : TAxisItem;
    function AddCurve : TCurveItem;
    function AddFit : TFitItem;
    function AddGraph (gt : TGraphType = gtBar) : TGraphItem;
    function AddFunction : TFunctionItem;
    function AddText (tt : TTextType = ttText) : TTextItem;
    function AddImage : TImageItem;
    function AddDrawing (dt : TDrawingType = dtLine) : TDrawingItem;
    function CreateID (AItemType : TItemType) : integer;
    function IsInChart (APos : TFPoint) : boolean;
    procedure UpdateFits (AItemID : integer);
    property Area : TFloatArea read FArea write FArea;  // rel. zu unterer linker Ecke
    property Border : TChartBorder read FBorder write FBorder;
    property ChartColor : TColor read FBColor write FBColor;
    property ChartDesc : string read GetChartDesc write FChartDesc;
    property ChartID : integer read FID;
    property Deleted : boolean read FDeleted write FDeleted;
    property InnerArea : TFloatArea read FInnerArea;  // rel. zu unterer linker Ecke
    property ItemCount : integer read GetChartItemCount;
    property Item[Index : integer] : TChartItem read GetChartItem;
    property ParentSheet : TSheet read FSheet;
    property Index : integer read FIndex;
    property Visible : boolean read FVisible write FVisible;
    end;

{ ------------------------------------------------------------------- }
  TSheet = class (TObject)
  private
    FOwner         : TComponent;
    FPlotUnit      : TPlotUnit;
    FProperties    : TSheetProperties;
    FSheetDesc,
    FFileName      : string;
    FCharts        : TObjectList;
    FZipFile       : TZipFile;
    procedure SetDefaultProperties;
    procedure SetProperties (Value : TSheetProperties);
    procedure SetSize (Value : TFloatSize);
    procedure SetMargin (Value : TFRect);
    procedure SetUnit (AUnit : TPLotUnit);
    function GetChartCount : integer;
    function GetChart (Index : integer) : TChart;
    procedure SetChart (AIndex : integer; ch : TChart);
    function CreateID :  integer;
  public
    DefObjProps    : TDefaultObjectProperties;
    constructor Create (AOwner : TComponent; AUnit : TPlotUnit);
    destructor Destroy; override;
    procedure LoadFromStream (AStream : TStream);
    procedure SaveToStream (AStream : TStream);
    function LoadFromFile (const AName : string) : boolean;
    function LoadFromSourceFile (const AName : string) : boolean;
    procedure SaveToFile (const AName : string = '');
    procedure SaveToSourceFile (const AName : string);
    procedure Clear;          // delete all components
    procedure ResetCharts;    // reset charts
    function AddChart : TChart; overload;
    function AddChart (AArea : TFloatArea) : TChart; overload;
    procedure ExchangeCharts(AIndex1,AIndex2 : integer);
    procedure DeleteChart (Index : integer);
    function GetDefaultChartArea : TFloatArea;
    procedure AdjustChartAreas;
    procedure AdjustSize;

    property PlotUnit : TPlotUnit read FPlotUnit write SetUnit;             // Maßeinheit
    property Properties : TSheetProperties read FProperties write SetProperties;
    property SheetColor : TColor read FProperties.FBakColor write FProperties.FBakColor;
    property DecimalSeparator : char read FProperties.FDecSep write FProperties.FDecSep;

    // Standardvorgaben für Linien
    property DefaultLineWidth : double read FProperties.FLineWidth;
    property DefaultLineStyle : TLineStyle read FProperties.FLineStyle;
    property DefaultLineColor : TColor read FProperties.FLineColor;
    property DefaultSymbolSize : double read FProperties.FSymSize;
    property DefFillColor : TColor read FProperties.FFillColor;

    // Standardvorgaben für Schrift
    property DefTextFont : TPlotFont read FProperties.FPlotFont;

    property Filename : string read FFileName;
    property SheetDesc : string read FSheetDesc write FSheetDesc;
    property Size : TFloatSize read FProperties.FSize write SetSize;
    property Margin : TFRect read FProperties.FMargin write SetMargin;
    property ChartCount : integer read GetChartCount;
    property Chart[Index : integer] : TChart read GetChart write SetChart; default;
    property ZipFile : TZipFile read FZipFile;
    end;

  TOutline = record
    Valid : boolean;
    Rect  : TFRect;
    end;

function FloatPoint (ax,ay : double) : TFPoint;
function FloatSize (aw,ah : double) : TFloatSize;
function FloatRect (al,ab,ar,at : double) : TFRect; overload;
function FloatRect (lb,tr : TFPoint) : TFRect; overload;
function FloatArea (al,ab,aw,ah : double) : TFloatArea; overload;
function FloatArea (lb,tr : TFPoint) : TFloatArea; overload;
function MovePoint (pt,off : TFPoint) : TFPoint;
function MoveRect (re : TFRect; off : TFPoint) : TFRect;
function MoveArea (ar : TFloatArea; off : TFPoint) : TFloatArea;
function AreaToRect (ar : TFloatArea) : TFRect;

function TryStringToFloat(const ValStr : string; var Value : double; DecSep : Char = #0) : boolean;
function TryStringToDateTime (s : string; var dt : TDateTime;
                              TimeSep : Char = #0; DecSep : Char = #0) : boolean;
function ReadNxtDateTime (var s : String; Del : char; Default : TDateTime;
                          TimeSep : Char = #0; DecSep : Char = #0) : TDateTime;
function StringToFloat (const s : string; Default : extended) : extended;
function FloatToString (Value : extended; Format: TFloatFormat; Precision, Digits: Integer) : string;

function NumberToPlotString (const s : string) : string;

implementation

uses GnuGetText, ExtSysUtils, NumberUtils, MathUtils, StrUtils, XMLUtils, FileUtils,
  System.DateUtils, System.Math, Vcl.Imaging.jpeg, RPlotUtils, MsgDialogs;

{ ------------------------------------------------------------------- }
const
  defChartArea : TFloatArea = (Left : 0; Bottom : 0; Width : 10; Height : 10);

{ ------------------------------------------------------------------- }
procedure TFloatArea.Offset(const DX, DY: double);
begin
  BottomLeft.Offset(DX,DY);
  end;

procedure TFloatArea.Offset(const Point: TFPoint);
begin
  BottomLeft.Offset(Point);
  end;

function TFloatArea.AsFRect : TFRect;
begin
  Result.Left:=Left; Result.Bottom:=Bottom; Result.Right:=Left+Width; Result.Top:=Bottom+Height;
  end;

{ ------------------------------------------------------------------- }
function FloatPoint (ax,ay : double) : TFPoint;
begin
  with Result do begin
    X:=ax; Y:=ay;
    end;
  end;

function FloatSize (aw,ah : double) : TFloatSize;
begin
  with Result do begin
    Width:=aw; Height:=ah;
    end;
  end;

(* Rechteck als Double zuweisen (siehe auch Rect) *)
function FloatRect (al,ab,ar,at : double) : TFRect;
begin
  with Result do begin
    Left:=al; Bottom:=ab;
    Right:=ar; Top:=at;
    end;
  end;

function FloatRect (lb,tr : TFPoint) : TFRect;
begin
  Result:=FloatRect(lb.X,lb.Y,tr.X,tr.Y);
  end;

function FloatArea (al,ab,aw,ah : double) : TFloatArea;
begin
  with Result do begin
    Left:=al; Bottom:=ab;
    Width:=aw; Height:=ah;
    end;
  end;

function FloatArea (lb,tr : TFPoint) : TFloatArea;
begin
  Result:=FloatArea(lb.X,lb.Y,tr.X-lb.X,tr.Y-lb.Y);
  end;

function MovePoint (pt,off : TFPoint) : TFPoint;
begin
  with Result do begin
    x:=pt.x+off.X; y:=pt.y+off.Y;
    end;
  end;

function MoveRect (re : TFRect; off : TFPoint) : TFRect;
begin
  with Result do begin
    Left:=re.Left+off.x; Top:=re.Top+off.Y;
    Right:=re.Right+off.x; Bottom:=re.Bottom+off.Y;
    end;
  end;

function MoveArea (ar : TFloatArea; off : TFPoint) : TFloatArea;
begin
  with Result do begin
    Left:=ar.Left+off.X; Bottom:=ar.Bottom+off.Y;
    Width:=ar.Width; Height:=ar.Height;
    end;
  end;

function AreaToRect (ar : TFloatArea) : TFRect;
begin
  with ar do begin
    Result.Left:=Left; Result.Bottom:=Bottom;
    Result.Right:=Left+Width; Result.Top:=Bottom+Height;
    end;
  end;

function RectToArea (re : TFRect) : TFloatArea;
begin
  with re do begin
    Result.Left:=Left; Result.Bottom:=Bottom;
    Result.Width:=Right-Left; Result.Height:=Top-Bottom;
    end;
  end;

{ ------------------------------------------------------------------- }
// Distance between two points
function Distance (PtA,PtB : TFPoint) : double;
begin
  Result:=sqrt(sqr(PtB.X-PtA.X)+sqr(PtB.Y-PtA.Y));
  end;

function IsNearPoint (Pt,PtA : TFPoint; Delta : double) : boolean;
begin
  Result:=abs(Distance(Pt,PtA))<=Delta;
  end;

// Distance between point and line
function LineDist (Pt,PtA,PtB : TFPoint) : double;
var
  A,B,C : double;
begin
  A:=PtA.Y-PtB.Y; B:=PtB.X-PtA.X;
  if (A=0) and (B=0) then Result:=0
  else begin
    C:=PtA.X*PtB.Y-PtA.Y*PtB.X;
    with Pt do Result:=(A*X+B*Y+C)/sqrt(sqr(A)+sqr(B));
    end;
  end;

function IsNearLineSection (Pt,PtA,PtB : TFPoint; Delta : double) : boolean;
var
  d : double;
begin
  d:=abs(PtA.X-PtB.X);
  if d<Delta then begin
    d:=abs(PtA.Y-PtB.Y);
    Result:=(abs(Pt.Y-PtA.Y)<=d) and (abs(Pt.Y-PtB.Y)<=d);
    end
  else Result:=(abs(Pt.X-PtA.X)<=d) and (abs(Pt.X-PtB.X)<=d);
  if Result then Result:=abs(LineDist (Pt,PtA,PtB))<=Delta;
  end;

function IsInRect (Pt : TFPoint; R : TFRect) : boolean;
begin
  with R,Pt do Result:=(x>=Left) and (x<=Right) and (y>=Bottom) and (y<=Top);
  end;

{ ------------------------------------------------------------------- }
function TryStringToFloat(const ValStr : string; var Value : double; DecSep : Char) : boolean;
var
  fs   : TFormatSettings;
begin
  fs:=FormatSettings;
  if DecSep<>#0 then fs.DecimalSeparator:=DecSep;
  Result:=TryStrToFloat(ValStr,Value,fs);
  end;

function TryStringToDateTime (s : string; var dt : TDateTime; TimeSep,DecSep : Char) : boolean;
var
  j1,j2,j3 : integer;
  err : boolean;
  tm : TDateTime;
  xs : double;
begin
  err:=false;
  if TimeSep=#0 then TimeSep:=FormatSettings.TimeSeparator;
  s:=Trim(s);
  if length(s)>0 then begin
    if Pos('-',s)>0 then begin // mit Datum
      j1:=ReadNxtInt(s,'-',YearOf(Now),err);
      j2:=ReadNxtInt(s,'-',MonthOf(Now),err);
      j3:=ReadNxtInt(s,' ',DayOf(Now),err);
      if not err then begin
        try dt:=EncodeDate(j1,j2,j3); except err:=true; end;
        end;
      end
    else begin
      j1:=Pos(TimeSep,s); j2:=Pos('.',s);
      if ((j1=0) and (j2>0)) or ((j2>0) and (j2<j1)) then begin
        j3:=ReadNxtInt(s,'.',DayOf(Now),err);
        j2:=ReadNxtInt(s,'.',MonthOf(Now),err);
        j1:=ReadNxtInt(s,' ',YearOf(Now),err);
        if not err then begin
          try dt:=EncodeDate(j1,j2,j3); except err:=true; end;
          end;
        end
      else dt:=Date;   // no date specified, take current
      end;
    if not err then begin
      if (length(s)>0) then begin  // Zeit
        if Pos(TimeSep,s)>0 then err:=not TryStrToTime(s,tm)
        else begin
          err:=not TryStringToFloat(s,xs,DecSep);
          tm:=xs*OneSecond;
          end;
        if not err then dt:=DateOf(dt)+TimeOf(tm);
        end;
      end
    else dt:=Now;
    end
  else dt:=Now;
  Result:=not err;
  end;

{ ------------------------------------------------------------------- }
function NumberToPlotString (const s : string) : string;
var
  i : integer;
begin
  i:=Pos('E',s);
  if i>0 then begin
    Result:=AnsiReplaceText(s,'E','·10^')+'^';
    if (i=2) and (s[1]='1') then Delete(Result,1,2); // 1Ex = Ex
    end
  else Result:=s;
  end;

// Read Integer or Float from string s until next delimiter
// remove the processed part from string
function ReadNextInteger (var s   : String;
                          Del     : char;
                          Default : int64) : int64;
var
  n    : int64;
  i,ic : integer;
begin
  i:=pos (Del,s);
  if i>1 then s:=TrimLeft(s);
  i:=pos (Del,s);
  if i=0 then i:=succ(length(s));
  val(copy(s,1,pred(i)),n,ic);
  if ic=0 then Result:=n
  else Result:=Default;
  delete(s,1,i);
  end;

// Decimal separator is period
function ReadNextFloat (var s   : String;
                        Del     : char;
                        Default : double) : double;
var
  i    : integer;
  x    : double;
  fs   : TFormatSettings;
begin
  fs:=FormatSettings;
  fs.DecimalSeparator:='.';
  i:=pos (Del,s);
  if i>1 then s:=TrimLeft(s);
  i:=pos (Del,s);
  if i=0 then i:=succ(length(s));
  if TryStrToFloat(copy(s,1,pred(i)),x,fs) then Result:=x
  else Result:=Default;
  delete(s,1,i);
  end;

function ReadNxtDateTime (var s : String; Del : char; Default : TDateTime; TimeSep,DecSep : char) : TDateTime;
var
  sd : string;
begin
  sd:=ReplChars(ReadNxtStr(s,Del),'_',Space);
  if not TryStringToDateTime(sd,Result,TimeSep,DecSep) then Result:=Default;
  end;

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
// all dimensions in 1/100 cm/inch
function DimensionsToStr (Vals : array of double; Delim : char) : string;
var
  i : integer;
begin
  Result:='';
  for i:=low(Vals) to High(Vals) do Result:=Result+IntToStr(round(100*Vals[i]))+Delim;
  delete(Result,length(Result),1);
  end;

procedure StrToPosition (s : string; Delim : char; var APos : TFPoint);
begin
  with APos do begin
    X:=ReadNextInteger(s,Delim,round(100*X))/100;
    Y:=ReadNextInteger(s,Delim,round(100*Y))/100;
    end;
  end;

procedure StrToArea (s : string; Delim : char; var AArea : TFloatArea);
begin
  with AArea do begin
    Left:=ReadNextInteger(s,Delim,round(100*Left))/100;
    Bottom:=ReadNextInteger(s,Delim,round(100*Bottom))/100;
    Width:=ReadNextInteger(s,Delim,round(100*Width))/100;
    Height:=ReadNextInteger(s,Delim,round(100*Height))/100;
    end;
  end;

function GetFuncPoints (d,w : double; AStyle : TLineStyle) : integer;
begin
  if AStyle=lsDotted then Result:=round(d/(3*w))
  else if AStyle=lsDashed then Result:=round(d/(6*w))
  else Result:=FuncPoints;
  end;

{ ------------------------------------------------------------------- }
const
  iniID       = 'ID';
  iniDesc     = 'Description';
  iniSize     = 'Size';
  iniMargin   = 'Margin';
  iniCount    = 'Count';
  iniType     = 'Type';
  iniSubType  = 'SubType';
  iniPrec     = 'Precision';
  iniNotate   = 'Notation';
  iniArea     = 'Area';
  iniShow     = 'Visible';
  iniOpt      = 'Options';

  // Axis properties
  iniCap      = 'Caption';
  iniCapFont  = 'CaptionFont';
  iniCapPos   = 'CaptionPosition';
  iniLabPos   = 'LabelPosition';
  iniPos      = 'Position';
  iniAxScale  = 'ScaleType';
  iniAxType   = 'AxisType';
  iniAxPos    = 'AxisPos';
  iniLabels   = 'Labels';
  iniLab      = 'L';
  iniLShow    = 'ShowLabels';
  iniLabFont  = 'LabelFont';
  iniDatForm  = 'DateFormat';
  iniCTmSize  = 'CoarseTickmark';
  iniFTmSize  = 'FineTickmark';
  iniIvWidth  = 'TickmarkWidth';
  iniTmWidth  = 'StepWidth';
  iniTmStyle  = 'TickmarkStyle';
  iniGrStyle  = 'GridStyle';
  iniGrWidth  = 'GridWidth';
  iniAxStyles = 'AxisStyles';
  iniMin      = 'Min';
  iniMax      = 'Max';
  iniGrid     = 'Grid';
  iniTicks    = 'Ticks';

  // Curve properties
  iniXAxis    = 'XAxis';
  iniYAxis    = 'YAxis';
  iniJoin     = 'JoinMode';
  iniFitAll   = 'FitAll';
  iniFitView  = 'FitView';
  iniFMin     = 'FitLow';
  iniFMax     = 'FitHigh';
  iniSpSmooth = 'SplineSmooth';
  iniFitOrder = 'FitOrder';
  iniEbWidth  = 'EBarWidth';
  iniEbCol    = 'EBarColor';
  iniErrBar   = 'ErrorBars';
  iniColumns  = 'Columns';
  iniData     = 'Data';
  iniVal      = 'V';

  // Fit properties
  iniXScale    = 'XScale';
  iniYScale    = 'YScale';

  // Graph properties
  iniStripes  = 'Stripes';

  // Function properties
  iniFuncAll  = 'WholeRange';
  iniFormula  = 'Function';
  iniAngUnit  = 'AngleUnit';
  iniConst    = 'Constant';

  // Text properties
  iniText     = 'Text';
  iniCurve    = 'Curve';
  iniTrans    = 'Transparent';
  iniAlign    = 'Alignment';
  iniBorder   = 'Border';
  iniFont     = 'Font';
  iniName     = 'Name';
  iniAngle    = 'Angle';
  iniColor    = 'Color';
  iniBColor   = 'BorderColor';
  iniBgColor  = 'Background';

  // Image properties
  iniRatio = 'Ratio';

  // Line properties
  iniStPt     = 'StartPoint';
  iniEndPt    = 'EndPoint';
  iniHdLgt    = 'HeadLength';
  iniHdWdt    = 'HeadWidth';
  iniHdStyle  = 'HeadStyle';

{ ------------------------------------------------------------------- }
constructor TSheet.Create (AOwner : TComponent; AUnit : TPlotUnit);
begin
  inherited Create;
  FOwner:=AOwner;
  FCharts:=TObjectList.Create;
  FCharts.OwnsObjects:=true;
  FSheetDesc:=''; FFileName:='';
  SetUnit(AUnit);
  SetDefaultProperties;
  FZipFile:=nil;
  end;

destructor TSheet.Destroy;
begin
  FCharts.Free;
  end;

procedure TSheet.SetUnit (AUnit : TPLotUnit);
begin
  FPLotUnit:=AUnit;
  if FPlotUnit=puInch then Properties:=InchSheetProps
  else Properties:=MetricSheetProps;
  end;

{ ------------------------------------------------------------------- }
procedure TSheet.SetDefaultProperties;
begin
  with DefObjProps do begin
    if FPlotUnit=puInch then begin
      AxisProps:=InchAxis;
      CurveProps:=InchCurve;
      FitProps:=InchFit;
      FunctionProps:=InchFunction;
      DrawingProps:=InchDrawing;
      end
    else begin
      AxisProps:=MetricAxis;;
      CurveProps:=MetricCurve;
      FitProps:=MetricFit;
      FunctionProps:=MetricFunction;
      DrawingProps:=MetricDrawing;
      end;
    with Properties do begin
      with AxisProps,FPlotFont do begin
        CapFont.FontName:=FontName;
        CapFont.FontColor:=FontColor;
        CapFont.FontStyle:=FontStyle;
        CapFont.FontType:=FontType;
        LabFont.FontName:=FontName;
        LabFont.FontColor:=FontColor;
        LabFont.FontStyle:=FontStyle;
        LabFont.FontType:=FontType;
        LabFont.FontSize:=FLabSize;
        LabDist:=FLabDist;
        CapFont.FontSize:=FCapSize;
        CapDist:=FCapDist;
        LnWidth:=FAxLnWidth;
        GrWidth:=FAxLnWidth;
        IvWidth:=FAxLnWidth;
        TmWidth:=FAxLnWidth;
        CTmSize:=FTickLength;
        FTmSize:=FTickLength/2;
        if FAxisFrame then Include(AxStyles,asBorder)
        else Exclude(AxStyles,asBorder)
        end;
      with DrawingProps do begin
        LWidth:=FLineWidth;
        Style:=FLineStyle;
        LColor:=FLineColor;
        if FillColor>=0 then BgColor:=FFillColor;
//        else if FChartColor<0 then BgColor:=FBakColor else BgColor:=FChartColor;
        end;
      with CurveProps do begin
        SymSize:=FSymSize;
        SymType:=FSymType;
        LStyle:=FLineStyle;
        LWidth:=FLineWidth;
        EWidth:=FLineWidth;
        LColor:=FLineColor;
        MColor:=FLineColor;
        EColor:=FLineColor;
        end;
      with FitProps do begin
        LWidth:=FLineWidth;
        LColor:=FLineColor;
        end;
      with FunctionProps do begin
        LWidth:=FLineWidth;
        LColor:=FLineColor;
        Constants:=nil;
        end;
      PlotFont:=FPlotFont;
      end;
    end;
  end;

procedure TSheet.SetProperties (Value : TSheetProperties);
begin
  FProperties:=Value;
  SetDefaultProperties;
  end;

{ ------------------------------------------------------------------- }
procedure TSheet.LoadFromStream (AStream : TStream);
var
  XDoc        : TXMLDocument;
  lnode,knode : IXMLNode;
  i,n         : integer;
  s           : string;
  nc          : TChart;
begin
  Clear;
  XDoc:=TXMLDocument.Create(FOwner);
  with XDoc do begin
//    Options:=[doNodeAutoCreate,doNodeAutoIndent];
    LoadFromStream(AStream);
    lnode:=XMLReadNode(DocumentElement,SheetSekt);
    if assigned(lnode) then begin
      SheetDesc:=XMLReadString(lnode,iniDesc,'');
      FPlotUnit:=TPlotUnit(XMLReadInteger(lnode,iniUnit,integer(puMetric)));
      with FProperties do begin
        with FSize do begin                    // all sizes in 1/100 cm
          s:=XMLReadString(lnode,iniSize,'');
          Width:=ReadNextInteger(s,ValDelim,round(100*Width))/100;
          Height:=ReadNextInteger(s,ValDelim,round(100*Height))/100;
          if length(s)>0 then FPageFormat:=TPageFormat(ReadNextInteger(s,ValDelim,0))  // since V. 1.3
          else FPageFormat:=pfUser;
          end;
        with FMargin do begin
          s:=XMLReadString(lnode,iniMargin,'');
          Left:=ReadNextInteger(s,ValDelim,round(100*Left))/100;
          Bottom:=ReadNextInteger(s,ValDelim,round(100*Bottom))/100;
          Right:=ReadNextInteger(s,ValDelim,round(100*Right))/100;
          Top:=ReadNextInteger(s,ValDelim,round(100*Top))/100;
          end;
        FBakColor:=XMLReadInteger(lnode,iniBakCol,FBakColor);
        FChartColor:=XMLReadInteger(lnode,iniChartCol,FChartColor);
        FDecSep:=chr(XMLReadInteger(lnode,iniDecSep,ord(FDecSep)));
        FLineWidth:=XMLReadInteger(lnode,iniLnWidth,round(100*FLineWidth))/100;
        FLineStyle:=TLineStyle(XMLReadInteger(lnode,iniLnStyle,integer(FLineStyle)));
        FLineColor:=XMLReadInteger(lnode,iniLnCol,FLineColor);
        FSymSize:=XMLReadInteger(lnode,iniSymSize,round(100*FSymSize))/100;
        FChartSpace:=XMLReadInteger(lnode,iniChSpace,round(100*FChartSpace))/100;
        FAxisSpace:=XMLReadInteger(lnode,iniAxSpace,round(100*FAxisSpace))/100;
        FAxLnWidth:=XMLReadInteger(lnode,iniAxLnWdt,round(100*FAxLnWidth))/100;
        FTickLength:=XMLReadInteger(lnode,iniAxTickMk,round(100*FTickLength))/100;
        FAxisFrame:=XMLReadBool(lnode,iniAxFrame,FAxisFrame);
        FLabDist:=XMLReadInteger(lnode,iniLabDist,round(100*FLabDist))/100;
        FCapDist:=XMLReadInteger(lnode,iniCapDist,round(100*FCapDist))/100;
        knode:=XMLReadNode(lNode,iniFont);
        with FPlotFont do if assigned(knode) then begin
          FontName:=XMLReadString(kNode,iniName,FontName);
          FontSize:=XMLReadInteger(kNode,iniSize,round(100*FontSize))/100;
          FontStyle:=[];
          if XMLReadBool(knode,iniBold,fsBold in FontStyle) then include(FontStyle,fsBold);
          if XMLReadBool(knode,iniItalic,fsItalic in FontStyle) then include(FontStyle,fsItalic);
          FontColor:=XMLReadInteger(kNode,iniColor,FontColor);
          FontType:=TFontType(XMLReadInteger(kNode,iniType,integer(FontType)));
          end;
        end;
      n:=XMLReadInteger(lnode,iniCount,0);  // number of charts
      for i:=0 to n-1 do begin
        nc:=TChart.Create(self,defChartArea);
        nc.LoadData(XMLReadNode(lnode,ChartSekt+ZStrint(i,3)),doAll);
        nc.AddToList(FCharts);  // add chart
        end;
      end;
    Free;
    end;
  SetDefaultProperties;
  end;

// load from plain XML
function TSheet.LoadFromSourceFile (const AName : string) : boolean;
var
  fs : TFileStream;
begin
  Result:=FileExists(AName);
  if Result then begin
    FFileName:=AName;
    fs:=TFileStream.Create(FFileName,fmOpenRead);
    LoadFromStream(fs);
    fs.Free;
    end;
  end;

// load from compressed XML
function TSheet.LoadFromFile (const AName : string) : boolean;
var
  ms : TMemoryStream;
  zh : TZipHeader;
begin
  Result:=FileExists(AName);
  if Result then begin
    FZipFile:=TZipFile.Create;
    ms:=TMemoryStream.Create;
    try
      with FZipFile do begin
        Open(AName,zmRead);
        Read(RpDataName,TStream(ms),zh);
        ms.Position:=0;
        FFileName:=AName;
        LoadFromStream(ms);
        Close;
        end;
    except
      ErrorDialog(_('Error reading file: ')+AName);
      end;
    FreeAndNil(FZipFile);
    ms.Free;
    end;
  end;

procedure TSheet.SaveToStream (AStream : TStream);
var
  XDoc        : TXMLDocument;
  lnode,knode : IXMLNode;
  i,n         : integer;
begin
  XDoc:=TXMLDocument.Create(FOwner);
  with XDoc do begin
    Options:=[doNodeAutoCreate,doNodeAutoIndent];
    Active:=true;
    Version:='1.0';
    Encoding:='ISO-8859-1';
    DocumentElement:=CreateElement(RpIdent,'');
    lnode:=XMLNewNode(DocumentElement,SheetSekt);
    XMLWriteVariant(lnode,iniDesc,SheetDesc);
    XMLWriteVariant(lnode,iniUnit,FPlotUnit);
    with FProperties do begin
      with FSize do XMLWriteVariant(lnode,iniSize,
        DimensionsToStr([Width,Height],ValDelim)+ValDelim+IntToStr(integer(FPageFormat)));
      with FMargin do XMLWriteVariant(lnode,iniMargin,DimensionsToStr([Left,Bottom,Right,Top],ValDelim));
      XMLWriteVariant(lnode,iniBakCol,FBakColor);
      XMLWriteVariant(lnode,iniChartCol,FChartColor);
      XMLWriteVariant(lnode,iniDecSep,ord(FDecSep));
      XMLWriteVariant(lnode,iniLnWidth,round(100*FLineWidth));
      XMLWriteVariant(lnode,iniLnStyle,integer(FLineStyle));
      XMLWriteVariant(lnode,iniLnCol,FLineColor);
      XMLWriteVariant(lnode,iniSymSize,round(100*FSymSize));
      XMLWriteVariant(lnode,iniChSpace,round(100*FChartSpace));
      XMLWriteVariant(lnode,iniAxSpace,round(100*FAxisSpace));
      XMLWriteVariant(lnode,iniAxLnWdt,round(100*FAxLnWidth));
      XMLWriteVariant(lnode,iniAxTickMk,round(100*FTickLength));
      XMLWriteVariant(lnode,iniAxFrame,FAxisFrame);
      XMLWriteVariant(lnode,iniLabDist,round(100*FLabDist));
      XMLWriteVariant(lnode,iniCapDist,round(100*FCapDist));
      knode:=XMLNewNode(lNode,iniFont);
      with FPlotFont do begin
        XMLWriteVariant(kNode,iniName,FontName);
        XMLWriteVariant(kNode,iniSize,round(100*FontSize));
        XMLWriteVariant(kNode,iniBold,fsbold in FontStyle);
        XMLWriteVariant(kNode,iniItalic,fsItalic in FontStyle);
        XMLWriteVariant(kNode,iniColor,FontColor);
        XMLWriteVariant(kNode,iniType,integer(FontType));
        end;
      end;
    n:=0;
    for i:=0 to FCharts.Count-1 do if not (FCharts[i] as TChart).Deleted then inc(n);
    XMLWriteVariant(lnode,iniCount,n);  // number of charts
    n:=0;
    for i:=0 to FCharts.Count-1 do with (FCharts[i] as TChart) do if not Deleted then begin
      SaveData(XMLNewNode(lnode,ChartSekt+ZStrint(n,3)),doAll);
      inc(n);
      end;
    SaveToStream(AStream);
    Free;
    end;
  end;

procedure TSheet.SaveToSourceFile (const AName : string);
var
  fs : TFileStream;
begin
  FFileName:=AName;
  fs:=TFileStream.Create(FFileName,fmCreate);
  fs.Free;
  end;

procedure TSheet.SaveToFile (const AName : string);
var
  fs : TMemoryStream;
begin
  if length(AName)>0 then FFileName:=AName;
  FZipFile:=TZipFile.Create;
  fs:=TMemoryStream.Create;
  with FZipFile do begin
    Open (FFileName,zmWrite);
    SaveToStream(fs);
    fs.Position:=0;
    Add(fs,RpDataName);
    Close;
    end;
  FreeAndNil(FZipFile);
  end;

{ ------------------------------------------------------------------- }
procedure TSheet.Clear;
begin
  FCharts.Clear;
  end;

procedure TSheet.ResetCharts;
var
  i : integer;
begin
  for i:=0 to ChartCount-1 do Chart[i].ResetItems;
  end;

procedure TSheet.SetSize (Value : TFloatSize);
begin
  FProperties.FSize:=Value;
  end;

procedure TSheet.SetMargin (Value : TFRect);
begin
  FProperties.FMargin:=Value;
  end;

{ ------------------------------------------------------------------- }
function TSheet.GetDefaultChartArea : TFloatArea;
var
  dx,dy,y : double;
  i     : integer;
begin
  with FProperties do begin
    with FMargin do begin
      dx:=Left+Right; dy:=Bottom+Top;
      end;
    if ChartCount=0 then Result:=FloatArea(0,0,FSize.Width-dx,FSize.Height-dy)
    else begin
      dy:=(FSize.Height-dy)/(ChartCount+1); y:=0;
      for i:=0 to ChartCount-1 do with Chart[i] do begin
        Area:=FloatArea(Area.Left,y,Area.Width,dy);;
        SetInnerArea;
        y:=y+dy;
        end;
      Result:=FloatArea(0,y,FSize.Width-dx,dy);
      end;
    end;
  end;

procedure TSheet.AdjustChartAreas;
var
  dy,y : double;
  i     : integer;
begin
  with FProperties do begin
    with FMargin do dy:=Bottom+Top;
    if ChartCount>0 then begin
      dy:=(FSize.Height-dy)/ChartCount; y:=0;
      for i:=0 to ChartCount-1 do with Chart[i] do begin
        Area:=FloatArea(Area.Left,y,Area.Width,dy);;
        SetInnerArea;
        y:=y+dy;
        end;
      end;
    end;
  end;

procedure TSheet.AdjustSize;
var
  x,y : double;
  i   : integer;
begin
  with FProperties do if ChartCount>0 then begin
    x:=0; y:=0;
    for i:=0 to ChartCount-1 do with Chart[i].Area do begin
      x:=x+Left+Width; y:=y+ Bottom+Height;
      end;
    with FSize do begin
      if x>Width then Width:=x;
      if y>Height then Height:=y;
      end;
    end;
  end;

function TSheet.GetChartCount : integer;
begin
  Result:=FCharts.Count;
  end;

function TSheet.GetChart(Index: Integer) : TChart;
begin
  if (Index<0) or (Index>=FCharts.Count) then Result:=nil
  else Result:=FCharts[Index] as TChart;
  end;

procedure TSheet.SetChart (AIndex : integer; ch : TChart);
begin
  if (AIndex>=0) or (AIndex<FCharts.Count) then FCharts[AIndex]:=ch;
  end;

function TSheet.AddChart : TChart;
begin
  Result:=TChart.CreateAsNew(self);
  Result.AddToList(FCharts);
  end;

function TSheet.AddChart (AArea : TFloatArea) : TChart;
begin
  Result:=TChart.Create(self,AArea);
  Result.AddToList(FCharts);
  end;

procedure TSheet.ExchangeCharts(AIndex1,AIndex2 : integer);
begin
  FCharts.Exchange(AIndex1,AIndex2);
  end;

procedure TSheet.DeleteChart (Index : integer);
begin
  FCharts.Delete(Index);
  AdjustChartAreas;
  end;

function TSheet.CreateID :  integer;
var
  i  : integer;
  ok : boolean;
begin
  Result:=0;
  repeat
    i:=0;
    while (i<ChartCount) and (Chart[i].ChartID<>Result) do inc(i);
    ok:=i>=ChartCount;
    if not ok then inc(Result);
    until ok;
  end;

{ ------------------------------------------------------------------- }
constructor TChart.Create (ASheet : TSheet; AArea : TFloatArea);
var
  it : TItemType;
begin
  inherited Create;
  FSheet:=ASheet;
  FItems:=TObjectList.Create;
  FItems.OwnsObjects:=true;
  if assigned(FSheet) then FID:=FSheet.CreateID else FID:=-1;
  FArea:=AArea;
  XChartSpace:=FSheet.Properties.FChartSpace;
  YChartSpace:=FSheet.Properties.FChartSpace;
  XAxisSpace:=FSheet.Properties.FAxisSpace;
  YAxisSpace:=FSheet.Properties.FAxisSpace;
  SetInnerArea;
  FBColor:=FSheet.Properties.FChartColor;
  with FBorder do begin
    Visible:=false;
    LnWidth:=FSheet.DefaultLineWidth;
    LColor:=FSheet.DefaultLineColor;
    LStyle:=lsSolid;
    end;
  FChartDesc:='';
  FUserClip:=false;
  FVisible:=true; FDeleted:=false;
  for it:=low(TItemType) to High(TItemType) do LastIndex[it]:=-1;
  end;

constructor TChart.CreateAsNew (ASheet : TSheet);
var
  a : TFloatArea;
begin
  if assigned(ASheet) then a:=ASheet.GetDefaultChartArea else a:=defChartArea;
  Create(ASheet,a);
  end;

constructor TChart.CreateFrom (AChart : TChart);
begin
  Create(AChart.ParentSheet,defChartArea);
  Assign(AChart,true);
  end;

destructor TChart.Destroy;
begin
  FItems.Free;
  end;

procedure TChart.Assign (AChart : TChart; WithArea : boolean);
var
  i  : integer;
  ci : TChartItem;
begin
  FChartDesc:=AChart.FChartDesc;
  FID:=FSheet.CreateID;
  if WithArea then FArea:=AChart.FArea;
  XChartSpace:=AChart.XChartSpace;
  YChartSpace:=AChart.YChartSpace;
  XAxisSpace:=AChart.XAxisSpace;
  YAxisSpace:=AChart.YAxisSpace;
  FBColor:=AChart.FBColor;
  FBorder:=AChart.FBorder;
  FUserClip:=AChart.FUserClip;
  FVisible:=AChart.FVisible;
  FDeleted:=AChart.Deleted;
  LastIndex:=AChart.LastIndex;
  for i:=0 to AChart.ItemCount-1 do begin
    case AChart.Item[i].ItemType of
    itAxis      : ci:=TAxisItem.CreateFrom(AChart.Item[i] as TAxisItem);
    itCurve     : ci:=TCurveItem.CreateFrom(AChart.Item[i] as TCurveItem);
    itFit       : ci:=TFitItem.CreateFrom(AChart.Item[i] as TFitItem);
    itGraph     : ci:=TGraphItem.CreateFrom(AChart.Item[i] as TGraphItem);
    itFunction  : ci:=TFunctionItem.CreateFrom(AChart.Item[i] as TFunctionItem);
    itText      : ci:=TTextItem.CreateFrom(AChart.Item[i] as TTextItem);
    itImage     : ci:=TImageItem.CreateFrom(AChart.Item[i] as TImageItem);
    itDrawing   : ci:=TDrawingItem.CreateFrom(AChart.Item[i] as TDrawingItem);
    else ci:=nil;
      end;
    if assigned(ci) then with ci do begin
      FChart:=self;
      AddToList(FItems);
      FID:=AChart.Item[i].ItemID;
      end;
    end;
  SetInnerArea;
  end;

procedure TChart.Clear;
begin
  FItems.Clear;
  end;

procedure TChart.ResetItems;
var
  i : integer;
begin
  for i:=0 to ItemCount-1 do Item[i].Reset;
  end;

{ ------------------------------------------------------------------- }
procedure TChart.SetInnerArea;
var
  i  : integer;
  dr : TFRect;

  procedure GetMin (var v : double; vc : double);
  begin
    if (vc<=0) and (vc<v) then v:=vc;
    end;

  procedure GetMax (var v : double; vc : double);
  begin
    if (vc>=0) and (vc>v) then v:=vc;
    end;

begin
  dr:=FloatRect(1,1,-1,-1);
  for i:=0 to FItems.Count-1 do if (Item[i].ItemType=itAxis) and not (Item[i].Deleted) then begin
    with Item[i] as TAxisItem,dr do begin
      if AxType=atHorz then begin
        if AxPos=apBottomLeft then GetMin(Bottom,AxOffset) else GetMax(Top,AxOffset);
        end
      else begin
        if AxPos=apBottomLeft then GetMin(Left,AxOffset) else GetMax(Right,AxOffset);
        end;
      end;
    end;
  with dr do begin
    if Left>0 then Left:=XChartSpace else Left:=-Left+XAxisSpace;
    if Bottom>0 then Bottom:=YChartSpace else Bottom:=-Bottom+YAxisSpace;
    if Right<0 then Right:=XChartSpace else Right:=Right+XAxisSpace;
    if Top<0 then Top:=YChartSpace else Top:=Top+YAxisSpace;
    end;
  with FInnerArea do begin
    Left:=FArea.Left+dr.Left; Bottom:=FArea.Bottom+dr.Bottom;
    Width:=FArea.Width-dr.Left-dr.Right;
    Height:=FArea.Height-dr.Bottom-dr.Top;
    end;
  end;

{ ------------------------------------------------------------------- }
function TChart.AddToList (AList : TObjectList) : integer;
begin
  FIndex:=AList.Add(self);
  Result:=FIndex;
  end;

// ermittle Offset für zusätzliche Achse links oder unten
function TChart.GetAxisOffset(AAxType : TAxisType) : TOffset;
var
  n1,n2 : integer;
begin
  n1:=GetAxisCount(AAxType,apBottomLeft);
  n2:=GetAxisCount(AAxType,apTopRight);
  if n1=0 then Result.BottomLeft:=0
  else begin
    if AAxType=atHorz then Result.BottomLeft:=-n1*YAxisSpace else Result.BottomLeft:=-n1*XAxisSpace;
    end;
  if n2=0 then Result.TopRight:=0
  else begin
    if AAxType=atHorz then Result.TopRight:=n2*YAxisSpace else Result.TopRight:=n2*XAxisSpace;
    end;
  end;

procedure TChart.SetAxesOffset (AAxType : TAxisType; Value : double);
var
  i,n1,n2 : integer;
begin
  n1:=0; n2:=0;
  for i:=0 to FItems.Count-1 do if (Item[i].ItemType=itAxis) then with Item[i] as TAxisItem do begin
    if (AxType=AAxType) then begin
      if (AxPos=apBottomLeft) then begin
        AxOffset:=-n1*Value; inc(n1);
        end
      else if (AxPos=apTopRight) then begin
        AxOffset:=n2*Value; inc(n2);
        end;
      end;
    end;
  end;

function TChart.GetAxisCount(AAxType : TAxisType; AAxPos : TAxPos) : integer;
var
  i : integer;
begin
  Result:=0;
  for i:=0 to FItems.Count-1 do begin
    if (Item[i].ItemType=itAxis) then with Item[i] as TAxisItem do
      if (AxType=AAxType) and ((AAxPos=apAll) or (AxPos=AAxPos)) then inc(Result);
    end;
  end;

function TChart.GetFirstAxisID (AAxType : TAxisType) : integer;
var
  i : integer;
begin
  i:=0;
  while (i<FItems.Count) and ((Item[i].ItemType<>itAxis) or ((Item[i] as TAxisItem).AxType<>AAxType)) do inc(i);
  if i=FItems.Count then Result:=0  // not found
  else Result:=Item[i].ItemID;
  end;

function TChart.GetItemOffset : TFPoint;
begin
  with Result do begin
    X:=FArea.Width/20; Y:=FArea.Height/20;
    end;
  end;

function TChart.GetCenterPos : TFPoint;
begin
  with FArea do begin
    Result.X:=Left+Width/2;
    Result.Y:=Bottom+Height/2;
    end;
  end;

function TChart.GetItemTypeCount (AItemType : TItemType) : integer;
var
  i : integer;
begin
  Result:=0;
  for i:=0 to FItems.Count-1 do begin
    if (Item[i].ItemType=AItemType) then inc(Result);
    end;
  end;

function TChart.GetFirstItemID (AItemType : TItemType) : integer;
var
  i : integer;
begin
  i:=0;
  while (i<FItems.Count) and (Item[i].ItemType<>AItemType) do inc(i);
  if i=FItems.Count then Result:=0  // not found
  else Result:=Item[i].ItemID;
  end;

function TChart.GetFirstItem (AItemType : TItemType) : TChartItem;
var
  i : integer;
begin
  i:=0;
  while (i<FItems.Count) and (Item[i].ItemType<>AItemType) do inc(i);
  if i=FItems.Count then begin
    Result:=nil;
    LastIndex[AItemType]:=-1;
    end
  else begin
    Result:=Item[i];
    LastIndex[AItemType]:=i;
    end;
  end;

function TChart.GetNextItem (AItemType : TItemType) : TChartItem;
var
  i : integer;
begin
  i:=LastIndex[AItemType]+1;
  while (i<FItems.Count) and (Item[i].ItemType<>AItemType) do inc(i);
  if i=FItems.Count then begin
    Result:=nil;
    LastIndex[AItemType]:=-1;
    end
  else begin
    Result:=Item[i];
    LastIndex[AItemType]:=i;
    end;
  end;

procedure TChart.ExchangeItems(AIndex1,AIndex2 : integer);
begin
  FItems.Exchange(AIndex1,AIndex2);
  end;

procedure TChart.DeleteItem (AIndex : integer);
var
  i : integer;
begin
  with FItems do if (AIndex>=0) and (AIndex<Count) then begin
    Delete(AIndex);
    for i:=AIndex to Count-1 do dec((Items[i] as TChartItem).FIndex);
    end;
  end;

function TChart.CreateID (AItemType : TItemType) : integer;
var
  i  : integer;
  ok : boolean;
begin
  Result:=$100*integer(AItemType);
  repeat
    i:=0;
    while (i<ItemCount) and (Item[i].ItemID<>Result) do inc(i);
    ok:=i>=ItemCount;
    if not ok then inc(Result);
    until ok;
  end;

function TChart.IndexOf (AID : integer) : integer;
var
  i  : integer;
begin
  i:=0;
  while (i<ItemCount) and (Item[i].ItemID<>AID) do inc(i);
  if i>=ItemCount then Result:=-1 else Result:=i;
  end;

function TChart.GetItemFromID (AID : integer) : TChartItem;
var
  n : integer;
begin
  n:=IndexOf(AID);
  if n>=0 then Result:=Item[n] else Result:=nil;
  end;

function TChart.IsInChart(APos : TFPoint) : boolean;
begin
  with FArea,APos do Result:=(x>=Left) and (x<=Left+Width) and
    (y>=Bottom) and (y<=Bottom+Height);
  end;

function TChart.AddNewItem (AItemType : TItemType) : TChartItem;
begin
  case AItemType of
  itAxis      : Result:=AddAxis(atHorz);
  itCurve     : Result:=AddCurve;
  itFit       : Result:=AddFit;
  itGraph     : Result:=AddGraph;
  itFunction  : Result:=AddFunction;
  itText      : Result:=AddText;
  itImage     : Result:=AddImage;
  itDrawing   : Result:=AddDrawing;
  else Result:=nil;
    end;
  end;

function TChart.AddItem (AItem : TChartItem) : integer;
begin
  Result:=AItem.AddToList(FItems);
  end;

function TChart.AddItemByName (const AItemName : string) : TChartItem;
var
  it : TItemType;
begin
  it:=itAxis;
  while (it<=High(TItemType)) and not AnsiSameStr(AItemName,ItemTypeNames[it]) do inc(it);
  if it<=High(TItemType) then Result:=AddNewItem(it) else Result:=nil;
  end;

function TChart.AddAxis (AAxType : TAxisType) : TAxisItem;
begin
  Result:=TAxisItem.Create(self,AAxType,FSheet.DefObjProps.AxisProps);
  Result.AddToList(FItems);
  end;

function TChart.AddCurve : TCurveItem;
begin
  Result:=TCurveItem.Create(self,FSheet.DefObjProps.CurveProps);
  Result.AddToList(FItems);
  end;

function TChart.AddFit : TFitItem;
begin
  Result:=TFitItem.Create(self,FSheet.DefObjProps.FitProps);
  Result.AddToList(FItems);
  end;

function TChart.AddGraph (gt : TGraphType) : TGraphItem;
begin
  Result:=TGraphItem.Create(self,FSheet.DefObjProps.CurveProps,gt);
  Result.AddToList(FItems);
  end;

function TChart.AddFunction : TFunctionItem;
begin
  Result:=TFunctionItem.Create(self,FSheet.DefObjProps.FunctionProps);
  Result.AddToList(FItems);
  end;

function TChart.AddText (tt : TTextType) : TTextItem;
begin
  Result:=TTextItem.Create(self,FSheet.DefObjProps.PlotFont,tt);
  Result.AddToList(FItems);
  end;

function TChart.AddImage : TImageItem;
begin
  Result:=TImageItem.Create(self);
  Result.AddToList(FItems);
  end;

function TChart.AddDrawing (dt : TDrawingType) : TDrawingItem;
begin
  Result:=TDrawingItem.Create(self,FSheet.DefObjProps.DrawingProps,dt);
  Result.AddToList(FItems);
  end;

function TChart.GetChartDesc : string;
begin
  if length(FChartDesc)=0 then Result:=_('Chart')+' '+IntToStr((FID and $FF)+1)
  else Result:=FChartDesc;
  end;

procedure TChart.UpdateFits (AItemID : integer);
var
  i : integer;
begin
  for i:=0 to ItemCount-1 do with Item[i] do
    if (ItemType=itFit) and (ItemID=AItemID) then (Item[i] as TFitItem).FitData.Computed:=false;
  end;

function TChart.GetChartItemCount : integer;
begin
  Result:=FItems.Count;
  end;

function TChart.GetChartItem (AIndex : integer) : TChartItem;
begin
  if (AIndex<0) or (AIndex>=FItems.Count) then Result:=nil
  else Result:=FItems[AIndex] as TChartItem;
  end;

function TChart.ScaleFromID (AxID : integer; Value : double) : double;
var
  n : integer;
begin
  n:=IndexOf(AxID);
  if (n>=0) and (FItems[n] is TAxisItem) then Result:=(Item[n] as TAxisItem).Scale(Value)
  else Result:=0;
  end;

// AxNdx muss auf eine Achse zeigen (z.B. über IndexOf ermittelt)
function TChart.Scale (AxNdx : integer; Value : double) : double;
begin
  if (AxNdx>=0) then Result:=(Item[AxNdx] as TAxisItem).Scale(Value)
  else Result:=0;
  end;

procedure TChart.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
  i,n   : integer;
  s     : string;
  ci    : TChartItem;
begin
  Clear;
  FID:=XMLReadInteger(XmlNode,iniID,FID);
  FChartDesc:=XMLReadString(XmlNode,iniDesc,'');
  Visible:=XMLReadBool(XmlNode,iniShow,Visible);
  StrToArea(XMLReadString(XmlNode,iniArea,''),ValDelim,FArea);
  n:=XMLReadInteger(Xmlnode,iniChSpace,0);       // for compatibility
  if n=0 then n:=round(100*XChartSpace);
  XChartSpace:=XMLReadInteger(Xmlnode,iniXChSpace,n)/100;
  YChartSpace:=XMLReadInteger(Xmlnode,iniYChSpace,round(100*YChartSpace))/100;
  XAxisSpace:=XMLReadInteger(Xmlnode,iniXAxSpace,round(100*XAxisSpace))/100;
  YAxisSpace:=XMLReadInteger(Xmlnode,iniYAxSpace,round(100*YAxisSpace))/100;
  FBColor:=XMLReadInteger(Xmlnode,iniBakCol,FBColor);
  with FBorder do begin
    Visible:=XMLReadBool(XmlNode,iniBorder,Visible);
    LnWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LnWidth))/100;
    LColor:=XMLReadInteger(Xmlnode,iniLnCol,LColor);
    LStyle:=TLineStyle(XMLReadInteger(XmlNode,iniLnStyle,integer(LStyle)));
    end;
  n:=XMLReadInteger(XmlNode,iniCount,0);  // number of items
  for i:=0 to n-1 do begin
    lnode:=XMLReadNode(XmlNode,ItemSekt+ZStrint(i,3));
    s:=XMLReadString(lNode,iniType,'');
    ci:=AddItemByName(s);
    if assigned(ci) then ci.LoadData(lnode,DataOptions);
    end;
  SetInnerArea;
  end;

procedure TChart.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
  i,n   : integer;
begin
  XMLWriteVariant(XmlNode,iniID,'$'+IntToHex(FID,2));
  XMLWriteVariant(XmlNode,iniDesc,FChartDesc);
  XMLWriteVariant(XmlNode,iniShow,Visible);
  with FArea do XMLWriteVariant(XmlNode,iniArea,DimensionsToStr([Left,Bottom,Width,Height],ValDelim));
  XMLWriteVariant(Xmlnode,iniXChSpace,round(100*XChartSpace));
  XMLWriteVariant(Xmlnode,iniYChSpace,round(100*YChartSpace));
  XMLWriteVariant(Xmlnode,iniXAxSpace,round(100*XAxisSpace));
  XMLWriteVariant(Xmlnode,iniYAxSpace,round(100*YAxisSpace));
  XMLWriteVariant(Xmlnode,iniBakCol,FBColor);
  with FBorder do begin
    XMLWriteVariant(XmlNode,iniBorder,Visible);
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LnWidth));
    XMLWriteVariant(Xmlnode,iniLnCol,LColor);
    XMLWriteVariant(XmlNode,iniLnStyle,integer(LStyle));
    end;
  n:=0;
  for i:=0 to FItems.Count-1 do with Item[i] do if not Deleted then inc(n);
  XMLWriteVariant(XmlNode,iniCount,n);  // number of items
  n:=0;
  for i:=0 to FItems.Count-1 do with Item[i] do if not Deleted then begin
    lnode:=XMLNewNode(XmlNode,ItemSekt+ZStrint(n,3));
    inc(n);
    XMLWriteVariant(lNode,iniType,ItemTypeNames[ItemType]);
    Item[i].SaveData(lnode,DataOptions);
    end;
  end;

procedure TChart.LoadTemplate (const AName,Id : string);
var
  fs        : TFileStream;
  XDoc      : TXMLDocument;
  lnode     : IXMLNode;
begin
  if FileExists(AName) then begin
    fs:=TFileStream.Create(aName,fmOpenRead);
    XDoc:=TXMLDocument.Create(Application);
    with XDoc do begin
      LoadFromStream(fs);
      fs.Free;
      if AnsiSameText(Id,DocumentElement.NodeName) then begin
        lnode:=XMLReadNode(DocumentElement,ChartSekt);
        if assigned(lnode) then LoadData(lnode,[doChart]);
        end
      else ErrorDialog(TryFormat(_('Invalid template file: %s'),[AName]));
      Free;
      end;
    end;
  end;

procedure TChart.SaveTemplate (const AName,Id : string);
var
  fs        : TFileStream;
  XDoc      : TXMLDocument;
begin
  fs:=TFileStream.Create(AName,fmCreate);
  XDoc:=TXMLDocument.Create(nil);
  with XDoc do begin
    Options:=[doNodeAutoCreate,doNodeAutoIndent];
    Active:=true;
    Version:='1.0';
    Encoding:='ISO-8859-1';
    DocumentElement:=CreateElement(Id,'');
    SaveData(XMLNewNode(DocumentElement,ChartSekt),[doChart]);
    SaveToStream(fs);
    Free;
    end;
  fs.Free;
  end;

{ ------------------------------------------------------------------- }
constructor TChartItem.Create (AItemType : TItemType; AChart : TChart);
begin
  inherited Create;
  FChart:=AChart;
  FItemType:=AItemType;
  FDesc:='';
  if assigned(FChart) then FID:=FChart.CreateID(AItemType) else FID:=-1;
  FVisible:=true; FDeleted:=false;
  FOutLine:=FloatRect(0,0,2,2);
  end;

procedure TChartItem.Assign (AChartItem : TChartItem);
begin
  FDesc:=AChartItem.FDesc;
  FVisible:=AChartItem.FVisible;
  FDeleted:=AChartItem.Deleted;
  end;

function TChartItem.GetStatus : boolean;
begin
  Result:=length(FDesc)=0;      // true before first call of GetDesc
  end;

function TChartItem.GetDesc : string;
begin
  if length(FDesc)=0 then Result:=_('Chart object')+' '+IntToStr(FIndex+1)
  else Result:=FDesc;
  end;

function TChartItem.GetTypeName: string;
begin
  Result:='['+ItemTypeNames[FItemType]+'] ';
  end;

function TChartItem.GetDecSep : Char;
begin
  Result:=FChart.FSheet.DecimalSeparator;
  end;

function TChartItem.AddToList (AList : TObjectList) : integer;
begin
  FIndex:=AList.Add(self);
  Result:=FIndex;
  end;

procedure TChartItem.Reset;    // virtual
begin
  end;

function TChartItem.IsInItem (APos : TFPoint) : boolean;
begin
  Result:=IsInRect(APos,OutLine);
  end;

function TChartItem.HitsItem (APos : TFPoint; Delta : double) : TItemAction;
begin
  if IsInItem(APos) then begin
    if (FItemType=itText) or (FItemType=itImage) then Result:=iaMoveBox
    else Result:=iaFixed
    end
  else result:=iaNone;
  end;

procedure TChartItem.MovePos (Offset : TFPoint);
begin
  end;

procedure TChartItem.MoveStart (Offset : TFPoint);
begin
  end;

procedure TChartItem.MoveEnd (Offset : TFPoint);
begin
  end;

procedure TChartItem.MoveStartEnd (Offset : TFPoint);
begin
  end;

procedure TChartItem.MoveEndStart (Offset : TFPoint);
begin
  end;

function TChartItem.GetIsMoveable : boolean;  // Return true if is moveable object
begin
  Result:=(FItemType=itText) or (FItemType=itImage) or (FItemType=itDrawing);
  end;

function TChartItem.GetOutline : TFRect;
begin
  Result:=FChart.InnerArea.AsFRect;
//  Result:=MoveRect(FloatRect(0,0,5,5),GetOrigin(FChart.FArea));
  end;

procedure TChartItem.SetOutLine (Value : TFRect);
begin
  FOutline:=Value;
  end;

procedure TChartItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  FID:=XMLReadInteger(XmlNode,iniID,FID);
  if doChart in DataOptions then begin
    Description:=XMLReadString(XmlNode,iniDesc,'');
    Visible:=XMLReadBool(XmlNode,iniShow,Visible);
    end;
  end;

procedure TChartItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  XMLWriteVariant(XmlNode,iniID,'$'+IntToHex(FID,4));
  if doChart in DataOptions then begin
    XMLWriteVariant(XmlNode,iniDesc,Description);
    XMLWriteVariant(XmlNode,iniShow,Visible);
    end;
  end;

procedure TChartItem.LoadTemplate (const AName,Id,Section : string);
var
  fs        : TFileStream;
  XDoc      : TXMLDocument;
  lnode     : IXMLNode;
begin
  if FileExists(AName) then begin
    fs:=TFileStream.Create(aName,fmOpenRead);
    try
      XDoc:=TXMLDocument.Create(Application);
      with XDoc do begin
        LoadFromStream(fs);
        if AnsiSameText(Id,DocumentElement.NodeName) then begin
          lnode:=XMLReadNode(DocumentElement,Section);
          if assigned(lnode) then LoadData(lnode,[]);
          end
        else ErrorDialog(TryFormat(_('Invalid template file: %s'),[AName]));
        Free;
        end;
    finally
      fs.Free;
      end;
    end;
  end;

procedure TChartItem.SaveTemplate (const AName,Id,Section : string);
var
  fs        : TFileStream;
  XDoc      : TXMLDocument;
begin
  fs:=TFileStream.Create(AName,fmCreate);
  XDoc:=TXMLDocument.Create(nil);
  with XDoc do begin
    Options:=[doNodeAutoCreate,doNodeAutoIndent];
    Active:=true;
    Version:='1.0';
    Encoding:='ISO-8859-1';
    DocumentElement:=CreateElement(Id,'');
    SaveData(XMLNewNode(DocumentElement,Section),[]);
    SaveToStream(fs);
    Free;
    end;
  fs.Free;
  end;

function TChartItem.DataToStr (ADataCols : TDataCols; Data : TData) : string;
begin
  with Data do begin
    if dcValX in ADataCols then begin
      Result:=FloatToString(Val.X,ffGeneral,6,0);
      if dcErrSX in ADataCols then   // symm. X error
        Result:=Result+ValDelim+FloatToString(PErr.X,ffGeneral,6,0)
      else if dcErrAX in ADataCols then   // asymm. X error
        Result:=Result+ValDelim+FloatToString(PErr.X,ffGeneral,6,0)+ValDelim
               +FloatToString(MErr.X,ffGeneral,6,0);
      end
    else if dcTime in ADataCols then Result:=FormatDateTime('yyyy-mm-dd_hh:nn:ss',Val.X)
    else Result:='';
    if dcValY in ADataCols then begin
      if length(Result)>0 then Result:=Result+ValDelim;
      Result:=Result+FloatToString(Val.Y,ffGeneral,6,0);
      if dcErrSY in ADataCols then  // symm. Y error
        Result:=Result+ValDelim+FloatToString(PErr.Y,ffGeneral,6,0)
      else if dcErrAY in ADataCols then  // asymm. Y error
        Result:=Result+ValDelim+FloatToString(PErr.Y,ffGeneral,6,0)+ValDelim+FloatToString(MErr.Y,ffGeneral,6,0);
      end;
    end;
  end;

function TChartItem.StrToData (ADataCols : TDataCols; s : string) : TData;
begin
  with Result do begin
    Val.X:=0; PErr.X:=0; MErr.X:=0;
    Val.Y:=0; PErr.Y:=0; MErr.Y:=0;
    if dcValX in ADataCols then begin
      Val.X:=ReadNextFloat(s,ValDelim,0);
      if dcErrSX in ADataCols then begin  // symm. X error
        PErr.X:=ReadNextFloat(s,ValDelim,0); MErr.X:=PErr.X;
        end
      else if dcErrAX in ADataCols then begin  // asymm. X error
        PErr.X:=ReadNextFloat(s,ValDelim,0); MErr.X:=ReadNextFloat(s,ValDelim,0);
        end;
      end
    else if dcTime in ADataCols then Val.X:=ReadNxtDateTime(s,ValDelim,Now,':');
    if dcValY in ADataCols then begin
      Val.Y:=ReadNextFloat(s,ValDelim,0);
      if dcErrSY in ADataCols then begin // symm. Y error
        PErr.Y:=ReadNextFloat(s,ValDelim,0); MErr.Y:=PErr.Y;
        end
      else if dcErrAY in ADataCols then begin // asymm. Y error
        PErr.Y:=ReadNextFloat(s,ValDelim,0); MErr.Y:=ReadNextFloat(s,ValDelim,0);
        end;
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
constructor TAxisItem.Create (AChart : TChart; AAxType : TAxisType; AProps : TAxisProperties);
begin
  inherited Create(itAxis,AChart);
  AxType:=AAxType;            // horizontal
  MinVal:=0; MaxVal:=10;      // Bereich in Benutzereinheiten
  GridWidth:=2; GridTicks:=10; // Skala
  AxPos:=apBottomLeft;        // Position links/unten, rechts/oben oder benutzerdefiniert
  AxOffset:=0;                // Offset der Achse in cm/inch rel zu Rand
  ScaleType:=stLin;           // Skalierung
  Caption:='';                // Legendentext
  Labels:=TStringList.Create; // benutzerdef. Beschriftung
  if AxType=atHorz then FSpace:=ParentChart.YAxisSpace else FSpace:=ParentChart.XAxisSpace;
  Properties:=AProps;
  end;

constructor TAxisItem.CreateFrom (AAxis : TAxisItem);
begin
  Create(AAxis.ParentChart,AAxis.AxType,AAxis.Properties);
  Assign(AAxis);
  end;

destructor TAxisItem.Destroy;
begin
  Labels.Free;
  inherited Destroy;
  end;

procedure TAxisItem.Assign (AAxis : TAxisItem);
begin
  inherited Assign (AAxis);
  MinVal:=AAxis.MinVal;
  MaxVal:=AAxis.MaxVal;       // Bereich in Benutzereinheiten
  GridWidth:=AAxis.GridWidth;
  GridTicks:=AAxis.GridTicks; // Skala
  AxPos:=AAxis.AxPos;         // Position links/unten, rechts/oben oder benutzerdefiniert
  AxOffset:=AAxis.AxOffset;   // benutzerdefinierte Position in cm/inch
  ScaleType:=AAxis.ScaleType; // Skalierung
  Caption:=AAxis.Caption;     // Legendentext
  AUnit:=AAxis.AUnit;
  if assigned(AAxis.Labels) then Labels.Assign(AAxis.Labels);
  Properties:=AAxis.Properties;
  end;

function TAxisItem.GetDesc : string;
begin
  if length(FDesc)=0 then Result:=_('Axis')+' '+IntToStr((FID and $FF)+1)
  else Result:=inherited;
  end;

function TAxisItem.GetAxPos : double;
begin
  with FChart.InnerArea do if AxType=atVert then begin
    if AxPos=apBottomLeft then Result:=AxOffset+Left
    else Result:=AxOffset+Left+Width;
    end
  else begin
    if AxPos=apBottomLeft then Result:=AxOffset+Bottom
    else Result:=AxOffset+Bottom+Height;
    end
  end;

function TAxisItem.GetOutline : TFRect;
var
  xp,xd   : double;
  ATR,MSW : boolean;
begin
  ATR:=AxPos=apTopRight;
  with Properties do begin
    MSW:=asMirror in AxStyles;
    xd:=LabDist+LabFont.FontSize;
    end;
  if AxType=atHorz then begin
    with FChart.InnerArea do begin
      Result.Left:=Left; Result.Right:=Left+Width;
      end;
    xp:=AxisPosition;
    if ATR then begin // oben
      if MSW then xd:=-xd;
      end
    else begin // unten
      if not MSW then xd:=-xd;
      end;
    with Result do if xd<0 then begin
      Bottom:=xp+xd; Top:=xp;
      end
    else begin
      Bottom:=xp; Top:=xp+xd;
      end;
    end
  else begin
    with FChart.InnerArea do begin
      Result.Bottom:=Bottom; Result.Top:=Bottom+Height;
      end;
    xp:=AxisPosition;
    if ATR then begin // rechts
      if MSW then xd:=-xd;
      end
    else begin // links
      if not MSW then xd:=-xd;
      end;
    with Result do if xd<0 then begin
      Left:=xp+xd; Right:=xp;
      end
    else begin
      Left:=xp; Right:=xp+xd;
      end;
    end;
  end;

(* ------------------------------------------------------------------------ *)
procedure TAxisItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  s   : string;
  i,n : integer;
  lNode : IXMLNode;
begin
  inherited LoadData (XmlNode,DataOptions);
  // benutzt Punkt als Dezimaltrenner
  MinVal:=StringToFloat(XMLReadString(XmlNode,iniMin,''),MinVal);
  MaxVal:=StringToFloat(XMLReadString(XmlNode,iniMax,''),MaxVal);
  GridWidth:=StringToFloat(XMLReadString(XmlNode,iniGrid,''),GetGrid);
  GridTicks:=XMLReadInteger(XmlNode,iniTicks,5);
  AxPos:=TAxPos(XMLReadInteger(XmlNode,iniPos,integer(AxPos)));
  s:=XMLReadString(XmlNode,iniAxPos,'');
  if (length(s)>0) and TryStrToInt(s,n) then AxOffset:=n/100 else AxOffset:=0.0;
  ScaleType:=TScaleType(XMLReadInteger(XmlNode,iniAxScale,integer(ScaleType)));
  AxType:=TAxisType(XMLReadInteger(XmlNode,iniAxType,integer(AxType)));
  Caption:=XMLReadString(XmlNode,iniCap,'');
  AUnit:=XMLReadString(XmlNode,iniUnit,'');
  with Labels do begin
    lnode:=XMLReadNode(XmlNode,iniLabels);
    if assigned(lnode) then begin
      n:=lnode.ChildNodes.Count;
      for i:=0 to n-1 do Add(XMLReadChildString(lnode,i,''));
      end;
    end;
  with Properties do begin
    lnode:=XMLReadNode(XmlNode,iniCapFont);
    with CapFont do if assigned(lnode) then begin
      FontName:=XMLReadString(lNode,iniName,FontName);
      FontSize:=XMLReadInteger(lNode,iniSize,round(100*FontSize))/100;
      FontAngle:=XMLReadInteger(lNode,iniAngle,FontAngle);
      FontStyle:=[];
      if XMLReadBool(lnode,iniBold,fsBold in FontStyle) then include(FontStyle,fsBold);
      if XMLReadBool(lnode,iniItalic,fsItalic in FontStyle) then include(FontStyle,fsItalic);
      FontColor:=XMLReadInteger(lNode,iniColor,FontColor);
      FontType:=TFontType(XMLReadInteger(lNode,iniType,integer(FontType)));
      end;
    CapDist:=XMLReadInteger(XmlNode,iniCapDist,round(100*CapDist))/100;
    CapPos:=XMLReadInteger(XmlNode,iniCapPos,CapPos);
    LabPos:=XMLReadInteger(XmlNode,iniLabPos,LabPos);
    ShowLabels:=XMLReadBool(XmlNode,iniLShow,ShowLabels);
    Precision:=XMLReadInteger(XmlNode,iniPrec,Precision);
    Notation:=TNotation(XMLReadInteger(XmlNode,iniNotate,integer(Notation)));
    DateFormat:=XMLReadString(XmlNode,iniDatForm,DateFormat);
    LnColor:=XMLReadInteger(XmlNode,iniLnCol,LnColor);
    lnode:=XMLReadNode(XmlNode,iniLabFont);
    with LabFont do if assigned(lnode) then begin
      FontName:=XMLReadString(lNode,iniName,FontName);
      FontSize:=XMLReadInteger(lNode,iniSize,round(100*FontSize))/100;
      FontAngle:=XMLReadInteger(lNode,iniAngle,FontAngle);
      FontStyle:=[];
      if XMLReadBool(lnode,iniBold,fsBold in FontStyle) then include(FontStyle,fsBold);
      if XMLReadBool(lnode,iniItalic,fsItalic in FontStyle) then include(FontStyle,fsItalic);
      FontColor:=XMLReadInteger(lNode,iniColor,FontColor);
      FontType:=TFontType(XMLReadInteger(lNode,iniType,integer(FontType)));
      end;
    LabDist:=XMLReadInteger(XmlNode,iniLabDist,round(100*LabDist))/100;
    LnWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LnWidth))/100;
    GrWidth:=XMLReadInteger(XmlNode,iniGrWidth,round(100*GrWidth))/100;
    IvWidth:=XMLReadInteger(XmlNode,iniIvWidth,round(100*IvWidth))/100;
    TmWidth:=XMLReadInteger(XmlNode,iniTmWidth,round(100*TmWidth))/100;
    CTmSize:=XMLReadInteger(XmlNode,iniCTmSize,round(100*CTmSize))/100;
    FTmSize:=XMLReadInteger(XmlNode,iniFTmSize,round(100*FTmSize))/100;
    TmStyle:=TTickMarks(XMLReadInteger(XmlNode,iniTmStyle,integer(TmStyle)));
    GrStyle:=TLineStyle(XMLReadInteger(XmlNode,iniGrStyle,integer(GrStyle)));
    HexToSet(XMLReadString(XmlNode,iniAxStyles,
      SetToHex(@AxStyles,integer(Low(TAxisStyle)),integer(High(TAxisStyle)))),@AxStyles);
    end;
  end;

procedure TAxisItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lNode : IXMLNode;
  i     : integer;
begin
  inherited SaveData (XmlNode,DataOptions);
  // benutze Punkt als Dezimaltrenner
  XMLWriteVariant(XmlNode,iniMin,FloatToString(MinVal,ffGeneral,6,1));
  XMLWriteVariant(XmlNode,iniMax,FloatToString(MaxVal,ffGeneral,6,1));
  XMLWriteVariant(XmlNode,iniGrid,FloatToString(GridWidth,ffGeneral,6,1));
  XMLWriteVariant(XmlNode,iniTicks,GridTicks);
  XMLWriteVariant(XmlNode,iniPos,integer(AxPos));
  XMLWriteVariant(XmlNode,iniAxPos,round(100*AxOffset));
  XMLWriteVariant(XmlNode,iniAxScale,integer(ScaleType));
  XMLWriteVariant(XmlNode,iniAxType,integer(AxType));
  XMLWriteVariant(XmlNode,iniCap,Caption);
  XMLWriteVariant(XmlNode,iniUnit,AUnit);
  with Labels do if Count>0 then begin
    lnode:=XMLNewNode(XmlNode,iniLabels);
    for i:=0 to Count-1 do XMLWriteVariant(lNode,iniLab,Strings[i]);
    end;
  with Properties do begin
    lnode:=XMLNewNode(XmlNode,iniCapFont);
    with CapFont do begin
      XMLWriteVariant(lNode,iniName,FontName);
      XMLWriteVariant(lNode,iniSize,round(100*FontSize));
      XMLWriteVariant(lNode,iniAngle,FontAngle);
      XMLWriteVariant(lNode,iniBold,fsbold in FontStyle);
      XMLWriteVariant(lNode,iniItalic,fsItalic in FontStyle);
      XMLWriteVariant(lNode,iniColor,FontColor);
      XMLWriteVariant(lNode,iniType,integer(FontType));
      end;
    XMLWriteVariant(XmlNode,iniCapDist,round(100*CapDist));
    XMLWriteVariant(XmlNode,iniCapPos,CapPos);
    XMLWriteVariant(XmlNode,iniLabPos,LabPos);
    XMLWriteVariant(XmlNode,iniLShow,ShowLabels);
    XMLWriteVariant(XmlNode,iniPrec,Precision);
    XMLWriteVariant(XmlNode,iniNotate,integer(Notation));
    XMLWriteVariant(XmlNode,iniDatForm,DateFormat);
    XMLWriteVariant(XmlNode,iniLnCol,LnColor);
    lnode:=XMLNewNode(XmlNode,iniLabFont);
    with LabFont do begin
      XMLWriteVariant(lNode,iniName,FontName);
      XMLWriteVariant(lNode,iniSize,round(100*FontSize));
      XMLWriteVariant(lNode,iniAngle,FontAngle);
      XMLWriteVariant(lNode,iniBold,fsbold in FontStyle);
      XMLWriteVariant(lNode,iniItalic,fsItalic in FontStyle);
      XMLWriteVariant(lNode,iniColor,FontColor);
      XMLWriteVariant(lNode,iniType,integer(FontType));
      end;
    XMLWriteVariant(XmlNode,iniLabDist,round(100*LabDist));
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LnWidth));
    XMLWriteVariant(XmlNode,iniGrWidth,round(100*GrWidth));
    XMLWriteVariant(XmlNode,iniIvWidth,round(100*IvWidth));
    XMLWriteVariant(XmlNode,iniTmWidth,round(100*TmWidth));
    XMLWriteVariant(XmlNode,iniCTmSize,round(100*CTmSize));
    XMLWriteVariant(XmlNode,iniFTmSize,round(100*FTmSize));
    XMLWriteVariant(XmlNode,iniTmStyle,integer(TmStyle));
    XMLWriteVariant(XmlNode,iniGrStyle,integer(GrStyle));
    XMLWriteVariant(XmlNode,iniAxStyles,SetToHex(@AxStyles,integer(Low(TAxisStyle)),integer(High(TAxisStyle))));
    end;
  end;

(* ------------------------------------------------------------------------ *)
(* Berechnung des groben Rasters einer Skala (nur lin.)*)
function TAxisItem.GetGrid : double;
(* AxNr =   Nummer der Achse (1 -4 = hor., 5 - 8 = vert.)
   GetGrid = Rasterabstand in der Abstufung 1, 2, 5
             zu dem mit DefScale vorgebenen Bereich
   Bsp.:     Bereich von -1 bis 10 ==> GRaster = 2 *)
var
  xa,xb,dec        : double;
begin
  xa:=MaxVal-MinVal;
  if IsZero(xa) then Result:=1
  else begin
    dec:=pwr(10.0,aint(lg(abs(xa))-0.05)); xa:=xa/dec;
    if xa<=2.1 then xb:=0.5 else
    if xa<=5.1 then xb:=1.0 else xb:=2.0;
    Result:=xb*dec;
    end
  end;

(* Berechnung der feinen Unterteilung einer Skala *)
function TAxisItem.GetFGrid (Grid  : double) : integer;
(* Grid     =  grobe Skalierung (s.o.)
   GetFGrid = Anzahl der Unterteilungen einer Grobskala *)
var
  xa   : double;
begin
  with ParentChart.InnerArea do if AxType=atHorz then xa:=Width else xa:=Height;
  xa:=xa/(MaxVal-MinVal)*Grid; (* ein Raster in cm/inch *)
  xa:=xa/Properties.FTmSize;
  if xa<=8 then Result:=2 else
  if xa<=15 then Result:=5 else Result:=10;
  end;

// Bereichsgrenzen auf Ticks setzen
procedure TAxisItem.AlignLimits;
var
  dx : double;
begin
  with Properties do dx:=GridWidth/GridTicks;
  MinVal:=AInt(MinVal/dx)*dx;
  MaxVal:=(AInt(MaxVal/dx)+1)*dx;
  end;

procedure TAxisItem.InitScale (AField : TFRect);
begin
  with AField do if AxType=atVert then begin
    FFactor:=Top-Bottom; FOffset:=Bottom;
    end
  else begin
    FFactor:=Right-Left; FOffset:=Left;
    end;
  if ScaleType=stTime then begin // Zeit
     if MaxVal<=MinVal then MaxVal:=MinVal+1/24.0;
     FFactor:=FFactor/(MaxVal-MinVal); FOffset:=FOffset-FFactor*MinVal;
    end
  else if ScaleType=stLog then begin
    if Minval<0 then MinVal:=1;
    FFactor:=FFactor/lg(MaxVal/MinVal); FOffset:=FOffset-FFactor*lg(MinVal);
    end
  else if ScaleType=stInv then begin // invers
    FFactor:=FFactor/(1/MaxVal-1/MinVal); FOffset:=FOffset-FFactor/MinVal;
    end
  else begin
    FFactor:=FFactor/(MaxVal-MinVal); FOffset:=FOffset-FFactor*MinVal;
    end;
  end;

// Skalieren: Benutzerkoord. <==> cm/inch
function TAxisItem.Scale (Val : double) : double;
begin
  try
    if ScaleType=stLog then begin
      if Val<=0 then Val:=MinSingle;
      try
        Result:=FFactor*lg(Val)+FOffset;
      except
        Result:=FOffset;
        end;
      end
    else if ScaleType=stInv then Result:=FFactor/Val+FOffset
    else Result:=FFactor*Val+FOffset;
  except
    Result:=FOffset;
    end;
  end;

function TAxisItem.InvUserScale (Val   : double) : double;
begin
  if ScaleType=stLog then Result:=Pwr(10.0,(Val-FOffset)/FFactor)
  else if ScaleType=stInv then Result:=FFactor/(Val-FOffset)
  else Result:=(Val-FOffset)/FFactor
  end;

{ ------------------------------------------------------------------- }
// Object: TCurveItem - Darstellung voon Messdaten als Kurve
constructor TCurveItem.Create (AChart : TChart; AProps : TCurveProperties);
begin
  inherited Create(itCurve,AChart);
  XAxID:=-1; YAxID:=-1;
  Properties:=AProps;
  SplineData.Computed:=false; HitData.Available:=false;
  with DataTable do begin
    Count:=0; Data:=nil; DataCols:=[dcValX,dcValY];
    end;
  end;

constructor TCurveItem.CreateFrom (ACurve : TCurveItem);
begin
  inherited Create(itCurve,ACurve.ParentChart);
  Assign(ACurve);
  end;

procedure TCurveItem.Assign (ACurve : TCurveItem);
begin
  inherited Assign (ACurve);
  XAxID:=ACurve.XAxID;
  YAxID:=ACurve.YAxID;
  Properties:=ACurve.Properties;
  DataTable:=ACurve.DataTable;
  SplineData.Computed:=false; HitData.Available:=false;
  end;

function TCurveItem.GetDesc : string;
begin
  if length(FDesc)=0 then Result:=_('Data curve')+' '+IntToStr((FID and $FF)+1)
  else Result:=inherited;
  end;

function TCurveItem.GetOutline : TFRect;
begin
  Result:=FOutline;
//  Result:=inherited;
  end;

procedure TCurveItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
  i     : integer;
begin
  inherited LoadData (XmlNode,DataOptions);
  if doChart in DataOptions then begin
    XAxID:=XMLReadInteger(XmlNode,iniXAxis,XAxID);
    YAxID:=XMLReadInteger(XmlNode,iniYAxis,YAxID);
    end;
  with DataTable do begin
    Count:=0; Data:=nil; DataCols:=[dcValX,dcValY];
    end;
  if doData in DataOptions then begin
    lnode:=XMLReadNode(XmlNode,iniData);
    with DataTable do if assigned(lnode) then begin
      HexToSet(XMLReadString(XmlNode,iniColumns,
        SetToHex(@DataCols,integer(Low(TDataCol)),integer(High(TDataCol)))),@DataCols);
//      DataCols:=DataCols+[dcValX,dcValY];
      Count:=lnode.ChildNodes.Count;
      SetLength(Data,Count);
      for i:=0 to Count-1 do Data[i]:=StrToData(DataCols,XMLReadChildString(lnode,i,''));
      end;
    end;
  with Properties do begin
    SymType:=TSymbolType(XMLReadInteger(XmlNode,iniSymStyle,integer(SymType)));
    SymSize:=XMLReadInteger(XmlNode,iniSymSize,round(100*SymSize))/100;
    MColor:=XMLReadInteger(XmlNode,iniSymCol,MColor);
    JoinMode:=TJoinMode(XMLReadInteger(XmlNode,iniJoin,integer(JoinMode)));
    HexToSet(XMLReadString(XmlNode,iniErrBar,
      SetToHex(@ErrorBars,integer(Low(TErrorBar)),integer(High(TErrorBar)))),@ErrorBars);
    SmoothFactor:=XMLReadInteger(XmlNode,iniSpSmooth,SmoothFactor);
    LStyle:=TLineStyle(XMLReadInteger(XmlNode,iniLnStyle,integer(LStyle)));
    LWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LWidth))/100;
    EWidth:=XMLReadInteger(XmlNode,iniEbWidth,round(100*EWidth))/100;
    LColor:=XMLReadInteger(XmlNode,iniLnCol,LColor);
    EColor:=XMLReadInteger(XmlNode,iniEbCol,EColor);
    end;
  SplineData.Computed:=false; HitData.Available:=false;
  end;

procedure TCurveItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
  i     : integer;
begin
  inherited SaveData (XmlNode,DataOptions);
  if doChart in DataOptions then begin
    XMLWriteVariant(XmlNode,iniXAxis,'$'+IntToHex(XAxID,4));
    XMLWriteVariant(XmlNode,iniYAxis,'$'+IntToHex(YAxID,4));
    end;
  if doData in DataOptions then begin
    lnode:=XMLNewNode(XmlNode,iniData);
    with DataTable do begin
      XMLWriteVariant(XmlNode,iniColumns,SetToHex(@DataCols,integer(Low(TDataCol)),integer(High(TDataCol))));
      for i:=0 to Count-1 do XMLWriteVariant(lnode,iniVal,DataToStr(DataCols,Data[i]));
      end;
    end;
  with Properties do begin
    XMLWriteVariant(XmlNode,iniSymStyle,integer(SymType));
    XMLWriteVariant(XmlNode,iniSymSize,round(100*SymSize));
    XMLWriteVariant(XmlNode,iniSymCol,MColor);
    XMLWriteVariant(XmlNode,iniJoin,integer(JoinMode));
    XMLWriteVariant(XmlNode,iniErrBar,SetToHex(@ErrorBars,integer(Low(TErrorBar)),integer(High(TErrorBar))));
    XMLWriteVariant(XmlNode,iniSpSmooth,SmoothFactor);
    XMLWriteVariant(XmlNode,iniLnStyle,integer(LStyle));
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LWidth));
    XMLWriteVariant(XmlNode,iniEbWidth,round(100*EWidth));
    XMLWriteVariant(XmlNode,iniLnCol,LColor);
    XMLWriteVariant(XmlNode,iniEbCol,EColor);
    end;
  end;

function TCurveItem.HitsItem (APos : TFPoint; Delta : double) : TItemAction;
var
  i : integer;
begin
  Result:=iaNone;
  with HitData do if Available then begin
    if (Properties.JoinMode=jmSpline) then begin
      for i:=0 to High(Data) do
        if (abs(APos.X-Data[i].X)<=Delta) and (abs(APos.Y-Data[i].Y)<=Delta) then begin
        Result:=iaFixed; Exit;
        end;
      end
    else if (Properties.JoinMode=jmLine) then begin
      for i:=1 to High(Data) do if IsNearLineSection(APos,Data[i-1],Data[i],Delta) then begin
        Result:=iaFixed; Exit;
        end;
      end
    else begin
      for i:=0 to High(Data) do if IsNearPoint(APos,Data[i],Delta) then begin
        Result:=iaFixed; Exit;
        end;
      end;
    end;
  end;

procedure TCurveItem.Reset;
begin
  SplineData.Computed:=false;
  end;

function TCurveItem.CompareVals (const arg1,arg2) : boolean;
var
  n1 : TData absolute arg1;
  n2 : TData absolute arg2;
begin
  Result:=n1.Val.X<n2.Val.X;
  end;

(* Splinefit berechnen *)
procedure TCurveItem.ComputeSplineFit;
var
  xv,yv,ys    : TVector;
  ck          : TMatrix;
  stx,sty     : TScaleType;
  XMax,XMin,
  YMax,YMin,
  xls,yls,
  x0,dx,xw    : double;
  ix,iy,np,
  i,n,k       : integer;
  s           : string;
  da          : TDataArray;
begin
  if SplineData.Computed or (DataTable.Count=0) then Exit;
  with DataTable do begin
    SetLength(xv,Count); SetLength(yv,Count);
    SetLength(ys,Count); SetLength(ck,Count-1,3);
    end;
  with FChart do begin
    ix:=IndexOf(XAxID);
    if ix<0 then begin
      ErrorDialog(Description+' - '+_('Computing of spline function is impossible:')+sLineBreak+_('No X axis specified!'));
      Exit;
      end;
    iy:=IndexOf(YAxID);
    if iy<0 then begin
      ErrorDialog(Description+' - '+_('Computing of spline function is impossible:')+sLineBreak+_('No Y axis specified!'));
      Exit;
      end;
    with Item[ix] as TAxisItem do begin
      XMin:=MinVal; XMax:=MaxVal; stx:=ScaleType;
      end;
    with Item[iy] as TAxisItem  do begin
      YMin:=MinVal; YMax:=MaxVal; sty:=ScaleType;
      end;
    if stx=stLog then xls:=lg(XMax/XMin);
    if sty=stLog then yls:=lg(YMax/YMin);
    n:=0;
    da:=Copy(DataTable.Data);
    QuickSort(da[0],length(da),SizeOf(TData),CompareVals);
    for i:=0 to High(da) do with da[i].Val,Properties do begin
      try
        if stx=stLog then xv[n]:=lg(x/XMin)/xls
        else if stx=stInv then xv[n]:=1/x
        else xv[n]:=x;
      except
        xv[n]:=1;
        end;
      try
        if sty=stLog then yv[n]:=lg(y/YMin)/yls
        else if sty=stInv then yv[n]:=1/y
        else yv[n]:=y;
      except
        yv[n]:=1;
        end;
      inc(n);
      end;
    da:=nil;
    k:=CubSpline(n,Properties.SmoothFactor,xv,yv,ys,ck);
    if k=0 then with SplineData do begin
      x0:=xv[0]; dx:=xv[n-1];
      with ParentChart.Item[ix] as TAxisItem do begin
        xw:=abs(Scale(x0)-Scale(dx));
        end;
      dx:=dx-x0;
      with Properties do np:=GetFuncPoints(xw,LWidth,LStyle);
      SetLength(Data,np+1);
      if np>0 then for i:=0 to np do with Data[i] do begin
        x:=x0+dx*i/np;
        CubSplineVal(n,x,xv,ys,ck,y);
        if stx=stLog then begin
          if x>1 then x:=XMax+1
          else if x>0 then x:=XMin*Pwr(10.0,x*xls)
          else x:=XMin-1;
          end
        else if stx=stInv then x:=1/x;
        if sty=stLog then begin
          if y>1 then y:=YMax+1
          else if y>0 then y:=YMin*Pwr(10.0,y*yls)
          else y:=YMin-1;
          end
        else if sty=stInv then y:=1/y;
        Valid:=(x>=XMin) and (x<=XMax) and (y>=YMin) and (y<=YMax);
        end;
      Computed:=np>1;
      end
    else begin
      if k=81 then s:=_('at least two points are required!')
      else s:=_('the X values must be sorted in ascending order!');
      ErrorDialog (_('Could not compute spline function:')+sLineBreak+s);
      Properties.JoinMode:=jmNone;
      end;
    end;
  xv:=nil; yv:=nil; ys:=nil; ck:=nil
  end;

{ ------------------------------------------------------------------- }
// Object: TFitItem - Approximation von Messdaten nach Gauss
constructor TFitItem.Create (AChart : TChart; AProps : TFitProperties);
begin
  inherited Create(itFit,AChart);
  CurveID:=-1; Precision:=0;
  Properties:=AProps;
  FitData.Computed:=false;
  end;

constructor TFitItem.CreateFrom (AFit : TFitItem);
begin
  inherited Create(itFit,AFit.ParentChart);
  Assign(AFit);
  end;

procedure TFitItem.Assign (AFit : TFitItem);
begin
  inherited Assign (AFit);
  CurveID:=AFit.CurveID;
  Properties:=AFit.Properties;
  FitData.Computed:=false;
  end;

function TFitItem.GetDesc : string;
begin
  if length(FDesc)=0 then Result:=_('Best-fit curve')+' '+IntToStr((FID and $FF)+1)
  else Result:=inherited;
  end;

function TFitItem.GetOutline : TFRect;
begin
  Result:=FOutline;
  end;

procedure TFitItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  inherited LoadData (XmlNode,DataOptions);
  if doChart in DataOptions then begin
    CurveID:=XMLReadInteger(XmlNode,iniXAxis,CurveID);
    end;
  with Properties do begin
    FitAll:=XMLReadBool(XmlNode,iniFitAll,true);
    ViewAll:=XMLReadBool(XmlNode,iniFitView,true);
  // benutzt Punkt als Dezimaltrenner
    FitMin:=StringToFloat(XMLReadString(XmlNode,iniFMin,''),FitMin);
    FitMax:=StringToFloat(XMLReadString(XmlNode,iniFMax,''),FitMax);
    FitOrder:=XMLReadInteger(XmlNode,iniFitOrder,FitOrder);
    XScale:=TScaleType(XMLReadInteger(XmlNode,iniXScale,integer(XScale)));
    YScale:=TScaleType(XMLReadInteger(XmlNode,iniYScale,integer(YScale)));
    LStyle:=TLineStyle(XMLReadInteger(XmlNode,iniLnStyle,integer(LStyle)));
    LWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LWidth))/100;
    LColor:=XMLReadInteger(XmlNode,iniLnCol,LColor);
    end;
  FitData.Computed:=false;
  end;

procedure TFitItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  inherited SaveData (XmlNode,DataOptions);
  if doChart in DataOptions then begin
    XMLWriteVariant(XmlNode,iniXAxis,CurveID);
    end;
  with Properties do begin
    XMLWriteVariant(XmlNode,iniFitAll,FitAll);
    XMLWriteVariant(XmlNode,iniFitView,ViewAll);
  // benutzt Punkt als Dezimaltrenner
    XMLWriteVariant(XmlNode,iniFMin,FloatToString(FitMin,ffGeneral,6,1));
    XMLWriteVariant(XmlNode,iniFMax,FloatToString(FitMax,ffGeneral,6,1));
    XMLWriteVariant(XmlNode,iniFitOrder,FitOrder);
    XMLWriteVariant(XmlNode,iniXScale,integer(XScale));
    XMLWriteVariant(XmlNode,iniYScale,integer(YScale));
    XMLWriteVariant(XmlNode,iniLnStyle,integer(LStyle));
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LWidth));
    XMLWriteVariant(XmlNode,iniLnCol,LColor);
    end;
  end;

function TFitItem.HitsItem (APos : TFPoint; Delta : double) : TItemAction;
var
  i : integer;
begin
  Result:=iaNone;
  with HitData do if Available then begin
    for i:=1 to High(Data) do if IsNearLineSection(APos,Data[i-1],Data[i],Delta) then begin
      Result:=iaFixed; Exit;
      end;
    end
  end;

procedure TFitItem.Reset;
begin
  FitData.Computed:=false;
  end;

procedure TFitItem.ComputeFit;
var
  xv,yv       : TVector;
  XMax,XMin,
  YMax,YMin,
  xls,yls,
  xw,x0,dx    : double;
  ix,iy,ic,
  i,n,np      : integer;
  dt          : TDataTable;

  function PolynomFit(fo : integer; var fr : TFitResult) : boolean;
  begin
    with fr do begin
      Degree:=fo;
      SetLength(Coeffs,Degree+1);
      Result:=PolFit (fo,n,xv,yv,Coeffs,Sigma);
      end;
    end;

  function MinXVal : double;
  var
    i : integer;
  begin
    Result:=MaxDouble;
    with dt do for i:=0 to Count-1 do with Data[i].Val do if x<Result then Result:=x;
    end;

  function MaxXVal : double;
  var
    i : integer;
  begin
    Result:=MinDouble;
    with dt do for i:=0 to Count-1 do with Data[i].Val do if x>Result then Result:=x;
    end;

begin
  if FitData.Computed then Exit;
  if Properties.FitOrder=0 then Exit;
  with ParentChart do begin
    ic:=IndexOf(CurveID);
    if ic<0 then begin
      ErrorDialog(Description+' - '+_('Computing of polynom fit is impossible:')+sLineBreak+_('No data curve assigned!'));
      Exit;
      end;
    with Item[ic] as TCurveItem do begin
      dt:=DataTable;
      ix:=IndexOf(XAxID);
      iy:=IndexOf(YAxID);
      end;
    if ix<0 then begin
      ErrorDialog(Description+' - '+_('Computing of polynom fit is impossible:')+sLineBreak+_('No X axis assigned!'));
      Exit;
      end;
    if iy<0 then begin
      ErrorDialog(Description+' - '+_('Computing of polynom fit is impossible:')+sLineBreak+_('No Y axis assigned!'));
      Exit;
      end;
    with Item[ix] as TAxisItem do begin
      XMin:=MinVal; XMax:=MaxVal;
      XUnit:=AUnit;
      end;
    with Item[iy] as TAxisItem  do begin
      YMin:=MinVal; YMax:=MaxVal;
      Precision:=Properties.Precision;
      YUnit:=AUnit;
      end;
    end;
  if dt.Count<=Properties.FitOrder+1 then begin
    ErrorDialog(Description+' - '+_('Insufficient number of points to compute the fit!'));
    Exit;
    end;
  try
    with Properties do begin
      if XScale=stLog then xls:=lg(XMax/XMin);
      if YScale=stLog then yls:=lg(YMax/YMin);
      end;
  except
    ErrorDialog(Description+' - '+_('Error computing nonlinear scaling!'));
    Exit;
    end;
  with dt do begin
    Setlength(xv,Count); SetLength(yv,Count);
    end;
  n:=0;
  with dt do for i:=0 to Count-1 do with Data[i].Val,Properties do
        if FitAll or ((x>=FitMin) and (x<=FitMax)) then begin
    try
      if XScale=stLog then xv[n]:=lg(x/XMin)/xls
      else if XScale=stInv then xv[n]:=1/x
      else xv[n]:=x;
      if YScale=stLog then yv[n]:=lg(y/YMin)/yls
      else if YScale=stInv then yv[n]:=1/y
      else yv[n]:=y;
    except
      ErrorDialog(Description+' - '+_('Error computing nonlinear scaling!'));
      n:=0; Break;
      end;
    inc(n);
    end;
  if n>0 then begin
    with Properties do if PolynomFit(FitOrder,FitResult) then begin
      if XScale=stLog then begin
        x0:=lg(MinXVal/XMin)/xls; dx:=lg(MaxXVal/XMin)/xls-x0;
        if FitOrder=1 then np:=1
        else np:=GetFuncPoints(ParentChart.InnerArea.Width,LWidth,LStyle);
        end
      else if XScale=stInv then begin
        x0:=1/MinXVal; dx:=1/MaxXVal-x0;
        if FitOrder=1 then np:=1
        else np:=FuncPoints;
        end
      else begin
        if ViewAll then begin
          x0:=XMin; dx:=XMax;
          end
        else begin
          x0:=MinXVal; dx:=MaxXVal;
          end;
        with ParentChart.Item[ix] as TAxisItem do begin
          xw:=abs(Scale(x0)-Scale(dx));
          end;
        dx:=dx-x0;
        if FitOrder=1 then np:=1
        else np:=GetFuncPoints(xw,LWidth,LStyle);
        end;
      with FitData do begin
        SetLength(Data,np+1);
        if np>0 then for i:=0 to np do with Data[i] do begin
          x:=x0+dx*i/np;
          y:=Horner(FitResult,x);
          Valid:=true; //(x>=XMin) and (x<=XMax) and (y>=YMin) and (y<=YMax);
          if XScale=stLog then begin
            x:=XMin*Pwr(10.0,x*xls);
            end
          else if XScale=stInv then begin
            if x=0 then Valid:=false
            else x:=1/x;
            end;
          if YScale=stLog then begin
            y:=YMin*Pwr(10.0,y*yls)
            end
          else if YScale=stInv then begin
            if y=0 then Valid:=false
            else y:=1/y;
            end;
          end
        else Data[0].Valid:=false;
        Computed:=np>0;
        end;
      with FitResult do if YScale=stLog then begin
        if XScale=stLog then begin  // doppelt log
          Coeffs[0]:=YMin*Pwr(10.0,Coeffs[0]*yls);
          dx:=yls;
          for i:=1 to Degree do begin
            dx:=dx/xls; Coeffs[i]:=Coeffs[i]*dx;
            end;
          end
        else begin  // x -> lin, y -> log
          for i:=0 to Degree do Coeffs[i]:=Coeffs[i]*yls;
          x0:=Coeffs[0]+lg(YMin);
          Coeffs[0]:=x0;
          end;
        end
      else if XScale=stLog then begin  // x -> log, y -> lin
        Coeffs[0]:=Horner(Coeffs,Degree,-lg(XMin)/xls);
        dx:=1;
        for i:=1 to Degree do begin
          dx:=dx/xls; Coeffs[i]:=Coeffs[i]*dx;
          end;
        end;
      end
    else begin
      ErrorDialog (_('Could not compute polynomial fit!'));
      end;
    end;
  xv:=nil; yv:=nil;
  end;

function TFitItem.GetFitString (Options : TTextOptions) : string;
var
  i           : integer;
  fu          : boolean;
  s,t         : string;
begin
  Result:='';
  if FitData.Computed then begin
    fu:=toUnits in Options ;
    with FitResult,Properties do begin
      if toDesc in Options then Result:=Description+':'+sLineBreak else Result:='';
      Result:=Result+'a_0_ = '+NumberToPlotString(FloatToStrS(Coeffs[0],Precision));
      if fu and (YScale<>stLog) then Result:=Result+' '+YUnit+sLineBreak else Result:=Result+sLineBreak;
      if fu and (YScale<>stLog) and (length(YUnit)>0) then s:=' '+YUnit else s:='';
      for i:=1 to Degree do begin
        if fu  and (XScale<>stLog) and (length(XUnit)>0) then begin
          if length(s)=0 then t:='1/'+XUnit else t:=s+'/'+XUnit;
          if i>1 then t:=t+'^'+Strint(i,0)+'^';
          end
        else t:=s;
        Result:=Result+'a_'+StrInt(i,1)+'_ = '
           +NumberToPlotString(FloatToStrS(Coeffs[i],Precision))+t+sLineBreak;
        end;
      if toSigma in Options then begin
        Result:=Result+'!s! = '+NumberToPlotString(FloatToStrS(Sigma,Precision));
        if fu then Result:=Result+' '+YUnit;
        end;
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
// Object: TGraphItem - Darstellung von Messdaten als Balken- oder Tortendiagramm
constructor TGraphItem.Create (AChart : TChart; AProps : TCurveProperties; AType : TGraphType);
begin
  inherited Create(itGraph,AChart);
  GraphType:=AType;
  XAxID:=-1; YAxID:=-1;
  with Properties do begin
    Transparent:=false;
    LWidth:=AProps.LWidth;
    LColor:=AProps.LColor;
    BColor:=AChart.ParentSheet.DefFillColor;
    if GraphType=gtPie then begin           // Torte
      end
    else if GraphType=gtBar then begin      // Balken
      BWidth:=2*AProps.SymSize; BOffset:=0;
      end
    else begin
      Stripes:=20;
      end;
    end;
  with DataTable do begin
    Count:=0; Data:=nil;
    if GraphType=gtBar then DataCols:=[dcValX,dcValY]
    else DataCols:=[dcValX];
    end;
  with HistData do begin
    Data:=nil;
    Computed:=false;
    end;
  HitData.Available:=false;
  end;

constructor TGraphItem.CreateFrom (AGraph : TGraphItem);
begin
  inherited Create(itGraph,AGraph.ParentChart);
  Assign(AGraph);
  end;

procedure TGraphItem.Assign (AGraph : TGraphItem);
begin
  inherited Assign (AGraph);
  GraphType:=AGraph.GraphType;
  XAxID:=AGraph.XAxID;
  YAxID:=AGraph.YAxID;
  Properties:=AGraph.Properties;
  DataTable:=AGraph.DataTable;
  HistData.Computed:=false; HitData.Available:=false;
  end;

function TGraphItem.GetDesc : string;
var
  n,i : integer;
begin
  if length(FDesc)=0 then begin
    case GraphType of
    gtHisto : Result:=_('Histogram');
    gtPie   : Result:=_('Pie chart');
    else Result:=_('Bar graph');
      end;
    if assigned(FChart) then with FChart do begin
      n:=0;
      for i:=0 to ItemCount-1 do if (Item[i].FItemType=itGraph)
        and ((Item[i] as TGraphItem).GraphType=GraphType) then inc(n);
      Result:=Result+' '+IntToStr(n);
      end;
    FDesc:=Result;
    end
  else Result:=inherited;
  end;

function TGraphItem.GetTypeName: string;
begin
  Result:='['+GraphTypeNames[GraphType]+'] ';
  end;

function TGraphItem.GetOutline : TFRect;
begin
  Result:=FOutline;
  end;

procedure TGraphItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
  i     : integer;
begin
  inherited LoadData (XmlNode,DataOptions);
  GraphType:=TGraphType(XMLReadInteger(XmlNode,iniSubType,integer(GraphType)));
  if doChart in DataOptions then begin
    XAxID:=XMLReadInteger(XmlNode,iniXAxis,XAxID);
    YAxID:=XMLReadInteger(XmlNode,iniYAxis,YAxID);
    end;
  with DataTable do begin
    Count:=0; Data:=nil; DataCols:=[];
    end;
  if doData in DataOptions then begin
    lnode:=XMLReadNode(XmlNode,iniData);
    with DataTable do if assigned(lnode) then begin
      HexToSet(XMLReadString(XmlNode,iniColumns,
        SetToHex(@DataCols,integer(Low(TDataCol)),integer(High(TDataCol)))),@DataCols);
      if GraphType=gtBar then DataCols:=DataCols+[dcValX,dcValY]
      else DataCols:=DataCols+[dcValX];
      Count:=lnode.ChildNodes.Count;
      SetLength(Data,Count);
      for i:=0 to Count-1 do Data[i]:=StrToData(DataCols,XMLReadChildString(lnode,i,''));
      end;
    end;
  with Properties do begin
    Transparent:=XMLReadBool(XmlNode,iniTrans,Transparent);
    if GraphType=gtPie then begin
      end
    else if GraphType=gtBar then begin
      BWidth:=XMLReadInteger(XmlNode,iniWidth,round(100*BWidth))/100;
      BOffset:=XMLReadInteger(XmlNode,iniOffs,round(100*BOffset))/100;
      end
    else begin
      Stripes:=XMLReadInteger(XmlNode,iniStripes,Stripes);
      end;
    LWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LWidth))/100;
    LColor:=XMLReadInteger(XmlNode,iniLnCol,LColor);
    BColor:=XMLReadInteger(XmlNode,iniBakCol,BColor);
    end;
  HistData.Computed:=false;
  end;

procedure TGraphItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
  i     : integer;
begin
  inherited SaveData (XmlNode,DataOptions);
  XMLWriteVariant(XmlNode,iniSubType,integer(GraphType));
  if doChart in DataOptions then begin
    XMLWriteVariant(XmlNode,iniXAxis,'$'+IntToHex(XAxID,4));
    XMLWriteVariant(XmlNode,iniYAxis,'$'+IntToHex(YAxID,4));
    end;
  if doData in DataOptions then begin
    lnode:=XMLNewNode(XmlNode,iniData);
    with DataTable do begin
      XMLWriteVariant(XmlNode,iniColumns,SetToHex(@DataCols,integer(Low(TDataCol)),integer(High(TDataCol))));
      for i:=0 to Count-1 do XMLWriteVariant(lnode,iniVal,DataToStr(DataCols,Data[i]));
      end;
    end;
  with Properties do begin
    XMLWriteVariant(XmlNode,iniTrans,Transparent);
    if GraphType=gtPie then begin
      end
    else if GraphType=gtBar then begin
      XMLWriteVariant(XmlNode,iniWidth,round(100*BWidth));
      XMLWriteVariant(XmlNode,iniOffs,round(100*BOffset));
      end
    else begin
      XMLWriteVariant(XmlNode,iniStripes,Stripes);
      end;
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LWidth));
    XMLWriteVariant(XmlNode,iniLnCol,LColor);
    XMLWriteVariant(XmlNode,iniBakCol,BColor);
    end;
  end;

function TGraphItem.HitsItem (APos : TFPoint; Delta : double) : TItemAction;
var
  i : integer;
  y0 : double;
begin
  Result:=iaNone;
  if not HitData.Available then Exit;
  with Properties,HitData do if GraphType=gtHisto then begin
    if Transparent then begin
      for i:=1 to High(Data) do if IsNearLineSection(APos,Data[i-1],Data[i],Delta) then begin
        Result:=iaFixed; Exit;
        end;
      end
    else begin
      y0:=Data[0].Y;
      for i:=0 to Stripes-1 do if IsInRect(APos,FloatRect(Data[2*i].X,y0,Data[2*(i+1)].X,Data[2*(i+1)].Y)) then begin
        Result:=iaFixed; Exit;
        end;
      end;
    end
  else begin
    for i:=0 to High(Data) do with Data[i] do
        if IsInRect(APos,FloatRect(X-BWidth/2+BOffset,ParentChart.InnerArea.Bottom+LWidth/2,X+BWidth/2+BOffset,Y))
        then begin
      Result:=iaFixed; Exit;
      end;
    end;
  end;

procedure TGraphItem.Reset;
begin
  HistData.Computed:=false;
  end;

procedure TGraphItem.ComputeHistogram;
var
  i,ix,j,n : integer;
  sw       : double;
begin
  if HistData.Computed then Exit;
  n:=Properties.Stripes;
  SetLength(HistData.Data,n);
  for i:=0 to n-1 do HistData.Data[i]:=0;
  with FChart do begin
    ix:=IndexOf(XAxID);
    if ix<0then begin
      ErrorDialog(Description+' - '+_('Computing of histogram is impossible:')+sLineBreak+_('No X axis assigned!'));
      Exit;
      end;
    sw:=InnerArea.Width/Properties.Stripes;  // Streifenbreite in cm/inch
    with DataTable do begin
      for i:=0 to Count-1 do begin
        j:=trunc((Scale(ix,Data[i].Val.X)-InnerArea.Left)/sw);
        if (j>=0) and (j<n) then inc(HistData.Data[j]);
        end;
      end;
    end;
  HistData.Computed:=true;
  end;

{ ------------------------------------------------------------------- }
// Object: TFunctionItem - Darstellung einer berechneten Funktion im Diagramm
constructor TFunctionItem.Create (AChart : TChart; AProps : TFunctionProperties);
var
  i : integer;
begin
  inherited Create(itFunction,AChart);
  XAxID:=-1; YAxID:=-1;
  Properties:=AProps;
  with Properties do begin
    SetLength(Constants,MaxConst);
    for i:=0 to MaxConst-1 do with Constants[i] do begin
      ConstName:=defConstName[i]; ConstValue:=0;
      end;
    end;
  FuncData.Computed:=false;
  end;

constructor TFunctionItem.CreateFrom (AFunction : TFunctionItem);
begin
  inherited Create(itFunction,AFunction.ParentChart);
  Assign(AFunction);
  end;

procedure TFunctionItem.Assign (AFunction : TFunctionItem);
begin
  inherited Assign (AFunction);
  XAxID:=AFunction.XAxID;
  YAxID:=AFunction.YAxID;
  Properties:=AFunction.Properties;
  FuncData.Computed:=false;
  end;

function TFunctionItem.GetDesc : string;
begin
  if length(FDesc)=0 then Result:=_('Function')+' '+IntToStr((FID and $FF)+1)
  else Result:=inherited;
  end;

function TFunctionItem.GetOutline : TFRect;
begin
  Result:=FOutline;
  end;

procedure TFunctionItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  i : integer;
begin
  inherited LoadData (XmlNode,DataOptions);
  if doChart in DataOptions then begin
    XAxID:=XMLReadInteger(XmlNode,iniXAxis,XAxID);
    YAxID:=XMLReadInteger(XmlNode,iniYAxis,YAxID);
    end;
  with Properties do begin
    FuncAll:=XMLReadBool(XmlNode,iniFuncAll,true);
  // benutzt Punkt als Dezimaltrenner
    Min:=StringToFloat(XMLReadString(XmlNode,iniMin,''),Min);
    Max:=StringToFloat(XMLReadString(XmlNode,iniMax,''),Max);
    LWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LWidth))/100;
    LStyle:=TLineStyle(XMLReadInteger(XmlNode,iniLnStyle,integer(LStyle)));
    LColor:=XMLReadInteger(XmlNode,iniLnCol,LColor);
    AngularUnit:=TAngularUnit(XMLReadInteger(XmlNode,iniAngUnit,integer(AngularUnit)));
    Formula:=XMLReadString(XmlNode,iniFormula,Formula);
    for i:=0 to MaxConst-1 do with Constants[i] do
      ConstValue:=StringToFloat(XMLReadString(XmlNode,iniConst+IntToStr(i),''),ConstValue);
    end;
  FuncData.Computed:=false;
  end;

procedure TFunctionItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  i : integer;
begin
  inherited SaveData (XmlNode,DataOptions);
  if doChart in DataOptions then begin
    XMLWriteVariant(XmlNode,iniXAxis,'$'+IntToHex(XAxID,4));
    XMLWriteVariant(XmlNode,iniYAxis,'$'+IntToHex(YAxID,4));
    end;
  with Properties do begin
    XMLWriteVariant(XmlNode,iniFuncAll,FuncAll);
  // benutzt Punkt als Dezimaltrenner
    XMLWriteVariant(XmlNode,iniMin,FloatToString(Min,ffGeneral,6,1));
    XMLWriteVariant(XmlNode,iniMax,FloatToString(Max,ffGeneral,6,1));
    XMLWriteVariant(XmlNode,iniLnStyle,integer(LStyle));
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LWidth));
    XMLWriteVariant(XmlNode,iniLnCol,LColor);
    XMLWriteVariant(XmlNode,iniAngUnit,integer(AngularUnit));
    XMLWriteVariant(XmlNode,iniFormula,Formula);
    for i:=0 to MaxConst-1 do
      XMLWriteVariant(XmlNode,iniConst+IntToStr(i),FloatToString(Constants[i].ConstValue,ffGeneral,6,1));
    end;
  end;

function TFunctionItem.HitsItem (APos : TFPoint; Delta : double) : TItemAction;
var
  i : integer;
begin
  Result:=iaNone;
  with HitData do if Available then begin
    for i:=1 to High(Data) do if IsNearLineSection(APos,Data[i-1],Data[i],Delta) then begin
      Result:=iaFixed; Exit;
      end;
    end
  end;

procedure TFunctionItem.Reset;
begin
  FuncData.Computed:=false;
  end;

procedure TFunctionItem.ComputeFunction;
var
  i,ix,iy,np  : integer;
  stx,sty     : TScaleType;
  XMax,XMin,
  YMax,YMin,
  xls,
  x0,dx,xw    : double;
  ok          : boolean;
begin
  if FuncData.Computed then Exit;
  with FChart do begin
    ix:=IndexOf(XAxID);
    if ix<0then begin
      ErrorDialog(Description+' - '+_('Computing of function is impossible:')+sLineBreak+_('No X axis assigned!'));
      Exit;
      end;
    iy:=IndexOf(YAxID);
    if iy<0 then begin
      ErrorDialog(Description+' - '+_('Computing of function is impossible:')+sLineBreak+_('No Y axis assigned!'));
      Exit;
      end;
    with Item[ix] as TAxisItem do begin
      XMin:=MinVal; XMax:=MaxVal; stx:=ScaleType;
      end;
    with Item[iy] as TAxisItem  do begin
      YMin:=MinVal; YMax:=MaxVal; sty:=ScaleType;
      end;
    with Properties do if not FuncAll then begin
      if (Min>XMin) and (Min<Max) and (Min<XMax) then XMin:=Min;
      if (Max>XMin) and (Max>Min) and (Max<XMax) then XMax:=Max;
      end;
    with Item[ix] as TAxisItem do begin
      xw:=abs(Scale(XMin)-Scale(XMax));
      end;
    x0:=XMin; dx:=XMax-x0;
    with Properties do begin
      with Properties do np:=GetFuncPoints(xw,LWidth,LStyle);
      SetLength(FuncData.Data,np+1); ok:=false;
      if np>0 then for i:=0 to np do with FuncData.Data[i] do begin
        x:=x0+dx*i/np;
        Valid:=(x>=XMin) and (x<=XMax)
          and CalcFunction(ReplaceDecSepWithPeriod(Formula),x,integer(AngularUnit),Constants,y);
//          and (y>=YMin) and (y<=YMax);
        if Valid then ok:=true;
        end
      else FuncData.Data[0].Valid:=false;
      end;
    FuncData.Computed:=(np>1) and ok;
    end;
  end;

{ ------------------------------------------------------------------- }
// Object: TTextItem - Darstellung eines mehrzeilgen Texts mit opt. Umrahmnung
constructor TTextItem.Create (AChart : TChart; AFont : TPlotFont; AType : TTextType);
begin
  inherited Create(itText,AChart);
  TextType:=AType;
  Text:='';
  CurveID:=-1;
  Options:=[];
  FPosition:=AChart.GetCenterPos;
  with Properties do begin
    Font:=AFont;
    Transparent:=true;
    Align:=alCenterAll;
    Border:=false;
    with AChart.ParentSheet do begin
      LWidth:=DefaultLineWidth;
      LColor:=DefaultLineColor;
      BgColor:=SheetColor;
      end;
    end;
  end;

constructor TTextItem.CreateFrom (AText : TTextItem);
begin
  inherited Create(AText.Itemtype,AText.ParentChart);
  Assign(AText);
  end;

procedure TTextItem.Assign (AText : TTextItem);
begin
  inherited Assign (AText);
  TextType:=AText.TextType;
  Text:=AText.Text;
  CurveID:=AText.CurveID;
  Options:=AText.Options;
  Position:=AText.Position;
  Properties:=AText.Properties;
  end;

function TTextItem.GetDesc : string;
var
  i,n : integer;
begin
  if length(FDesc)=0 then begin
    case TextType of
    ttFitResult : Result:=_('Best-fit result');
    ttLegend : Result:=_('Legend');
    ttComment : Result:=_('Comment');
    else Result:=_('Text');
      end;
    if assigned(FChart) then with FChart do begin
      n:=0;
      for i:=0 to ItemCount-1 do if (Item[i].FItemType=itText)
        and ((Item[i] as TTextItem).TextType=TextType) then inc(n);
      Result:=Result+' '+IntToStr(n);
      end;
    FDesc:=Result;
    end
  else Result:=inherited;
  end;

function TTextItem.GetTypeName: string;
begin
  Result:='['+TextTypeNames[TextType]+'] '
  end;

function TTextItem.GetOutline : TFRect;
begin
  Result:=FOutline;
  end;

function TTextItem.GetPos  : TFPoint;  // get abs. Position
begin
  with Result do begin
    X:=FPosition.X+FChart.InnerArea.Left;
    Y:=FPosition.Y+FChart.InnerArea.Bottom;
    end;
  end;

procedure TTextItem.SetPos (APos : TFPoint);
begin
  with FPosition do begin
    X:=APos.X-FChart.InnerArea.Left;
    Y:=APos.Y-FChart.InnerArea.Bottom;
    end;
  end;

procedure TTextItem.MovePos (Offset : TFPoint);
begin
  FPosition:=MovePoint(FPOsition,Offset);
  end;

procedure TTextItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
begin
  inherited LoadData (XmlNode,DataOptions);
  TextType:=TTextType(XMLReadInteger(XmlNode,iniSubType,integer(TextType)));
  Text:=ReplaceText(XMLReadString(XmlNode,iniText,''),'|',sLineBreak);
  CurveID:=XMLReadInteger(XmlNode,iniCurve,CurveID);
  StrToPosition(XMLReadString(XmlNode,iniPos,''),ValDelim,FPosition);
  HexToSet(XMLReadString(XmlNode,iniOpt,
    SetToHex(@Options,integer(Low(TTextOption)),integer(High(TTextOption)))),@Options);
  with Properties do begin
    lnode:=XMLReadNode(XmlNode,iniFont);
    with Font do if assigned(lnode) then begin
      FontName:=XMLReadString(lNode,iniName,FontName);
      FontSize:=XMLReadInteger(lNode,iniSize,round(100*FontSize))/100;
      FontAngle:=XMLReadInteger(lNode,iniAngle,FontAngle);
      FontStyle:=[];
      if XMLReadBool(lnode,iniBold,fsBold in FontStyle) then include(FontStyle,fsBold);
      if XMLReadBool(lnode,iniItalic,fsItalic in FontStyle) then include(FontStyle,fsItalic);
      FontColor:=XMLReadInteger(lNode,iniColor,FontColor);
      FontType:=TFontType(XMLReadInteger(lNode,iniType,integer(FontType)));
      end;
    Align:=TTextAlign(XMLReadInteger(XmlNode,iniAlign,integer(Align)));
    Transparent:=XMLReadBool(XmlNode,iniTrans,Transparent);
    Border:=XMLReadBool(XmlNode,iniBorder,Border);
    LWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LWidth))/100;
    LColor:=XMLReadInteger(XmlNode,iniLnCol,LColor);
    BgColor:=XMLReadInteger(XmlNode,iniBakCol,BgColor);
    end;
  end;

procedure TTextItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
var
  lnode : IXMLNode;
begin
  inherited SaveData (XmlNode,DataOptions);
  XMLWriteVariant(XmlNode,iniSubType,integer(TextType));
  XMLWriteVariant(XmlNode,iniText,ReplaceText(Text,sLineBreak,'|'));
  XMLWriteVariant(XmlNode,iniCurve,'$'+IntToHex(CurveID,4));
  with FPosition do XMLWriteVariant(XmlNode,iniPos,DimensionsToStr([X,Y],ValDelim));
  XMLWriteVariant(XmlNode,iniOpt,SetToHex(@Options,integer(Low(TTextOption)),integer(High(TTextOption))));
  with Properties do begin
    lnode:=XMLNewNode(XmlNode,iniFont);
    with Font do begin
      XMLWriteVariant(lNode,iniName,FontName);
      XMLWriteVariant(lNode,iniSize,round(100*FontSize));
      XMLWriteVariant(lNode,iniAngle,FontAngle);
      XMLWriteVariant(lNode,iniBold,fsbold in FontStyle);
      XMLWriteVariant(lNode,iniItalic,fsItalic in FontStyle);
      XMLWriteVariant(lNode,iniColor,FontColor);
      XMLWriteVariant(lNode,iniType,integer(FontType));
      end;
    XMLWriteVariant(XmlNode,iniAlign,integer(Align));
    XMLWriteVariant(XmlNode,iniTrans,Transparent);
    XMLWriteVariant(XmlNode,iniBorder,Border);
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LWidth));
    XMLWriteVariant(XmlNode,iniLnCol,LColor);
    XMLWriteVariant(XmlNode,iniBakCol,BgColor);
    end;
  end;

{ ------------------------------------------------------------------- }
// Object: TImageItem - Darstellung eines Bildes
constructor TImageItem.Create (AChart : TChart);
begin
  inherited Create(itImage,AChart);
  with FArea do begin
    Left:=0; Bottom:=0; Width:=5.0; Height:=5.0;
    end;
  Transparent:=true;
  Border:=false;
  LWidth:=AChart.ParentSheet.DefaultLineWidth;
  LColor:=clBlack;
  FImage:=TBitmap.Create; Ratio:=1;
  end;

constructor TImageItem.CreateFrom (AImage : TImageItem);
begin
  Create(AIMage.ParentChart);
  Assign(AImage);
  end;

destructor TImageItem.Destroy;
begin
  FImage.Free;
  inherited Destroy;
  end;

procedure TImageItem.Assign (AImage: TImageItem);
begin
  inherited Assign (AImage);
  FArea:=AImage.FArea;
  ImgName:=AImage.ImgName;
  FImage.Assign(AIMage.FImage);
  Ratio:=AIMage.Ratio;
  Transparent:=AIMage.Transparent;  // transparenter Hintergrund
  Border:=AIMage.Border;            // mit Umrahmung
  LWidth:=AIMage.LWidth;            // Linienbreite - Rahmen
  LColor:=AIMage.LColor;            // Farbe - Linien
  end;

function TImageItem.GetDesc : string;
begin
  if length(FDesc)=0 then Result:=_('Image')+' '+IntToStr((FID and $FF)+1)
  else Result:=inherited;
  end;

function TImageItem.GetOutline : TFRect;
begin
  Result:=AreaToRect(Area);
  end;

function TImageItem.GetArea : TFloatArea;
begin
  with Result do begin
    Left:=FArea.Left+FChart.InnerArea.Left;
    Bottom:=FArea.Bottom+FChart.InnerArea.Bottom;
    Width:=FArea.Width;
    Height:=FArea.Height;
    end;
  end;

procedure TImageItem.SetArea (AArea : TFloatArea);
begin
  with FArea do begin
    Left:=AArea.Left-FChart.InnerArea.Left;
    Bottom:=AArea.Bottom-FChart.InnerArea.Bottom;
    Width:=AArea.Width;
    Height:=AArea.Height;
    end;
  end;

procedure TImageItem.MovePos (Offset : TFPoint);
begin
  FArea:=MoveArea(FArea,Offset);
  end;

function TImageItem.CreateFilename : string;
begin
//  Result:=IncludeTrailingPathDelimiter(defImgPath)+DelExt(ExtractFilename(ParentChart.ParentSheet.Filename));
  Result:='Image-'+IntToHex(ParentChart.ChartID,2)+IntToHex((FID and $FF),2);
  end;

function TImageItem.LoadImage(const FName : string; ATrans : boolean) : boolean;
var
  bp : TJpegImage;
  ms : TMemoryStream;
  zf : TZipFile;
  sn,se : string;
  zh    : TZipHeader;
  ok    : boolean;
begin
  Result:=false;
  zf:=ParentChart.ParentSheet.ZipFile;
  if assigned(zf) then begin
    ms:=TMemoryStream.Create;
    sn:=DelExt(FName); se:=GetExt(FName);
    if length(se)=0 then se:=BmpExt;
    try
      zf.Read(sn+Punkt+se,TStream(ms),zh);
      ok:=true;
    except
      ok:=false;
      end;
    if ok and (ms.Size>0) then begin
      if AnsiSameText(se,BmpExt) then begin
        try
          FImage.LoadFromStream(ms);
          Result:=not FImage.Empty;
        except
          Result:=false;
          end;
        if Result then FIMage.Transparent:=true;
        end
      else begin
        bp:=TJpegImage.Create;
        with bp do begin
          try
            LoadFromStream(ms);
            Result:=not Empty;
          except
            Result:=false;
            end;
          end;
        if Result then with FIMage do begin
          ReleaseHandle;
          Assign(bp);
          TransParent:=ATrans;
          end;
        bp.Free;
        end;
      end
    end;
  end;

procedure TImageItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  inherited LoadData (XmlNode,DataOptions);
  ImgName:=XMLReadString(XmlNode,iniName,'');
  Transparent:=XMLReadBool(XmlNode,iniTrans,Transparent);
  if not LoadImage(ImgName,Transparent) then ImgName:='';
  StrToArea(XMLReadString(XmlNode,iniArea,''),ValDelim,FArea);
  Ratio:=XMLReadInteger(XmlNode,iniRatio,round(1000*Ratio))/1000;
//  s:=ExtractFilePath(ParentChart.ParentSheet.Filename)+ImgName;
  Border:=XMLReadBool(XmlNode,iniBorder,Border);
  LWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LWidth))/100;
  LColor:=XMLReadInteger(XmlNode,iniLnCol,LColor);
  end;

// Save image as compressed bitmap
procedure TImageItem.SaveImage(const FName : string);
var
  ms : TMemoryStream;
  zf : TZipFile;
begin
  zf:=(ParentChart.ParentSheet.ZipFile as TZipFile);
  if assigned(zf) then begin
    ms:=TMemoryStream.Create;
    FImage.SaveToStream(ms);
    ms.Position:=0;
    zf.Add(ms,FName);
    end;
  end;

procedure TImageItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  inherited SaveData (XmlNode,DataOptions);
  ImgName:=DelExt(ImgName);   // nur für Kompatibiltät zu JPG
  XMLWriteVariant(XmlNode,iniName,ImgName);
//  s:=ExtractFilePath(ParentChart.ParentSheet.Filename);
//  ForceDirectories(s+ExtractFilePath(ImgName));
  if (doData in DataOptions) then SaveImage(NewExt(ImgName,BmpExt));
  with FArea do XMLWriteVariant(XmlNode,iniArea,DimensionsToStr([Left,Bottom,Width,Height],ValDelim));
  XMLWriteVariant(XmlNode,iniRatio,round(1000*Ratio));
  XMLWriteVariant(XmlNode,iniTrans,Transparent);
  XMLWriteVariant(XmlNode,iniBorder,Border);
  XMLWriteVariant(XmlNode,iniLnWidth,round(100*LWidth));
  XMLWriteVariant(XmlNode,iniLnCol,LColor);
  end;

{------------------------------------------------------------------}
// Object: TGraphicItem - Darstellung eines grafischen Objekts (Linie, Pfeil, etc.)
constructor TDrawingItem.Create (AChart : TChart; AProps : TDrawingProperties; AType : TDrawingType);
var
  d : double;
begin
  inherited Create(itDrawing,AChart);
  DrawingType:=AType;
  d:=AChart.InnerArea.Width/5;
  FStartPt:=MovePoint(AChart.GetCenterPos,FloatPoint(-d,-d));
  FEndPt:=MovePoint(AChart.GetCenterPos,FloatPoint(d,d));
  Properties:=AProps;
  end;

constructor TDrawingItem.CreateFrom (ADrawing : TDrawingItem);
begin
  inherited Create(itDrawing,ADrawing.ParentChart);
  Assign(ADrawing);
  end;

procedure TDrawingItem.Assign (ADrawing : TDrawingItem);
begin
  inherited Assign (ADrawing);
  DrawingType:=ADrawing.DrawingType;
  FDesc:=ADrawing.FDesc;
  FStartPt:=ADrawing.FStartPt;
  FEndPt:=ADrawing.FEndPt;
  Properties:=ADrawing.Properties;
  end;

function TDrawingItem.GetDesc : string;
var
  i,n : integer;
begin
  if length(FDesc)=0 then begin
    if DrawingType=dtLine then Result:=_('Line')
    else Result:=_('Rectangle');
    if assigned(FChart) then with FChart do begin
      n:=0;
      for i:=0 to ItemCount-1 do if (Item[i].FItemType=itDrawing)
        and ((Item[i] as TDrawingItem).DrawingType=DrawingType) then inc(n);
      Result:=Result+' '+IntToStr(n);
      end;
    FDesc:=Result;
    end
  else Result:=inherited;
  end;

function TDrawingItem.GetOutline : TFRect;
var
  v : double;
begin
  Result:=FloatRect(StartPoint,EndPoint);
  with Result,Properties do begin
    if Left>Right then begin
      v:=Left; Left:=Right; Right:=v;
      end;
    if Bottom>Top then begin
      v:=Bottom; Bottom:=Top; Top:=v;
      end;
    if abs(Right-Left)<HdWidth then begin
      Right:=(Left+Right+HdWidth)/2; Left:=Right-HdWidth;
      end;
    if abs(Top-Bottom)<HdWidth then begin
      Top:=(Bottom+Top+HdWidth)/2; Bottom:=Top-HdWidth;
      end;
    end;
  end;

function TDrawingItem.GetPoint (Index : integer) : TFPoint;
var
  p : TFPoint;
begin
  case Index of
  1 : p:=FloatPoint(FEndPt.X,FStartPt.Y);
  2 : p:=FEndPt;
  3 : p:=FloatPoint(FStartPt.X,FEndPt.Y);
  else p:=FStartPt;
    end;
  with Result do begin
    X:=p.X+FChart.InnerArea.Left;
    Y:=p.Y+FChart.InnerArea.Bottom;
    end;
  end;

procedure TDrawingItem.SetPoint (Index : integer; APos : TFPoint);
var
  p : TFPoint;
begin
  with p do begin
    X:=APos.X-FChart.InnerArea.Left;
    Y:=APos.Y-FChart.InnerArea.Bottom;
    end;
  case Index of
  1 : begin
      FEndPt.X:=p.X; FStartPt.Y:=p.Y;
      end;
  2 : FEndPt:=p;
  3 : begin
      FStartPt.X:=p.X; FEndPt.Y:=p.Y;
      end;
  else FStartPt:=p;
    end;
  end;

function TDrawingItem.GetRect : TFRect;
begin
  Result:=MoveRect(FloatRect(FStartPt,FEndPt),FChart.InnerArea.BottomLeft);
  end;

function TDrawingItem.HitsItem (APos : TFPoint; Delta : double) : TItemAction;
begin
  Result:=iaNone;
  if DrawingType=dtLine then begin
    if IsNearPoint(APos,StartPoint,Delta) then Result:=iaMoveStart
    else if IsNearPoint(APos,EndPoint,Delta) then Result:=iaMoveEnd
    else if IsNearLineSection(APos,StartPoint,EndPoint,Delta) then Result:=iaMoveLine;
    end
  else begin
    if IsNearPoint(APos,StartPoint,Delta) then Result:=iaMoveSS
    else if IsNearPoint(APos,FloatPoint(StartPoint.X,EndPoint.Y),Delta) then Result:=iaMoveSE
    else if IsNearPoint(APos,EndPoint,Delta) then Result:=iaMoveEE
    else if IsNearPoint(APos,FloatPoint(EndPoint.X,StartPoint.Y),Delta) then Result:=iaMoveES
    else if Properties.Transparent then begin
      if IsNearLineSection(APos,StartPoint,FloatPoint(StartPoint.X,EndPoint.Y),Delta) or
         IsNearLineSection(APos,FloatPoint(StartPoint.X,EndPoint.Y),EndPoint,Delta) or
         IsNearLineSection(APos,EndPoint,FloatPoint(EndPoint.X,StartPoint.Y),Delta) or
         IsNearLineSection(APos,FloatPoint(EndPoint.X,StartPoint.Y),StartPoint,Delta) then Result:=iaMoveRect;
      end
    else begin
      if IsInItem(APos) then Result:=iaMoveRect;
      end;
    end;
  end;

procedure TDrawingItem.MovePos (AOffset : TFPoint);
begin
  FStartPt.Offset(AOffset);
  FEndPt.Offset(AOffset);
  end;

procedure TDrawingItem.MoveStart (AOffset : TFPoint);
begin
  FStartPt.Offset(AOffset);
  end;

procedure TDrawingItem.MoveEnd (AOffset : TFPoint);
begin
  FEndPt.Offset(AOffset);
  end;

procedure TDrawingItem.MoveStartEnd (AOffset : TFPoint);
begin
  with FStartPt do X:=X+AOffset.X;
  with FEndPt do Y:=Y+AOffset.Y;
  end;

procedure TDrawingItem.MoveEndStart (AOffset : TFPoint);
begin
  with FStartPt do Y:=Y+AOffset.Y;
  with FEndPt do X:=X+AOffset.X;
  end;

procedure TDrawingItem.LoadData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  inherited LoadData (XmlNode,DataOptions);
  DrawingType:=TDrawingType(XMLReadInteger(XmlNode,iniSubType,integer(DrawingType)));
  StrToPosition(XMLReadString(XmlNode,iniStPt,''),ValDelim,FStartPt);
  StrToPosition(XMLReadString(XmlNode,iniEndPt,''),ValDelim,FEndPt);
  with Properties do begin
    HdLength:=XMLReadInteger(XmlNode,iniHdLgt,round(100*HdLength))/100;
    HdWidth:=XMLReadInteger(XmlNode,iniHdWdt,round(100*HdWidth))/100;
    LWidth:=XMLReadInteger(XmlNode,iniLnWidth,round(100*LWidth))/100;
    Style:=TLineStyle(XMLReadInteger(XmlNode,iniLnStyle,integer(Style)));
    Transparent:=XMLReadBool(XmlNode,iniTrans,Transparent);
    Border:=XMLReadBool(XmlNode,iniBorder,Border);
    LColor:=XMLReadInteger(XmlNode,iniLnCol,LColor);
    BgColor:=XMLReadInteger(XmlNode,iniBgColor,BgColor);
    ArrowStyle:=TArrowStyle(XMLReadInteger(XmlNode,iniHdStyle,integer(ArrowStyle)));
    end;
  end;

procedure TDrawingItem.SaveData (XmlNode : IXMLNode; DataOptions : TDataOptions);
begin
  inherited SaveData (XmlNode,DataOptions);
  XMLWriteVariant(XmlNode,iniSubType,integer(DrawingType));
  with FStartPt do XMLWriteVariant(XmlNode,iniStPt,DimensionsToStr([X,Y],ValDelim));
  with FEndPt do XMLWriteVariant(XmlNode,iniEndPt,DimensionsToStr([X,Y],ValDelim));
  with Properties do begin
    XMLWriteVariant(XmlNode,iniHdLgt,round(100*HdLength));
    XMLWriteVariant(XmlNode,iniHdWdt,round(100*HdWidth));
    XMLWriteVariant(XmlNode,iniLnWidth,round(100*LWidth));
    XMLWriteVariant(XmlNode,iniLnStyle,integer(Style));
    XMLWriteVariant(XmlNode,iniTrans,Transparent);
    XMLWriteVariant(XmlNode,iniBorder,Border);
    XMLWriteVariant(XmlNode,iniLnCol,LColor);
    XMLWriteVariant(XmlNode,iniBgColor,BgColor);
    XMLWriteVariant(XmlNode,iniHdStyle,integer(ArrowStyle));
    end;
  end;

end.
