/*
Find the Collection name in which Star Wars belong
Output: 1 row
*/

SELECT m.title, c.name
FROM "Movie" m
JOIN "Belongstocollection" bc ON m.id = bc.movie_id
JOIN "Collection" c ON bc.collection_id = c.id
WHERE m.title = 'Star Wars';
