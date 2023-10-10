FROM python:3.8
WORKDIR /Flask-Python-E-Commerce-Website
COPY . .
RUN pip install -r requirements.txt
ENV FLASK_APP=application.py
CMD ["flask", "run", "--host=0.0.0.0"]
