/*
"Find all the Actors playing in the Original Star Wars."
Output: 106 rows
*/
SELECT mc.name
FROM "Movie" m
JOIN "Movie_cast" mc
ON m.id = mc.movie_id
WHERE m.title = 'Star Wars';
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
/*
"Find the highest gross and best rated movie and its Average rating"
Return movie title|budget|revenue|Average Rating
Output: 1 row
*/
SELECT title, budget, revenue, AVG(r.rating) AS "Average Rating"
FROM "Movie" m
JOIN "Ratings" r ON m.id = r.movie_id
GROUP BY m.id
ORDER BY revenue DESC, "Average Rating" DESC
LIMIT 1;
/*
"Find the 10 movies with the best ROI and their Ratings,
provided that they have a reasonable budget of at least 1000$
Output: title|budget|revenue|ROI|AVGrating
*/
SELECT m.title, m.budget, m.revenue, CAST(((revenue-budget)/budget)*100 AS INT) as "ROI (%)", AVG(r.rating) AS "Average Rating"
FROM "Movie" m
LEFT JOIN "Ratings" r ON m.id = r.movie_id
WHERE budget > 1000
GROUP BY m.id
ORDER BY "ROI (%)" DESC, "Average Rating" DESC
LIMIT 10;
/*
Find the 10 best Executive Producers with the highest ROI movies, provided they have a budget of at least 1000$,
along with their, to invest in them.
Output: title||ROI|Producer Name
*/
SELECT m.title as "Movie Title", CAST(((revenue-budget)/budget)*100 AS INT) as "ROI (%)", name as "Executive Producer"
FROM "Movie" m
JOIN "Movie_crew" mcr ON m.id = mcr.movie_id
WHERE job='Executive Producer' and budget>1000
ORDER BY "ROI (%)" DESC
LIMIT 10;
/*
"Find the max and min rating of the 30 most popular movies"
*/
SELECT m.title, popularity, MAX(r.rating) as "Max Rating", MIN(r.rating) as "Min Rating"
FROM "Movie" m
LEFT JOIN "Ratings" r ON m.id = r.movie_id
GROUP BY m.id
ORDER BY popularity DESC
LIMIT 30;
/*
Find the Collection name in which Star Wars belong
Output: 1 row
*/
SELECT m.title, c.name
FROM "Movie" m
JOIN "Belongstocollection" bc ON m.id = bc.movie_id
JOIN "Collection" c ON bc.collection_id = c.id
WHERE m.title = 'Star Wars';
/*
Find the Productioncompany of Star Wars
Output: 2 rows
*/
SELECT m.title, p.name
FROM "Movie" m
JOIN "Hasproductioncompany" hp ON m.id = hp.movie_id
JOIN "Productioncompany" p ON hp.pc_id = p.id
WHERE m.title = 'Star Wars';
/*
" Count the numbers of distinct female Actors "
Output: 1 row
*/
SELECT COUNT(DISTINCT name) AS "Number of Female Actors"
FROM "Movie_cast"
WHERE gender='1';
