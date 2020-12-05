(* RPlot dialog
   Edit curve properties

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

unit CurveDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs,
  NumberEd, Vcl.ComCtrls, RPlotObjects, RPlotUtils;

type
  TCurveDialog = class(TForm)
    gbErrBars: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    edLineWidth: TFloatRangeEdit;
    edErrorWidth: TFloatRangeEdit;
    gbMarker: TGroupBox;
    sbDot: TSpeedButton;
    sbDiamond: TSpeedButton;
    sbTriangle: TSpeedButton;
    sbSquare: TSpeedButton;
    sbDelta: TSpeedButton;
    sbNoSym: TSpeedButton;
    laSymbolColor: TLabel;
    laSymbolSize: TLabel;
    laSymbolUnit: TLabel;
    edSymbolSize: TFloatRangeEdit;
    rbConnect: TRadioButton;
    rbSpline: TRadioButton;
    ColorDialog: TColorDialog;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    gbXAxis: TGroupBox;
    cbXAxisSelect: TComboBox;
    gbYAxis: TGroupBox;
    cbYAxisSelect: TComboBox;
    sbCircle: TSpeedButton;
    sbODiamond: TSpeedButton;
    sbOTriangle: TSpeedButton;
    sbOSquare: TSpeedButton;
    sbODelta: TSpeedButton;
    sbPlus: TSpeedButton;
    sbCross: TSpeedButton;
    gbConn: TGroupBox;
    rbNoLine: TRadioButton;
    laSmooth: TLabel;
    cbXErr: TCheckBox;
    cbYErr: TCheckBox;
    edDescription: TLabeledEdit;
    bbData: TBitBtn;
    cbShow: TCheckBox;
    bbLoadTemplate: TBitBtn;
    bbSaveTemplate: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label2: TLabel;
    cxStyle: TComboBox;
    Label1: TLabel;
    bbSymBolColor: TBitBtn;
    bbErrColor: TBitBtn;
    Label3: TLabel;
    bbLineColor: TBitBtn;
    cxYRange: TCheckBox;
    cxXRange: TCheckBox;
    reSmooth: TRangeEdit;
    udSmooth: TNumUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbSymBolColorClick(Sender: TObject);
    procedure bbLineColorClick(Sender: TObject);
    procedure bbErrColorClick(Sender: TObject);
    procedure rbSplineClick(Sender: TObject);
    procedure rbConnectClick(Sender: TObject);
    procedure rbNoLineClick(Sender: TObject);
    procedure Update(Sender: TObject);
    procedure reSmoothChange(Sender: TObject);
    procedure bbDataClick(Sender: TObject);
    procedure bbLoadTemplateClick(Sender: TObject);
    procedure bbSaveTemplateClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbXAxisSelectCloseUp(Sender: TObject);
  private
    { Private-Deklarationen }
    FIniName,
    LastTemplate,
    DataTitle    : string;
    FCurve       : TCurveItem;
    FDataTable   : TDataTable;
    Bitmap       : TBitmap;
    FJoinMode    : TJoinMode;
    FTimeSeries,
    DataChanged  : boolean;
    procedure ShowData(ACurve : TCurveItem);
    procedure SaveData(ACurve : TCurveItem);
    procedure ShowAxis(ComboBox : TComboBox; AItemID : integer);
    procedure ShowParameter;
    procedure UpdateView;
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    procedure LoadFromIni (const AIniName : string);
    function Execute (ACurve : TCurveItem) : boolean;
  end;

var
  CurveDialog: TCurveDialog;

implementation

{$R *.dfm}

uses GnuGetText, WinUtils, ExtSysUtils, MathUtils, RWinFit, DataDlg,
  System.IniFiles, System.Math;

{ ------------------------------------------------------------------- }
const
  BitMapHeight=8;

procedure TCurveDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  if not Assigned(Bitmap) then BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLineColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  LastTemplate:='';
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TCurveDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TCurveDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (CurveSekt,IniLeft,Left);
    Top:=ReadInteger (CurveSekt,IniTop,Top);
    LastTemplate:=ReadString(CurveSekt,iniTpl,'');
    Free;
    end;
  end;

procedure TCurveDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  wc : TWinControl;
  s  : string;
begin
  if (ModalResult=mrOK) then begin
    CanClose:=(cbXAxisSelect.ItemIndex>0) and (cbYAxisSelect.ItemIndex>0);
    if not CanClose then begin
      if cbXAxisSelect.ItemIndex=0 then begin
        wc:=cbXAxisSelect; s:='X';
        end
      else begin
        wc:=cbYAxisSelect; s:='Y';
        end;
      ErrorDialog(TopRightPos(wc),TryFormat(_('Please select an axis for %s'),[s]));
      wc.SetFocus;
      end;
    end;
  end;

procedure TCurveDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (CurveSekt,IniLeft,Left);
    WriteInteger (CurveSekt,IniTop,Top);
    WriteString(CurveSekt,iniTpl,LastTemplate);
    Free;
    end;
  BitMap.Free;
  end;

{ ------------------------------------------------------------------- }
procedure TCurveDialog.UpdateView;
begin
  edSymbolSize.Visible:=not sbNoSym.Down;
  laSymbolSize.Visible:=edSymbolSize.Visible;
  laSymbolUnit.Visible:=edSymbolSize.Visible;
  laSymbolColor.Visible:=edSymbolSize.Visible;
  bbSymbolColor.Visible:=edSymbolSize.Visible;
  ShowParameter;
  end;

procedure TCurveDialog.Update(Sender: TObject);
begin
  UpdateView;
  end;

procedure TCurveDialog.bbErrColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbErrColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbErrColor,Color);
    end;
  end;

procedure TCurveDialog.bbLineColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbLineColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbLineColor,Color);
    end;
  end;

procedure TCurveDialog.bbSymBolColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbSymbolColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbSymbolColor,Color);
    end;
  end;

procedure TCurveDialog.cbXAxisSelectCloseUp(Sender: TObject);
var
  id : integer;
begin
  with cbXAxisSelect do if ItemIndex>0 then begin
    id:=integer(Items.Objects[ItemIndex]);
    FTimeSeries:=(FCurve.ParentChart.GetItemFromID(id) as TAxisItem).ScaleType=stTime;
    cbxErr.Visible:=not FTimeSeries;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TCurveDialog.ShowParameter;
begin
  with cxStyle do if FJoinMode=jmLine then Enabled:=true
  else begin
    ItemIndex:=0; Enabled:=false;
    end;
  reSmooth.Hide; udSmooth.Hide; laSmooth.Hide;
  case FJoinMode of
  jmLine : begin
          rbConnect.Checked:=true;
          end;
  jmSpline : begin
          rbSpline.Checked:=true;
          reSmooth.Visible:=true;
          udSmooth.Visible:=true;
          laSmooth.Visible:=true;
          end;
    else begin
      rbNoLine.Checked:=true;
      end;
    end;
  end;

procedure TCurveDialog.rbSplineClick(Sender: TObject);
begin
  FJoinMode:=jmSpline;
  ShowParameter;
  if Active then reSmooth.SetFocus
  end;

procedure TCurveDialog.rbConnectClick(Sender: TObject);
begin
  FJoinMode:=jmLine;
  ShowParameter;
  end;

procedure TCurveDialog.rbNoLineClick(Sender: TObject);
begin
  FJoinMode:=jmNone;
  ShowParameter;
  end;

procedure TCurveDialog.reSmoothChange(Sender: TObject);
begin
  if Visible then with udSmooth do if reSmooth.Value<10 then Increment:=1 else Increment:=5;
  end;

procedure TCurveDialog.bbDataClick(Sender: TObject);
var
  al : boolean;
begin
  DataChanged:=DataDialog.Execute(DataTitle,true,FTimeSeries,al,FDataTable);
  cxXRange.Checked:=(cbXAxisSelect.ItemIndex<>0) and al;
  cxYRange.Checked:=(cbYAxisSelect.ItemIndex<>0) and al;
  end;

{ ------------------------------------------------------------------- }
procedure TCurveDialog.ShowData(ACurve : TCurveItem);
begin
  with ACurve do begin
    edDescription.Text:=Description;
    cbShow.Checked:=Visible;
    with Properties do begin
      case SymType of                  // Form der Markierungen
      stDot       : sbDot.Down:=true;
      stDiamond   : sbDiamond.Down:=true;
      stTriangle  : sbTriangle.Down:=true;
      stSquare    : sbSquare.Down:=true;
      stDelta     : sbDelta.Down:=true;
      stCircle    : sbCircle.Down:=true;
      stODiamond  : sbODiamond.Down:=true;
      stOTriangle : sbOTriangle.Down:=true;
      stOSquare   : sbOSquare.Down:=true;
      stODelta    : sbODelta.Down:=true;
      stPlus      : sbPlus.Down:=true;
      stCross     : sbCross.Down:=true;
      else sbNoSym.Down:=true;
        end;
      edSymbolSize.Value:=SymSize;     // Größe der Punktmarkierungen
      FJoinMode:=JoinMode;             // Verbindungen der Messpunkte
      with cxStyle do if FJoinMode=jmLine then begin
        ItemIndex:=integer(LStyle)-1; Enabled:=true;
        end
      else begin
        ItemIndex:=0; Enabled:=false;
        end;
      cbXErr.Checked:=ebShowX in ErrorBars;  // Fehlerbalken
      cbYErr.Checked:=ebShowY in ErrorBars;
      reSmooth.Value:=SmoothFactor; // Glättung bei Spline
      with udSmooth do begin
        if SmoothFactor<10 then Increment:=1 else Increment:=5;
        end;
      edLineWidth.Value:=LWidth;       // Linienbreite - Linien
      edErrorWidth.Value:=EWidth;      // Linienbreite - Fehlerbalken
      FillBtnGlyph(Bitmap,bbLineColor,LColor);   // Farbe - Linien
      FillBtnGlyph(Bitmap,bbSymbolColor,MColor); // Farbe - Markierungen
      FillBtnGlyph(Bitmap,bbErrColor,EColor);    // Farbe - Fehlerbalken
      end;
    end;
  end;

procedure TCurveDialog.SaveData(ACurve : TCurveItem);
begin
  with ACurve do begin
    Description:=edDescription.Text;
    Visible:=cbShow.Checked;
    with Properties do begin
      if sbDot.Down then SymType:=stDot
      else if sbDiamond.Down then SymType:=stDiamond
      else if sbTriangle.Down then SymType:=stTriangle
      else if sbSquare.Down then SymType:=stSquare
      else if sbDelta.Down then SymType:=stDelta
      else if sbCircle.Down then SymType:=stCircle
      else if sbODiamond.Down then SymType:=stODiamond
      else if sbOTriangle.Down then SymType:=stOTriangle
      else if sbOSquare.Down then SymType:=stOSquare
      else if sbODelta.Down then SymType:=stODelta
      else if sbPlus.Down then SymType:=stPlus
      else if sbCross.Down then SymType:=stCross
      else SymType:=stNone;
      SymSize:=edSymbolSize.Value;     // Größe der Punktmarkierungen
      if (JoinMode<>FJoinMode) or (SmoothFactor<>reSmooth.Value)
          or DataChanged then SplineData.Computed:=false; // neu berechnen
      JoinMode:=FJoinMode;             // Verbindungen der Messpunkte
      LStyle:=TLineStyle(cxStyle.ItemIndex+1);
      ErrorBars:=[];
      if cbXErr.Checked then Include(ErrorBars,ebShowX);    // Fehlerbalken
      if cbYErr.Checked then Include(ErrorBars,ebShowY);
      SmoothFactor:=reSmooth.Value;    // Glättung bei Spline
      LWidth:=edLineWidth.Value;       // Linienbreite - Linien
      EWidth:=edErrorWidth.Value;      // Linienbreite - Fehlerbalken
      LColor:=bbLineColor.Tag;         // Farbe - Linien
      MColor:=bbSymbolColor.Tag;       // Farbe - Markierungen
      EColor:=bbErrColor.Tag           // Farbe - Fehlerbalken
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TCurveDialog.bbLoadTemplateClick(Sender: TObject);
begin
  with OpenDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='*.'+XrcExt;
    DefaultExt:=XrcExt;
    Filter:=_('R-Plot data curve template')+'|*.'+XrcExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot data curve template');
    if Execute then begin
      FCurve.LoadTemplate(Filename,RpCuTpId,CurveSekt);
      ShowData(FCurve);
      UpdateView;
      LastTemplate:=Filename;
      end;
    end;
  end;

procedure TCurveDialog.bbSaveTemplateClick(Sender: TObject);
begin
  with SaveDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='';
    DefaultExt:=XrcExt;
    Filter:=_('R-Plot data curve template')+'|*.'+XrcExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot data curve template');
    if Execute then begin
      SaveData(FCurve);
      FCurve.SaveTemplate(Filename,RpCuTpId,CurveSekt);
      LastTemplate:=Filename;
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TCurveDialog.ShowAxis(ComboBox : TComboBox; AItemID : integer);
var
  i : integer;
begin
  with ComboBox do begin
    for i:=0 to Items.Count-1 do if integer(Items.Objects[i])=AItemID then begin
      ItemIndex:=i; Exit;
      end;
    ItemIndex:=0;
    end;
  end;

{ ------------------------------------------------------------------- }
function TCurveDialog.Execute (ACurve : TCurveItem) : boolean;
var
  i,np : integer;
  s    : string;
  metr : boolean;
  ai   : TChartItem;
  x    : double;
  pmin,pmax: TFPoint;     // Min und Max
begin
  FCurve:=TCurveItem.CreateFrom(ACurve);
  with ACurve do begin
    FDataTable:=DataTable;
    metr:=ParentChart.ParentSheet.PlotUnit=puMetric;
    end;
  DataChanged:=false;
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
  cxXRange.Checked:=false; cxYRange.Checked:=false; FTimeSeries:=false;
  with ACurve do begin
    DataTitle:=TryFormat(_('%s of %s'),[Description,ParentChart.ChartDesc]);
    if IsNew then Caption:=TryFormat(_('Create %s for %s'),[_('Curve'),ParentChart.ChartDesc])
    else Caption:=GetItemName(itCurve)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
    with ParentChart do begin
      with cbXAxisSelect do begin
        Clear;
        AddItem(_('<not selected>'),nil);
        end;
      with cbYAxisSelect do begin
        Clear;
        AddItem(_('<not selected>'),nil);
        end;
      ai:=GetFirstItem(itAxis);
      while assigned(ai) do with ai as TAxisItem do begin
        if AxType=atHorz then begin
          cbXAxisSelect.AddItem(Description,pointer(ItemID));
          if (XAxID=ItemID) then FTimeSeries:=ScaleType=stTime;
          end
        else cbYAxisSelect.AddItem(Description,pointer(ItemID));
        ai:=GetNextItem(itAxis);
        end;
      end;
    ShowAxis(cbXAxisSelect,XAxID); ShowAxis(cbYAxisSelect,YAxID);
    end;
  cbxErr.Visible:=not FTimeSeries;
  ShowData(ACurve);
  UpdateView;
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then begin
    SaveData(ACurve);
    with ACurve do begin
      with cbXAxisSelect do if ItemIndex>0 then begin
        DataChanged:=DataChanged or (XAxID<>integer(Items.Objects[ItemIndex]));
        XAxID:=integer(Items.Objects[ItemIndex]);
        end;
      with cbYAxisSelect do if ItemIndex>0 then begin
        DataChanged:=DataChanged or (YAxID<>integer(Items.Objects[ItemIndex]));
        YAxID:=integer(Items.Objects[ItemIndex]);
        end;
      DataTable:=FDataTable;
      FDataTable.Data:=nil;
      np:=ItemID;
      if DataChanged then with ParentChart do begin  // Ausgleichskurven suchen
        ai:=GetFirstItem(itFit);
        while assigned(ai) do with ai as TFitItem do begin
          if CurveID=np then FitData.Computed:=false;
          ai:=GetNextItem(itFit);
          end;
       end;
      if (cxXRange.Checked or cxYRange.Checked) and (DataTable.Count>1) then begin
        ResetMinMax(pmin,pmax);
        with DataTable do for i:=0 to Count-1 do MinMax(Data[i].Val,pmin,pmax);
        end;
      if cxXRange.Checked and (DataTable.Count>1) then begin
        with ParentChart.Item[ParentChart.IndexOf(XAxID)] as TAxisItem do begin
          x:=0.05*(pmax.X-pmin.X);
          MinVal:=pmin.X-x; MaxVal:=pmax.X+x;
          if (ScaleType=stLin) then begin
            with Properties do begin
              GridWidth:=GetGrid; GridTicks:=GetFGrid(GridWidth);
              end;
            AlignLimits;
            end;
          end;
        end;
      if cxYRange.Checked and (DataTable.Count>1) then begin
        with ParentChart.Item[ParentChart.IndexOf(YAxID)] as TAxisItem do begin
          x:=0.05*(pmax.Y-pmin.Y);
          MinVal:=pmin.Y-x; MaxVal:=pmax.Y+x;
          if ScaleType=stLin then begin
            with Properties do begin
              GridWidth:=GetGrid; GridTicks:=GetFGrid(GridWidth);
              end;
            AlignLimits;
            end;
          end;
        end;
      end;
    end;
  FCurve.Free;
  end;

end.
