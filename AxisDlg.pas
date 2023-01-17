(* RPlot dialog
   Edit axis properties

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

unit AxisDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, NumberEd,
  RPlotObjects, RPlotUtils, Vcl.Dialogs;

type
  TAxisDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    gbRange: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    rgScale: TRadioGroup;
    gbPos: TGroupBox;
    rbBottomLeft: TRadioButton;
    rbTopRight: TRadioButton;
    laPrecision: TLabel;
    cbPrec: TComboBox;
    gbLabels: TGroupBox;
    gbLine: TGroupBox;
    laUnit3: TLabel;
    Label7: TLabel;
    gbTickMarks: TGroupBox;
    Label8: TLabel;
    Label10: TLabel;
    laPlotUnit2: TLabel;
    Label14: TLabel;
    rbInner: TRadioButton;
    rbOuter: TRadioButton;
    rbBoth: TRadioButton;
    edTickSize: TFloatRangeEdit;
    edTickWidth: TFloatRangeEdit;
    edFTickSize: TFloatRangeEdit;
    laPlotUnit1: TLabel;
    Label1: TLabel;
    Label16: TLabel;
    edTicks: TLabeledEdit;
    udTicks: TUpDown;
    gbCaption: TGroupBox;
    edCaption: TEdit;
    paPositon: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    tbCapPos: TTrackBar;
    Label2: TLabel;
    feCapDist: TFloatRangeEdit;
    Label3: TLabel;
    feCapSize: TFloatRangeEdit;
    laUnit2: TLabel;
    feLnWidth: TFloatRangeEdit;
    laUnit4: TLabel;
    laUnit5: TLabel;
    cxRotate: TCheckBox;
    cxBorder: TCheckBox;
    cxNoLabels: TCheckBox;
    feOffsetPos: TFloatRangeEdit;
    ColorDialog: TColorDialog;
    feLabDist: TFloatRangeEdit;
    laUnit6: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    feLabSize: TFloatRangeEdit;
    laUnit7: TLabel;
    edDescription: TLabeledEdit;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    bbLoadTemplate: TBitBtn;
    bbSaveTemplate: TBitBtn;
    cxShow: TCheckBox;
    edMinVal: TEdit;
    edMaxVal: TEdit;
    cbNotation: TComboBox;
    laNotation: TLabel;
    cbHide: TCheckBox;
    cxDate: TCheckBox;
    cxDayOfWeek: TCheckBox;
    cbLess: TCheckBox;
    edInterval: TEdit;
    rbNoTicks: TRadioButton;
    pcNotate: TPageControl;
    tsNumber: TTabSheet;
    tsUser: TTabSheet;
    paNumber: TPanel;
    paUser: TPanel;
    bbLabels: TBitBtn;
    pcLabels: TPageControl;
    tsProps: TTabSheet;
    tsLabels: TTabSheet;
    gbUserLabels: TGroupBox;
    btnEdit: TBitBtn;
    cbLabel: TComboBox;
    Label5: TLabel;
    tbLabPos: TTrackBar;
    Label13: TLabel;
    lvLabels: TListView;
    cbShowLabel: TCheckBox;
    bbLnColor: TBitBtn;
    bbLabFont: TBitBtn;
    bbCapFont: TBitBtn;
    bbInterval: TBitBtn;
    edUnit: TLabeledEdit;
    edFTickWidth: TFloatRangeEdit;
    gbGrid: TGroupBox;
    rbNoGrid: TRadioButton;
    rbSolidGrid: TRadioButton;
    rbDashedGrid: TRadioButton;
    rbDottedGrid: TRadioButton;
    Label15: TLabel;
    feGridWidth: TFloatRangeEdit;
    Label20: TLabel;
    cbLabUnit: TCheckBox;
    bbTextFormat: TBitBtn;
    Label21: TLabel;
    bbDone: TBitBtn;
    Label22: TLabel;
    Label23: TLabel;
    pcRange: TPageControl;
    tsNormal: TTabSheet;
    tsDateTime: TTabSheet;
    rgType: TRadioGroup;
    gbTimeRange: TGroupBox;
    dtpMinD: TDateTimePicker;
    Label24: TLabel;
    Label25: TLabel;
    dtpMaxD: TDateTimePicker;
    dtpMinT: TDateTimePicker;
    dtpMaxT: TDateTimePicker;
    bbMinTSet: TBitBtn;
    bbMaxTSet: TBitBtn;
    bbDateFormat: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbLnColorClick(Sender: TObject);
    procedure rgScaleClick(Sender: TObject);
    procedure bbLoadTemplateClick(Sender: TObject);
    procedure bbSaveTemplateClick(Sender: TObject);
    procedure bbCapFontClick(Sender: TObject);
    procedure bbLabFontClick(Sender: TObject);
    procedure cxDateClick(Sender: TObject);
    procedure edMinValExit(Sender: TObject);
    procedure edMaxValExit(Sender: TObject);
    procedure bbIntervalClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbPrecCloseUp(Sender: TObject);
    procedure bbLabelsClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure lvLabelsClick(Sender: TObject);
    procedure cbLabelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rbNoGridClick(Sender: TObject);
    procedure rbSolidGridClick(Sender: TObject);
    procedure rbDashedGridClick(Sender: TObject);
    procedure rbDottedGridClick(Sender: TObject);
    procedure bbTextFormatClick(Sender: TObject);
    procedure edCaptionEnter(Sender: TObject);
    procedure edUnitEnter(Sender: TObject);
    procedure rbPosClick(Sender: TObject);
    procedure bbDoneClick(Sender: TObject);
    procedure dtpMinChange(Sender: TObject);
    procedure dtpMaxChange(Sender: TObject);
    procedure bbMinTSetClick(Sender: TObject);
    procedure bbMaxTSetClick(Sender: TObject);
    procedure rgTypeClick(Sender: TObject);
    procedure bbDateFormatClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FIniName,
    LastTemplate     : string;
    FAxis            : TAxisItem;
    DateFormats,
    FDateFormat      : string;
    XMin,XMax,XInt,
    AxBegin,AxLength : double;  // Achse in cm/inch
    IsTimeScale,
    ValErr           : boolean;
    CFont,LFont      : TPLotFont;
    BitMap           : TBitMap;
    GridStyle        : TLineStyle;
    LabList          : TStringList;
    LastEdit         : TCustomEdit;
    procedure BuidlLabelList (ACount : integer; AList : TStringList);
    procedure SetGridStyle (AStyle : TLineStyle);
    procedure ShowData (AAxis : TAxisItem);
    procedure SaveData (AAxis : TAxisItem);
    function SetValue (Value : double) : string;
    function CheckValue (Edit : TEdit; var Val : double) : boolean;
    procedure UpdateView;
    function GetGrid : double;
    function GetFGrid (Grid  : double) : integer;
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    procedure LoadFromIni (const AIniName : string);
    function Execute (AAxis: TAxisItem) : boolean;
  end;

var
  AxisDialog: TAxisDialog;

implementation

{$R *.dfm}

uses GnuGetText, System.IniFiles, System.Math, System.StrUtils,
  NumberUtils, WinUtils, StringUtils, MathUtils, ExtSysUtils, DateUtils,
  PlotFontDlg, SelectFromListDlg, TextFormatDlg, DateFormatDlg, MsgDialogs;

const
  BitMapHeight=8;
  DfFile = 'DateFormats.cfg';

{ ------------------------------------------------------------------- }
procedure TAxisDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLnColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  LastTemplate:=''; GridStyle:=lsNone; DateFormats:='';
  LabList:=TStringList.Create;
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TAxisDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TAxisDialog.LoadFromIni (const AIniName : string);
var
  sd,s : string;
  fs : TextFile;
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (AxisSekt,IniLeft,Left);
    Top:=ReadInteger (AxisSekt,IniTop,Top);
    LastTemplate:=ReadString(AxisSekt,iniTpl,'');
    Free;
    end;
// Load user date formats
  sd:=ExtractFilePath(Application.ExeName)+DfFile;
  if FileExists(sd) then begin
    AssignFile(fs,sd);
    Reset(fs); DateFormats:='';
    while not Eof(fs) do begin
      ReadLn(fs,s);
      s:=Trim(s);
      if length(s)>0 then begin
        s:=AnsiReplaceText(s,'/','"/"');
        if length(DateFormats)>0 then DateFormats:=DateFormats+';';
        DateFormats:=DateFormats+s;
        end;
      end;
    CloseFile(fs);
    end;
  end;

procedure TAxisDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  x : double;
begin
  if ModalResult=mrOK then begin
    if not ValErr then begin
//    if CheckValue(edMinVal,x) and CheckValue(edMaxVal,x) then begin
      with rgScale do if (ItemIndex=1) or (ItemIndex=2) then CanClose:=(XMin>0) and (XMax>XMin)
      else CanClose:=XMax>XMin;
      if not CanClose then begin
        ErrorDialog(_('Invalid range selection'));
        edMinVal.SetFocus;
        end;
      end
    else CanClose:=false;
    end;
  end;

procedure TAxisDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (AxisSekt,IniLeft,Left);
    WriteInteger (AxisSekt,IniTop,Top);
    WriteString(AxisSekt,iniTpl,LastTemplate);
    Free;
    end;
  BitMap.Free; LabList.Free;
  end;

{ ------------------------------------------------------------------- }
procedure TAxisDialog.UpdateView;
var
  x : double;
begin
  with rgType do if ItemIndex<>1 then begin   // horizontal, date/time
    rbBottomLeft.Caption:=_('At bottom');
    rbTopRight.Caption:=_('At top');
    cxRotate.Visible:=false;
    end
  else begin                         // vertical
    rbBottomLeft.Caption:=_('At left');
    rbTopRight.Caption:=_('At right');
    cxRotate.Visible:=true;
    end;
  with edInterval do begin
    Enabled:=rgScale.ItemIndex=0;
    edTicks.Visible:=Enabled; udTicks.Visible:=Enabled;
    end;
  if rgScale.ItemIndex=0 then begin
    with edInterval do begin
      Text:=FloatToStrF(XInt,ffGeneral,6,1);
      ReadOnly:=false;
      end;
    end
  else with edInterval do begin
    if TryStrToFloat(Text,x) then XInt:=x;
    Text:=_('<auto>'); ReadOnly:=true;
    end;
  edTicks.Visible:=rgScale.ItemIndex=0;
  udTicks.Visible:=edTicks.Visible;
  bbInterval.Visible:=edTicks.Visible;
  cbLess.Visible:=rgScale.ItemIndex=2;
  cbPrec.Visible:=rgType.ItemIndex<>2;
  laPrecision.Visible:=cbPrec.Visible;
  with pcNotate do begin
    Visible:=cbPrec.Visible;
    if (cbPrec.ItemIndex=1) then ActivePageIndex:=1 else ActivePageIndex:=0;
    end;
  cxDate.Visible:=not cbPrec.Visible;
  cxDayOfWeek.Visible:=cxDate.Visible;
  end;

function TAxisDialog.SetValue (Value : double) : string;
begin
  if rgScale.ItemIndex=3 then begin  // Datum, Zeit
    if cxDate.Checked then Result:=FormatDateTime('yyyy-mm-dd hh:nn:ss',Value)
    else begin
      if Value>=1 then begin
        Result:=IntToStr(round(DateOf(Value))*24+HourOf(Value));
        if Value<40 then Result:=Result+':'+IntToStr(MinuteOf(Value))+':00'
        else Result:=Result+':00:00';
        end
      else Result:=FormatDateTime('hh:nn:ss',Value);
      end;
    end
  else Result:=FloatToStrF(Value,ffGeneral,6,1);
  end;

function TAxisDialog.CheckValue (Edit : TEdit; var Val : double) : boolean;
var
  ok : boolean;
  dt : TDateTime;
begin
  Result:=true;
  if ModalResult=mrCancel then Exit;
  with Edit do Result:=TryStrToFloat(Text,Val);
  if not Result then begin
    if Visible then with Edit do begin
      Beep; SetFocus; SelectAll;
      end;
    end;
  end;

(* ------------------------------------------------------------------------ *)
(* Berechnung des groben Rasters einer Skala (nur lin.)*)
function TAxisDialog.GetGrid : double;
(* AxNr =   Nummer der Achse (1 -4 = hor., 5 - 8 = vert.)
   GetGrid = Rasterabstand in der Abstufung 1, 2, 5
             zu dem mit DefScale vorgebenen Bereich
   Bsp.:     Bereich von -1 bis 10 ==> GRaster = 2 *)
var
  xa,xb,dec        : double;
begin
  xa:=XMax-XMin;
  dec:=pwr(10.0,aint(lg(abs(xa))-0.05)); xa:=xa/dec;
  if xa<=2.1 then xb:=0.5 else
  if xa<=5.1 then xb:=1.0 else xb:=2.0;
  Result:=xb*dec;
  end;

(* Berechnung der feinen Unterteilung einer Skala *)
function TAxisDialog.GetFGrid (Grid  : double) : integer;
(* Grid     =  grobe Skalierung (s.o.)
   GetFGrid = Anzahl der Unterteilungen einer Grobskala *)
var
  xa   : double;
begin
  xa:=XMax-XMin;
  if xa=0 then Result:=0
  else begin
    xa:=AxLength*Grid/xa; (* ein Raster in cm/inch *)
    xa:=xa/edFTickSize.Value;
    if xa<=8 then Result:=2 else if xa<=15 then Result:=5 else Result:=10;
    end;
  end;

procedure TAxisDialog.rbPosClick(Sender: TObject);
begin
  with feOffsetPos do Value:=-Value;
  end;

procedure TAxisDialog.rbDashedGridClick(Sender: TObject);
begin
  SetGridStyle(lsDashed);
  end;

procedure TAxisDialog.rbDottedGridClick(Sender: TObject);
begin
  SetGridStyle(lsDotted);
  end;

procedure TAxisDialog.rbNoGridClick(Sender: TObject);
begin
  SetGridStyle(lsNone);
  end;

procedure TAxisDialog.rbSolidGridClick(Sender: TObject);
begin
  SetGridStyle(lsSolid);
  end;

procedure TAxisDialog.rgScaleClick(Sender: TObject);
begin
  UpdateView;
  end;

procedure TAxisDialog.rgTypeClick(Sender: TObject);
begin
  if Visible then begin
    with FAxis do if rgType.ItemIndex=2 then begin  // date/time
      AxType:=atHorz; ScaleType:=stTime;
      if not IsTimeScale then begin
        MinVal:=Date; MaxVal:=Date+1; IsTimeScale:=true;
        end;
      end
    else begin
      AxType:=TAxisType(rgType.ItemIndex); ScaleType:=stLin;
      if IsTimeScale then begin
        MinVal:=0; MaxVal:=10; IsTimeScale:=false;
        end;
      end;
    ShowData(FAxis);
    UpdateView;
    end;
  end;

procedure TAxisDialog.bbCapFontClick(Sender: TObject);
begin
  EditPlotFont(BottomLeftPos(bbCapFont),CFont);
  end;

procedure TAxisDialog.bbDateFormatClick(Sender: TObject);
var
   s : string;
begin
  if SelectDateFormat(BottomRightPos(bbDateFormat),FDateFormat,DateFormats) then
    bbDateFormat.Hint:=_('Select date format')+' ('+FDateFormat+')';
  end;

procedure TAxisDialog.bbDoneClick(Sender: TObject);
begin
  pcLabels.ActivePageIndex:=0;
  end;

procedure TAxisDialog.bbIntervalClick(Sender: TObject);
begin
  XInt:=GetGrid;
  edInterval.Text:=FloatToStrF(XInt,ffGeneral,6,1);
  udTicks.Position:=GetFGrid(XInt);
  end;

procedure TAxisDialog.bbLabFontClick(Sender: TObject);
begin
  EditPlotFont(BottomLeftPos(bbLabFont),LFont);
  end;

procedure TAxisDialog.bbLnColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbLnColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbLnColor,Color);
    end;
  end;

procedure TAxisDialog.cbPrecCloseUp(Sender: TObject);
begin
  UpdateView;
  end;

procedure TAxisDialog.bbLabelsClick(Sender: TObject);
var
  na,nd,i : integer;
begin
  na:=IInt((XMin+Xint)/XInt);      // erste grobe Marke
  nd:=IInt(XMax/XInt+0.1)-na+1;       // letzte grobe Marke
  if nd>20 then ErrorDialog(_('Too many tick marks'))
  else if nd=0 then  ErrorDialog(_('No tick marks found'))
  else with lvLabels.Items do begin
    if nd>Count then for i:=Count to nd-1 do with Add do begin
      Caption:=IntToStr(i+1);
      SubItems.Add('');
      end
    else for i:=Count-1 downto nd do Delete(i);
    pcLabels.ActivePageIndex:=1;
    lvLabels.ItemIndex:=0;
    lvLabelsClick(Sender);
    cbLabel.SetFocus;
    end;
  end;

procedure TAxisDialog.cbLabelKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_INSERT then if lvLabels.Items.Count>0 then begin
    btnEditClick(Sender);
    with lvLabels do if ItemIndex<Items.Count-1 then ItemIndex:=ItemIndex+1
    else ItemIndex:=0;
    lvLabelsClick(Sender);
    Key:=0;
    end;
  end;

procedure TAxisDialog.lvLabelsClick(Sender: TObject);
begin
  with lvLabels do if assigned(Selected) then cbLabel.Text:=Selected.SubItems[0];
  end;

procedure TAxisDialog.btnEditClick(Sender: TObject);
begin
  with lvLabels do if assigned(Selected) then with Selected do begin
    SubItems[0]:=cbLabel.Text;
    MakeVisible(false);
    end;
  with cbLabel do AddToHistory(Items,Trim(Text),20);
  end;

procedure TAxisDialog.cxDateClick(Sender: TObject);
begin
  edMinVal.Text:=SetValue(XMin); edMaxVal.Text:=SetValue(XMax);
  end;

procedure TAxisDialog.bbMaxTSetClick(Sender: TObject);
begin
  dtpMaxT.Time:=1-OneSecond;
  end;

procedure TAxisDialog.dtpMaxChange(Sender: TObject);
begin
  XMax:=DateOf(dtpMaxD.Date)+TimeOf(dtpMaxT.Time);
  cxDate.Checked:=DaysBetween(XMin,XMax)>2;
  end;

procedure TAxisDialog.bbMinTSetClick(Sender: TObject);
begin
  dtpMinT.Time:=0;
  end;

procedure TAxisDialog.dtpMinChange(Sender: TObject);
begin
  XMin:=DateOf(dtpMinD.Date)+TimeOf(dtpMinT.Time);
  cxDate.Checked:=DaysBetween(XMin,XMax)>2;
  end;

procedure TAxisDialog.edCaptionEnter(Sender: TObject);
begin
  LastEdit:=edCaption;
  end;

procedure TAxisDialog.edUnitEnter(Sender: TObject);
begin
  LastEdit:=edUnit;
  end;

procedure TAxisDialog.edMaxValExit(Sender: TObject);
begin
  ValErr:=not CheckValue(edMaxVal,XMax);
  end;

procedure TAxisDialog.edMinValExit(Sender: TObject);
begin
  ValErr:=not CheckValue(edMinVal,XMin);
  end;

procedure TAxisDialog.BuidlLabelList (ACount : integer; AList : TStringList);
var
  i : integer;
begin
  lvLabels.Clear;
  for i:=0 to ACount-1 do begin
    with lvLabels.Items.Add do begin
      Caption:=IntToStr(i+1);
      with SubItems do if i<AList.Count then Add(AList.Strings[i])
      else Add('');
      end;
    end;
  end;

procedure TAxisDialog.SetGridStyle (AStyle : TLineStyle);
begin
  GridStyle:=AStyle;
  case AStyle of
  lsSolid : rbSolidGrid.Checked:=true;
  lsDashed : rbDashedGrid.Checked:=true;
  lsDotted : rbDottedGrid.Checked:=true;
  else rbNoGrid.Checked:=true
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TAxisDialog.ShowData (AAxis : TAxisItem);
begin
  with AAxis do begin
    edDescription.Text:=Description;
    cxShow.Checked:=Visible;
    XMin:=MinVal; XMax:=MaxVal;
    with rgType do if ScaleType=stTime then begin  // scale. date/time
      ItemIndex:=2;
      pcRange.ActivePage:=tsDateTime;
      dtpMinD.Date:=DateOf(XMin);
      dtpMinT.Time:=TimeOf(XMin);
      dtpMaxD.Date:=DateOf(XMax);
      dtpMaxT.Time:=TimeOf(XMax);
      end
    else begin
      ItemIndex:=integer(AxType);
      pcRange.ActivePage:=tsNormal;
      rgScale.ItemIndex:=integer(ScaleType);     // scale (lin, log, invers)
      edMinVal.Text:=SetValue(XMin);
      edMaxVal.Text:=SetValue(XMax);
      end;
    with ParentChart.Area do begin
      if AxType=atHorz then begin
        AxBegin:=Left; AxLength:=Width;
        end
      else begin
        AxBegin:=Bottom; AxLength:=Height;
        end;
      end;
    if AxPos=apTopRight then rbTopRight.Checked:=true  // Position links/unten, rechts/oben
    else rbBottomLeft.Checked:=true;
    feOffsetPos.Value:=AxOffset;               // Offset in cm/inch rel zu Rand
    edCaption.Text:=Caption;                   // Legendentext
    edUnit.Text:=AUnit;
    XInt:=GridWidth;
    udTicks.Position:=GridTicks;
    with Labels do BuidlLabelList(Count,Labels);
    with Properties do begin
      CFont:=CapFont;                          // Schriftart und Farbe für Legende
      feCapSize.Value:=CapFont.FontSize;       // Legende: Größe
      feCapDist.Value:=CapDist;    		         // Legende: Abstand von der Achse
      tbCapPos.Position:=CapPos;               // Legende: Pos. in %
      tbLabPos.Position:=LabPos;               // Position von benutzerdefinierten Labels
      cbShowLabel.Checked:=ShowLabels;         // benutzerdefinierte Labels anzeigen
      cbPrec.ItemIndex:=Precision;             // Anzahl signif. Stellen bei der Beschriftung
      cbNotation.ItemIndex:=integer(Notation); // Schreibweise der Zahlen
      bbDateFormat.Hint:=_('Select date format')+' ('+DateFormat+')';
      FDateFormat:=DateFormat;
      FillBtnGlyph(Bitmap,bbLnColor,LnColor);  // Linienfarbe
      LFont:=LabFont;                          // Schriftart und Farbe für Beschriftung
      feLabSize.Value:=LabFont.FontSize;       // Textgröße
      feLabDist.Value:=LabDist;                // Abstand der Beschriftung von der Achse
      feLnWidth.Value:=LnWidth;                // Dicke der Linien
      feGridWidth.Value:=GrWidth;              // Dicke der Raster-Linien
      edTickSize.Value:=CTmSize/2;             // Länge der Grobskalierungsstriche
      edFTickSize.Value:=FTmSize/2;            // Länge der Feinskalierungsstriche
      edTickWidth.Value:=IvWidth;              // Dicke der groben Skalierungsstriche
      edFTickWidth.Value:=TmWidth;              // Dicke der feinen Skalierungsstriche
      if TmStyle=tmInner then rbInner.Checked:=true  // Art der Skalierungsstriche
      else if TmStyle=tmOuter then rbOuter.Checked:=true
      else if TmStyle= tmBoth then rbBoth.Checked:=true
      else rbNoTicks.Checked:=true;
      SetGridStyle(GrStyle);                    // Stil der Rasterlinien
      cxNoLabels.Checked:=asNoText in AxStyles;
      cxRotate.Checked:=asRotate in AxStyles;
      cxBorder.Checked:=asBorder in AxStyles;
      cxDate.Checked:=asDate in AxStyles;
      cxDayofWeek.Checked:=asWeekday in AxStyles;
      cbHide.Checked:=asHidden in AxStyles;
      cbLess.Checked:=asLessTicks in AxStyles;
      cbLabUnit.Checked:=asLabelUnit in AxStyles;
      end;
    end;
  pcLabels.ActivePageIndex:=0;
  end;

procedure TAxisDialog.SaveData (AAxis : TAxisItem);
var
  i : integer;
begin
  with AAxis do begin
    Description:=edDescription.Text;
    Visible:=cxShow.Checked;
    with rgType do if ItemIndex=2 then begin   // scale: date/time
      AxType:=atHorz; ScaleType:=stTime;
      MinVal:=DateOf(dtpMinD.Date)+TimeOf(dtpMinT.Time);
      MaxVal:=DateOf(dtpMaxD.Date)+TimeOf(dtpMaxT.Time);
      end
    else begin
      AxType:=TAxisType(ItemIndex);
      ScaleType:=TScaleType(rgScale.ItemIndex);    // scale (lin, log, invers)
      MinVal:=XMin; MaxVal:=XMax;   // range
      if ScaleType=stLin then begin
        if TryStrToFloat(edInterval.Text,XInt) then begin
          i:=round(abs(MaxVal-MInVal)/XInt);
          if (i>50) or (i<1) then XInt:=GetGrid;
          end
        else  XInt:=GetGrid;
        GridWidth:=XInt;
        GridTicks:=udTicks.Position;
        end;
      end;
    if rbBottomLeft.Checked then AxPos:=apBottomLeft // Position links/unten, rechts/oben
    else AxPos:=apTopRight;
    AxOffset:=feOffsetPos.Value;        // benutzerdefinierte Position in cm/inch
    Caption:=edCaption.Text;                   // Legendentext
    AUnit:=edUnit.Text;
    Labels.Clear;
    with lvLabels do for i:=0 to Items.Count-1 do Labels.Add(Items[i].SubItems[0]);
    with Properties do begin
      CFont.FontSize:=feCapSize.Value;         // Legende: Größe
      CapFont:=CFont;
      CapDist:=feCapDist.Value;                // Legende: Abstand von der Achse
      CapPos:=tbCapPos.Position;               // Legende: Pos. in %
      LabPos:=tbLabPos.Position;               // Labels: Pos. in %
      ShowLabels:=cbShowLabel.Checked;         // benutzerdefinierte Labels anzeigen
      Precision:=cbPrec.ItemIndex;             // Anzahl signif. Stellen bei der Beschriftung
      Notation:=TNotation(cbNotation.ItemIndex); // Schreibweise der Zahlen
      DateFormat:=FDateFormat;
      LFont.FontSize:=feLabSize.Value;         // Textgröße
      LabFont:=LFont;
      LnColor:=bbLnColor.Tag;                  // Linienfarbe
      LabDist:=feLabDist.Value;                // Abstand der Beschriftung von der Achse
      LnWidth:=feLnWidth.Value;                // Dicke der Linien
      GrWidth:=feGridWidth.Value;              // Dicke der Raster-Linien
      CTmSize:=2*edTickSize.Value;             // Länge der Grobskalierungsstriche
      FTmSize:=2*edFTickSize.Value;            // Länge der Feinskalierungsstriche
      IvWidth:=edTickWidth.Value;              // Dicke der groben Skalierungsstriche
      TmWidth:=edFTickWidth.Value;             // Dicke der feinen Skalierungsstriche
      if rbInner.Checked then TmStyle:=tmInner // Art der Skalierungsstriche
      else if rbOuter.Checked then TmStyle:=tmOuter
      else if rbBoth.Checked then TmStyle:=tmBoth
      else TmStyle:=tmNone;
      GrStyle:=GridStyle;                      // Stil der Rasterlinien
      AxStyles:=[];
      if cxNoLabels.Checked then Include(AxStyles,asNoText);
      if cxRotate.Checked then Include(AxStyles,asRotate);
      if cxBorder.Checked then Include(AxStyles,asBorder);
      if cxDate.Checked then Include(AxStyles,asDate);
      if cxDayofWeek.Checked then Include(AxStyles,asWeekday);
      if cbHide.Checked then Include(AxStyles,asHidden);
      if cbLess.Checked then Include(AxStyles,asLessTicks);
      if cbLabUnit.Checked then Include(AxStyles,asLabelUnit);
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TAxisDialog.bbLoadTemplateClick(Sender: TObject);
begin
  with OpenDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='*.'+XraExt;
    DefaultExt:=XraExt;
    Filter:=_('R-Plot axis template')+'|*.'+XraExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot axis template');
    if Execute then begin
      FAxis.LoadTemplate(Filename,RpAxTpId,AxisSekt);
      ShowData(FAxis);
      UpdateView;
      LastTemplate:=Filename;
      end;
    end;
  end;

procedure TAxisDialog.bbSaveTemplateClick(Sender: TObject);
begin
  with SaveDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='';
    DefaultExt:=XraExt;
    Filter:=_('R-Plot axis template')+'|*.'+XraExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot axis template');
    if Execute then begin
      SaveData(FAxis);
      FAxis.SaveTemplate(Filename,RpAxTpId,AxisSekt);
      LastTemplate:=Filename;
      end;
    end;
  end;

procedure TAxisDialog.bbTextFormatClick(Sender: TObject);
var
  s : string;
begin
  with LastEdit do begin
    s:=SelText;
    if EditTextFormat(BottomRightPos(bbTextFormat),s) then begin
      SelText:=s; SetFocus;
      end;
    end;
  end;

function TAxisDialog.Execute (AAxis : TAxisItem) : boolean;
var
  i,n   : integer;
  ids   : array of integer;
  s     : string;
  metr  : boolean;
  ai    : TChartItem;
begin
  FAxis:=TAxisItem.CreateFrom(AAxis);
  with AAxis do begin
    if AxType=atHorz then s:=_('X axis') else s:=_('Y axis');
    if IsNew then s:=TryFormat(_('Create %s for %s'),[s,ParentChart.ChartDesc])
    else s:=GetItemName(itAxis)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
    metr:=AAxis.ParentChart.ParentSheet.PlotUnit=puMetric;
    IsTimeScale:=ScaleType=stTime;
    end;
  Caption:=s;
  if metr then s:='cm' else s:='inch';
  for i:=0 to ComponentCount-1 do if Components[i] is TFloatRangeEdit then
      with (Components[i] as TFloatRangeEdit) do begin
    if metr then with MetricRanges[Tag] do begin
      Decimal:=Dec; MinValue:=Min; MaxValue:=Max;
      end
    else with InchRanges[Tag] do begin
      Decimal:=Dec; MinValue:=Min; MaxValue:=Max;
      end;
    end;
  for i:=0 to ComponentCount-1 do if (Components[i] is TLabel) and (Components[i].Tag=1) then
    (Components[i] as TLabel).Caption:=s;
  cbLabel.Clear;
  with AAxis.Labels do for i:=0 to Count-1 do begin
    s:=Trim(Strings[i]);
    if length(s)>0 then cbLabel.Items.Add(s);
    end;
  LastEdit:=edCaption;
  ValErr:=false;
  ShowData(AAxis);
  UpdateView;
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then begin
    SaveData(AAxis);
    with AAxis do begin
      i:=ItemID;
      with ParentChart do begin
        SetLength(ids,ItemCount); n:=0;
        ai:=GetFirstItem(itCurve); // Datenkurven mit dieser Achse suchen
        while assigned(ai) do with ai as TCurveItem do begin
          if (XAxID=i) or (YAxID=i) then begin
            ids[n]:=ItemID; inc(n);
            end;
          ai:=GetNextItem(itCurve);
          end;
        if n>0 then begin
          ai:=GetFirstItem(itFit);
          while assigned(ai) do with ai as TFitItem do begin
            for i:=0 to n-1 do if CurveID=ids[i] then begin
              FitData.Computed:=false;
              if AxType=atVert then begin
                Precision:=cbPrec.ItemIndex;
                YUnit:=AUnit;
                end
              else XUnit:=AUnit;
              end;
            ai:=GetNextItem(itFit);
            end;
          end;
        ids:=nil;
        ai:=GetFirstItem(itGraph); // Histogramme mit dieser Achse suchen
        while assigned(ai) do with ai as TGraphItem do begin
          if (GraphType=gtHisto) and (XAxID=i) then HistData.Computed:=false;
          ai:=GetNextItem(itCurve);
          end;
        end;
      end;
    end;
  FAxis.Free;
  end;

end.

