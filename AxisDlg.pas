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
   last modified January 2020
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
    Label4: TLabel;
    cbPrec: TComboBox;
    rgType: TRadioGroup;
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
  private
    { Private-Deklarationen }
    FIniName,
    LastTemplate     : string;
    FAxis            : TAxisItem;
    XMin,XMax,XInt,
    AxBegin,AxLength : double;  // Achse in cm/inch
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
    function GetValue (Edit : TEdit) : double;
    procedure UpdateView;
    function GetGrid : double;
    function GetFGrid (Grid  : double) : integer;
  public
    { Public-Deklarationen }
    procedure LoadFromIni (const AIniName : string);
    function Execute (AAxis: TAxisItem) : boolean;
  end;

var
  AxisDialog: TAxisDialog;

implementation

{$R *.dfm}

uses GnuGetText, WinUtils, StringUtils, System.IniFiles, System.Math, NumberUtils,
  MathUtils, ExtSysUtils, PlotFontDlg, DateUtils, SelectFromListDlg, TextFormatDlg;

const
  BitMapHeight=8;

{ ------------------------------------------------------------------- }
procedure TAxisDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLnColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  LastTemplate:=''; GridStyle:=lsNone;
  LabList:=TStringList.Create;
  end;

procedure TAxisDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (AxisSekt,IniLeft,Left);
    Top:=ReadInteger (AxisSekt,IniTop,Top);
    LastTemplate:=ReadString(AxisSekt,iniTpl,'');
    Free;
    end;
  end;

procedure TAxisDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  x : double;
begin
  if ModalResult=mrOK then begin
    x:=GetValue(edMinVal);
    with rgScale do if (ItemIndex=1) or (ItemIndex=2) then CanClose:=(x>0) and (GetValue(edMaxVal)>x)
    else CanClose:=(GetValue(edMaxVal)>x);
    if not CanClose then begin
      ErrorDialog(_('Invalid range selection'));
      edMinVal.SetFocus;
      end;
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
  if rgType.ItemIndex=0 then begin   // horizontal
    rbBottomLeft.Caption:=_('At bottom');
    rbTopRight.Caption:=_('At top');
    end
  else begin                         // vertical
    rbBottomLeft.Caption:=_('At left');
    rbTopRight.Caption:=_('At right');
    end;
  cxRotate.Visible:=rgType.ItemIndex=1;
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
  cbPrec.Visible:=rgScale.ItemIndex<>3;
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

function TryStringToDateTime (s : string; var dt : TDateTime) : boolean;
var
  j1,j2,j3 : integer;
  err : boolean;
begin
  err:=false;
  if Pos('-',s)>0 then begin // mit Datum
    j1:=ReadNxtInt(s,'-',YearOf(Now),err);
    j2:=ReadNxtInt(s,'-',MonthOf(Now),err);
    j3:=ReadNxtInt(s,' ',DayOf(Now),err);
    try dt:=EncodeDate(j1,j2,j3); except err:=true; end;
    end
  else dt:=0;
  if not err then begin  // Zeit
    j1:=ReadNxtInt(s,':',HourOf(Now),err);
    j2:=ReadNxtInt(s,':',MinuteOf(Now),err);
    j3:=ReadNxtInt(s,'.',SecondOf(Now),err);
    dt:=dt+j1*OneHour+j2*OneMinute+j3*OneSecond;
    end;
  Result:=not err;
  end;

function TAxisDialog.GetValue (Edit : TEdit) : double;
var
  ok : boolean;
  dt : TDateTime;
begin
  if ModalResult=mrCancel then Exit;
  with Edit do if rgScale.ItemIndex=3 then begin
    ok:=TryStringToDateTime(Text,dt);  // Datum,Zeit
    Result:=dt;
    end
  else ok:=TryStrToFloat(Text,Result);
  if not ok then begin
    Result:=Edit.Tag;
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
  xa:=XMax-XMin; //GetValue(edMaxVal)-GetValue(edMinVal);
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
  xa:=XMax-XMin; //GetValue(edMaxVal)-GetValue(edMinVal);
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

procedure TAxisDialog.bbCapFontClick(Sender: TObject);
begin
  EditPlotFont(BottomLeftPos(bbCapFont),CFont);
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
  XMax:=GetValue(edMaxVal);
  end;

procedure TAxisDialog.edMinValExit(Sender: TObject);
begin
  XMin:=GetValue(edMinVal);
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
    rgType.ItemIndex:=integer(AxType);
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
    XMin:=MinVal; XMax:=MaxVal;
    rgScale.ItemIndex:=integer(ScaleType);     // Skalierung (lin, log, reziprok oder Zeit)
    edMinVal.Text:=SetValue(MinVal); edMaxVal.Text:=SetValue(MaxVal);
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
    AxType:=TAxisType(rgType.ItemIndex);
    MinVal:=GetValue(edMinVal); MaxVal:=GetValue(edMaxVal);   // Bereich
    ScaleType:=TScaleType(rgScale.ItemIndex);     // Skalierung (lin, log, reziprok oder Zeit)
    if ScaleType=stLin then begin
      if TryStrToFloat(edInterval.Text,XInt) then begin
        i:=round(abs(MaxVal-MInVal)/XInt);
        if (i>50) or (i<1) then XInt:=GetGrid;
        end
      else  XInt:=GetGrid;
      GridWidth:=XInt;
      GridTicks:=udTicks.Position;
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

