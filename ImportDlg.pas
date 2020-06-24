(* RPlot dialog
   Import data (e.g. csv format)

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

unit ImportDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Indicators,
  RPlotObjects, NumberEd;

const
  lmax = 9;

type
  TCsvFormatSettings = record
    QuoteChar,
    ColSeparator,
    DecSeparator  : char;
    Path,Ext       : string;
    ColWidth       : integer;
    end;

  TImportCols = record
    icV,icP,icM : integer;
    end;

  TImportSettings = record
    FirstLine,
    Reduce      : integer;
    XCols,YCols : TImportCols;
    end;

  TImportDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    rgDecimal: TRadioGroup;
    gbColumns: TGroupBox;
    Label1: TLabel;
    laXM: TLabel;
    Label3: TLabel;
    mePreview: TMemo;
    edX: TEdit;
    edXM: TEdit;
    gbLine: TGroupBox;
    Label4: TLabel;
    paPreview: TPanel;
    laXP: TLabel;
    edXP: TEdit;
    Label6: TLabel;
    edY: TEdit;
    gbQuote: TGroupBox;
    rbNoQuote: TRadioButton;
    rbQuote: TRadioButton;
    rbOtherQuote: TRadioButton;
    edQuote: TEdit;
    gbDelim: TGroupBox;
    rbSpace: TRadioButton;
    rbTab: TRadioButton;
    rbSemi: TRadioButton;
    rbComma: TRadioButton;
    rbOtherDel: TRadioButton;
    edDelim: TEdit;
    rbSlash: TRadioButton;
    siX: TSpotIndicator;
    siXP: TSpotIndicator;
    siXM: TSpotIndicator;
    siY: TSpotIndicator;
    edFilename: TEdit;
    laYM: TLabel;
    laYP: TLabel;
    edYP: TEdit;
    edYM: TEdit;
    siYP: TSpotIndicator;
    siYM: TSpotIndicator;
    laLines: TLabel;
    Label2: TLabel;
    reXCol: TRangeEdit;
    udXCol: TNumUpDown;
    reXPCol: TRangeEdit;
    udXPCol: TNumUpDown;
    reXMCol: TRangeEdit;
    udXMCol: TNumUpDown;
    reYCol: TRangeEdit;
    udYCol: TNumUpDown;
    reYPCol: TRangeEdit;
    udYPCol: TNumUpDown;
    reYMCol: TRangeEdit;
    udYMCol: TNumUpDown;
    reLine: TRangeEdit;
    udLine: TNumUpDown;
    reReduce: TRangeEdit;
    udReduce: TNumUpDown;
    procedure SettingsChange(Sender: TObject);
    procedure rbNoQuoteClick(Sender: TObject);
    procedure rbQuoteClick(Sender: TObject);
    procedure rbOtherQuoteClick(Sender: TObject);
    procedure rbTabClick(Sender: TObject);
    procedure rbSpaceClick(Sender: TObject);
    procedure rbSemiClick(Sender: TObject);
    procedure rbCommaClick(Sender: TObject);
    procedure rbSlashClick(Sender: TObject);
    procedure rbOtherDelClick(Sender: TObject);
    procedure rgDecimalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ColVal : integer;
    FTimeSeries : boolean;
    FFormat : TCsvFormatSettings;
    procedure UpdatePreview;
    procedure EnableControls(AEnable : Boolean; AIndex : integer);
  public
    { Public declarations }
    function Execute (const AFilename : string;
                      TimeSeries  : boolean;
                      var AFormat : TCsvFormatSettings;
                      ADataCols   : TDataCols;
                      var ImpSet  : TImportSettings) : boolean;
  end;

var
  ImportDialog: TImportDialog;

function TryStringToDateTime (s : string; var dt : TDateTime) : boolean;

implementation

{$R *.DFM}

uses System.DateUtils, StringUtils, FileUtils, GnuGetText;

function TryStringToDateTime (s : string; var dt : TDateTime) : boolean;
var
  j1,j2,j3 : integer;
  err : boolean;
begin
  err:=false;
  s:=Trim(s);
  if length(s)>0 then begin
    if Pos('-',s)>0 then begin // mit Datum
      j1:=ReadNxtInt(s,'-',YearOf(Now),err);
      j2:=ReadNxtInt(s,'-',MonthOf(Now),err);
      j3:=ReadNxtInt(s,' ',DayOf(Now),err);
      try dt:=EncodeDate(j1,j2,j3); except err:=true; end;
      end
    else begin
      j1:=Pos(':',s); j2:=Pos('.',s);
      if ((j1=0) and (j2>0)) or ((j2>0) and (j2<j1)) then begin
        j3:=ReadNxtInt(s,'.',DayOf(Now),err);
        j2:=ReadNxtInt(s,'.',MonthOf(Now),err);
        j1:=ReadNxtInt(s,' ',YearOf(Now),err);
        try dt:=EncodeDate(j1,j2,j3); except err:=true; end;
        end
      else dt:=Date;
      end;
    if not err and (length(s)>0) then begin  // Zeit
      j1:=ReadNxtInt(s,':',HourOf(Now),err);
      j2:=ReadNxtInt(s,':',MinuteOf(Now),err);
      j3:=ReadNxtInt(s,'.',SecondOf(Now),err);
      dt:=dt+j1*OneHour+j2*OneMinute+j3*OneSecond;
      end;
    end
  else dt:=Date;
  Result:=not err;
  end;

procedure TImportDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  end;

procedure TImportDialog.UpdatePreview;
var
  n,j : integer;
  s,t : string;

  function CHeckDateTime (s : String) : boolean;
  var
    dt : TDateTime;
  begin
    Result:=TryStringToDateTime(s,dt);
    end;

  function CheckFloat (s : String) : boolean;
  var
    i,ic : integer;
    x    : double;
  begin
    s:=RemSp(ReplChars(s,FFormat.DecSeparator,Period));
    if length(s)=0 then Result:=false
    else begin
      i:=1;
      while (i<=length(s)) and CharInSet(s[i],FloatChars) do inc(i);
      if (i<length(s)) and CharInSet(s[i+1],FloatChars) then Result:=false
      else begin
        val(copy(s,1,pred(i)),x,ic);
        Result:=ic=0;
        end;
      end;
    end;

begin
  n:=reLine.Value;
  with mePreView.Lines do if n>Count then n:=Count;
  s:=mePreview.Lines[n-1];
  edX.Text:=''; edY.Text:='';
  edXP.Text:=''; edYP.Text:='';
  edXM.Text:=''; edYM.Text:='';
  j:=0;
  repeat
    with FFormat do if QuoteChar=#0 then t:=ReadNxtStr(s,ColSeparator)
    else t:=ReadNxtQuotedStr(s,ColSeparator,QuoteChar);
    inc(j);
    if length(t)>0 then begin
      if j=reXCol.Value then edX.Text:=t;
      if j=reXPCol.Value then edXP.Text:=t;
      if j=reXMCol.Value then edXM.Text:=t;
      if j=reYCol.Value then edY.Text:=t;
      if j=reYPCol.Value then edYP.Text:=t;
      if j=reYMCol.Value then edYM.Text:=t;
      end;
    until length(s)=0;
  if FTimeSeries then siX.Indicate:=not CheckDateTime(edX.Text)
  else siX.Indicate:=not CheckFloat(edX.Text);
  siY.Indicate:=not CheckFloat(edY.Text);
  with rgDecimal do if (pos(Period,edX.Text)>0) or (pos(Period,edY.Text)>0) then begin
    ItemIndex:=0; Enabled:=false;
    end
  else Enabled:=true;
  with siXP do if Enabled then Indicate:=not CheckFloat(edXP.Text);
  with siXM do if Enabled then Indicate:=not CheckFloat(edXM.Text);
  with siYP do if Enabled then Indicate:=not CheckFloat(edYP.Text);
  with siYM do if Enabled then Indicate:=not CheckFloat(edYM.Text);
  end;

procedure TImportDialog.rbTabClick(Sender: TObject);
begin
  FFormat.ColSeparator:=Tab;
  edDelim.Hide;
  UpdatePreview;
  end;

procedure TImportDialog.rbSpaceClick(Sender: TObject);
begin
  FFormat.ColSeparator:=Space;
  edDelim.Hide;
  UpdatePreview;
  end;

procedure TImportDialog.rbSemiClick(Sender: TObject);
begin
  FFormat.ColSeparator:=';';
  edDelim.Hide;
  UpdatePreview;
  end;

procedure TImportDialog.rbCommaClick(Sender: TObject);
begin
  FFormat.ColSeparator:=',';
  edDelim.Hide;
  UpdatePreview;
  end;

procedure TImportDialog.rbSlashClick(Sender: TObject);
begin
  FFormat.ColSeparator:='/';
  edDelim.Hide;
  UpdatePreview;
  end;

procedure TImportDialog.rbOtherDelClick(Sender: TObject);
begin
  with edDelim,FFormat do begin
    if length(Text)>0 then ColSeparator:=Text[1] else ColSeparator:=',';
    Text:=ColSeparator;
    Show;
    if Active then SetFocus;
    end;
  UpdatePreview;
  end;

procedure TImportDialog.rbNoQuoteClick(Sender: TObject);
begin
  FFormat.QuoteChar:=#0;
  edQuote.Hide;
  UpdatePreview;
  end;

procedure TImportDialog.rbQuoteClick(Sender: TObject);
begin
  FFormat.QuoteChar:='"';
  edQuote.Hide;
  UpdatePreview;
  end;

procedure TImportDialog.rbOtherQuoteClick(Sender: TObject);
begin
  with edQuote,FFormat do begin
    if length(Text)>0 then QuoteChar:=Text[1] else QuoteChar:='''';
    Text:=QuoteChar;
    Show;
    end;
  UpdatePreview;
  end;

procedure TImportDialog.rgDecimalClick(Sender: TObject);
begin
  with FFormat do if rgDecimal.ItemIndex=0 then DecSeparator:=Period
  else DecSeparator:=',';
  UpdatePreview;
  end;

procedure TImportDialog.SettingsChange(Sender: TObject);
begin
  UpdatePreview;
  end;

procedure TImportDialog.EnableControls(AEnable : Boolean; AIndex : integer);
var
  i : integer;
begin
  with gbColumns do for i:=0 to ControlCount-1 do with Controls[i] do if Tag=AIndex then begin
    Enabled:=AEnable;
    if (Controls[i] is TRangeEdit) then with (Controls[i] as TRangeEdit) do
      if AEnable then Value:=ColVal else Value:=0;
    end;
  if AEnable then inc(ColVal);
  end;

function TImportDialog.Execute (const AFilename : string;
                                TimeSeries  : boolean;
                                var AFormat : TCsvFormatSettings;
                                ADataCols   : TDataCols;
                                var ImpSet  : TImportSettings) : boolean;
var
  fi      : TFileStream;
  s       : string;
  fm      : integer;
begin
  Result:=false;
  edFilename.Text:=StripPath(AFilename,85);
  edDelim.Text:=''; edQuote.Text:='';
  fm:=FileMode; FTimeSeries:=TimeSeries;
  fi:=TFileStream.Create(AFilename,fmOpenRead or fmShareDenyRead);
  with mePreview do begin
    Clear;
    Lines.LoadFromStream(fi);
    laLines.Caption:=IntToStr(Lines.Count)+' '+_('lines of data');
    end;
  fi.Free;
  FileMode:=fm;
  FFormat:=AFormat;
  edDelim.Hide;
  case FFormat.ColSeparator of
  Space     : rbSpace.Checked:=true;
  Tab       : rbTab.Checked:=true;
  ';'       : rbSemi.Checked:=true;
  ','       : rbComma.Checked:=true;
  '/'       : rbSlash.Checked:=true;
  else with edDelim do begin
      Text:=FFormat.ColSeparator;
      rbOtherDel.Checked:=true;
//      Show;
      end;
    end;
  with rgDecimal do case FFormat.DecSeparator of
    Period : ItemIndex:=0;
    ','    : ItemIndex:=1;
    end;
  edQuote.Hide;
  case FFormat.QuoteChar of
  '"' : rbQuote.Checked:=true;
  #0  : rbNoQuote.Checked:=true;
  else with edQuote do begin
      rbOtherQuote.Checked:=true;
      Text:=FFormat.QuoteChar; Show;
      end;
    end;
  ColVal:=1;
  EnableControls(dcValX in ADataCols,1);
  EnableControls((dcErrSX in ADataCols) or (dcErrAX in ADataCols),2);
  EnableControls(dcErrAX in ADataCols,3);
  EnableControls(dcValY in ADataCols,4);
  EnableControls((dcErrSY in ADataCols) or (dcErrAY in ADataCols),5);
  EnableControls(dcErrAY in ADataCols,6);
  reReduce.Value:=1;
  UpdatePreview;
  if ShowModal=mrOK then begin
    AFormat:=FFormat;
    with ImpSet do begin
      with XCols do begin
        with reXCol do if Enabled then icV:=Value else icV:=0;
        with reXPCol do if Enabled then icP:=Value else icP:=0;
        with reXMCol do if Enabled then icM:=Value else icM:=0;
        end;
      with YCols do begin
        with reYCol do if Enabled then icV:=Value else icV:=0;
        with reYPCol do if Enabled then icP:=Value else icP:=0;
        with reYMCol do if Enabled then icM:=Value else icM:=0;
        end;
      FirstLine:=reLine.Value;
      Reduce:=reReduce.Value;
      end;
    Result:=true;
    end;
  end;

end.
