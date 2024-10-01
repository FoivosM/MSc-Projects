/*
"Find the 10 movies with the best ROI and their Ratings,
provided that they have a reasonable budget of at least 1000$
Output: title|budget|revenue|ROI|AVGrating
*/

-- ground truth
/*
select id,title, budget, revenue, revenue/budget AS ROI
from "Movie"
where budget>1000
order by roi desc
LIMIT 10;
*/

SELECT m.title, m.budget, m.revenue, CAST(((revenue-budget)/budget)*100 AS INT) as "ROI (%)", AVG(r.rating) AS "Average Rating"
FROM "Movie" m
LEFT JOIN "Ratings" r ON m.id = r.movie_id
WHERE budget > 1000
GROUP BY m.id
ORDER BY "ROI (%)" DESC, "Average Rating" DESC
LIMIT 10;

