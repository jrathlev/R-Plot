(* RPlot window
   Screen output of the plot sheet

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

unit RPlotView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, RPlotMain, RPlotObjects, RPlotUtils,
  WinUtils, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, Vcl.Buttons,
  Vcl.ComCtrls;

const
  crEyeDrop = 1;
  crFill = 2;
  crMoveObject = 3;
  crMovePoint = 4;
  crArrowCheck = 5;

type
  TCurrentAction = (caNone,caFrame,caBox,caLine,caRect,caColor,caMove);  // interaktive Aktionen

  TfrmView = class(TForm)
    GraphBox: TScrollBox;
    GraphArea: TPaintBox;
    sbHorz: TScrollBar;
    sbVert: TScrollBar;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GraphAreaPaint(Sender: TObject);
    procedure sbZoomInClick(Sender: TObject);
    procedure sbZoomOutClick(Sender: TObject);
    procedure GraphBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GraphAreaMouseEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure itSaveSheetClick(Sender: TObject);
    procedure sbCopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GraphAreaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GraphAreaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GraphAreaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen }
    FIniName                  : string;
    Zoom                      : double;
    ChartIndex,ItemIndex      : integer;
    Frame,
    CurrrentOutline           : TRect;
    ItemAction                : TItemAction;
    CurrentAction             : TCurrentAction;
    GrPlot                    : TSheetToWindow;
    SelIndex                  : TChartItemIndex;
    DPos                      : TFPoint;
    OldMPos,MPos              : TPoint;
    function MouseToUnit (Pos : TPoint) : TFPoint;
    function UnitToMouse (UPos : TFPoint) : TPoint;
    procedure MoveViewArea;
    procedure ShowBox;
    procedure MoveBox;
    procedure DeleteBox;
    procedure ShowLine;
    procedure MoveLine;
    procedure DeleteLine;
    procedure ShowRect;
    procedure MoveRect;
    procedure DeleteRect;

  public
    { Public-Deklarationen }
    procedure LoadFromIni (const AIniName : string);
    procedure InitWindowPlot;
    procedure InitView;
    procedure UpdateView;
    function GetClipWindow : TRect;
    procedure ZoomView (AZoomMode : TZoomMode);
    procedure ShowOutline (ChNdx,ItNdx : integer);
    procedure ShowPrinter (AName : string);
    procedure ShowWindow;
    procedure SelectColor (Enable : boolean);
  end;

var
  frmView: TfrmView;

implementation

{$R *.dfm}

uses GnuGetText, IniFiles, SetCustomColorDlg;

procedure TfrmView.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  FIniName:='';
  ChartIndex:=-1; ItemIndex:=-1;
  CurrentAction:=caNone; ItemAction:=iaNone;
  with SelIndex do begin
    ChartNr:=-1; ItemNr:=-1;
    end;
  end;

procedure TfrmView.LoadFromIni (const AIniName : string);
begin
  FIniName:=AIniName;
  with TIniFile.Create(FIniName) do begin
//    with Form do begin
      Left:=ReadInteger (ViewSekt,IniLeft,Left);
      Top:=ReadInteger (ViewSekt,IniTop,Top);
      ClientWidth:=ReadInteger (ViewSekt,iniWidth,ClientWidth);
      ClientHeight:=ReadInteger (ViewSekt,iniHeight,ClientHeight);
//      end;
    Zoom:=ReadInteger(ViewSekt,iniZoom,100)/100;
    sbHorz.Position:=ReadInteger(ViewSekt,iniSHorz,0);
    sbVert.Position:=ReadInteger(ViewSekt,iniSVert,0);
    Free;
    end;
  end;

procedure TfrmView.FormDestroy(Sender: TObject);
begin
  if length(FIniName)>0 then with TIniFile.Create(FIniName) do begin
    WriteInteger (ViewSekt,IniLeft,Left);
    WriteInteger (ViewSekt,IniTop,Top);
    WriteInteger(ViewSekt,iniWidth,ClientWidth);
    WriteInteger(ViewSekt,iniHeight,ClientHeight);
    WriteInteger(ViewSekt,iniZoom,round(100*Zoom));
    WriteInteger(ViewSekt,iniSHorz,sbHorz.Position);
    WriteInteger(ViewSekt,iniSVert,sbVert.Position);
    Free;
    end;
  end;

procedure TfrmView.FormResize(Sender: TObject);
begin
  if assigned(GrPlot) then GraphArea.Invalidate;
  end;

procedure TfrmView.FormShow(Sender: TObject);
begin
  with frmSheet do begin
    Show; BringToFront;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TfrmView.InitWindowPlot;
begin
  GrPlot:=TSheetToWindow.Create (GraphArea.Canvas);
  end;

procedure TfrmView.InitView;
begin
  with GrPlot do begin
    InitSheet(frmSheet.Sheet);
    CurrrentOutline:=SheetField;
    end;
  GraphArea.Invalidate;
  end;

procedure TfrmView.UpdateView;
begin
  if not Visible then Show;
  if WindowState=wsMinimized then WindowState:=wsNormal;
  GraphArea.Invalidate;
  end;

procedure TfrmView.ShowPrinter (AName : string);
begin
  StatusBar.Panels[0].Text:=AName;
  end;

procedure TfrmView.ZoomView (AZoomMode : TZoomMode);
begin
  if AZoomMode=zmIn then Zoom:=1.4*Zoom
  else if AZoomMode=zmOut then Zoom:=Zoom/1.4
  else Zoom:=1;
  UpdateView;
  end;

procedure TfrmView.GraphBoxMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta<>0 then begin
    if WheelDelta>0 then Zoom:=(1+WheelDelta/1200)*Zoom
    else Zoom:=Zoom/(1-WheelDelta/1200);
    UpdateView;
    end;
  end;

{ ------------------------------------------------------------------- }
// from mouse coordinates to cm/inch
function TfrmView.MouseToUnit (Pos : TPoint) : TFPoint;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    Result:=ViewToUnit(Pos);
    end;
  end;

// from cm/inch to mouse coordinates
function TfrmView.UnitToMouse (UPos : TFPoint) : TPoint;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    Result:=UnitToView (UPos);
    end;
  end;

procedure TfrmView.MoveViewArea;
var
  dx,dy : integer;
begin
  if CurrentAction=caMove then begin
    dx:=MPos.X-OldMPOs.X;
    dy:=OldMPOs.y-MPos.y;
    if (abs(dx)>2) or (abs(dy)>2) then begin
      with sbVert do Position:=Position+trunc(500*dy/Height);
      with sbHorz do Position:=Position-trunc(500*dx/Width);
      GraphArea.Invalidate;
      end;
    end
  else begin
    CurrentAction:=caMove;
    Screen.Cursor:=crHandPoint;
    Application.ProcessMessages;
    ShowOutline(-1,-1);
    end;
  end;

procedure TfrmView.ShowBox;
begin
  with GrPlot do begin
    GetFrame(SelIndex,Frame);
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
    end;
  OldMPos:=MPos;
  CurrentAction:=caBox;
  end;

procedure TfrmView.MoveBox;
var
  dx,dy : integer;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    with ViewToWindow(MPos) do begin
      dx:=X; dy:=Y;
      end;
    with ViewToWindow(OldMPos) do begin
      dx:=dx-X; dy:=dy-Y;
      end;
//    StatusBar.Panels[1].Text:=IntToStr(dx)+'/'+IntToStr(dy);
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
    with Frame do begin
      Left:=Left+dx; Top:=Top+dy;
      Right:=Right+dx; Bottom:=Bottom+dy;
      end;
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
    if (abs(dx)>0) or (abs(dy)>0) then frmSheet.SetChangeStatus(true);
    end;
  end;

procedure TfrmView.DeleteBox;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
    end;
  CurrentAction:=caNone;
  end;

procedure TfrmView.ShowLine;
begin
  with GrPlot do begin
    GetLine(SelIndex,Frame);
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotWay(Frame,clBlack,psDash,pmNotXor);
//    MoveMode:=GetMoveMode(ViewToWindow(MPos),Frame);
//    if MoveMode<>mmNone then
    CurrentAction:=caLine;
    end;
  end;

procedure TfrmView.MoveLine;
var
  dx,dy : integer;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotWay(Frame,clBlack,psDash,pmNotXor);
    with ViewToWindow(MPos) do begin
      dx:=X; dy:=Y;
      end;
    with ViewToWindow(OldMPos) do begin
      dx:=dx-X; dy:=dy-Y;
      end;
    with Frame do if ItemAction=iaMoveStart then begin
      Left:=Left+dx; Bottom:=Bottom+dy;
      end
    else if ItemAction=iaMoveEnd then begin
      Right:=Right+dx; Top:=Top+dy;
      end
    else begin
      Left:=Left+dx; Top:=Top+dy;
      Right:=Right+dx; Bottom:=Bottom+dy;
      end;
    PlotWay(Frame,clBlack,psDash,pmNotXor);
    if (abs(dx)>0) or (abs(dy)>0) then frmSheet.SetChangeStatus(true);
    end;
  end;

procedure TfrmView.DeleteLine;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotWay(Frame,clBlack,psDash,pmNotXor);
    end;
  CurrentAction:=caNone;
  end;

procedure TfrmView.ShowRect;
begin
  with GrPlot do begin
    GetRect(SelIndex,Frame);
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
//    MoveMode:=GetMoveMode(ViewToWindow(MPos),Frame);
//    if MoveMode<>mmNone then
    CurrentAction:=caRect;
    end;
  end;

procedure TfrmView.MoveRect;
var
  dx,dy : integer;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
    with ViewToWindow(MPos) do begin
      dx:=X; dy:=Y;
      end;
    with ViewToWindow(OldMPos) do begin
      dx:=dx-X; dy:=dy-Y;
      end;
    with Frame do begin
      if ItemAction=iaMoveRect then begin
        Left:=Left+dx; Top:=Top+dy;
        Right:=Right+dx; Bottom:=Bottom+dy;
        end
      else if ItemAction=iaMoveSS then begin
        Left:=Left+dx; Bottom:=Bottom+dy;
        end
      else if ItemAction=iaMoveSE then begin
        Left:=Left+dx; Top:=Top+dy;
        end
      else if ItemAction=iaMoveEE then begin
        Right:=Right+dx; Top:=Top+dy;
        end
      else begin
        Right:=Right+dx; Bottom:=Bottom+dy;
        end
      end;
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
    if (abs(dx)>0) or (abs(dy)>0) then frmSheet.SetChangeStatus(true);
    end;
  end;

procedure TfrmView.DeleteRect;
begin
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotFrame(Frame,clBlack,psDash,pmNotXor);
    end;
  CurrentAction:=caNone;
  end;

procedure TfrmView.GraphAreaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (CurrentAction=caColor) then begin
    if (Button=mbLeft) then SetUserColor(GraphArea.Canvas.Pixels[x,y],UserColors);
    StatusBar.Panels[1].Text:='';
    with frmSheet do begin
      sbPipette.Down:=false;
      BringToFront;
      end;
    end
  else begin
    CurrentAction:=caNone;
    MPos.X:=X; MPos.Y:=Y;
    DPos:=MouseToUnit(MPos);
    ShowOutline(-1,-1);
    with SelIndex do ShowOutline(ChartNr,ItemNr);
    frmSheet.SelectItem(SelIndex);
    case ItemAction of
    iaMoveBox :  ShowBox;
    iaMoveLine,iaMoveStart,iaMoveEnd : ShowLine;
    iaMoveRect,iaMoveSS,iaMoveSE,iaMoveES,iaMoveEE : ShowRect;
    iaFixed : CurrentAction:=caFrame;
{    DPos:=MouseToUnit(MPos);
    with GrPlot do if not SecondHit and IsItemAt(DPos,SelIndex) then begin
      if GetLine(SelIndex,Frame) then ShowLine
      else if GetRect(SelIndex,Frame) then ShowRect
      else if GetFrame(SelIndex,Frame) then ShowBox;
      SecondHit:=true;
      end
    else if GetNextItemAt(DPos,SelIndex) then begin
      ShowOutline(-1,-1);
      with SelIndex do ShowOutline(ChartNr,ItemNr);
      frmSheet.SelectItem(SelIndex);
      if GetLine(SelIndex,Frame) then ShowLine
      else if GetRect(SelIndex,Frame) then ShowRect
      else if GetFrame(SelIndex,Frame) then ShowBox;
      SecondHit:=false;
      end                     }
      end;
    end;
  if (Button=mbRight) and (ItemAction<>iaNone) then begin
    with SelIndex do if (ChartNr>=0) then begin
      if (ItemNr>=0) then frmSheet.EditItem(ItemNr)
      else frmSheet.EditChart;
      GraphAreaMouseUp(Sender,Button,Shift,X,Y);
      end;
    end
  end;

procedure TfrmView.GraphAreaMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  MPos.X:=X; MPos.Y:=Y;
  if ssLeft in Shift then begin
    if (CurrentAction=caNone) or (CurrentAction=caMove) then MoveViewArea
    else if CurrentAction=caLine then MoveLine
    else if CurrentAction=caRect then MoveRect
    else if CurrentAction=caBox then MoveBox;
    end
  else if CurrentAction=caNone then begin
    DPos:=MouseToUnit(MPos);
    ItemAction:=GrPlot.GetItemFromPos(DPos,SelIndex);
    case ItemAction of
    iaFixed : GraphArea.Cursor:=crArrowCheck;
    iaMoveBox,iaMoveRect,iaMoveLine: GraphArea.Cursor:=crMoveObject;
    iaMoveStart,iaMoveEnd,iaMoveSS,iaMoveSE,iaMoveES,iaMoveEE : GraphArea.Cursor:=crMovePoint;
    else GraphArea.Cursor:=crDefault;
      end;
    with StatusBar.Panels[1] do if ItemAction<>iaNone then Text:=frmSheet.GetItemName(SelIndex)
    else Text:='';
    end
  else if CurrentAction=caColor then begin
//    GraphArea.Cursor:=crEyeDrop;
    StatusBar.Panels[1].Text:=GetColorString(GraphArea.Canvas.Pixels[x,y]);
    end;
  OldMPOs:=MPos;
  end;

procedure TfrmView.GraphAreaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  UPos : TFPoint;
begin
  MPos.X:=X; MPos.Y:=Y;
  UPos:=MouseToUnit(MPos);
  if CurrentAction=caColor then CurrentAction:=caNone
  else if CurrentAction<>caNone then begin
    if CurrentAction=caMove then begin
      CurrentAction:=caNone; Screen.Cursor:=crDefault;
      end
    else begin
      GrPlot.MoveItem(DPos,UPos,SelIndex,ItemAction);
      with SelIndex do begin
        ShowOutline(ChartNr,ItemNr);
        end;
      if CurrentAction=caLine then DeleteLine
      else if CurrentAction=caRect then DeleteRect
      else if CurrentAction=caBox then DeleteBox
      else CurrentAction:=caNone;
      end;
    end
  else ShowOutline(-1,-1);
  GraphArea.Invalidate;
  end;

procedure TfrmView.GraphAreaMouseEnter(Sender: TObject);
begin
  ActiveControl:=GraphBox;
  end;

procedure TfrmView.GraphAreaPaint(Sender: TObject);
begin
  if not assigned(GrPlot) then Exit;
  sbHorz.Visible:=Zoom>1.0;
  sbVert.Visible:=sbHorz.Visible;
  if Visible then with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    PlotSheet(true);
    PlotOutline(ChartIndex,ItemIndex);
    if CurrentAction=caBox then ShowBox;
    end;
  end;

procedure TfrmView.ShowOutline (ChNdx,ItNdx : integer);
begin
  if (ChNdx=ChartIndex) and (ItNdx=ItemIndex) then Exit;
  with GrPlot do begin
    InitView(GetSize(GraphArea),Point(sbHorz.Position,sbVert.Position),Zoom);
    if ChNdx<0 then begin
      if ChartIndex>=0 then PlotOutline(ChartIndex,ItemIndex);
      ChartIndex:=-1;
      end
    else begin
      ChartIndex:=ChNdx; ItemIndex:=ItNdx;
      PlotOutline(ChNdx,ItNdx);
      end;
    GraphArea.Invalidate;
    end;
  end;

procedure TfrmView.itSaveSheetClick(Sender: TObject);
begin
  end;

{ ------------------------------------------------------------------- }
function TfrmView.GetClipWindow : TRect;
var
  ClipRect : TRect;
  d        : integer;
begin
  with GrPlot do if CurrentAction=caFrame then begin
    ClipRect:=CurrrentOutline;
    with ClipRect do begin
      if Left>Right then begin
        d:=Left; Left:=Right; Right:=d;
        end;
      if Top<Bottom then begin
        d:=Top; Top:=Bottom; Bottom:=d;
        end;
      end;
    end
  else begin
    ClipRect:=SheetField;
    end;
  Result:=ClipRect;
  end;

procedure TfrmView.sbCopyClick(Sender: TObject);
begin
  end;

{ ------------------------------------------------------------------- }
procedure TfrmView.sbZoomInClick(Sender: TObject);
begin
  Zoom:=1.4*Zoom;
  UpdateView;
  end;

procedure TfrmView.sbZoomOutClick(Sender: TObject);
begin
  Zoom:=Zoom/1.4;
  UpdateView;
  end;

{ ------------------------------------------------------------------- }
procedure TfrmView.ShowWindow;
begin
  Show;
  end;

{ ------------------------------------------------------------------- }
procedure TfrmView.SelectColor (Enable : boolean);
begin
  if Enable then begin
    CurrentAction:=caColor;
    GraphArea.Cursor:=crEyeDrop;
    BringToFront;
    end
  else begin
    CurrentAction:=caNone;
    GraphArea.Cursor:=crDefault;
    end;
  StatusBar.Panels[1].Text:='';
  end;

end.
