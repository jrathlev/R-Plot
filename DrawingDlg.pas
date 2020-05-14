(* RPlot dialog
   Edit line properties

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

unit DrawingDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, NumberEd,
  RPlotObjects, RplotUtils, Vcl.Dialogs, Vcl.ComCtrls;

type
  TDrawingDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    edDescription: TLabeledEdit;
    gbEnd: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    feEndX: TFloatRangeEdit;
    feEndY: TFloatRangeEdit;
    gbBegin: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    feStartX: TFloatRangeEdit;
    feStartY: TFloatRangeEdit;
    gbHead: TGroupBox;
    laBWidth: TLabel;
    laBUnit: TLabel;
    feLWidth: TFloatRangeEdit;
    feHdLength: TFloatRangeEdit;
    Label5: TLabel;
    Label10: TLabel;
    feHdWidth: TFloatRangeEdit;
    Label11: TLabel;
    Label12: TLabel;
    cbShow: TCheckBox;
    gbLine: TGroupBox;
    cxStyle: TComboBox;
    ColorDialog: TColorDialog;
    cbStartArrow: TCheckBox;
    cbEndArrow: TCheckBox;
    bbLineColor: TBitBtn;
    pcType: TPageControl;
    tsLine: TTabSheet;
    tsRect: TTabSheet;
    pcProps: TPageControl;
    tsArrow: TTabSheet;
    tsFill: TTabSheet;
    gbBackground: TGroupBox;
    shBackground: TShape;
    cbTrans: TCheckBox;
    bbBgColor: TBitBtn;
    cbBorder: TCheckBox;
    gbRect: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    feLeft: TFloatRangeEdit;
    feWidth: TFloatRangeEdit;
    feBottom: TFloatRangeEdit;
    feHeight: TFloatRangeEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbLColorClick(Sender: TObject);
    procedure cbBorderClick(Sender: TObject);
    procedure bbBgColorClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FIniName     : string;
    Bitmap       : TBitmap;
    ChColor      : TColor;
    procedure UpdateView;
  public
    { Public-Deklarationen }
    procedure LoadFromIni (const AIniName : string);
    function Execute(ADrawing : TDrawingItem) : boolean;
  end;

var
  DrawingDialog: TDrawingDialog;

implementation

{$R *.dfm}

uses GnuGetText, ExtSysUtils, WinUtils, System.IniFiles;

const
  BitMapHeight=8;

procedure TDrawingDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  Bitmap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbBgColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  end;

procedure TDrawingDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (ImgSekt,IniLeft,Left);
    Top:=ReadInteger (ImgSekt,IniTop,Top);
    Free;
    end;
  end;

procedure TDrawingDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (ImgSekt,IniLeft,Left);
    WriteInteger (ImgSekt,IniTop,Top);
    Free;
    end;
  Bitmap.Free;
  end;

{ ------------------------------------------------------------------- }
procedure TDrawingDialog.UpdateView;
begin
  with bbBgColor do begin
    Enabled:=not cbTrans.Checked;
    with shBackground.Brush do begin
      Style:=bsSolid;
      if Enabled then Color:=bbBgColor.Tag
      else Color:=ChColor;
      end
    end;
  with shBackground.Pen do if cbBorder.Checked then Style:=psSolid else Style:=psClear;
  gbLine.Visible:=(pcType.ActivePageIndex=0) or cbBorder.Checked;
  end;

procedure TDrawingDialog.bbBgColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbBgColor.Tag;
    if Execute then begin
      bbBgColor.Tag:=Color;
      shBackground.Brush.Color:=Color;
      end;
    end;
  end;

procedure TDrawingDialog.bbLColorClick(Sender: TObject);
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
procedure TDrawingDialog.cbBorderClick(Sender: TObject);
begin
  UpdateView;
  end;

function TDrawingDialog.Execute(ADrawing : TDrawingItem) : boolean;
var
  metr : boolean;
  s    : string;
  i    : integer;
  pt   : TFPoint;
begin
  metr:=ADrawing.ParentChart.ParentSheet.PlotUnit=puMetric;
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
  with ADrawing do begin
    with Properties do begin
      feLWidth.Value:=LWidth;
      cxStyle.ItemIndex:=integer(Style)-1;
      FillBtnGlyph(Bitmap,bbLineColor,LColor);    // Farbe - Linien
      end;
    with ParentChart do begin
      ChColor:=ChartColor;
      if ChColor<0 then ChColor:=ParentSheet.SheetColor;
      end;
    if DrawingType=dtLine then begin
      pcType.ActivePageIndex:=0; pcProps.ActivePageIndex:=0;
      with StartPoint do begin
        feStartX.Value:=X; feStartY.Value:=Y;
        end;
      with EndPoint do begin
        feEndX.Value:=X; feEndY.Value:=Y;
        end;
      with Properties do begin
        feHdLength.Value:=HdLength;
        feHdWidth.Value:=HdWidth;
        cbStartArrow.Checked:=(ArrowStyle=asBegin) or (ArrowStyle=asBoth);
        cbEndArrow.Checked:=(ArrowStyle=asEnd) or (ArrowStyle=asBoth);
        end;
      gbLine.Caption:=_('Line properties');
      edDescription.EditLabel.Caption:=_('Name of line:');
      s:=_('Line');
      end
    else begin
      pcType.ActivePageIndex:=1; pcProps.ActivePageIndex:=1;
      feLeft.Value:=StartPoint.X;
      feBottom.Value:=StartPoint.Y;
      feWidth.Value:=EndPoint.X-StartPoint.X;
      feHeight.Value:=EndPoint.Y-StartPoint.Y;
      with Properties do begin
        cbTrans.Checked:=Transparent;            // transparenter Hintergrund
        cbBorder.Checked:=Border;                // mit Umrahmung
        FillBtnGlyph(Bitmap,bbBgColor,BgColor);   // Farbe - Linien
        shBackground.Pen.Color:=LColor;
        end;
      gbLine.Caption:=_('Border');
      edDescription.EditLabel.Caption:=_('Name of rectangle:');
      s:=_('Rectangle');
      end;
    cbShow.Checked:=Visible;
    if IsNew then Caption:=TryFormat(_('Create %s for %s'),[s,ParentChart.ChartDesc])
    else Caption:=GetItemName(itDrawing)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
    edDescription.Text:=Description;
    end;
  ColorDialog.CustomColors.CommaText:=UserColors;
  UpdateView;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then with ADrawing do begin
    Description:=edDescription.Text;
    with Properties do begin
      LWidth:=feLWidth.Value;
      Style:=TLineStyle(cxStyle.ItemIndex+1);
      LColor:=bbLineColor.Tag;                    // Farbe - Linien
      end;
    if DrawingType=dtLine then begin
      with pt do begin
        X:=feStartX.Value; Y:=feStartY.Value;
        end;
      StartPoint:=pt;
      with pt do begin
        X:=feEndX.Value; Y:=feEndY.Value;
        end;
      EndPoint:=pt;
      with Properties do begin
        HdLength:=feHdLength.Value;
        HdWidth:=feHdWidth.Value;
        if cbStartArrow.Checked then begin
          if cbEndArrow.Checked then ArrowStyle:=asBoth else ArrowStyle:=asBegin;
          end
        else if cbEndArrow.Checked then ArrowStyle:=asEnd
        else ArrowStyle:=asNone;
        end;
      end
    else begin  // Rectangle
      with pt do begin
        X:=feLeft.Value; Y:=feBottom.Value;
        end;
      StartPoint:=pt;
      with pt do begin
        X:=x+feWidth.Value; Y:=Y+feHeight.Value;
        end;
      EndPoint:=pt;
      with Properties do begin
        Transparent:=cbTrans.Checked;            // transparenter Hintergrund
        Border:=cbBorder.Checked;                // mit Umrahmung
        BgColor:=bbBgColor.Tag;                  // Farbe - Hintergrund
        end;
      end;
    Visible:=cbShow.Checked;
    end;
  end;

end.
