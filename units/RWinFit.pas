(* Mathematische Routinen zur Approximation von Messwerten
   =======================================================
   
   © J. Rathlev, IEAP, Uni-Kiel, (rathlev(a)physik.uni-kiel.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Vers. 1 - Jun. 2001
   Vars. 2 - Apr. 2012: mit dyn. Arrays, für RPlot angepasst
   *)

unit RWinFit;

interface

const
  MaxDegree = 10;
  IterMax   : integer = 50;
  Precision : double = 1E-15;    (* Determinantengrenze für die Iterationen *)

type
  TMatrix = array of array of double;
  TVector = array of double;
  TIntVector = array of integer;

  TFitResult = record
    Degree  : integer; // = 0 noch nicht berechnet
    Sigma   : double;
    Coeffs  : TVector;
    end;

function Horner (const A : TVector; N  : integer; X  : double) : double; overload;
function Horner (const FitResult : TFitResult; x : double) : double; overload;

procedure LinEqSolve (const SMAT : TMatrix;
                      const B    : TVector;
                      N          : integer;
                      var A      : TVector;
                      var DET    : double;
                      var ITER   : integer);

function PolFit (Degree,n     : integer;
                 const x,y    : TVector;
                 var PolKoeff : TVector;
                 var Sigma    : double) : boolean;

function CubSpline (NP,Smooth   : integer;
                    const XA,YA : TVector;
                    var YS      : TVector;
                    var CK      : TMatrix)  : integer;
                    
function CubSplineVal (NP             : integer;
                       X              : double;
                       const XA,YS    : TVector;
                       const CK       : TMatrix;
                       var Y          : double) : integer;

function CubSplineFit (NP,Smooth   : integer;
                       const XA,YA : TVector) : integer;

function CubSplineFitValue (x : double) : double;


implementation
{------------------------------------------------------------------}
(* Berechnung eines Polynoms nach dem Hornerschema
   A = Polynomkoeffizienten
   N = Grad des Polynoms
   X = Wert
   HORNER = Pol(X)
   J. Rathlev, März 1988 *)
function Horner (const A : TVector;
                 N       : integer;
                 X       : double) : double;
var
  I  : integer;
  Y  : double;
begin
  if (X <> 0) then begin
    Y:=A[N];
    for I:=pred(N) downto 0 do Y:=Y*X+A[I];
    Result:= Y;
    end
  else Result:=A[0];
  end;

function Horner (const FitResult : TFitResult; x : double) : double;
begin
  with FitResult do Result:=Horner (Coeffs,Degree,x);
  end;

{------------------------------------------------------------------}
(* Unterroutine zum Loesen von linearen Gleichungssystemen
   nach dem Couffignal Verfahren
       Uebergabeparameter:
       SMAT = Systemmatrix [Zeilenindex,Spaltenindex]
       B = rechte Seite    (SMAT und B werden nicht verändert)
       N = Ordnung des Systems
       A = Loesungsvektor
       DET = Determinante
       ITER = Anzahl der Iterationen zur Reduzierung der Rundungsfehler
            =  0 ==> Die Determinante ist zu klein (d.h. die Lösung
                     ist unkorrigiert)
            = -1 ==> Die Determinante verschwindet, keine Lösung
   Die Ordnung des Gleichungssystem ist beliebig (<=25)*)
procedure LinEqSolve (const SMAT : TMatrix;
                      const B    : TVector;
                      N          : integer;
                      var A      : TVector;
                      var DET    : double;
                      var ITER   : integer);

  function AMAX (x,y : double) : double;
  begin
    if x<y then amax:=y else amax:=x;
    end;

var
  M            : TMatrix;
  KS,KZ        : TIntVector;
  Q0,Q1,Q2     : double;
  I0,I1,I2,N1,
  J0,J1,J2     : integer;
  ende         : boolean;

begin
  Iter:=-1;
  N1:=N+1;
  DET := 1.0;
  SetLength(M,N,N+2);
  SetLength(KS,N);
  SetLength(KZ,N);
(* UMSPEICHERN IN DIE MATRIX M *)
  for I1:=0 to N-1 do
    for I2:=0 to N-1 do M[I1,I2]:=SMAT[I1,I2];
  for I1:=0 to N-1 do M[I1,N]:=-B[I1];
  for I1:=0 to N-1 do begin
    KS[I1]:=-1; KZ[I1]:=-1;
    end;
  for I0:=0 to N-1 do begin
 (* ERMITTLUNG DES PIVOT-ELEMENTS *)
    Q0:=2.0;
    for I1:=0 to N-1 do
      IF (KZ[I1]<0) then begin
        Q2:=0.0;
        for I2:=0 to N-1 do
          IF (KS[I2]<0) then begin
            Q1:=ABS(M[I1,I2]);
            IF (Q1 > Q2) then begin
              Q2:=Q1; J0:=I2;
              end;
            end;
        Q1:=0.0;
        ende:=abs(Q2)<Precision;
        if ende then break; (* Pivot Elem. zu klein *)
        for I2:=0 to N-1 do
          IF (KS[I2]<0) and (J0<>I2) then
            Q1:=AMAX(Q1,ABS(M[I1,I2]/Q2));
        IF (Q0 > Q1) then begin
          Q0:=Q1; J1:=I1; J2:=J0;
          end;
        end;
    if ende then break;
    KZ[J1]:=J2;             (* J1 ZEILENNUMMERN *)
    KS[J2]:=J1;             (* J2 SPALTENNUMMERN *)
    Q0:=M[J1,J2];           (* Pivotelement *)
  (* LOESEN DES GLEICHUNGSSYSTEMS *)
    DET:=DET*Q0;            (* DETERMINANTE *)
  (* SETZEN DER SPALTE N+2 FUER DIE INV. MATR. *)
    for I1:=0 to N-1 do M[I1,N1]:=0.0;
    M[J1,N1]:=-1.0;
  (* Zeile J1 bearbeiten *)
    for I1:=0 to N1 do M[J1,I1]:=-M[J1,I1]/Q0;
  (* Spalte J2 eliminieren *)
    for I1:=0 to N-1 do IF (I1 <> J1) then begin
      Q0:=M[I1,J2];
      for I2:=0 to N1 do M[I1,I2]:=M[I1,I2]+Q0*M[J1,I2];
      end;
  (* UMSPEICHERN DER SPALTE N+2 NACH J2 *)
    for I1:=0 to N-1 do M[I1,J2]:=M[I1,N1];
    end;
  if not ende then begin
  (* ORDNEN DER LOESUNG *)
    for I1:=0 to N-1 do A[KZ[I1]]:=M[I1,N];
    IF (ABS(DET) > precision) then begin
    (* KORREKTUR DER RUNDUNGSFEHLER *)
      I0:=0;
      repeat
        for I1:=0 to N-1 do begin
          Q0:=0.0;
          for I2:=0 to N-1 do Q0:=Q0+SMAT[I1,I2]*A[I2];
          M[I1,N1]:=Q0-B[I1];
          end;
        Q1:=0.0;
        for I1:=0 to N-1 do begin
          Q0:=0.0;
          for I2:=0 to N-1 do Q0:=Q0+M[I1,I2]*M[KS[I2],N1];
          J0:=KZ[I1];
          A[J0]:=A[J0]-Q0;          (* Q0 = KORREKTUR *)
          if Q0<>0 then Q1:=AMAX(Q1,ABS(Q0/A[J0]));
          end;
        inc(I0); ITER:=I0;
        ende:=abs(Q1)<=precision;
        until (I0>IterMax) or ende;
      end
    else ITER:=0;
    end
  else ITER:=-1;
  M:=nil; KS:=nil; KZ:=nil;
  end;

{------------------------------------------------------------------}
(* Approximation mit Polynom nach Gauss
   Degree = Grad des Polynoms
   n      = Anzahl der Wertepaare
   x,y    = Wertepaare
   PolCoeff = berechnete Polynomkoeffizienten
   Sigma    = Standardabweichung *)
function PolFit (Degree,n     : integer;
                 const x,y    : TVector;
                 var PolKoeff : TVector;
                 var Sigma    : double) : boolean;
var
  tx,sx,sy,mx,my : double;
  NVek           : TVector;
  i,j,d2         : integer;
  SMat           : TMatrix;
  BVek,LVek      : TVector;
begin
  if (n>Degree) and (Degree<MaxDegree) then begin
    (* Mittelwerte berechnen *)
    sx:=0; sy:=0;
    for i:=0 to n-1 do begin
      sx:=sx+x[i]; sy:=sy+y[i];
      end;
    mx:=sx/n; my:=sy/n;
    if mx=0 then mx:=1; // keine Skalierung
    if my=0 then my:=1;
   (* Gauß-Matrix berechnen *)
    d2:=2*Degree;
    SetLength(NVek,d2+1);
    SetLength(BVek,Degree+1);
    SetLength(LVek,Degree+1);
    SetLength(SMat,Degree+1,Degree+1);
    for i:=0 to Degree do BVek[i]:=0;
    for i:=0 to d2-1 do NVek[i]:=0;
    for i:=0 to n-1 do begin
      sx:=x[i]/mx; sy:=y[i]/my;
      tx:=sx;
      for j:=0 to d2-1 do begin
        NVek[j+1]:=NVek[j+1]+sx;
        if j<=Degree then BVek[j]:=BVek[j]+sy;
        sx:=sx*tx; sy:=sy*tx;
        end;
      end;
    NVek[0]:=n;
    for i:=0 to Degree do begin    // Zeilen
      for j:=0 to Degree do SMat[i,j]:=NVek[i+j];
      end;
    NVek:=nil;
    (* Gleichungssystem lösen *)
    LinEqSolve(SMat,BVek,Degree+1,LVek,sx,i);
    if i>=0 then begin
      (* Normierung zurückrechnen *)
      tx:=1;
      for i:=0 to Degree do begin
        PolKoeff[i]:=LVek[i]*my/tx; tx:=tx*mx;
        end;
      (* Berechnung der Fehlerquadrate *)
      sx:=0;
      for i:=0 to n-1 do sx:=sx+sqr(y[i]-Horner(PolKoeff,Degree,x[i]));
      Sigma:=sqrt(sx/pred(n)/n);
      Result:=true;
      end
    else Result:=false;
    BVek:=nil; LVek:=nil; SMat:=nil;
    end
  else Result:=false;
  end;

{------------------------------------------------------------------}
(* Datenglättung mit kub. Spline Funktionen
   Basis:  FH KIEL MATHLIB  Rel. 1.1   01.03.91
           (C) Copyright 1991 by Prof. Dr. Guido Hartmann, Kiel
   Pascal-Umsetzung: J. Rathlev, Jun. 2001
   *)
var
  NPoints     : integer;
  pck         : TMatrix;
  pxa,pys     : TVector;

{------------------------------------------------------------------}
(* Purpose:   Data smoothing by a cubic spline.
   Parameters:
     NP:       (In)  The number of elements in XA and YA. NP must not
                     be less than 2.
     SMooth:   (In)  Smoothing parameter. SM is a measure for the sum
                     of squares of the differences between the input
                     values YA[i] and the values of the spline function
                     YS[i] at XA[i]. SM is normalized such that
                     SM = 1000  means maximum smoothing (linear fit) and
                     SM = 0    means interpolation.
                     Therefore SM must neither be less than zero nor
                     greater than hundred.
     XA:       (In)  Vector of length NP containing the abscissas of
                     the data points. XA must be ordered so that
                     XA[i] < XA[i+1].
     YA:       (In)  Vector of length NP containing the ordinates of
                     the data points.
     YS:       (Out) Vector of length NP containing the function values
                     of the spline corresponding to the abscissas XA.
     CK:       (Out) Coeff. matrix of length (NP-1) containing the spline
                     coefficients. The value of the spline approximation
                     at X is
                       S(X) = ((CK[I,3]*D+CK[I,2])*D+CK[I,1])*D+YS[i],
                     where XA[i]<=X<=XA[i+1], D=X-XA[i] and
  Result:      (Out) Error code
    Possible Errors
      0:  no error
      81: NP is less than 2
      82: Input abscissas are not ordered
      83: SM is out of range
  Remarks:
    For evaluation of the spline function, program CubSplineVal may be used.
    Note that vector YS instead of YA has to be passed to CubSplineVal.
  Ref.:      C.H. Reinsch, Smoothing by Spline Functions
             Numerische Mathematik 10 (1967) 177-183
*)
function CubSpline (NP,Smooth   : integer;
                    const XA,YA : TVector;
                    var YS      : TVector;
                    var CK      : TMatrix) : integer;
var
  Work         : TMatrix;
  e,f,f2,g,h,
  p,s,xsm,
  xi,yi,sx,sy,
  sxx,sxy,syy  : double;
  m2,ier,i     : integer;
  EndLoop      : boolean;
begin
(* TEST FOR PARAMETER ERRORS *)
  CubSpline:=81;
  IF NP<=1 then Exit;
  CubSpline:=82;
  for I:=1 to NP-1 do if xa[i]<=xa[i-1] then Exit;
  CubSpline:=83;
  IF (Smooth<0) or (Smooth>100) then Exit;
  SetLength (Work,8,NP+2);
//  GetMem (Work,7*(NP+2)*SizeOf(double));
  xsm:=Smooth/1000;
  CubSpline:=0;
(* COMPUTE DEVIATION FROM STRAIGHT LINE FIT *)
  SX:=0; SY:=0;
  for I:=0 to NP-1 do begin
    SX:=SX+xa[i]; SY:=SY+ya[i];
    end;
  SX:=SX/NP; SY:=SY/NP;
  SXX:=0; SXY:=0; SYY:=0;
  for I:=0 to NP-1 do begin
    XI:=xa[i]-SX; YI:=ya[i]-SY;
    SXX:=SXX+XI*XI; SXY:=SXY+XI*YI; SYY:=SYY+YI*YI;
    end;
  S:=(SYY-SXY*SXY/SXX)*xsm;
(* INITIALIZATIONS *)
  M2:=NP+1;
  Work[1,0]:=0; Work[1,1]:=0;
  Work[2,NP]:=0; Work[3,NP]:=0;
  Work[3,M2]:=0; Work[6,0]:=0;
  Work[6,1]:=0; Work[6,NP]:=0; Work[6,M2]:=0;
  M2:=NP-1;
  H:=xa[1]-xa[0]; F:=(ya[1]-ya[0])/H;
(* COMPUTE MATRICES T AND Q *)
  for I:=2 to M2 do begin
    G:=H; H:=xa[i]-xa[i-1];
    E:=F; F:=(ya[i]-ya[i-1])/H;
    ys[i-1]:=F-E;
    Work[4,I]:=(G+H)*2/3;
    Work[5,I]:=H/3;
    Work[1,I]:=1/H;
    Work[3,I]:=1/G;
    Work[2,I]:=-(1/G+1/H);
    end;
  for I:=2 to M2 do begin
    CK[I-1,0]:=Work[1,I]*Work[1,I]+Work[2,I]*Work[2,I]+Work[3,I]*Work[3,I];
    CK[I-1,1]:=Work[1,I]*Work[2,I+1]+Work[2,I]*Work[3,I+1];
    CK[I-1,2]:=Work[1,I]*Work[3,I+2];
    end;
  F2:=-S; P:=0;
(* LOOP TO DETERMINE THE LAGRANGIAN PARAMETER P *)
  repeat
(* CHOLESKY DECOMPOSITION *)
    for I:=2 to M2 do begin
      Work[2,I-1]:=Work[1,I-1]*F;
      Work[3,I-2]:=Work[1,I-2]*G;
      Work[1,I]:=1/(CK[I-1,0]*P+Work[4,I]-Work[2,I-1]*F-Work[3,I-2]*G);
      Work[6,I]:=ys[i-1]-Work[2,I-1]*Work[6,I-1]-Work[3,I-2]*Work[6,I-2];
      F:=CK[I-1,1]*P+Work[5,I]-Work[2,I-1]*H;
      G:=H; H:=CK[I-1,2]*P;
      end;
(* COMPUTE VECTOR U *)
    for I:=M2 downto 2 do Work[6,I]:=Work[1,I]*Work[6,I]-
      Work[2,I]*Work[6,I+1]-Work[3,I]*Work[6,I+2];
    E:=0; H:=0;
(* COMPUTE VECTOR V *)
    for I:=1 to M2 do begin
      G:=H; H:=(Work[6,I+1]-Work[6,I])/(xa[i]-xa[i-1]);
      Work[7,I]:=H-G; E:=E+Work[7,I]*(H-G);
      end;
    G:=-H; Work[7,NP]:=G;
    E:=E-G*H; G:=F2; F2:=E*P*P;
    EndLoop:=true;
    IF (F2<S) and (F2>G) then begin
      F:=0;
      H:=(Work[7,2]-Work[7,1])/(xa[1]-xa[0]);
      for I:=2 to M2 do begin
        G:=H;
        H:=(Work[7,I+1]-Work[7,I])/(xa[i]-xa[i-1]);
        G:=H-G-Work[2,I-1]*Work[1,I-1]-Work[3,I-2]*Work[1,I-2];
        F:=F+Work[1,I]*G*G;
        Work[1,I]:=G;
        end;
      H:=E-P*F;
      IF (H>0) then begin
        (* ADJUST P AND ITERATE *)
        P:=P+(S-F2)/((SQRT(S/E)+P)*H);
        EndLoop:=false;
        end;
      end;
    until EndLoop;
(* DETERMINATION OF THE SPLINE *)
(* COEFFICIENTS *)
  for I:=0 to M2-1 do begin
    ys[i]:=ya[i]-Work[7,I+1]*P;
    CK[I,1]:=Work[6,I+1];
    end;
  ys[NP-1]:=ya[NP-1]-Work[7,NP]*P;
  for I:=0 to M2-1 do begin
    H:=xa[i+1]-xa[i];
    CK[I,2]:=(Work[6,I+2]-Work[6,I+1])/(H*3);
    CK[I,0]:=(ys[i+1]-ys[i])/H-(CK[I,2]*H+Work[6,I+1])*H;
    end;
  Work:=nil;
  end;

{------------------------------------------------------------------}
(* Compute y-value of spline interpolation
   Parameters:
     NP:       (In)  The number of elements in XA and YA. NP must not
                     be less than 2.
     X:        (In)  abscissa value of point to interpolate
     XA:       (In)  Vector of length NP containing the abscissas of
                     the data points. XA must be ordered so that
                     XA[i] < XA[i+1].
     YS:       (In)  Vector of length NP containing the function values
                     of the spline corresponding to the abscissas XA.
     CK:       (In)  Coeff. matrix of length (NP-1) containing the spline
                     coefficients. The value of the spline approximation
                     at X is
                       S(X) = ((CK[I,3]*DX+CK[I,2])*DX+CK[I,1])*DX+YS[i],
                     where XA[i]<=X<=XA[i+1], DX=X-XA[i] and
  Result:      (Out) Error code
    Possible Errors
      0:  no error
      84: X<XMin
      85: X>XMax
  *)
function CubSplineVal (NP          : integer;
                       X           : double;
                       const XA,YS : TVector;
                       const CK    : TMatrix;
                       var Y       : double) : integer;
var
  i  : integer;
  dx : double;
begin
  (* Seek interval *)
  CubSplineVal:=84;
  if (x<XA[0]) then Exit;
  CubSplineVal:=85;
  if (x>XA[NP-1]) then Exit;
  CubSplineVal:=0;
  i:=1;
  while (x>=XA[i]) and (i<NP-1) do inc(i);
  dec(i); dx:=x-XA[i];
  Y:=((CK[I,2]*dx+CK[I,1])*dx+CK[I,0])*dx+YS[i];
  end;

{------------------------------------------------------------------}
(* Data smoothing by a cubic spline.
   All results are stored to compute a value with GetCubSpline *)
function CubSplineFit (NP,Smooth : integer;
                       const XA,YA : TVector) : integer;
var
  i : integer;
begin
  SetLength(pxa,NP);
  SetLength(pys,NP);
  SetLength(pck,NP-1,3);
  NPoints:=NP;
  for i:=1 to NPoints do pxa[i]:=xa[i];
  Result:=CubSpline (NPoints,Smooth,xa,ya,pys,pck);
  end;

{------------------------------------------------------------------}
(* Compute interpolated value, no range checking is done *)
function CubSplineFitValue (x : double) : double;
var
  i : integer;
  y : double;
begin
  if NPoints>1 then begin
    i:=CubSplineVal (NPoints,x,pxa,pys,pck,y);
    if i=84 then Result:=pys[1]
    else if i=85 then Result:=pys[NPoints]
    else Result:=y;
    end
  else Result:=0;
  end;

begin
  NPoints:=0; pxa:=nil; pys:=nil; pck:=nil;
  end.
