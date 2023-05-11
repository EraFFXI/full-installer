import configparser
import re
import os
import subprocess

config = configparser.ConfigParser()
config.read('Settings.ini')

############################
# Client Ver
############################
def client_ver():
    with open(config['Archive Settings']['FFXiSourceDir'] + r"\SquareEnix\FINAL FANTASY XI\patch.cfg") as file:
        match = re.search(r"^([\d_]+) .*\n}", file.read(), re.MULTILINE)
        
        if match:
            return match.group(1)
        
        return ''

clientVersion = client_ver()

archiveName = config['Archive Settings']['FFXiArchiveName'].replace('${CLIENT_VERSION}', clientVersion)
archivePath = os.path.abspath(config['Compile Settings']['OutputDir'] + "\\" + archiveName)
archiveSize = 0

# "C:\Program Files\7-Zip\7z.exe" l "%iniOutputDir%\%iniFFXiArchiveName%" | findstr /r "files^,.*folders"


cmd = '"C:\Program Files\\7-Zip\\7z.exe" l "'+archivePath+'"'

output = subprocess.run(cmd, shell=False, check=True, capture_output=True, text=True)

match = re.search(r"(\d+)\s+\d+\s+\d+ files, \d+ folders", output.stdout, re.IGNORECASE)

if match:
    archiveSize = int(match.group(1)) // 1024

print(archiveSize)

with open("tempinclude.nsh", "w") as f:
    f.write(f'!define INSTALLER_NAME "{config["Compile Settings"]["InstallerName"]}"\n')
    f.write(f'!define OUTPUT_DIR "{config["Compile Settings"]["OutputDir"]}"\n')
    f.write(f'!define FFXI_ARCHIVE_NAME "{archiveName}"\n')
    f.write(f'!define FFXI_ARCHIVE_UNCOMPRESSED_SIZE "{archiveSize}"\n')
    f.write(f'!define FFXI_ARCHIVE_CLIENT_VERSION "{clientVersion}"\n')
    f.write(f'!define SERVER_NAME "{config["Installer Settings"]["ServerName"]}"\n')
    f.write(f'!define DEFAULT_DIR "{config["Installer Settings"]["DefaultDir"]}"\n')
    f.write(f'!define DESCRIPTION "{config["Installer Settings"]["Description"]}"\n')
