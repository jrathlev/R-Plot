(* Delphi Unit
   resource strings of MathExp - English

   � Dr. J. Rathlev, D-24222 Schwentinental (info(a)rathlev-home.de)

   The contents of this file may be used under the terms of the
   Mozilla Public License ("MPL") or
   GNU Lesser General Public License Version 2 or later (the "LGPL")

   Software distributed under this License is distributed on an "AS IS" basis,
   WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
   the specific language governing rights and limitations under the License.

   Vers. 1 - Jan. 2016
   *)

unit MathExpConsts;

interface

resourcestring
  rsMathErrPar = 'Error (left/right parenthesis)'; //'Fehler (�ffnende/schlie�ende Klammern)'
  rsMathErrLeftPar = 'Input error (missing left parenthesis)'; //Eingabefehler (�ffnende Klammer fehlt)';
  rsMathErrEmptyPar = 'Input error (empty parentheses)'; //'Eingabefehler (kein Klammerinhalt)';
  rsMathErrDivZero = 'Division by zero'; //'Division durch Null';
  rsMathErrInvalidArg = 'Invalid argument'; //'Unzul�ssiges Argument';
  rsMathErrOverflow = 'Overflow on operation'; //'Operation f�hrt zu �berlauf';
  rsMathErrInvalidExp = 'Invalid expression'; //'Unidentifizierbarer Ausdruck';
  rsMathErrUnexpOper = 'Unexpected operator'; //'Unerwartetes Operationssymbol';
  rsMathErrIncompExp = 'Invalid expression'; //'Unvollst�ndiger Ausdruck';
  rsMathErrMissOper = 'Missing operator'; //'Operationssymbol fehlt';
  rsMathErrNegPower = 'Power with invalid (negative) base'; //'Potenz mit unzul�ssiger (negativer) Basis';
  rsMathErrZeroPower = 'Zero to power of zero'; //'"Null hoch Null"';
  rsMathErrZeroZero = 'Divide zero by zero'; //'"Null durch Null"';
  rsMathErrInvalidOps = 'Invalid combination of operands'; //'Unzul�ssige Kombination von Operanden';
  rsMathErrInvalidChar = 'Invalid character'; //'Unerlaubtes Zeichen';
  rsMathErrInvalidOvfl = 'Invalid argument (potential overflow)'; //'Unzul�ssiges Argument (�berlaufgefahr)';
  rsMathErrStackOvfl = 'Low memory ("stack overflow")'; //'Speicherplatz fehlt ("stack overflow")';
  rsMathErrMemOvfl = 'Low memory ("string overflow")'; //'Speicherplatz fehlt ("string overflow")';
  rsMathErrUnknown = 'Unknown error'; //'Unbekannter Fehler';

implementation

end.
