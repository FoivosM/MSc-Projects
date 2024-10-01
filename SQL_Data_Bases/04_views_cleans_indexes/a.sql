CREATE VIEW Actor AS
    SELECT DISTINCT person_id, gender, name
    FROM "Movie_cast"
    ORDER BY person_id;

CREATE VIEW CrewMember AS
    SELECT DISTINCT person_id, gender, name
    FROM "Movie_crew"
    ORDER BY person_id;

CREATE VIEW Person AS
    SELECT * FROM Actor
    UNION
    SELECT * FROM CrewMember