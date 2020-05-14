(* Delphi Unit
   XML read and write
   ==================
   
   © Dr. J. Rathlev, D-24222 Schwentinental (kontakt(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Vers. 1 - Feb. 2012
   last modified January 2020
   *)

unit XMLUtils;

interface

uses SysUtils, Xml.XMLIntf, Xml.XMLDoc;

function XMLReadNode (Node : IXMLNode; Ident : string) : IXMLNode;
function XMLReadString (Node : IXMLNode; Ident : string; Default : string) : string;
function XMLReadChildString (Node : IXMLNode; Index : integer; Default : string) : string;
function XMLReadInteger (Node : IXMLNode; Ident : string; Default : integer) : integer;
function XMLReadBool (Node : IXMLNode; Ident : string; Default : boolean) : boolean;
function XMLReadFloat (Node : IXMLNode; Ident : string; Default : extended) : extended;
function XMLReadDateTime (Node : IXMLNode; Ident : string; Default : TDateTime) : TDateTime;
function XMLReadDate (Node : IXMLNode; Ident : string; Default : TDateTime) : TDateTime;
function XMLReadTime(Node : IXMLNode; Ident : string; Default : TDateTime) : TDateTime;

function XMLNewNode (Node : IXMLNode; Ident : string) : IXMLNode;
procedure XMLWriteVariant (Node : IXMLNode; Ident : string; Value : OleVariant);

implementation

function XMLReadNode (Node : IXMLNode; Ident : string) : IXMLNode;
var
  n : integer;
begin
  with node.ChildNodes do begin
    n:=IndexOf(Ident);
    if (n>=0) then Result:=Nodes[n] else Result:=nil;
    end;
  end;

function XMLReadString (Node : IXMLNode; Ident : string; Default : string) : string;
var
  n : integer;
begin
  with Node.ChildNodes do begin
    n:=IndexOf(Ident);
    if (n>=0) then Result:=Nodes[n].Text
    else Result:=Default;
    end;
  end;

function XMLReadChildString (Node : IXMLNode; Index : integer; Default : string) : string;
begin
  with Node,ChildNodes do if (Index>=0) and (Index<Count) then Result:=Nodes[Index].Text
  else Result:=Default;
  end;

function XMLReadBool (Node : IXMLNode; Ident : string; Default : boolean) : boolean;
var
  s : string;
begin
  s:=XMLReadString(Node,Ident,BoolToStr(Default));
  if not TryStrToBool(s,Result) then Result:=Default;
  end;

function XMLReadInteger (Node : IXMLNode; Ident : string; Default : integer) : integer;
var
  s : string;
begin
  s:=XMLReadString(node,Ident,'');
  if (length(s)=0) or not TryStrToInt(s,Result) then Result:=Default;
  end;

function XMLReadFloat (Node : IXMLNode; Ident : string; Default : extended) : extended;
var
  s : string;
begin
  s:=XMLReadString(node,Ident,'');
  if (length(s)=0) or not TryStrToFloat(s,Result) then Result:=Default;
  end;

function XMLReadDateTime (Node : IXMLNode; Ident : string; Default : TDateTime) : TDateTime;
var
  s : string;
begin
  s:=XMLReadString(Node,Ident,'');
  if (length(s)=0) or not TryStrToDateTime(s,Result) then Result:=Default;
  end;

function XMLReadDate (Node : IXMLNode; Ident : string; Default : TDateTime) : TDateTime;
var
  s : string;
begin
  s:=XMLReadString(Node,Ident,'');
  if (length(s)=0) or not TryStrToDate(s,Result) then Result:=Default;
  end;

function XMLReadTime(Node : IXMLNode; Ident : string; Default : TDateTime) : TDateTime;
var
  s : string;
begin
  s:=XMLReadString(Node,Ident,'');
  if (length(s)=0) or not TryStrToTime(s,Result) then Result:=Default;
  end;

function XMLNewNode (Node : IXMLNode; Ident : string) : IXMLNode;
begin
  Result:=Node.AddChild(Ident);
  end;

procedure XMLWriteVariant (Node : IXMLNode; Ident : string; Value : OleVariant);
begin
  Node.AddChild(Ident).NodeValue:=Value;
  end;

end.
