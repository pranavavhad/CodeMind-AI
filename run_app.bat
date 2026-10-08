@echo off
REM CodeMind AI - REAL AI MODE (needs a free Groq API key in backend\.env)
cd /d "%~dp0backend"
if not exist .env (
  copy .env.example .env >nul
  echo A file backend\.env was created. Open it, paste your GROQ_API_KEY, then run this again.
  pause
  exit /b
)
if not exist venv (
  echo Setting up Python environment, first time only...
  python -m venv venv
)
call venv\Scripts\activate
pip install -q -r requirements.txt
start "" cmd /c "timeout /t 4 >nul & start http://localhost:8000"
echo.
echo CodeMind AI is running at http://localhost:8000  (press Ctrl+C to stop)
uvicorn app.main:app --port 8000
