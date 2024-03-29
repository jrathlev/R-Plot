; Setup script for R-Plot (32 bit)
; ================================
;  � Dr. J. Rathlev, D-24222 Schwentinental (kontakt(a)rathlev-home.de)

;  The contents of this file may be used under the terms of the
;  Mozilla Public License ("MPL") or
;  GNU Lesser General Public License Version 2 or later (the "LGPL")

;  Software distributed under this License is distributed on an "AS IS" basis,
;  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
;  the specific language governing rights and limitations under the License.

#define ApplicationVersion GetFileVersion('..\Release\Win32\RPlot.exe')
#define Year GetDateTimeString('yyyy','','')

[Setup]
PrivilegesRequired=admin
AppName=R-Plot (32-bit)
AppId=R-Plot
AppVerName=R-Plot {#ApplicationVersion}
AppVersion={#ApplicationVersion}
AppPublisher=Dr. J. Rathlev
AppPublisherURL=http://www.rathlev-home.de/
AppSupportURL=http://www.rathlev-home.de/?tools/datatools.html
AppUpdatesURL=http://www.rathlev-home.de/?tools/datatools.html
AppCopyright=Copyright � 2012 - {#Year} Dr. J. Rathlev
VersionInfoVersion={#ApplicationVersion}
DefaultDirName={pf}\R-Plot
AppendDefaultDirName=yes
DefaultGroupName=R-Plot
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=rp-setup
SetupIconFile=RPlot.ico
UninstallDisplayIcon={app}\RPlot-u.ico
WizardImageFile=RPlot-Install.bmp
WizardSmallImageFile=RPlot-Install-small.bmp
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes
ShowLanguageDialog=auto
DisableWelcomePage=no
DisableDirPage=auto
DisableProgramGroupPage=auto

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"; LicenseFile:"license-en.rtf";
Name: "de"; MessagesFile: "compiler:Languages\German.isl"; LicenseFile:"license-de.rtf";

[CustomMessages]
en.FileAssoc=File association:
en.Update=R-Plot is already installed on your system!
en.StartUpdate=Clicking the "Next" button will start the update.
en.UpdateMode=Run fast update
en.V64Update=You have installed the 64-bit version of R-Plot on your system! It is necessary to uninstall this version prior to installing the 32-bit version!
en.V64Hint=Please use the function "Programs and Features" from the "Windows Control Panel" to do so!
en.V64End=Clicking the "Next" button will cancel the setup.

de.FileAssoc=Dateizuordnung:
de.Update=R-Plot ist bereits auf Ihrem System installiert!
de.StartUpdate=Ein Klick auf die "Weiter"-Taste startet das Update.
de.UpdateMode=Schnelles Update
de.V64Update=Sie haben die 64-bit-Version von R-Plot auf Ihrem System installiert! Diese Version muss deinstalliert werden, bevor die 32-bit-Version installiert werden kann!
de.V64Hint=Bitte benutzen Sie dazu die Funktion "Programme und Funktionen" aus der "Windows-Systemsteuerung"!
de.V64End=Nach einem Klick auf die "Weiter"-Taste wird die Installation abgebrochen.

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce
Name: "fileassoc"; Description: "{cm:AssocFileExtension,R-Plot,xrp}"; GroupDescription: "{cm:FileAssoc}"; Flags: checkedonce

[Registry]
Root: HKCR; Subkey: ".xrp"; ValueType: string; ValueName: ""; ValueData: "R-Plot"; Tasks: fileassoc; Flags: uninsdeletevalue
Root: HKCR; Subkey: "R-Plot"; ValueType: string; ValueName: ""; ValueData: "R-Plot"; Tasks: fileassoc; Flags: uninsdeletekey
Root: HKCR; Subkey: "R-Plot\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\RPlot.exe,0"; Tasks: fileassoc;
Root: HKCR; Subkey: "R-Plot\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\RPlot.exe"" ""%1"""; Tasks: fileassoc;

[Files]
Source: "..\Release\Win32\RPlot.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Release\Win32\locale\*.mo"; DestDir: "{app}\locale"; Flags: recursesubdirs ignoreversion restartreplace
Source: "..\Release\Win32\language.cfg"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion restartreplace
Source: "..\docs\rp-help-*.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "license-*.rtf"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\docs\changelog*.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "RPlot-u.ico"; DestDir: "{app}"; Flags: ignoreversion
; samples
Source: "..\samples\*.xrp"; DestDir: "{commondocs}\RPlot\Samples"; Flags: ignoreversion

[Icons]
Name: "{group}\R-Plot"; Filename: "{app}\RPlot.exe"
Name: "{group}\{cm:UninstallProgram,R-Plot}"; Filename: "{uninstallexe}"; IconFilename: "{app}\RPlot-u.ico"
Name: "{commondesktop}\R-Plot"; Filename: "{app}\RPlot.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\RPlot.exe"; Description: "{cm:LaunchProgram,R-Plot}"; Flags: nowait postinstall skipifsilent

[Code]
var
  V64,DoUpdate  : boolean;
  FullCheckBox  : TNewCheckBox;

function IsUpdate :boolean;
begin
  if IsWin64 then Result:=RegKeyExists(HKLM,'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\R-Plot_is1')
  else Result:=RegKeyExists(HKLM,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\R-Plot_is1');
end;

function Vers64Installed : boolean;
begin
  if IsWin64 then begin
    Result:=RegKeyExists(HKLM64,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\R-Plot_is1'); 
    end
  else Result:=false;
  end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if V64 then begin
    WizardForm.Close;
    Result:=false;
    end
  else Result:=true;
  end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  Confirm:=not V64;
  end;

function InitializeSetup(): Boolean;
begin
  DoUpdate:=IsUpdate(); V64:=Vers64Installed();
  Result:=true;
  end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result:=False;
  case PageID of
  wpLicense: Result:= DoUpdate and FullCheckBox.Checked;
  wpInfoBefore: Result:= DoUpdate and FullCheckBox.Checked;
  wpSelectTasks: Result:= DoUpdate and FullCheckBox.Checked;
  wpInfoAfter: Result:= DoUpdate and FullCheckBox.Checked;
  wpReady: Result:= DoUpdate and FullCheckBox.Checked;
    end;
  end;

procedure InitializeWizard();
begin
  if V64 then begin
    WizardForm.WelcomeLabel2.Caption:=CustomMessage('V64Update')+#13#10#13#10+CustomMessage('V64Hint')+#13#10#13#10+CustomMessage('V64End');
    end
  else if DoUpdate then begin
    WizardForm.WelcomeLabel2.Caption:=CustomMessage('Update')+#13#10#13#10+CustomMessage('StartUpdate');
    FullCheckBox := TNewCheckBox.Create(WizardForm.WelcomePage);
    FullCheckBox.Top := ScaleY(150);
    FullCheckBox.Left := ScaleX(180);
    FullCheckBox.Height := ScaleY(17);
    FullCheckBox.Width := ScaleX(150);
    FullCheckBox.Caption := CustomMessage('UpdateMode');
    FullCheckBox.Checked := True;
    FullCheckBox.Parent := WizardForm.WelcomePage;
  end;
end;


