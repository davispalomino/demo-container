ARG IMAGE
FROM $IMAGE
COPY /app .
RUN pip install -r requirements.txt
CMD ["gunicorn", "-b", "0.0.0.0:80","-w","1","--log-level","DEBUG","-t","800","wsgi:app"]