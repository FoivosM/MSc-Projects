import json
import asyncio
from aiokafka import AIOKafkaProducer
import pandas as pd
import time
from datetime import datetime, timezone
from faker import Faker

# Create a Faker instance
fake = Faker()
topic = 'test'
# Read Songs table
df = pd.read_csv('spotify-songs.csv')
df.dropna(subset=['name'], inplace=True)

# Create a list of users listening to Spotify
users = [fake.name() for _ in range(10)]
users.append('Phevos Margonis')

def serializer(value):
    '''Convert data to JSON before streaming'''
    return json.dumps(value).encode() 

async def produce():
    '''Simulate data stream'''
    global users

    producer = AIOKafkaProducer(
        bootstrap_servers='localhost:29092', 
        value_serializer=serializer,
        compression_type="gzip")

    # Start the streaming to Kafka
    await producer.start()

    # Stream simulated data
    for _,name in enumerate(users):
        # song = df[df['name'].str.contains('From "')]['name'].sample(n=1).iloc[0] # DEBUG escaped ""
        song = df.name.sample().iloc[0]
        now_utc = datetime.now(timezone.utc)
        timestamp = int(now_utc.timestamp() * 1000)
        data = {"name": name, "song": song, "timestamp": timestamp} # Create a data entry
        await producer.send(topic, data)

    await producer.stop()

loop = asyncio.get_event_loop()

# Send 10 batches, one every 10 seconds, containing data for all users.
for _ in range(10):
    result = loop.run_until_complete(produce())
    time.sleep(10)


