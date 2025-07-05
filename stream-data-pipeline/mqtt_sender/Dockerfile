FROM python:3.10-slim

WORKDIR /app

COPY mqtt_tweet_sender.py /app/

RUN pip install numpy paho-mqtt==1.6.1

CMD ["python", "mqtt_tweet_sender.py"]



