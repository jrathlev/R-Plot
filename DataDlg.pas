(* RPlot dialog
   Edit data

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

unit DataDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, SynEdit, Vcl.ComCtrls,
  SynEditMiscClasses, SynEditSearch, Vcl.Dialogs, RPlotObjects, RPlotUtils, ImportDlg;

const
  DataForm = ffGeneral;
  DataPrec = 6;
  DataDig  = 0;

type
  TDataDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    bbImport: TBitBtn;
    OpenDialog: TOpenDialog;
    paTop: TPanel;
    SynEditSearch: TSynEditSearch;
    paBottom: TPanel;
    sbCol: TSpeedButton;
    sbNext: TSpeedButton;
    sbReplace: TSpeedButton;
    sbFind: TSpeedButton;
    sbPaste: TSpeedButton;
    gbXErr: TGroupBox;
    rbXNoErr: TRadioButton;
    rbXSymErr: TRadioButton;
    rbXAsymErr: TRadioButton;
    gbYErr: TGroupBox;
    rbYNoErr: TRadioButton;
    rbYSymerr: TRadioButton;
    rbYAsymerr: TRadioButton;
    paData: TPanel;
    seHeader: TSynEdit;
    seData: TSynEdit;
    paTab: TPanel;
    Label1: TLabel;
    edTab: TEdit;
    udTab: TUpDown;
    sbSort: TSpeedButton;
    cxRange: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure edTabChange(Sender: TObject);
    procedure rgErrClick(Sender: TObject);
    procedure bbImportClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbPasteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbColClick(Sender: TObject);
    procedure FindNextText(Sender: TObject);
    procedure ReplaceNextText(Sender: TObject);
    procedure sbFindClick(Sender: TObject);
    procedure sbReplaceClick(Sender: TObject);
    procedure FindNext(Sender: TObject);
    procedure sbSortClick(Sender: TObject);
    procedure seDataKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    FIniName,
    FTitle    : string;
    FData     : TDataArray;
    FDataCols : TDataCols;
    FoImp     : TCsvFormatSettings;
    xcol,ycol : boolean;
    function CompareVals (const arg1,arg2) : boolean;
    procedure ShowData;
    procedure SaveData;
  public
    { Public-Deklarationen }
    procedure LoadFromIni (AIniName : string);
    function Execute (const ATitle : string; ShowErrors : boolean;
                      var AutoAlign : boolean;
                      var ADataTable : TDataTable) : boolean;
  end;

var
  DataDialog: TDataDialog;

implementation

{$R *.dfm}

uses GnuGetText, StringUtils, WinUtils, RPlotMain, ExtSysUtils, ExtStreams,
  System.Math, System.IniFiles, FileUtils, FindReplDlg, SynEditTypes;

const
  DefColSep = ';';
  DefQuote = '"';

procedure TDataDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  FIniName:='';
  end;

procedure TDataDialog.FormDestroy(Sender: TObject);
begin
  if length(FiniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (ImpSekt,IniLeft,Left);
    WriteInteger (ImpSekt,IniTop,Top);
    with FoImp do begin
      WriteString(ImpSekt,IniDir,Path);
      WriteString(ImpSekt,IniExt,Ext);
      WriteInteger(ImpSekt,IniColSep,ord(ColSeparator));
      WriteInteger(ImpSekt,IniQuote,ord(QuoteChar));
      WriteInteger(ImpSekt,IniDecSep,ord(DecSeparator));
      end;
    end;
  end;

procedure TDataDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((ssCtrl in Shift) and (Key=ord('V'))) or ((ssShift in Shift) and (Key=VK_INSERT)) then begin
    sbPasteClick(Sender);
    Key:=0;
    end
  else if Key=VK_F4 then begin
    with sbCol do Down:=not Down;
    sbColClick(Sender);
    end
  else if Key=VK_F3 then FindNext(Sender)
  else if (ssCtrl in Shift) and (Key=ord('F')) then sbFindClick(Sender)
  else if (ssCtrl in Shift ) and (Key=ord('R')) then sbReplaceClick(Sender)
  else if (ssCtrl in Shift ) and (Key=ord('S')) then sbSortClick(Sender)
  else if Key=VK_ESCAPE then ModalResult:=mrCancel;
  end;

procedure TDataDialog.LoadFromIni (AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
    Left:=ReadInteger (ImpSekt,IniLeft,Left);
    Top:=ReadInteger (ImpSekt,IniTop,Top);
    with FoImp do begin
      Path:=ReadString(ImpSekt,IniDir,frmSheet.UserPath);
      Ext:=ReadString(ImpSekt,IniExtn,CsvExt);
      ColSeparator:=chr(ReadInteger(ImpSekt,IniColSep,ord(DefColSep)));
      QuoteChar:=chr(ReadInteger(ImpSekt,IniQuote,ord(DefQuote)));
      DecSeparator:=chr(ReadInteger(ImpSekt,IniDecSep,ord(FormatSettings.DecimalSeparator)));
      ColWidth:=0;
      end;
    end;
  FindReplDialog.LoadFromIni(AIniName);
  end;

procedure TDataDialog.ShowData;
var
  i   : integer;
  s,t : string;
begin
  with seHeader do begin
    Clear;
    FDataCols:=[];
    TabWidth:=udTab.Position;
    if xcol then begin
      s:=_('X-Values'); include(FDataCols,dcValX);
      if rbXSymErr.Checked then begin
        s:=s+Tab+_('X-Errors'); include(FDataCols,dcErrSX);
        end
      else if rbXAsymErr.Checked then begin
        s:=s+Tab+'+'+_('X-Errors')+Tab+'-'+_('X-Errors'); include(FDataCols,dcErrAX);
        end
      end
    else s:='';
    if ycol then begin
      if length(s)=0 then begin
        s:=_('Values'); t:=_('Errors');
        end
      else begin
        s:=s+Tab+_('Y-Values'); t:=_('Y-Errors');
        end;
      include(FDataCols,dcValY);
      if rbYSymErr.Checked then begin
        s:=s+Tab+t; include(FDataCols,dcErrSY);
        end
      else if rbYAsymErr.Checked then begin
        s:=s+Tab+'+'+t+Tab+'-'+t; include(FDataCols,dcErrAY);
        end;
      end;
    Lines.Add(s);
    end;
  with seData do begin
    Clear;
    TabWidth:=udTab.Position;
    end;
  for i:=0 to length(FData)-1 do with FData[i] do begin
    if xcol then begin
      s:=FloatToStrF(Val.X,DataForm,DataPrec,DataDig);
      if rbXSymErr.Checked then s:=s+Tab+FloatToStrF(PErr.X,DataForm,DataPrec,DataDig)
      else if rbXAsymErr.Checked then s:=s+Tab+FloatToStrF(PErr.X,DataForm,DataPrec,DataDig)
        +Tab+FloatToStrF(MErr.X,DataForm,DataPrec,DataDig);
      end
    else s:='';
    if ycol then begin
      if length(s)=0 then s:=FloatToStrF(Val.Y,DataForm,DataPrec,DataDig)
      else s:=s+Tab+FloatToStrF(Val.Y,DataForm,DataPrec,DataDig);
      if rbYSymErr.Checked then s:=s+Tab+FloatToStrF(PErr.Y,DataForm,DataPrec,DataDig)
      else if rbYAsymErr.Checked then s:=s+Tab+FloatToStrF(PErr.Y,DataForm,DataPrec,DataDig)
        +Tab+FloatToStrF(MErr.Y,DataForm,DataPrec,DataDig);
      end;
    seData.Lines.Add(s);
    end;
  end;

procedure TDataDialog.SaveData;
var
  i,n : integer;
  s   : string;
begin
  with seData do begin
    SetLength(FData,Lines.Count);
    n:=0;
    for i:=0 to Lines.Count-1 do with FData[n] do begin
      s:=DelSp(Lines[i]);
      if length(s)>0 then begin
        if xcol then begin
          Val.X:=ReadNxtDbl(s,Tab,0);
          if dcErrSX in FDataCols then PErr.X:=ReadNxtDbl(s,Tab,0)
          else if dcErrAX in FDataCols then begin
            PErr.X:=ReadNxtDbl(s,Tab,0); MErr.X:=ReadNxtDbl(s,Tab,0);
            end;
          end;
        if ycol then begin
          Val.Y:=ReadNxtDbl(s,Tab,0);
          if dcErrSY in FDataCols  then PErr.Y:=ReadNxtDbl(s,Tab,0)
          else if dcErrAY in FDataCols  then begin
            PErr.Y:=ReadNxtDbl(s,Tab,0); MErr.Y:=ReadNxtDbl(s,Tab,0);
            end;
          end;
        inc(n);
        end;
      end;
    SetLength(FData,n);
    end;
  end;

(* OnFind-Routine für Suchen- und Ersetzendialog *)
procedure TDataDialog.FindNextText(Sender: TObject);
begin
  with  FindReplDialog do begin
    if Length(FindText)=0 then Beep
    else begin
      if seData.SearchReplace(FindText,'',Options)=0 then begin
        Beep;
        InfoDialog(CursorPos,TryFormat(_('"%s" not found!'),[FindText]));
        end;
      end
    end;
  end;

(* OnReplace-Routine für Ersetzendialog *)
procedure TDataDialog.ReplaceNextText(Sender: TObject);
begin
  with FindReplDialog do begin
    if Length(FindText)=0 then Beep
    else begin
      if seData.SearchReplace(FindText,ReplaceText,Options)=0 then begin
        Beep;
        InfoDialog(CursorPos,TryFormat(_('"%s" not found!'),[FindText]));
        end;
      end;
    end;
  end;

procedure TDataDialog.sbColClick(Sender: TObject);
begin
  with seData do if sbCol.Down then SelectionMode:=smColumn else SelectionMode:=smNormal;
  end;

procedure TDataDialog.sbFindClick(Sender: TObject);
begin
  with FindReplDialog do begin
    FindText:='';
    OnFind:=FindNextText;
    Execute(false);
    end;
  end;

procedure TDataDialog.sbReplaceClick(Sender: TObject);
begin
  with FindReplDialog do begin
    FindText:='';
    OnFind:=FindNextText;
    OnReplace:=ReplaceNextText;
    Execute (true);
    end;
  end;

procedure TDataDialog.FindNext(Sender: TObject);
begin
  if ssoReplace in FindReplDialog.Options then ReplaceNextText(Sender)
  else FindNextText(self);
  end;

procedure TDataDialog.sbPasteClick(Sender: TObject);
var
  i   : integer;
  s,t : string;

  function ReadNxtNumber (var s : String) : string;
  var
    i,j : integer;
  begin
    if length(s)=0 then Result:=''
    else begin
      i:=1;
      while (i<=length(s)) and not (s[i] in FloatChars) do inc(i);
      j:=i;
      while (j<=length(s)) and (s[j] in FloatChars) do inc(j);
      Result:=copy(s,i,j-i);
      delete(s,1,j-1);
      s:=Trim(s);
      end;
    end;

begin
  with seData do begin
    BeginUpdate;
    PasteFromClipboard;
    for i:=0 to Lines.Count-1 do begin
      s:=Trim(Lines[i]);      // remove no number characters and insert Tab between
      t:='';
      repeat
        if length(t)>0 then t:=t+Tab;
        t:=t+ReadNxtNumber(s);
        until length(s)=0;
      Lines[i]:=t;
      end;
    EndUpdate;
    end;
  end;

function TDataDialog.CompareVals (const arg1,arg2) : boolean;
var
  n1 : TData absolute arg1;
  n2 : TData absolute arg2;
begin
  Result:=n1.Val.X<n2.Val.X;
  end;

procedure TDataDialog.sbSortClick(Sender: TObject);
begin
  SaveData;
  QuickSort(FData[0],length(FData),SizeOf(TData),CompareVals);
  ShowData;
  end;

procedure TDataDialog.seDataKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Space then Key:=VK_Tab;
  end;

procedure TDataDialog.bbImportClick(Sender: TObject);
var
  ImpSet : TImportSettings;
  ft     : TReadTextFile;
  line,
  j,n,k  : integer;
  s,t    : string;
  da     : TDataArray;
  err    : boolean;

  function ReadFloat (s       : String;
                      Default : double;
                      var err : boolean) : double;
  var
    i,ic : integer;
    x    : double;
  begin
    s:=RemSp(ReplChars(s,FoImp.DecSeparator,DecSep));
    if length(s)=0 then Result:=0
    else begin
      i:=1;
      while (i<=length(s)) and (s[i] in FloatChars) do inc(i);
      val(copy(s,1,pred(i)),x,ic);
      if ic=0 then Result:=x
      else begin
        Result:=Default;
        err:=true;
        end;
      end;
    end;

  function MeanValues(Data : TDataArray; n,dn : integer) : TData;
  var
    i : integer;

    procedure Add (Val : TFPoint; var Sum : TFPoint);
    begin
      with Sum do begin
        x:=x+Val.X; y:=y+Val.Y;
        end;
      end;

  begin
    with Result do begin
      with Val do begin
        x:=0; y:=0;
        end;
      with PErr do begin
        x:=0; y:=0;
        end;
      with MErr do begin
        x:=0; y:=0;
        end;
      end;
    for i:=n to n+dn-1 do with Data[i] do begin
      Add(Val,Result.Val);
      Add(PErr,Result.PErr);
      Add(MErr,Result.MErr);
      end;
    with Result do begin
      with Val do begin
        x:=x/dn; y:=y/dn;
        end;
      with PErr do begin
        x:=x/dn; y:=y/dn;
        end;
      with MErr do begin
        x:=x/dn; y:=y/dn;
        end;
      end;
    end;

begin
  with OpenDialog do begin
    with FoImp do begin
      InitialDir:=Path;
      Filename:='*.'+Ext;
      end;
    DefaultExt:='';
    Filter:=_('CSV files')+'|*.'+CsvExt+'|'+_('Text files')+'|*.'+TxtExt+'|'+_('all')+'|*.*';
    Title:=TryFormat(_('Import data for: %s'),[FTitle]);
    if Execute then begin
      with FoImp do begin
        Path:=ExtractFilePath(Filename);
        Ext:=GetExt(Filename);
        end;
      if ImportDialog.Execute(Filename,FoImp,FDataCols,ImpSet) then begin
        ft:=TReadTextFile.Create(Filename,fmShareDenyRead);
        n:=0; line:=0;
        with ft do while not Eof do begin
          inc(line);
          if (length(ReadString)>0) and (line>=ImpSet.FirstLine) then inc(n);  // Zeilen zählen
          end;
        SetLength(da,n);
        ft.Reset; n:=0; line:=0;
        with ft,ImpSet do while not Eof do begin
          inc(line);
          s:=ReadString;
          if (length(s)>0) and (line>=FirstLine) then begin
            j:=0; err:=false;
            with da[n] do begin
              Val.X:=0; Val.Y:=0;
              MErr.X:=0; MErr.Y:=0;
              PErr.X:=0; PErr.Y:=0;
              repeat
                with FoImp do if QuoteChar=#0 then t:=ReadNxtStr(s,ColSeparator)
                else t:=ReadNxtQuotedStr(s,ColSeparator,QuoteChar);
                inc(j);
                if length(t)>0 then begin
                  with XCols do begin
                    if j=icV then Val.X:=ReadFloat(t,0,err);
                    if j=icP then PErr.X:=ReadFloat(t,0,err);
                    if j=icM then MErr.X:=ReadFloat(t,0,err);
                    end;
                  with YCols do begin
                    if j=icV then Val.Y:=ReadFloat(t,0,err);
                    if j=icP then PErr.Y:=ReadFloat(t,0,err);
                    if j=icM then MErr.Y:=ReadFloat(t,0,err);
                    end;
                  end;
                until length(s)=0;
              end;
            if err then begin
              if ConfirmDialog (Caption,_('Error in')+sLineBreak+
                        StripPath(Filename,30)+_(' - Line:')+IntToStr(line)+sLineBreak+
                        _('Cancel import?')) then begin
                Free; da:=nil; Exit;
                end
              end
            else inc(n);
            end;
          end;
        ft.Free;
        if ImpSet.Reduce>1 then begin
          k:=(n+1) div ImpSet.Reduce -1; n:=ImpSet.Reduce;
          SetLength(FData,k);
          for j:=0 to k do FData[j]:=MeanValues(da,n*j,n);
          end
        else begin
          SetLength(FData,n); FData:=da;
          end;
        ShowData;
        end;
      end;
    end;
  end;

procedure TDataDialog.edTabChange(Sender: TObject);
begin
  ShowData;
  end;

procedure TDataDialog.rgErrClick(Sender: TObject);
begin
  SaveData;
  ShowData;
  end;

function TDataDialog.Execute (const ATitle : string; ShowErrors : boolean;
                              var AutoAlign : boolean;
                              var ADataTable : TDataTable) : boolean;
begin
  Caption:=_('Edit data for ')+ATitle;
  FTitle:=ATitle;
  paTop.Visible:=ShowErrors;
  with ADataTable do begin
    xcol:=dcValX in DataCols ; ycol:=dcValY in DataCols ;
    rbXNoerr.Checked:=true;
    rbXSymErr.Checked:=dcErrSX in DataCols;
    rbXAsymErr.Checked:=dcErrAX in DataCols;
    rbYNoerr.Checked:=true;
    rbYSymErr.Checked:=dcErrSY in DataCols;
    rbYAsymErr.Checked:=dcErrAY in DataCols;
    SetLength(FData,Count);
    FData:=Copy(Data);
    cxRange.Checked:=Count=0;
    ShowData;
    end;
  Result:=ShowModal=mrOK;
  if Result then with ADataTable do begin
    AutoAlign:=cxRange.Checked;
    DataCols:=FDataCols;
    SaveData;
    Count:=length(FData);
    SetLength(Data,Count);
    Data:=Copy(FData);
    end
  else FData:=nil;
  end;

end.
