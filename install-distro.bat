@echo off

set "cache="
@REM set "cache=%cache% apt-update"
set "cache=%cache% curl"
set "cache=%cache% elan"
set "cache=%cache% micromamba"
set "cache=%cache% npm"
set "cache=%cache% nvm"
set "cache=%cache% pip"
set "cache=%cache% vscode-server"

set "install="
set "install=%install% locale"
set "install=%install% wget"
set "install=%install% vscode-server"
set "install=%install% vscode-extension"
set "install=%install% less"
set "install=%install% man"
set "install=%install% ssh"
set "install=%install% vim"
set "install=%install% curl"
set "install=%install% git"
set "install=%install% neovim"
set "install=%install% clang"
set "install=%install% golang"
set "install=%install% node"
set "install=%install% typescript"
set "install=%install% micromamba"
set "install=%install% python"
set "install=%install% elan"
set "install=%install% lean"
set "install=%install% latex"
set "install=%install% blueprint"

if "%~1"=="" (set "distro=debian") else (set "distro=%~1")
if "%~2"=="" (set "location=C:\WSL") else (set "location=%~2")
if "%~3"=="" (set "image=debian.tar") else (set "image=%~3")

echo distro: %distro%
echo location: %location%
echo image: %image%
echo:

call :main & goto :eof

:run__root
	wsl -d %distro% -u root "%1" || exit /b 1 & goto :eof

:run__user
	wsl -d %distro% "%1" || exit /b 1 & goto :eof

:run_terminate
	wsl -t %distro% > nul 2>&1 & echo: & goto :eof

:run_root
	call :run__root "%1" || exit /b 1 & call :run_terminate & goto :eof

:run_user
	call :run__user "%1" || exit /b 1 & call :run_terminate & goto :eof

:main
	wsl --unregister %distro% > nul 2>&1

	mkdir "%location%" > nul 2>&1
	wsl --import %distro% "%location%\%distro%" "%image%" || goto :eof
	echo:

	call :run_root "./setup-user" || goto :eof

	call :run_root "./cache/apt" || goto :eof

	call :run_root "./install/gnupg" || goto :eof
	call :run_root "./install/patch" || goto :eof
	call :run_user "./setup-config" || goto :eof

	for %%i in (%cache%) do call :run__root "./cache/%%i" || goto :eof
	call :run_terminate

	call :run_root "./setup-update" || goto :eof

	for %%i in (%install%) do call :run_root "./install/%%i" || goto :eof
goto :eof
