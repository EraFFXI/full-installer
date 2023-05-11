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

archiveName = config['Archive Settings']['FFXiArchiveName'].replace('${CLIENT_VERSION}', client_ver())
archivePath = os.path.abspath(config['Compile Settings']['OutputDir'] + "\\" + archiveName)

cmd = '"C:\Program Files\\7-Zip\\7z.exe" u -t7z "'+archivePath+'" "FINAL FANTASY XI\\*" -ir!"PlayOnlineViewer\\*" -xr!"PlayOnlineViewer\\usr\\*" -xr!"PlayOnlineViewer\\tmp\\*" -xr!"FINAL FANTASY XI\\USER\\*" -xr!"FINAL FANTASY XI\\TEMP\\*"'

args = [r'C:\Program Files\7-Zip\7z.exe', 'u', '-t7z', archivePath, '"FINAL FANTASY XI\\*"', '-ir!"PlayOnlineViewer\\*"', '-xr!"PlayOnlineViewer\\usr\\*"', '-xr!"PlayOnlineViewer\\tmp\\*"', '-xr!"FINAL FANTASY XI\\USER\\*"', '-xr!"FINAL FANTASY XI\\TEMP\\*"']

print(subprocess.list2cmdline(args))
print(cmd)

output = subprocess.run(cmd, shell=False, check=True, capture_output=False, text=True, cwd=config['Archive Settings']['FFXiSourceDir']+"\\SquareEnix")

