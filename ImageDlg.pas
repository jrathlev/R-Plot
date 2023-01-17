(* RPlot dialog
   Edit image properties

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

unit ImageDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, NumberEd,
  RPlotObjects,  RPlotUtils, Vcl.Dialogs, Vcl.ExtDlgs;

type
  TImageDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    pnImage: TPanel;
    PaintBox: TPaintBox;
    edDescription: TLabeledEdit;
    gbBorder: TGroupBox;
    laBWidth: TLabel;
    laBUnit: TLabel;
    cbBorder: TCheckBox;
    feBWidth: TFloatRangeEdit;
    cbShow: TCheckBox;
    gbPos: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    feLeft: TFloatRangeEdit;
    feWidth: TFloatRangeEdit;
    cbTrans: TCheckBox;
    bbLoadImage: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    feBottom: TFloatRangeEdit;
    feHeight: TFloatRangeEdit;
    OpenPictureDialog: TOpenPictureDialog;
    cbRatio: TCheckBox;
    ColorDialog: TColorDialog;
    bbPaste: TBitBtn;
    bbBColor: TBitBtn;
    gbImgSize: TGroupBox;
    cbReduce: TCheckBox;
    cxDownscale: TComboBox;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbLoadImageClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure cbRatioClick(Sender: TObject);
    procedure feWidthChange(Sender: TObject);
    procedure feHeightChange(Sender: TObject);
    procedure bbBColorClick(Sender: TObject);
    procedure bbPasteClick(Sender: TObject);
    procedure cbReduceClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbTransClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    FIniName,FPath,
    LastPath      : string;
    Bitmap,
    FImage        : TBitmap;
    FRatio        : double;
    metr          : boolean;
    function LoadImageFromFile (FName : string) : boolean;
    procedure ShowImageSize;
    procedure ScaleImage;
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    procedure LoadFromIni (const AIniName : string);
    function Execute(const APath : string; AImage : TImageItem) : boolean;
  end;

var
  ImageDialog: TImageDialog;

implementation

{$R *.dfm}

uses GnuGetText, WinUtils, ExtSysUtils, System.IniFiles, Vcl.Imaging.jpeg,
  Vcl.Clipbrd, Vcl.Imaging.GifImg, Vcl.Imaging.pngimage, MsgDialogs;

const
  BitMapHeight=8;

procedure TImageDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  Bitmap:=TBitMap.Create; FImage:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbBColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TImageDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TImageDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  n : integer;
begin
  if ModalResult=mrOK then CanClose:=TryStrToInt(cxDownscale.Text,n);
  if not CanClose then begin
    ErrorDialog(_('Invalid value for downsizing!'));
    cxDownscale.SetFocus;
    end;
  end;

procedure TImageDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (ImgSekt,IniLeft,Left);
    Top:=ReadInteger (ImgSekt,IniTop,Top);
    LastPath:=ReadString(ImgSekt,IniDir,'');
    Free;
    end;
  end;

procedure TImageDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (ImgSekt,IniLeft,Left);
    WriteInteger (ImgSekt,IniTop,Top);
    WriteString(ImgSekt,IniDir,LastPath);
    Free;
    end;
  FImage.Free; Bitmap.Free;
  end;

procedure TImageDialog.FormResize(Sender: TObject);
begin
  with cbTrans do Left:=pnImage.Left+pnImage.Width-Width;
  end;

procedure TImageDialog.ShowImageSize;
begin
  with FImage do
    gbImgSize.Caption:=_('Original size in pixels:')+' '+IntToStr(Width)+' x '+IntToStr(Height);
  end;

{ ------------------------------------------------------------------- }
function TImageDialog.LoadImageFromFile (FName : string) : boolean;
var
  bj : TPicture;
begin
  Result:=false;
  if (length(FName)>0) then begin
    if FileExists(FName) then begin
      bj:=TPicture.Create;
      with bj do begin
        LoadFromFile(FName);
//        cbTrans.Checked:=Graphic.Transparent;
        Result:=not Graphic.Empty;
        end;
      if Result then with FIMage do begin
        ReleaseHandle;
        if bj.Graphic.ClassType=TPngImage then begin
          // setze ein Pixelformat, das in png nicht verwendet wird, damit
          // es in AssignTo neu gesetzt wird (TBitmap.SetPixelFormat)
          PixelFormat:=pf16Bit;
          (bj.Graphic as TPngImage).AssignTo(FImage);
          end
        else if bj.Graphic.ClassType=TWICImage then begin  // TIFF
          Assign(bj.Graphic);
          AlphaFormat:=afIgnored;
          PixelFormat:=pf24bit;
          end
        else Assign(bj.Graphic);
        TransparentMode:=tmAuto;
        Transparent:=cbTrans.Checked;
        end;
      bj.Free;
      if not Result then ErrorDialog(_('Error loading image:')+sLineBreak+FName)
      else begin
        with FIMage do FRatio:=Width/Height;
        if cbRatio.Checked then feHeight.Value:=feWidth.Value/FRatio;
        PaintBox.Invalidate;
        end;
      end
    else begin
      ErrorDialog(_('Image file not found:')+sLineBreak+FName);
      end;
    end;
  end;

procedure TImageDialog.PaintBoxPaint(Sender: TObject);
var
  r  : double;
begin
  with FImage do begin
    if (Width<=PaintBox.Width) and (Height<=PaintBox.Height) then
      PaintBox.Canvas.Draw(0,0,FImage)
    else begin
      r:=Width/Height;
      if Width<Height then
        PaintBox.Canvas.StretchDraw(Rect(0,0,round(PaintBox.Width*r),PaintBox.Height),FImage)
      else
        PaintBox.Canvas.StretchDraw(Rect(0,0,PaintBox.Width,round(PaintBox.Height/r)),FImage);
      end;
    end;
  end;

procedure TImageDialog.bbBColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbBColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,bbBColor,Color);
    end;
  end;

procedure TImageDialog.bbLoadImageClick(Sender: TObject);
begin
  with OpenPictureDialog do begin
    if length(LastPath)>0 then InitialDir:=LastPath else InitialDir:=FPath;
    FileName:='';
    if Execute then begin
      LoadImageFromFile(Filename);
      ShowImageSize;
      LastPath:=ExtractFilePath(Filename);
      end;
    end;
  end;

procedure TImageDialog.bbPasteClick(Sender: TObject);
begin
  FImage.LoadFromClipBoardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
  with FIMage do FRatio:=Width/Height;
  if cbRatio.Checked then feHeight.Value:=feWidth.Value/FRatio;
  ShowImageSize;
  PaintBox.Invalidate;
  end;

procedure TImageDialog.cbRatioClick(Sender: TObject);
begin
  if cbRatio.Checked then begin
    feHeight.Value:=feWidth.Value/FRatio;
    end;
  end;

procedure TImageDialog.cbReduceClick(Sender: TObject);
begin
  cxDownscale.Enabled:=cbReduce.Checked;
  end;

procedure TImageDialog.cbTransClick(Sender: TObject);
begin
  FImage.Transparent:=cbTrans.Checked;
  PaintBox.Invalidate;
  end;

procedure TImageDialog.feHeightChange(Sender: TObject);
begin
  if cbRatio.Checked then with feHeight do if (Value>0.5) and Focused then feWidth.Value:=Value*FRatio;
  end;

procedure TImageDialog.feWidthChange(Sender: TObject);
begin
  if cbRatio.Checked then with feWidth do if (Value>0.5) and Focused then feHeight.Value:=Value/FRatio;
  end;

{ ------------------------------------------------------------------- }
procedure TImageDialog.ScaleImage;
var
  w,h : integer;
  f   : double;
  bm  : TBitmap;
begin
  with FImage do begin
    if not TryStrToInt(cxDownscale.Text,w) then w:=50;
    f:=w/100;
    w:=round(f*Width); h:=round(f*Height);
    if (w<Width) and (h<Height) then begin
       bm:=TBitmap.Create;
       bm.Assign(FImage);
       Width:=w; Height:=h;
       Canvas.StretchDraw(Rect(0,0,w,h),bm);
       bm.Free;
       end;
    end;
  end;

{ ------------------------------------------------------------------- }
function TImageDialog.Execute(const APath : string; AImage : TImageItem) : boolean;
var
  s    : string;
  i    : integer;
  a    : TFloatArea;
begin
  FPath:=APath;
  metr:=AImage.ParentChart.ParentSheet.PlotUnit=puMetric;
  for i:=0 to ComponentCount-1 do if Components[i] is TFloatRangeEdit then
      with (Components[i] as TFloatRangeEdit) do begin
    if metr then with MetricRanges[Tag] do begin
      Decimal:=Dec; MinValue:=Min; MaxValue:=Max;
      end
    else with InchRanges[Tag] do begin
      Decimal:=Dec; MinValue:=Min; MaxValue:=Max;
      end;
    end;
  if metr then s:='cm' else s:='inch';
  for i:=0 to ComponentCount-1 do if (Components[i] is TLabel) and (Components[i].Tag=1) then
    (Components[i] as TLabel).Caption:=s;
  cbReduce.Checked:=false;
  with cxDownscale do begin
    ItemIndex:=3;  // 50%
    Enabled:=cbReduce.Checked;;
    end;
  with AImage do begin
    if IsNew then Caption:=TryFormat(_('Create %s for %s'),[_('Image'),ParentChart.ChartDesc])
    else Caption:=GetItemName(itImage)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
    edDescription.Text:=Description;
    with FImage do begin
      FreeImage;
      Assign(Image);
      end;
    with Area do begin
      feLeft.Value:=Left; feBottom.Value:=Bottom;
      feWidth.Value:=Width; feHeight.Value:=Height;
      end;
    with Image do if not Empty then FRatio:=Width/Height else FRatio:=1;
    cbTrans.Checked:=Transparent;            // transparenter Hintergrund
    cbBorder.Checked:=Border;                // mit Umrahmung
    feBWidth.Value:=LWidth;                  // Linienbreite - Rahmen
    FillBtnGlyph(Bitmap,bbBColor,LColor);    // Farbe - Linien
    cbShow.Checked:=Visible;
    end;
  ShowImageSize;
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then with AImage do begin
    Description:=edDescription.Text;
    ImgName:=CreateFilename;
    if cbReduce.Checked then ScaleImage;
    with Image do begin
      ReleaseHandle;
      Assign(FImage);
//      Transparent:=cbTrans.Checked;
//      TransparentMode:=tmAuto;
      end;
    with a do begin
      Left:=feLeft.Value; Bottom:=feBottom.Value;
      Width:=feWidth.Value; Height:=feHeight.Value;
      end;
    Area:=a;
    Transparent:=cbTrans.Checked;            // transparenter Hintergrund
    Border:=cbBorder.Checked;                // mit Umrahmung
    LWidth:=feBWidth.Value;                  // Linienbreite - Rahmen
    LColor:=bbBColor.Tag;                    // Farbe - Linien
    Visible:=cbShow.Checked;
    end;
  end;

end.

