[Setup]
AppName=PORTEX
AppVersion=1.0.0
AppPublisher=MeLA Node
DefaultDirName={autopf}\PORTEX
DefaultGroupName=PORTEX
OutputBaseFilename=PORTEX-Installer-Setup
Compression=lzma2
SolidCompression=yes
OutputDir=installer_output
SetupIconFile=assets\icons\app_icon.ico
UninstallDisplayIcon={app}\PORTEX.exe
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\PORTEX.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\PORTEX"; Filename: "{app}\PORTEX.exe"
Name: "{autodesktop}\PORTEX"; Filename: "{app}\PORTEX.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\PORTEX.exe"; Description: "{cm:LaunchProgram,PORTEX}"; Flags: nowait postinstall skipifsilent
