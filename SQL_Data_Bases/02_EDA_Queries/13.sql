/*
" Count the numbers of distinct female Actors "
Output: 1 row
*/
SELECT COUNT(DISTINCT name) AS "Number of Female Actors"
FROM "Movie_cast"
WHERE gender='1';
