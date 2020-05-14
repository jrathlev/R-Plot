(* Read and write standard types from / to stream

   © Dr. J. Rathlev, D-24222 Schwentinental (info(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Vers. 1 - Jan. 2006
   Vers. 2 - Jun. 2012
   *)

unit ExtStreams;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils;

const
  defBufferSize = 64*1024;

  UcBom = $FEFF;      //UniCode-Signatur (Low Endian)
  Utf8Bom = $BFBBEF;  // UTF-8-Signature

type
  TWord = record
    case integer of
    0 : (Both : word);
    1 : (Lo,Hi : byte);
    2 : (Bytes : array [0..1] of Byte);
    end;

  TLongWord = record
    case integer of
    0 : (LongWord : cardinal);
    1 : (Lo,Hi : word);
    2 : (LoL,LoH,HiL,HiH : byte);
    3 : (Bytes : array [0..3] of Byte);
    end;

  TInt64 = record
    case integer of
    0: (AsInt64 : int64);
    1: (Lo,Hi   : Cardinal);
    2: (Cardinals : array [0..1] of Cardinal);
    3: (Words : array [0..3] of Word);
    4: (Bytes : array [0..7] of Byte);
    end;

  TTextFormat = (tfAnsi,tfUnicode,tfUtf8);

  // extended file stream functions: read/write several data types
  TExtFileStream = class (TFileStream)
  private
  protected
    FBufPos    : integer;
    FBufSize   : cardinal;
    FBuffer    : array of byte;
    procedure SetPosition (APosition : int64);
  public
    constructor Create (const FileName: string; Mode: Word; ABufSize : integer);
    destructor Destroy; override;
    property NewPosition : int64 write SetPosition;
    end;

  TReadFileStream = class (TExtFileStream)
  private
    FBufRead   : cardinal;
    FDelim     : word;
    function GetEof : boolean;
    function GetDelim : char;
  public
    constructor Create (const FileName : string; Share : Word = 0;
                        ABufSize : integer = defBufferSize);
    procedure Reset; virtual;
    function ReadByte : byte;
    function ReadChar : char;
    function ReadWord : word;
    function ReadInteger : integer;
    function ReadInt64 : int64;
    procedure ReadRecord (var Buffer; Count : cardinal);
    function ReadAnsiString : string;
    function ReadWideString : string;
    property Eof : boolean read GetEof;
    property Delimiter : char read GetDelim;
    end;

  TReadTextFile = class (TReadFileStream)
  private
    FHasBom,
    FIsUnicode  : boolean;
    FTxtFmt     : TTextFormat;
    procedure SetFormat (Value : TTextFormat);
  public
    constructor Create (const FileName : string; Share : Word = 0;
                        ABufSize : integer = defBufferSize);
    procedure Reset; override;
    function ReadString : string;
    property TextFormat : TTextFormat read FTxtFmt write SetFormat;
    end;

  TWriteFileStream = class (TExtFileStream)
  public
    constructor Create (const FileName : string; Share : Word = 0;
                        ABufSize : integer = defBufferSize);
    constructor Append (const FileName : string; Share : Word = 0; ABufSize : integer = defBufferSize);
    destructor Destroy; override;
    procedure Reset;
    procedure Flush;
    procedure WriteByte (Value : byte);
    procedure WriteChar (Value : Char);
    procedure WriteWord (Value : word);
    procedure WriteInteger (Value : integer);
    procedure WriteInt64 (Value : int64);
    procedure WriteRecord (const Buffer; Count : cardinal);
    procedure WriteAnsiString (s : AnsiString);
    procedure WriteAnsiStringLine (s : AnsiString);
    procedure WriteUtf8String (s : string);
    procedure WriteUtf8StringLine (s : string);
    procedure WriteWideString (s : string);
    procedure WriteWideStringLine (s : string);
    procedure WriteNewline;
    end;

implementation

{ TExtFileStream ------------------------------------------------------------------- }
constructor TExtFileStream.Create (const FileName: string; Mode: Word; ABufSize : integer);
begin
  inherited Create (Filename,Mode);
  FBufSize:=ABufSize;
  SetLength(FBuffer,FBufSize);
  FBufPos:=-1;
  end;

destructor TExtFileStream.Destroy;
begin
  FBuffer:=nil;
  inherited Destroy;
  end;

procedure TExtFileStream.SetPosition (APosition : int64);
begin
  Position:=APosition;
  FBufPos:=-1;
  end;

{ TReadFileStream ------------------------------------------------------------------- }
constructor TReadFileStream.Create (const FileName : string; Share : Word; ABufSize : integer);
begin
  inherited Create (Filename,fmOpenRead	or Share,ABufSize);
  FBufRead:=FBufSize; FDelim:=0;
  end;

procedure TReadFileStream.Reset;
begin
  SetPosition(0);
  FBufRead:=FBufSize; FDelim:=0;
  end;

function TReadFileStream.GetEof : boolean;
begin
  Result:=(FBufRead<FBufSize) and (FBufPos=FBufRead); //Position>Size;
  end;

function TReadFileStream.ReadByte : byte;
begin
  if (FBufPos<0) then begin
    FBufRead:=Read(FBuffer[0],FBufSize); FBufPos:=0;
    end;
  if (FBufPos<FBufRead) then begin
    Result:=FBuffer[FBufPos];
    inc(FBufPos);
    if (FBufPos>=FBufRead) and (FBufRead=FBufSize) then FBufPos:=-1;
    end
  else Result:=0;
  end;

function TReadFileStream.ReadChar : char;
begin
  Result:=chr(ReadByte);
  end;

function TReadFileStream.ReadWord : word;
begin
  with TWord(Result) do begin
    Lo:=ReadByte; Hi:=ReadByte;
    end;
  end;

function TReadFileStream.ReadInteger : integer;
var
  i : integer;
begin
  for i:=0 to sizeof(TLongWord)-1 do TLongWord(Result).Bytes[i]:=ReadByte;
  end;

function TReadFileStream.ReadInt64 : int64;
var
  i : integer;
begin
  for i:=0 to sizeof(TInt64)-1 do TInt64(Result).Bytes[i]:=ReadByte;
  end;

procedure TReadFileStream.ReadRecord (var Buffer; Count : cardinal);
var
  i : integer;
begin
  for i:=0 to Count-1 do TByteArray(Buffer)[i]:=ReadByte;
  end;

const
  TAB = 9;
  LF = 10;
  CR = 13;
  FF = 12;
  SP = 32;

function TReadFileStream.ReadAnsiString : string;
var
  s    : AnsiString;
  b    : byte;
  ende : boolean;
begin
  s:='';
  repeat
    ende:=Eof;
    if ende then b:=0
    else begin
      repeat
        b:=ReadByte;      // read bytewise
        until not ((b=LF) and (FDelim=CR));
      FDelim:=0;
      ende:=(b=CR) or (b=LF) or (b=FF) or (b=0);
      if not ende and ((b=TAB) or (b>=SP)) then s:=s+chr(b);
      end
    until ende;
  FDelim:=b;
  Result:=s;
  end;

function TReadFileStream.ReadWideString : string;
var
  s    : string;
  w    : word;
  ende : boolean;
begin
  s:='';
  repeat
    ende:=Eof;
    if ende then w:=0
    else begin
      repeat
        w:=ReadWord;      // read wordwise
        until not ((w=LF) and (FDelim=CR));
      FDelim:=0;
      ende:=(w=CR) or (w=LF) or (w=FF) or (w=0);
      if not ende and ((w=TAB) or (w>=SP)) then s:=s+chr(w);
      end
    until ende;
  FDelim:=w;
  Result:=s;
  end;

function TReadFileStream.GetDelim : char;
begin
  Result:=chr(FDelim);
  end;

{ TReadTextFile ------------------------------------------------------------------- }
constructor TReadTextFile.Create (const FileName : string; Share : Word = 0;
                    ABufSize : integer = defBufferSize);
var
  uid     : TLongWord;
begin
  inherited Create (Filename,Share,ABufSize);
  FHasBom:=false; FIsUnicode:=false; FTxtFmt:=tfAnsi;
  Read(uid.LongWord,4);  // prüfe, ob Unicode oder UTF-8
  with uid do if Lo=UcBom then FTxtFmt:=tfUnicode
  else begin
    HiH:=0;
    if LongWord=Utf8Bom then FTxtFmt:=tfUtf8
    else FTxtFmt:=tfAnsi;
    end;
  FHasBom:=FTxtFmt<>tfAnsi;
  FIsUnicode:=FTxtFmt=tfUnicode;
  Reset;
  end;

procedure TReadTextFile.Reset;
var
  n : int64;
begin
  if FHasBom then begin
    if FIsUnicode then n:=2 else n:=3;
    end
  else n:=0;
  SetPosition(n);
  FBufRead:=FBufSize; FDelim:=0;
  end;

procedure TReadTextFile.SetFormat (Value : TTextFormat);
begin
  FTxtFmt:=Value;
  FIsUnicode:=FTxtFmt=tfUnicode;
  end;

function TReadTextFile.ReadString : string;
begin
  if FIsUnicode then Result:=ReadWideString
  else begin
    Result:=ReadAnsiString;
    if FTxtFmt=tfUtf8 then Result:=Utf8Decode(Result);
    end;
  end;

{ TWriteFileStream ------------------------------------------------------------------- }
constructor TWriteFileStream.Create (const FileName : string; Share : Word; ABufSize : integer);
begin
  inherited Create (Filename,fmCreate or Share,ABufSize);
  end;

constructor TWriteFileStream.Append (const FileName : string; Share : Word; ABufSize : integer);
begin
  inherited Create (Filename,fmOpenReadWrite or Share,ABufSize);
  Position:=Size;
  end;

destructor TWriteFileStream.Destroy;
begin
  Flush;
  inherited Destroy;
  end;

procedure TWriteFileStream.Reset;
begin
  SetPosition(0);
  end;

procedure TWriteFileStream.Flush;
begin
  if FBufPos>=0 then Write (FBuffer[0],FBufPos+1);
  FBufPos:=-1;
  FlushFileBuffers(Handle);
  end;

procedure TWriteFileStream.WriteByte (Value : byte);
begin
  if FBufPos=FBufSize-1 then begin
    Write (FBuffer[0],FBufSize);
    FBufPos:=-1;
    end;
  inc(FBufPos); FBuffer[FBufPos]:=Value;
  end;

procedure TWriteFileStream.WriteChar (Value : Char);
begin
  WriteByte(ord(Value));
  end;

procedure TWriteFileStream.WriteWord (Value : word);
begin
  with TWord(Value) do begin
    WriteByte(Lo); WriteByte(Hi);
    end;
  end;

procedure TWriteFileStream.WriteInteger (Value : integer);
var
  i : integer;
begin
  for i:=0 to sizeof(TLongWord)-1 do WriteByte(TLongWord(Value).Bytes[i]);
  end;

procedure TWriteFileStream.WriteInt64 (Value : int64);
var
  i : integer;
begin
  for i:=0 to sizeof(TInt64)-1 do WriteByte(TInt64(Value).Bytes[i]);
  end;

procedure TWriteFileStream.WriteRecord (const Buffer; Count : cardinal);
var
  i : integer;
begin
  for i:=0 to Count-1 do WriteByte(TByteArray(Buffer)[i]);
  end;

procedure TWriteFileStream.WriteAnsiString (s : AnsiString);
var
  i   : integer;
begin
  for i:=1 to length(s) do WriteByte (ord(s[i]));
  end;

procedure TWriteFileStream.WriteAnsiStringLine (s : AnsiString);
begin
  WriteAnsiString(s); WriteByte(CR); WriteByte(LF);
  end;

procedure TWriteFileStream.WriteUtf8String (s : string);
var
  i  : integer;
  su : Utf8String;
begin
  su:=Utf8Encode(s);
  for i:=1 to length(su) do WriteByte (ord(su[i]));
  end;

procedure TWriteFileStream.WriteUtf8StringLine (s : string);
begin
  WriteUtf8String(s); WriteByte(CR); WriteByte(LF);
  end;

procedure TWriteFileStream.WriteWideString (s : string);
var
  i   : integer;
begin
  for i:=1 to length(s) do WriteWord (ord(s[i]));
  end;

procedure TWriteFileStream.WriteWideStringLine (s : string);
begin
  WriteWideString(s); WriteWord(CR); WriteWord(LF);
  end;

procedure TWriteFileStream.WriteNewline;
begin
  WriteByte(CR); WriteByte(LF);
  end;

end.
