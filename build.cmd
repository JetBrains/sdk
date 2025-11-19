@echo off

setlocal

echo %* | findstr /C:"-pack" >nul
if %errorlevel%==0 (
    set skipFlags="/p:SkipUsingCrossgen=false /p:SkipBuildingInstallers=false"
) else (
    REM skip crossgen for inner-loop builds to save a ton of time
    set skipFlags="/p:SkipUsingCrossgen=true /p:SkipBuildingInstallers=true"
)
set DOTNET_SYSTEM_NET_SECURITY_NOREVOCATIONCHECKBYDEFAULT=true
rem Hardcode default build to exclude test projects by building the source-build solution filter.
rem Users can still override by passing their own -projects argument after this default.
powershell -NoLogo -NoProfile -ExecutionPolicy ByPass -command "& """%~dp0eng\common\build.ps1""" -restore -build -projects """source-build.slnf""" -msbuildEngine dotnet %skipFlags% /tlp:summary %*"
exit /b %ErrorLevel%
