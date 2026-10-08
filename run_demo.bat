@echo off
REM CodeMind AI - DEMO MODE (no API key, no internet needed after setup)
cd /d "%~dp0backend"
if not exist venv (
  echo Setting up Python environment, first time only...
  python -m venv venv
)
call venv\Scripts\activate
pip install -q -r requirements.txt
set DEMO_MODE=1
start "" cmd /c "timeout /t 4 >nul & start http://localhost:8000"
echo.
echo CodeMind AI demo is running at http://localhost:8000  (press Ctrl+C to stop)
uvicorn app.main:app --port 8000
