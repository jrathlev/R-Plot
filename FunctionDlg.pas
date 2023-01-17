(* RPlot dialog
   Edit function properties

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

unit FunctionDlg;

interface

// 20+15*sin(36*x)

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.ComCtrls,
  NumberEd, RPlotObjects, RPlotUtils, MathExp;

type
  TFunctionDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    gbFormula: TGroupBox;
    Label15: TLabel;
    edFormula: TEdit;
    gbLine: TGroupBox;
    laUnit: TLabel;
    edLineWidth: TFloatRangeEdit;
    cbShow: TCheckBox;
    edDescription: TLabeledEdit;
    gbXAxis: TGroupBox;
    cbXAxisSelect: TComboBox;
    gbYAxis: TGroupBox;
    cbYAxisSelect: TComboBox;
    ColorDialog: TColorDialog;
    bbLoadTemplate: TBitBtn;
    bbSaveTemplate: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    gbFuncRange: TGroupBox;
    FromLabel: TLabel;
    ToLabel: TLabel;
    rbAll: TRadioButton;
    rbRange: TRadioButton;
    buSetMin: TButton;
    buSetMax: TButton;
    edMinFit: TFloatEdit;
    edMaxFit: TFloatEdit;
    laBWidth: TLabel;
    cxStyle: TComboBox;
    bbLineColor: TBitBtn;
    cxYRange: TCheckBox;
    gbAngUnit: TGroupBox;
    cbAngUnit: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bbLineColorClick(Sender: TObject);
    procedure rbAllClick(Sender: TObject);
    procedure rbRangeClick(Sender: TObject);
    procedure bbLoadTemplateClick(Sender: TObject);
    procedure bbSaveTemplateClick(Sender: TObject);
    procedure buSetMinClick(Sender: TObject);
    procedure buSetMaxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FIniName,
    LastTemplate : string;
    Bitmap       : TBitmap;
    FFunction    : TFunctionItem;
    laConsts     : array[0..MaxConst-1] of TLabel;
    edConsts     : array[0..MaxConst-1] of TFloatEdit;
    procedure ShowData(AFunction : TFunctionItem);
    procedure SaveData(AFunction : TFunctionItem);
    procedure ShowAxis(ComboBox : TComboBox; AItemID : integer);
    procedure ShowFuncRange;
    procedure GetConstants (var AConst : TConstArr);
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    procedure LoadFromIni (const AIniName : string);
    function Execute (AFunction : TFunctionItem) : boolean;
  end;

var
  FunctionDialog: TFunctionDialog;

implementation

{$R *.dfm}

uses GnuGetText, ExtSysUtils, WinUtils, MsgDialogs, StringUtils, MathUtils,
  System.IniFiles;

{ ------------------------------------------------------------------- }
const
  BitMapHeight=8;

procedure TFunctionDialog.FormCreate(Sender: TObject);
var
  i : integer;
begin
  TranslateComponent (self);
  if not Assigned(Bitmap) then BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLineColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  for i:=0 to MaxConst-1 do begin
    laConsts[i]:=TLabel.Create(self);
    with laConsts[i] do begin
      Parent:=gbFormula;
      Top:=73; Left:=10+85*i;
      Font.Style:=[fsBold];
      Caption:='';
      end;
    end;
  for i:=0 to MaxConst-1 do begin
    edConsts[i]:=TFloatEdit.Create(self);
    with edConsts[i] do begin
      Parent:=gbFormula;
      Top:=70; Left:=35+85*i; Height:=21; Width:=51;
      Value:=0;
      end;
    end;
  LastTemplate:='';
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TFunctionDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TFunctionDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (FuncSekt,IniLeft,Left);
    Top:=ReadInteger (FuncSekt,IniTop,Top);
    LastTemplate:=ReadString(FuncSekt,iniTpl,'');
    Free;
    end;
  end;

procedure TFunctionDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  y  : double;
  wc : TWinControl;
  s  : string;
  co : TConstArr;
begin
  if (ModalResult=mrOK) then begin
    if (length(Trim(edFormula.Text))>0) then begin   // Check formula
      SetLength(co,MaxConst); GetConstants(co);
      CanClose:=CalcFunction(ReplaceDecSepWithPeriod(edFormula.Text),1,cbAngUnit.ItemIndex,co,y);
      co:=nil;
      if not CanClose then begin
        ErrorDialog(BottomLeftPos(edFormula),_('Syntax error in formula!'));
        edFormula.SetFocus;
        end;
      end;
    if CanClose then begin
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
  end;

procedure TFunctionDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (FuncSekt,IniLeft,Left);
    WriteInteger (FuncSekt,IniTop,Top);
    WriteString(FuncSekt,iniTpl,LastTemplate);
    Free;
    end;
  BitMap.Free;
  end;

{ ------------------------------------------------------------------- }
procedure TFunctionDialog.ShowFuncRange;
begin
  if rbAll.Checked then begin
    FromLabel.Hide; ToLabel.Hide;
    edMinFit.Hide; edMaxFit.Hide;
    buSetMin.Hide; buSetMax.Hide;
    end
  else begin
    FromLabel.Show; ToLabel.Show;
    edMinFit.Show; edMaxFit.Show;
    buSetMin.Show; buSetMax.Show;
    if edMaxFit.Value<=edMinFit.Value then buSetMaxClick(self);
    end;
  end;

procedure TFunctionDialog.rbAllClick(Sender: TObject);
begin
  ShowFuncRange;
  end;

procedure TFunctionDialog.rbRangeClick(Sender: TObject);
begin
  ShowFuncRange;
  if Active then edMinFit.SetFocus;
  end;

procedure TFunctionDialog.buSetMinClick(Sender: TObject);
var
  n : integer;
begin
  with cbXAxisSelect do if ItemIndex>0 then n:=FFunction.ParentChart.IndexOf(integer(Items.Objects[ItemIndex]))
  else n:=-1;
  if n>=0 then edMinFit.Value:=(FFunction.ParentChart.Item[n] as TAxisItem).MinVal;
  end;

procedure TFunctionDialog.buSetMaxClick(Sender: TObject);
var
  n : integer;
begin
  with cbXAxisSelect do if ItemIndex>0 then n:=FFunction.ParentChart.IndexOf(integer(Items.Objects[ItemIndex]))
  else n:=-1;
  if n>=0 then edMaxFit.Value:=(FFunction.ParentChart.Item[n] as TAxisItem).MaxVal;
  end;

procedure TFunctionDialog.bbLineColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbLineColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbLineColor,Color);
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TFunctionDialog.ShowData(AFunction : TFunctionItem);
var
  i : integer;
begin
  with AFunction do begin
    edDescription.Text:=Description;
    cbShow.Checked:=Visible;
    with Properties do begin
      if FuncAll then rbAll.Checked:=true
      else rbRange.Checked:=true;            // Funktion über ges. X-Bereich oder Teil
      edMinFit.Value:=Min;                   // X-Bereich für Funktion
      edMaxFit.Value:=Max;
      edLineWidth.Value:=LWidth;             // Linienbreite - Linien
      cxStyle.ItemIndex:=integer(LStyle)-1;
      FillBtnGlyph(Bitmap,bbLineColor,LColor);  // Farbe - Linien
      cxYRange.Checked:=(length(Formula)=0) and (cbYAxisSelect.ItemIndex<>0);
      cbAngUnit.ItemIndex:=integer(AngularUnit);
      edFormula.Text:=Formula;
      for i:=0 to MaxConst-1 do with Constants[i] do begin   // Konstanten anzeigen
        laConsts[i].Caption:=ConstName+' =';
        edConsts[i].Value:=ConstValue;
        end;
      end;
    end;
  ShowFuncRange;
  end;

procedure TFunctionDialog.GetConstants (var AConst : TConstArr);
var
  i : integer;
begin
  for i:=0 to MaxConst-1 do with AConst[i] do begin
    ConstName:=GetNxtStr(laConsts[i].Caption,' ');
    ConstValue:=edConsts[i].Value;
    end;
  end;

procedure TFunctionDialog.SaveData(AFunction : TFunctionItem);
begin
  with AFunction do begin
    Description:=edDescription.Text;
    Visible:=cbShow.Checked;
    with Properties do begin
      FuncAll:=rbAll.Checked;           // Funktion über ges. X-Bereich oder Teil
      Min:=edMinFit.Value;              // X-Bereich für Funktion
      Max:=edMaxFit.Value;
      LWidth:=edLineWidth.Value;        // Linienbreite - Linien
      LStyle:=TLineStyle(cxStyle.ItemIndex+1);
      LColor:=bbLineColor.Tag;          // Farbe - Linien
      AngularUnit:=TAngularUnit(cbAngUnit.ItemIndex);
      Formula:=edFormula.Text;
      GetConstants(Constants);
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TFunctionDialog.bbLoadTemplateClick(Sender: TObject);
begin
  with OpenDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='*.'+XrfExt;
    DefaultExt:=XrfExt;
    Filter:=_('R-Plot function template')+'|*.'+XrfExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot function template');
    if Execute then begin
      FFunction.LoadTemplate(Filename,RpFuTpId,FuncSekt);
      ShowData(FFunction);
      LastTemplate:=Filename;
      end;
    end;
  end;

procedure TFunctionDialog.bbSaveTemplateClick(Sender: TObject);
begin
  with SaveDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='';
    DefaultExt:=XrfExt;
    Filter:=_('R-Plot function template')+'|*.'+XrfExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot function template');
    if Execute then begin
      SaveData(FFunction);
      FFunction.SaveTemplate(Filename,RpFuTpId,FuncSekt);
      LastTemplate:=Filename;
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TFunctionDialog.ShowAxis(ComboBox : TComboBox; AItemID  : integer);
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
function TFunctionDialog.Execute (AFunction : TFunctionItem) : boolean;
var
  metr : boolean;
  ai   : TChartItem;
  i    : integer;
  x    : double;
  pmin,pmax: TFPoint;     // Min und Max
begin
  FFunction:=TFunctionItem.CreateFrom(AFunction);
  metr:=AFunction.ParentChart.ParentSheet.PlotUnit=puMetric;
  with edLineWidth do begin
    if metr then begin
      Decimal:=2; MinValue:=0.01; MaxValue:=0.5;
      end
    else begin
      Decimal:=3; MinValue:=0.004; MaxValue:=0.2;
      end;
    end;
  with laUnit do if metr then Caption:='cm' else Caption:='inch';
  with AFunction do begin
    if IsNew then Caption:=TryFormat(_('Create %s for %s'),[_('Function'),ParentChart.ChartDesc])
    else Caption:=GetItemName(itFunction)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
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
        if AxType=atHorz then cbXAxisSelect.AddItem(Description,pointer(ItemID))
        else cbYAxisSelect.AddItem(Description,pointer(ItemID));
        ai:=GetNextItem(itAxis);
        end;
      end;
    ShowAxis(cbXAxisSelect,XAxID); ShowAxis(cbYAxisSelect,YAxID);
    end;
  ShowData(AFunction);
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then begin
    SaveData(AFunction);
    with AFunction do begin
      with cbXAxisSelect do if ItemIndex>0 then XAxID:=integer(Items.Objects[ItemIndex]);
      with cbYAxisSelect do if ItemIndex>0 then YAxID:=integer(Items.Objects[ItemIndex]);
      if cxYRange.Checked then begin
        ComputeFunction;
        if FuncData.Computed then begin
          ResetMinMax(pmin,pmax);
          with FuncData do for i:=0 to High(Data) do MinMax(Data[i],pmin,pmax);
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
        end
      else FuncData.Computed:=false;
      end;
    end;
  FFunction.Free;
  end;

end.
