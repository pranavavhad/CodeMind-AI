# CodeMind AI

A simple web app that **explains Python code line by line**, **adds comments and docstrings**, and lets you **chat with a Co-Pilot chatbot** about your code.

* **Chatbot:** the Co-Pilot chat tab answers questions about your code.
* **External APIs:** (1) **Groq API** (LLM) for the explanations, comments and chat, and (2) **GitHub** to import a Python file from a link.
* **Safety check:** after commenting, the app proves your code is unchanged (it compares the code's syntax tree with comments and docstrings removed). If the AI changes anything, it retries and then falls back to safe comments.

## Quick start: DEMO MODE (no API key, no internet needed)

Needs only Python 3.11+ installed.

* **Windows:** double-click `run_demo.bat`
* **Mac / Linux:** run `./run_demo.sh`

Your browser opens at http://localhost:8000. In demo mode the answers come from built-in rules that read the code's syntax tree, not from an AI model, so a yellow **DEMO MODE** badge is shown. The first run installs the Python packages (about a minute).

## Real AI mode (Groq)

1. Get a free API key at https://console.groq.com
2. Run `run_app.bat` (Windows) or `./run_app.sh` (Mac/Linux). The first time it creates `backend/.env`; open it and paste your key as `GROQ_API_KEY=...`
3. Run the script again. The badge now says **AI mode: Groq**.

## Suggested demo script (3 minutes)

1. Pick **Fibonacci (recursion)** from "Try a sample" and press **Explain & Comment**.
2. Show the **Explanation** tab. Switch the level to *beginner* and run again to show the wording change.
3. Open **Commented Code**: point out the green comments, the docstring and the **Verified: your code is unchanged** badge. Click Copy or Download.
4. Open **Co-Pilot Chat** and click the chips: "What is the time complexity?", "Explain line 3".
5. Paste a public GitHub link such as `https://github.com/<user>/<repo>/blob/main/<file>.py` and press **Import** (needs internet).
6. Type a syntax error (for example `def broken(:`) to show the friendly error message.

## Project structure

```
CodeMind_AI/
  backend/                FastAPI server
    app/
      main.py             app setup, serves the built frontend
      config.py           settings (.env)
      routes.py           the 4 endpoints
      schemas.py          request/response models and validation
      services/
        llm_service.py      Groq API calls (external API 1)
        explain_service.py  line-by-line explanation
        comment_service.py  commenting + the "code unchanged" validator
        chat_service.py     Co-Pilot chatbot
        github_service.py   GitHub import (external API 2)
        demo_service.py     rule-based demo mode (no AI)
    tests/                pytest tests (28)
  frontend/               React + Vite + Tailwind (frontend/dist is the built app)
  run_demo.bat / .sh      one-click demo
  run_app.bat / .sh       one-click real AI mode
```

## API

| Method | Endpoint | Body | Returns |
|---|---|---|---|
| POST | `/api/explain` | `{code, level}` | overview + explanation for every line |
| POST | `/api/comment` | `{code}` | commented code + `validation_passed` + `used_fallback` |
| POST | `/api/chat` | `{code, history, message}` | `{reply}` |
| POST | `/api/import-github` | `{url}` | `{code, filename}` |
| GET | `/health` | | `{status, demo_mode}` |

Interactive API docs: http://localhost:8000/docs

## Development

```
# backend (terminal 1)
cd backend
python -m venv venv && venv\Scripts\activate      # Mac/Linux: source venv/bin/activate
pip install -r requirements.txt
set DEMO_MODE=1                                   # optional (Mac/Linux: export DEMO_MODE=1)
uvicorn app.main:app --reload

# frontend (terminal 2)
cd frontend
npm install
npm run dev            # http://localhost:5173
npm run build          # rebuilds frontend/dist
```

## Tests

```
cd backend
python -m pytest -v
```
The Groq calls are mocked, so the tests run without an API key or internet. They cover the validator, the missing-line retry, the fallback, input validation, GitHub link handling and demo mode.

## Limits

* Python code only, up to 300 lines (`MAX_CODE_LINES` in `.env`).
* The submitted code is only read, never executed.
