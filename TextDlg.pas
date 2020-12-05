(* RPlot dialog
   Edit text properties

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

unit TextDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, RPlotObjects, RPlotUtils,
  NumberEd, Vcl.Dialogs, Vcl.ComCtrls, RadioDials;

type
  TTextDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    edDescription: TLabeledEdit;
    meText: TMemo;
    Label1: TLabel;
    Label3: TLabel;
    feSize: TFloatRangeEdit;
    laUnit5: TLabel;
    cbBold: TCheckBox;
    cbItalic: TCheckBox;
    gbBackground: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    cbTrans: TCheckBox;
    gbBorder: TGroupBox;
    cbBorder: TCheckBox;
    feBWidth: TFloatRangeEdit;
    laBWidth: TLabel;
    laBUnit: TLabel;
    gbProps: TGroupBox;
    ColorDialog: TColorDialog;
    reAngle: TRangeEdit;
    lbFonts: TListBox;
    cbShow: TCheckBox;
    gbPos: TGroupBox;
    Label6: TLabel;
    feLeft: TFloatRangeEdit;
    Label7: TLabel;
    Label8: TLabel;
    feBottom: TFloatRangeEdit;
    Label9: TLabel;
    edPreview: TEdit;
    pcType: TPageControl;
    tsMode: TTabSheet;
    tsText: TTabSheet;
    gbCurve: TGroupBox;
    cxCurveSelect: TComboBox;
    cbDesc: TCheckBox;
    cbSigma: TCheckBox;
    bbCharTab: TBitBtn;
    edLegendText: TLabeledEdit;
    pcMode: TPageControl;
    tsFitResult: TTabSheet;
    tsLegText: TTabSheet;
    cbSymbol: TCheckBox;
    tsComment: TTabSheet;
    edComment: TLabeledEdit;
    rbLeftTop: TRadioButton;
    paAlign: TPanel;
    rbLeftBottom: TRadioButton;
    rbRightTop: TRadioButton;
    rbCenterTop: TRadioButton;
    Shape1: TShape;
    rbCenterCenter: TRadioButton;
    rbCenterBottom: TRadioButton;
    rbRightBottom: TRadioButton;
    rbLeftCenter: TRadioButton;
    rbRightCenter: TRadioButton;
    Label10: TLabel;
    rdAngle: TRadioDial;
    bbTextFormat: TBitBtn;
    bbColor: TBitBtn;
    shBackground: TShape;
    bbBgColor: TBitBtn;
    bbLineColor: TBitBtn;
    cbUnits: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bbLineColorClick(Sender: TObject);
    procedure bbColorClick(Sender: TObject);
    procedure bbBgColorClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateViewClick(Sender: TObject);
    procedure bbCharTabClick(Sender: TObject);
    procedure rbLeftTopClick(Sender: TObject);
    procedure rbLeftCenterClick(Sender: TObject);
    procedure rbLeftBottomClick(Sender: TObject);
    procedure rbCenterTopClick(Sender: TObject);
    procedure rbCenterCenterClick(Sender: TObject);
    procedure rbCenterBottomClick(Sender: TObject);
    procedure rbRightTopClick(Sender: TObject);
    procedure rbRightCenterClick(Sender: TObject);
    procedure rbRightBottomClick(Sender: TObject);
    procedure reAngleChange(Sender: TObject);
    procedure rdAngleChange(Sender: TObject);
    procedure bbTextFormatClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure meTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    FIniName     : string;
    Bitmap       : TBitmap;
    FAlign       : TTextAlign;
    procedure UpdateView;
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    procedure LoadFromIni (const AIniName : string);
    function Execute(AText : TTextItem) : boolean;
  end;

var
  TextDialog: TTextDialog;

implementation

{$R *.dfm}

uses GnuGetText, WinUtils, ExtSysUtils, NumberUtils, System.IniFiles,
  CharTableDlg, TextFormatDlg;

const
  BitMapHeight=8;
  defText = 'The quick brown fox jumps ..';

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
procedure TTextDialog.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (ModalResult=mrOK) and (pcType.ActivePageIndex=1) then begin
    CanClose:=cxCurveSelect.ItemIndex>0;
    if not CanClose then begin
      ErrorDialog(TopRightPos(cxCurveSelect),_('Please select a curve!'));
      cxCurveSelect.SetFocus;
      end;
    end;
  end;

procedure TTextDialog.FormCreate(Sender: TObject);
var
  dc : HDC;
  lf : TLogFont;
begin
  TranslateComponent (self);
  BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=bbLineColor.Width-6;
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
procedure TTextDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TTextDialog.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (TextSekt,IniLeft,Left);
    Top:=ReadInteger (TextSekt,IniTop,Top);
    Free;
    end;
  end;

procedure TTextDialog.meTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then Modalresult:=mrCancel;
  end;

procedure TTextDialog.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (TextSekt,IniLeft,Left);
    WriteInteger (TextSekt,IniTop,Top);
    Free;
    end;
  BitMap.Free;
  end;

{ ------------------------------------------------------------------- }
procedure TTextDialog.UpdateView;
var
  s : string;
  i : integer;
begin
  with bbBgColor do begin
    Enabled:=not cbTrans.Checked;
    with shBackground.Brush do if Enabled then begin
      Style:=bsSolid; Color:=bbBgColor.Tag;
      end
    else Style:=bsClear;
    end;
  with shBackground.Pen do if cbBorder.Checked then Style:=psSolid else Style:=psClear;
  feBWidth.Enabled:=cbBorder.Checked;
  with lbFonts do s:=Items[ItemIndex];
  with edPreview do begin
    with Font do begin
      Name:=s;
      Color:=bbColor.Tag;
      Style:=[];
      if cbBold.Checked then Style:=Style+[fsBold];
      if cbItalic.Checked then Style:=Style+[fsItalic];
      end;
    if pcType.ActivePageIndex=0 then with meText do begin
      i:=0;
      while (i<Lines.Count) and (length(Lines[i])=0) do inc(i);
      if i<Lines.Count then s:=Lines[i] else s:=defText;
      end
    else if pcType.ActivePageIndex=1 then begin
      if pcMode.ActivePageIndex=1 then begin
        with edLegendText do if length(Text)>0 then s:=Text else s:=defText;
        with cxCurveSelect do cbSymbol.Visible:=integer(Items.Objects[ItemIndex]) and $F0000>0;
        end
      else s:=defText;
      end
    else with edComment do if length(Text)>0 then s:=Text else s:=defText;
    Text:=s;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TTextDialog.rbCenterBottomClick(Sender: TObject);
begin
  FAlign:=alCenterBottom;
  end;

procedure TTextDialog.rbCenterCenterClick(Sender: TObject);
begin
  FAlign:=alCenterAll;
  end;

procedure TTextDialog.rbCenterTopClick(Sender: TObject);
begin
  FAlign:=alCenterTop;
  end;

procedure TTextDialog.rbLeftBottomClick(Sender: TObject);
begin
  FAlign:=alLeftBottom;
  end;

procedure TTextDialog.rbLeftCenterClick(Sender: TObject);
begin
  FAlign:=alLeftCenter;
  end;

procedure TTextDialog.rbLeftTopClick(Sender: TObject);
begin
  FAlign:=alLeftTop;
  end;

procedure TTextDialog.rbRightBottomClick(Sender: TObject);
begin
  FAlign:=alRightBottom;
  end;

procedure TTextDialog.rbRightCenterClick(Sender: TObject);
begin
  FAlign:=alRightCenter;
  end;

procedure TTextDialog.rbRightTopClick(Sender: TObject);
begin
  FAlign:=alRightTop
  end;

{ ------------------------------------------------------------------- }
procedure TTextDialog.bbBgColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbBgColor.Tag;
    if Execute then begin
      bbBgColor.Tag:=Color;
      shBackground.Brush.Color:=Color;
      end;
    end;
  end;

procedure TTextDialog.bbLineColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbLineColor.Tag;
    if Execute then begin
      FillBtnGlyph(Bitmap,bbLineColor,Color);
      shBackground.Pen.Color:=Color;
      end;
    end;
 end;

procedure TTextDialog.bbColorClick(Sender: TObject);
begin
  with ColorDialog do begin
    Color:=bbColor.Tag;
    if Execute then begin
      bbColor.Tag:=Color;
      UpdateView;
      end;
    end;
  end;

procedure TTextDialog.rdAngleChange(Sender: TObject);
begin
  with reAngle do if Tag=0 then Value:=-rdAngle.Position;
  end;

procedure TTextDialog.reAngleChange(Sender: TObject);
begin
  with reAngle do begin
    Tag:=1;
    rdAngle.Position:=90-(Value+90) mod 360;
    Tag:=0;
    end;
  end;

procedure TTextDialog.UpdateViewClick(Sender: TObject);
begin
  UpdateView;
  end;

procedure TTextDialog.bbTextFormatClick(Sender: TObject);
var
  s : string;
begin
  if pcType.ActivePageIndex=0 then with meText do begin
    s:=SelText;
    if EditTextFormat(BottomRightPos(bbTextFormat),s) then SelText:=s;
    SetFocus;
    end
  else if pcType.ActivePageIndex=2 then with edComment do begin
    s:=SelText;
    if EditTextFormat(BottomRightPos(bbTextFormat),s) then SelText:=s;
    SetFocus;
    end
  else with edLegendText do begin
    s:=SelText;
    if EditTextFormat(BottomRightPos(bbTextFormat),s) then SelText:=s;
    SetFocus;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TTextDialog.bbCharTabClick(Sender: TObject);
var
  c : char;
begin
  c:=CharFromTable (TopRightPos(bbCharTab),edPreview.Font.Name);
  case pcType.ActivePageIndex of
  0 : with meText do begin
      if c>#0 then SelText:=c;
      SetFocus;
      end;
  1 : if pcMode.ActivePageIndex=1 then with edLegendText do begin
      if c>#0 then SelText:=c;
      SetFocus;
      end;
  2 : with edComment do begin
      if c>#0 then SelText:=c;
      SetFocus;
      end;
    end;
  end;

function TTextDialog.Execute (AText : TTextItem) : boolean;
var
  metr : boolean;
  s    : string;
  i    : integer;
  p    : TFPoint;
  ai   : TChartItem;
begin
  metr:=AText.ParentChart.ParentSheet.PlotUnit=puMetric;
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
  with AText do begin
    gbBackground.Visible:=true; gbBorder.Visible:=true;
    bbCharTab.Visible:=true;
    if TextType=ttText then begin        // text box
      pcType.ActivePageIndex:=0;
      meText.Text:=Text;
      ActiveControl:=meText;
      edDescription.EditLabel.Caption:=_('Name of text box:');
      s:=_('Text box');
      end
    else if TextType=ttComment then begin     // comment
      pcType.ActivePageIndex:=2;
      gbBackground.Visible:=false; gbBorder.Visible:=false;
      edComment.Text:=Text;
      ActiveControl:=edComment;
      FAlign:=Properties.Align;
      case FAlign of
      alLeftCenter   : rbLeftCenter.Checked:=true;
      alLeftTop      : rbLeftTop.Checked:=true;
      alCenterBottom : rbCenterBottom.Checked:=true;
      alCenterAll    : rbCenterCenter.Checked:=true;
      alCenterTop    : rbCenterTop.Checked:=true;
      alRightBottom  : rbRightBottom.Checked:=true;
      alRightCenter  : rbRightCenter.Checked:=true;
      alRightTop     : rbRightTop.Checked:=true;
      else rbLeftBottom.Checked:=true;
        end;
      edDescription.EditLabel.Caption:=_('Name of comment:');
      s:=_('Comment');
      end
    else begin
      pcType.ActivePageIndex:=1;                // fit or legend
      with ParentChart do begin
        with cxCurveSelect do begin
          Clear;
          AddItem(_('<not selected>'),nil);
          end;
        if TextType<>ttFitResult then begin
          ai:=GetFirstItem(itCurve);            // add all curves for legend
          while assigned(ai) do with ai do begin
            cxCurveSelect.AddItem(Description,pointer(WordsToCardinal(1,ItemID)));
            ai:=GetNextItem(itCurve);                             // has symbol
            end;
          end;
        ai:=GetFirstItem(itFit);
        while assigned(ai) do with ai do begin  // add fits for both
          cxCurveSelect.AddItem(Description,pointer(WordsToCardinal(0,ItemID)));
          ai:=GetNextItem(itFit);                                 // no symbol
          end;
        if TextType<>ttFitResult then begin     // add curves for legend
          ai:=GetFirstItem(itFunction);
          while assigned(ai) do with ai do begin
            cxCurveSelect.AddItem(Description,pointer(WordsToCardinal(0,ItemID)));
            ai:=GetNextItem(itFunction);                          // no symbol
            end;
          ai:=GetFirstItem(itGraph);
          while assigned(ai) do with ai do begin
            cxCurveSelect.AddItem(Description,pointer(WordsToCardinal(0,ItemID)));
            ai:=GetNextItem(itGraph);                          // no symbol
            end;
          end;
        end;
      with cxCurveSelect do begin
        if Items.Count>1 then ItemIndex:=1 else ItemIndex:=0;
        for i:=0 to Items.Count-1 do if integer(Items.Objects[i]) and $FFFF=CurveID then begin
          ItemIndex:=i; Break;
          end;
        end;
      with pcMode do if TextType=ttFitResult then begin
        ActivePageIndex:=0;
        ActiveControl:=cxCurveSelect;
        gbCurve.Caption:=_('Select best-fit curve');
        cbDesc.Checked:=toDesc in Options;
        cbSigma.Checked:=toSigma in Options;
        cbUnits.Checked:=toUnits in Options;
        bbCharTab.Visible:=false;
        edDescription.EditLabel.Caption:=_('Name of best-fit result:');
        s:=_('Best-fit result');
        end
      else begin
        ActivePageIndex:=1;
        ActiveControl:=edLegendText;
        gbCurve.Caption:=_('Select curve or function');
        edLegendText.Text:=Text;
        cbSymbol.Checked:=toSymbol in Options;
        edDescription.EditLabel.Caption:=_('Name of legend:');
        s:=_('Legend');
        end;
      end;
    if IsNew then Caption:=TryFormat(_('Create %s for %s'),[s,ParentChart.ChartDesc])
    else Caption:=GetItemName(itText,TextType)+TryFormat(_('Edit %s of %s'),[Description,ParentChart.ChartDesc]);
    edDescription.Text:=Description;
    bbTextFormat.Visible:=bbCharTab.Visible;
    with Position do begin
      feLeft.Value:=X; feBottom.Value:=Y;
      end;
    cbShow.Checked:=Visible;
    with Properties do begin
      with Font do begin
        i:=lbFonts.Items.IndexOf(FontName);
        if i<0 then i:=lbFonts.Items.IndexOf(defFontName);
        if i<0 then i:=0;
        lbFonts.ItemIndex:=i;
        feSize.Value:=FontSize;
        reAngle.Value:=FontAngle;
        bbColor.Tag:=FontColor;
        cbBold.Checked:=fsBold in FontStyle;
        cbItalic.Checked:=fsItalic in FontStyle;
        end;
      cbTrans.Checked:=Transparent;            // transparenter Hintergrund
      cbBorder.Checked:=Border;                // mit Umrahmung
      feBWidth.Value:=LWidth;                  // Linienbreite - Rahmen
      FillBtnGlyph(Bitmap,bbLineColor,LColor); // Farbe - Linien
      bbBgColor.Tag:=BgColor;                  // Farbe - Hintergrund
      shBackground.Pen.Color:=LColor;
      end;
    UpdateView;
    end;
  ColorDialog.CustomColors.CommaText:=UserColors;
  Result:=ShowModal=mrOK;
  UserColors:=ColorDialog.CustomColors.CommaText;
  if Result then with AText do begin
    Description:=edDescription.Text;
    if TextType=ttText then Text:=meText.Text
    else if TextType=ttComment then begin
      Text:=edComment.Text;
      Properties.Align:=FAlign;
      Properties.Font.FontAngle:=reAngle.Value;
      end
    else begin
      with cxCurveSelect do if ItemIndex>0 then CurveID:=integer(Items.Objects[ItemIndex]) and $FFFF;
      Options:=[];
      if TextType=ttFitResult then begin
        if cbDesc.Checked then Include(Options,toDesc);
        if cbSigma.Checked then Include(Options,toSigma);
        if cbUnits.Checked then Include(Options,toUnits);
        with ParentChart do (Item[IndexOf(CurveID)] as TFitItem).FitData.Computed:=false;
        end
      else begin
        Text:=edLegendText.Text;
        with cxCurveSelect do
          metr:=(integer(Items.Objects[ItemIndex]) and $F0000>0) and cbSymbol.Checked;
        if metr then Include(Options,toSymbol);
        end;
      end;

    with p do begin
      X:=feLeft.Value; Y:=feBottom.Value;
      end;
    Position:=p;
    Visible:=cbShow.Checked;
    with Properties do begin
      with Font do begin
        with lbFonts do FontName:=Items[ItemIndex];
        FontSize:=feSize.Value;
        FontColor:=bbColor.Tag;
        FontStyle:=[];
        if cbBold.Checked then Include(FontStyle,fsBold);
        if cbItalic.Checked then Include(FontStyle,fsItalic);
        with lbFonts do FontType:=GetFontType(byte(Items.Objects[ItemIndex]));
        end;
      Transparent:=cbTrans.Checked;            // transparenter Hintergrund
      Border:=cbBorder.Checked;                // mit Umrahmung
      LWidth:=feBWidth.Value;                  // Linienbreite - Rahmen
      LColor:=bbLineColor.Tag;                 // Farbe - Linien
      BgColor:=bbBgColor.Tag;                  // Farbe - Hintergrund
      end;
    end;
  end;

end.
