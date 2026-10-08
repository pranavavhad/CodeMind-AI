#!/usr/bin/env bash
# CodeMind AI - DEMO MODE (no API key, no internet needed after setup)
cd "$(dirname "$0")/backend" || exit 1
[ -d venv ] || { echo "Setting up Python environment, first time only..."; python3 -m venv venv; }
source venv/bin/activate
pip install -q -r requirements.txt
export DEMO_MODE=1
( sleep 3; (xdg-open http://localhost:8000 || open http://localhost:8000) >/dev/null 2>&1 ) &
echo "CodeMind AI demo is running at http://localhost:8000  (press Ctrl+C to stop)"
uvicorn app.main:app --port 8000
