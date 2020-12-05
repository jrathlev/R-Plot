(* RPlot dialog
   Edit global preferences

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

unit PrefsDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, NumberEd, Vcl.ComCtrls,
  RPlotObjects, RPlotUtils, Vcl.Dialogs;

type
  TDefaultSheet = record
    MetricSheet,InchSheet : TSheetProperties;
    end;

  TPreferencesDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    pcPrefs: TPageControl;
    paBottom: TPanel;
    tsSheet: TTabSheet;
    tsLines: TTabSheet;
    tsText: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    gbSize: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    cbForms: TComboBox;
    feWidth: TFloatRangeEdit;
    feHeight: TFloatRangeEdit;
    rbPortrait: TRadioButton;
    rbLandscape: TRadioButton;
    rgUnit: TRadioGroup;
    gbMargin: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    feLeft: TFloatRangeEdit;
    feBottom: TFloatRangeEdit;
    feRight: TFloatRangeEdit;
    feTop: TFloatRangeEdit;
    Label5: TLabel;
    lbFonts: TListBox;
    edPreview: TEdit;
    cbItalic: TCheckBox;
    cbBold: TCheckBox;
    feSize: TFloatRangeEdit;
    Label9: TLabel;
    Label10: TLabel;
    edLineWidth: TFloatRangeEdit;
    Label11: TLabel;
    cxStyle: TComboBox;
    Label12: TLabel;
    sbLineColor: TSpeedButton;
    edSymbolSize: TFloatRangeEdit;
    laSymbolSize: TLabel;
    Label13: TLabel;
    cxSymbols: TComboBox;
    gbLines: TGroupBox;
    gbSymbols: TGroupBox;
    Label14: TLabel;
    sbSymColor: TSpeedButton;
    ColorDialog: TColorDialog;
    bbColor: TBitBtn;
    shBackground: TShape;
    bbBgColor: TBitBtn;
    paDesc: TPanel;
    edDesc: TLabeledEdit;
    bbDefault: TBitBtn;
    tsCharts: TTabSheet;
    Panel3: TPanel;
    edChartSpace: TFloatRangeEdit;
    Label8: TLabel;
    edAxisSpace: TFloatRangeEdit;
    Label15: TLabel;
    tsAxes: TTabSheet;
    Panel6: TPanel;
    Label16: TLabel;
    feLabDist: TFloatRangeEdit;
    Label17: TLabel;
    feCapDist: TFloatRangeEdit;
    laChartColor: TLabel;
    shChartBg: TShape;
    bbChartBg: TBitBtn;
    cxTranspChart: TCheckBox;
    gbBackground: TGroupBox;
    cxBorder: TCheckBox;
    Label19: TLabel;
    feLabSize: TFloatRangeEdit;
    Label20: TLabel;
    feCapSize: TFloatRangeEdit;
    gbLabels: TGroupBox;
    gbCaption: TGroupBox;
    GroupBox1: TGroupBox;
    cxNoFill: TCheckBox;
    laFillColor: TLabel;
    shFill: TShape;
    bbFillColor: TBitBtn;
    bbLoadTemplate: TBitBtn;
    bbSavePrefs: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label18: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    feAxLnWidth: TFloatRangeEdit;
    Label37: TLabel;
    cbDecSep: TComboBox;
    Label38: TLabel;
    Label39: TLabel;
    feTickLength: TFloatRangeEdit;
    Label40: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbFormsCloseUp(Sender: TObject);
    procedure rgUnitClick(Sender: TObject);
    procedure bbBgColorClick(Sender: TObject);
    procedure sbLineColorClick(Sender: TObject);
    procedure sbSymColorClick(Sender: TObject);
    procedure bbColorClick(Sender: TObject);
    procedure pcPrefsChange(Sender: TObject);
    procedure lbFontsClick(Sender: TObject);
    procedure bbDefaultClick(Sender: TObject);
    procedure bbChartBgClick(Sender: TObject);
    procedure cxTranspChartClick(Sender: TObject);
    procedure bbFillColorClick(Sender: TObject);
    procedure bbLoadTemplateClick(Sender: TObject);
    procedure bbSavePrefsClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Bitmap       : TBitmap;
    PUnit        : TPlotUnit;
    DefHeight    : integer;
    FSheet       : TDefaultSheet;
    procedure UpdateView;
    procedure ShowData (sp : TSheetProperties);
    function SaveData : TSheetProperties;
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    function Preferences (APos : TPoint; var APlotUnit : TPlotUnit;
                          var ASheet : TDefaultSheet) : boolean;
    function SheetProperties (APos : TPoint; const FName: string; ASheet : TSheet) : boolean;

  end;

function EditPreferences (APos : TPoint; var APlotUnit : TPlotUnit;
                          var ASheet : TDefaultSheet) : boolean;

function EditSheetProperties (APos : TPoint; const FName: string; ASheet : TSheet) : boolean;

procedure LoadSheetProperties (const Filename : string; APlotUnit : TPlotUnit;
                               var ASheetProps : TSheetProperties);
procedure SaveSheetProperties (const Filename : string; APlotUnit : TPlotUnit;
                               const ASheetProps : TSheetProperties);

var
  PreferencesDialog: TPreferencesDialog;
  DefSheet   : TDefaultSheet;

implementation

{$R *.dfm}

uses GnuGetText,
//  RPlotMain,
  WinUtils, ExtSysUtils, System.IniFiles;

const
  BitMapHeight=8;

procedure LoadSheetProperties (const Filename : string; APlotUnit : TPlotUnit;
                               var ASheetProps : TSheetProperties);
var
  Section : string;
begin
  if APlotUnit=puMetric then Section:=MetricSekt else Section:=InchSekt;
  with TIniFile.Create(Filename) do with ASheetProps do begin  // load user preferences
    FBakColor:=ReadInteger(Section,iniBakCol,FBakColor);
    FPageFormat:=TPageFormat(ReadInteger(Section,iniFormat,0));
    with FSize do begin
      Width:=ReadInteger(Section,iniWidth,round(100*Width))/100;
      Height:=ReadInteger(Section,iniHeight,round(100*Height))/100;
      end;
    with FMargin do begin
      Left:=ReadInteger(Section,iniLeft,round(100*Left))/100;
      Bottom:=ReadInteger(Section,iniBottom,round(100*Bottom))/100;
      Right:=ReadInteger(Section,iniRight,round(100*Right))/100;
      Top:=ReadInteger(Section,iniTop,round(100*Top))/100;
      end;
    FChartColor:=ReadInteger(Section,iniChartCol,FChartColor);
    FChartSpace:=ReadInteger(Section,iniChSpace,round(100*FChartSpace))/100;
    FAxisSpace:=ReadInteger(Section,iniAxSpace,round(100*FAxisSpace))/100;
    FAxLnWidth:=ReadInteger(Section,iniAxLnWdt,round(100*FAxLnWidth))/100;
    FTickLength:=ReadInteger(Section,iniAxTickMk,round(100*FTickLength))/100;
    FLabSize:=ReadInteger(Section,iniLabSize,round(100*FLabSize))/100;
    FCapSize:=ReadInteger(Section,iniCapSize,round(100*FCapSize))/100;
    FLabDist:=ReadInteger(Section,iniLabDist,round(100*FLabDist))/100;
    FCapDist:=ReadInteger(Section,iniCapDist,round(100*FCapDist))/100;
    FAxisFrame:=ReadBool(Section,iniAxFrame,FAxisFrame);
    with FPlotFont do begin
      FontName:=ReadString(Section,iniFontName,FontName);
      FontSize:=ReadInteger(Section,iniFontSize,round(100*FontSize))/100;
      FontStyle:=[];
      if ReadBool(Section,iniBold,fsBold in FontStyle) then include(FontStyle,fsBold);
      if ReadBool(Section,iniItalic,fsItalic in FontStyle) then include(FontStyle,fsItalic);
      FontColor:=ReadInteger(Section,iniFontColor,FontColor);
      FontType:=TFontType(ReadInteger(Section,iniFontType,integer(FontType)));
      end;
    FLineWidth:=ReadInteger(Section,iniLnWidth,round(100*FLineWidth))/100;
    FLineStyle:=TLineStyle(ReadInteger(Section,iniLnStyle,integer(FLineStyle)));
    FLineColor:=ReadInteger(Section,iniLnCol,FLineColor);
    FFillColor:=ReadInteger(Section,iniFillCol,FFillColor);
    FSymSize:=ReadInteger(Section,iniSymSize,round(100*FSymSize))/100;
    FSymType:=TSymbolType(ReadInteger(Section,iniSymStyle,integer(FSymType)));
    FSymColor:=ReadInteger(Section,iniSymCol,FSymColor);
    FDecSep:=chr(ReadInteger(Section,iniDecSep,ord(FDecSep)));
    Free;
    end;
  end;

procedure SaveSheetProperties (const Filename : string; APlotUnit : TPlotUnit;
                               const ASheetProps : TSheetProperties);
var
  Section : string;
begin
  if APlotUnit=puMetric then Section:=MetricSekt else Section:=InchSekt;
  with TIniFile.Create(Filename) do with ASheetProps do begin  // load user preferences
    WriteInteger(Section,iniBakCol,FBakColor);
    WriteInteger(Section,iniFormat,integer(FPageFormat));
    with FSize do begin
      WriteInteger(Section,iniWidth,round(100*Width));
      WriteInteger(Section,iniHeight,round(100*Height));
      end;
    with FMargin do begin
      WriteInteger(Section,iniLeft,round(100*Left));
      WriteInteger(Section,iniBottom,round(100*Bottom));
      WriteInteger(Section,iniRight,round(100*Right));
      WriteInteger(Section,iniTop,round(100*Top));
      end;
    WriteInteger(Section,iniChartCol,FChartColor);
    WriteInteger(Section,iniChSpace,round(100*FChartSpace));
    WriteInteger(Section,iniAxSpace,round(100*FAxisSpace));
    WriteInteger(Section,iniAxLnWdt,round(100*FAxLnWidth));
    WriteInteger(Section,iniAxTickMk,round(100*FTickLength));
    WriteInteger(Section,iniLabSize,round(100*FLabSize));
    WriteInteger(Section,iniCapSize,round(100*FCapSize));
    WriteInteger(Section,iniLabDist,round(100*FLabDist));
    WriteInteger(Section,iniCapDist,round(100*FCapDist));
    WriteBool(Section,iniAxFrame,FAxisFrame);
    with FPlotFont do begin
      WriteString(Section,iniFontName,FontName);
      WriteInteger(Section,iniFontSize,round(100*FontSize));
      WriteBool(Section,iniBold,fsbold in FontStyle);
      WriteBool(Section,iniItalic,fsItalic in FontStyle);
      WriteInteger(Section,iniFontColor,FontColor);
      WriteInteger(Section,iniFontType,integer(FontType));
      end;
    WriteInteger(Section,iniLnWidth,round(100*FLineWidth));
    WriteInteger(Section,iniSymSize,round(100*FSymSize));
    WriteInteger(Section,iniLnStyle,integer(FLineStyle));
    WriteInteger(Section,iniLnCol,FLineColor);
    WriteInteger(Section,iniFillCol,FFillColor);
    WriteInteger(Section,iniSymStyle,integer(FSymType));
    WriteInteger(Section,iniSymCol,FSymColor);
    WriteInteger(Section,iniDecSep,ord(FDecSep));
    Free;
    end;
  end;

{ ------------------------------------------------------------------- }
function EnumFontsProc(var EnumLogFont: TEnumLogFont; var TextMetric: TNewTextMetric;
           FontType: Integer; Data: LPARAM): Integer; stdcall;
var
   FontName: string;
   lb      : TListBox;
begin
  lb:=TListBox(Data);
  FontName:=StrPas(EnumLogFont.elfLogFont.lfFaceName);
  if (lb.Items.IndexOf(FontName)<0) and (FontType=TRUETYPE_FONTTYPE)
    and (ord(TextMetric.tmCharSet)=ANSI_CHARSET) and (copy(FontName,1,1)<>'@') then
    lb.Items.AddObject(FontName,pointer(EnumLogFont.elfLogFont.lfPitchAndFamily));
  Result:=1;
  end;

function GetFontType (lfQuality : byte) : TFontType;
begin
  if lfQuality and $FC = FF_ROMAN then Result:=ftRoman
  else if (lfQuality and $FC = FF_MODERN) or (lfQuality and 3 = FIXED_PITCH) then Result:=ftFixed
  else Result:=ftSwiss;
  end;

{ ------------------------------------------------------------------- }
procedure TPreferencesDialog.FormCreate(Sender: TObject);
var
  dc : HDC;
  lf : TLogFont;
  pf : TPageformat;
  n  : integer;
begin
  TranslateComponent(self);
  DefHeight:=ClientHeight;
  BitMap:=TBitMap.Create;
  with cbForms do begin
    Clear; n:=0;
    for pf:=Low(TPageformat) to High(TPageformat) do begin
      if pf=pfUser then Items.Add(_('User defined'))
      else Items.Add(PaperSizes[pf].Name);
      if pf=pfA4 then n:=integer(pf);
      end;
    ItemIndex:=n;
    end;
  rbPortrait.Checked:=true;
  with BitMap do begin
    Height:=BitMapHeight; Width:=sbLineColor.Width-6;
    TransparentMode:=tmFixed;
    end;
  // Build font list
  dc:=GetDC(0);
  with lf do begin
    lfCharset:=DEFAULT_CHARSET; lfFaceName:=''; lfPitchAndFamily:=0;
    end;
  try
    EnumFontFamiliesEx(dc,lf,@EnumFontsProc,LongInt(lbFonts),0);
  finally
    ReleaseDC(0,dc);  { release device context }
    end;
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TPreferencesDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TPreferencesDialog.FormDestroy(Sender: TObject);
begin
  Bitmap.Free;
  end;

procedure TPreferencesDialog.lbFontsClick(Sender: TObject);
begin
  UpdateView;
  end;

procedure TPreferencesDialog.bbBgColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbBgColor.Tag;
    if Execute then begin
      bbBgColor.Tag:=Color;
      shBackground.Brush.Color:=Color;
      if cxTranspChart.Checked then bbChartBg.Tag:=Color;
      UpdateView;
      end;
    end;
  end;

procedure TPreferencesDialog.bbChartBgClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbChartBg.Tag;
    if Execute then begin
      bbChartBg.Tag:=Color;
      shChartBg.Brush.Color:=Color;
      UpdateView;
      end;
    end;
  end;

procedure TPreferencesDialog.bbFillColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbFillColor.Tag;
    if Execute then begin
      bbFillColor.Tag:=Color;
      shFill.Brush.Color:=Color;
      UpdateView;
      end;
    end;
  end;

procedure TPreferencesDialog.pcPrefsChange(Sender: TObject);
begin
  UpdateView;
  end;

procedure TPreferencesDialog.rgUnitClick(Sender: TObject);
var
  i : integer;
begin
  if integer(PUnit)<>rgUnit.ItemIndex then begin
{    if PUnit=puMetric then begin // in inch umrechnen
      for i:=0 to ComponentCount-1 do if Components[i] is TFloatRangeEdit then
          with (Components[i] as TFloatRangeEdit) do begin
        MinValue:=MinValue/OneInch; MaxValue:=MaxValue/OneInch; Value:=Value/OneInch;
        end;
      rgDecSep.ItemIndex:=1;
      end
    else begin  // in cm umrechnen
      for i:=0 to ComponentCount-1 do if Components[i] is TFloatRangeEdit then
          with (Components[i] as TFloatRangeEdit) do begin
        MinValue:=MinValue*OneInch; MaxValue:=MaxValue*OneInch; Value:=Value*OneInch;
        end;
      rgDecSep.ItemIndex:=0;
      end;                  }
    with FSheet do if PUnit=puMetric then MetricSheet:=SaveData
    else InchSheet:=SaveData;
    PUnit:=TPlotUnit(rgUnit.ItemIndex);
    with FSheet do if PUnit=puMetric then ShowData(MetricSheet)
    else ShowData(InchSheet);
    UpdateView;
    end;
  end;

procedure TPreferencesDialog.bbColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbColor.Tag;
    if Execute then begin
      bbColor.Tag:=Color;
      UpdateView;
      end;
    end;
  end;

procedure TPreferencesDialog.bbLoadTemplateClick(Sender: TObject);
var
  sp : TSheetProperties;
begin
  with OpenDialog do begin
    InitialDir:=TemplPath;
    Filename:='*.'+PshExt;
    DefaultExt:=PshExt;
    Filter:=_('R-Plot sheet preferences')+'|*.'+PshExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot sheet preferences');
    if Execute then begin
      sp:=SaveData;
      LoadSheetProperties(Filename,PUnit,sp);
      ShowData(sp);
      end;
    end;
  end;

procedure TPreferencesDialog.bbSavePrefsClick(Sender: TObject);
begin
  with SaveDialog do begin
    InitialDir:=TemplPath;
    Filename:='';
    DefaultExt:=PshExt;
    Filter:=_('R-Plot sheet preferences')+'|*.'+PshExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot sheet preferences');
    if Execute then begin
      SaveSheetProperties(Filename,PUnit,SaveData);
      end;
    end;
  end;

procedure TPreferencesDialog.bbDefaultClick(Sender: TObject);
begin
  with DefSheet do
    if PUnit=puMetric then ShowData(MetricSheet) else ShowData(InchSheet);
  end;

procedure TPreferencesDialog.sbLineColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=sbLineColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,sbLineColor,Color);
    end;
  end;

procedure TPreferencesDialog.sbSymColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=sbSymColor.Tag;
    if Execute then FillBtnGlyph(Bitmap,sbSymColor,Color);
    end;
  end;

procedure TPreferencesDialog.UpdateView;
var
  i    : integer;
  metr : boolean;
  s    : string;

  procedure SetMargins (AMargin : TFRect);
  begin
    with AMargin do begin
      feLeft.Value:=Left; feBottom.Value:=Bottom;
      feRight.Value:=Right; feTop.Value:=Top;
      end;
    end;

begin
  metr:=rgUnit.ItemIndex=0;
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
  rbPortrait.Visible:=cbForms.ItemIndex<>0;
  rbLandscape.Visible:=rbPortrait.Visible;
  with PaperSizes[TPageFormat(cbForms.ItemIndex)] do begin
    if metr then with MSize do begin
      if rbPortrait.Checked then begin
        feWidth.Value:=Width; feHeight.Value:=Height;
        if cbForms.ItemIndex=0 then SetMargins(NoMargin)
        else SetMargins(MetricPoMargin);
        end
      else begin  // Landscape
        feWidth.Value:=Height; feHeight.Value:=Width;
        if cbForms.ItemIndex=0 then SetMargins(NoMargin)
        else SetMargins(MetricLsMargin);
        end;
      end
    else with ISize do begin
      if rbPortrait.Checked then begin
        feWidth.Value:=Width; feHeight.Value:=Height;
        if cbForms.ItemIndex=0 then SetMargins(NoMargin)
        else SetMargins(InchPoMargin);
        end
      else begin
        feWidth.Value:=Height; feHeight.Value:=Width;
        if cbForms.ItemIndex=0 then SetMargins(NoMargin)
        else SetMargins(InchLsMargin);
        end;
      end;
    end;
  with shBackground.Brush do begin
    Style:=bsSolid; Color:=bbBgColor.Tag;
    end;
  with bbChartBg do begin
    Visible:=not cxTranspChart.Checked;
    shChartBg.Visible:=Visible;
    laChartColor.Visible:=Visible;
    end;
  bbFillColor.Visible:=not cxNoFill.Checked;
  laFillColor.Visible:=bbFillColor.Visible;
  with shFill do begin
    Visible:=bbFillColor.Visible;
    Brush.Style:=bsSolid;
    if bbFillColor.Visible then Brush.Color:=bbFillColor.Tag
    else
    end;
  with shChartBg.Brush do begin
    Style:=bsSolid;
    if bbChartBg.Visible then Color:=bbChartBg.Tag;
    end;
  if pcPrefs.ActivePageIndex=4 then begin
    with lbFonts do s:=Items[ItemIndex];
    with edPreview do begin
      with Font do begin
        Name:=s;
        Color:=bbColor.Tag;
        Style:=[];
        if cbBold.Checked then Style:=Style+[fsBold];
        if cbItalic.Checked then Style:=Style+[fsItalic];
        end;
      Text:='The quick brown fox jumps ..';
      end;
    end;
  end;

procedure TPreferencesDialog.cbFormsCloseUp(Sender: TObject);
begin
//  with rgUnit do if cbForms.ItemIndex>4 then ItemIndex:=1 else ItemIndex:=0;
  UpdateView;
  end;

procedure TPreferencesDialog.cxTranspChartClick(Sender: TObject);
begin
  if Visible then UpdateView;
  end;

procedure TPreferencesDialog.ShowData (sp : TSheetProperties);
var
  i  : integer;
  s  : string;
begin
  for i:=0 to ComponentCount-1 do if Components[i] is TFloatRangeEdit then
      with (Components[i] as TFloatRangeEdit) do begin
    if PUnit=puMetric then with MetricRanges[Tag] do begin
      Decimal:=Dec; MinValue:=Min; MaxValue:=Max;
      end
    else with InchRanges[Tag] do begin
      Decimal:=Dec; MinValue:=Min; MaxValue:=Max;
      end;
    end;
  if PUnit=puMetric then s:='cm' else s:='inch';
  for i:=0 to ComponentCount-1 do if (Components[i] is TLabel) and (Components[i].Tag=1) then
    (Components[i] as TLabel).Caption:=s;
  with sp do begin
    bbBgColor.Tag:=FBakColor;
    cbForms.ItemIndex:=integer(FPageFormat);
    with FSize do begin
      feWidth.Value:=Width; feHeight.Value:=Height;
      if (cbForms.ItemIndex>0) then begin
        if (Width<Height) then rbPortrait.Checked:=true else rbLandscape.Checked:=true;
        end;
      end;
    with FMargin do begin
      feLeft.Value:=Left; feBottom.Value:=Bottom;
      feRight.Value:=Right; feTop.Value:=Top;
      end;
    cxTranspChart.Checked:=FChartColor<0;
    with bbChartBg do begin
      if FChartColor>=0 then Tag:=FChartColor else Tag:=FBakColor;
      end;
    edChartSpace.Value:=FChartSpace;
    edAxisSpace.Value:=FAxisSpace;
    feAxLnWidth.Value:=FAxLnWidth;
    feTickLength.Value:=FTickLength;
    cxBorder.Checked:=FAxisFrame;
    feLabSize.Value:=FLabSize;
    feCapSize.Value:=FCapSize;
    feLabDist.Value:=FLabDist;
    feCapDist.Value:=FCapDist;
    edLineWidth.Value:=FLineWidth;
    edSymbolSize.Value:=FSymSize;
    cxStyle.ItemIndex:=integer(FLineStyle)-1;
    FillBtnGlyph(Bitmap,sbLineColor,FLineColor);
    FillBtnGlyph(Bitmap,sbSymColor,FSymColor);
    cxSymbols.ItemIndex:=integer(FSymType);
    cxNoFill.Checked:=FFillColor<0;
    with bbFillColor do begin
      if FFillColor>=0 then Tag:=FFillColor else Tag:=bbChartBg.Tag;
      end;
    with FPlotFont do begin
      i:=lbFonts.Items.IndexOf(FontName);
      if i<0 then i:=lbFonts.Items.IndexOf(defFontName);
      lbFonts.ItemIndex:=i;
      feSize.Value:=FontSize;
      bbColor.Tag:=FontColor;
      cbBold.Checked:=fsBold in FontStyle;
      cbItalic.Checked:=fsItalic in FontStyle;
      end;
    with cbDecSep do if FDecSep='.' then ItemIndex:=0 else ItemIndex:=1;
    end;
  end;

function TPreferencesDialog.SaveData : TSheetProperties;
begin
  with Result do begin
    FBakColor:=bbBgColor.Tag;
    FPageFormat:=TPageFormat(cbForms.ItemIndex);
    FSize:=FloatSize(feWidth.Value,feHeight.Value);
    FMargin:=FloatRect(feLeft.Value,feBottom.Value,feRight.Value,feTop.Value);
    if cxTranspChart.Checked then FChartColor:=-1
    else FChartColor:=bbChartBg.Tag;
    FChartSpace:=edChartSpace.Value;
    FAxisSpace:=edAxisSpace.Value;
    FAxLnWidth:=feAxLnWidth.Value;
    FTickLength:=feTickLength.Value;
    FAxisFrame:=cxBorder.Checked;
    FLabSize:=feLabSize.Value;
    FCapSize:=feCapSize.Value;
    FLabDist:=feLabDist.Value;
    FCapDist:=feCapDist.Value;
    FLineWidth:=edLineWidth.Value;
    FSymSize:=edSymbolSize.Value;
    FLineStyle:=TLineStyle(cxStyle.ItemIndex+1);
    FLineColor:=sbLineColor.Tag;         // Farbe - Linien
    FSymColor:=sbSymColor.Tag;       // Farbe - Markierungen
    FSymType:=TSymbolType(cxSymbols.ItemIndex);
    if cxNoFill.Checked then FFillColor:=-1
    else FFillColor:=bbFillColor.Tag;
    with FPlotFont do begin
      with lbFonts do FontName:=Items[ItemIndex];
      FontSize:=feSize.Value;
      FontColor:=bbColor.Tag;
      FontStyle:=[];
      if cbBold.Checked then Include(FontStyle,fsBold);
      if cbItalic.Checked then Include(FontStyle,fsItalic);
      with lbFonts do FontType:=GetFontType(byte(Items.Objects[ItemIndex]));
      end;
    if cbDecSep.ItemIndex=0 then FDecSep:='.' else FDecSep:=',';
    end;
  end;

function TPreferencesDialog.Preferences (APos : TPoint; var APlotUnit : TPlotUnit;
                                         var ASheet : TDefaultSheet) : boolean;
begin
  if APos.X<0 then Position:=poScreenCenter
  else with APos do begin
    Position:=poDesigned;
    if X<0 then X:=Left;
    if Y<0 then Y:=Top;
    CheckScreenBounds(Screen,x,y,Width,Height);
    Left:=x; Top:=y;
    end;
  Caption:=_('Preferred settings for new sheets');
  pcPrefs.ActivePageIndex:=0;
  paDesc.Visible:=false;
  ClientHeight:=DefHeight-padesc.Height;
  PUnit:=APlotUnit;
  with rgUnit do begin
    ItemIndex:=integer(aPlotUnit);
    Enabled:=true;
    end;
  cbForms.ItemIndex:=0;
  FSheet:=ASheet;
  with ASheet do if APlotUnit=puMetric then ShowData(MetricSheet)
  else ShowData(InchSheet);
  UpdateView;
  ColorDialog.CustomColors.CommaText:=UserColors;
  ActiveControl:=cbForms;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then begin
    APlotUnit:=PUnit;
    with FSheet do if APlotUnit=puMetric then MetricSheet:=SaveData
    else InchSheet:=SaveData;
    ASheet:=FSheet;
    end;
  end;

function TPreferencesDialog.SheetProperties (APos : TPoint; const FName: string; ASheet : TSheet) : boolean;
var
  New : boolean;
begin
  if APos.X<0 then Position:=poScreenCenter
  else with APos do begin
    Position:=poDesigned;
    if X<0 then X:=Left;
    if Y<0 then Y:=Top;
    CheckScreenBounds(Screen,x,y,Width,Height);
    Left:=x; Top:=y;
    end;
  New:=length(FName)=0;
  if New then Caption:=_('Create new sheet')
  else Caption:=TryFormat(_('Edit sheet properties [%s]'),[FName]);
  pcPrefs.ActivePageIndex:=0;
  paDesc.Visible:=true;
  ClientHeight:=DefHeight;
  cbForms.ItemIndex:=0;
  with ASheet do begin
    PUnit:=PlotUnit;
    with rgUnit do begin
      ItemIndex:=integer(PlotUnit);
      Enabled:=New;
      end;
    ShowData(Properties);
    edDesc.Text:=SheetDesc;
    end;
  UpdateView;
  ColorDialog.CustomColors.CommaText:=UserColors;
  ActiveControl:=edDesc;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then with ASheet do begin
    if New then PlotUnit:=TPlotUnit(rgUnit.ItemIndex);
    SheetDesc:=edDesc.Text;
    Properties:=SaveData;
    end;
  end;

function EditPreferences (APos : TPoint; var APlotUnit : TPlotUnit;
                          var ASheet : TDefaultSheet) : boolean;
begin
  if not assigned(PreferencesDialog) then PreferencesDialog:=TPreferencesDialog.Create(Application);
  Result:=PreferencesDialog.Preferences(APos,APlotUnit,ASheet);
  FreeAndNil(PreferencesDialog);
  end;

function EditSheetProperties (APos : TPoint; const FName: string; ASheet : TSheet) : boolean;
begin
  if not assigned(PreferencesDialog) then PreferencesDialog:=TPreferencesDialog.Create(Application);
  Result:=PreferencesDialog.SheetProperties(APos,FName,ASheet);
  FreeAndNil(PreferencesDialog);
  end;

initialization
  with DefSheet do begin  // set to program default preferences
    MetricSheet:=MetricSheetProps;
    InchSheet:=InchSheetProps
    end;

end.
