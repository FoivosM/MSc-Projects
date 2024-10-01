-- Get duplicates
with duplicate_ids AS (
    SELECT person_id
    FROM person
    GROUP BY person_id
    HAVING COUNT(name)>1 OR COUNT(gender)>1
)

SELECT * 
FROM person 
WHERE person_id IN ( 
    SELECT * FROM duplicate_ids
);

-- select * from "Movie_cast" where person_id = 47395;
-- change gender of id 47395 to 2
UPDATE "Movie_cast" SET gender=2 WHERE person_id = 47395;
UPDATE "Movie_crew" SET gender=2 WHERE person_id = 47395;
-- change gender of id 1785844 to 2
UPDATE "Movie_cast" SET gender=2 WHERE person_id = 1785844;
UPDATE "Movie_crew" SET gender=2 WHERE person_id = 1785844;
-- change NAME of id 63574 to Ka-Fai Cheung
UPDATE "Movie_crew" SET name = 'Ka-Fai Cheung' WHERE person_id = 63574;
UPDATE "Movie_cast" SET name = 'Ka-Fai Cheung' WHERE person_id = 63574;

-- check
with duplicate_ids AS (
    SELECT person_id
    FROM person
    GROUP BY person_id
    HAVING COUNT(name)>1 OR COUNT(gender)>1
)

SELECT * 
FROM person 
WHERE person_id IN ( 
    SELECT * FROM duplicate_ids
);