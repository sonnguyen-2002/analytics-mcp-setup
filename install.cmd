@echo off
rem Double-click to connect Claude Code and Codex to Google Analytics (see README.md).
rem Extra options are passed on, e.g.  install.cmd -Name analytics-client -Project my-project
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*
echo.
pause
