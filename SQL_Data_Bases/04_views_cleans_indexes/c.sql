-- Check Query Time
EXPLAIN ANALYZE
SELECT name, character
FROM "Movie" m join "Movie_cast" mc on mc.movie_id=m.id
WHERE title ='Armageddon';

-- Create the proper indexes
CREATE INDEX movie_title ON "Movie" (title);
CREATE INDEX cast_movie_id ON "Movie_cast" (movie_id);

-- Check again
EXPLAIN ANALYZE
SELECT name, character
FROM "Movie" m join "Movie_cast" mc on mc.movie_id=m.id
WHERE title ='Armageddon';

-- OUTPUT:
--                                                          QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------------------
--  Hash Join  (cost=764.94..4278.96 rows=16 width=27) (actual time=2.006..23.494 rows=67 loops=1)
--    Hash Cond: (mc.movie_id = m.id)
--    ->  Seq Scan on "Movie_cast" mc  (cost=0.00..3092.63 rows=160463 width=31) (actual time=0.016..8.624 rows=160463 loops=1)
--    ->  Hash  (cost=764.92..764.92 rows=1 width=4) (actual time=1.875..1.877 rows=1 loops=1)
--          Buckets: 1024  Batches: 1  Memory Usage: 9kB
--          ->  Seq Scan on "Movie" m  (cost=0.00..764.92 rows=1 width=4) (actual time=0.350..1.872 rows=1 loops=1)
--                Filter: ((title)::text = 'Armageddon'::text)
--                Rows Removed by Filter: 9993
--  Planning Time: 0.273 ms
--  Execution Time: 23.527 ms
-- (10 rows)


-- CREATE INDEX
-- CREATE INDEX
--                                                                QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------------------------------
--  Nested Loop  (cost=0.58..79.28 rows=16 width=27) (actual time=0.087..0.112 rows=67 loops=1)
--    ->  Index Scan using movie_title on "Movie" m  (cost=0.29..8.30 rows=1 width=4) (actual time=0.054..0.054 rows=1 loops=1)
--          Index Cond: ((title)::text = 'Armageddon'::text)
--    ->  Index Scan using cast_movie_id on "Movie_cast" mc  (cost=0.29..70.80 rows=18 width=31) (actual time=0.029..0.045 rows=67 loops=1)
--          Index Cond: (movie_id = m.id)
--  Planning Time: 1.963 ms
--  Execution Time: 0.132 ms
-- (7 rows)