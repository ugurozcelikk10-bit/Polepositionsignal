from fastapi import FastAPI
import subprocess
import sys

app = FastAPI()

@app.get("/")
def root():
    return {"status": "Polepositionsignal running"}

@app.get("/scan")
def run_scan():
    try:
        result = subprocess.run(
            [sys.executable, "scanner/okx_scanner.py"],
            capture_output=True,
            text=True,
            timeout=120
        )
        return {
            "ok": True,
            "output": result.stdout[-4000:]
        }
    except Exception as e:
        return {"ok": False, "error": str(e)}
