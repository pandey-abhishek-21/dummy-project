FROM python:3.7-alpine

# ADD test.py /

COPY ../python-project /

RUN pip install PyYAML

CMD [ "python", "python-project/test.py" ]