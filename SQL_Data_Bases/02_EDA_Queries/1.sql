/*
"Find all the Actors playing in the Original Star Wars."
Output: 106 rows
*/
SELECT mc.name
FROM "Movie" m
JOIN "Movie_cast" mc
ON m.id = mc.movie_id
WHERE m.title = 'Star Wars';
