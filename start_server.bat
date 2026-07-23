@echo off
title Sparsh Setu NGO Website Server
echo ===================================================
echo     Starting Sparsh Setu NGO Local Web Server...
echo ===================================================
echo.
echo Opening http://localhost:8000 in Google Chrome...
echo.

start http://localhost:8000/

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"

pause
