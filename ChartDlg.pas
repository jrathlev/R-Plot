(* RPlot dialog
   Edit chart properties

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

unit ChartDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, NumberEd, RPlotObjects,
  RPlotUtils, Vcl.Dialogs;

type
  TChartDialog = class(TForm)
    gbPosition: TGroupBox;
    edDesc: TLabeledEdit;
    Label2: TLabel;
    feWidth: TFloatRangeEdit;
    feHeight: TFloatRangeEdit;
    Label1: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    feLeft: TFloatRangeEdit;
    Label3: TLabel;
    feBottom: TFloatRangeEdit;
    Label4: TLabel;
    laUnit: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    bbLoadTemplate: TBitBtn;
    bbSaveTemplate: TBitBtn;
    cbShow: TCheckBox;
    gbColor: TGroupBox;
    cbTransparent: TCheckBox;
    ColorDialog: TColorDialog;
    gbBorder: TGroupBox;
    Label7: TLabel;
    feLnWidth: TFloatRangeEdit;
    laUnit3: TLabel;
    cbBorder: TCheckBox;
    Label5: TLabel;
    cxStyle: TComboBox;
    Label6: TLabel;
    bbLineColor: TBitBtn;
    shBackground: TShape;
    bbBgColor: TBitBtn;
    gbSpace: TGroupBox;
    edHorzChartSpace: TFloatRangeEdit;
    laUnitD: TLabel;
    Label9: TLabel;
    edVertChartSpace: TFloatRangeEdit;
    Label8: TLabel;
    Label10: TLabel;
    gbBoundary: TGroupBox;
    edHorzAxisSpace: TFloatRangeEdit;
    laUnitL: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edVertAxisSpace: TFloatRangeEdit;
    Label13: TLabel;
    gbSize: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbLoadTemplateClick(Sender: TObject);
    procedure bbSaveTemplateClick(Sender: TObject);
    procedure bbBgColorClick(Sender: TObject);
    procedure cbBorderClick(Sender: TObject);
    procedure bbLnColorClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FIniName,
    LastTemplate     : string;
    FChart           : TChart;
    BitMap           : TBitMap;
    procedure ShowData (AChart : TChart);
    procedure SaveData (AChart : TChart);
    procedure UpdateView;
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    procedure LoadFromIni (const AIniName : string);
    function Execute (New : boolean; AChart : TChart) : boolean;
  end;

var
  ChartDialog: TChartDialog;

implementation

{$R *.dfm}

uses GnuGetText, IniFiles, WinUtils;

const
  BitMapHeight=8;
{ ------------------------------------------------------------------- }
procedure TChartDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLineColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  LastTemplate:='';
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TChartDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TChartDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (ChartSekt,IniLeft,Left);
    Top:=ReadInteger (ChartSekt,IniTop,Top);
    LastTemplate:=ReadString(ChartSekt,iniTpl,'');
    Free;
    end;
  end;

procedure TChartDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (ChartSekt,IniLeft,Left);
    WriteInteger (ChartSekt,IniTop,Top);
    WriteString(ChartSekt,iniTpl,LastTemplate);
    Free;
    end;
  Bitmap.Free;
  end;

{ ------------------------------------------------------------------- }
procedure TChartDialog.UpdateView;
var
  i : integer;
begin
  with gbBorder do for i:=0 to ControlCount-1 do if not (Controls[i] is TCheckBox) then
    Controls[i].Visible:=cbBorder.Checked;
  with bbBgColor do begin
    Enabled:=not cbTransparent.Checked;
    with shBackground.Brush do begin
      Style:=bsSolid;
      if Enabled then Color:=bbBgColor.Tag
      else Color:=FChart.ParentSheet.SheetColor;
      end
    end;
  with shBackground.Pen do if cbBorder.Checked then Style:=psSolid else Style:=psClear;
  end;

procedure TChartDialog.bbBgColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbBgColor.Tag;
    if Execute then begin
      bbBgColor.Tag:=Color;
      shBackground.Brush.Color:=Color;
      end;
    end;
  end;

procedure TChartDialog.cbBorderClick(Sender: TObject);
begin
  UpdateView;
  end;

procedure TChartDialog.ShowData (AChart : TChart);
begin
  with AChart do begin
    edDesc.Text:=ChartDesc;
    with Area do begin
      feLeft.Value:=Left; feBottom.Value:=Bottom;
      feWidth.Value:=Width; feHeight.Value:=Height;
      end;
    edHorzChartSpace.Value:=XChartSpace;
    edVertChartSpace.Value:=YChartSpace;
    edHorzAxisSpace.Value:=XAxisSpace;
    edVertAxisSpace.Value:=YAxisSpace;
    cbShow.Checked:=Visible;
    cbTransparent.Checked:=ChartColor<0;
    with bbBgColor do begin
      if ChartColor>=0 then Tag:=ChartColor else Tag:=ParentSheet.Properties.FBakColor;
      end;
    with Border do begin
      cbBorder.Checked:=Visible;
      feLnWidth.Value:=LnWidth;
      FillBtnGlyph(Bitmap,bbLineColor,LColor);
      shBackground.Pen.Color:=Tag;
      cxStyle.ItemIndex:=integer(LStyle)-1;
      end;
    end;
  end;

procedure TChartDialog.SaveData (AChart : TChart);
var
  cb : TChartBorder;
begin
  with AChart do begin
    ChartDesc:=edDesc.Text;
    Area:=FloatArea(feLeft.Value,feBottom.Value,feWidth.Value,feHeight.Value);
    XChartSpace:=edHorzChartSpace.Value;
    YChartSpace:=edVertChartSpace.Value;
    XAxisSpace:=edHorzAxisSpace.Value;
    YAxisSpace:=edVertAxisSpace.Value;
    if cbTransparent.Checked then ChartColor:=-1
    else ChartColor:=bbBgColor.Tag;
    Visible:=cbShow.Checked;
    with cb do begin
      Visible:=cbBorder.Checked;
      LnWidth:=feLnWidth.Value;
      LColor:=bbLineColor.Tag;
      LStyle:=TLineStyle(cxStyle.ItemIndex+1);
      end;
    Border:=cb;
    SetAxesOffset(atHorz,YAxisSpace);
    SetAxesOffset(atVert,XAxisSpace);
    end;
  end;

procedure TChartDialog.bbLnColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbLineColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbLineColor,Color);
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TChartDialog.bbLoadTemplateClick(Sender: TObject);
begin
  with OpenDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='*.'+XrdExt;
    DefaultExt:=XrdExt;
    Filter:=_('R-Plot chart template')+'|*.'+XrdExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot chart template');
    if Execute then begin
      FChart.LoadTemplate(Filename,RpChTpId);
      ShowData(FChart);
      LastTemplate:=Filename;
      UpdateView;
      end;
    end;
  end;

procedure TChartDialog.bbSaveTemplateClick(Sender: TObject);
begin
  with SaveDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='';
    DefaultExt:=XrdExt;
    Filter:=_('R-Plot chart template')+'|*.'+XrdExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot chart template');
    if Execute then begin
      SaveData(FChart);
      FChart.SaveTemplate(Filename,RpChTpId);
      LastTemplate:=Filename;
      end;
    end;
  end;

function TChartDialog.Execute (New : boolean; AChart : TChart) : boolean;
var
  i    : integer;
  s    : string;
  metr : boolean;
begin
  if New then Caption:=_('Create new chart') else Caption:=_('Edit chart');
  FChart:=AChart;
  with AChart do begin
    metr:=ParentSheet.PlotUnit=puMetric;
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
    end;
  for i:=0 to ComponentCount-1 do if (Components[i] is TLabel) and (Components[i].Tag=1) then
    (Components[i] as TLabel).Caption:=s;
  ShowData(AChart);
  UpdateView;
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then SaveData(AChart);
  end;

end.
