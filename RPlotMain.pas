(* RPlot main program
   create scientific plots
   - Sheet    : base form
   - Chart    : a diagram placed on sheet (any number)
   - Axis     : hor. or vertical axis of chart (any number)
   - Curve    : x-y-diagram of measuremnet values (any number)
   - Function : curve computed from a formula

   © J. Rathlev, D-24222 Schwentinental, (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Vers. 1.0, July 2012    - Basic version
         1.1, June 2015    - Bug fixes
         1.2, June 2016    - Implementation to Delphi 10
         1.3: January 2020 - Enhancements
   last modified January 2020
   *)

unit RPlotMain;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Menus,
  Vcl.ImgList, Vcl.ComCtrls, NumberEd, WinUtils, HListBox,
  RPlotObjects, RPlotUtils, PsPlot, PrefsDlg, LangUtils, System.ImageList;

const
  ProgName='R-Plot';
  Vers=' - Vers. 1.3';
  CopRgt='© 2012-2020 - J. Rathlev, D-24222 Schwentinental';
  EMailAdr='kontakt(a)rathlev-home.de';

type
  TZoomMode=(zmOrg,zmIn,ZmOut);

  TfrmSheet=class(TForm)
    paLeft : TPanel;
    paMain : TPanel;
    Label3 : TLabel;
    laChart : TLabel;
    sbItemUp : TSpeedButton;
    sbItemDown : TSpeedButton;
    sbChartUp : TSpeedButton;
    sbChartDown : TSpeedButton;
    bbNewChart: TBitBtn;
    bbEditChart: TBitBtn;
    bbRemoveChart: TBitBtn;
    edDesc : TLabeledEdit;
    bbEditSheet : TBitBtn;
    bbEditItem : TBitBtn;
    bbRemoveItem : TBitBtn;
    gbObjects : TGroupBox;
    bbAddAxis : TBitBtn;
    bbAddCurve : TBitBtn;
    bbAddFunction : TBitBtn;
    bbAddImage : TBitBtn;
    bbAddText : TBitBtn;
    bbAddFit: TBitBtn;
    bbAddDrawing: TBitBtn;
    MainMenu : TMainMenu;
    itSheet : TMenuItem;
    itNewSheet : TMenuItem;
    itLoadSheet : TMenuItem;
    itSaveSheet : TMenuItem;
    itSaveSheetAs : TMenuItem;
    N1 : TMenuItem;
    itQuit : TMenuItem;
    sbCopy : TSpeedButton;
    sbEps : TSpeedButton;
    sbLoad : TSpeedButton;
    sbNewSheet : TSpeedButton;
    sbPrint : TSpeedButton;
    sbQuit : TSpeedButton;
    sbRefresh : TSpeedButton;
    sbSaveSheet : TSpeedButton;
    sbSaveSheetAs : TSpeedButton;
    sbZoomIn : TSpeedButton;
    sbZoomOut : TSpeedButton;
    OpenDialog : TOpenDialog;
    SaveDialog : TSaveDialog;
    PrintDialog : TPrintDialog;
    bbAddGraph: TBitBtn;
    pmNewText : TPopupMenu;
    piAddText: TMenuItem;
    piAddLegend: TMenuItem;
    piAddResult: TMenuItem;
    itChart: TMenuItem;
    otNewChart: TMenuItem;
    itEditChart: TMenuItem;
    itRemoveChart: TMenuItem;
    itComponent: TMenuItem;
    itAddComp: TMenuItem;
    itEditComp: TMenuItem;
    itRemoveComp: TMenuItem;
    itAddAxis: TMenuItem;
    itAddCurve: TMenuItem;
    itAddFunction: TMenuItem;
    itAddText: TMenuItem;
    itAddImage: TMenuItem;
    itAddOther: TMenuItem;
    itAddTextBox: TMenuItem;
    itAddLegend: TMenuItem;
    itAddFitResult: TMenuItem;
    itAddLine: TMenuItem;
    itInfo: TMenuItem;
    itPreferences: TMenuItem;
    piAddComment: TMenuItem;
    N2: TMenuItem;
    itPrint: TMenuItem;
    itExport: TMenuItem;
    itPostscript: TMenuItem;
    itClipboard: TMenuItem;
    pmNewGraph: TPopupMenu;
    piAddBarchart: TMenuItem;
    piAddHistogram: TMenuItem;
    piAddPieChart: TMenuItem;
    sbPipette: TSpeedButton;
    pmAxis: TPopupMenu;
    piXAxis: TMenuItem;
    piYAxis: TMenuItem;
    piCopyAxis: TMenuItem;
    bbDupChart: TBitBtn;
    itAddGraph: TMenuItem;
    itAddBarGraph: TMenuItem;
    itAddHisto: TMenuItem;
    itAddComment: TMenuItem;
    itLanguage: TMenuItem;
    itSheetPrefs: TMenuItem;
    lvItems: TListView;
    lvCharts: TListView;
    laArea: TLabel;
    sbLoadHist: TSpeedButton;
    itRecent: TMenuItem;
    pmSheets: TPopupMenu;
    itAddFit: TMenuItem;
    itAddXAxis: TMenuItem;
    itAddYAxis: TMenuItem;
    itViewAll: TSpeedButton;
    pmDrawing: TPopupMenu;
    piLine: TMenuItem;
    piRectangle: TMenuItem;
    bbUndoItem: TBitBtn;
    bbUndoChart: TBitBtn;
    ImageList: TImageList;
    itHelp: TMenuItem;
    N4: TMenuItem;
    itAbout: TMenuItem;
    itRef: TMenuItem;
    Edit1: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    itAddRect: TMenuItem;
    bbDupItem: TBitBtn;
    N6: TMenuItem;
    itWeb: TMenuItem;
    itChangelog: TMenuItem;
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure bbEditSheetClick(Sender : TObject);
    procedure lvChartsClick(Sender : TObject);
    procedure bbNewChartClick(Sender : TObject);
    procedure bbEditChartClick(Sender : TObject);
    procedure bbRemoveChartClick(Sender : TObject);
    procedure bbEditItemClick(Sender : TObject);
    procedure bbRemoveItemClick(Sender : TObject);
    procedure sbItemUpClick(Sender : TObject);
    procedure sbItemDownClick(Sender : TObject);
    procedure sbChartUpClick(Sender : TObject);
    procedure sbChartDownClick(Sender : TObject);
    procedure lvChartsDblClick(Sender : TObject);
    procedure piXAxisClick(Sender : TObject);
    procedure bbAddCurveClick(Sender : TObject);
    procedure bbAddFunctionClick(Sender : TObject);
    procedure bbAddImageClick(Sender : TObject);
    procedure piAddTextClick(Sender : TObject);
    procedure piAddResultClick(Sender : TObject);
    procedure bbAddDrawingClick(Sender : TObject);
    procedure sbNewSheetClick(Sender : TObject);
    procedure sbLoadClick(Sender : TObject);
    procedure sbSaveSheetClick(Sender : TObject);
    procedure sbSaveSheetAsClick(Sender : TObject);
    procedure sbZoomInClick(Sender : TObject);
    procedure sbZoomOutClick(Sender : TObject);
    procedure sbRefreshClick(Sender : TObject);
    procedure sbQuitClick(Sender : TObject);
    procedure sbPrintClick(Sender : TObject);
    procedure sbEpsClick(Sender : TObject);
    procedure sbCopyClick(Sender : TObject);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure bbAddTextClick(Sender : TObject);
    procedure piAddLegendClick(Sender : TObject);
    procedure itPreferencesClick(Sender: TObject);
    procedure piAddCommentClick(Sender: TObject);
    procedure itInfoClick(Sender: TObject);
    procedure piAddBarchartClick(Sender: TObject);
    procedure piAddHistogramClick(Sender: TObject);
    procedure piAddPieChartClick(Sender: TObject);
    procedure bbAddGraphClick(Sender: TObject);
    procedure sbPipetteClick(Sender: TObject);
    procedure piYAxisClick(Sender: TObject);
    procedure bbAddAxisClick(Sender: TObject);
    procedure piCopyAxisClick(Sender: TObject);
    procedure bbDupChartClick(Sender: TObject);
    procedure edDescChange(Sender: TObject);
    procedure lvItemsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bbAddFitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LoadFromListClick (Sender : TObject; FileName   : string);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sbLoadHistClick(Sender: TObject);
    procedure itViewAllClick(Sender: TObject);
    procedure piRectangleClick(Sender: TObject);
    procedure piLineClick(Sender: TObject);
    procedure bbUndoItemClick(Sender: TObject);
    procedure bbUndoChartClick(Sender: TObject);
    procedure itHelpClick(Sender: TObject);
    procedure itRefClick(Sender: TObject);
    procedure bbDupItemClick(Sender: TObject);
    procedure itWebClick(Sender: TObject);
    procedure itChangelogClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ProgVersName,ProgVersDate,
    AppPath,ProgPath,
    PrtName,TmpPath,
    LastSheet,LastEps,
    CmdName,FIniName,
    RpName                    : string;
    SelChart                  : integer;
    DefPlotUnit               : TPlotUnit;
    UserSheet                 : TDefaultSheet;
    PrPlot                    : TSheetToPrinter;
    FormRect                  : TRect;
    DelCount                  : integer;
    SheetList                 : THistoryList;
    Languages                 : TLanguageList;
    Changed                   : boolean;
    function AskForSave : boolean;
    procedure LoadSheet(const AFilename : string);
    procedure SaveSheet;
    procedure SaveSheetAs;
    procedure SetLanguageClick(Sender : TObject; Language : TLangCodeString);
    procedure ActivateHandler(Sender : TObject);
    procedure SetCaption(ACaption : string);
    function GetPrinterName : string;
    procedure Print;
    function NewChart : boolean;
    function GetImage (Visible,Deleted : boolean) : integer;
    procedure ShowItems(AIndex : integer);
    function EditAxis (ai : TAxisItem) : boolean;
    procedure DupAxis (ao : TAxisItem);
    procedure AddGraphObject(gt :  TGraphType);
    procedure AddTextObject(tt :  TTextType);
    procedure AddDrawingObject(dt :  TDrawingType);
  public
    { Public-Deklarationen }
    Sheet      : TSheet;
    DefSheet   : TDefaultSheet;
    UserPath   : string;
    procedure UpdateSheet (ChartIndex : integer; ObjectIndex : integer = 0);
    procedure SetChangeStatus (Status : boolean = true);
    procedure SelectItem (AItemIndex : TChartItemIndex);
    function GetItemName (AItemIndex : TChartItemIndex) : string;
    function EditItem (AIndex : integer) : boolean;
    procedure EditChart;
  end;

var
  frmSheet : TfrmSheet;

implementation

{$R *.dfm}
{$R Cursors.res}

uses Winapi.ShellAPI, System.IniFiles, Vcl.Printers, Vcl.Clipbrd,
  GnuGetText, InitProg, FileUtils, StringUtils, ExtSysUtils, ShowText,
  RPlotView, WinApiUtils, ChartDlg, AxisDlg, CurveDlg, DataDlg, FunctionDlg,
  TextDlg, ImageDlg, DrawingDlg, GraphDlg, SelectAxisDlg, FitDlg;

{ ------------------------------------------------------------------- }
procedure TfrmSheet.FormCreate(Sender : TObject);

  procedure ReadOptions;
  var
    s   : string;
    i   : integer;
  begin
    if ParamCount>0 then begin
      for i:=1 to ParamCount do begin
        s:=ParamStr(i);
        if (s[1]='/') or (s[1]='-') then begin
          delete (s,1,1);
          if ReadOptionValue(s,siAltIni) then   // anderer Ort für Ini-Datei
            FIniName:=Erweiter(AppPath,s,IniExt);
          end
        else CmdName:=s;
        end;
      end;
    end;

begin
  TranslateComponent(self);
  InitPaths(AppPath,UserPath,ProgPath);
  InitVersion(ProgName,Vers,CopRgt,3,3,ProgVersName,ProgVersDate);
  RpName:=ProgVersName;
  Languages:=TLanguageList.Create(PrgPath,LangName);
  with Languages do begin
    Menu:=itLanguage;
    LoadLanguageNames(SelectedLanguage);
    OnLanguageItemClick:=SetLanguageClick;
    end;
  Screen.Cursors[crEyeDrop]:=LoadCursor(HInstance,'EYEDROP');
  Screen.Cursors[crFill]:=LoadCursor(HInstance,'FILL');
  Screen.Cursors[crMoveObject]:=LoadCursor(HInstance,'MOVEOBJECT');
  Screen.Cursors[crMovePoint]:=LoadCursor(HInstance,'MOVEPOINT');
  Screen.Cursors[crArrowCheck]:=LoadCursor(HInstance,'ARROWCHECK');
  SheetPath:=SetDirName(SetDirName(UserPath)+defRPlotPath);
  if not DirectoryExists(SheetPath) then ForceDirectories(SheetPath);
  TemplPath:=SetDirName(SheetPath)+defTemplPath;
  ImagePath:=SetDirName(SheetPath)+defImgPath;
  TmpPath:=TempDirectory;
  if not DirectoryExists(TemplPath) then ForceDirectories(TemplPath);
  with DefSheet do begin  // set to program default preferences
    MetricSheet:=MetricSheetProps;
    InchSheet:=InchSheetProps
    end;
  UserSheet:=DefSheet;
  FIniName:='';
  ReadOptions;
  if length(FIniName)=0 then FIniName:=Erweiter(AppPath,PrgName,IniExt);
  with TIniFile.Create(FIniName) do begin
    PrtName:=ReadString(GlobalSekt,iniPrinter,'');
    with FormRect do begin   // position and size of form
      Left:=ReadInteger(GlobalSekt,iniLeft,-1);
      Top:=ReadInteger(GlobalSekt,iniTop,-1);
      Width:=ReadInteger(GlobalSekt,iniWidth,ClientWidth);
      Height:=ReadInteger(GlobalSekt,iniHeight,ClientHeight);
      end;
    LastSheet:=ReadString(GlobalSekt,iniLast,'');
    LastEps:=ReadString(GlobalSekt,iniEps,'');
    DefPlotUnit:=TPlotUnit(ReadInteger(GlobalSekt,iniUnit,integer(puMetric)));
    UserColors:=ReadString(GlobalSekt,iniUColors,'');
    Free;
    end;
  // load user preferences
  LoadSheetProperties (FiniName,puMetric,UserSheet.MetricSheet);
  LoadSheetProperties (FiniName,puInch,UserSheet.InchSheet);
  if ParamCount>0 then begin
    CmdName:=ParamStr(1);
    if not FileExists(CmdName) then CmdName:='';
    end
  else CmdName:='';
  SheetList:=THistoryList.Create;
  with SheetList do begin
    MaxLen:=25;
    LoadFromIni (FIniName,HistSekt);
    Menu2:=itRecent;
    Menu:=pmSheets.Items;
    OnAutoItemClick:=LoadFromListClick;
    end;
  with UserSheet do begin
    MetricSheetProps:=MetricSheet;
    InchSheetProps:=InchSheet;
    end;
  Sheet:=TSheet.Create(self,DefPlotUnit);
  with Printer do begin
    PrinterIndex:=Printers.IndexOf(PrtName);
    Orientation:=poLandscape;
    PrtName:=Printers[PrinterIndex];
    PrPlot:=TSheetToPrinter.Create(Canvas);
    end;
  with Application do begin
    OnActivate:=ActivateHandler;
    end;
  SelChart:=-1; SetChangeStatus(false); DelCount:=0;
  end;

procedure TfrmSheet.FormDestroy(Sender : TObject);
begin
  SaveSheetProperties (FiniName,puMetric,UserSheet.MetricSheet);
  SaveSheetProperties (FiniName,puInch,UserSheet.InchSheet);
  with TIniFile.Create(FIniName) do begin
    WriteString(GlobalSekt,iniProgram,ProgName);
    WriteString(GlobalSekt,iniVersion,VersInfo.Version);
    WriteString(GlobalSekt,iniPrinter,PrtName);
    WriteInteger(GlobalSekt,iniLeft,Left);
    WriteInteger(GlobalSekt,iniTop,Top);
    WriteInteger(GlobalSekt,iniWidth,ClientWidth);
    WriteInteger(GlobalSekt,iniHeight,ClientHeight);
    WriteString(GlobalSekt,iniLast,LastSheet);
    WriteString(GlobalSekt,iniEps,LastEps);
    WriteInteger(GlobalSekt,iniUnit,integer(DefPlotUnit));
    WriteString(GlobalSekt,IniUColors,UserColors);
    Free;
    end;
  SheetList.SaveToIni (FIniName,HistSekt,true);
  SheetList.Free; PrPlot.Free; Sheet.Free;
  end;

procedure TfrmSheet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then begin
    frmView.SelectColor(false);
    sbPipette.Down:=false;
    end;
  end;

procedure TfrmSheet.FormResize(Sender: TObject);
begin
  with lvCharts do Columns[0].Width:=Width-Columns[1].Width-21;
  with lvItems do Columns[0].Width:=Width-Columns[1].Width-21;
  end;

procedure TfrmSheet.FormShow(Sender : TObject);
var
  s : string;
  r : TRect;
begin
  frmView.LoadFromIni(FIniName);
  with frmView do r:=Rect(Left,Top,Left+Width,Top+Height);
  with FormRect do begin
    if (Left<0) or r.Contains(TopLeft) or r.Contains(BottomRight) then
      Location:=Point(r.Right+10,r.Top);
    if (Top<0) then Top:=r.Top;
    end;
  Left:=FormRect.Left;
  Top:=FormRect.Top;
  ClientWidth:=FormRect.Width;
  ClientHeight:=FormRect.Height;
  ChartDialog.LoadFromIni(FIniName);
  AxisDialog.LoadFromIni(FIniName);
  CurveDialog.LoadFromIni(FIniName);
  FitDialog.LoadFromIni(FIniName);
  GraphDialog.LoadFromIni(FIniName);
  FunctionDialog.LoadFromIni(FIniName);
  DataDialog.LoadFromIni(FIniName);
  TextDialog.LoadFromIni(FIniName);
  ImageDialog.LoadFromIni(FIniName);
  DrawingDialog.LoadFromIni(FIniName);
  if length(CmdName)>0 then s:=CmdName
  else if FileExists(LastSheet) then s:=LastSheet
  else s:='';
  if length(s)>0 then begin
    Sheet.LoadFromFile(s); // ***
    SetCaption(RpName+' ['+ExtractFilename(s)+']');
    end
  else SetCaption(RpName+' ['+_('New sheet')+']');
  with frmView do begin
    Show;
    InitWindowPlot;
    InitView;
    ShowPrinter(GetPrinterName);
    end;
  UpdateSheet(-1);
  SetChangeStatus(false);
  end;

procedure TfrmSheet.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  frmView.Close;
  end;

procedure TfrmSheet.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=AskForSave;
  end;

procedure TfrmSheet.ActivateHandler(Sender : TObject);
begin
  ImageDialog.Update;
  end;

function TfrmSheet.AskForSave : boolean;
var
  s  : string;
  n : word;
begin
  if Changed or (DelCount>0) then begin
    Result:=false;       // Abbruch
    if (length(Sheet.Filename)>0) then begin
      s:=TryFormat(_('Save changed sheet to %s?'),[ExtractFilename(Sheet.Filename)]);
      end
    else s:=_('Save new sheet?');
    n:=MessageDialog(CursorPos,s,mtConfirmation,mbYesNoCancel);
    if n<>mrCancel then begin
      if n=mrYes then begin  // sichern
        if length(Sheet.Filename)=0 then SaveSheetAs else SaveSheet;
        end;
      Result:=true;  // ok
      SetChangeStatus(false); DelCount:=0;
      end
    end
  else Result:=true;  // OK
  end;

procedure TfrmSheet.SetChangeStatus (Status : boolean);
begin
  Changed:=Status;
  sbSaveSheet.Enabled:=Status;
  end;

procedure TfrmSheet.sbNewSheetClick(Sender : TObject);
var
  sh : TSheet;
begin
  if AskForSave then begin
    sh:=TSheet.Create(self,DefPlotUnit);
    if EditSheetProperties(BottomRightPos(sbNewSheet),'',sh) then begin
      Sheet.Free;
      Sheet:=sh;
      SetCaption(RpName+' ['+_('New sheet')+']');
      UpdateSheet(-1);
      frmView.InitView;
      SelChart:=-1;
      SetChangeStatus(false); DelCount:=0;
      end
    else sh.Free;
    end;
  end;

procedure TfrmSheet.LoadSheet(const AFilename : string);
begin
  LastSheet:=AFilename;
  SheetList.AddString(MakeRelativePath(SheetPath,AFilename));
  SetCaption(RpName+' ['+ExtractFilename(LastSheet)+']');
  Sheet.LoadFromFile(LastSheet);
  UpdateSheet(0);
  SetChangeStatus(false);
  with frmView do begin
    InitView; ZoomView(zmOrg);
    end;
  end;

procedure TfrmSheet.sbLoadClick(Sender : TObject);
begin
  if AskForSave then with OpenDialog do begin
    if length(LastSheet)>0 then InitialDir:=ExtractFilePath(LastSheet)
    else InitialDir:=SheetPath;
    Filename:='*.'+XrpExt;
    DefaultExt:=XrpExt;
    Filter:=_('R-Plot sheet')+'|*.'+XrpExt+'|'+_('all')+'|*.*';
    Title:=_('Load R-Plot sheet');
    if Execute then LoadSheet(Filename);
    end;
  end;

procedure TfrmSheet.sbLoadHistClick(Sender: TObject);
begin
  with BottomLeftPos(sbLoadHist) do pmSheets.Popup(x,y);
  end;

procedure TfrmSheet.SaveSheetAs;
begin
  with SaveDialog do begin
    if length(LastSheet)>0 then InitialDir:=ExtractFilePath(LastSheet)
    else InitialDir:=SheetPath;
    Filename:=''; // LastSheet;
    DefaultExt:=XrpExt;
    Filter:=_('R-Plot sheet')+'|*.'+XrpExt+'|'+_('all')+'|*.*';
    Title:=_('Save R-Plot sheet');
    if Execute then begin
      LastSheet:=Filename;
      SheetList.AddString(MakeRelativePath(SheetPath,Filename));
      SetCaption(RpName+' ['+ExtractFilename(LastSheet)+']');
      Sheet.SaveToFile(LastSheet);
      SetChangeStatus(false); DelCount:=0;
      end;
    end;
  end;

procedure TfrmSheet.sbSaveSheetAsClick(Sender : TObject);
begin
  SaveSheetAs;
  end;

procedure TfrmSheet.SaveSheet;
begin
  if length(Sheet.Filename)=0 then SaveSheetAs
  else begin
    Sheet.SaveToFile;
    SetChangeStatus(false); DelCount:=0;
    end;
  end;

procedure TfrmSheet.sbSaveSheetClick(Sender : TObject);
begin
  SaveSheet;
  end;

(* Klick auf Dateilistenmenü *)
procedure TfrmSheet.LoadFromListClick (Sender     : TObject;
                                       FileName   : string);
begin
  if (length(FileName)>0) then FileName:=MakeAbsolutePath(SheetPath,Filename);
  if FileExists (FileName) then begin
    if AskForSave then LoadSheet(FileName);
    end
  else begin
    ErrorDialog (CursorPos,_('File not found:')+sLineBreak+FileName);
    SheetList.RemString (MakeRelativePath(SheetPath,FileName));
    end;
  end;

procedure TfrmSheet.SetCaption(ACaption : string);
begin
  Caption:=ACaption;
  frmView.Caption:=ACaption;
  end;

function TfrmSheet.GetPrinterName;
begin
  with Printer do begin
    if Printers.Count>0 then begin
      PrtName:=Printers[PrinterIndex];
      Result:=_(' Printer: ')+PrtName;
      itPrint.Enabled:=true;
      sbPrint.Enabled:=true;
      end
    else begin
      Result:=_(' No printer available!');
      itPrint.Enabled:=false;
      sbPrint.Enabled:=false;
      end;
    end;
  end;

procedure TfrmSheet.itHelpClick(Sender: TObject);
var
  s : string;
begin
  s:=PrgPath+_('rp-help-en.chm');
  if FileExists(s) then begin
    try
      HtmlHelp(GetDesktopWindow,pchar(s),HH_DISPLAY_TOPIC,0);
    except
      ErrorDialog (CursorPos,_('Help not available on this system!'));
      end;
    end
  else ErrorDialog (CursorPos,_('Help file not found!'));
  end;

procedure TfrmSheet.itInfoClick(Sender: TObject);
begin
  InfoDialog(CursorPos,ProgVersName+' - '+ProgVersDate+sLineBreak+CopRgt
           +sLineBreak+'E-Mail: '+EmailAdr);
  end;

procedure TfrmSheet.itRefClick(Sender: TObject);
begin
  InfoDialog(CursorPos,_('Editor from OpenSource project SynEdit'+sLineBreak+
               'Mathematical parser by J. Dankert'+sLineBreak+
               'Multilanguage system by Lars B. Dybdahl'+sLineBreak+
               'Installation program by Jordan Russell'));
  end;

procedure TfrmSheet.itWebClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',pchar(_('https://www.rathlev-home.de/index-e.html?home-e.html#rplot')),nil,nil,SW_SHOW);
  end;

procedure TfrmSheet.itChangelogClick(Sender: TObject);
var
  s : string;
begin
  s:=Erweiter(PrgPath,_('changelog-e.txt'),'');
  if FileExists(s) then ShowTextFile(CenterPos,s,1,stShowModal,[])
  else ErrorDialog (CursorPos,_('File not found:')+sLineBreak+s);
  end;

procedure TfrmSheet.SetLanguageClick(Sender : TObject; Language : TLangCodeString);
begin
  if not AnsiSameText(SelectedLanguage,Language) then begin
    Languages.SelectedLanguageCode:=Language;
    ChangeLanguage(Language);
    Languages.LoadLanguageNames(SelectedLanguage);
    UpdateSheet(-1);
    frmView.ShowPrinter(GetPrinterName);
    end;
  end;

procedure TfrmSheet.itPreferencesClick(Sender: TObject);
begin
  if EditPreferences(CursorPos,DefPlotUnit,UserSheet) then begin
    if DefPlotUnit=puMetric then MetricSheetProps:=UserSheet.MetricSheet
    else InchSheetProps:=UserSheet.InchSheet;
    end;
  end;

{ ------------------------------------------------------------------- }
function TfrmSheet.GetImage (Visible,Deleted : boolean) : integer;
begin
  if Deleted then Result:=2
  else if Visible then Result:=1
  else Result:=0;
  end;

procedure TfrmSheet.UpdateSheet(ChartIndex,ObjectIndex : integer);
var
  i,n : integer;
begin
  with Sheet do begin
    edDesc.Text:=SheetDesc;
    if PlotUnit=puInch then n:=2 else n:=1;
    if ChartIndex<0 then with Size,Margin do // sheet was changed
      laArea.Caption:=_('Provided area:')+Space+FloatToStrF(Width-Left-Right,ffFixed,5,n)+' '+Units[PlotUnit]+
        ' x '+FloatToStrF(Height-Top-Bottom,ffFixed,5,n)+' '+Units[PlotUnit]+
        ' ('+_('Width x Height')+')';
    with lvCharts do begin
      n:=ItemIndex;
      Clear;
      for i:=0 to ChartCount-1 do with Chart[i],Items.Add do begin
        Caption:=ChartDesc;
        SubItems.Add(GetPluralString(_('no object'),_('1 object'),_('%u objects'),ItemCount));
        ImageIndex:=GetImage(Visible,Deleted);
        end;
      if ChartIndex<0 then ChartIndex:=n;
      if (ChartIndex>=0)and(ChartIndex<ChartCount) then ItemIndex:=ChartIndex
      else if ChartCount>0 then ItemIndex:=0
      else ItemIndex:=-1;
      if assigned(Selected) then Selected.MakeVisible(false);
      end;
    ShowItems(ObjectIndex);
    end;
  frmView.InitView;
  end;

procedure TfrmSheet.ShowItems(AIndex : integer);
var
  i : integer;
begin
  lvItems.Clear;
  with lvCharts do if ItemIndex>=0 then begin
    laChart.Caption:=TryFormat(_('Objects of %s'),[Items[ItemIndex].Caption]);
    SelChart:=ItemIndex;
    with Sheet.Chart[SelChart] do begin
      for i:=0 to ItemCount-1 do with Item[i] do with lvItems.Items.Add do begin
        Caption:=Description;
        SubItems.Add(TypeName);
        ImageIndex:=GetImage(Visible,Deleted);
        end;
      if (ItemCount>0)and(AIndex>=0)and(AIndex<ItemCount) then with lvItems do begin
        ItemIndex:=AIndex;
        Selected.MakeVisible(false);
        end;
      end;
// InitChart(SelChart);
    end
  else laChart.Caption:=_('No chart selected!');
  end;

procedure TfrmSheet.SelectItem(AItemIndex : TChartItemIndex);
begin
  with AItemIndex do if ChartNr>=0 then begin
    with lvCharts do begin
      ItemIndex:=ChartNr;
      Selected.MakeVisible(true);
      end;
    ShowItems(ChartNr);
    if ItemNr>=0 then with lvItems do begin
      ItemIndex:=ItemNr;
      Selected.MakeVisible(true);
      end;
    end;
  end;

function TfrmSheet.GetItemName (AItemIndex : TChartItemIndex) : string;
begin
  with AItemIndex do if ChartNr>=0 then with Sheet.Chart[ChartNr] do
    Result:=ChartDesc+' - '+Item[ItemNr].Description
  else Result:='';
  end;

function TfrmSheet.EditItem (AIndex : integer) : boolean;
var
  n  : integer;
begin
  Result:=false;
  if SelChart<0 then begin
    ErrorDialog(CursorPos,_('No chart selected!')); Exit;
    end
  else frmView.ShowOutline(-1,-1);
  if AIndex>=0 then begin
    with Sheet,Chart[SelChart] do begin
      frmView.ShowOutline(SelChart,AIndex);
      case Item[AIndex].ItemType of
      itAxis :  begin
                Result:=AxisDialog.Execute(Item[AIndex] as TAxisItem);
                if Result then SetInnerArea;
                end;
      itCurve : begin
                Result:=CurveDialog.Execute(Item[AIndex] as TCurveItem);
                UpdateFits(Item[AIndex].ItemID);
                end;
      itFit : Result:=FitDialog.Execute(Item[AIndex] as TFitItem);
      itGraph : Result:=GraphDialog.Execute(Item[AIndex] as TGraphItem);
      itFunction : Result:=FunctionDialog.Execute(Item[AIndex] as TFunctionItem);
      itText : Result:=TextDialog.Execute(Item[AIndex] as TTextItem);
      itImage : Result:=ImageDialog.Execute(ImagePath,Item[AIndex] as TImageItem);
      itDrawing : Result:=DrawingDialog.Execute(Item[AIndex] as TDrawingItem);
      else Result:=false;
        end;
      end;
    if Result then SetChangeStatus;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TfrmSheet.sbQuitClick(Sender : TObject);
begin
  Close;
  end;

procedure TfrmSheet.edDescChange(Sender: TObject);
begin
  Sheet.SheetDesc:=edDesc.Text;
  SetChangeStatus;
  end;

procedure TfrmSheet.bbEditSheetClick(Sender : TObject);
begin
  if EditSheetProperties(TopLeftPos(bbNewChart),ExtractFilename(LastSheet),Sheet) then begin
    UpdateSheet(-1);
    SetChangeStatus;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TfrmSheet.Print;
begin
  with Printer do begin
    Printer.Orientation:=poPortrait;
    Title:=DelExt(Sheet.SheetDesc);
    BeginDoc;
    with PrPlot do begin
      InitSheet(Sheet);
      InitPrint(true);
      PlotSheet(false);
      end;
    EndDoc;
    end;
  end;

procedure TfrmSheet.sbPipetteClick(Sender: TObject);
begin
  frmView.SelectColor(sbPipette.Down);
  end;

procedure TfrmSheet.sbPrintClick(Sender : TObject);
begin
  if PrintDialog.Execute then begin
    with Printer do PrtName:=Printers[PrinterIndex];
    frmView.ShowPrinter(GetPrinterName);
    Print;
    end
  end;

{ ------------------------------------------------------------------- }
procedure TfrmSheet.sbCopyClick(Sender : TObject);
var
  FMeta       : TMetaFile;
  MfPlot      : TSheetToClipboard;
  ACanvas     : TMetaFileCanvas;
  Mf          : word;
  AData       : THandle;
  APal        : HPalette;
  ClipRect    : TRect;
begin
  FMeta:=TMetaFile.Create;
  ClipRect:=frmView.GetClipWindow;
  with FMeta,ClipRect do begin
    MMWidth:=(Right-Left)*10;
    MMHeight:=(Top-Bottom)*10;
    end;
  ACanvas:=TMetaFileCanvas.Create(FMeta,0);
  MfPlot:=TSheetToClipboard.Create(ACanvas);
  with MfPlot do begin
    InitSheet(Sheet);
    InitPrint(false);
    PlotSheet(false);
    end;
  MfPlot.Free;
  ACanvas.Free;
  FMeta.SaveToClipBoardFormat(Mf,AData,APal);
  ClipBoard.SetAsHandle(Mf,AData);
  FMeta.Free;
  end;

procedure TfrmSheet.sbEpsClick(Sender : TObject);
var
  eps  : TSheetToPs;
begin
 with SaveDialog do begin
    if DirectoryExists(LastEps) then InitialDir:=LastEps
    else if length(LastSheet)>0 then InitialDir:=ExtractFilePath(LastSheet)
    else InitialDir:=SheetPath;
    Filename:=ExtractFilename(NewExt(LastSheet,EpsExt));
    DefaultExt:=EpsExt;
    Filter:=_('EPS files')+'|*.'+EpsExt+'|'+_('all')+'|*.*';
    Title:=_('Export sheet to EPS');
    if Execute then begin
      LastEps:=ExtractFilePath(Filename);
      eps:=TSheetToPs.Create(Filename);
      with eps do begin
        InitSheet(Sheet);
        InitPrint(true);
        PlotSheet(false);
        Free;
        end;
       end;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TfrmSheet.sbRefreshClick(Sender : TObject);
begin
  Sheet.ResetCharts;
  frmView.UpdateView;
  end;

procedure TfrmSheet.itViewAllClick(Sender: TObject);
begin
  frmView.ZoomView(zmOrg);
  end;

procedure TfrmSheet.sbZoomInClick(Sender : TObject);
begin
  frmView.ZoomView(zmIn);
  end;

procedure TfrmSheet.sbZoomOutClick(Sender : TObject);
begin
  frmView.ZoomView(zmOut);
  end;

{ ------------------------------------------------------------------- }
procedure TfrmSheet.lvChartsClick(Sender : TObject);
begin
  ShowItems(0);
  end;

procedure TfrmSheet.lvChartsDblClick(Sender : TObject);
begin
  ShowItems(0);
  bbEditChartClick(Sender);
  end;

{ ------------------------------------------------------------------- }
function TfrmSheet.NewChart : boolean;
var
  ch : TChart;
begin
  ch:=Sheet.AddChart; Result:=false;
  if ChartDialog.Execute(true,ch) then begin
    with lvCharts.Items.Add do begin
//      Caption:=ch.ChartDesc;
//      SubItems.Add(_('No items'));
      UpdateSheet(Index);
      end;
    ActiveControl:=edDesc;
    SetChangeStatus;
    Result:=true;
    end
  else Sheet.DeleteChart(ch.Index);
  end;

procedure TfrmSheet.bbNewChartClick(Sender : TObject); // new chart
begin
  NewChart;
  end;

procedure TfrmSheet.bbDupChartClick(Sender: TObject);
var
  ch : TChart;
begin
  if SelChart>=0 then begin
    ch:=Sheet.AddChart;
    with ch do begin
      Assign(Sheet.Chart[SelChart],false);
      ChartDesc:='';
      end;
    if ChartDialog.Execute(false,ch) then begin
      with lvCharts.Items.Add do begin
//        Caption:=ch.ChartDesc;
//        SubItems.Add(TryFormat(_('%u items'),[ch.ItemCount]));
        UpdateSheet(Index);
        end;
      SetChangeStatus;
      end
    else Sheet.DeleteChart(ch.Index);
    end;
  end;

procedure TfrmSheet.bbRemoveChartClick(Sender : TObject); // remove chart
begin
  if (lvCharts.ItemIndex>=0) and
      ConfirmDialog(BottomLeftPos(bbRemoveChart),_('Remove selected chart?')) then begin
    with Sheet.Chart[lvCharts.ItemIndex] do begin
      Deleted:=true;
      inc(DelCount);
      end;
    with lvCharts do Items[ItemIndex].ImageIndex:=2;
    UpdateSheet(SelChart);
    frmView.UpdateView;
    SetChangeStatus;
    end;
  end;

procedure TfrmSheet.bbUndoChartClick(Sender: TObject);
begin
  with lvCharts do if ItemIndex>=0 then with Sheet.Chart[ItemIndex] do begin
    Deleted:=false;
    Items[ItemIndex].ImageIndex:=GetImage(Visible,Deleted);
    frmView.UpdateView;
    dec(DelCount);
    end
  end;

procedure TfrmSheet.bbEditChartClick(Sender : TObject); // edit chart
begin
  EditChart;
  end;

procedure TfrmSheet.EditChart;
var
  FChart : TChart;
begin
  with lvCharts do if ItemIndex>=0 then begin
    FChart:=TChart.CreateFrom(Sheet.Chart[ItemIndex]);
    if ChartDialog.Execute(false,FChart) then begin
      FChart.SetInnerArea;
      Sheet.Chart[ItemIndex]:=FChart;
      UpdateSheet(-1);
      frmView.UpdateView;
      SetChangeStatus;
      end
    else FChart.Free;
    end;
  end;

procedure TfrmSheet.sbChartUpClick(Sender : TObject);
begin
  with lvCharts do if (Items.Count>0)and(ItemIndex>0) then begin
    Sheet.ExchangeCharts(ItemIndex,ItemIndex-1);
    UpdateSheet(ItemIndex-1);
    SetChangeStatus;
    end;
  end;

procedure TfrmSheet.sbChartDownClick(Sender : TObject);
begin
  with lvCharts do if (Items.Count>0)and(ItemIndex<Items.Count-1) then begin
    Sheet.ExchangeCharts(ItemIndex,ItemIndex+1);
    UpdateSheet(ItemIndex+1);
    SetChangeStatus;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TfrmSheet.sbItemUpClick(Sender : TObject);
begin
  if SelChart>=0 then with lvItems do if (Items.Count>0)and(ItemIndex>0) then begin
    Sheet.Chart[SelChart].ExchangeItems(ItemIndex,ItemIndex-1);
    ShowItems(ItemIndex-1);
    frmView.UpdateView;
    SetChangeStatus;
    end;
  end;

procedure TfrmSheet.sbItemDownClick(Sender : TObject);
begin
  if SelChart>=0 then with lvItems do if (Items.Count>0)and(ItemIndex<Items.Count-1) then begin
    Sheet.Chart[SelChart].ExchangeItems(ItemIndex,ItemIndex+1);
    ShowItems(ItemIndex+1);
    frmView.UpdateView;
    SetChangeStatus;
    end;
  end;

procedure TfrmSheet.lvItemsClick(Sender: TObject);
begin
  if SelChart<0 then ErrorDialog(CursorPos,_('No chart selected!'))
  else with lvItems do if ItemIndex>=0 then begin
    frmView.ShowOutline(-1,-1);
    frmView.ShowOutline(SelChart,ItemIndex);
    end;
  end;

procedure TfrmSheet.bbEditItemClick(Sender : TObject); // edit chart item
var
  n,ni : integer;
begin
  n:=lvItems.ItemIndex;
  if EditItem(n) then with lvItems.Items[n] do begin
    with Sheet.Chart[SelChart].Item[n] do begin
      Caption:=Description;
      ImageIndex:=GetImage(Visible,Deleted);
      end;
    SetChangeStatus;
    end;
  with frmView do begin
    ShowOutline(-1,-1);
    UpdateView;
    end;
  end;

procedure TfrmSheet.bbDupItemClick(Sender: TObject);
var
  ci : TChartItem;
  n  : integer;
begin
  if SelChart<0 then ErrorDialog(CursorPos,_('No chart selected!'))
  else with lvItems do if ItemIndex>=0 then begin
    frmView.ShowOutline(-1,-1);
    with Sheet,Chart[SelChart] do begin
      if Item[ItemIndex].ItemType=itAxis then DupAxis(Item[ItemIndex] as TAxisItem)
      else begin
        frmView.ShowOutline(SelChart,ItemIndex);
        case Item[ItemIndex].ItemType of
        itCurve     : begin
                      ci:=TCurveItem.CreateFrom(Item[ItemIndex] as TCurveItem);
                      end;
        itFit       : begin
                      ci:=TFitItem.CreateFrom(Item[ItemIndex] as TFitItem);
                      end;
        itGraph     : begin
                      ci:=TGraphItem.CreateFrom(Item[ItemIndex] as TGraphItem);
                      end;
        itFunction  : begin
                      ci:=TFunctionItem.CreateFrom(Item[ItemIndex] as TFunctionItem);
                      end;
        itText      : begin
                      ci:=TTextItem.CreateFrom(Item[ItemIndex] as TTextItem);
                      (ci as TTextItem).MovePos(GetItemOffset);
                      end;
        itImage     : begin
                      ci:=TImageItem.CreateFrom(Item[ItemIndex] as TImageItem);
                      (ci as TImageItem).MovePos(GetItemOffset)
                      end;
        itDrawing   : begin
                      ci:=TDrawingItem.CreateFrom(Item[ItemIndex] as TDrawingItem);
                      (ci as TDrawingItem).MovePos(GetItemOffset);
                      end;
          end;
        n:=AddItem(ci);
        if EditItem(n) then begin
          ShowItems(n);
          SetChangeStatus;
          end
        else DeleteItem(n);
        frmView.UpdateView;
        end;
      end;
    end;
  end;

procedure TfrmSheet.bbRemoveItemClick(Sender : TObject); // remove item from chart
var
  s : string;
begin
  if SelChart<0 then ErrorDialog(CursorPos,_('No chart selected!'))
  else with lvItems do if ItemIndex>=0 then begin
    with Sheet.Chart[SelChart].Item[ItemIndex] do s:=Description+' '+TypeName;
    if ConfirmDialog(BottomLeftPos(bbRemoveItem),TryFormat(_('Remove %s?'),[s])) then begin
      with Sheet.Chart[SelChart] do begin
//        DeleteItem(ItemIndex);
        Item[ItemIndex].Deleted:=true;
        SetInnerArea;
        end;
      Items[ItemIndex].ImageIndex:=2;
//      if ItemIndex>0 then ShowItems(ItemIndex-1) else ShowItems(0);
      SetChangeStatus;
      frmView.UpdateView;
      inc(DelCount);
      end;
    end;
  end;

procedure TfrmSheet.bbUndoItemClick(Sender: TObject);
begin
  if SelChart<0 then ErrorDialog(CursorPos,_('No chart selected!'))
  else with lvItems do if ItemIndex>=0 then begin
    with Sheet.Chart[SelChart] do with Item[ItemIndex] do begin
      Deleted:=false;
      Items[ItemIndex].ImageIndex:=GetImage(Visible,Deleted);
      SetInnerArea;
      frmView.UpdateView;
      dec(DelCount);
      end
    end;
  end;

procedure TfrmSheet.bbAddDrawingClick(Sender : TObject);
begin
  with BottomLeftPos(bbAddDrawing) do pmDrawing.Popup(x,y);
  end;

procedure TfrmSheet.bbAddGraphClick(Sender: TObject);
begin
  with BottomLeftPos(bbAddGraph) do pmNewGraph.Popup(x,y);
  end;

procedure TfrmSheet.bbAddTextClick(Sender : TObject);
begin
  with BottomLeftPos(bbAddText) do pmNewText.Popup(x,y);
  end;

function TfrmSheet.EditAxis (ai : TAxisItem) : boolean;
begin
  with Sheet.Chart[SelChart] do begin
    Result:=false;
    with ai do if GetAxisCount(AxType,apAll)>1 then Exclude(Properties.AxStyles,asBorder);
    Sheet.AdjustChartAreas;
    frmView.UpdateView;
    if AxisDialog.Execute(ai) then begin
      UpdateSheet(SelChart,ItemCount-1);
//      ShowItems(ItemCount-1);
      SetChangeStatus;
      Result:=true;
      end
    else DeleteItem(ai.Index);
    SetInnerArea;
    end;
  frmView.UpdateView;
  end;

procedure TfrmSheet.piXAxisClick(Sender : TObject);
var
  ai  : TAxisItem;
  ofs : TOffset;
  ok  : boolean;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    ofs:=GetAxisOffset(atHorz);
    ai:=AddAxis(atHorz);
    with ai do begin
      Description:=_('X axis');
      if AxPos=apBottomLeft then AxOffset:=ofs.BottomLeft else AxOffset:=ofs.TopRight;
      end;
    EditAxis(ai);
    end;
  end;

procedure TfrmSheet.piYAxisClick(Sender: TObject);
var
  ai  : TAxisItem;
  ofs : TOffset;
  ok  : boolean;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    ofs:=GetAxisOffset(atVert);
    ai:=AddAxis(atVert);
    with ai do begin
      Description:=_('Y axis');
      if AxPos=apBottomLeft then AxOffset:=ofs.BottomLeft else AxOffset:=ofs.TopRight;
      end;
    EditAxis(ai);
    end;
  end;

procedure TfrmSheet.DupAxis (ao : TAxisItem);
var
  ai  : TAxisItem;
  ofs  : TOffset;
begin
  with Sheet.Chart[SelChart] do begin
    ofs:=GetAxisOffset(ao.AxType);
    ai:=AddAxis(ao.AxType);
    end;
  with ai do begin
    Assign(ao);
    Description:='';
    if AxPos=apBottomLeft then AxOffset:=ofs.BottomLeft else AxOffset:=ofs.TopRight;
    end;
  EditAxis(ai);
  end;

procedure TfrmSheet.piCopyAxisClick(Sender: TObject);
var
  n,ni : integer;
begin
  if SelChart<0 then ErrorDialog(CursorPos,_('No chart selected!'))
  else if SelectAxis (CursorPos,Sheet,n,ni) then begin
    with Sheet.Chart[n] do DupAxis(Item[IndexOf(ni)] as TAxisItem);
    end;
  end;

procedure TfrmSheet.bbAddAxisClick(Sender: TObject);
begin
  with BottomLeftPos(bbAddAxis) do pmAxis.Popup(x,y);
  end;

procedure TfrmSheet.bbAddCurveClick(Sender : TObject);
var
  ci : TCurveItem;
  ok : boolean;
  ix,iy : integer;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    if GetAxisCount(atHorz,apAll)=0 then begin
      with AddAxis(atHorz) do begin
        Description:=_('X axis');
        ix:=ItemID;
        end;
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else ix:=GetFirstAxisID(atHorz);
    if GetAxisCount(atVert,apAll)=0 then begin
      with AddAxis(atVert) do begin
        Description:=_('Y axis');
        iy:=ItemID;
        end;
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else iy:=GetFirstAxisID(atVert);
    if Changed then SetInnerArea;
    frmView.UpdateView;
    ci:=AddCurve;
    with ci do begin
      XAxID:=ix; YAxID:=iy;
      end;
    if CurveDialog.Execute(ci) then begin
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else DeleteItem(ci.Index);
    end;
  frmView.UpdateView;
  end;

procedure TfrmSheet.bbAddFitClick(Sender: TObject);
var
  fi : TFitItem;
begin
  if SelChart<0 then ErrorDialog(CursorPos,_('No chart selected!'))
  else with Sheet.Chart[SelChart] do begin
    if GetItemTypeCount(itCurve)>0 then begin
      fi:=AddFit;
      fi.CurveID:=GetFirstItemID(itCurve);
      if FitDialog.Execute(fi) then begin
        UpdateSheet(SelChart,ItemCount-1);
        SetChangeStatus;
        end
      else DeleteItem(fi.Index);
      end
    else ErrorDialog(CursorPos,_('No curve defined yet!'))
    end;
  frmView.UpdateView;
  end;

// Balken- oder Tortendiagramm einfügen
procedure TfrmSheet.AddGraphObject(gt :  TGraphType);
var
  gi  : TGraphItem;
  ok  : boolean;
  ix,iy : integer;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    if GetAxisCount(atHorz,apAll)=0 then begin
      with AddAxis(atHorz) do begin
        Description:=_('X axis');
        ix:=ItemID;
        end;
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else ix:=GetFirstAxisID(atHorz);
    if GetAxisCount(atVert,apAll)=0 then begin
      with AddAxis(atVert) do begin
        Description:=_('Y axis');
        iy:=ItemID;
        end;
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else iy:=GetFirstAxisID(atVert);
    if Changed then SetInnerArea;
    frmView.UpdateView;
    gi:=AddGraph(gt);
    with gi do begin
      XAxID:=ix; YAxID:=iy;
      end;
    if GraphDialog.Execute(gi) then begin
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else DeleteItem(gi.Index);
    end;
  frmView.UpdateView;
  end;

procedure TfrmSheet.piAddBarchartClick(Sender: TObject);
begin
  AddGraphObject(gtBar);
  end;

procedure TfrmSheet.piAddHistogramClick(Sender: TObject);
begin
  AddGraphObject(gtHisto);
  end;

procedure TfrmSheet.piAddPieChartClick(Sender: TObject);
begin
  AddGraphObject(gtPie);
  end;

procedure TfrmSheet.bbAddFunctionClick(Sender : TObject);
var
  fi : TFunctionItem;
  ai  : TAxisItem;
  ok : boolean;
  ix,iy : integer;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    if GetAxisCount(atHorz,apAll)=0 then begin
      ai:=AddAxis(atHorz);
      with ai do begin
        Description:=_('X axis');
        ix:=ItemID;
        end;
      if not EditAxis(ai) then Exit;
      end
    else ix:=GetFirstAxisID(atHorz);
    if GetAxisCount(atVert,apAll)=0 then begin
      with AddAxis(atVert) do begin
        Description:=_('Y axis');
        iy:=ItemID;
        end;
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else iy:=GetFirstAxisID(atVert);
    if Changed then SetInnerArea;
    frmView.UpdateView;
    fi:=AddFunction;
    with fi do begin
      XAxID:=ix; YAxID:=iy;
      end;
    if FunctionDialog.Execute(fi) then begin
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else DeleteItem(fi.Index);
    end;
  frmView.UpdateView;
  end;

procedure TfrmSheet.bbAddImageClick(Sender : TObject);
var
  ii : TImageItem;
  ok  : boolean;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    ii:=AddImage;
    if ImageDialog.Execute(ImagePath,ii) then begin
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else DeleteItem(ii.Index);
    end;
  frmView.UpdateView;
  end;

// Textobjekt hinzufügen
procedure TfrmSheet.AddTextObject(tt :  TTextType);
var
  ti  : TTextItem;
  ok  : boolean;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    ti:=AddText(tt);
    if TextDialog.Execute(ti) then begin
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else DeleteItem(ti.Index);
    end;
  frmView.UpdateView;
  end;

procedure TfrmSheet.piAddResultClick(Sender : TObject);
begin
  AddTextObject(ttFitResult);
  end;

procedure TfrmSheet.piAddTextClick(Sender : TObject);
begin
  AddTextObject(ttText);
  end;

procedure TfrmSheet.piAddCommentClick(Sender: TObject);
begin
  AddTextObject(ttComment);
  end;

procedure TfrmSheet.piAddLegendClick(Sender : TObject);
begin
  AddTextObject(ttLegend);
  end;

procedure TfrmSheet.AddDrawingObject(dt :  TDrawingType);
var
  di  : TDrawingItem;
  ok  : boolean;
begin
  if SelChart<0 then ok:=NewChart  // Create new chart if not exists
  else ok:=true;
  if ok then with Sheet.Chart[SelChart] do begin
    di:=AddDrawing(dt);
    if DrawingDialog.Execute(di) then begin
      UpdateSheet(SelChart,ItemCount-1);
      SetChangeStatus;
      end
    else DeleteItem(di.Index);
    end;
  frmView.UpdateView;
  end;

procedure TfrmSheet.piLineClick(Sender: TObject);
begin
  AddDrawingObject(dtLine);
  end;

procedure TfrmSheet.piRectangleClick(Sender: TObject);
begin
  AddDrawingObject(dtRect);
  end;

end.

