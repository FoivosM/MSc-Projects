/*
"Find the 10 best rated movies that were rated by at leat 200 users. Return the title|avgRating|Votes"
Output: 10 rows
*/
SELECT m.title, AVG(r.rating) AS "Average Rating", Count(r.rating) AS "Votes"
FROM "Movie" m
JOIN "Ratings" r ON m.id = r.movie_id
GROUP BY m.id
HAVING count(r.rating) > 200
ORDER BY "Average Rating" DESC
LIMIT 10;
