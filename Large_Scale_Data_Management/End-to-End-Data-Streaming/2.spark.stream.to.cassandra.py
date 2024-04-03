from pyspark.sql import SparkSession
from pyspark.sql.types import (
    StructType,
    StructField,
    LongType,
    IntegerType,
    FloatType,
    StringType,
)
from pyspark.sql.functions import split, from_json, col

# Schema to Reconstruct String from JSON
songSchema = StructType(
    [
        StructField("name", StringType(), False),
        StructField("timestamp", LongType(), False),
        StructField("song", StringType(), False),
    ]
)

# Initialize Spark Session
spark = (
    SparkSession.builder.appName("SSKafka")
    .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0")
    .getOrCreate()
)
spark.sparkContext.setLogLevel("ERROR")

# Read and Cache local CSV for Augmentation. Escape double quotes
localDF = (
    spark.read.option("header", True)
    .option("quote", '"')
    .option("escape", '"')
    .csv("spotify-songs.csv")
)
# Rename column name to song, for easier JOIN
localDF = localDF.withColumnRenamed("name", "song")
# Cash the result for repeated computations
localDF.cache()

# Read Data from Kafka Stream
df = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", "localhost:29092")
    .option("subscribe", "test")
    .option("startingOffsets", "latest")
    .load()
)
# Convert JSON to Sting
sdf = (
    df.selectExpr("CAST(value AS STRING)")
    .select(from_json(col("value"), songSchema).alias("data"))
    .select("data.*")
)
# JOIN Song metadata from localDF to Streamed df ON column 'song'
sdf = sdf.join(localDF, "song", "leftOuter")


def writeToCassandra(writeDF, _):
    writeDF.write.format("org.apache.spark.sql.cassandra").mode("append").options(
        table="records", keyspace="spotify"
    ).save()


result = None
while result is None:
    try:
        # connect
        result = (
            sdf.writeStream.option("spark.cassandra.connection.host", "localhost:9042")
            .foreachBatch(writeToCassandra)
            .outputMode("update")  # Because we are streaming
            .trigger(
                processingTime="30 seconds"
            )  # Process a batch of stream data every 30sec
            .option("checkpointLocation", "chk-point-dir")  # For Fault-Tolerance
            .start()
            .awaitTermination()
        )
    except:
        pass
