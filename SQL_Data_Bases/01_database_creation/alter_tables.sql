ALTER TABLE "Haskeyword" ADD FOREIGN KEY(movie_id) REFERENCES "Movie"(id);
ALTER TABLE "Haskeyword" ADD FOREIGN KEY(key_id) REFERENCES "Keyword"(id);


ALTER TABLE "Belongstocollection" ADD FOREIGN KEY(movie_id) REFERENCES "Movie"(id);
ALTER TABLE "Belongstocollection" ADD FOREIGN KEY(collection_id) REFERENCES "Collection"(id);

ALTER TABLE "Hasgenre" ADD FOREIGN KEY(movie_id) REFERENCES "Movie"(id);
ALTER TABLE "Hasgenre" ADD FOREIGN KEY(genre_id) REFERENCES "Genre"(id);

ALTER TABLE "Hasproductioncompany" ADD FOREIGN KEY(movie_id) REFERENCES "Movie"(id);
ALTER TABLE "Hasproductioncompany" ADD FOREIGN KEY(pc_id) REFERENCES "Productioncompany"(id);

ALTER TABLE "Ratings" ADD FOREIGN KEY(movie_id) REFERENCES "Movie"(id);

ALTER TABLE "Movie_cast" ADD FOREIGN KEY(movie_id) REFERENCES "Movie"(id);

ALTER TABLE "Movie_crew" ADD FOREIGN KEY(movie_id) REFERENCES "Movie"(id);
