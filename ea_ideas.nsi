; ea_modaf.nsi
;

;--------------------------------

; The name of the installer
Name "IDEAS Add-In for EA"

; The file to write
OutFile "setupEAIDEASAddin.exe"

; The default installation directory
InstallDir $PROGRAMFILES\ModelFutures\IDEAS_EA_AddIn

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\IdeasAddIn" "Install_Dir"

LicenseText "IDEAS Add-In Beta License Agreement"
LicenseData "license.txt"

;--------------------------------

; Pages

Page license
Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

Var EAINST ;

; The stuff to install
Section "IDEAS EA AddIn (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "ea_ideas.nsi"
  File "IdeasAddIn.ocx"
  File "IdeasTool.exe"
  

  
  ;Find the EA directory
  ReadRegStr $EAINST HKCU "Software\Sparx Systems\EA400\EA" "Install Path"
  DetailPrint "EA installed at: $EAINST"
  
  ; Set output path to the Sparx installation directory.
  SetOutPath $EAINST
  ; Put file there
  File "blank.ideas"
  
  
   ; Set output path to the EA/MDG folder
  CreateDirectory $EAINST\MDGTechnologies
  SetOutPath $EAINST\MDGTechnologies
  
  ; Put xml file there
  File "ideasMDG.xml"
  File "ideas_template.xml"

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\IdeasAddIn "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKCU "Software\Sparx Systems\EAAddins\IdeasAddIn" "" "IdeasAddIn.AddIn"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\IdeasAddIn" "DisplayName" "IDEAS Add-In for EA"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\IdeasAddIn" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\IdeasAddIn" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\IdeasAddIn" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  UnRegDLL "$INSTDIR\IdeasAddIn.ocx"
  Sleep 1000
  RegDLL "$INSTDIR\IdeasAddIn.ocx"
  Sleep 1000
  
  CreateShortCut "$SMPROGRAMS\IDEAS AddIn for EA\IdeasTool.lnk" "$INSTDIR\IdeasTool.exe" "" "$INSTDIR\IdeasTool.exe" 0
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Uninstaller Icon Shortcut"

  CreateShortCut "$SMPROGRAMS\IDEAS AddIn for EA\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd
;--------------------------------

; Uninstaller

Section "Uninstall"

  UnRegDLL "$INSTDIR\IdeasAddIn.ocx"
  Sleep 1000
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\IdeasAddIn"
  DeleteRegKey HKLM SOFTWARE\IdeasAddIn
  DeleteRegKey HKCU "Software\Sparx Systems\EAAddins\IdeasAddIn"
  
  ;Find the EA directory
  ReadRegStr $EAINST HKCU "Software\Sparx Systems\EA400\EA" "Install Path"

  ; Remove files and uninstaller
  Delete $INSTDIR\ea_ideas.nsi
  Delete $INSTDIR\IdeasAddIn.ocx
  Delete $INSTDIR\IdeasTool.exe
  Delete $INSTDIR\uninstall.exe
  Delete "$EAINST\MDGTechnologies\ideasMDG.xml"

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\IDEAS AddIn for EA\*.*"
  
  ; Remove directories used
  RMDir "$SMPROGRAMS\IdeasAddIn"
  RMDir "$INSTDIR"

SectionEnd
