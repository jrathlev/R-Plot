{ Auswertung von mathematischen Ausdrücken
  Basis : PARSER-TOOLBOX Level 1 von J. Dankert

  Angepasst an Delphi: Nov. 2005
  Resourcestrings:     Jun. 2007
  Expressions als AnsiString für Delphi2009: Jul. 2011
  Berechnung von Funktionswerten einer Variable: Mai 2012
  letzte Änderung: April 2022

  J. Rathlev (kontakt(a)rathlev-home.de)

  function Calculate
  ------------------
    berechnet aus einem arithmetischen Ausdruck, der
    als String eingegeben wird, einen Zahlenwert (double)

  function CalcFunction
  ---------------------
    berechnet aus einem arithmetischen Ausdruck, der als String eingegeben wird,
    zu einer Variable X den Funktionswert Y (double) (s.o. "Calculate).
    Zusätzlich können frei definierbare Konstanten übergeben werden

  function CalcErrorCode
  function CalcErrorPos
  function CalcErrorLength
  ------------------------
    gibt den Fehlercode und Anfangsposition und Länge
    des String-Bereichs zurück, in dem ein Fehler erkannt wurde.

  function CalcErrorText:
  -----------------------
    liefert einen erläuternden Text zu einem Fehlercode

  procedure CalcSetAngleUnits:
  ----------------------------
    dient zur Änderung der Voreinstellung für die Winkelfunktionsargumente

  Vordefinierte Konstanten:
  -------------------------
    Pi und e
  }

unit MathExp;

interface

const
  MathStrLen = 6;

type
  TAngularUnits = (auRad,auDegree,auGrad);
  TConstString = string[MathStrLen];

  TConstant = record
    ConstName  : TConstString;
    ConstValue : double;
    end;

  TConstArr = array of TConstant;

function Calculate (const Expr : Ansistring; var Value : double) : boolean;
function CalcFunction (const Expr : Ansistring; XValue : double; AngUni : integer;
                       const Constants : TConstArr;
                       var YValue : double) : boolean;

function CalcErrorCode : integer;
function CalcErrorPos : integer;
function CalcErrorLength : integer;
function CalcErrorText : string;

procedure CalcSetAngleUnits (Mode : TAngularUnits);
function CalcGetAngleUnits : TAngularUnits;

implementation

uses System.Math, MathExpConsts;

var
  ErrCode,ErrPos,ErrLen: integer;
  NLENHS : Integer ;  {  Laenge der Arbeitsstrings PARSTX und HLSTRX    }
  MAXSTC : Integer ;  {  Groesse des Stacks STACK (1:MAXSTC)            }
  NSTACK : Integer ;  {  Anzahl der belegten Stack-Positionen           }
  MAXCON : Integer ;  {  Maximal moegliche Zahl von Konstanten
                         (Laenge der Felder NAMCON und DPCON)           }
  BASCON : Integer ;  { Anzahl der vordefinierten Konstanten            }
  NDFCON : Integer ;  {  Aktuelle Anzahl der definierten Konstanten     }
  IGRAD  : TAngularUnits;
  DOPRPI : double    ;  {  PI                                             }
  PID180 : double    ;  {  PI / 180                                       }
  PID200 : double    ;  {  PI / 200  (für Neugrad)                      }
  MAXFUN : Integer ;  {  Maximal moegliche Anzahl von Funktionen        }
  NCFUST : Integer ;  {  Laenge (number of characters) des Strings,
                         der die Funktionen aufnimmt                    }
  NDFFUN : Integer ;  {  Aktuelle Anzahl der definierten Funktionen     }
  ICLFUN : Integer ;  {  Hoechste zu "akzeptierende Funktionsnummer"
                         = 0      -  Auswertung einer "normalen Formel"
                         = NDFFUN -  Test eines Strings auf "Funktions-
                                     Tauglichkeit"
                         = I - 1  -  Auswertung der Funktion I          }
  LOVFLW : Boolean ;  {  = .TRUE. ---> Abbruch wegen Ueberlaufgefahr    }
  DPRMAX : double    ;  {  Groesster darstellbarer double-Wert              }
  DPMXLG : double    ;  {  Groesster double-Exponent                        }
  DPEPS  : double    ;  {  double-Epsilon (fuer OPERIT)                     }
  DPLGE  : double    ;  {  double-Wert  LG(E)                               }
  DEPSLG : double    ;  {  Kleinstes zulaessiges Argument fuer LG         }
  DEPSLN : double    ;  {  Kleinstes zulaessiges Argument fuer LN         }
  DEPSTN : double    ;  {  Kleinste Abweichung von pi/2 bzw. pi
                         fuer TAN bzw. COT                              }
  DMXWFA : double    ;  {  Maximales Argument fuer Winkelfunktionen       }
  DPZERO : double    ;  {  double-Null                                      }
  DPONE  : double    ;  {  double-Eins                                      }
  NBRSOL : Integer ;  {  Anzahl der aufgeloesten Klammern               }
  NAROPE : Integer ;  {  Anzahl der ausgefuehrten arithmetischen
                         Operationen im aktuellen Klammerpaar           }
  INDERR : Integer ;  {  Fehlerindikator                                }
  IPOHLF : Integer ;
  IPOHLL : Integer ;  {  Highlight-Bereich im Expression-String         }
  IPOHLS : Integer ;  {  Position fuer Operanden/Vorzeichenmuster
                         in HLSTRN                                      }
  IPOREL : Integer ;  {  Relative Position des Fehlers zum Beginn des
                         aktuellen Substrings                           }
  NFNLEN : Integer ;  {  Laenge des Namens der zuletzt behandelten
                         Standardfunktion                               }

{   Die nachfolgende Konfiguration gestattet keine Funktionen-
  definitionen und keine Konstantendefinitionen (Level 1).

  Die Felder FCNNAM, FCNVAL und IFCPOS und der String
  FCNSTR werden nur fuer das Arbeiten mit Funktionen
  benoetigt.

  =========================================================
  = Parameter, die den Parser konfigurieren               =
  = =======================================               =
  =                                                       =
  = Laenge des Stacks, des Konstantenspeichers,           =
  = Anzahl der zu definierenden Funktionen, Laenge        =
  = der Workstrings, Laenge des Strings, der die          =
  = Funktionen aufnimmt, und Anzahl der Spalten des       =
  = Feldes IFCPOS:                                        =
  =                                                       = }
    const
         MXSTCK = 160 ;
         MXCONS =   9 ;
         MXFUNC =   0 ;
         NLENWS = 1023;
         NCFCST =   1 ;
         IFCROW =   1 ;
{   =                                                       =
  = Workstrings, deren Laenge die Laenge des Eingabe-     =
  = strings begrenzen:                                    =
  =                                                       = }
    type
         PWSTRN = array [1 .. NLENWS] of AnsiChar ;

    var
         PARSTX , HLSTRX : PWSTRN ;
{   =                                                       =
  = String fuer Aufnahme der zu definierenden Funktionen: =
  =                                                       =
         FCNSTR : string [1]
  =                                                       = }

    type
         STACKTYPE  = array [1 .. MXSTCK]           of double       ;
         DPCONTYPE  = array [1 .. MXCONS]           of double       ;
         NAMCONTYPE = array [1 .. MXCONS]           of String [MathStrLen] ;
         FCNNAMTYPE = array [0 .. MXFUNC]           of String [MathStrLen] ;
         IFCPOSTYPE = array [0 .. MXFUNC ,
                                  IFCROW .. IFCROW] of Integer    ;
         FCNVALTYPE = array [0 .. MXFUNC]           of double       ;
         FUNTYPTYPE = String [4] ;
         NAMETYPE   = String [MathStrLen] ;


    var
         STACK  : STACKTYPE  ;
         DPCON  : DPCONTYPE  ;
         NAMCON : NAMCONTYPE ;
         FCNNAM : FCNNAMTYPE ;
         IFCPOS : IFCPOSTYPE ;

{============================================================}

{Simulation der "FORTRAN-SIGNUM"-Funktion:
 Vorzeichen-Transfer von SIGNV auf VALUE}

function SIGNUM_P (VALUE : double  ;
                   SIGNV : double) : double ;
begin
  IF  SIGNV > 0  THEN
    SIGNUM_P :=   Abs (VALUE)
  ELSE IF  SIGNV < 0  THEN
    SIGNUM_P := - Abs (VALUE)
end ;

{============================================================}

// Error messages
function gterrm_p (Error : Integer) : string ;
begin
  case Error of
  0 : Result:= ' ';
  1 : Result:=rsMathErrPar; //'Fehler (öffnende/schließende Klammern)'
  2 : Result:=rsMathErrLeftPar; //Eingabefehler (öffnende Klammer fehlt)'
  3 : Result:=rsMathErrEmptyPar; //'Eingabefehler (kein Klammerinhalt)'
  4 : Result:=rsMathErrDivZero; //'Division durch Null'
  5 : Result:=rsMathErrInvalidArg; //'Unzulässiges Argument'
  6 : Result:=rsMathErrOverflow; //'Operation führt zu Überlauf'
  7 : Result:=rsMathErrInvalidExp; //'Unidentifizierbarer Ausdruck'
  8 : Result:=rsMathErrUnexpOper; //'Unerwartetes Operationssymbol'
  9 : Result:=rsMathErrIncompExp; //'Unvollständiger Ausdruck'
  10 : Result:=rsMathErrMissOper; //'Operationssymbol fehlt'
  11 : Result:=rsMathErrNegPower; //'Potenz mit unzulässiger (negativer) Basis'
  12 : Result:=rsMathErrZeroPower; //'"Null hoch Null"'
  13 : Result:=rsMathErrZeroZero; //'"Null durch Null"'
  14 : Result:=rsMathErrInvalidOps; //'Unzulässige Kombination von Operanden'
  15 : Result:=rsMathErrInvalidChar; //'Unerlaubtes Zeichen'
  19 : Result:=rsMathErrInvalidOvfl; //'Unzulässiges Argument (Überlaufgefahr)'
  20 : Result:=rsMathErrStackOvfl; //'Speicherplatz fehlt ("stack overflow")'
  30 : Result:=rsMathErrMemOvfl; //'Speicherplatz fehlt ("string overflow")'
  else Result:=rsMathErrUnknown; //'Unbekannter Fehler'
    end;
  end;

{============================================================}

{ Korrektur der ermittelten Highlight-Positionen durch
  Vergleich des Originalstrings mit dem verdichteten
  String }

procedure CRRHLP_P (EXSTRN : PWSTRN ;
                    NEXSLN : Integer) ;
var
    LFNOTC : Boolean ;
    LLNOTC : Boolean ;
    IEXUB  : Integer ;
    I      : Integer ;
    IASCII : Integer ;
label
    9999 ;
begin
    IF  (IPOHLF <= 0)  OR  (NEXSLN = 0)  THEN  GOTO 9999 ;

    LFNOTC := TRUE ;
    LLNOTC := TRUE ;
    IEXUB  := 0    ;

    for I:=1 to NEXSLN do
    begin
      IASCII := Ord (EXSTRN [I]) ;
      IF  (IASCII <> 9)  AND  (IASCII <> 32)  THEN
      begin
        IEXUB := IEXUB + 1 ;
        IF  (IEXUB = IPOHLF)  AND  (LFNOTC) THEN
        begin
          IPOHLF := I     ;
          LFNOTC := FALSE
        end ;
        IF  (IEXUB = IPOHLL)  AND  (LLNOTC) THEN
        begin
          IPOHLL := I     ;
          LLNOTC := FALSE
        end
      end
    end ;

9999:
end ;

{============================================================}

{ "CHECK 'CHARACTER = NUMBER'" }

function CHSNUM_P (CAPIT : AnsiChar) : Boolean ;
var
    I : Integer ;
begin
    I := Ord (CAPIT) ;

    IF  (I >= 48) AND (I <= 57) THEN
      CHSNUM_P := TRUE
    ELSE
      CHSNUM_P := FALSE ;
end ;

{============================================================}

{ "Ist ein String eine Zahl?" }

function NUMBIT_P (CSTRIN : AnsiString ;
                   NLEN   : Integer) : Boolean ;

var
    LNBFOU : Boolean ;
    IPOS   : Integer ;
label
    1000 ,
    2000 ,
    4000 ,
    5000 ,
    9000 ,
    9999 ;
begin
    NUMBIT_P := FALSE ;
    LNBFOU   := FALSE ;
    IPOS     := 1     ;

    IF  (CSTRIN [IPOS] = '+')  OR
        (CSTRIN [IPOS] = '-')  THEN
    begin
      IPOS := IPOS + 1 ;
      IF  IPOS > NLEN  THEN  GOTO 9999
    end ;

    IF  CSTRIN [IPOS] = '.'  THEN
    begin
      IPOS := IPOS + 1 ;
      IF  IPOS > NLEN  THEN  GOTO 9999 ;
GOTO 2000
    end ;

1000:
    IF  CHSNUM_P (CSTRIN [IPOS])  THEN
    begin
      {... Ziffern vor dem Dezimalpunkt}
      LNBFOU := TRUE     ;
      IPOS   := IPOS + 1 ;
      IF  IPOS > NLEN  THEN  GOTO 9000 ;
GOTO 1000
    end ;

    IF  NOT LNBFOU  THEN  GOTO 9999 ;
    {... weder Dezimalpunkt noch Ziffer gefunden ---> keine Zahl}

    IF  CSTRIN [IPOS] = '.'  THEN
    begin
      IPOS := IPOS + 1 ;
      IF  IPOS > NLEN  THEN  GOTO 9000 ;
      {Weitere Ziffern nach dem Dezimalpunkt moeglich:}
      GOTO 2000
    end
    ELSE
      {... Exponent moeglich:}
      GOTO 4000 ;

2000:
    IF  CHSNUM_P (CSTRIN [IPOS])  THEN
    begin
      {... Ziffern nach dem Dezimalpunkt}
      LNBFOU := TRUE     ;
      IPOS   := IPOS + 1 ;
      IF  IPOS > NLEN  THEN  GOTO 9000 ;
GOTO 2000
    end ;

    IF  NOT LNBFOU  THEN  GOTO 9999 ;
    {... keine Ziffer gefunden ---> keine Zahl}

4000:
    IF  CSTRIN [IPOS] = 'E'  THEN
    begin
      {... Exponent:}
      IPOS := IPOS + 1 ;
      IF  IPOS > NLEN  THEN  GOTO 9999 ;
        {... weil nicht ein einsames E am Ende stehen darf}
      IF  (CSTRIN [IPOS] = '+')  OR
          (CSTRIN [IPOS] = '-')  THEN  IPOS := IPOS + 1 ;
      IF  IPOS > NLEN  THEN  GOTO 9999 ;
        {... weil nicht ein einsames Vorzeichen am Ende stehen darf}
5000:
      IF  CHSNUM_P (CSTRIN [IPOS])  THEN
      begin
        IPOS := IPOS + 1 ;
        IF  IPOS <= NLEN  THEN  GOTO 5000
      end
ELSE
        GOTO 9999 ;
    end
    ELSE
      GOTO 9999 ;

9000:
    NUMBIT_P := TRUE ;

9999:
end ;

{============================================================}

{ "Position of NAME in NAMARR" }

{Diese Function, die in der Fortran-Version fuer die Positions-
 bestimmung in FCNNAM (Funktionsnamen) UND NAMCON (Konstanten-
 namen) verwendet wird (Arrays mit UNTERSCHIEDLICHEN Index-
 grenzen), wird vorsichtshalber voellig herausgenommen aus der
 Pascal-Version.

 Die Positionsermittlung in NAMCON wird wie in Fortran von
 CONPOS_P uebernommen (in Pascal ist dies allerdings eine
 selbstaendig arbeitende Function).

Fuer die Positionsermittlung in FCNNAM wird die neue Function
FCNPOS_P vorgesehen.}

{ *********** In Pascal ersetzt durch FCNPOS_P ************

function NAMPOS_P (NAMARR : NAMCONTYPE ;
                   NAME   : NAMETYPE   ;
               var INMPOS : Integer    ;
                   NDFNAM : Integer)   : Boolean ;
var
    I : Integer    ;
    J : Integer    ;
    N : String [6] ;
label
     100 ,
    9999 ;
begin
    NAMPOS_P := FALSE ;

    for I:=1 to NDFNAM do
    begin
      for J:=1 to 6 do
      begin
        N := NAMARR [I] ;
        IF  NAME [J] <> N [J]  THEN  GOTO 100
      end ;
      INMPOS   := I    ;
      NAMPOS_P := TRUE ;
      GOTO 9999        ;
100:
    end ;

9999:
end ;

*********** In Pascal ersetzt durch FCNPOS_P ************ }

{============================================================}

{ "Position of NAME in FCNNAM" }

{Achtung: Wenn der Fortran-NAMPOS_P-Aufruf fuer die Positions-
          bestimmung in FCNNAM durch einen FCNPOS_P-Aufruf
          ersetzt wird, muss beachtet werden, dass FCNPOS_P
          die "richtige" INMPOS-Position liefert, waehrend
          in Fortran die untere Grenze 0 auf den Index 1
          abgebildet wurde!}

function FCNPOS_P (FCNNAM : FCNNAMTYPE ;
                   NAME   : NAMETYPE   ;
               var INMPOS : Integer    ;
                   NDFNAM : Integer)   : Boolean ;
var
    I : Integer    ;
    J : Integer    ;
    N : String [MathStrLen] ;
label
     100 ,
    9999 ;
begin
    FCNPOS_P := FALSE ;

    for I:=0 to NDFNAM do
    begin
      for J:=1 to MathStrLen do
      begin
        N := FCNNAM [I] ;
        IF  NAME [J] <> N [J]  THEN  GOTO 100
      end ;
      INMPOS   := I    ;
      FCNPOS_P := TRUE ;
      GOTO 9999        ;
100:
    end ;

9999:
end ;

{============================================================}

{ "POSITION OF CONSTANT IN NAMCON" }

{Weil im Gegensatz zu Fortran in Pascal die Abbildung eines
 mit unterer Indexgrenze 0 beginnenden Feldes auf ein mit
 unterer Indexgrenze 1 beginnendes Feld nicht moeglich ist,
 muss hier CONPOS_P "eigenstaendig" arbeiten und kann nicht
 NAMPOS_P verweden.}

function CONPOS_P (NAMCON : NAMCONTYPE ;
                   NAME   : NAMETYPE   ;
               var ICOPOS : Integer)   : Boolean ;
var
    I : Integer    ;
    J : Integer    ;
    N : String [MathStrLen] ;
label
     100 ,
    9999 ;
begin
    CONPOS_P := FALSE ;

    for I:=1 to NDFCON do
    begin
      for J:=1 to MathStrLen do
      begin
        N := NAMCON [I] ;
        IF  NAME [J] <> N [J]  THEN  GOTO 100
      end ;
      ICOPOS   := I    ;
      CONPOS_P := TRUE ;
      GOTO 9999        ;
100:
    end ;

9999:
end ;

{============================================================}

function CAPCHR_P (OLDCHR : AnsiChar) : AnsiChar ;
var
    I : byte;
begin
    I := Ord (OLDCHR) ;

    IF (I >= 97)  AND  (I <= 122)  THEN
      CAPCHR_P := AnsiChar(I-32)
    ELSE IF  I = 132  THEN
      CAPCHR_P := AnsiChar(142)
    ELSE IF  I = 148  THEN
      CAPCHR_P := AnsiChar(153)
    ELSE IF  I = 129  THEN
      CAPCHR_P := AnsiChar(154)
    ELSE
      CAPCHR_P := OLDCHR
end ;

{============================================================}

procedure MKPARS_P (CSTRIN : PWSTRN ;
                var QARSTR : PWSTRN ;
                    NCSTLN : Integer) ;
var
    C : AnsiChar    ;
    I : Integer ;
begin
    for I:=1 to NCSTLN do
    begin
      C := CSTRIN [I] ;
      IF  (C = '[')  OR  (C = '{')  THEN
        QARSTR [I] := '('
      ELSE IF  (C = ']')  OR  (C = '}')  THEN
        QARSTR [I] := ')'
      ELSE
        QARSTR [I] := CAPCHR_P (C) ;
        {... wobei Klein- zu Grossbuchstaben werden}
    end
end ;

{============================================================}

procedure COMPST_P (var CSTRIN : PWSTRN  ;
                        IPOS   : Integer ;
                    var NLEN   : Integer) ;
var
    I      : Integer ;
    IOG    : Integer ;
    IASCII : Integer ;
begin
    IOG  := NLEN     ;
    NLEN := IPOS - 1 ;

    for I:=IPOS to IOG do
    begin
      IASCII := Ord (CSTRIN[I]) ;
      IF (IASCII <> 9)  AND  (IASCII <> 32) THEN
      begin
        NLEN          := NLEN + 1   ;
        CSTRIN [NLEN] := CSTRIN [I]
      end
    end ;

    IF  NLEN < IOG  THEN
    begin
      for I := NLEN+1 to IOG do
         CSTRIN [I] := ' '
    end
end ;

{============================================================}

{ Check des Strings auf Verwendung der
  zulaessigen Characters               }

function CHRCHK_P (PARSTR : PWSTRN ;
                   NLENPS : Integer) : Boolean ;
var
    I      : Integer ;
    IASCII : Integer ;
label
    9999 ;
begin
    CHRCHK_P := FALSE ;

    for I:=1 to NLENPS do
    begin
      IASCII := Ord (PARSTR [I]) ;
      IF (IASCII <= 39)                           OR
         (IASCII  = 44)                           OR
         ((IASCII >= 58) AND (IASCII <= 60))      OR
         ((IASCII >= 62) AND (IASCII <= 64))      OR
         (IASCII  = 92)                           OR
         ((IASCII >= 126) AND (IASCII <> 129) AND
          (IASCII <> 132) AND (IASCII <> 142) AND
          (IASCII <> 148) AND (IASCII <> 153) AND
          (IASCII <> 154)) THEN
      begin
        INDERR := 15 ;
        IPOHLF :=  I ;
        IPOHLL :=  I ;
        GOTO 9999
      end
    end ;

    CHRCHK_P := TRUE ;

 9999:
 end ;

{============================================================}

{ "SYMBOL = OPEARATIONSSYMBOL ?" }

function OPSYMB_P (SYMBOL : AnsiChar) : Boolean ;
begin
    IF  (SYMBOL = '+')  OR  (SYMBOL = '-')  OR
        (SYMBOL = '*')  OR  (SYMBOL = '/')  OR
        (SYMBOL = '^') THEN
      OPSYMB_P := TRUE
    ELSE
      OPSYMB_P := FALSE ;
end ;

{============================================================}

{ "POSITION OF NEXT DELIMITER" }

    function PDELIM_P (CSTRIN      : PWSTRN  ;
                       IPOS , ILAS : Integer ;
                   var IPODLM      : Integer) : Boolean ;
var
    I : Integer ;
label
    9999 ;
begin
    PDELIM_P := FALSE ;

    IF  ILAS >= IPOS  THEN
    begin
      for  I:=IPOS to ILAS do
      begin
        IF  (CSTRIN [I] = '+') OR (CSTRIN [I] = '-') OR
            (CSTRIN [I] = '*') OR (CSTRIN [I] = '/') OR
            (CSTRIN [I] = '^') OR (CSTRIN [I] = '(') THEN
        begin
          IPODLM   := I    ;
          PDELIM_P := TRUE ;
          GOTO 9999
        end
      end ;
      IPODLM   := ILAS + 1 ;
      PDELIM_P := TRUE
    end ;

9999:
end ;

{============================================================}

{ "Position of next operation symbol" }

function POPSYM_P (CSTRIN      : PWSTRN   ;
                   IPOS , ILAS : Integer  ;
               var IPODLM      : Integer) : Boolean ;
var
    I : Integer ;
label
    9999 ;
begin
    POPSYM_P := FALSE ;

    IF  ILAS >= IPOS  THEN
    begin
      for I:=IPOS to ILAS do
      begin
        IF  (CSTRIN [I] = '+') OR (CSTRIN [I] = '-') OR
            (CSTRIN [I] = '*') OR (CSTRIN [I] = '/') OR
            (CSTRIN [I] = '^') OR (CSTRIN [I] = '(') OR
            (CSTRIN [I] = ')') THEN
        begin
          IPODLM   := I    ;
          POPSYM_P := TRUE ;
          GOTO 9999
        end
      end ;
      IPODLM   := ILAS + 1 ;
      POPSYM_P := TRUE
    end ;

9999:
end ;

{============================================================}

{ "SYMBOL = KLAMMER AUF?"  }

function LOPBRC_P (SYMBOL : AnsiChar) : Boolean ;

begin
    IF  (SYMBOL = '(')  OR  (SYMBOL = '[')  OR
        (SYMBOL = '{')  THEN
      LOPBRC_P := TRUE
    ELSE
      LOPBRC_P := FALSE ;

end ;

{============================================================}

{ "SYMBOL = KLAMMER ZU?" }

function LCLBRC_P (SYMBOL : AnsiChar) : Boolean ;

begin
    IF  (SYMBOL = ')')  OR  (SYMBOL = ']')  OR
        (SYMBOL = '}')  THEN
      LCLBRC_P := TRUE
    ELSE
      LCLBRC_P := FALSE ;

end ;

{============================================================}

{ "CHECK 'CHARACTER = CAPITAL"  }

function CHCAPS_P (CAPIT : AnsiChar) : Boolean ;
var
    I : Integer ;
begin
    I := Ord (CAPIT) ;

    IF ((I >  64) AND (I <  91)) OR
        (I = 142) OR  (I = 153)  OR  (I = 154) THEN
      CHCAPS_P := TRUE
    ELSE
      CHCAPS_P := FALSE
end ;

{============================================================}

{ "PARSE AN FUNCTION ITEM"

  IPOARG ist die Position des Arguments '#' in PARSTR.
  Es wird geprueft, ob ein Funktionsaufruf vorangeht,
  wenn ja:

        FUNCIT_P = .TRUE ,
        FUNTYP   = 'Funktionstyp',
        IPOS     = Position des ersten Funktions-
                   Characters in PARSTR }

function FUNCIT_P (PARSTR : PWSTRN  ;
                   IPOARG : Integer ;
               var IPOS   : Integer ;
               var FUNTYP : FUNTYPTYPE) : Boolean ;
var
    LDUMMY : Boolean ;
    I      : Integer ;
    IPODLM : Integer ;
label
     500 ,
    1000 ,
    2000 ,
    9000 ,
    9999 ;
begin
    FUNCIT_P := FALSE ;

    IF  IPOARG > 1  THEN
    begin
      IF  PARSTR [IPOARG-1] <> '('  THEN  GOTO 9999
    end ;

    IPOS := IPOARG - 6 ;
    IF  IPOS > 0  THEN
    begin
      IF  Copy (PARSTR , IPOS , 5) = 'ASINH'  THEN
        FUNTYP := 'ASNH'
      ELSE IF  Copy (PARSTR , IPOS , 5) = 'ACOSH'  THEN
        FUNTYP := 'ACSH'
      ELSE IF  Copy (PARSTR , IPOS , 5) = 'ATANH'  THEN
        FUNTYP := 'ATNH'
      ELSE IF  Copy (PARSTR , IPOS , 5) = 'ACOTH'  THEN
        FUNTYP := 'ACTH'
      ELSE IF  Copy (PARSTR , IPOS , 5) = 'SWOFF'  THEN
        FUNTYP := 'SWOF'
      ELSE
        GOTO 500 ;
      GOTO 9000
    end ;

500:
    IPOS := IPOARG - 5 ;
    IF  IPOS > 0  THEN
    begin
      IF  Copy (PARSTR , IPOS , 4) = 'SINH'  THEN
        FUNTYP := 'SINH'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'COSH'  THEN
        FUNTYP := 'COSH'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'TANH'  THEN
        FUNTYP := 'TANH'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'COTH'  THEN
        FUNTYP := 'COTH'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'ASIN'  THEN
        FUNTYP := 'ASIN'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'ACOS'  THEN
        FUNTYP := 'ACOS'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'ATAN'  THEN
        FUNTYP := 'ATAN'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'ACOT'  THEN
        FUNTYP := 'ACOT'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'SIGN'  THEN
        FUNTYP := 'SIGN'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'SQRT'  THEN
        FUNTYP := 'SQRT'
      ELSE IF  Copy (PARSTR , IPOS , 4) = 'SWON'  THEN
        FUNTYP := 'SWON'
      ELSE
        GOTO 1000 ;
      GOTO 9000
    end ;

1000:
    IPOS := IPOARG - 4 ;
    IF  IPOS > 0  THEN
    begin
      IF  Copy (PARSTR , IPOS , 3) = 'SIN'  THEN
        FUNTYP := 'SIN '
      ELSE IF  Copy (PARSTR , IPOS , 3) = 'COS'  THEN
        FUNTYP := 'COS '
      ELSE IF  Copy (PARSTR , IPOS , 3) = 'TAN'  THEN
        FUNTYP := 'TAN '
      ELSE IF  Copy (PARSTR , IPOS , 3) = 'COT'  THEN
        FUNTYP := 'COT '
      ELSE IF  Copy (PARSTR , IPOS , 3) = 'ABS'  THEN
        FUNTYP := 'ABS '
      ELSE IF  Copy (PARSTR , IPOS , 3) = 'EXP'  THEN
        FUNTYP := 'EXP '
      ELSE IF  Copy (PARSTR , IPOS , 3) = 'FAK'  THEN
        FUNTYP := 'FAK '
      ELSE IF  Copy (PARSTR , IPOS , 3) = 'SQR'  THEN
        FUNTYP := 'SQRT'
      ELSE
        GOTO 2000 ;
      GOTO 9000
    end ;

2000:
    IPOS := IPOARG - 3 ;
    IF  IPOS > 0  THEN
      begin
        IF  Copy (PARSTR , IPOS , 2) = 'LN'  THEN
          FUNTYP := 'LN  '
        ELSE IF  Copy (PARSTR , IPOS , 2) = 'LG'  THEN
          FUNTYP := 'LG  '
        ELSE
          GOTO 9999 ;
      end
    ELSE
      GOTO 9999 ;

9000:
    IF  IPOS = 1  THEN
      FUNCIT_P := TRUE
    ELSE
      begin
        I      := IPOS - 1 ;
        LDUMMY := PDELIM_P (PARSTR , I , IPOS , IPODLM) ;
          {... sucht nach Delimiter vor Funktionsaufruf}
        IF  (IPODLM = I) OR (PARSTR [I] = '=')  THEN
          FUNCIT_P := TRUE
        ELSE
          begin
            IPOREL := IPOS - IPOARG ;
            INDERR := 10
          end
      end ;

9999:
end ;

{============================================================}

{ Syntaxcheck der Klammerstruktur eines Strings }

function PARCHK_P (PARSTR : PWSTRN ;
                   NLENPS : Integer) : Boolean ;
var
    ICHAR  : AnsiChar       ;
    CDUM   : FUNTYPTYPE ;
    FEQUAL : Boolean    ;
    IPOBR1 : Integer    ;
    NOPEN  : Integer    ;
    NCLOS  : Integer    ;
    I      : Integer    ;
    IDUM   : Integer    ;
label
    9999 ;
begin
    PARCHK_P := FALSE ;
    IPOBR1   := 0     ;
    NOPEN    := 0     ;
    NCLOS    := 0     ;
    FEQUAL   := FALSE ;

    for I:=1 to NLENPS do
    begin
      IF  PARSTR [I] = '('  THEN  NOPEN := NOPEN + 1 ;
      IF  PARSTR [I] = ')'  THEN  NCLOS := NCLOS + 1
    end ;

    IF  NOPEN <> NCLOS  THEN
    begin
      INDERR := 1      ;
      IPOHLF := 1      ;
      IPOHLL := NLENPS ;
GOTO 9999
    end ;

    IPOBR1 := 0     ;
    NOPEN  := 0     ;
    FEQUAL := FALSE ;

    for  I:=1 to NLENPS do
    begin
      ICHAR := PARSTR [I] ;
      IF  ICHAR = '('  THEN
      begin  {... oeffnende Klammer gefunden}
        IF  I > 1  THEN
        begin
          IF  (PARSTR [I-1] <> '(')                       AND
              (NOT OPSYMB_P (PARSTR [I-1]))               AND
              (NOT FUNCIT_P (PARSTR , I+1 , IDUM , CDUM)) THEN
          begin
            IF  (PARSTR [I-1] = '=') AND (NOT FEQUAL) THEN
              FEQUAL := TRUE      {Konstantendefinition}
            ELSE
            begin
              INDERR := 10    ;
              IPOHLF := I - 1 ;
              IPOHLL := I     ;
              GOTO 9999
            end { ELSE ...}
          end
        end ; { IF  I > 1  THEN ...}
        IPOBR1 := I     + 1 ;
        NOPEN  := NOPEN + 1
      end {IF  ICHAR = '('  THEN ...}
      ELSE IF  ICHAR = ')'  THEN
      begin { ... schliessende Klammer gefunden}
        IF (I < NLENPS)                   AND
           (NOT OPSYMB_P (PARSTR [I+1]))  AND
           (PARSTR [I+1] <> ')')          THEN
        begin
            INDERR := 10    ;
            IPOHLF := I     ;
            IPOHLL := I + 1 ;
            GOTO 9999
        end ;
        IF  NOPEN = 0  THEN
          {Syntax-Fehler (schliessende Klammer ohne vorherige
           oeffnende Klammer):}
          begin
            INDERR := 2 ;
            IPOHLF := I ;
            IPOHLL := I ;
            GOTO 9999
          end
        ELSE
          begin
            IF  IPOBR1 = I  THEN
              {Syntax-Fehler (kein Klammerinhalt):}
              begin
                INDERR := 3     ;
                IPOHLF := I - 1 ;
                IPOHLL := I     ;
                GOTO 9999
              end
            ELSE
              begin
                IPOBR1 := 0         ;
                NOPEN  := NOPEN - 1
              end
          end
      end { ELSE IF (ICHAR .EQ. ')') THEN ...}
    end ; { for I:= ...}

    PARCHK_P := TRUE ;

9999:
end ;

{============================================================}

{ SYNTAXCHECK DER STRUKTUR DER OPERATIONSSYMBOLE EINES
  STRINGS }

function OPSCHK_P (PARSTR : PWSTRN ;
                   NLENPS : Integer) : Boolean ;
var
    JCHAR  : AnsiChar    ;
    LOPSYM : Boolean ;
    I      : Integer ;
label
    9999 ;
begin
    OPSCHK_P := FALSE ;

    JCHAR  := PARSTR [1]       ;
    LOPSYM := OPSYMB_P (JCHAR) ;
    IF  (JCHAR = '*')  OR  (JCHAR = '/')  OR
        (JCHAR = '^') THEN
    begin
      INDERR := 8 ;
      IPOHLF := 1 ;
      IPOHLL := 1 ;
GOTO 9999
    end ;

    IF  NLENPS > 1  THEN
    begin
      for I:=2 to NLENPS do
      begin
        IF  OPSYMB_P (PARSTR [I])  THEN
        begin
          {... Operationssymbol auf Position I ...}
          IF  (LOPSYM)  OR
              ((JCHAR = '(')       AND
               (PARSTR [I] <> '+') AND (PARSTR [I] <> '-')) THEN
              {... und Position (I-1) ebenfalls Operationssymbol
                   oder oeffnende Klammer ...}
          begin
            IF  (Copy (PARSTR , I-1 , 2) <> '**')  OR
                (OPSYMB_P (PARSTR [I+1]))          THEN
               {... und nicht Symbol '**' oder Position (I+1)
                   enthaelt auch Operationssymbol:}
            begin
              INDERR := 8     ;
              IPOHLF := I - 1 ;
              IPOHLL := I     ;
              GOTO 9999
            end
          end
        end ;
        IF  (LOPSYM)  AND  (PARSTR [I] = ')') THEN
          {... schliessende Klammer folgt auf Operationssymbol:}
        begin
          INDERR := 14    ;
          IPOHLF := I - 1 ;
          IPOHLL := I     ;
    GOTO 9999
        end ;
        JCHAR  := PARSTR [I]       ;
        LOPSYM := OPSYMB_P (JCHAR)
      end
    end ;

    IF  OPSYMB_P (PARSTR [NLENPS])  THEN
    begin
      INDERR := 8      ;
      IPOHLF := NLENPS ;
      IPOHLL := NLENPS ;
      GOTO 9999
    end ;

    OPSCHK_P := TRUE ;

9999:
end ;

{============================================================}

{ Check, ob alle verwendeten Ausdruecke interpretiert
  werden koennen (definierte Konstanten oder zulaessige
  Funktionen oder Zahlen sind, bei LFUNCH = .TRUE sind
  auch die definierten Funktionen erlaubt) }

function ITMCHK_P (PARSTR : PWSTRN      ;
                   NLENPS : Integer     ;
                   NAMCON : NAMCONTYPE  ;
                   FCNNAM : FCNNAMTYPE) : Boolean ;
var
    CONNAM : String [MathStrLen] ;
    FUNTYP : FUNTYPTYPE ;
    IPOS   : Integer    ;
    IPODLM : Integer    ;
    ILAST  : Integer    ;
    IPO1   : Integer    ;
    IEND   : Integer    ;
    I      : Integer    ;
    J      : Integer    ;
    ICOPOS : Integer    ;
    ILASTZ : Integer    ;
label
     100 ,
    8000 ,
    9000 ,
    9999 ;
begin
    ITMCHK_P := FALSE ;
    IPOS     := 1     ;

100:
    IF  NOT POPSYM_P (PARSTR , IPOS , NLENPS , IPODLM)  THEN GOTO 9000 ;
      {... weil POPSYM_P nur .FALSE. liefert, wenn  IPOS > NLENPS
           und also der String ohne Misserfolg abgearbeitet wurde}
    ILAST := IPODLM - 1 ;

    IF  ILAST < IPOS  THEN
    begin
      {... auf IPOS direkt Operationssysmbol, weiter:}
      IPOS := IPOS + 1 ;
GOTO 100
    end ;

   {... und auf  IPOS ... ILAST  steht ein String, der von einem
        Operationszeichen als Folgezeichen oder vom Stringende
        begrenzt wird, Operationszeichen:  +  -  *  /  ^  (  )  }

    IF  ILAST < NLENPS  THEN
    begin
      IF  PARSTR [IPODLM] = '('  THEN
      begin
        {... kann es nur eine Funktion sein:}
        IF  FUNCIT_P (PARSTR , IPODLM + 1 , IPO1 , FUNTYP) THEN
        begin
          IF  IPO1 = IPOS  THEN
            {... ist es tatsaechlich eine Funktion:}
          begin
            IPOS := IPODLM + 1 ;
      GOTO 100
            {... und der Ruecksprung erfolgt ohne Endepruefung,
                 obwohl Zeichen folgen MUESSEN. Ein solcher Fehler
                 wuerde aber vom Klammer-Check erwischt werden.}
          end
        end ;

        {Es duerfte nur eine Funktion sein, ist aber keine:}
        GOTO 8000

      end
    end ;

    {Test, ob es eine Konstante oder eine deklarierte
     Funktion ist:}
    IF  CHCAPS_P (PARSTR [IPOS])  THEN
      {... Item beginnt mit einem Gross-Buchstaben und haette als
           Konstante maximal 6 signifikante Characters, die auf
           CONNAM uebertragen werden:}
    begin
      IEND := ILAST ;
      IF  IPOS + 5 < ILAST  THEN  IEND := IPOS + 5 ;
      J := IPOS ;
      for I:=1 to MathStrLen do
      begin
        if  J > IEND  THEN
          CONNAM [I] := ' '
        else
          CONNAM [I] := PARSTR [J] ;
        J := J + 1
      end ;

      IF  (CONPOS_P (NAMCON , CONNAM , ICOPOS))              OR
          (FCNPOS_P (FCNNAM , CONNAM , ICOPOS , ICLFUN)) THEN
          {... Item ist eine definierte Konstante oder
               deklarierte Funktion:}
      begin
        IPOS := IPODLM + 1 ;
  GOTO 100
      end
    end ;

    { Hinweis zur oben verwendeten NAMPOS_P-Abfrage: ICLFUN ist die
      hoechste Funktionsnummer, die abgefragt werden soll. Da FCNNAM
      mit Index 0 beginnt (aber in NAMPOS_P auf ein Feld ab Index 1
      abgebildet wird), muss hier ICLFUN + 1 uebergeben werden.

      "Hinweis zum Hinweis: In Pascal ist NAMPOS_P durch FCNPOS_
      ersetzt worden. Nun gilt das nicht mehr, und oben ist auch
      ICLFUN uebergeben worden! }

    { Schliesslich koennte es noch eine Zahl sein:}

    ILASTZ := ILAST ;
    IF  (PARSTR [ILAST] = 'E')        AND
        ((PARSTR [IPODLM] = '+') OR
         (PARSTR [IPODLM] = '-'))     THEN
      { Sollte der String tatsaechlich eine Zahl repraesentieren,
        dann ist er zu kurz geraten, weil der Exponent mit
        einem Vorzeichen (...E+...) geschrieben wurde, was als
        Begrenzer gewertet wurde. Dann muessten also noch Ziffern
        folgen, um die ILAST vor dem "Zahl-Test" verschoben werden muss: }
    begin
      IF  NOT POPSYM_P (PARSTR , ILAST + 2 , NLENPS , IPODLM)  THEN
                                                               GOTO 8000 ;
        {... weil POPSYM_P nur .FALSE. liefert, wenn  ILAST+2 > NLENPS
             und also keine Exponentenziffern mehr gefunden wurden}
      ILASTZ := IPODLM - 1
    end ;

    IF  NUMBIT_P (Copy (PARSTR , IPOS , ILASTZ - IPOS + 1) ,
                                        ILASTZ - IPOS + 1)  THEN
      {... Item ist eine Zahl:}
    begin
      IPOS := IPODLM + 1 ;
GOTO 100
    end ;

    ILAST := ILASTZ ;

    {Item ist nicht identifizierbar:}

8000:
    INDERR := 7     ;
    IPOHLF := IPOS  ;
    IPOHLL := ILAST ;
    GOTO 9999       ;

9000:
    ITMCHK_P := TRUE ;

9999:
end ;

{============================================================}

{ ANALYSE EINES "EXPRESSIONS" (KLAMMERLOSER SUBSTRING)

  Suche in PARSTR nach dem ersten Klammerpaar des tiefsten
  Levels, das einen Substring mit den Character-Positionen
  IPOBR1 ... IPOBR2 umschliesst (kein Klammerpaar gefunden
  ---> IPOBR1 = 0).
  PARBRC_P = .FALSE. ---> Syntax-Fehler }

function PARBRC_P (PARSTR : PWSTRN   ;
                   NLENPS : Integer  ;
               var IPOBR1 : Integer  ;
               var IPOBR2 : Integer) : Boolean ;
var
    I : Integer ;
label
    9000 ;
begin
    PARBRC_P := FALSE ;
    IPOBR1   := 0     ;

    for I:=1 to NLENPS do
    begin
      IF  PARSTR [I] = '('  THEN
        IPOBR1 := I + 1
      ELSE IF  PARSTR [I] = ')'  THEN
        begin
          IPOBR2 := I - 1 ;
          GOTO 9000
        end
    end ;

9000:
    PARBRC_P := TRUE

end ;

{============================================================}

{ EMITTLUNG DER ANZAHL DES ZEICHENS CCHAR IN EINEM
  SUBSTRING CSTRIN (IANF:IEND) }

function NFENCE_P (CSTRIN : PWSTRN  ;
                   IANF   : Integer ;
                   IEND   : Integer ;
                   CCHAR  : AnsiChar  ) : Integer ;
var
    N : Integer ;
    I : Integer ;
begin
    N := 0 ;

    for  I:=IANF to IEND do
    begin
      IF  CSTRIN [I] = CCHAR  THEN  N := N + 1
    end ;

    NFENCE_P := N ;
end ;

{============================================================}

{ Ermitteln der Substring-Region, in der ein Fehler auftrat
  (Positionen des klammerlosen Strings)

  Strategie: Absuchen des Original-Strings nach schliessender
  Klammer, Blanken des Bereichs von letzter oeffnenden Klammer
  bis zur schliessenden und Beginn der Suche von vorn.

  Mitzaehlen der so geloeschten Klammerpaare und Vergleichen
  mit NBRSOL (Anzahl aufgeloester Klammerpaare) fuehrt bei
  Gleichheit dieser Zahlen auf Bereich, in dem Fehler auftrat. }

procedure SBSTRG_P (var CSTRIN : PWSTRN  ;
                        NLENCS : Integer ;
                    var IPOSRF : Integer ;
                    var IPOSRL : Integer ) ;
var
    I     : Integer ;
    J     : Integer ;
    IUG   : Integer ;
    ISOL  : Integer ;
    IOPEN : Integer ;

label
      50 ,
    9999 ;

begin
    IUG  := 1 ;
    ISOL := 0 ;

 50:
    for I:=1 to NLENCS do
    begin
      IF  (CSTRIN [I] = '=')  AND  (IUG = 1)  THEN  IUG := I ;
      IF  LOPBRC_P (CSTRIN [I])  THEN
        IOPEN := I
      ELSE IF  LCLBRC_P (CSTRIN [I])  THEN
      begin
        IF  ISOL = NBRSOL  THEN
        begin
          IPOSRF := IOPEN ;
          IPOSRL := I     ;
          GOTO 9999
        end
        ELSE
        begin
          for J:=IOPEN to I do
              CSTRIN [J] := ' ' ;
          ISOL := ISOL + 1 ;
          GOTO 50
        end
      end
    end ;

    IPOSRF := IUG    ;
    IPOSRL := NLENCS ;

9999:
end ;

{============================================================}

{ Definieren der Highlight-Region }

procedure MKHLRG_P (var CSTRIN : PWSTRN ;
                        HLSTRN : PWSTRN ;
                        NLENCS : Integer) ;
var
    NOPE   : Integer ;
    IOPE   : Integer ;
    IPOSRF : Integer ;
    IPOSRL : Integer ;
    I      : Integer ;
    J      : Integer ;
    K      : Integer ;

label
     300 ,
     400 ,
    9999 ;

begin
    IF  ((INDERR > 3) AND (INDERR < 14)) OR (INDERR = 19)  THEN
    begin
      SBSTRG_P (CSTRIN , NLENCS , IPOSRF , IPOSRL) ;
        {... ermittelt die Substring-Region (Positionen des
             klammerlosen Substrings) }

      IF  (INDERR =  4)  OR  (INDERR =  6)  OR
          (INDERR = 11)  OR  (INDERR = 12)  OR
          (INDERR = 13)  THEN
        { Fehler bei arithmetischer Operation (Division durch
          Null, Ueberlauf, Potenz mit negativer Basis ...): }
      begin
        NOPE := 0 ;
        IOPE := 1 ;
        for I:=IPOSRF to IPOSRL do
        begin
          IF  OPSYMB_P (CSTRIN [I])  THEN
          begin
            IF  (I = IPOSRL)  OR  (CSTRIN [I]   <> '*') OR
                                  (CSTRIN [I+1] <> '*') THEN
              {... um die Operation nur einmal (beim zweiten *) zu zaehlen}
            begin
              IF  HLSTRN [IOPE] = '&'  THEN
              begin
                NOPE := NOPE + 1 ;
                IF  NOPE = NAROPE  THEN
                begin
                  IPOHLF := I ;
                  IPOHLL := I ;
                  IF (I > IPOSRF)  AND (CSTRIN [I-1] = '*') AND
                                       (CSTRIN [I]   = '*') THEN
                                                     IPOHLF := I - 1 ;
      GOTO 9999
                end
              end ;
              IOPE := IOPE + 1
            end
          end
        end
      end
      ELSE IF  (INDERR =  5)  OR  (INDERR = 9)  OR
               (INDERR = 19)  THEN
        {Unzulaessiges Funktionsargument oder unerwarteter
         Substring:}
      begin
        IPOHLF := IPOSRF ;
        IPOHLL := IPOSRL
      end
      ELSE IF  (INDERR = 7)  OR  (INDERR = 8)  THEN
        {Nicht identifizierbares Item oder unerwartetes
         Operationssymbol:}
      begin
        for J:=1 to NLENHS do
        begin
          IF  HLSTRN [J] = ' '  THEN  GOTO 300
        end ;
    300:
        J := J - 1 ;
        {... ist die Anzahl der Operationssymbole und Vorzeichen
             vor dem unidentifizierbaren Item}
        IOPE := 0 ;
        for I:=IPOSRF to IPOSRL do
        begin
          IF  (OPSYMB_P (CSTRIN [I]))  OR  (J = 0)  THEN
          begin
            IF  (J > 0)  AND  (I < IPOSRL)  THEN
            begin
              {... Test auf '**' (soll erst beim zweiten '*'
                   beachtet werden und gezaehlt werden):}
              IF (CSTRIN [I]   = '*')  AND
                 (CSTRIN [I+1] = '*')  THEN  GOTO 400
            end ;
            IOPE := IOPE + 1 ;
            IF  IOPE >= J  THEN
            begin
              IPOHLF := I ;
              IF  INDERR = 7  THEN
              begin
                IF  (J > 0)  OR
                    (LOPBRC_P (CSTRIN [I]))  THEN  IPOHLF := IPOHLF + 1 ;
                IPOHLL := IPOSRL ;
                IF  IPOSRL > I  THEN
                begin
                  for K:=I+1 to IPOSRL do
                  begin
                    IF  (OPSYMB_P (CSTRIN [K]))  OR
                        (LCLBRC_P (CSTRIN [K]))  THEN  IPOHLL := K - 1 ;
                  end
                end
              end
              ELSE
                IPOHLL := IPOHLF ;
              GOTO 9999
            end
          end ;
      400:
        end
      end
      ELSE IF  INDERR = 10  THEN
        {Operationssymbol fehlt:}
      begin
        IPOHLF := IPOSRF + IPOREL - 1 ;
        IPOHLL := IPOSRF + IPOREL
      end
    end ;

9999:
end ;

{============================================================}

{ "PARSE AN REAL ITEM" }

function REALT_P (RSTRIN : PWSTRN  ;
               var IPOS   : Integer ;
                   ILAS   : Integer ;
               var DPITEM : double    ;
               var HLSTRN : PWSTRN) : Boolean ;
var
    I      : Integer ;
    IPODLM : Integer ;
    ERRORC : Integer ;
label
    9000 ,
    9999 ;
begin
    REALT_P := FALSE ;

    IF  PDELIM_P (RSTRIN , IPOS , ILAS , IPODLM)  THEN
    begin
      IF  IPOS = IPODLM  THEN
      begin
        IF  (RSTRIN [IPODLM] <> '+')  AND
            (RSTRIN [IPODLM] <> '-')  THEN
        begin
          IF  IPOHLS > NLENHS  THEN
          begin
            INDERR := 30 ;
      GOTO 9999
          end ;
          HLSTRN [IPOHLS] := '*'        ;
          IPOHLS          := IPOHLS + 1 ;
          INDERR          := 8          ;
          GOTO 9999
        end
      end ;
      IF  (RSTRIN [IPODLM] = '+')  OR
          (RSTRIN [IPODLM] = '-')  THEN
        {... koennte es eine Zahl in der Form  3.2E+12 oder
             5.7D-6 sein:}
      begin
        I := IPODLM - 1 ;
        IF  (RSTRIN [I] = 'E')  OR
            (RSTRIN [I] = 'D')  THEN
          {... wird der naechste Delimiter gesucht und der
               gesamte Bereich als double-Wert interpretiert:}
        begin
          I := IPODLM + 1 ;
          IF  IPOHLS > NLENHS  THEN
          begin
            INDERR := 30 ;
      GOTO 9999
          end ;
          HLSTRN [IPOHLS] := RSTRIN [IPODLM] ;
          IPOHLS          := IPOHLS + 1      ;
          IF  NOT PDELIM_P (RSTRIN , I , ILAS , IPODLM)  THEN  GOTO 9999 ;
        end
      end ;
      Val (Copy (RSTRIN , IPOS , IPODLM-IPOS) , DPITEM , ERRORC) ;
      IF (ERRORC <> 0)  THEN GOTO 9999 ;
      REALT_P := TRUE   ;
      IPOS     := IPODLM ;
      GOTO 9999          ;

      9000:
      INDERR := 7
    end ;

9999:
end ;

{============================================================}

{ EINFUEGEN EINES double-WERTES IN DEN STACK
  ("Tablett" kann auch "zwischengeschoben" werden) }

function INSSTC_P (var STACK  : STACKTYPE ;
                       DPITEM : double      ;
                       ISTACK : Integer)  : Boolean ;
var
    I : Integer ;
begin
    INSSTC_P := FALSE ;

    IF MXSTCK > NSTACK  THEN
    begin
      IF  ISTACK <= NSTACK  THEN
      begin
        for  I:=NSTACK downto ISTACK do
          STACK [I+1] := STACK [I] ;
      end ;
      STACK [ISTACK] := DPITEM     ;
      NSTACK         := NSTACK + 1 ;
      INSSTC_P       := TRUE
    end
    ELSE
      INDERR := 20 ;

end ;

{============================================================}

{ LOESCHEN EINES double-WERTES IM STACK }

procedure REMFST_P (var STACK  : STACKTYPE ;
                        ISTACK : Integer   ) ;
var
    I   : Integer ;
    IOG : Integer ;
begin
    IF  ISTACK < NSTACK  THEN
    begin
      IOG := NSTACK - 1 ;
      for I:=ISTACK to NSTACK do
        STACK [I] := STACK [I+1] ;
    end ;

    NSTACK := NSTACK - 1

end ;

{============================================================}

{ "Parse an constant or "declared function" item

  Der String ISTRIN (IPOS:ILAS) wird untersucht, ob

    -  auf der ersten Position ein Grossbuchstabe ist und

    -  von der ersten bis zur naechsten Delimiterposition
       eine registrierte Konstante oder

    -  eine deklarierte Funktion steht.

   Ergebnis bei COFCIT_P = .TRUE.:  DPITEM und
                                    IPOS (Position nach
                                    dem "Item")          }

function COFCIT_P (ISTRIN : PWSTRN     ;
               var IPOS   : Integer    ;
                   ILAS   : Integer    ;
                   NAMCON : NAMCONTYPE ;
                   DPCON  : DPCONTYPE  ;
                   FCNNAM : FCNNAMTYPE ;
                   FCNVAL : FCNVALTYPE ;
                   IFCPOS : IFCPOSTYPE ;
               var DPITEM : double     ) : Boolean ;
var
    NAME   : String [MathStrLen] ;
    CONIT  : Boolean    ;
    IPODLM : Integer    ;
    I      : Integer    ;
    II     : Integer    ;
    IOG    : Integer    ;
    ICOPOS : Integer    ;
    JROW   : Integer    ;
label
    9000 ;
begin
    CONIT  := FALSE ;

    IF  CHCAPS_P (ISTRIN [IPOS])  THEN
      {... erster Character ist Gross-Buchstabe:}
    begin
      IF  PDELIM_P (ISTRIN , IPOS , ILAS , IPODLM)  THEN
        {... Delimiter auf Position IPODLM}
      begin
        IOG := IPODLM - IPOS ;
        II  := IPOS          ;
        IF  IOG > MathStrLen  THEN  IOG := MathStrLen;
        NAME := '      ' ;
        for I:=1 to IOG do
        begin
          NAME [I] := ISTRIN [II] ;
          II       := II + 1
        end ;
        { NAME(1:IOG) mit IOG .LE. 6 enthaelt auf der ersten Position
          einen Gross-Buchstaben und weitere Zeichen bis zum naechsten
          Delimiter,
   1.)    Ueberpruefung, ob Funktionsvariable: }
        IF  FCNNAM [0] = NAME  THEN
        begin
          DPITEM := FCNVAL [0] ;
          IPOS   := IPODLM     ;
          CONIT  := TRUE       ;
    GOTO 9000
        end ;

{    2.)    Ueberpruefung, ob in Konstantenliste enthalten
          (Konsequenz: Vorrang eines Namens vor Standardfunktion): }
        IF  CONPOS_P (NAMCON , NAME , ICOPOS)  THEN
          { Konstante in Liste auf Position ICOPOS gefunden: }
        begin
          DPITEM := DPCON [ICOPOS] ;
          IPOS   := IPODLM         ;
          CONIT  := TRUE           ;
    GOTO 9000
        end ;

        { Dgl. fuer die deklarierten Funktionen (es werden die ersten
          ICLFUN Funktionen akzeptiert, bei ICLFUN = 0 nur der Name der
          auf Position 0 stehenden Funktionsvariablen, die bei "einfacher
          Formelauswertung" mit einem "unmoeglichen Namen" belegt ist): }

        IF  FCNPOS_P (FCNNAM , NAME , ICOPOS , ICLFUN)  THEN
          {Deklarierte Funktion in Liste auf Position ICOPOS gefunden: }
        begin
          IF  IFCROW >= 3 THEN
          begin
            JROW := 3 ;
            IF  IFCPOS [ICOPOS , JROW] <> 0  THEN  GOTO 9000 ;
          end ;
          {DPITEM = FCNVAL (ICOPOS - 1)
           ... weil untere Grenze 0 in FCNNAM auf Position 1 in NAMPOS_P
              abgebildet wird.
           Diese Fortran-Aussage gilt nicht, weil fuer Pascal FCNPOS_P
           an Stelle von NAMPOS_P verwendet wird, deshalb hier:}
          DPITEM := FCNVAL [ICOPOS] ;
          IPOS   := IPODLM          ;
          CONIT  := TRUE
        end
      end
    end ;

9000:
    COFCIT_P := CONIT

end;

{============================================================}

{ OPERATION MIT ZWEI DOUBLE-PRECISION-WERTEN }

function OPERIT_P (DPITM1 : double ;
                   DPITM2 : double ;
                   OPER   : AnsiChar ;
               var LSUCC  : Boolean) : double ;
var
    LEXINT : Boolean ;
    EPS    : double    ;
    EXP1   : double    ;
    EXP2   : double    ;
    SIG    : double    ;
    XXX    : double    ;
    IITEM2 : Longint ;
    I      : Longint ;

label
    9999 ;

begin
    EPS   := DPONE / (DPEPS * DPRMAX) ;
    LSUCC := TRUE                     ;
    EXP1  := DPZERO                   ;
    EXP2  := DPZERO                   ;
    SIG   := SIGNUM_P (DPONE , DPITM1) * SIGNUM_P (DPONE , DPITM2) ;
    IF (ABS(DPITM1) > EPS) THEN  EXP1 := LOG10 (Abs (DPITM1))    ;
    IF (ABS(DPITM2) > EPS) THEN  EXP2 := LOG10 (Abs (DPITM2))    ;

    IF  OPER = '+'  THEN
    begin
      IF  (SIG  <= DPZERO)                       OR
         ((EXP1 <  DPMXLG) AND (EXP2 < DPMXLG))  THEN
        OPERIT_P := DPITM1 + DPITM2
      ELSE
        begin
          INDERR := 6     ;
          LSUCC  := FALSE
        end
    end
    ELSE IF  OPER = '-'  THEN
    begin
      IF (SIG  >= DPZERO)                      OR
        ((EXP1 <  DPMXLG) AND (EXP2 < DPMXLG)) THEN
        OPERIT_P := DPITM1 - DPITM2
      ELSE
        begin
          INDERR := 6     ;
          LSUCC  := FALSE
        end
    end
    ELSE IF  OPER = '*'  THEN
    begin
      IF  EXP1+EXP2 < DPMXLG  THEN
        OPERIT_P := DPITM1 * DPITM2
      ELSE
        begin
          INDERR := 6     ;
          LSUCC  := FALSE
        end ;
    end
    ELSE IF  OPER = '/'  THEN
    begin
      IF  Abs (DPITM2) > EPS  THEN
      begin
        IF  EXP1-EXP2 < DPMXLG  THEN
          OPERIT_P := DPITM1 / DPITM2
        ELSE
          begin
            INDERR := 6     ;
            LSUCC  := FALSE
          end
      end
      ELSE
      begin
        IF  Abs (DPITM1) > EPS  THEN
          INDERR := 4
        ELSE
          INDERR := 13 ;
        LSUCC := FALSE
      end
    end
    ELSE IF  OPER = '^'  THEN
    begin
      { Ganzzahliger Exponent? }
      IITEM2 := Trunc (Abs (DPITM2) + 0.1)          ;
      LEXINT := Abs (Abs (DPITM2) - IITEM2) < DPEPS ;
      IF  (DPITM1 < DPZERO)  AND  (NOT LEXINT)  THEN
      begin
        INDERR := 11    ;
        LSUCC  := FALSE
      end
      ELSE
      begin
        IF  EXP1*DPITM2 < DPMXLG  THEN
        begin
          IF  LEXINT  THEN
          begin
            IF  EXP1*Abs(DPITM2) >= DPMXLG  THEN
            begin
              OPERIT_P := DPZERO ;
  GOTO 9999
            end ;
            XXX := DPONE ;
            IF  IITEM2 > 0  THEN
            begin
              for I:=1 to IITEM2 do
                XXX := XXX * DPITM1 ;
            end
            ELSE
            begin
              IF  Abs (DPITM1) < DPEPS  THEN
              begin
                INDERR := 12    ;
                LSUCC  := FALSE ;
                GOTO 9999
              end
            end ;
            IF  DPITM2 < DPZERO  THEN
            begin
              IF  Abs (XXX) > EPS  THEN
                XXX := DPONE / XXX
              ELSE
              begin
                INDERR := 6     ;
                LSUCC  := FALSE ;
                GOTO 9999
              end
            end ;
            OPERIT_P := XXX
          end
          ELSE
          begin
            IF  (DPITM2 < DPZERO)  AND  (Abs (DPITM1) < DPEPS) THEN
            begin
              INDERR := 6     ;
              LSUCC  := FALSE ;
              GOTO 9999
            end
            ELSE
              OPERIT_P := Exp (DPITM2 * Ln (DPITM1)) ;
          end
        end
        ELSE
        begin
          INDERR := 6     ;
          LSUCC  := FALSE
        end
      end
    end
    ELSE
      LSUCC := FALSE ;

9999:
end ;

{============================================================}

{ BERECHNUNG DES WERTES EINES AUSDRUCKS

  Verknuepfung von NITEM double-Werten, die im STACK
  stehen, unter Beachtung der Vorrangregeln

  VALEXP_P = .FALSE. ---> Fehler }

function VALEXP_P (var PARSTR : PWSTRN    ;
                   var IFIRST : Integer   ;
                       NITEM  : Integer   ;
                   var STACK  : STACKTYPE ;
                   var DPITEM : double      ;
                   var LMINUS : Boolean)  : Boolean ;
var
    OPERAC : AnsiChar    ;
    OPER   : AnsiChar    ;
    LSUCC  : Boolean ;
    NOP    : Integer ;
    IPO    : Integer ;
    IOPO   : Integer ;
    I      : Integer ;
    J      : Integer ;
    K      : Integer ;
    ISTACK : Integer ;
    X      : double    ;
const
    OPERDS : String [5] = '^/*-+' ;
label
     100 ,
    9000 ,
    9999 ;
begin
    VALEXP_P := FALSE ;

    { Erste aktuelle STACK-Position
      = (Anzahl der double-Werte im STACK vor dem Substring) + 1: }
    ISTACK := NFENCE_P (PARSTR , 1 , IFIRST-1 , '#') + 1 ;

    IF  NITEM = 1  THEN
    begin
      DPITEM := STACK [ISTACK] ;
      IF  LMINUS  THEN  DPITEM := - DPITEM ;
      GOTO 9000
    end ;

    NOP := NITEM  - 1 ;
    IPO := IFIRST + 1 ;

    for K:=1 to 5 do
    begin
      OPERAC := OPERDS [K] ;
      IF  (OPERAC = '-')  AND  (LMINUS)  THEN
        {... sind Potenz- und "Punktrechnungen" abgearbeitet,
             ein eventuell vor dem String stehendes Minuszeichen
             (Indikator: LMINUS) wird auf den ersten Wert uebernommen:}
      begin
        STACK [ISTACK] := - STACK [ISTACK] ;
        LMINUS         :=   FALSE
      end ;
    100 :
      J    := ISTACK ;
      IOPO := IPO    ;
      for  I:=1 to NOP do
      begin
        OPER := PARSTR [IOPO] ;
        IF  OPER <> ' '  THEN
        begin
          IF  OPER = OPERAC  THEN
          begin
            X := OPERIT_P (STACK [J] , STACK [J+1] , OPERAC , LSUCC) ;
            IF  NOT LSUCC  THEN
            begin
              NAROPE := I ;
              GOTO 9999
            end ;
            PARSTR [IOPO]   := ' ' ;
            PARSTR [IOPO+1] := ' ' ;
            REMFST_P (STACK , J)   ;
            STACK [J]       := X   ;
            GOTO 100
          end ;
          J := J + 1
        end ;
        IOPO := IOPO + 2
      end
    end ;

    DPITEM   := STACK [ISTACK] ;
9000:
    VALEXP_P := TRUE           ;

9999:
end ;

{============================================================}

{ ANALYSE EINES KLAMMERLOSEN SUBSTRINGS

  Behandlung eines Substrings, bis eine Zahl entstanden
  ist, die als Parameter A zurueckgegeben wird.
  In PARGTR_P wird der gesamte Substring durch '#'
  ersetzt, PARSTR wird komprimiert und NLENPS korrigiert.

  PARGTR_P = .FALSE. ---> Syntax-Fehler: }

function PARGTR_P (var PARSTR : PWSTRN     ;
                   var NLENPS : Integer    ;
                       IPOBR1 : Integer    ;
                       IPOBR2 : Integer    ;
                   var A      : double       ;
                   var LEXPR  : Boolean    ;
                   var HLSTRN : PWSTRN     ;
                   var STACK  : STACKTYPE  ;
                       DPCON  : DPCONTYPE  ;
                       NAMCON : NAMCONTYPE ;
                       FCNNAM : FCNNAMTYPE ;
                       FCNVAL : FCNVALTYPE ;
                       IFCPOS : IFCPOSTYPE ) : Boolean ;
var
    LMINUS : Boolean ;
    NITEM  : Integer ;
    I      : Integer ;
    IPO    : Integer ;
    IPOS   : Integer ;
    IOG    : Integer ;
    IFIRST : Integer ;
    IPOLAS : Integer ;
    ISTACK : Integer ;
    DPITEM : double    ;
label
     100 ,
     200 ,
    9999 ;
begin
    PARGTR_P := FALSE ;
    NITEM    := 0     ;

    {Anzahl der Operanden und Vorzeichen im aktuellen Substring,
     Position fuer Operanden/Vorzeichenmuster in HLSTRN:}
    NAROPE := 0 ;
    IPOHLS := 1 ;

    for I:=1 to NLENHS do
       HLSTRN [I] := ' ' ;

    IPOS   := IPOBR1 ;
    IPOLAS := IPOBR2 ;

    {String kann mit einem Vorzeichen beginnen:}
    LMINUS := FALSE ;

    IF  PARSTR [IPOS] = '+'  THEN
      begin
        IPOS            := IPOS + 1   ;
        HLSTRN [IPOHLS] := '+'        ;
        IPOHLS          := IPOHLS + 1
      end
    ELSE IF  PARSTR [IPOS] = '-'  THEN
      begin
        LMINUS          := TRUE       ;
        IPOS            := IPOS + 1   ;
        HLSTRN [IPOHLS] := '-'        ;
        IPOHLS          := IPOHLS + 1
      end ;

    IF  IPOS > IPOBR2  THEN
    begin
      INDERR := 9 ;
      GOTO 9999
    end ;

    IFIRST := IPOS ;

    {Naechste aktuelle STACK-Position
     = (Anzahl der double-Werte im STACK vor dem Substring) + 1:}
    ISTACK := NFENCE_P (PARSTR , 1 , IPOBR1-1 , '#') + 1 ;

100:
    IPO := IPOS ;
    IF  IPOS <= IPOLAS  THEN
    begin
      IF  COFCIT_P (PARSTR , IPOS   , IPOLAS , NAMCON ,
                    DPCON  , FCNNAM , FCNVAL , IFCPOS , DPITEM)  THEN
        {Konstante oder deklarierte Funktion oder Funktionsvariable
         gefunden, und Wert als DPITEM gespeichert, IPOS auf Position
         nach dem gefundenen Item veraendert,
         Wert einer Konstanten ---> STACK:}
        begin
          IF  NOT INSSTC_P (STACK , DPITEM , ISTACK)  THEN  GOTO 9999 ;
          LEXPR := TRUE
        end
      ELSE IF  REALT_P (PARSTR , IPOS   , IPOLAS ,
                                  DPITEM , HLSTRN)  THEN
        {double-Wert ---> STACK:}
        begin
          IF  NOT INSSTC_P (STACK , DPITEM , ISTACK)  THEN  GOTO 9999
        end
      ELSE IF  PARSTR [IPOS] = '#'  THEN
        IPOS := IPOS + 1
      ELSE
        {Syntaxfehler:}
        begin
          INDERR := 7 ;
          GOTO 9999
        end
    end
    ELSE
      {Loeschen des letzten Operationssymbols:}
    begin
      IPOHLS := IPOHLS - 1 ;
      IF  IPOHLS > 0  THEN  HLSTRN [IPOHLS] := ' ' ;
      GOTO 200
    end ;

    PARSTR [IPO] := '#'      ;
    IOG          := IPOS - 1 ;
    IF  IOG > IPO  THEN
    begin
      for I:=IPO+1 to IOG do
        PARSTR [I] := ' ' ;
    end ;

    NITEM  := NITEM  + 1 ;
    ISTACK := ISTACK + 1 ;

    IF (PARSTR [IPOS] = '*')  AND  (PARSTR [IPOS+1] = '*')  THEN
      {"Fortran"-Exponenten-Symbol durch "Daechle" ersetzen:}
    begin
      PARSTR [IPOS]   := '^' ;
      PARSTR [IPOS+1] := ' ' ;
      IPOS            := IPOS + 1
    end ;

    IPOS := IPOS + 1 ;

    {'&' steht fuer ein Operationssymbol:}
    HLSTRN [IPOHLS] := '&'        ;
    IPOHLS          := IPOHLS + 1 ;
    GOTO 100 ;

    {Substring-Items durch NITEM Characters '#' ersetzt,
     Verknuepfung der Items unter Beachtung der Vorrangregeln:}

200:
    IF  NITEM > 1  THEN  LEXPR := TRUE   ;
    COMPST_P (PARSTR , IFIRST , NLENPS)  ;
    {... komprimiert PARSTR}

    IF  NOT VALEXP_P (PARSTR , IFIRST , NITEM ,
                      STACK  , DPITEM , LMINUS)  THEN  GOTO 9999 ;
      {... berechnet den Wert}
    A := DPITEM ;

    PARSTR [IFIRST] := ' ' ;
    PARSTR [IPOBR1] := '#' ;
    COMPST_P (PARSTR , IPOBR1 , NLENPS) ;
    PARGTR_P := TRUE ;

9999:
end ;

{============================================================}

{ NORMALISIEREN EINES WINKELFUNKTIONEN-ARGUMENTS
  (Ergebnis liegt immer im Bereich  - pi ...  pi)}

function ARGNOR_P (ARG : double) : double ;

var
    PI2 : double ;
    AA  : double ;
    DN  : double ;

begin
    PI2 := DOPRPI + DOPRPI ;
    DN  := INT (Abs (ARG) / PI2) ;
    IF  ARG > DPZERO  THEN
      begin
        AA := ARG - PI2 * DN ;
        IF  AA > DOPRPI  THEN  AA := AA - PI2 ;
      end
    ELSE
      begin
        AA := ARG + PI2 * DN ;
        IF  AA < - DOPRPI  THEN  AA := AA + PI2
      end ;

    ARGNOR_P := AA

end ;

{============================================================}

{ BERECHNUNG DES FUNKTIONSWERTES FUNTYP (FUNARG) }

function VALFUN_P (FUNTYP : FUNTYPTYPE ;
                   FUNARG : double       ;
               var DPITEM : double)      : Boolean ;
var
    LSUCC  : Boolean ;
    EPOWX  : double    ;
    EPOWMX : double    ;
    XXX    : double    ;
    AA     : double    ;
    IERRPX : Integer ;
    IERPMX : Integer ;
    I      : Integer ;
    IOG    : Longint ;

label
    1000 ,
    2000 ,
    9000 ,
    9999 ;

begin
    VALFUN_P := FALSE ;
    LOVFLW   := FALSE ;

    IF  (FUNTYP = 'EXP ')  OR  (FUNTYP = 'SINH')  OR
        (FUNTYP = 'COSH')  OR  (FUNTYP = 'TANH')  OR
        (FUNTYP = 'COTH')  THEN
    begin
      IERRPX := 0 ;
      IERPMX := 0 ;
      IF  DPLGE * Abs (FUNARG) < DPMXLG  THEN
        begin
          EPOWX  := Exp (  FUNARG) ;
          EPOWMX := Exp (- FUNARG)
        end
      ELSE
        begin
          {... kann (oh, Turbo-Pascal!) WEDER Exp(FUNARG)
               noch Exp(-FUNARG) berechnet werden}
          IF  FUNARG > 0  THEN
            begin
              EPOWMX := DPZERO ;
              IERRPX := 1
            end
          ELSE
            begin
              EPOWX  := DPZERO ;
              IERPMX := 1
            end
        end
    end ;

    IF  FUNTYP = 'EXP '  THEN
    begin
      IF  IERRPX = 0  THEN
        DPITEM := EPOWX
      ELSE
      begin
        INDERR := 19   ;
        LOVFLW := TRUE ;
        GOTO 9999
      end
    end
    ELSE IF  FUNTYP = 'SQRT'  THEN
    begin
      IF  FUNARG < DPZERO  THEN
      begin
        INDERR := 5 ;
        GOTO 9999
      end ;
      DPITEM := Sqrt (FUNARG)
    end
    ELSE IF  FUNTYP = 'ABS '  THEN
      DPITEM := Abs (FUNARG)
    ELSE IF  FUNTYP = 'SIGN'  THEN
      DPITEM := SIGNUM_P (DPONE , FUNARG)
    ELSE IF  FUNTYP = 'SWON'  THEN
      IF  FUNARG < DPZERO  THEN
        DPITEM := DPZERO
      ELSE
        DPITEM := DPONE
    ELSE IF  FUNTYP = 'SWOF'  THEN
      IF  FUNARG < DPZERO  THEN
        DPITEM := DPONE
      ELSE
        DPITEM := DPZERO
    ELSE IF  FUNTYP = 'FAK '  THEN
    begin
      IOG := Round (FUNARG) ;
      IF  IOG < 0  THEN
        begin
          INDERR := 5 ;
          GOTO 9999
        end ;
      DPITEM := DPONE ;
      for  I:=1  to  IOG  do
      begin
        XXX := I ;
        XXX := OPERIT_P (DPITEM , XXX , '*' , LSUCC) ;
        IF  LSUCC THEN
          DPITEM := XXX
        ELSE
        begin
          INDERR := 19   ;
          LOVFLW := TRUE ;
          GOTO 9999
        end
      end
    end
    ELSE IF  FUNTYP = 'SINH'  THEN
    begin
      IF  (IERRPX = 0)  AND  (IERPMX = 0)  THEN
        DPITEM := (EPOWX - EPOWMX) / 2.0
      ELSE
      begin
        INDERR := 19   ;
        LOVFLW := TRUE ;
        GOTO 9999
      end
    end
    ELSE IF  FUNTYP = 'COSH'  THEN
    begin
      IF  (IERRPX = 0)  AND  (IERPMX = 0)  THEN
        DPITEM := (EPOWX + EPOWMX) / 2.0
      ELSE
      begin
        INDERR := 19   ;
        LOVFLW := TRUE ;
        GOTO 9999
      end
    end
    ELSE IF  FUNTYP = 'TANH'  THEN
    begin
      IF  (IERRPX = 1)  THEN
        DPITEM :=   1.0
      ELSE IF  (IERPMX = 1)  THEN
        DPITEM := - 1.0
      ELSE
        DPITEM := (EPOWX - EPOWMX) / (EPOWX + EPOWMX)
    end
    ELSE IF  FUNTYP = 'COTH'  THEN
    begin
      IF  (IERRPX = 1)  THEN
        DPITEM :=   1.0
      ELSE IF  (IERPMX = 1)  THEN
        DPITEM := - 1.0
      ELSE
        begin
          XXX := OPERIT_P (EPOWX + EPOWMX , EPOWX - EPOWMX , '/' , LSUCC) ;
          IF  LSUCC  THEN
            DPITEM := XXX
          ELSE
          begin
            LOVFLW := TRUE ;
            INDERR := 19   ;
            GOTO 9999
          end ;
        end
    end
    ELSE IF  FUNTYP = 'ASNH'  THEN
    begin
      XXX := OPERIT_P (FUNARG , FUNARG , '*' , LSUCC) ;
      IF  NOT LSUCC  THEN  GOTO 9999 ;
      XXX := Sqrt (XXX + DPONE) ;
      XXX := OPERIT_P (XXX , FUNARG , '+' , LSUCC) ;
      IF  NOT LSUCC  THEN  GOTO 9999 ;
      IF (XXX < DEPSLN) THEN
      begin
        LOVFLW := TRUE ;
        INDERR := 19   ;
        GOTO 9999
      end ;
      DPITEM := Ln (XXX)
    end
    ELSE IF  FUNTYP = 'ACSH' THEN
    begin
      IF  FUNARG < DPONE  THEN
      begin
        INDERR := 5 ;
        GOTO 9999
      end ;
      XXX := OPERIT_P (FUNARG , FUNARG , '*' , LSUCC) ;
      IF  NOT  LSUCC  THEN  GOTO 9999 ;
      XXX := SQRT (XXX - DPONE) ;
      XXX := OPERIT_P (XXX , FUNARG , '+' , LSUCC) ;
      IF  NOT LSUCC  THEN  GOTO 9999 ;
      DPITEM := Ln (XXX)
    end
    ELSE IF  FUNTYP = 'ATNH'  THEN
    begin
      IF  Abs (FUNARG) >= DPONE  THEN
      begin
        INDERR := 5 ;
        GOTO 9999
      end ;
      XXX := OPERIT_P (DPONE+FUNARG , DPONE-FUNARG , '/' , LSUCC) ;
      IF  NOT  LSUCC  THEN  GOTO 9999 ;
      DPITEM := Ln (XXX) / 2.0
    end
    ELSE IF  FUNTYP = 'ACTH'  THEN
    begin
      IF  Abs (FUNARG) <= DPONE  THEN
      begin
        INDERR := 5 ;
        GOTO 9999
      end ;
      XXX := OPERIT_P (FUNARG+DPONE , FUNARG-DPONE , '/' , LSUCC) ;
      IF  NOT LSUCC  THEN  GOTO 9999 ;
      DPITEM := Ln (XXX) / 2.0
    end
    ELSE IF  FUNTYP = 'LN  ' THEN
    begin
      IF  FUNARG < DEPSLN  THEN
      begin
        IF  Abs (FUNARG) <= DEPSLN  THEN
          begin
            LOVFLW := TRUE ;
            INDERR := 19
          end
        ELSE
          INDERR := 5 ;
        GOTO 9999
      end ;
      DPITEM := Ln (FUNARG)
    end
    ELSE IF  FUNTYP = 'LG  '  THEN
    begin
      IF  FUNARG < DEPSLG  THEN
      begin
        IF  Abs (FUNARG) <= DEPSLG  THEN
          begin
            LOVFLW := TRUE ;
            INDERR := 19
          end
        ELSE
          INDERR := 5 ;
        GOTO 9999
      end ;
      DPITEM := Ln (FUNARG) * DPLGE
    end
    ELSE
      GOTO 1000 ;

    GOTO 9000 ;

1000:
    IF  (FUNTYP = 'ASIN')  OR  (FUNTYP = 'ACOS')  THEN
    begin
      IF  Abs (FUNARG) > DPONE  THEN
      begin
        INDERR := 5 ;
        GOTO 9999
      end ;
      XXX := Sqrt (DPONE - FUNARG * FUNARG) ;
      XXX := OPERIT_P (DPONE , DPONE - FUNARG * FUNARG , '/' , LSUCC) ;
      IF  LSUCC  THEN
        DPITEM := ArcTan (XXX)
      ELSE
        begin
          IF  FUNARG > DPZERO  THEN
            DPITEM :=   DOPRPI
          ELSE
            DPITEM := - DOPRPI
        end ;
      IF  FUNTYP = 'ACOS'  THEN  DPITEM := DOPRPI / 2.0 - DPITEM
    end
    ELSE IF  FUNTYP = 'ATAN'  THEN
      DPITEM := ArcTan (FUNARG)
    ELSE IF  FUNTYP = 'ACOT'  THEN
    begin
      DPITEM := DOPRPI / 2.0 - ArcTan (FUNARG)   ;
      IF  DPITEM < DPZERO  THEN  DPITEM := DPZERO
    end
    ELSE
      GOTO 2000 ;

    IF  IGRAD = auDegree  THEN begin
      XXX := OPERIT_P (DPITEM , PID180 , '/' , LSUCC) ;
      IF  NOT  LSUCC  THEN  GOTO 9999 ;
      DPITEM := XXX
      end
    else if IGrad=auGrad then begin
      XXX := OPERIT_P (DPITEM , PID200 , '/' , LSUCC) ;
      IF  NOT  LSUCC  THEN  GOTO 9999 ;
      DPITEM := XXX
      end ;
    GOTO 9000 ;

2000:
    IF  IGRAD = auDegree  THEN AA := FUNARG * PID180
    ELSE IF  IGRAD = auGrad  THEN AA := FUNARG * PID200
    else AA := FUNARG ;

    IF  Abs (AA) > DMXWFA  THEN
      { ... Argument zu gross: }
    begin
      INDERR := 5 ;
GOTO 9999
    end ;

    AA := ARGNOR_P (AA) ;
    {... normalisiert das Argument auf das Intervall  - PI .. PI}

    IF  FUNTYP = 'SIN '  THEN
      DPITEM := Sin (AA)
    ELSE IF  FUNTYP = 'COS '  THEN
    begin
      XXX    := Sin (AA) ;
      DPITEM := Sqrt (DPONE - XXX * XXX) ;
      IF  Abs (AA) > DOPRPI / 2.0  THEN  DPITEM := - DPITEM
    end
    ELSE IF  FUNTYP = 'TAN ' THEN
    begin
      IF  Abs (Abs (AA) - DOPRPI / 2.0) < DEPSTN  THEN
      begin
        INDERR := 19   ;
        LOVFLW := TRUE ;
        GOTO 9999
      end ;
      XXX    := Sin (AA) ;
      DPITEM := OPERIT_P (XXX , DPONE - XXX * XXX , '/' , LSUCC) ;
      IF  NOT LSUCC  THEN  GOTO 9999 ;
      IF  Abs (AA) > DOPRPI / 2.0  THEN  DPITEM := - DPITEM
    end
    ELSE IF  FUNTYP = 'COT '  THEN
    begin
      IF  (Abs (AA) < DEPSTN)  OR
          (Abs (Abs (AA) - DOPRPI) < DEPSTN)  THEN
      begin
        INDERR := 19   ;
        LOVFLW := TRUE ;
        GOTO 9999
      end ;
      XXX    := Sin (AA) ;
      DPITEM := OPERIT_P (DPONE - XXX * XXX , XXX , '/' , LSUCC) ;
      IF  NOT LSUCC  THEN  GOTO 9999 ;
      IF  Abs (AA) > DOPRPI / 2.0  THEN  DPITEM := - DPITEM
    end
    ELSE
      GOTO 9999 ;

9000:
    VALFUN_P := TRUE ;

9999:
end ;

{============================================================}

{ ANALYSE EINES VON KLAMMERN UMSCHLOSSENEN SUBSTRINGS

  Behandlung eines Substrings, bis eine Zahl entstanden
  ist, die im STACK auf die Position eingetragen
  wird. In PARSUB_P wird der gesamte Substring
  einschliesslich der ihn umschliessenden Klammern
  und eines vorangehenden Funktionsaufrufs durch '#'
  ersetzt, PARSTR wird komprimiert und NLENPS korrigiert.

  PARSUB_P = .FALSE. ---> Syntax-Fehler }

function PARSUB_P (var PARSTR : PWSTRN     ;
                   var NLENPS : Integer    ;
                       IPOBR1 : Integer    ;
                       IPOBR2 : Integer    ;
                   var HLSTRN : PWSTRN     ;
                   var STACK  : STACKTYPE  ;
                       DPCON  : DPCONTYPE  ;
                       NAMCON : NAMCONTYPE ;
                       FCNNAM : FCNNAMTYPE ;
                       FCNVAL : FCNVALTYPE ;
                       IFCPOS : IFCPOSTYPE ) : Boolean ;
var
    LEXPR  : Boolean    ;
    FUNTYP : FUNTYPTYPE ;
    X      : double       ;
    AResult : double       ;
    I      : Integer    ;
    IPOS   : Integer    ;

label
    9999 ;

begin
    PARSUB_P := FALSE ;

    IF  NOT PARGTR_P (PARSTR , NLENPS , IPOBR1 , IPOBR2 ,
                           X , LEXPR  , HLSTRN , STACK  ,
                       DPCON , NAMCON , FCNNAM , FCNVAL ,
                                        IFCPOS)  THEN  GOTO 9999 ;
      {... ermittelt aus dem klammerlosen Substring PARSTR
           (Positionen IPOBR1 ... IPOBR2) das Ergebnis.
           PARGTR_P = .FALSE. ---> Syntax-Fehler }

    IF  FUNCIT_P (PARSTR , IPOBR1 , IPOS , FUNTYP)  THEN
      {... '(#)' steht nach einem Funktionsaufruf, der
           bei IPOS beginnt, Berechnung des Funktionswertes:}
      begin
        IF  NOT VALFUN_P (FUNTYP , X , AResult)  THEN  GOTO 9999
      end
    ELSE
      begin
        IPOS   := IPOBR1 - 1 ;
        AResult := X
      end ;

    for i:=IPOS to IPOBR1+1 do
        PARSTR [I] := ' ' ;

    PARSTR [IPOS] := '#' ;
    {... ueberschreibt Substring mit '#      '}

    COMPST_P (PARSTR , IPOS , NLENPS) ;
    {... komprimiert PARSTR}

    NSTACK := NFENCE_P (PARSTR , 1 , IPOS , '#') ;
    STACK [NSTACK] := AResult     ;
    PARSUB_P       := TRUE       ;
    NBRSOL         := NBRSOL + 1 ;

9999:
end ;

{============================================================}

{ Umspeichern der Character des Strings EXSTRN auf die
  ersten Positionen des Character-Arrays PARSTR, dessen
  uebrige Elemente mit Blanks aufgefuellt werden (PARSTR
  hat NCHARS Elemente) }

procedure STTOAR_P (EXSTRN : AnsiString ;
                var PARSTR : PWSTRN ;
                    NCHARS : Integer) ;
var
      i    : Integer ;
      nlen : Integer ;

begin
      nlen := Length (EXSTRN) ;

      for i:=1 to NCHARS do
      begin
        if  i <= nlen  then
          PARSTR [i] := EXSTRN [i]
        else
          PARSTR [i] := ' '
      end ;

end ;

{============================================================}

procedure GTDVFS_P (EXSTRN : AnsiString     ;
                    PARSTR : PWSTRN     ;
                    HLSTRN : PWSTRN     ;
                    NLENWS : Integer    ;
                var STACK  : STACKTYPE  ;
                var DPCON  : DPCONTYPE  ;
                var NAMCON : NAMCONTYPE ;
                var IERRIN : Integer    ;
                var IPERRF : Integer    ;
                var IPERRL : Integer    ;
                var DVALUE : double) ;
var
    LEXPR  : Boolean    ;
    NEXSLN : Integer    ;
    NLENPS : Integer    ;
    IPOBR1 : Integer    ;
    IPOBR2 : Integer    ;
    RESULT : double       ;
    FCNNAM : FCNNAMTYPE ;
    FCNVAL : FCNVALTYPE ;
    IFCPOS : IFCPOSTYPE ;
    {... als Dummies fuer die Unterprogramm-Aufrufe, die auch
         von Funktionsauswerte-Unterprogrammen gerufen werden.}

label
     100 ,
    9000 ,
    9999 ;

begin
    FCNNAM [0] :=  '######'   ;
    {... damit dieser "Name" unmoeglich der Name der Funktionsvariablen
         sein kann}

    {Keine Funktionsabarbeitung:}
    ICLFUN := 0               ;

    NEXSLN := Length (EXSTRN) ;
    NLENHS := NLENWS          ;
    NAROPE := 0               ;
    NBRSOL := 0               ;
    INDERR := 0               ;
    IPOHLF := 1               ;
    IPOHLL := NEXSLN          ;

    IF NEXSLN > NLENHS THEN
    begin
      INDERR := 30 ;
      GOTO 9999
    end ;

    LEXPR := FALSE ;
    {... String ist kein "Expression" (Default)}

    STTOAR_P (EXSTRN , HLSTRN , NLENWS) ;
    MKPARS_P (HLSTRN , PARSTR , NEXSLN) ;
    {... speichert EXSTRN auf PARSTR, wobei geschweifte und
         eckige Klammern zu runden Klammern und Klein- zu
         Grossbuchstaben werden.}

    NSTACK := 0      ;
    NLENPS := NEXSLN ;

    COMPST_P (PARSTR , 1 , NLENPS) ;

    IF  NLENPS <= 0  THEN
    begin
      INDERR := 100 ;
GOTO 9999
    end ;

   { Ueberpruefen des Strings auf Verwendung der zulaessigen
     Characters, der Items (Konstanten, Funktionen,
     und Zahlen), der Klammerstruktur und der
     Struktur der Operationssymbole: }
    IF  (NOT CHRCHK_P (PARSTR , NLENPS)) OR
        (NOT PARCHK_P (PARSTR , NLENPS)) OR
        (NOT OPSCHK_P (PARSTR , NLENPS)) OR
        (NOT ITMCHK_P (PARSTR , NLENPS , NAMCON ,
                                         FCNNAM)) THEN
    begin
      STTOAR_P (EXSTRN , HLSTRN , NLENWS) ;
      CRRHLP_P (HLSTRN , NEXSLN) ;
      {... korrigiert die ermittelten Highlight-Positionen
           IPOHLF und IPOHLL durch Suchen nach Blanks und
           TABs im Originalstring EXSTRN}
GOTO 9999
    end ;

100:
    IF  NOT PARBRC_P (PARSTR , NLENPS , IPOBR1 , IPOBR2)  THEN
      {... sucht in PARSTR nach dem ersten Klammerpaar des tiefsten
           Levels, das einen Substring mit den Character-Positionen
           IPOBR1 ... IPOBR2 umschliesst (kein Klammerpaar gefunden
           ---> IPOBR1 = 0).
           PARBRC_P = .FALSE. ---> Syntax-Fehler }
        GOTO 9000 ;

    IF  IPOBR1 > 0  THEN
      begin
        {String ist ein "Expression":}
        LEXPR := TRUE ;
        IF  PARSUB_P (PARSTR , NLENPS , IPOBR1 , IPOBR2 , HLSTRN ,
                      STACK  , DPCON  , NAMCON , FCNNAM , FCNVAL ,
                                                 IFCPOS)  THEN  GOTO 100 ;
          {... behandelt den Substring, bis eine Zahl entstanden ist,
               die im STACK eingetragen wird.
               In PARSUB_P wird der gesamte Substring durch '#' ersetzt,
               PARSUB_P wird komprimiert und NLENPS korrigiert.
               PARSUB_P = .FALSE. ---> Syntax-Fehler: }
        GOTO 9000
      end
    ELSE
      begin
        IF  NOT PARGTR_P (PARSTR , NLENPS ,      1 , NLENPS ,
                          RESULT , LEXPR  , HLSTRN , STACK  ,
                          DPCON  , NAMCON , FCNNAM , FCNVAL ,
                                            IFCPOS)  THEN  GOTO 9000
          {... ermittelt aus dem klammerlosen String PARSTR (Laenge:
               NLENPS) das Ergebnis.
               PARGTR_P = .FALSE. ---> Syntax-Fehler }
      end ;

    DVALUE := RESULT ;

    GOTO 9999 ;

    { Fehler, Ermitteln der Highlight-Region im Originalstring: }

9000:
    STTOAR_P (EXSTRN , PARSTR , NLENWS) ;
    MKHLRG_P (PARSTR , HLSTRN , NEXSLN) ;

9999:
    IERRIN := INDERR ;
    IPERRF := IPOHLF ;
    IPERRL := IPOHLL
end ;

{============================================================}
function Calculate (const Expr : Ansistring; var Value : double) : boolean;
begin

  GTDVFS_P (Expr , PARSTX , HLSTRX , NLENWS ,
            STACK  , DPCON  , NAMCON ,
            ErrCode, ErrPos, ErrLen, VALUE);
  Result:=errCode=0;
  end;

(* Großbuchstaben und Leerstellen am Ende ergänzen *)
function ProcStr (const S : TConstString) : TConstString;
var
  i  : integer;
begin
  Result:=s;
  for i:=1 to length(Result) do Result[i]:=UpCase(Result[i]);
  for i:=succ(length(Result)) to MathStrLen do Result:=Result+' ';
  end;

function CalcFunction (const Expr : Ansistring; XValue : double; AngUni : integer;
                       const Constants : TConstArr;
                       var YValue : double) : boolean;
var
  i,n : integer;
begin
  DPCON[3]:=XValue;
  for i:=BASCON+1 to MXCONS do begin
    NAMCON[I]:='      '; DPCON[I]:=DPZERO;  // reset
    end;
  n:=length(Constants)+BASCON;
  if n>MXCONS then NDFCON:=MXCONS else NDFCON:=n;
  for i:=0 to length(Constants)-1 do with Constants[i] do begin
    n:=i+BASCON+1;
    if n<=MXCONS then begin
      NAMCON[n]:=ProcStr(ConstName); DPCON[n]:=ConstValue;  // set value
      end;
    end;
  IGrad:=TAngularUnits(AngUni);
  Result:=Calculate (Expr,YValue);
  end;

function CalcErrorCode : integer;
begin
  Result:=ErrCode;
  end;

function CalcErrorPos : integer;
begin
  Result:=ErrPos;
  end;

function CalcErrorLength : integer;
begin
  Result:=ErrPos-ErrLen+1;
  end;

function CalcErrorText : string;
begin
  Result:=gterrm_p(ErrCode);
  end;

procedure CalcSetAngleUnits (Mode : TAngularUnits);
begin
  IGRAD:=Mode;
  end;

function CalcGetAngleUnits : TAngularUnits;
begin
  Result:=IGRAD;
  end;

procedure CalcSetConstant (const Name : TConstString; Value : double);
begin

  end;

{============================================================}

var
    i : Integer ;
begin
  {Initialisierung:}
  DPZERO := 0.0E0    ;
  DPONE  := 1.0E0    ;
  DPRMAX := MaxDouble;
  DPMXLG := 307    ;
  DPEPS  := 1E-7   ;
  DEPSLG := 1E-35  ;
  DEPSLN := 1E-35  ;
  DEPSTN := 1E-7   ;
  DMXWFA := 1E8    ;

  MAXSTC := MXSTCK  ;
  MAXCON := MXCONS  ;
  MAXFUN := MXFUNC  ;
  NCFUST := NCFCST  ;
  IGRAD  := auDegree;
  ErrCode:=0; ErrPos:=0; ErrLen:=0;

  for I:=1 to MXCONS do begin
    NAMCON [I] := '      ' ;
    DPCON  [I] := DPZERO
    end ;

  for I:=1 to NLENWS do begin
    PARSTX [I] := ' ' ;
    HLSTRX [I] := ' '
    end ;

  for I:=1 to MXSTCK do STACK [I] := DPZERO ;

  for I:=0 to MXFUNC do begin
    FCNNAM [I]     := '      ' ;
    IFCPOS [I , 1] := 0
    end ;

  FCNNAM [0] := 'X     ' ;

  NSTACK     :=  0          ;
  BASCON     :=  3;
  NDFCON     :=  BASCON;
  NAMCON [1] := 'PI    '    ;
  NAMCON [2] := 'E     '    ;
  NAMCON [3] := 'X     '    ;
  DPCON  [1] := Pi          ;
  DPCON  [2] := Exp (DPONE) ;
  DPCON  [3] := 1           ;

  NDFFUN     := 0           ;

  DPLGE      := DPONE/Ln(10) ;
  DOPRPI     := DPCON [1];
  PID180     := DOPRPI/180;
  PID200     := DOPRPI/200;

end.

