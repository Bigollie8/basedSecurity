FROM python:3.8

EXPOSE 5000/tcp

WORKDIR /app

COPY requirement.txt .

COPY *.py .

RUN pip install -r requirement.txt

ENV PYTHONPATH "${PYTHONPATH}:/basedSecurity/"

CMD [ "python", "./backend.py"]
