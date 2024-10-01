/*
"Find the max and min rating of the 30 most popular movies"
*/

SELECT m.title, popularity, MAX(r.rating) as "Max Rating", MIN(r.rating) as "Min Rating"
FROM "Movie" m
LEFT JOIN "Ratings" r ON m.id = r.movie_id
GROUP BY m.id
ORDER BY popularity DESC
LIMIT 30;
