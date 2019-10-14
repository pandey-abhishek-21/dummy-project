FROM python:3.7-alpine

# ADD test.py /

COPY python-project /

RUN pip install PyYAML
RUN ls


CMD [ "python", "./test.py" ]
# CMD [ "CD" , "python-project/"]
RUN ls -ltr
