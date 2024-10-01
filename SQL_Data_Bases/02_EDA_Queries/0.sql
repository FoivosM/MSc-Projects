-- Change revenue and budget to float for precision
ALTER TABLE "Movie"
ALTER COLUMN budget TYPE REAL,
ALTER COLUMN revenue TYPE REAL;
