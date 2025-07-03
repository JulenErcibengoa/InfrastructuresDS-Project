FROM python:3.10-slim

WORKDIR /app

RUN pip install paho-mqtt numpy

COPY mqtt_tweet_sender.py ./mqtt_tweet_sender.py

CMD ["python", "mqtt_tweet_sender.py"]