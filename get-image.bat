@echo off

if "%~1"=="" (set "distro=Debian") else (set "distro=%~1")
if "%~2"=="" (set "image=debian.tar") else (set "image=%~2")

echo distro: %distro%
echo image: %image%
echo:

if exist "%image%" (
	echo The image %image% exists.
	goto :eof
)

echo The image %image% does not exists.
echo:

wsl --install %distro% --no-launch || goto :eof
echo:
wsl --export %distro% "%image%" > nul || goto :eof
wsl --unregister %distro% > nul || goto :eof
