-- How many rows does my table have
select COUNT(*) from "Belongstocollection";
-- Select the duplicate entries
select *,count(*)
from "Belongstocollection"
group by movie_id,collection_id
having count(*)>1;

-- Create an empty table with the same schema of "Belongstocollection"
create table btc_temp (like "Belongstocollection");

-- Insert only the distinct rows in the new table
insert into btc_temp(movie_id,collection_id)
select distinct on (movie_id, collection_id) movie_id,collection_id
from "Belongstocollection";

-- Drop the original table
drop table "Belongstocollection";

-- Rename the new table as the old table
Alter table btc_temp RENAME TO "Belongstocollection";

-- Verify the deletion
select *,count(*)
from "Belongstocollection"
group by movie_id,collection_id
having count(*)>1;

select COUNT(*) from "Belongstocollection";

---Haskeyword
select *,count(*)
from "Haskeyword"
group by movie_id, key_id
having count(*)>1;

create table hktemp (like "Haskeyword");

insert into hktemp(movie_id, key_id)
select distinct on (movie_id, key_id) movie_id, key_id
from "Haskeyword";

drop table "Haskeyword";

Alter table hktemp RENAME TO "Haskeyword";

-- Hasgenre
select *,count(*)
from "Haskeyword"
group by movie_id, key_id
having count(*)>1;
select COUNT(*) from "Hasgenre";

select *,COUNT(*)
from "Hasgenre"
group by movie_id, genre_id
having count(*)>1;

create table hgtemp (like "Hasgenre");

insert into hgtemp(movie_id, genre_id)
select distinct on (movie_id, genre_id) movie_id, genre_id
from "Hasgenre";

drop table "Hasgenre";

Alter table hgtemp RENAME TO "Hasgenre";

select *,COUNT(*)
from "Hasgenre"
group by movie_id, genre_id
having count(*)>1;

select COUNT(*) from "Hasgenre";

-- Hasproductioncompany
select COUNT(*) from "Hasproductioncompany";

select *,COUNT(*)
from "Hasproductioncompany"
group by movie_id, pc_id
having count(*)>1;

create table temp (like "Hasproductioncompany");

insert into temp(movie_id, pc_id)
select distinct on (movie_id, pc_id) movie_id, pc_id
from "Hasproductioncompany";

drop table "Hasproductioncompany";

Alter table temp rename to "Hasproductioncompany";

select COUNT(*) from "Hasproductioncompany";

select *,COUNT(*)
from "Hasproductioncompany"
group by movie_id, pc_id
having count(*)>1;
