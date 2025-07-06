# Superset visualisation project

This repository delivers a **ready-to-run data platform** that transforms the raw Twitter-personality data into an interactive, real-time dashboard in **Apache Superset**. The project authomatically sets up everything except the `Superset` connections and the charts, which have to be manually made. 

The architecture integrates batch processing and stream processing for real-time data, satisfying the project’s requirements while keeping the deployment lean (using just one Docker Compose files, with zero manual container setup). Key components and their roles are outlined below:

| Layer                   | Tooling                                                         | Role in the Pipeline                                                             |
|-------------------------|-----------------------------------------------------------------|----------------------------------------------------------------------------------|
| **Batch Storage**       | **Apache Hive**                                                | Holds static user graph (`edges1`), user metadata (`users1`), and MBTI labels.   |
| **Stream Ingestion**    | **Python + Paho-MQTT → Mosquitto → Kafka**                     | Publishes live tweets via MQTT; an MQTT–Kafka bridge forwards them to Kafka.     |
| **Real-time Analytics** | **Apache Druid**                                               | Consumes the Kafka topic and exposes a continuously-updated tweets table.        |
| **Visualization**       | **Apache Superset**                                            | Dashboards that blend static MBTI traits with streaming tweet activity.          |


#### Note:
For the project to run correctly, make sure the `tweets1.json`, `edges1.json`, `users1.json` and `mbti_labels.csv` files are placed inside the `/data` folder.

#### Note:
The project has been tested on a Windows 10 local machine.






---
# 1. Description of the data

The dataset consists of four separate files, each capturing a different aspect of the Twitter user ecosystem. Together, they offer a comprehensive view of user behavior, personality, and social connections.



### 🔗 `edges1.json`
Describes the **network relationships** between users.

Each record includes:
- `follows`: List of user IDs this user follows  
- `is_followed_by`: List of user IDs following this user  
- `id`: Unique identifier of the user  

This file models a directed social graph.



### 👤 `users1.json`
Contains **user profile metadata**.

Each entry includes:
- `screen_name`: The user’s Twitter handle
- `location`: Profile location (free text)
- `verified`: Boolean flag indicating if the account is verified
- `statuses_count`: Total number of tweets posted
- `total_retweet_count`: Cumulative retweets the user has received
- `total_favorite_count`: Cumulative likes the user has received
- `total_hashtag_count`: Total hashtags the user has used
- `total_mentions_count`: Total mentions the user has made
- `total_media_count`: Total media (images, videos) the user has posted
- `id`: Unique user ID

This file provides context about each user's identity and public profile.



### 🧠 `mbti_labels.csv`
Stores **personality classifications** for each user, based on the MBTI model.

Columns:
- `id`: User ID (matching the other files)  
- `mbti_personality`: MBTI type
- `pers_id`: Alternative personality identifier  

This data enables behavioral and psychological analysis.


### 📝 `tweets1.json`
Contains the **tweets authored** by each user.

Each record includes:
- `id`: User ID  
- `tweets`: List of tweet texts (strings) authored by that user  

This file is used primarily for real-time ingestion and streaming analytics.







---
# 2. Description of the project

This section is an in-depth description of the project: what files it has, what each file does and how each file connects to each other.

The project is organised as follows:

```

│   combined-docker-compose.yml
│
├───data
│       edges1.json                         <-- Must be added
│       mbti_labels.csv                     <-- Must be added
│       tweets1.json                        <-- Must be added
│       users1.json                         <-- Must be added
│
├───static-data-pipeline
│   ├───Hive
│   │   │   Dockerfile_hive
│   │   │
│   │   └───scripts
│   │           convert_to_jsonl.sh
│   │           create_tables.sh
│   │           pipeline.sh
│   │
│   └───Superset
│       │   Dockerfile_superset
│       │   superset_config.py
│       │
│       └───scripts
│               start_superset.sh
│
└───stream-data-pipeline
    │   mosquitto.conf
    │   mqtt-source.json
    │
    └───mqtt_sender
            Dockerfile
            mqtt_tweet_sender.py

```

The `data` folder contains the four data files necessary to run the project. The `static-data-pipeline` folder contains the files that handle the static data, and the `stream-data-pipeline` contains the files for the stream data. 


## 2.1 static-data-pipeline

Inside the folder, the `docker-compose-static-data.yml` file is responsible for launching the batch processing environment, which includes two services: `Apache Hive` and `Apache Superset`. These containers enable the storage of static data and its visualization through `Superset`.

### `Hive` 
The `hive` container is the first service built, using a custom image defined in `Dockerfile_hive`. This image extends the official `apache/hive:3.1.3` base image and includes additional tools and scripts required to automate the ingestion of static data into `Hive` tables.

When the container starts, it executes the `pipeline.sh` script, which orchestrates the entire ingestion process:

1. `convert_to_jsonl.sh` – Converts the original .json files into .jsonl (JSON Lines) format, which is more suitable for ingestion into `Hive`. To do so, first it creates the JSONL files and then it organises them in folders, for better data handling.

2. `create_tables.sh` – Defines the `Hive` tables `edges1`, `users1`, and `mbti_labels`, and loads the converted data into them.


### `Superset` 
The `superset` container is the second service launched by the `docker-compose-static-data.yml` file. With `Dockerfile_superset`, it builds a custom image based on the official `apache/superset:latest` image, extending it with the necessary dependencies and initialization scripts to fully automate the setup of the `Superset` environment:

- **Adds required Python libraries** to connect Superset with Hive and MySQL.
- **Includes a startup script** (`start_superset.sh`) that:
  - Initializes the Superset database
  - Creates an admin user (if it doesn't already exist)
  - Starts the web server on port `8088`
- **Loads a basic configuration file** (`superset_config.py`) that sets a secret key for Superset.

Once running, you can access Superset at `http://localhost:8088/` using:

- **Username:** `admin`  
- **Password:** `admin`

From there, Superset can connect directly to Hive to explore the static data and build visualizations.











## 2.2 stream-data-pipeline

Bla bla bla bla





---
# 3. How to launch the project

In order to make everything work and connect all the databases with `superset`, there are several steps that need to be executed.

## 3.1 Static data
Firstly we will start with the **static data**. You need to open a `terminal` and go to the folder where the repository or project is located. Then, you need to run the following command:

```
docker-compose -f static-data-pipeline/docker-compose-static-data.yml up
```

This will execute the [docker-compose](static-data-pipeline/docker-compose-static-data.yml) file of the **static data** and set up everything to connect `Hive` with `Superset`. This process will last like a minute, and when it's done the following commands will appear on the `terminal`:

![Alt text](report/figures/01-static-data-docker-compose-terminal-output.PNG)

Then, to access `Superset` the port `http://localhost:8088/` should be oppened and introduce the following credentials:

- USERNAME: **admin**
- PASSWORD: **admin**

After that, the `Superset` main page will open. 

Now you need to connect `Apache Hive` to `Superset`. To do so, click on **Settings** --> **Database Connections**:

![Alt text](report/figures/02-superset-connection.PNG)

Then, click on **+ DATABASE** and select `Apache Hive` on the **SUPPORTED DATABASES** scrolling window:

![Alt text](report/figures/03-Connect-hive-to-superset.jpg)

Then, the following will appear:

![Alt text](report/figures/04-test-connection.PNG)

and you need to introduce the following command on **SQLALCHEMI URY**:

```
hive://hive@hive:10000/default
```

After that, click on **CONNECT** and close the **Connect a database** window. 

Now, `Apache Hive` and `Superset` should be connected. To check it, go to **SQL** --> **SQL Lab** and check whether on **SEE TABLE SCHEMA** appear the following three tables:
- edges1
- mbti_labels
- users1

If everything is working correctly, this is what you should see: 

![Alt text](report/figures/05-see-tables.jpg)

Now the stream data needs to be connected.




## 3.2 Stream data

TO DO

```
docker-compose -f stream-data-pipeline/docker-compose-dynamic-data.yml up
```








---
# 4. Charts and dashboard

Bla bla bla bla




---
# Authors

- Julen Ercibengoa
- Erik








docker-compose -f combined-docker-compose.yml up

hive://hive@hive:10000/default

druid://druid:9999/druid/v2/sql/


## TO CHECK 