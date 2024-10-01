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

