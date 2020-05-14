(* TIFF-Daten lesen und schreiben
   Lesen:     8-bit und 16-bit Graustufen
   Schreiben: 16-bit Graustufen
   Fehlercodes beim Einlesen von Tiff:
               rtNotFound : Datei nicht gefunden
               rtFormat :   nicht unterstütztes Format

   © Dr. J. Rathlev, D-24222 Schwentinental (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   siehe auch: Lipp, Grafikformate
   Vers. 1 - Jul. 2001 
   *)

unit Tiff;

interface

uses System.SysUtils, System.Classes;

const

  (* Datentypen *)
  dtByte = 1;
  dtASCII = 2;
  dtShort = 3;
  dtLong = 4;
  dtRational = 5;
  dtSByte = 6;
  dtUndefined = 7;
  dtSShort = 8;
  dtSLong = 9;
  dtSRational = 10;
  dtFloat = 11;
  dtDouble = 12;

  RowsPerStrip = 8;

type
  (* Rückgabe-Fehlercodes beim Einlesen von Tiff *)
  TTiffError = (rtOK,rtNotFound,rtFormat);

  TPixData = array [0..99] of word;
  TBinData = class (TObject)
  private
    Pixels       : array of array of word;
  public
    ZMin,ZMax,
    Width,Height : word;
    DLine        : array of word;
    constructor Create (AWidth,AHeight : word);
    constructor Copy (const Source : TBinData);
    destructor Destroy; override;
    function GetPixel (x,y : word) : word;
    procedure SetPixel (x,y,val : word);
    function GetScanLine (y : word) : PWordArray;
    property ScanLine[Row : word] : PWordArray read GetScanLine;
    property BinPixel[x,y : word] : word read GetPixel write SetPixel;
    end;

  TTiffHeader = record
    ByteOrder,
    Identifier : word;
    IFDOffset  : longint;
    end;

  TIFDField = record
    Tag,
    DataType  : word;
    DataCount,
    DataValue : cardinal;
    end;

  TIFDList = array [1..10] of TIFDField;

  TIFDStructure = record
    FieldCount : word;
    FieldPtr   : ^TIFDList;
    NextIFD    : cardinal;
    end;

  TPtrList = array [0..10] of cardinal;

const
  ttImageWidth = 256;
  ttImageLength = 257;
  ttBitsPerSample = 258;
  ttCompression = 259;
  ttPhotometric = 262;
  ttStripOffsets = 273;
  ttSamplePerPixel = 277;
  ttRowsPerStrip = 278;
  ttStripByteCounts = 279;
  ttXResolution = 282;
  ttYResolution = 283;
  ttResolutionUnit = 297;
  IFDBitsperSample : TIFDField = (Tag : ttBitsPerSample; DataType : dtShort;
                                  DataCount : 1; DataValue : 16);
  IFDCompression:    TIFDField = (Tag : ttCompression; DataType : dtShort;
                                  DataCount : 1; DataValue : 1);
  IFDPhotometric:    TIFDField = (Tag : ttPhotometric; DataType : dtShort;
                                  DataCount : 1; DataValue : 1);
  IFDSamplePerPixel: TIFDField = (Tag : ttSamplePerPixel; DataType : dtShort;
                                  DataCount : 1; DataValue : 1);
  IFDRowsPerStrip:   TIFDField = (Tag : ttRowsPerStrip; DataType : dtShort;
                                  DataCount : 1; DataValue : RowsPerStrip);
  IFDResolutionUnit: TIFDField = (Tag : ttResolutionUnit; DataType : dtShort;
                                  DataCount : 1; DataValue : 1);

type
  TTiffGraphic = class (TObject)
  private
    Header    : TTiffHeader;
    IFD       : TIFDSTructure;
  public
    constructor Create;
    function ReadTiff (Filename    : string;
                       var Bindata : TBindata) : TTiffError;
    procedure WriteTiff (Filename      : string;
                         const Bindata : TBindata);
    end;

implementation

uses NumberUtils;

{ ------------------------------------------------------------------- }
constructor TBinData.Create (AWidth,AHeight : word);
var
  i,j : integer;
begin
  inherited Create;
  Width:=AWidth; Height:=AHeight;
//  ZMin:=High(ZMin); ZMax:=Low(ZMax);
  ZMin:=0; ZMax:=0;
  SetLength(DLine,AWidth);
  SetLength(Pixels,AHeight,AWidth);
  for i:=0 to AHeight-1 do for j:=0 to AWidth-1 do Pixels[i,j]:=0;
  end;

constructor TBinData.Copy (const Source : TBinData);
var
  iy : integer;
begin
  inherited Create;
  Width:=Source.Width; Height:=Source.Height;
  ZMin:=Source.ZMin; ZMax:=Source.ZMax;
//  n:=2*Width*Height;
  SetLength(DLine,Width);
  SetLength(Pixels,Height,Width);
//  Move(Source.Pixels[0,0],Pixels[0,0],n);
  for iy:=0 to Height-1 do Move(Source.Pixels[iy,0],Pixels[iy,0],2*Width);
  end;

destructor TBinData.Destroy;
begin
  Pixels:=nil;
  DLine:=nil;
  inherited Destroy;
  end;

function TBinData.GetPixel (x,y : word) : word;
begin
  Result:=Pixels[y,x];
  end;

procedure TBinData.SetPixel (x,y,val : word);
begin
  Pixels[y,x]:=val;
  end;

function TBinData.GetScanLine (y : word) : PWordArray;
begin
  Result:=@Pixels[y,0];
  end;

{-----------------------------------------------------------------------}
(* TTiff-Object erzeugen *)
constructor TTiffGraphic.Create;
begin
  inherited Create;
  with Header do begin
    ByteOrder:=$4949;
    Identifier:=42;
    IFDOffset:=0;
    end;
  with IFD do begin
    FieldCount:=0;
    end;
  end;

{ ------------------------------------------------------------------- }
procedure TTiffGraphic.WriteTiff (Filename      : string;
                                  const Bindata : TBindata);
const
  Resolution : array [0..3] of cardinal =(71,1,72,1);
var
  fo         : TFileStream;
  n,m,i,j,k  : integer;
  so,sc      : ^TPtrList;
  ifdf       : TIFDField;
  w          : word;
  idpp,xrp,
  sop,scp    : cardinal;
begin
  fo:=TFileStream.Create(Filename,fmCreate);
  with fo do begin
    Write(Header,sizeof(TTiffHeader));
    with BinData do begin
      n:=Height div RowsPerStrip;
      GetMem (so,(n+1)*sizeof(cardinal));
      GetMem (sc,(n+1)*sizeof(cardinal));
      (* Daten schreiben *)
      for i:=0 to n do begin
        so^[i]:=Position;
        if i=n then m:=(Height-i*RowsPerStrip)
        else m:=RowsPerStrip;
        sc^[i]:=m*Width*sizeof(word);
        for j:=1 to m do begin
          for k:=0 to Width-1 do begin
            w:=BinPixel[k,i*RowsPerStrip+j];
            Write(w,2);
            end;
          end;
        end;
      (* Pointer für Streifen *)
      sop:=Position;
      for i:=0 to n do Write(so^[i],4);
      scp:=Position;
      for i:=0 to n do Write(sc^[i],4);
      (* X- Y-Auflösung pro inch *)
      xrp:=Position;
      Write (Resolution[0],16);
      (* IFD-Struktur *)
      idpp:=Position;
      w:=12; Write (w,2);
      with ifdf do begin
        Tag:=ttImageWidth; DataType:=dtLong;
        DataCount:=1; DataValue:=Width;
        end;
      Write (ifdf,sizeof(TIFDField));
      with ifdf do begin
        Tag:=ttImageLength; DataType:=dtLong;
        DataCount:=1; DataValue:=Height;
        end;
      Write(ifdf,sizeof(TIFDField));
      Write(IFDBitsperSample,sizeof(TIFDField));
      Write(IFDCompression,sizeof(TIFDField));
      Write(IFDPhotometric,sizeof(TIFDField));
      with ifdf do begin
        Tag:=ttStripOffsets; DataType:=dtLong;
        DataCount:=n+1; DataValue:=sop;
        end;
      Write(ifdf,sizeof(TIFDField));
      Write(IFDSamplePerPixel,sizeof(TIFDField));
      Write(IFDRowsPerStrip,sizeof(TIFDField));
      with ifdf do begin
        Tag:=ttStripByteCounts; DataType:=dtLong;
        DataCount:=n+1; DataValue:=scp;
        end;
      Write(ifdf,sizeof(TIFDField));
      with ifdf do begin
        Tag:=ttXResolution; DataType:=dtRational;
        DataCount:=1; DataValue:=xrp;
        end;
      Write(ifdf,sizeof(TIFDField));
      with ifdf do begin
        Tag:=ttYResolution; DataType:=dtRational;
        DataCount:=1; DataValue:=xrp+2*sizeof(cardinal);
        end;
      Write(ifdf,sizeof(TIFDField));
      Write(IFDResolutionUnit,sizeof(TIFDField));
      w:=0; Write (w,2); Write (w,2);
      FreeMem (so);
      FreeMem (sc);
      end;
    Seek (4,soFromBeginning); Write(idpp,4);
    Free;
    end;
  end;

{ ------------------------------------------------------------------- }
function TTiffGraphic.ReadTiff (Filename    : string;
                                var Bindata : TBindata) : TTiffError;

  function ReadWord (var fs : TFileStream;
                     BSwap  : boolean) : word;
  var
    w : word;
  begin
    fs.Read(w,2);
    if BSwap then ReadWord:=Swap(w) else ReadWord:=w;
    end;

  function ReadLongWord (var fs : TFileStream;
                         BSwap  : boolean) : longint;
  var
    w1,w2 : word;
  begin
    w1:=ReadWord(fs,BSwap);
    w2:=ReadWord(fs,BSwap);
    if BSwap then Result:=WordsToCardinal(w1,w2)
    else Result:=WordsToCardinal(w2,w1);
    end;

  function IFDValue (const IFD : TIFDStructure;
                     ATag      : integer;
                     var DCount,DValue : cardinal) : boolean;
  var
    i : integer;
  begin
    with IFD do begin
      i:=1;
      while (i<=FieldCount) and (FieldPtr^[i].Tag<>ATag) do inc(i);
      if i>FieldCount then Result:=true
      else with FieldPtr^[i] do begin
        Result:=false;
        DCount:=DataCount;
        DValue:=DataValue;
        end;
      end;
    end;

var
  fi     : TFileStream;
  Header : TTiffHeader;
  IFD    : TIFDStructure;
  Err,
  BSwap  : boolean;
  BCount,
  w      : word;
  n,m,i,j,k,r: cardinal;
  so,sc      : ^TPtrList;
  sop,scp    : cardinal;
begin
  if FileExists(Filename) then begin
    fi:=TFileStream.Create(Filename,fmOpenRead);
    fi.Read(w,2);
    BSwap:=w=$4D4D;
    with Header do begin
      ByteOrder:=w;
      Identifier:=ReadWord(fi,BSwap);
      IFDOffSet:=ReadLongWord(fi,BSwap);
      if Identifier<>42 then begin
        Result:=rtFormat; fi.Free; Exit;
        end;
      end;
    if fi.Seek(Header.IFDOffSet,soFromBeginning)=Header.IFDOffSet then begin
      with IFD do begin
        FieldCount:=ReadWord(fi,BSwap);
        GetMem (FieldPtr,FieldCount*sizeof(TIFDField));
        for i:=1 to FieldCount do with FieldPtr^[i] do begin
          Tag:=ReadWord(fi,BSwap);
          DataType:=ReadWord(fi,BSwap);
          DataCount:=ReadLongWord(fi,BSwap);
          DataValue:=ReadLongWord(fi,BSwap);
          end;
        end;
      Result:=rtFormat;
      if not IFDValue (IFD,ttBitsPerSample,n,m) then begin
        if m=16 then BCount:=2 else BCount:=1;
        if (m=8) or (m=16) then begin
          Err:=IFDValue (IFD,ttImageWidth,m,i);
          Err:=Err or IFDValue (IFD,ttCompression,m,j);
          Err:=Err or (j<>1);
          Err:=Err or IFDValue (IFD,ttImageLength,m,j);
          Err:=Err or IFDValue (IFD,ttRowsPerStrip,m,r);
          Err:=Err or IFDValue (IFD,ttStripOffsets,n,sop);
          Err:=Err or IFDValue (IFD,ttStripByteCounts,n,scp);
          if not Err then begin
            if assigned(BinData) then BinData.Free;
            BinData:=TBinData.Create (i,j);
            GetMem (so,n*sizeof(cardinal));
            GetMem (sc,n*sizeof(cardinal));
            with BinData do begin
              ZMin:=65535; ZMax:=0;
              fi.Seek(sop,soFromBeginning);
              for i:=0 to n-1 do so^[i]:=ReadLongWord(fi,BSwap);
              fi.Seek(scp,soFromBeginning);
              for i:=0 to n-1 do sc^[i]:=ReadLongWord(fi,BSwap);
              for i:=0 to n-1 do begin
                fi.Seek(so^[i],soFromBeginning);
                m:=sc^[i] div BCount div Width;
                for j:=1 to m do begin
                  for k:=0 to Width-1 do begin
                    if BCount=1 then begin
                      w:=0; fi.Read(w,1); w:=swap(w);
                      end
                    else w:=ReadWord(fi,BSwap);
                    if w<zmin then zmin:=w;
                    if w>zmax then zmax:=w;
                    BinPixel[k,i*r+j-1]:=w;
                    end;
                  end;
                end;
              if ZMin=ZMax then begin
                ZMin:=0; ZMax:=65535;
                end;
              end;
            FreeMem (so);
            FreeMem (sc);
            Result:=rtOK;
            end;
          end
        end;
      FreeMem (IFD.FieldPtr);
      end
    else Result:=rtFormat;
    fi.Free;
    end
  else Result:=rtNotFound;
  end;

end.
