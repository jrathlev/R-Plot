(* Grafik als EPS abspeichern
   Komprimierung mit LZW

   © Dr. J. Rathlev, D-24222 Schwentinental (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   siehe auch: Lipp, Grafikformate
   Vers. 1 - Jan. 2006
   *)

unit Eps;

interface

uses Winapi.Windows, System.Classes, System.SysUtils, Vcl.Graphics;

const
  EpsExt = '.eps';

  emNone     = 0;
  emColor    = 1;
  emInvert   = 2;
  emCompress = 4;
  emSwap     = 8;

type
  TRotate = (trNone,trLeft,trTurn,trRight);

{- Write EPS image ---------------------------------------------------}
  TEpsGraphic = class (TObject)
  private
    FColor,
    FCompress,
    FSwap,
    FInvert      : boolean;
    FRotate      : TRotate;
    FCreator,
    FImgName     : string;
    procedure Rotate (var bm : TBitmap);
  public
    constructor Create (AMode : integer; ARot : TRotate);
    function Output (var fEps : TextFile; var Bitmap : TBitmap) : boolean;
    function WriteToFile (Filename : string; var Bitmap : TBitmap) : boolean;
    property Creator : string read FCreator write FCreator;
    property ImageName : string read FImgName write FImgName;
    end;

{- LZW-Compression ------------------------------------------------------------}
const
  MaxBits        = 12;               // max. number of code bits
  MaxTableSize   = 2 shl MaxBits +1; // max. table size

  ClearCode      = 256;              // code to clear table
  EofCode        = 257;              // marks end of compressed data
  FirstFreeCode  = 258;              // first free code

type
  TTableEntry = record
    first,next : smallint;
    zCh        : byte;
    end;

  TStatus = (tsFound,tsNextUse,tsFirstUse,tsEnd);

  TLzwCompress = class (TMemoryStream)
  private
    freeCode           : word;
    nBits,maxCode,
    bitsOut            : integer;
    OutBuf             : cardinal;
    Table              : array[0..MaxTableSize] of TTableEntry;
    procedure InitCodeTable;
    procedure WriteCode (code : smallint);
    procedure AddCode (status: TStatus; ch,index : smallint);
    function LookupCode (index,ch : smallint; var where : smallint) : TStatus;
  public
    constructor Create;
    function LzwCompress (sSrc : TStream) : boolean;
    end;

implementation

uses NumberUtils;

{- LZW-Compression ------------------------------------------------------------}
// The algorithm is based on a pascal program by Rahul Dhesi (1986/12/31) which uses
// ideas from Tom Pfau and Tom Cattrall
// The lookup table is organized as a chain of codes. A hash algorithm would
// do a faster job but modern computers are fast enough even for large files

constructor TLzwCompress.Create;
begin
  inherited Create;
  iniTcodeTable;
  bitsOut:=0;
  OutBuf:=0;
  end;

procedure TLzwCompress.InitCodeTable;
var
  i : integer;
begin
  nbits:=9;
  maxCode:=1 shl nBits;
  for i:=0 to MaxTableSize do with Table[i] do begin
    zCh:=0; first:=-1; next:=-1;
    end;
  FreeCode:=firstFreeCode;
  end;

procedure TLzwCompress.WriteCode (code : smallint);
var
  cd : cardinal;
begin
  cd:=code;
  inc(bitsOut,nbits);                //total number of bits to write
  OutBuf:=OutBuf or (cd shl (32-bitsOut));
  while (bitsOut>=8) do begin
    Write(TLongWord(OutBuf).HiH,1);  // write leftmost byte
    OutBuf:=OutBuf shl 8;
    dec(bitsOut,8);
    end;
  end;

procedure TLzwCompress.AddCode (status: TStatus; ch,index : smallint);
var
  t : smallint;
begin
  if FreeCode>=MaxTableSize then t:=-1 else t:=FreeCode;
  if (status=tsNextUse) then table[index].next:=t
  else table[index].first:=t;   // firstUse
  if (FreeCode<MaxTableSize) then with Table[FreeCode] do begin
    first:=-1;
    next:=-1;
    zCh:=ch and $FF;
    inc(FreeCode);
    end;
  end;

function TLzwCompress.LookupCode (index,ch   : smallint;
                                  var where : smallint) : TStatus;
(* index     where to start looking *)
(* ch        char to look for *)
(* where     last entry looked at *)
var
  t  : TStatus;
begin
  where:=index;
  index:=Table[index].first;
  t:=tsFirstUse;
  if (index<>-1) then begin
    while t=tsFirstUse do begin
      if table[index].zCh = (ch  and $FF) then begin
        where:=index;
        t:= tsFound;
        end
      else begin
        where:=index;
        index:=table[index].next;
        if (index=-1) then t:= tsNextUse;
        end;
      end;
    end;
  LookupCode:= t;
  end;

function TLzwCompress.LzwCompress (sSrc : TStream) : boolean;
var
  prefixCode,
  nextCh,k,where  : smallint;
  status          : TStatus;
  rp              : cardinal;

  function RdCh (ss : TStream; var ch : smallint) : boolean;
  var
    b : byte;
  begin
    Result:=ss.Read(b,1)>0;
    if Result then ch:=b;
    end;

begin
  Result:=true;
  WriteCode(ClearCode);
  if RdCh(sSrc,nextCh) then begin
    //compression loop begins here with nextCh holding the next input char
    repeat
      rp:=sSrc.Position;
      repeat
        prefixCode:=nextCh;
        if RdCh(sSrc,nextCh) then begin
          k:=nextCh;
          status:=LookupCode (prefixCode, nextCh, where);
          if (status=tsFound) then nextCh:=where;           // found in table
          end
        else begin   // file end
          WriteCode (prefixCode);
          status:=tsEnd;
          end;
        until status <> tsFound;
      if status<>tsEnd then begin
        // status:=firstUse or nextUse, add to table
        AddCode (status, nextCh, where);
        if (FreeCode>=MaxCode) then begin
          if (nbits>=MaxBits) then begin
            // start with new table
            WriteCode (ClearCode);
            InitCodeTable;
            sSrc.Position:=rp-1;
            RdCh(sSrc,k);
            end
          else begin
            // increment bits
            WriteCode (prefixCode);
            inc(nbits);
            maxCode:=maxCode shl 1;
            end;
          end
        else WriteCode (prefixCode);
        nextCh:=k;
        end;
      until status=tsEnd;
    end;
  WriteCode (EofCode);
  nBits:=9;
  WriteCode (0);
  end;

{- ASCII85 -------------------------------------------------------------}
type
  TAscii85Buffer = array [0..3]of byte;

function ValueToAscii85 (const Value : TAscii85Buffer; Len : cardinal) : string;
var
  i   : integer;
  n   : cardinal;
  s   : string;
begin
  with TLongWord(n) do begin
    HiH:=Value[0]; HiL:=Value[1];
    LoH:=Value[2]; LoL:=Value[3];
    end;
  if (n=0) and (Len>=4) then Result:='z'
  else begin
    s:='';
    for i:=0 to 4 do begin
      s:=chr(n mod 85 +33)+s;
      n:=n div 85;
      end;
    if Len<4 then Result:=copy(s,1,Len+1)
    else Result:=s;;
    end;
  end;

function Asci85ToValue (A85Str : string) : TAscii85Buffer;
var
  i : integer;
  n : cardinal;
begin
  n:=0;
  while length(A85Str)<5 do A85Str:=A85Str+#33;
  for i:=1 to 5 do n:=85*n+ord(A85Str[i])-33;
  with TLongWord(n) do begin
    Result[0]:=HiH; Result[1]:=HiL;
    Result[2]:=LoH; Result[3]:=LoL;
    end;
  end;

{- Write EPS image ---------------------------------------------------}
const
  // EPS-Header
  psBCm = '%!PS-Adobe-3.0 EPSF-3.0';
  psBbx = '%%%%BoundingBox: 0 0 %u %u';
  psTit = '%%%%Title: %s';
  psDte = '%%%%CreationDate: %s';
  psCre = '%%Creator: ';
  psCop = '%%Copyright: Copyright (C) 2012-2020 - J. Rathlev, D-24222 Schwentinental';
  psDat = '%%DocumentData: Clean7Bit';
  psLev = '%%%%LanguageLevel: %s';
  psPgs = '%%Pages: 1';
  psECm = '%%EndComments';
  psBPl = '%%BeginProlog';
  psPSu = '200 dict begin'#13'currentdict /pgsave save put';
  psStream = '/imgstream currentfile /ASCII85Decode filter def';
  psCStream = '/imgstream currentfile /ASCII85Decode filter /LZWDecode filter def';
  psSize   = '/IWidth %u def /IHeight %u def /IBits %u def';
  psScale  = '/IScale {%u %u scale} def';
  psMatrix = '/ImgMatrix{[IWidth 0 0 IHeight 0 0]}bind def';
  psGImg    = '/BeginImg{IScale IWidth IHeight IBits ImgMatrix imgstream image} bind def';
  psCImg    = '/BeginImg{IScale IWidth IHeight IBits ImgMatrix imgstream false 3 colorimage} bind def';
  psEPl = '%%EndProlog';

  psData   = 'BeginImg';

  psRst = 'showpage currentdict /pgsave get restore end';

  PixelBits : array [pf1bit..pf32bit] of byte = (1,4,8,15,16,24,32);

type
  TPixels = array [0..2] of byte;

(* Create Eps-Object *)
constructor TEpsGraphic.Create (AMode : integer; ARot : TRotate);
begin
  inherited Create;
  FColor:=AMode and emColor <>0;
  FCompress:=AMode and emCompress <>0;
  FInvert:=AMode and emInvert <>0;
  FSwap:=AMode and emSwap <>0;
  FRotate:=ARot;
  FImgName:=''; FCreator:='EpsGraphic by J. Rathlev';
  end;

{ ------------------------------------------------------------------- }
type
  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..1] of TRGBTriple;
const
  BitMask : array [0..7] of byte = ($80,$40,$20,$10,$8,$4,$2,$1);

procedure TEpsGraphic.Rotate (var bm : TBitmap);
var
  tbm   : TBitmap;
  i,j,b : integer;
  P,Q   : PByteArray;
begin
  if FRotate<>trNone then begin
    case bm.PixelFormat of
    pf1bit  : b:=0;
    pf8Bit  : b:=1;
    pf24Bit : b:=3;
    else b:=-1;
      end;
    if b<0 then Exit;
    tbm:=TBitmap.Create;
    with tbm do begin
      PixelFormat:=bm.PixelFormat;
      Palette:=bm.Palette;
      if FRotate=trTurn then begin
        Width:=bm.Width; Height:=bm.Height;
        end
      else begin
        Width:=bm.Height; Height:=bm.Width;
        end;
      end;
    if b=0 then begin     // 1 bit
      with tbm do begin
        for j:=0 to Height-1 do begin  // clear image
          P:=ScanLine[j];
          FillChar(P[0],(Width-1) div 8 +1,0);
          end;
        end;
      case FRotate of
      trLeft : with bm do begin
          for j:=0 to Height-1 do begin
            P:=ScanLine[Height-j-1];
            for i:=0 to Width-1 do begin
              Q:=tbm.Scanline[i];
              if (P[i div 8] and BitMask[i mod 8])>0 then
                Q[j div 8]:=Q[j div 8] or BitMask[j mod 8];
              end;
            end;
          end;
      trRight : with bm do begin
          for j:=0 to Height-1 do begin
            P:=ScanLine[j];
            for i:=0 to Width-1 do begin
              Q:=tbm.Scanline[Width-i-1];
              if (P[i div 8] and BitMask[i mod 8])>0 then
                Q[j div 8]:=Q[j div 8] or BitMask[j mod 8];
              end;
            end;
          end;
      trTurn : with bm do begin
          for j:=0 to Height-1 do begin
            P:=ScanLine[j];
            Q:=tbm.Scanline[Height-j-1];
            for i:=0 to Width-1 do begin
              if (P[i div 8] and BitMask[i mod 8])>0 then
                Q[(Width-i-1) div 8]:=Q[(Width-i-1) div 8] or BitMask[(Width-i-1) mod 8];
              end;
            end;
          end;
        end;
      end
    else begin    // 8 or 24 bit
      case FRotate of
      trLeft : with bm do begin
          for j:=0 to Height-1 do begin
            P:=ScanLine[Height-j-1];
            for i:=0 to Width-1 do begin
              Q:=tbm.Scanline[i];
              move(P[b*i],Q[b*j],b);
              end;
            end;
          end;
      trRight : with bm do begin
          for j:=0 to Height-1 do begin
            P:=ScanLine[j];
            for i:=0 to Width-1 do begin
              Q:=tbm.Scanline[Width-i-1];
              move(P[b*i],Q[b*j],b);
              end;
            end;
          end;
      trTurn: with bm do begin
          for j:=0 to Height-1 do begin
            P:=ScanLine[j];
            Q:=tbm.Scanline[Height-j-1];
            for i:=0 to Width-1 do begin
              move(P[b*i],Q[b*(Width-i-1)],b);
              end;
            end;
          end;
        end;
      end;
    bm.Free;
    bm:=tbm;
    end;
  end;

{ ------------------------------------------------------------------- }
function TEpsGraphic.WriteToFile (Filename     : string;
                                  var Bitmap : TBitmap) : boolean;
var
  fEps      : TextFile;
begin
  AssignFile(fEps,Filename); rewrite(fEps);
  if length(FImgName)=0 then FImgName:=Filename;
  Result:=Output (fEps,Bitmap);
  CloseFile(fEps);
  end;

function TEpsGraphic.Output (var fEps : TextFile; var Bitmap : TBitmap) : boolean;
// Swap = true: swap up-down
var
  Wd,Hg,Bt,
  i,j,jj,
  k,nc      : integer;
  n,np      : cardinal;
  v         : TAscii85Buffer;
  s         : string;
  P         : PByteArray;
  px        : TPixels;
  sLzw      : TLzwCompress;
  sImg      : TMemoryStream;
  pal       : array [0..255] of TPaletteEntry;
  bi        : boolean;

  procedure WriteColToGray (const Px : TPixels);
  var
    k,n : word;
  begin
    n:=0;
    for k:=0 to 2 do n:=n+px[k];
    n:=n div 3;
    if FInvert then n:=255-n;
    sImg.Write(n,1)
    end;

begin
  Result:=false;
  with Bitmap do begin
    if (PixelFormat<>pf1bit) and (PixelFormat<>pf8bit)
        and (PixelFormat<>pf24bit) then Exit; // not supported
    Rotate (Bitmap);
    Wd:=Width; Hg:=Height; Bt:=8;
    sImg:=TMemoryStream.Create;
    if PixelFormat=pf1bit then begin
      Bt:=1; FColor:=false; nc:=0;
      // Check the two palette entries for values
      GetPaletteEntries(Palette,0,1,pal);
      with pal[0] do j:=peRed+peGreen+peBlue;
      with pal[1] do j:=j-peRed-peGreen-peBlue;
      bi:=j>0;  // invert color
      end
    else if PixelFormat=pf24bit then nc:=3
    else nc:=1;
    if nc=1 then np:=GetPaletteEntries(Palette,0,256,pal);
    for j:=Height-1 downto 0 do begin
      if FSwap then jj:=Height-1-j else jj:=j;
      P:=ScanLine[jj];
      if nc=0 then begin
        n:=0; k:=0;
        for i:=0 to Width-1 do begin  // 1 bit
          if k=8 then begin
            if FInvert xor bi then n:=255-n;
            sImg.Write(n,1); k:=0;
            end;
          n:=n shl 1; inc(k);
          if (P[i div 8] and BitMask[i mod 8])>0 then n:=n or 1;
          end;
        for i:=k to 7 do n:=n shl 1;
        if FInvert xor bi then n:=255-n;
        sImg.Write(n,1);
        end
      else for i:=0 to Width-1 do begin
        if nc=1 then begin  // 8 bit
          k:=P[i];
          if k<np then move(pal[k],px[0],3)
          else fillchar(px[0],3,0);
          if FColor then sImg.Write(px[0],3)
          else WriteColToGray(px);
          end
        else begin
          for k:=0 to nc-1 do px[nc-k-1]:=P[nc*i+k];
          if FColor then sImg.Write(px[0],3)
          else WriteColToGray(px);
          end;
        end;
      end;
    end;
  sImg.Seek(0,soFromBeginning);
  if FCompress then  begin
    sLzw:=TLzwCompress.Create;
    with sLzw do begin
      LzwCompress (sImg);
      Seek(0,soFromBeginning);
      end;
    sImg.Free;
    sImg:=sLzw;
    end;
  WriteLn (fEps,psBCm);      // Comments
  WriteLn (fEps,Format(psBbx,[Wd-1,Hg-1]));
  if length(FImgName)>0 then WriteLn (fEps,Format(psTit,[ExtractFileName(FImgName)]));
  WriteLn (fEps,Format(psDte,[FormatDateTime('yyyy-mm-dd hh:nn',Now)]));
  WriteLn (fEps,psCre+FCreator);
  WriteLn (fEps,psCop);
  WriteLn (fEps,psDat);
  WriteLn (fEps,Format(psLev,['2']));
  WriteLn (fEps,psECm);
  WriteLn (fEps,psBPl);
  WriteLn (fEps,psPSu);
  if FCompress then WriteLn (fEps,psCStream)
  else WriteLn (fEps,psStream);
  WriteLn (fEps,Format(psSize,[Wd,Hg,Bt]));
  WriteLn (fEps,Format(psScale,[Wd,Hg]));
  WriteLn (fEps,psMatrix);
  if FColor then WriteLn (fEps,psCImg)
  else WriteLn (fEps,psGImg);
  WriteLn (fEps,psEPl);      // End Prolog
  WriteLn (fEps,psData);
  n:=sImg.Size; i:=0;
  repeat
    j:=sImg.Read(v,4);
    s:=ValueToAscii85(v,j);
    Write (fEps,s);
    dec(n,j);
    inc(i,length(s));
    if i>79 then begin
      WriteLn (fEps);
      i:=0;
      end;
    until n=0;
  WriteLn (fEps,'~>');
  WriteLn (fEps,psRst);
  sImg.Free;
  Result:=true;
  end;

end.
