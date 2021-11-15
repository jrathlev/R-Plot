(* Anzeige-Komponenten
   TSpotIndicator - runde farbige Anzeige
   TArrowIndicator - Pfeil in 4 Richtungen

   © Dr. J. Rathlev, D-24222 Schwentinental (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Vers. 1 - Feb. 2002
   letzte Änderung: Feb. 2008
   *)

unit Indicators;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.StdCtrls;

// Definiere CompPalPage (siehe Register)
{$Include UserComps.pas }

type
  TArrowPoints = array [0..7] of TPoint;
  TArrowDirection = (adUp,adRight,adDown,adLeft);

const
  Arrow : TArrowPoints = ((x:8;y:0),(x:0;y:8),(x:4;y:8),(x:4;y:16),
                          (x:12;y:16),(x:12;y:8),(x:16;y:8),(x:8;y:0));

type
  TCustomIndicator = class (TGraphicControl)
  protected
    { Private declarations }
    FColorOff,
    FColorOn  : TColor;
    FIndicate : boolean;
    procedure SetColorOn (value: TColor);
    procedure SetColorOff (value: TColor);
    procedure SetIndicate (value : boolean);
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnClick;
    property OnDblClick;
    end;

  TSpotIndicator = class (TCustomIndicator)
  private
    FBorder : integer;
  protected
    procedure SetBorder (value : integer);
    procedure Paint; override;
  published
    property Border : integer read FBorder write SetBorder default 2;
    property ColorOff : TColor read FColorOff write SetColorOff default clWhite;
    property ColorOn  : TColor read FColorOn write SetColorOn default clRed;
    property Indicate : boolean read FIndicate write SetIndicate default false;
    property Enabled;
    property ParentColor;
    property ShowHint;
  public
    constructor Create(AOwner: TComponent); override;
    end;

  TLamp = class (TCustomIndicator)
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ColorOff : TColor read FColorOff write SetColorOff default clWhite;
    property ColorOn  : TColor read FColorOn write SetColorOn default clRed;
    property LightOn : boolean read FIndicate write SetIndicate default true;
    end;

  TGlyphSize = (gs16,gs24,gs32,gs48,gs64,gs96);

  TLamp3D = class (TCustomIndicator)
  private
    FGlyphSize : TGlyphSize;
    FBitMap    : TBitMap;
    procedure SetIndicate (value : boolean);
    procedure SetGlyphSize (Value : TGlyphSize);
    procedure AdjustSize (var W, H: Integer); reintroduce;
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property GlyphSize : TGlyphSize read FGlyphSize write SetGlyphSize default gs24;
    property LightOn : boolean read FIndicate write SetIndicate default true;
    end;

  TArrowIndicator = class (TCustomIndicator)
  private
    FDir   : TArrowDirection;
    FArrow : TArrowPoints;
    w,h    : integer;
    procedure ComputePoints;
    procedure SetDirection (ADir : TArrowDirection);
  public
    constructor Create(AOwner: TComponent); override;
  protected
    procedure Paint; override;
  published
    property ColorOff : TColor read FColorOff write SetColorOff default clBlue;
    property ColorOn  : TColor read FColorOn write SetColorOn default clRed;
    property Indicate : boolean read FIndicate write SetIndicate default false;
    property Direction : TArrowDirection read FDir write SetDirection default adUp;
    property Enabled;
    property ParentColor;
    property ShowHint;
    end;

procedure Register;

implementation

{$R Lamps.res}

constructor TCustomIndicator.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  { set defaults }
  Width:=16;
  Height:=16;
  FColorOff:=clBlack;
  FColorOn:=clWhite;
  FIndicate:=false;
  end;

procedure TCustomIndicator.SetColorOn (value: TColor);
begin
  FColorOn:=value;
  Invalidate;
  end;

procedure TCustomIndicator.SetColorOff (value: TColor);
begin
  FColorOff:=value;
  Invalidate;
  end;

procedure TCustomIndicator.SetIndicate (value : boolean);
begin
  FIndicate:=value;
  Invalidate;
  end;

procedure TCustomIndicator.SetEnabled(Value: Boolean);
begin
  if Enabled <> Value then begin
    inherited SetEnabled(Value);
    Invalidate;
    end;
  end;

{ ---------------------------------------------------------------- }
constructor TSpotIndicator.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorOff:=clWhite;
  FColorOn:=clRed;
  FBorder:=2;
  end;

procedure TSpotIndicator.SetBorder (value : integer);
begin
  FBorder:=value;
  Invalidate;
  end;

procedure TSpotIndicator.Paint;
var
  b : integer;
begin
  with Canvas do begin
    Brush.Color:=clWhite;
    with Pen do begin
      Color:=clGray; Width:=1;
      end;
    Ellipse (0,0,Height,Height);
    Pen.Color:=clSilver;
    Pie (0,0,Height,Height,0,Height,Height,0);
    Ellipse (1,1,Height-1,Height-1);
    if Enabled then begin
      if FIndicate then Brush.Color:=FColorOn
      else Brush.Color:=FColorOff;
      end 
    else Brush.Color:=clBtnface;
    b:=Border+1;
    Ellipse (b,b,Height-b,Height-b);
    end;
  end;

{ ---------------------------------------------------------------- }
(* Anzeigelampe *)
constructor TLamp.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorOff:=clGray;
  FColorOn:=$001BBCE4;
  FIndicate:=true;
  end;

procedure TLamp.Paint;
begin
  with Canvas do begin
    with Pen do begin
      Color:=clGray; Width:=0;
      end;
    if FIndicate then Brush.Color:=FColorOn
    else Brush.Color:=FColorOff;
    Ellipse (0,0,Height-1,Height-1);
    end;
  end;

{ ---------------------------------------------------------------- }
(* 3D Anzeigelampe *)
const
  GlyphSizes : array [TGlyphSize] of integer = (16,24,32,48,64,96);

constructor TLamp3D.Create (AOwner: TComponent);
begin
  FBitMap:=TBitMap.Create;
  with FBitMap do begin
    Transparent:=True;
    TransparentMode:=tmAuto;
    Width:=24; Height:=24;
    end;
  inherited Create(AOwner);
  FIndicate:=true;
  GlyphSize:=gs24;
  end;

destructor TLamp3D.Destroy;
begin
  FBitMap.Free;
  inherited Destroy;
  end;

procedure TLamp3D.SetGlyphSize (Value : TGlyphSize);
var
  s : string;
begin
  FGlyphSize:=Value;
  case Value of
  gs16 : if FIndicate then s:='Lamp16' else s:='Dark16';
  gs32 : if FIndicate then s:='Lamp32' else s:='Dark32';
  gs48 : if FIndicate then s:='Lamp48' else s:='Dark48';
  gs64 : if FIndicate then s:='Lamp64' else s:='Dark64';
  gs96 : if FIndicate then s:='Lamp96' else s:='Dark96';
    else if FIndicate then s:='Lamp24' else s:='Dark24';
    end;
  FBitMap.Handle:=LoadBitmap(HInstance,pchar(s));
  Width:=GlyphSizes[Value];
  Height:=GlyphSizes[Value];
  end;

procedure TLamp3D.SetIndicate (value : boolean);
begin
  FIndicate:=Value;
  SetGlyphSize(FGlyphSize);
  Invalidate;
  end;

procedure TLamp3D.AdjustSize(var W,H: Integer);
begin
  if (csLoading in ComponentState) then Exit;
  with FBitMap do begin
    if W<Width then W:=Width;
    if H<Height then H:=Height;
    end;
  end;

procedure TLamp3D.SetBounds(ALeft,ATop,AWidth,AHeight: Integer);
var
  W, H: Integer;
begin
  W:=AWidth;
  H:=AHeight;
  AdjustSize(W,H);
  inherited SetBounds(ALeft,ATop,W,H);
  end;

procedure TLamp3D.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  { check for minimum size }
  W:=Width; H:=Height;
  AdjustSize(W,H);
  if (W<>Width) or (H<>Height) then inherited SetBounds(Left,Top,W,H);
  Message.Result:=0;
  end;

procedure TLamp3D.Paint;
begin
  Canvas.Draw(0,0,FBitMap);
  end;

{ ---------------------------------------------------------------- }
(* Pfeil in 4 Richtungen *)
constructor TArrowIndicator.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorOff:=clGreen;
  FColorOn:=clRed;
  w:=0; h:=0;
  end;

procedure TArrowIndicator.ComputePoints;
var
  scx,scy : single;
  i       : integer;
begin
  scx:=(Width-1)/16; scy:=(Height-1)/16;
  case FDir of
  adUp    : for i:=0 to 7 do with FArrow[i] do begin
            x:=round(scx*Arrow[i].x); y:=round(scy*Arrow[i].y);
            end;
  adDown  : for i:=0 to 7 do with FArrow[i] do begin
            x:=round(scx*Arrow[i].x); y:=round(scy*(16-Arrow[i].y));
            end;
  adLeft  : for i:=0 to 7 do with FArrow[i] do begin
            x:=round(scx*Arrow[i].y); y:=round(scy*Arrow[i].x);
            end;
  adRight : for i:=0 to 7 do with FArrow[i] do begin
            x:=round(scx*(16-Arrow[i].y)); y:=round(scy*Arrow[i].x);
            end;
    end;
  end;

procedure TArrowIndicator.SetDirection (ADir : TArrowDirection);
begin
  if FDir<>ADir then begin
    FDir:=ADir;
    ComputePoints;
    Invalidate;
    end;
  end;

procedure TArrowIndicator.Paint;
begin
  if (w<>Width) or (h<>Height) then begin
    ComputePoints;
    w:=Width; h:=Height;
    end;
  with Canvas do begin
    Brush.Style:=bsSolid;
    if Enabled then begin
      if FIndicate then  Brush.Color:=FColorOn
      else Brush.Color:=FColorOff;
      end
    else Brush.Color:=clBtnface;
    with Pen do begin
      if Enabled then Color:=clBlack else Color:=clInactiveBorder;
      Width:=1;
      end;
    Polygon(FArrow);
    end;
  end;

{ ---------------------------------------------------------------- }
procedure Register;
begin
  RegisterComponents(CompPalPage, [TSpotIndicator]);
  RegisterComponents(CompPalPage, [TLamp]);
  RegisterComponents(CompPalPage, [TLamp3D]);
  RegisterComponents(CompPalPage, [TArrowIndicator]);
end;

end.
