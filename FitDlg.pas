(* RPlot dialog
   Edit fit function properties

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

unit FitDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  NumberEd, RPlotObjects, RPlotUtils, Vcl.Dialogs;

type
  TFitDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    edDescription: TLabeledEdit;
    gbCurve: TGroupBox;
    cxCurveSelect: TComboBox;
    gbFitrange: TGroupBox;
    FromLabel: TLabel;
    ToLabel: TLabel;
    rbAll: TRadioButton;
    rbRange: TRadioButton;
    buSetMin: TButton;
    buSetMax: TButton;
    edMinFit: TFloatEdit;
    edMaxFit: TFloatEdit;
    rgAnzeige: TRadioGroup;
    cbShow: TCheckBox;
    bbLoadTemplate: TBitBtn;
    bbSaveTemplate: TBitBtn;
    gbFitType: TGroupBox;
    rbPoly: TRadioButton;
    rbLinear: TRadioButton;
    edDegree: TEdit;
    laDegree: TLabel;
    udDegree: TUpDown;
    gbLine: TGroupBox;
    laBUnit: TLabel;
    laBWidth: TLabel;
    edLineWidth: TFloatRangeEdit;
    cxStyle: TComboBox;
    bbLineColor: TBitBtn;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    ColorDialog: TColorDialog;
    rgXScale: TRadioGroup;
    rgYScale: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure bbLoadTemplateClick(Sender: TObject);
    procedure bbSaveTemplateClick(Sender: TObject);
    procedure rbLinearClick(Sender: TObject);
    procedure rbPolyClick(Sender: TObject);
    procedure rbAllClick(Sender: TObject);
    procedure rbRangeClick(Sender: TObject);
    procedure buSetMinClick(Sender: TObject);
    procedure buSetMaxClick(Sender: TObject);
    procedure bbLineColorClick(Sender: TObject);
    procedure cxCurveSelectCloseUp(Sender: TObject);
  private
    { Private-Deklarationen }
    FIniName,
    LastTemplate : string;
    FFit         : TFitItem;
    Bitmap       : TBitmap;
    procedure ShowData(AFit : TFitItem);
    procedure SaveData(AFit : TFitItem);
    procedure ShowFitRange;
    procedure ShowFitParameter;
    procedure UpdateView;
  public
    { Public-Deklarationen }
    procedure LoadFromIni (const AIniName : string);
    function Execute (AFit : TFitItem) : boolean;
  end;

var
  FitDialog: TFitDialog;

implementation

{$R *.dfm}

uses GnuGetText, ExtSysUtils, WinUtils, MathUtils, RWinFit, DataDlg, System.IniFiles;


{ ------------------------------------------------------------------- }
const
  BitMapHeight=8;

procedure TFitDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  if not Assigned(Bitmap) then BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLineColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  udDegree.Max:=MaxDegree;
  LastTemplate:='';
  end;

procedure TFitDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (FitSekt,IniLeft,Left);
    Top:=ReadInteger (FitSekt,IniTop,Top);
    LastTemplate:=ReadString(FitSekt,iniTpl,'');
    Free;
    end;
  end;

procedure TFitDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (ModalResult=mrOK) then begin
    CanClose:=cxCurveSelect.ItemIndex>0;
    if not CanClose then begin
      ErrorDialog(TopRightPos(cxCurveSelect),_('Please select the data curve!'));
      cxCurveSelect.SetFocus;
      end;
    end;
  end;

procedure TFitDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (FitSekt,IniLeft,Left);
    WriteInteger (FitSekt,IniTop,Top);
    WriteString(FitSekt,iniTpl,LastTemplate);
    Free;
    end;
  BitMap.Free;
  end;

{ ------------------------------------------------------------------- }
procedure TFitDialog.ShowFitRange;
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
    end;
  end;

procedure TFitDialog.ShowFitParameter;
begin
  if udDegree.Position=1 then rbLinear.Checked:=true
  else rbPoly.Checked:=true;
  edDegree.Visible:=rbPoly.Checked;
  udDegree.Visible:=rbPoly.Checked;
  laDegree.Visible:=rbPoly.Checked;
  gbFitRange.Show;
  rgAnzeige.Visible:=(rgXScale.ItemIndex=0) and (rgYScale.ItemIndex=0)
  end;

procedure TFitDialog.UpdateView;
begin
  ShowFitParameter;
  ShowFitRange;
  end;

{ ------------------------------------------------------------------- }
procedure TFitDialog.rbAllClick(Sender: TObject);
begin
  ShowFitRange;
  end;

procedure TFitDialog.rbLinearClick(Sender: TObject);
begin
  udDegree.Position:=1;
  ShowFitParameter;
  end;

procedure TFitDialog.rbPolyClick(Sender: TObject);
begin
  with udDegree do if Position=1 then Position:=2;
  ShowFitParameter;
  if Active then edDegree.SetFocus
  end;

procedure TFitDialog.rbRangeClick(Sender: TObject);
begin
  ShowFitRange;
  if Active then edMinFit.SetFocus;
  end;

procedure TFitDialog.bbLineColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbLineColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbLineColor,Color);
    end;
  end;

procedure TFitDialog.buSetMaxClick(Sender: TObject);
var
  k,n : integer;
begin
  with FFit.ParentChart do begin
    with cxCurveSelect do if ItemIndex>0 then n:=IndexOf(integer(Items.Objects[ItemIndex]))
    else n:=-1;
    if (n>=0) and (Item[n].ItemType=itCurve)  then begin
      k:=IndexOf((Item[n] as TCurveItem).XAxID);
      if k>=0 then edMaxFit.Value:=(Item[k] as TAxisItem).MaxVal
      else ErrorDialog(_('No assigned axis found!'));
      end
    else ErrorDialog(_('No assigned curve data found!'));
    end;
  end;

procedure TFitDialog.buSetMinClick(Sender: TObject);
var
  k,n : integer;
begin
  with FFit.ParentChart do begin
    with cxCurveSelect do if ItemIndex>0 then n:=IndexOf(integer(Items.Objects[ItemIndex]))
    else n:=-1;
    if (n>=0) and (Item[n].ItemType=itCurve)  then begin
      k:=IndexOf((Item[n] as TCurveItem).XAxID);
      if k>=0 then edMaxFit.Value:=(Item[k] as TAxisItem).MaxVal
      else ErrorDialog(_('No assigned axis found!'));
      end
    else ErrorDialog(_('No assigned curve data found!'));
    end;
  end;

procedure TFitDialog.cxCurveSelectCloseUp(Sender: TObject);
var
  k,n : integer;
  st  : TScaleType;
begin
  with FFit.ParentChart do begin
    with cxCurveSelect do if ItemIndex>0 then n:=IndexOf(integer(Items.Objects[ItemIndex]))
    else n:=-1;
    if (n>=0) and (Item[n].ItemType=itCurve) then begin
      k:=IndexOf((Item[n] as TCurveItem).XAxID);
      if k>=0 then begin
        st:=(Item[k] as TAxisItem).ScaleType;
        if st=stTime then st:=stLin;
        end
      else st:=stLin;
      rgXScale.ItemIndex:=integer(st);
      k:=IndexOf((Item[n] as TCurveItem).YAxID);
      if k>=0 then begin
        st:=(Item[k] as TAxisItem).ScaleType;
        if st=stTime then st:=stLin;
        end
      else st:=stLin;
      rgYScale.ItemIndex:=integer(st);
      end
    end;

  end;

{ ------------------------------------------------------------------- }
procedure TFitDialog.ShowData(AFit : TFitItem);
begin
  with AFit do begin
    edDescription.Text:=Description;
    cbShow.Checked:=Visible;
    with Properties do begin
      rgXScale.ItemIndex:=integer(XScale);
      rgYScale.ItemIndex:=integer(YScale);
      cxStyle.ItemIndex:=integer(LStyle)-1;
      if FitAll then rbAll.Checked:=true
      else rbRange.Checked:=true;            // Fit über alle Daten oder Bereich
      edMinFit.Value:=FitMin;                // X-Bereich für Fit-Funktion
      edMaxFit.Value:=FitMax;
      rgAnzeige.ItemIndex:=integer(ViewAll);
      udDegree.Position:=FitOrder;           // Grad der Pol.-Approximation
      edLineWidth.Value:=LWidth;             // Linienbreite - Linien
      FillBtnGlyph(Bitmap,bbLineColor,LColor);   // Farbe - Linien
      end;
    end;
  end;

procedure TFitDialog.SaveData(AFit : TFitItem);
begin
  with AFit do begin
    Description:=edDescription.Text;
    Visible:=cbShow.Checked;
    with Properties do begin
      if edMinFit.Modified or edMaxFit.Modified or (LStyle<>TLineStyle(cxStyle.ItemIndex+1))
          or (XScale<>TScaleType(rgXScale.ItemIndex)) or (YScale<>TScaleType(rgYScale.ItemIndex))
          or (FitAll<>rbAll.Checked) or (integer(ViewAll)<>(rgAnzeige.ItemIndex))
          or edLineWidth.Modified
          or (FitOrder<>udDegree.Position) then FitData.Computed:=false; // neu berechnen
      LStyle:=TLineStyle(cxStyle.ItemIndex+1);
      FitAll:=rbAll.Checked;           // Fit über alle Daten oder Bereich
      FitMin:=edMinFit.Value;          // X-Bereich für Fit-Funktion
      FitMax:=edMaxFit.Value;
      ViewAll:=rgAnzeige.ItemIndex=1;
      XScale:=TScaleType(rgXScale.ItemIndex);
      YScale:=TScaleType(rgYScale.ItemIndex);
      FitOrder:=udDegree.Position;     // Grad der Pol.-Approximation
      LWidth:=edLineWidth.Value;       // Linienbreite - Linien
      LColor:=bbLineColor.Tag;         // Farbe - Linien
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TFitDialog.bbLoadTemplateClick(Sender: TObject);
begin
  with OpenDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='*.'+XriExt;
    DefaultExt:=XriExt;
    Filter:=_('R-Plot best-fit curve template')+'|*.'+XriExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot best-fit curve template');
    if Execute then begin
      FFit.LoadTemplate(Filename,RpFiTpId,CurveSekt);
      ShowData(FFit);
      UpdateView;
      LastTemplate:=Filename;
      end;
    end;
  end;

procedure TFitDialog.bbSaveTemplateClick(Sender: TObject);
begin
  with SaveDialog do begin
    if length(LastTemplate)>0 then InitialDir:=ExtractFilePath(LastTemplate)
    else InitialDir:=TemplPath;
    Filename:='';
    DefaultExt:=XriExt;
    Filter:=_('R-Plot best-fit curve template')+'|*.'+XriExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot best-fit curve template');
    if Execute then begin
      SaveData(FFit);
      FFit.SaveTemplate(Filename,RpFiTpId,CurveSekt);
      LastTemplate:=Filename;
      end;
    end;
  end;

{ ------------------------------------------------------------------- }
function TFitDialog.Execute (AFit : TFitItem) : boolean;
var
  i,np : integer;
  s    : string;
  metr : boolean;
  ai   : TChartItem;
begin
  FFit:=TFitItem.CreateFrom(AFit);
  metr:=AFit.ParentChart.ParentSheet.PlotUnit=puMetric;
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
  with AFit do begin
    if IsNew then Caption:=TryFormat(_('Create %s for %s'),[_('Best-fit curve'),ParentChart.ChartDesc])
    else Caption:=GetItemName(itFit)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
    with ParentChart do begin
      with cxCurveSelect do begin
        Clear;
        AddItem(_('<not selected>'),nil);
        end;
      ai:=GetFirstItem(itCurve);
      while assigned(ai) do with ai as TCurveItem do begin
        cxCurveSelect.AddItem(Description,pointer(ItemID));
        ai:=GetNextItem(itCurve);
        end;
      end;
    with cxCurveSelect do begin
      ItemIndex:=0;
      for i:=0 to Items.Count-1 do if integer(Items.Objects[i])=CurveID then begin
        ItemIndex:=i; Break;
        end;
      end;
    end;
  with edMinFit do begin
    Digits:=np; FloatFormat:=ffNormalized;
    end;
  with edMaxFit do begin
    Digits:=np; FloatFormat:=ffNormalized;
    end;
  ShowData(AFit);
  UpdateView;
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then begin
    SaveData(AFit);
    with AFit do begin
      with cxCurveSelect do if ItemIndex>0 then begin
        if CurveID<>integer(Items.Objects[ItemIndex]) then FitData.Computed:=false;
        CurveID:=integer(Items.Objects[ItemIndex]);
        end;
      end;
    end;
  FFit.Free;
  end;

end.
