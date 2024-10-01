CREATE TABLE "Movie"(
id int,
adult varchar(10),
budget int,
homepage varchar(230),
original_language varchar(10),
original_title varchar(110),
title varchar(110),
tagline varchar(280),
overview varchar(1000),
popularity varchar(10),
release_date date,
revenue int,
runtime varchar(10),
PRIMARY KEY(id)
);

CREATE TABLE "Genre"(
    id INT,
    name VARCHAR(80),
    PRIMARY KEY("id")
);

CREATE TABLE "Collection"(
    id INT,
    name VARCHAR(80),
    PRIMARY KEY("id")
);

CREATE TABLE "Productioncompany"(
    id INT,
    name VARCHAR,
    PRIMARY KEY("id")
);

CREATE TABLE "Movie_cast"(
    id INT,
    movie_id INT,
    character VARCHAR,
    gender INT2,
    person_id INT,
    name VARCHAR(50),
    PRIMARY KEY("id")
 );

CREATE TABLE "Movie_crew"(
    id INT,
    movie_id INT,
    department VARCHAR(20),
    gender INT2,
    person_id INT,
    job VARCHAR,
    name VARCHAR(50),
    PRIMARY KEY("id")
);

CREATE TABLE "Keyword"(
    id INT,
    name VARCHAR(80),
    PRIMARY KEY("id")
);

---------------------------------

CREATE TABLE "Haskeyword"(
    movie_id INT,
    key_id INT
);

CREATE TABLE "Belongstocollection"(
    movie_id INT,
    collection_id INT
);

CREATE TABLE "Hasgenre"(
    movie_id INT,
    genre_id INT
);

CREATE TABLE "Hasproductioncompany"(
    movie_id INT,
    pc_id INT
);

CREATE TABLE "Ratings"(
    user_id INT,
	movie_id INT,
    rating REAL
);

--DROP TABLE "Movie", "Genre", "Collection", "Productioncompany", "Movie_cast", "Movie_crew", "Keyword", "Haskeyword", "Belongstocollection", "Hasgenre", "Hasproductioncompany", "Ratings";
