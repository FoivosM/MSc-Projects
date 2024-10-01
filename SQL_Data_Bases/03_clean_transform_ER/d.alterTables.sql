ALTER TABLE "Haskeyword" ADD PRIMARY KEY(movie_id, key_id);

ALTER TABLE "Belongstocollection" ADD PRIMARY KEY(movie_id);
ALTER TABLE "Belongstocollection" ALTER COLUMN collection_id SET NOT NULL;

ALTER TABLE "Hasgenre" ADD PRIMARY KEY(movie_id, genre_id);

ALTER TABLE "Hasproductioncompany" ADD PRIMARY KEY(movie_id, pc_id);

ALTER TABLE "Ratings" ADD PRIMARY KEY(movie_id, user_id);
ALTER TABLE "Ratings" ALTER COLUMN rating SET NOT NULL;

