(* RPlot dialog
   Edit graph properties

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

unit GraphDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs,
  RPlotObjects, RPlotUtils, NumberEd, Vcl.ComCtrls;

type
  TGraphDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    edDescription: TLabeledEdit;
    gbXAxis: TGroupBox;
    cbXAxisSelect: TComboBox;
    gbYAxis: TGroupBox;
    cbYAxisSelect: TComboBox;
    cbShow: TCheckBox;
    bbLoadTemplate: TBitBtn;
    bbSaveTemplate: TBitBtn;
    gbDesign: TGroupBox;
    edLineWidth: TFloatRangeEdit;
    Label6: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    laBakCol: TLabel;
    cbTrans: TCheckBox;
    ColorDialog: TColorDialog;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    pcSubType: TPageControl;
    tsBar: TTabSheet;
    tsHisto: TTabSheet;
    paBottom: TPanel;
    pcType: TPageControl;
    tsScaled: TTabSheet;
    tsPie: TTabSheet;
    paTop: TPanel;
    gbPie: TGroupBox;
    bbData: TBitBtn;
    bbLineColor: TBitBtn;
    bbBgColor: TBitBtn;
    shBackground: TShape;
    Label1: TLabel;
    Label3: TLabel;
    edBarWidth: TFloatRangeEdit;
    Label4: TLabel;
    Label7: TLabel;
    edBarOffset: TFloatRangeEdit;
    Label8: TLabel;
    Label9: TLabel;
    reStripes: TRangeEdit;
    cxXRange: TCheckBox;
    cxYRange: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbLoadTemplateClick(Sender: TObject);
    procedure bbSaveTemplateClick(Sender: TObject);
    procedure bbDataClick(Sender: TObject);
    procedure bbLineColorClick(Sender: TObject);
    procedure bbBgColorClick(Sender: TObject);
    procedure cbTransClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private-Deklarationen }
    FIniName,
    LastTemplate : string;
    FGraph       : TGraphItem;
    FDataTable   : TDataTable;
    Bitmap       : TBitmap;
    procedure UpdateView;
    procedure ShowData(AGraph : TGraphItem);
    procedure SaveData(AGraph : TGraphItem);
    procedure ShowAxis(ComboBox : TComboBox; AItemID : integer);
  public
    { Public-Deklarationen }
    procedure LoadFromIni (const AIniName : string);
    function Execute (AGraph : TGraphItem) : boolean;
  end;

var
  GraphDialog: TGraphDialog;

implementation

{$R *.dfm}

uses GnuGetText, ExtSysUtils, WinUtils, System.IniFiles, DataDlg;

{ ------------------------------------------------------------------- }
const
  BitMapHeight=8;

procedure TGraphDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

procedure TGraphDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  if not Assigned(Bitmap) then BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLineColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  LastTemplate:='';
  end;

procedure TGraphDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (CurveSekt,IniLeft,Left);
    Top:=ReadInteger (CurveSekt,IniTop,Top);
    LastTemplate:=ReadString(CurveSekt,iniTpl,'');
    Free;
    end;
  end;

procedure TGraphDialog.FormDestroy(Sender: TObject);
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
procedure TGraphDialog.UpdateView;
begin
  with bbBgColor do begin
    Enabled:=not cbTrans.Checked;
    laBakCol.Visible:=Visible;
    with shBackground.Brush do if Enabled then begin
      Style:=bsSolid; Color:=bbBgColor.Tag;
      end
    else Style:=bsClear;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TGraphDialog.ShowData(AGraph : TGraphItem);
begin
  with AGraph do begin
    edDescription.Text:=Description;
    cbShow.Checked:=Visible;
    with Properties do begin
      edLineWidth.Value:=LWidth;                 // Linienbreite - Linien
      FillBtnGlyph(Bitmap,bbLineColor,LColor);   // Farbe - Linien
      cbTrans.Checked:=Transparent;
      bbBgColor.Tag:=BColor;                     // Farbe - Hintergrund
      shBackground.Pen.Color:=LColor;
      if GraphType=gtPie then begin      // Torte
        pcType.ActivePageIndex:=1;
        end
      else begin
        pcType.ActivePageIndex:=0;
        if GraphType=gtBar then begin    // Balken
          pcSubType.ActivePageIndex:=0;
          edBarWidth.Value:=BWidth;
          edBarOffset.Value:=BOffset;
          end
        else begin  // Histogramm
          pcSubType.ActivePageIndex:=1;
          reStripes.Value:=Stripes;
          end
        end;
      end;
    end;
  end;

procedure TGraphDialog.SaveData(AGraph : TGraphItem);
begin
  with AGraph do begin
    Description:=edDescription.Text;
    Visible:=cbShow.Checked;
    with Properties do begin
      LWidth:=edLineWidth.Value;              // Linienbreite - Linien
      LColor:=bbLineColor.Tag;                // Farbe - Linien
      Transparent:=cbTrans.Checked;
      BColor:=bbBgColor.Tag;                  // Farbe - Hintergrund
      if GraphType=gtPie then begin           // Torte
        end
      else if GraphType=gtBar then begin      // Balken
        BWidth:=edBarWidth.Value;
        BOffset:=edBarOffset.Value;
        end
      else with reStripes do begin                 // Histogramm
        Stripes:=Value;
        if Modified then HistData.Computed:=false
        end;
      end;
    end;
  end;

procedure TGraphDialog.bbBgColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbBgColor.Tag;
    if Execute then begin
      bbBgColor.Tag:=Color;
      shBackground.Brush.Color:=Color;
      end;
    end;
  end;

procedure TGraphDialog.bbLineColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbLineColor.Tag;
    if Execute then begin
      FillBtnGlyph(Bitmap,bbLineColor,Color);
      shBackground.Pen.Color:=Color;
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TGraphDialog.bbDataClick(Sender: TObject);
var
  al : boolean;
begin
  DataDialog.Execute(FGraph.Description,false,false,al,FDataTable);
  cxXRange.Checked:=(cbXAxisSelect.ItemIndex<>0) and al;
  cxYRange.Checked:=(cbYAxisSelect.ItemIndex<>0) and al;
  end;

procedure TGraphDialog.bbLoadTemplateClick(Sender: TObject);
begin
  with OpenDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='*.'+XrgExt;
    DefaultExt:=XrgExt;
    Filter:=_('R-Plot graph template')+'|*.'+XrgExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot graph template');
    if Execute then begin
      FGraph.LoadTemplate(Filename,RpGrTpId,GraphSekt);
      ShowData(FGraph);
      UpdateView;
      LastTemplate:=Filename;
      end;
    end;
  end;

procedure TGraphDialog.bbSaveTemplateClick(Sender: TObject);
begin
  with SaveDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='';
    DefaultExt:=XrgExt;
    Filter:=_('R-Plot graph template')+'|*.'+XrgExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot graph template');
    if Execute then begin
      SaveData(FGraph);
      FGraph.SaveTemplate(Filename,RpGrTpId,GraphSekt);
      LastTemplate:=Filename;
      end;
    end;
  end;

procedure TGraphDialog.cbTransClick(Sender: TObject);
begin
  UpdateView;
  end;

{ ------------------------------------------------------------------- }
procedure TGraphDialog.ShowAxis(ComboBox : TComboBox; AItemID : integer);
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
function TGraphDialog.Execute (AGraph : TGraphItem) : boolean;
var
  i    : integer;
  s    : string;
  metr : boolean;
  ai   : TChartItem;
  x    : double;
  n    : cardinal;
  pmin,pmax: TFPoint;     // Min und Max
begin
  FGraph:=TGraphItem.CreateFrom(AGraph);
  FDataTable:=AGraph.DataTable;
  metr:=AGraph.ParentChart.ParentSheet.PlotUnit=puMetric;
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
  cxXRange.Checked:=false; cxYRange.Checked:=false;
  with AGraph do begin
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
          end
        else cbYAxisSelect.AddItem(Description,pointer(ItemID));
        ai:=GetNextItem(itAxis);
        end;
      end;
    ShowAxis(cbXAxisSelect,XAxID); ShowAxis(cbYAxisSelect,YAxID);
    if GraphType=gtPie then begin
      edDescription.EditLabel.Caption:=_('Name of pie chart:');
      s:=_('Pie chart')       // Torte
      end
    else if GraphType=gtBar then begin
      edDescription.EditLabel.Caption:=_('Name of bar graph:');
      s:=_('Bar graph');  // Balken
      end
    else begin
      edDescription.EditLabel.Caption:=_('Name of histogram:');
      s:=_('Histogram');
      end;
    if IsNew then Caption:=TryFormat(_('Create %s for %s'),[s,ParentChart.ChartDesc])
    else Caption:=GetItemName(itGraph,GraphType)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
    end;
  ShowData(AGraph);
  UpdateView;
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then begin
    SaveData(AGraph);
    with AGraph do begin
      with cbXAxisSelect do if ItemIndex>0 then XAxID:=integer(Items.Objects[ItemIndex]);
      with cbYAxisSelect do if ItemIndex>0 then YAxID:=integer(Items.Objects[ItemIndex]);
      AGraph.DataTable:=FDataTable;
      FDataTable.Data:=nil;
      if (cxXRange.Checked or cxYRange.Checked) and (DataTable.Count>1) then begin
        ResetMinMax(pmin,pmax);
        with DataTable do for i:=0 to Count-1 do MinMax(Data[i].Val,pmin,pmax);
        if GraphType=gtHisto then begin
          if cxXRange.Checked then begin
            with ParentChart.Item[ParentChart.IndexOf(XAxID)] as TAxisItem do begin
              x:=0.01*(pmax.X-pmin.X);
              MinVal:=pmin.X-x; MaxVal:=pmax.X+x;
              if ScaleType=stLin then begin
                with Properties do begin
                  GridWidth:=GetGrid; GridTicks:=GetFGrid(GridWidth);
                  end;
                AlignLimits;
                with ParentChart.InnerArea do InitScale(FloatRect(Left,Bottom,Left+Width,Bottom+Height));
                end;
              end;
            end;
          if cxYRange.Checked then begin
            HistData.Computed:=false;
            ComputeHistogram;
            n:=0;
            with HistData do for i:=0 to High(Data) do if Data[i]>n then n:=Data[i];
            if n>0 then with ParentChart.Item[ParentChart.IndexOf(YAxID)] as TAxisItem do begin
              x:=0.05*n;
              MinVal:=-x; MaxVal:=n+x;
              if ScaleType=stLin then begin
                with Properties do begin
                  GridWidth:=GetGrid; GridTicks:=GetFGrid(GridWidth);
                  end;
                AlignLimits;
                end;
              end;
            end;
          end
        else begin // bar chart
          if cxXRange.Checked and (DataTable.Count>1) then begin
            with ParentChart.Item[ParentChart.IndexOf(XAxID)] as TAxisItem do begin
              x:=0.05*(pmax.X-pmin.X);
              MinVal:=pmin.X-x; MaxVal:=pmax.X+x;
              if ScaleType=stLin then begin
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
      end;
    end;
  FGraph.Free;
  end;

end.
