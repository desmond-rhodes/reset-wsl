@echo off

if "%~1"=="" (set "distro=debian") else (set "distro=%~1")

echo distro: %distro%
echo:

wsl -d %distro% "./backup-config"
