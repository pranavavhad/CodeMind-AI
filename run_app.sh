#!/usr/bin/env bash
# CodeMind AI - REAL AI MODE (needs a free Groq API key in backend/.env)
cd "$(dirname "$0")/backend" || exit 1
if [ ! -f .env ]; then
  cp .env.example .env
  echo "A file backend/.env was created. Open it, paste your GROQ_API_KEY, then run this again."
  exit 0
fi
[ -d venv ] || { echo "Setting up Python environment, first time only..."; python3 -m venv venv; }
source venv/bin/activate
pip install -q -r requirements.txt
( sleep 3; (xdg-open http://localhost:8000 || open http://localhost:8000) >/dev/null 2>&1 ) &
echo "CodeMind AI is running at http://localhost:8000  (press Ctrl+C to stop)"
uvicorn app.main:app --port 8000
