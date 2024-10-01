/*
"Find the keywords characterising Star Wars"
Output: 16 rows
*/

SELECT name
FROM "Keyword"
WHERE id IN (
	SELECT key_id
	FROM "Haskeyword"
	WHERE movie_id=(
		SELECT id
		FROM "Movie"
		WHERE title='Star Wars'
	)
);
