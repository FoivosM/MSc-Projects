/*
"Find the 10 best 'Adventure' movies that have at least 20 reviews"
Output: 10 rows
*/
SELECT m.title, g.name, AVG(r.rating) as "Average Rating", COUNT(r.rating) AS "Votes"
FROM "Movie" m
JOIN "Ratings" r ON m.id = r.movie_id
JOIN "Hasgenre" hg ON m.id = hg.movie_id
JOIN "Genre" g ON hg.genre_id = g.id
WHERE g.name = 'Adventure'
GROUP by m.id, g.name
HAVING count(r.rating) > 20
ORDER by "Average Rating" DESC
LIMIT 10;
