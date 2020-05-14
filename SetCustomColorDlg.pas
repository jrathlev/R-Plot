(* RPlot dialog
   Edit custom colors

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

unit SetCustomColorDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TSetCustomColorDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    paNewColor: TPanel;
    gbUserColors: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    BitMap       : TBitMap;
    ColButtons   : array [0..15] of TBitBtn;
    procedure SelectColClick(Sender: TObject);
  public
    { Public-Deklarationen }
    function Execute (AColor : TColor; var AColorStr : string) : boolean;
  end;

function SetUserColor (AColor : TColor; var AColorStr : string) : boolean;

var
  SetCustomColorDialog: TSetCustomColorDialog;

implementation

{$R *.dfm}

uses GnuGetText, StringUtils, RPlotUtils;

const
  BitMapHeight = 21;
  BitMapWidth = 41;
  BtnHeight= 31;
  BtnWidth= 51;

procedure TSetCustomColorDialog.FormCreate(Sender: TObject);
var
  i : integer;
begin
  TranslateComponent(self);
  BitMap:=TBitMap.Create;
  with BitMap do begin
    Height:=BitMapHeight; Width:=BitMapWidth;
    TransparentMode:=tmFixed;
    end;
  for i:=0 to 15 do begin
    ColButtons[i]:=TBitBtn.Create(self);
    with ColButtons[i] do begin
      Parent:=gbUserColors;
      Height:=BtnHeight; Width:=BtnWidth;
      Top:=20+(BtnHeight+10)*(i div 8);
      Left:=10+(BtnWidth+10)*(i mod 8);
      TabOrder:=i;
      OnClick:=SelectColClick;
      end;
    end;
  end;

procedure TSetCustomColorDialog.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  Bitmap.Free;
  for i:=0 to 15 do ColButtons[i].Free;
  end;

procedure TSetCustomColorDialog.SelectColClick(Sender: TObject);
begin
  FillBtnGlyph(Bitmap,ColButtons[(Sender as TBitBtn).TabOrder],paNewColor.Color);
  end;

function TSetCustomColorDialog.Execute (AColor : TColor; var AColorStr : string) : boolean;
var
  i : integer;
  col : TColor;
  s,t,sn : string;
begin
  paNewColor.Color:=AColor;
  s:=AColorStr;
  for i:=0 to 15 do begin
    t:=ReadNxtStr(s,',');
    if length(s)>0 then begin
      sn:=ReadNxtStr(t,'='); t:='$'+t;
      col:=ReadNxtInt(t,'=',-1);
      end
    else col:=-1;
    FillBtnGlyph(Bitmap,ColButtons[i],col);
    end;
  Result:=ShowModal=mrOK;
  if Result then begin
    AColorStr:='';
    for i:=0 to 15 do begin
      AColorStr:=AColorStr+',Color'+chr(i+65)+'=';
      with ColButtons[i] do if Tag<0 then AColorStr:=AColorStr+'FFFFFFFF'
      else AColorStr:=AColorStr+IntToHex(Tag and $FFFFFF,3);
      end;
    Delete(AColorStr,1,1);
    end;
  end;

function SetUserColor (AColor : TColor; var AColorStr : string) : boolean;
begin
  if not assigned(SetCustomColorDialog) then SetCustomColorDialog:=TSetCustomColorDialog.Create(Application);
  Result:=SetCustomColorDialog.Execute(AColor,AColorStr);
  FreeAndNil(SetCustomColorDialog);
  end;

end.
