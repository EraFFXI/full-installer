# full-installer
Creates the full installer for the FFEra game client

# Requirements
 * Final Fantasy XI http://www.playonline.com/ff11us/index.shtml
 * 7zip https://www.7-zip.org/
 * Python3 https://www.python.org/downloads/
 * NSIS v3 https://nsis.sourceforge.io/Download
 * NSIS plugin: Nsis7z https://nsis.sourceforge.io/Nsis7z_plug-in
 * NSIS plugin: Registry https://nsis.sourceforge.io/Registry_plug-in

# Usage
After installing all the components, you'll need to configure `Settings.ini`. Then you can run `UpdateFFXiArchive.py` with Python to prepare the archives and run `Main.nsi` with NSIS to create the installer.
