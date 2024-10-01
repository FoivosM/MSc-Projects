/*
"Find what type of movies were made in the 70s and their frequency"
Return the Genre|Movie count
Output: 9
*/
SELECT g.name AS "Genre", count(m.id) as "Movies made"
FROM "Movie" m
JOIN "Hasgenre" hg ON m.id = hg.movie_id
JOIN "Genre" g ON hg.genre_id = g.id
WHERE EXTRACT(YEAR FROM release_date) BETWEEN 1970 AND 1980
GROUP BY g.name
ORDER BY "Movies made" DESC
