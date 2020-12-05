program RPlot;

uses
  GnuGetText in 'units\GnuGetText.pas',
  LangUtils in 'units\LangUtils.pas',
  Vcl.Forms,
  Vcl.Graphics,
  RPlotMain in 'RPlotMain.pas' {frmSheet},
  RPlotView in 'RPlotView.pas' {frmView},
  ChartDlg in 'ChartDlg.pas' {ChartDialog},
  AxisDlg in 'AxisDlg.pas' {AxisDialog},
  FunctionDlg in 'FunctionDlg.pas' {FunctionDialog},
  CurveDlg in 'CurveDlg.pas' {CurveDialog},
  ImportDlg in 'ImportDlg.pas' {ImportDialog},
  DataDlg in 'DataDlg.pas' {DataDialog},
  TextDlg in 'TextDlg.pas' {TextDialog},
  ImageDlg in 'ImageDlg.pas' {ImageDialog},
  DrawingDlg in 'DrawingDlg.pas' {DrawingDialog},
  RPlotObjects in 'RPlotObjects.pas',
  PsPlot in 'PsPlot.pas',
  FindReplDlg in 'units\FindReplDlg.pas' {FindReplDialog},
  PrefsDlg in 'PrefsDlg.pas' {PreferencesDialog},
  RadioDials in 'units\RadioDials.pas',
  PlotFontDlg in 'PlotFontDlg.pas' {PlotFontDialog},
  GraphDlg in 'GraphDlg.pas' {GraphDialog},
  SetCustomColorDlg in 'SetCustomColorDlg.pas' {SetCustomColorDialog},
  SelectAxisDlg in 'SelectAxisDlg.pas' {SelectAxisDialog},
  TextFormatDlg in 'TextFormatDlg.pas' {TextFormatDialog},
  FitDlg in 'FitDlg.pas' {FitDialog},
  RPlotUtils in 'RPlotUtils.pas',
  DateFormatDlg in 'units\DateFormatDlg.pas' {DateFormatDialog};

{$R *.res}

begin
//  DefaultInstance.DebugLogToFile('rp.log');
  TP_GlobalIgnoreClass(TFont);
  // Subdirectory in AppData for user configuration files and supported languages
  InitTranslation('','',['delphi10','units']);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSheet, frmSheet);
  Application.CreateForm(TfrmView, frmView);
  Application.CreateForm(TChartDialog, ChartDialog);
  Application.CreateForm(TAxisDialog, AxisDialog);
  Application.CreateForm(TFunctionDialog, FunctionDialog);
  Application.CreateForm(TCurveDialog, CurveDialog);
  Application.CreateForm(TImportDialog, ImportDialog);
  Application.CreateForm(TDataDialog, DataDialog);
  Application.CreateForm(TTextDialog, TextDialog);
  Application.CreateForm(TImageDialog, ImageDialog);
  Application.CreateForm(TDrawingDialog, DrawingDialog);
  Application.CreateForm(TFindReplDialog, FindReplDialog);
  Application.CreateForm(TGraphDialog, GraphDialog);
  Application.CreateForm(TSelectAxisDialog, SelectAxisDialog);
  Application.CreateForm(TFitDialog, FitDialog);
  Application.CreateForm(TDateFormatDialog, DateFormatDialog);
  Application.Run;
end.
