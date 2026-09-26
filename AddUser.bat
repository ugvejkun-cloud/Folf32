@echo off
cd /d "%~dp0"
title Fouf32 Whitelist Manager
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0AddUser.ps1"
