@echo off
title Trader Platform
echo Starting Trader Platform...
echo.

echo Starting backend (FastAPI on port 8000)...
cd /d "%~dp0backend"
start "Trader Backend" cmd /k "python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"

echo Starting frontend (Next.js on port 3000)...
cd /d "%~dp0frontend"
start "Trader Frontend" cmd /k "npx next dev -p 3000"

echo.
echo Backend:  http://127.0.0.1:8000/api/health
echo Frontend: http://127.0.0.1:3000
echo.
echo Close both windows to stop the servers.
pause
