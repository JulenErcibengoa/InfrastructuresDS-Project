# Superset visualisation project

(Project explanation)





---
# 1. Description of the data

Bla bla bla bla







---
# 2. Description of the project

Bla bla bla




## 2.1 Static data

Bla bla bla bla




## 2.2 Stream data

Bla bla bla bla






# 3. How to start the project

In order to make everything work and connect all the databases with `superset`, there are several steps that need to be executed.

### 3.1 Static data
Firstly we will start with the **static data**. You need to open a `terminal` and go to the folder where the repository or project is located. Then, you need to run the following command:

```
docker-compose -f static-data-pipeline/docker-compose-static-data.yml up
```

This will execute the [docker-compose](static-data-pipeline/docker-compose-static-data.yml) file of the **static data** and set up everything to connect `hive` with `superset`. This process will last like a minute, and when it's done the following commands will appear on the `terminal`:

![Alt text](report/figures/01-static-data-docker-compose-terminal-output.PNG)

Then, the port `http://localhost:8088/` should be oppened to access `Superset` and introduce the following:

- USERNAME: **admin**
- PASSWORD: **admin**

After that, the `Superset` main page will open. Then, you need to connect `Apache Hive` to `Superset`. To do so, click on **Settings** --> **Database Connections**:

![Alt text](report/figures/02-superset-connection.PNG)

Then, click on **+ DATABASE** and select `Apache Hive` on the **SUPPORTED DATABASES** scrolling window:

![Alt text](report/figures/03-Connect-hive-to-superset.jpg)


### 3.2 Dynamic data




---
# 4. Expected outcome

Bla bla bla bla




---
# Authors

- Julen Ercibengoa
- Erik