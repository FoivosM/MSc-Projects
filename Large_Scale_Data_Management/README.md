# Large Scale Data Management

## 🐘 MapReduce
This project uses Hadoop Distributed File System (HDFS) and MapReduce to process and analyze large datasets across distributed clusters. Utilizing Vagrant and Docker for virtualization, we detail two MapReduce jobs (in ☕ Java): a word count of ”Don Quixote” and analysis of Spotify song metrics for danceability.
- **Code**: [Driver](https://github.com/FoivosM/MSc-Projects/blob/master/Large_Scale_Data_Management/MapReduce/Driver.java), [MRjob](https://github.com/FoivosM/MSc-Projects/blob/master/Large_Scale_Data_Management/MapReduce/DanceabilityAnalysis.java) 
- **Report**: [PDF](https://github.com/FoivosM/MSc-Projects/blob/master/Large_Scale_Data_Management/MapReduce/LSDM.A1.report.pdf)

## 🎵 End-to-End Data Streaming
![lsdm.a2](../img/lsdm.a2.png)
In this project, we utilize the **Apache Spark** framework and the **Apache Cassandra NoSQL** database to create a Structured Streaming Spark process. We begin by generating data that simulate the activity (logs) of **Spotify** users, which we forward to a **Kafka broker**. Spark consumes Kafka messages, processes them further and uses Cassandra as a sink to persist information. We simulate this real-world environment using a virtual machine with the Spark framework installed locally, and the Kafka-broker and Cassandra NoSQL on two separate **Docker containers**.
- **Code**: [Kafka](https://github.com/FoivosM/MSc-Projects/blob/master/Large_Scale_Data_Management/End-to-End-Data-Streaming/1.stream.to.kafka.py), [Spark](https://github.com/FoivosM/MSc-Projects/blob/master/Large_Scale_Data_Management/End-to-End-Data-Streaming/2.spark.stream.to.cassandra.py), [Cassandra](https://github.com/FoivosM/MSc-Projects/blob/master/Large_Scale_Data_Management/End-to-End-Data-Streaming/3.create.cassandra.table.cql)
- **Report**: [PDF](https://github.com/FoivosM/MSc-Projects/blob/master/Large_Scale_Data_Management/End-to-End-Data-Streaming/0.LSDM.A2.report.pdf)