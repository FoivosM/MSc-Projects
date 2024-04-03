DROP KEYSPACE IF EXISTS spotify;

CREATE KEYSPACE IF NOT EXISTS spotify
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE IF NOT EXISTS spotify.records (
    name text,
    timestamp timestamp,
    song text,
    artists text,
    duration_ms text,
    album_name text,
    album_release_date date,
    danceability float,
    energy float,
    key tinyint,
    loudness float,
    mode tinyint,
    speechiness float,
    acousticness float, 
    instrumentalness float,
    liveness float,
    valence float,
    tempo float,
    PRIMARY KEY ((name), timestamp)
) ;
