(* RPlot dialog
   Select an axis from a chart on the sheet

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

unit SelectAxisDlg;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, RPlotObjects, RPlotUtils;

type
  TSelectAxisDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    lbCharts: TListBox;
    lbItems: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lbChartsClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FSheet : TSheet;
  public
    { Public-Deklarationen }
{$IFDEF HDPI}   // scale glyphs and images for High DPI
    procedure AfterConstruction; override;
{$EndIf}
    function Execute (APos : TPoint; ASheet : TSheet; var AChartItem,AItemID : integer) : boolean;
  end;

function SelectAxis(APos : TPoint; ASheet : TSheet; var AChartItem,AItemID : integer) : boolean;

var
  SelectAxisDialog: TSelectAxisDialog;

implementation

{$R *.dfm}

uses GnuGetText, WinUtils;

procedure TSelectAxisDialog.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  end;

{$IFDEF HDPI}   // scale glyphs and images for High DPI
procedure TSelectAxisDialog.AfterConstruction;
begin
  inherited;
  if Application.Tag=0 then begin
    ScaleButtonGlyphs(self,PixelsPerInchOnDesign,Monitor.PixelsPerInch);
    end;
  end;
{$EndIf}

procedure TSelectAxisDialog.lbChartsClick(Sender: TObject);
var
  i : integer;
begin
  lbItems.Clear;
  with lbCharts do if ItemIndex>=0 then begin
    with FSheet.Chart[ItemIndex] do begin
      for i:=0 to ItemCount-1 do with Item[i] do if ItemType=itAxis then
        lbItems.AddItem(Description,nil);
      end;
    end;
  end;

function TSelectAxisDialog.Execute (APos : TPoint; ASheet : TSheet; var AChartItem,AItemID : integer) : boolean;
var
  i,j,n : integer;
begin
  Result:=false;
  if APos.X<0 then Position:=poScreenCenter
  else with APos do begin
    Position:=poDesigned;
    if X<0 then X:=Left;
    if Y<0 then Y:=Top;
    CheckScreenBounds(Screen,x,y,Width,Height);
    Left:=x; Top:=y;
    end;
  FSheet:=ASheet;
  with FSheet do begin
    with lbCharts do begin
      Clear; n:=-1;
      for i:=0 to ChartCount-1 do with Chart[i] do begin
        lbCharts.AddItem(ChartDesc,nil);
        if n<0 then for j:=0 to ItemCount-1 do if Item[j].Itemtype=itAxis then begin
          n:=i; Break;
          end;
        end;
      if n<0 then begin
        ErrorDialog(_('No axes found on this sheet!'));
        Exit;
        end;
      ItemIndex:=n;
      end;
    end;
  lbChartsClick(self);
  Result:=ShowModal=mrOK;
  if Result then begin
    if (lbCharts.ItemIndex>=0) and (lbItems.ItemIndex>=0) then begin
      AChartItem:=lbCharts.ItemIndex;
      AItemID:=ASheet.Chart[AChartItem].Item[lbItems.ItemIndex].ItemID;
      end;
    end;
  end;

function SelectAxis(APos : TPoint; ASheet : TSheet; var AChartItem,AItemID : integer) : boolean;
begin
  if not assigned(SelectAxisDialog) then SelectAxisDialog:=TSelectAxisDialog.Create(Application);
  Result:=SelectAxisDialog.Execute(APos,ASheet,AChartItem,AItemID);
  FreeAndNil(SelectAxisDialog);
  end;

end.
