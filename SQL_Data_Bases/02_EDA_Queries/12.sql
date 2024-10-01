/*
Find the Productioncompany of Star Wars
Output: 2 rows
*/

SELECT m.title, p.name
FROM "Movie" m
JOIN "Hasproductioncompany" hp ON m.id = hp.movie_id
JOIN "Productioncompany" p ON hp.pc_id = p.id
WHERE m.title = 'Star Wars';

