@echo off

if "%~1"=="" (set "distro=debian") else (set "distro=%~1")
if "%~2"=="" (set "location=C:\WSL") else (set "location=%~2")
if "%~3"=="" (set "image=debian.tar") else (set "image=%~3")

echo distro: %distro%
echo location: %location%
echo image: %image%
echo:

wsl --unregister %distro% > nul 2>&1

mkdir "%location%" > nul 2>&1
wsl --import %distro% "%location%\%distro%" "%image%" || goto :eof
echo:

wsl -d %distro% -u root "./setup-cache-root" || goto :eof
wsl -t %distro% > nul 2>&1
echo:

wsl -d %distro% -u root "./setup-user" || goto :eof
wsl -t %distro% > nul 2>&1
echo:

wsl -d %distro% -u root "./setup-update" || goto :eof
wsl -t %distro% > nul 2>&1
