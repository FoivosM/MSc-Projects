/*
Find the 10 best Executive Producers with the highest ROI movies, provided they have a budget of at least 1000$,
along with their, to invest in them.
Output: title||ROI|Producer Name
*/

-- ground truth
/*
select id,title, budget, revenue, revenue/budget AS ROI
from "Movie"
where budget>1000
order by roi desc
LIMIT 10;
*/

SELECT m.title as "Movie Title", CAST(((revenue-budget)/budget)*100 AS INT) as "ROI (%)", name as "Executive Producer"
FROM "Movie" m
JOIN "Movie_crew" mcr ON m.id = mcr.movie_id
WHERE job='Executive Producer' and budget>1000
ORDER BY "ROI (%)" DESC
LIMIT 10;
