from python:alpine3.14

workdir /app

copy requirements.txt requirements.txt

run pip3 install -r requirements.txt

copy . .

expose 8000


cmd ["python", "manage.py", "runserver", "0.0.0.0:8000"]