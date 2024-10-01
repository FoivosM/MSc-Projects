/*
"Find all the movies starring 'Harrison Ford'."
Output: 34
*/
SELECT title
FROM "Movie"
WHERE id in (
	SELECT movie_id
	FROM "Movie_cast"
	WHERE name = 'Harrison Ford'
)
ORDER BY title;
