
# Modified from script created by NSIS Quick Setup Script Generator

############################################################################################
#      NSIS Installation Script created by NSIS Quick Setup Script Generator v1.09.18
#               Entirely Edited with NullSoft Scriptable Installation System                
#              by Vlasis K. Barkas aka Red Wine red_wine@freemail.gr Sep 2006               
############################################################################################

# TODO: Have the Windower and Ashita profiles check the machine's native resolution.

# TODO?: Install/check .NET Framework 4.5.2 (for Ashita3)?

# TODO?: Ashita4

# TODO?: Windower5 

!system 'py PrepareInstaller.py'
!include "tempinclude.nsh"

# PrepareInstaller creates the following defines (mostly from Settings.ini):
# INSTALLER_NAME
# OUTPUT_DIR
# FFXI_SOURCE_DIR
# FFXI_ARCHIVE_NAME
# FFXI_ARCHIVE_UNCOMPRESSED_SIZE
# FFXI_ARCHIVE_CLIENT_VERSION
# SERVER_NAME
# DEFAULT_DIR
# DESCRIPTION

!define APP_NAME "${SERVER_NAME}"
!define COMP_NAME "FFEra"
!define WEB_SITE "http://www.ffera.com"
!define INSTALL_TYPE "SetShellVarContext current"
!define LICENSE_FILE "License.rtf"
!define REG_ROOT "HKLM"
!define UNINSTALL_PATH "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

!define REG_START_MENU "StartMenuFolder"

Var DirectXError
Var VCRedistError
Var SM_Folder
Var StartMenuFolder

SetCompressor LZMA
Name "${APP_NAME}"
Caption "${APP_NAME}"
OutFile "${OUTPUT_DIR}\${INSTALLER_NAME}"
BrandingText "${APP_NAME}"
XPStyle on
InstallDir "${DEFAULT_DIR}\"
InstallDirRegKey "${REG_ROOT}" "${UNINSTALL_PATH}" ""

RequestExecutionLevel admin

######################################################################

!include "LogicLib.nsh"
!include "x64.nsh"
!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "StrFunc.nsh"
!include "Registry.nsh"
!include "functions.nsh"

${Using:StrFunc} StrLoc

Var NativeWidth
Var NativeHeight
Var Dialog

Function .onInit
    UserInfo::GetAccountType
    pop $0
    ${If} $0 != "admin" ;Require admin rights on NT4+
        MessageBox mb_iconstop "Administrator rights required!"
        SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        Quit
    ${EndIf}
    
    System::Call 'user32::GetSystemMetrics(i 0) i .r0'
    System::Call 'user32::GetSystemMetrics(i 1) i .r1'
    StrCpy $NativeWidth $0
    StrCpy $NativeHeight $1
    
    ${If} ${RunningX64}
        SetRegView 64
    ${EndIf}
    
    ClearErrors
    ReadRegStr $R0 ${REG_ROOT} "${UNINSTALL_PATH}" "InstallLocation"
    ${IfNot} ${Errors}
    ${AndIf} $R0 != ""
        ${TrimQuotes} $R0 $R0
        StrCpy $INSTDIR $R0
    ${EndIf}
FunctionEnd

Function un.onInit
    ${If} ${RunningX64}
        SetRegView 64
    ${EndIf}
FunctionEnd

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!insertmacro MUI_PAGE_WELCOME

!ifdef LICENSE_FILE
    !insertmacro MUI_PAGE_LICENSE "${LICENSE_FILE}"
!endif

!insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_PAGE_DIRECTORY

Page custom previousSettingsCheckCreate previousSettingsCheckLeave

!ifdef REG_START_MENU
    !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APP_NAME}"
    !define MUI_STARTMENUPAGE_REGISTRY_ROOT "${REG_ROOT}"
    !define MUI_STARTMENUPAGE_REGISTRY_KEY "${UNINSTALL_PATH}"
    !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${REG_START_MENU}"
    !insertmacro MUI_PAGE_STARTMENU Application $SM_Folder
!endif

!insertmacro MUI_PAGE_INSTFILES

!define MUI_PAGE_CUSTOMFUNCTION_SHOW "finishPageShow"
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "finishPageLeave"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_COMPONENTS

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Var RegFolder
Var OldInstallLocation
Var MigrateChoice
Var CleanupChoice
Var OverwriteRegistry
Var OverwriteAshita
Var OverwriteWindower

######################################################################

Section "-PreviousInstall" PreviousInstall

    ${INSTALL_TYPE}
    
    ${TrimQuotes} $OldInstallLocation $0

    ${If} $MigrateChoice == "true"
        DetailPrint "Migrating settings from previous FFEra installation..."
        CopyFiles "$0\SquareEnix\FINAL FANTASY XI\USER\*.*" "$INSTDIR\SquareEnix\FINAL FANTASY XI\USER"
        CopyFiles "$0\Windower\*.*" "$INSTDIR\Windower"
        CopyFiles "$0\Ashita\*.*" "$INSTDIR\Ashita"
    ${EndIf}
    
    ${If} $CleanupChoice == "true"
        # Backup the registry since the old uninstaller deletes it.
        ${registry::CopyKey} "HKLM\$RegFolder" "HKLM\$RegFolder2" $R0
        
        Var /GLOBAL UninstallError
        DetailPrint "Uninstalling previous FFEra installation. This may take a minute..."
        ExecWait '"$0\Uninstall.exe" /S _?=$0' $UninstallError
        Delete "$0\Uninstall.exe"
        RMDir "$0"
        
        ${registry::MoveKey} "HKLM\$RegFolder2" "HKLM\$RegFolder" $R0
        
        ClearErrors
        ReadRegStr $1 HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FFEraServer" "InstallLocation"
        
        ${IfNot} ${Errors}
        ${AndIf} $1 == $OldInstallLocation
            DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FFEraServer"
        ${EndIf}
    ${EndIf}
    
    # Always clean up registry if installing over the same directory.
    
    ClearErrors
    ReadRegStr $0 HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FFEraServer" "InstallLocation"
    
    ${IfNot} ${Errors}
    ${AndIf} $0 == $INSTDIR
        DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FFEraServer"
        
        RMDir /r "$SMPROGRAMS\FFEra Server"
    ${EndIf}
    
    ClearErrors
    ReadRegStr $0 HKEY_CURRENT_USER "${UNINSTALL_PATH}" ""
    
    ${IfNot} ${Errors}
    ${AndIf} $0 == $INSTDIR
        DeleteRegKey HKEY_CURRENT_USER "${UNINSTALL_PATH}"
    ${EndIf}
    
SectionEnd

SectionGroup /e "Game Files" GameFiles

Section "FFXI" GameFiles_FFXI

    AddSize ${FFXI_ARCHIVE_UNCOMPRESSED_SIZE}

    SetOutPath "$INSTDIR\SquareEnix"
    SetDetailsPrint both
    Nsis7z::ExtractWithDetails "$EXEDIR\${FFXI_ARCHIVE_NAME}" "Installing game files %s..."

SectionEnd

Section "Era-Specific Mods" GameFiles_EraSpecificMods

    SetOutPath "$INSTDIR"

    File /r ".\Additional Files\EraSpecificMods\*.*"

SectionEnd

Section "Enhanced Maps" GameFiles_EnhancedMaps

    SetOutPath "$INSTDIR"

    File /r ".\Additional Files\EnhancedMaps\*.*"

SectionEnd

SectionGroupEnd

######################################################################

SectionGroup /e "Launchers" Launchers

Section "Windower4" Launchers_Windower

    SetOutPath "$INSTDIR\Windower"
    
    File /r /x "settings.xml" ".\Additional Files\Windower\*.*"

    ${If} $OverwriteWindower == "true"
        File ".\Additional Files\Windower\settings.xml"
    ${EndIf}

SectionEnd

Section "Ashita3" Launchers_Ashita

    SetOutPath "$INSTDIR\Ashita"
    
    File /r /x "config" /x "scripts" ".\Additional Files\Ashita\*.*"

    ${If} $OverwriteAshita == "true"
        SetOutPath "$INSTDIR\Ashita\config"
        File /r ".\Additional Files\Ashita\config\*.*"
        SetOutPath "$INSTDIR\Ashita\scripts"
        File ".\Additional Files\Ashita\scripts\*.*"
    ${EndIf}

SectionEnd

SectionGroupEnd

######################################################################

Section -Icons_Reg

    SetOutPath "$INSTDIR"
    
    File ".\Additional Files\${APP_NAME}.ico"
    File ".\Additional Files\Switch.bat"

    RegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXi.dll"
    RegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiMain.dll"
    RegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiVersions.dll"
    RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\app.dll"
    RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\polcore.dll"
    RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\polcontentsINT.dll"
    RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\PolContents.dll"
    RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvfINT.dll"
    RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvf.dll"

    !include "FFXiRegistry.nsi"
    
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    StrCpy $StartMenuFolder "$SMPROGRAMS\${APP_NAME}"

    !ifdef REG_START_MENU
        !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        StrCpy $StartMenuFolder "$SMPROGRAMS\$SM_Folder"
    !endif
    
    CreateDirectory "$StartMenuFolder"
    
    ${If} ${FileExists} "$INSTDIR\Windower\Windower.exe"
        SetOutPath "$INSTDIR\Windower"
        CreateShortCut "$StartMenuFolder\${APP_NAME} on Windower.lnk" "$INSTDIR\Windower\Windower.exe" "" "$INSTDIR\${APP_NAME}.ico"
    ${EndIf}
    
    ${If} ${FileExists} "$INSTDIR\Ashita\Ashita.exe"
        SetOutPath "$INSTDIR\Ashita"
        CreateShortCut "$StartMenuFolder\${APP_NAME} on Ashita.lnk" "$INSTDIR\Ashita\Ashita.exe" "" "$INSTDIR\${APP_NAME}.ico"
    ${EndIf}
    
    SetOutPath "$INSTDIR"
    CreateShortCut "$StartMenuFolder\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall.exe"

    !ifdef WEB_SITE
        WriteIniStr "$INSTDIR\${APP_NAME} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
        CreateShortCut "$StartMenuFolder\${APP_NAME} Website.lnk" "$INSTDIR\${APP_NAME} website.url"
    !endif
    
    !ifdef REG_START_MENU
        !insertmacro MUI_STARTMENU_WRITE_END
    !endif
    
    WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "" ""
    WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "InstallLocation" '"$INSTDIR"'
    WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP_NAME}"
    WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'
    WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" '"$INSTDIR\${APP_NAME}.ico"'
    WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${COMP_NAME}"
    
    ${GetInstalledSize} $0
    WriteRegDWORD ${REG_ROOT} "${UNINSTALL_PATH}" "EstimatedSize" "$0"

    !ifdef WEB_SITE
        WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "URLInfoAbout" "${WEB_SITE}"
    !endif

SectionEnd

######################################################################

Section "-DirectX" Dependencies_DirectX

    SectionIn RO
    
    !define ExpectedDirectXVersion "4.09.00.0904"
    Var /GLOBAL DirectXNeeded

    # This registry key is always duplicated to WOW6432Node.
    ClearErrors
    ReadRegStr $R0 HKLM "Software\Microsoft\DirectX" "Version"
    
    ${If} ${Errors}
        StrCpy $DirectXNeeded "true"
    ${Else}
        ${VersionCheckNew} "$R0" "${ExpectedDirectXVersion}" "$R1"
        ${If} $R1 == 2
            StrCpy $DirectXNeeded "true"
        ${EndIf}
    ${EndIf}

    ${If} $DirectXNeeded == "true"
        SetRebootFlag true
        
        SetOutPath "$TEMP"
        File ".\FFXI Install Dependencies\dxwebsetup.exe"
        DetailPrint "Running DirectX Setup..."
        
        ExecWait '"$TEMP\dxwebsetup.exe" /Q' $DirectXError
        
        DetailPrint "Finished DirectX Setup"
        Delete "$TEMP\dxwebsetup.exe"

        SetOutPath "$INSTDIR"
    ${EndIf}

SectionEnd

Section "-DirectPlay" Dependencies_DirectPlay

    SectionIn RO
    
    # Make sure the Windows Feature, DirectPlay, is enabled
    nsExec::ExecToStack '"Dism" /online /Get-FeatureInfo /FeatureName:DirectPlay'
    Pop $0
    Pop $1

    ${StrLoc} $0 $1 "State : Enabled" ">"
    
    # If DirectPlay is not enabled, do so here.
    ${If} $0 == ""
        SetRebootFlag true
        
        DetailPrint "Enabling DirectPlay..."
        
        # See: https://www.itechtics.com/enable-disable-windows-features/
        ExecWait "DISM /online /enable-feature /featurename:DirectPlay"
        
        DetailPrint "DirectPlay enabled."
    ${EndIf}
    
SectionEnd

Section "-VC++ Runtime" Dependencies_VC

    SectionIn RO

    !define ExpectedVCVersion "14.34.31931"
    Var /GLOBAL VCNeeded

    ${If} ${RunningX64}
        StrCpy $R1 "SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\x86"
    ${Else}
        StrCpy $R1 "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86"
    ${EndIf}

    ClearErrors
    ReadRegStr $R0 HKLM "$R1" "Version"
    
    ${If} ${Errors}
        StrCpy $VCNeeded "true"
    ${Else}
        StrCpy $R1 $R0 1
        ${If} $R1 == "v"
            StrCpy $R0 $R0 "" 1
        ${EndIf}
        
        ${VersionCheckNew} "$R0" "${ExpectedVCVersion}" "$R1"
        
        ${If} $R1 == 2
            StrCpy $VCNeeded "true"
        ${EndIf}
    ${EndIf}
    
    ${If} $VCNeeded == "true"
        SetRebootFlag true
    
        SetOutPath "$TEMP"
        File ".\FFXI Install Dependencies\VC_redist.x86.exe"
        DetailPrint "Installing Microsoft Visual C++ x86 Redistributable..."
        
        ExecWait  '"$TEMP\VC_redist.x86.exe" /install /passive /norestart' $VCRedistError
        
        DetailPrint "Finished installing VC++ Redistributable"
        Delete "$TEMP\VC_redist.x86.exe"
        
        SetOutPath "$INSTDIR"
    ${EndIf}

SectionEnd

######################################################################

Section "un.Game Files" Uninstall_GameFiles
    
    SectionIn RO
    
    ${INSTALL_TYPE}
    
    UnRegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXi.dll"
    UnRegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiMain.dll"
    UnRegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiVersions.dll"
    UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\app.dll"
    UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\polcore.dll"
    UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\polcontentsINT.dll"
    UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\PolContents.dll"
    UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvfINT.dll"
    UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvf.dll"

    !include "FFXiUninstall.nsi"
    
SectionEnd

Section /o "un.Config" Uninstall_Config

    ${If} ${RunningX64}
        StrCpy $RegFolder "SOFTWARE\WOW6432Node\PlayOnlineUS"
    ${Else}
        StrCpy $RegFolder "SOFTWARE\PlayOnlineUS"
    ${EndIf}
    
    DeleteRegKey HKEY_LOCAL_MACHINE "$RegFolder"

SectionEnd

Section /o "un.User Files" Uninstall_UserFiles

    RMDir /r "$INSTDIR\SquareEnix\FINAL FANTASY XI\USER"
    RMDir "$INSTDIR\SquareEnix\FINAL FANTASY XI"
    RMDir "$INSTDIR\SquareEnix"

SectionEnd

SectionGroup "un.Launchers" Uninstall_Launchers

Section /o "un.Windower" Uninstall_Launchers_Windower

    RMDir /r "$INSTDIR\Windower"

SectionEnd

Section /o "un.Ashita" Uninstall_Launchers_Ashita

    RMDir /r "$INSTDIR\Ashita"

SectionEnd

SectionGroupEnd

Section -Uninstall

    Delete "$INSTDIR\uninstall.exe"
    Delete "$INSTDIR\Switch.bat"
    Delete "$INSTDIR\${APP_NAME}.ico"
    !ifdef WEB_SITE
        Delete "$INSTDIR\${APP_NAME} website.url"
    !endif

    # This won't do anything unless all the components were uninstalled.
    RMDir "$INSTDIR"
    
    StrCpy $StartMenuFolder "$SMPROGRAMS\${APP_NAME}"

    !ifdef REG_START_MENU
        !insertmacro MUI_STARTMENU_GETFOLDER "Application" $SM_Folder
        StrCpy $StartMenuFolder "$SMPROGRAMS\$SM_Folder"
    !endif
    
    RMDir /r "$StartMenuFolder"
    
    Delete "$DESKTOP\${APP_NAME} on Ashita.lnk"
    Delete "$DESKTOP\${APP_NAME} on Windower.lnk"

    DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"

SectionEnd

######################################################################

Var RegistryLabel
Var RegistryRadioPreserve
Var RegistryRadioOverwrite
Var RegistryRadioOverwriteState
Var OldInstallLabel
Var MigrateCheckbox
Var MigrateCheckboxState
Var CleanupCheckbox
Var CleanupCheckboxState
Var WindowerLabel
Var WindowerRadioPreserve
Var WindowerRadioOverwrite
Var WindowerRadioOverwriteState
Var AshitaLabel
Var AshitaRadioPreserve
Var AshitaRadioOverwrite
Var AshitaRadioOverwriteState
Var SkipRegistryChoice
Var SkipOldInstallChoice
Var SkipWindowerChoice
Var SkipAshitaChoice

# Ask before overwriting registry settings from previous FFXI installation.
Function previousSettingsCheckCreate
    # Default to assuming there's no previous settings so we can overwrite.
    StrCpy $OverwriteRegistry "false"
    StrCpy $OverwriteAshita "false"
    StrCpy $OverwriteWindower "false"
    StrCpy $SkipRegistryChoice "false"
    StrCpy $SkipOldInstallChoice "false"
    StrCpy $SkipWindowerChoice "false"
    StrCpy $SkipAshitaChoice "false"
    
    ClearErrors
    ReadRegStr $OldInstallLocation HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FFEraServer" "InstallLocation"
    
    ${If} ${Errors}
    ${OrIf} $OldInstallLocation == '"$INSTDIR"'
        ClearErrors
        ReadRegStr $OldInstallLocation HKEY_CURRENT_USER "${UNINSTALL_PATH}" ""
        ${If} ${Errors}
        ${OrIf} $OldInstallLocation == '"$INSTDIR"'
            ClearErrors
            ReadRegStr $OldInstallLocation HKEY_LOCAL_MACHINE "${UNINSTALL_PATH}" "InstallLocation"
            ${If} ${Errors}
            ${OrIf} $OldInstallLocation == '"$INSTDIR"'
                StrCpy $SkipOldInstallChoice "true"
            ${EndIf}
        ${EndIf}
    ${EndIf}
    
    ${If} ${RunningX64}
        StrCpy $RegFolder "SOFTWARE\WOW6432Node\PlayOnlineUS"
    ${Else}
        StrCpy $RegFolder "SOFTWARE\PlayOnlineUS"
    ${EndIf}
    
    ClearErrors
    ReadRegStr $0 HKEY_LOCAL_MACHINE "$RegFolder\InstallFolder" "0001"

    ${If} ${Errors}
        StrCpy $SkipRegistryChoice "true"
        StrCpy $OverwriteRegistry "true"
    ${EndIf}
    
    ${IfNot} ${SectionIsSelected} ${Launchers_Windower}
    ${OrIfNot} ${FileExists} "$INSTDIR\Windower\Windower.exe"
        StrCpy $SkipWindowerChoice "true"
        StrCpy $OverwriteWindower "true"
    ${EndIf}
    
    ${IfNot} ${SectionIsSelected} ${Launchers_Ashita}
    ${OrIfNot} ${FileExists} "$INSTDIR\Ashita\Ashita.exe"
        StrCpy $SkipAshitaChoice "true"
        StrCpy $OverwriteAshita "true"
    ${EndIf}
    
    ${If} $SkipRegistryChoice == "true"
    ${AndIf} $SkipOldInstallChoice == "true"
    ${AndIf} $SkipAshitaChoice == "true"
    ${AndIf} $SkipWindowerChoice == "true"
        Abort
    ${EndIf}
    
    !insertmacro MUI_HEADER_TEXT "A previous installation of FFXI was detected on your computer." \
    "Would you like to preserve previous settings or reset them?"
    
    nsDialogs::Create 1018
    Pop $Dialog
    
    ${If} $Dialog == error
        Abort
    ${EndIf}
    
    Var /GLOBAL OldInstallYOffset
    Var /GLOBAL WindowerYOffset
    Var /GLOBAL AshitaYOffset
    
    StrCpy $OldInstallYOffset 0
    StrCpy $WindowerYOffset 0
    StrCpy $AshitaYOffset 0
    
    # Provide option to overwrite previous registry settings.
    ${IfNot} $SkipRegistryChoice == "true"
        ${NSD_CreateLabel} 0 0 100% 10u "FFXI/Gamepad configuration detected (macros and in-game settings will NOT be affected)."
        Pop $RegistryLabel
        
        ${NSD_CreateFirstRadioButton} 10% 12u 35% 16u "Preserve Config"
        Pop $RegistryRadioPreserve
        
        ${NSD_CreateAdditionalRadioButton} 45% 12u 35% 16u "Reset to default"
        Pop $RegistryRadioOverwrite
        
        ${If} $RegistryRadioOverwriteState == ${BST_CHECKED}
            ${NSD_Check} $RegistryRadioOverwrite
        ${Else}
            ${NSD_Check} $RegistryRadioPreserve
        ${EndIf}
        
        IntOp $OldInstallYOffset $OldInstallYOffset + 36
        IntOp $WindowerYOffset $WindowerYOffset + 36
        IntOp $AshitaYOffset $AshitaYOffset + 36
    ${EndIf}
    
    ${IfNot} $SkipOldInstallChoice == "true"
        ${NSD_CreateLabel} 0 "$OldInstallYOffsetu" 100% 10u "A previous installation of FFEra was found at $OldInstallLocation."
        Pop $OldInstallLabel
        
        IntOp $OldInstallYOffset $OldInstallYOffset + 12
        
        ${NSD_CreateCheckbox} 10% "$OldInstallYOffsetu" 35% 16u "Migrate in-game settings, macros, addons, etc."
        Pop $MigrateCheckbox
        
        ${IfNot} $MigrateCheckboxState == ${BST_UNCHECKED}
            ${NSD_Check} $MigrateCheckbox
        ${EndIf}
        
        ${NSD_CreateCheckbox} 45% "$OldInstallYOffsetu" 35% 16u "Cleanup old install (recommended)"
        Pop $CleanupCheckbox
        
        ${IfNot} $CleanupCheckboxState == ${BST_UNCHECKED}
            ${NSD_Check} $CleanupCheckbox
        ${EndIf}
        
        IntOp $WindowerYOffset $WindowerYOffset + 36
        IntOp $AshitaYOffset $AshitaYOffset + 36
    ${EndIf}
    
    # Provide option to overwrite previous Windower settings.
    ${IfNot} $SkipWindowerChoice == "true"
        ${NSD_CreateLabel} 0 "$WindowerYOffsetu" 100% 10u "Windower found in the target directory."
        Pop $WindowerLabel
        
        IntOp $WindowerYOffset $WindowerYOffset + 12
        
        ${NSD_CreateFirstRadioButton} 10% "$WindowerYOffsetu" 35% 16u "Preserve Windower profiles"
        Pop $WindowerRadioPreserve
        
        ${NSD_CreateAdditionalRadioButton} 45% "$WindowerYOffsetu" 35% 16u "Reset Windower profiles to default"
        Pop $WindowerRadioOverwrite
        
        ${If} $WindowerRadioOverwriteState == ${BST_CHECKED}
            ${NSD_Check} $WindowerRadioOverwrite
        ${Else}
            ${NSD_Check} $WindowerRadioPreserve
        ${EndIf}
        
        IntOp $AshitaYOffset $AshitaYOffset + 36
    ${EndIf}
    
    # Provide option to overwrite previous Ashita settings.
    ${IfNot} $SkipAshitaChoice == "true"
        ${NSD_CreateLabel} 0 "$AshitaYOffsetu" 100% 10u "Ashita found in the target directory."
        Pop $AshitaLabel
        
        IntOp $AshitaYOffset $AshitaYOffset + 12
        
        ${NSD_CreateFirstRadioButton} 10% "$AshitaYOffsetu" 35% 16u "Preserve Ashita profiles"
        Pop $AshitaRadioPreserve
        
        ${NSD_CreateAdditionalRadioButton} 45% "$AshitaYOffsetu" 35% 16u "Reset Ashita profiles to default"
        Pop $AshitaRadioOverwrite
        
        ${If} $AshitaRadioOverwriteState == ${BST_CHECKED}
            ${NSD_Check} $AshitaRadioOverwrite
        ${Else}
            ${NSD_Check} $AshitaRadioPreserve
        ${EndIf}
    ${EndIf}

	nsDialogs::Show
FunctionEnd

Function previousSettingsCheckLeave
    ${IfNot} $SkipRegistryChoice == "true"
        ${NSD_GetState} $RegistryRadioOverwrite $RegistryRadioOverwriteState
        
        StrCpy $OverwriteRegistry "false"
        
        ${If} $RegistryRadioOverwriteState == ${BST_CHECKED}
            StrCpy $OverwriteRegistry "true"
        ${EndIf}
    ${EndIf}
    
    ${IfNot} $SkipOldInstallChoice == "true"
        ${NSD_GetState} $MigrateCheckbox $MigrateCheckboxState
        
        StrCpy $MigrateChoice "false"
        
        ${If} $MigrateCheckboxState == ${BST_CHECKED}
            StrCpy $MigrateChoice "true"
        ${EndIf}

        ${NSD_GetState} $CleanupCheckbox $CleanupCheckboxState
        
        StrCpy $CleanupChoice "false"
        
        ${If} $CleanupCheckboxState == ${BST_CHECKED}
            StrCpy $CleanupChoice "true"
        ${EndIf}
    ${EndIf}
    
    ${IfNot} $SkipAshitaChoice == "true"
        ${NSD_GetState} $AshitaRadioOverwrite $AshitaRadioOverwriteState
        
        StrCpy $OverwriteAshita "false"
        
        ${If} $AshitaRadioOverwriteState == ${BST_CHECKED}
            StrCpy $OverwriteAshita "true"
        ${EndIf}
    ${EndIf}
    
    ${IfNot} $SkipWindowerChoice == "true"
        ${NSD_GetState} $WindowerRadioOverwrite $WindowerRadioOverwriteState
        
        StrCpy $OverwriteWindower "false"
        
        ${If} $WindowerRadioOverwriteState == ${BST_CHECKED}
            StrCpy $OverwriteWindower "true"
        ${EndIf}
    ${EndIf}
FunctionEnd

######################################################################

Var DesktopShortcutsCheckbox

Function finishPageShow
    ${NSD_CreateCheckbox} 120u 170u 50% 20u "Create desktop shortcuts"
    Pop $DesktopShortcutsCheckbox
    SetCtlColors $DesktopShortcutsCheckbox 0x000000 0xffffff
    ${NSD_Check} $DesktopShortcutsCheckbox
FunctionEnd

Function finishPageLeave
    Var /GLOBAL DesktopShortcutsCheckboxState
    ${NSD_GetState} $DesktopShortcutsCheckbox $DesktopShortcutsCheckboxState
    
    ${If} $DesktopShortcutsCheckboxState == ${BST_CHECKED}
        ${If} ${FileExists} "$INSTDIR\Windower\Windower.exe"
            SetOutPath "$INSTDIR\Windower"
            CreateShortCut "$Desktop\${APP_NAME} on Windower.lnk" "$INSTDIR\Windower\Windower.exe" "" "$INSTDIR\${APP_NAME}.ico"
        ${EndIf}
        
        ${If} ${FileExists} "$INSTDIR\Ashita\Ashita.exe"
            SetOutPath "$INSTDIR\Ashita"
            CreateShortCut "$Desktop\${APP_NAME} on Ashita.lnk" "$INSTDIR\Ashita\Ashita.exe" "" "$INSTDIR\${APP_NAME}.ico"
        ${EndIf}
    ${EndIf}
FunctionEnd

######################################################################

LangString DESC_GameFiles ${LANG_ENGLISH} "Files directly related to the FFXI client itself."
LangString DESC_GameFiles_FFXI ${LANG_ENGLISH} "The main FFXI client."
LangString DESC_GameFiles_EraSpecificMods ${LANG_ENGLISH} "All the mods and customizations to the client for playing on Era. This includes making merits, spell mp costs, cast times, etc. display correctly."
LangString DESC_GameFiles_EnhancedMaps ${LANG_ENGLISH} "Enhanced maps that provide additional info by modifying the in-game maps."

LangString DESC_Launchers ${LANG_ENGLISH} "Launchers that enhance the FFXI experience by allowing you to play with various addons and plugins. At least one of these launchers is necessary for connecting to Era."
LangString DESC_Launchers_Windower ${LANG_ENGLISH} "Windower4 with profiles configured for connecting to Era."
LangString DESC_Launchers_Ashita ${LANG_ENGLISH} "Ashita3 with profiles configured for connecting to Era."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${GameFiles} $(DESC_GameFiles)
    !insertmacro MUI_DESCRIPTION_TEXT ${GameFiles_FFXI} $(DESC_GameFiles_FFXI)
    !insertmacro MUI_DESCRIPTION_TEXT ${GameFiles_EraSpecificMods} $(DESC_GameFiles_EraSpecificMods)
    !insertmacro MUI_DESCRIPTION_TEXT ${GameFiles_EnhancedMaps} $(DESC_GameFiles_EnhancedMaps)
    !insertmacro MUI_DESCRIPTION_TEXT ${Launchers} $(DESC_Launchers)
    !insertmacro MUI_DESCRIPTION_TEXT ${Launchers_Windower} $(DESC_Launchers_Windower)
    !insertmacro MUI_DESCRIPTION_TEXT ${Launchers_Ashita} $(DESC_Launchers_Ashita)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

LangString DESC_Uninstall_GameFiles ${LANG_ENGLISH} "Uninstall the FFXI client. Will not delete macros unless User Files is checked."
LangString DESC_Uninstall_Config ${LANG_ENGLISH} "Will delete all FFXI and Gamepad configurations from your system. This will affect all other FFXI installations you may have, so choose with care."
LangString DESC_Uninstall_UserFiles ${LANG_ENGLISH} "Check if you wish to delete all macros and in-game settings for your characters."
LangString DESC_Uninstall_Launchers ${LANG_ENGLISH} "Windower and Ashita. You may want to keep some of the files here."
LangString DESC_Uninstall_Launchers_Windower ${LANG_ENGLISH} "Check if you wish to delete all your Windower-related files, including profiles and addon settings, such as GearSwap."
LangString DESC_Uninstall_Launchers_Ashita ${LANG_ENGLISH} "Check if you wish to delete all your Ashita-related files, including profiles and addon settings, such as AshitaCast."

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Uninstall_GameFiles} $(DESC_Uninstall_GameFiles)
    !insertmacro MUI_DESCRIPTION_TEXT ${Uninstall_Config} $(DESC_Uninstall_Config)
    !insertmacro MUI_DESCRIPTION_TEXT ${Uninstall_UserFiles} $(DESC_Uninstall_UserFiles)
    !insertmacro MUI_DESCRIPTION_TEXT ${Uninstall_Launchers} $(DESC_Uninstall_Launchers)
    !insertmacro MUI_DESCRIPTION_TEXT ${Uninstall_Launchers_Windower} $(DESC_Uninstall_Launchers_Windower)
    !insertmacro MUI_DESCRIPTION_TEXT ${Uninstall_Launchers_Ashita} $(DESC_Uninstall_Launchers_Ashita)
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END

######################################################################

!system 'del tempinclude.nsh'
