@echo off
REM Path to LÖVE2D executable (update this if needed)
set LOVE_PATH="C:\Program Files\LOVE\love.exe"

REM Path to your game folder
set GAME_PATH=%~dp0

REM Launch the game
%LOVE_PATH% %GAME_PATH%
pause
