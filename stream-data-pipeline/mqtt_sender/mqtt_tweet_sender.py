import json
import numpy as np
from datetime import datetime
import time
import paho.mqtt.client as mqtt

# Load tweets file
json_file = '/app/data/tweets1.json'
gap = 4

BROKER = "mosquitto" 
PORT = 1883
mqtt_topic = "tweets_topic"
KEEPALIVE = 60

client = mqtt.Client()
client.connect(BROKER, PORT, KEEPALIVE)

with open(json_file, 'r') as file:
    tweets = json.load(file)
    while True:
        try:
            user = np.random.randint(len(tweets))
            tweet = np.random.randint(len(tweets[user]["tweets"]))

            now = datetime.now()
            formatted = now.strftime("%Y-%m-%d %H:%M:%S")

            text = tweets[user]["tweets"][tweet].encode('utf-8','ignore').decode("utf-8").replace('\n', ' ')
            text += "."
            text = text.replace('"', "")
            text = text.replace('\\', "")

            message = {
                "user_id": tweets[user]["id"],
                "tweet": text,
                "timestamp": formatted
            }

            message_json = json.dumps(message)
            print(message_json)

            client.publish(mqtt_topic, message_json)

        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")
        
        
        time.sleep(gap)
