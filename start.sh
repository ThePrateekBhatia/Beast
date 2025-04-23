source .venv/bin/activate && python3 update.py && gunicorn -k uvicorn.workers.UvicornWorker -w 1 web.wserver:app --bind 0.0.0.0:8080
