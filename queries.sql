/*Queries that provide answers to the questions from all projects.*/

/* Find all animals whose name ends in "mon". */
SELECT * FROM ANIMALS WHERE NAME LIKE '%mon';

/* List the name of all animals born between 2016 and 2019. */
SELECT NAME FROM ANIMALS WHERE DATE_OF_BIRTH BETWEEN '2016-01-01' AND '2019-12-31';

/* List the name of all animals that are neutered and have less than 3 escape attempts. */
SELECT NAME FROM ANIMALS WHERE NEUTERED AND ESCAPE_ATTEMPTS < 3;

/* List the date of birth of all animals named either "Agumon" or "Pikachu". */
SELECT DATE_OF_BIRTH FROM ANIMALS WHERE NAME IN ('Agumon', 'Pikachu');

/* List name and escape attempts of animals that weigh more than 10.5kg */
SELECT NAME, ESCAPE_ATTEMPTS FROM ANIMALS WHERE weight_kg > 10.5;

/* Find all animals that are neutered. */
SELECT * FROM ANIMALS WHERE NEUTERED;

/* Find all animals not named Gabumon. */
SELECT * FROM ANIMALS WHERE NAME != 'Gabumon';

/* 
  Find all animals with a weight between 10.4kg and 17.3kg 
  (including the animals with the weights that equals precisely 10.4kg or 17.3kg) 
*/
SELECT * FROM ANIMALS WHERE WEIGHT_KG BETWEEN 10.4 AND 17.3;


/* 

  transactions 

*/

/* 
  Here is the Transaction added to update the weight_kg of animals. 
  BEGIN;
  UPDATE ANIMALS SET WEIGHT_KG = WEIGHT_KG * (-1) WHERE NAME IN('Charmander', 'Plantmon', 'Squirtle', 'Angemon');
  SELECT * FROM ANIMALS;
  COMMIT;
  SELECT * FROM ANIMALS;
*/

/* Update the animals table by setting the species column to unspecified. Verify that change was made. Then rolled back the change and verified that the species columns went back to the state before the transaction. */
BEGIN;
UPDATE ANIMALS SET SPECIES = 'unspecified';
SELECT * FROM ANIMALS;
ROLLBACK;
SELECT * FROM ANIMALS;

/* Inside a transaction:
Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
Verify that changes were made.
Commit the transaction. */

BEGIN;
UPDATE ANIMALS SET SPECIES = 'digimon' WHERE NAME LIKE '%mon';
UPDATE ANIMALS SET SPECIES = 'pokemon' WHERE SPECIES IS NULL OR SPECIES = '';
SELECT * FROM ANIMALS;
COMMIT;
SELECT * FROM ANIMALS;

/* 
  Inside a transaction delete all records in the animals table, 
  then roll back the transaction. 
  After the rollback verify if all records in the animals table still exists.
  Take a screenshot of the results of your actions.
*/

BEGIN;
DELETE FROM ANIMALS;
SELECT * FROM ANIMALS;
ROLLBACK;
SELECT * FROM ANIMALS;

/* 
  Inside a transaction:
  Delete all animals born after Jan 1st, 2022.
  Create a savepoint for the transaction.
  Update all animals' weight to be their weight multiplied by -1.
  Rollback to the savepoint
  Update all animals' weights that are negative to be their weight multiplied by -1.
  Commit transaction
  Take a screenshot of the results of your actions. 
*/

BEGIN;
DELETE FROM ANIMALS WHERE DATE_OF_BIRTH > '2022-01-01';
SELECT * FROM ANIMALS;
SAVEPOINT born_after_2022_01_01;
UPDATE ANIMALS SET WEIGHT_KG = WEIGHT_KG * (-1);
SELECT * FROM ANIMALS;
ROLLBACK TO born_after_2022_01_01;
SELECT * FROM ANIMALS;
UPDATE ANIMALS SET WEIGHT_KG = WEIGHT_KG * (-1) WHERE WEIGHT_KG < 0;
COMMIT;
SELECT * FROM ANIMALS;

/* 
  Other queries
*/

/* How many animals are there? */
SELECT COUNT (*) FROM ANIMALS;

/* How many animals have never tried to escape? */
SELECT COUNT (*) FROM ANIMALS WHERE ESCAPE_ATTEMPTS = 0;

/* What is the average weight of animals? */
SELECT AVG(WEIGHT_KG) FROM ANIMALS;

/* Who escapes the most, neutered or not neutered animals? */
SELECT MAX(ESCAPE_ATTEMPTS) FROM ANIMALS WHERE NEUTERED IS TRUE OR NEUTERED IS FALSE;

/* What is the minimum and maximum weight of each type of animal? */
SELECT SPECIES, MAX(WEIGHT_KG), MIN(WEIGHT_KG) FROM ANIMALS GROUP BY SPECIES;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT SPECIES, AVG(ESCAPE_ATTEMPTS) FROM ANIMALS WHERE DATE_OF_BIRTH BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY SPECIES;


/* 
  vet_clinic Project3: Query multiple tables
  Write queries (using JOIN) to answer the following questions: 
  
*/
/* What animals belong to Melody Pond? */
SELECT a.name, a.date_of_birth, o.full_name AS owner, s.name AS specy
FROM animals AS a
LEFT JOIN owners AS o
ON a.owner_id = o.id
LEFT JOIN species AS s
ON a.specy_id = s.id
WHERE o.full_name = 'Melody Pond'; 

/* List of all animals that are pokemon (their type is Pokemon). */
SELECT a.name, a.date_of_birth, s.name as specy
FROM animals as a
INNER JOIN species as s
ON a.specy_id = s.id
WHERE s.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT o.full_name, a.name, a.date_of_birth, s.name as specy
FROM owners AS o
LEFT JOIN animals AS a
ON a.owner_id = o.id
LEFT JOIN species as s
ON a.specy_id = s.id;

/* How many animals are there per species? */
SELECT COUNT(*) as number, s.name as specy 
FROM animals
INNER JOIN species as s
ON animals.specy_id = s.id
GROUP BY s.name;

/* List all Digimon owned by Jennifer Orwell. */
SELECT a.name, a.date_of_birth, s.name AS specy, o.full_name AS owner
FROM animals As a
LEFT JOIN species AS s
ON a.specy_id = s.id
LEFT JOIN owners as o
ON a.owner_id = o.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

/* List all animals owned by Dean Winchester that haven\'t tried to escape. */
SELECT a.name, a.date_of_birth, a.escape_attempts, o.full_name
FROM animals AS a
LEFT JOIN owners AS o
ON a.owner_id = o.id
WHERE a.escape_attempts = 0 AND o.full_name = 'Dean Winchester';

/* Who owns the most animals? */
SELECT o.full_name, COUNT(a.name) AS animal_count
FROM owners AS o
LEFT JOIN animals AS a
ON o.id = a.owner_id
GROUP BY o.id
ORDER BY animal_count desc
LIMIT 1;

/* Who was the last animal seen by William Tatcher? */
SELECT a.name AS last_animal_seen
FROM animals AS a
INNER JOIN (
  SELECT v.animal_id
  FROM visits AS v
  LEFT JOIN vets AS vt
  ON v.vet_id = vt.id
  WHERE vt.name = 'William Tatcher' 
  ORDER BY v.date_of_visit DESC
  LIMIT 1
) AS last_visit
ON a.id = last_visit.animal_id;

/* How many different animals did Stephanie Mendez see? */
SELECT COUNT(DISTINCT a.name) AS animals_count, vt.name AS vet_name
FROM animals AS a
LEFT JOIN visits AS v 
ON a.id = v.animal_id
LEFT JOIN vets AS vt 
ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez'
GROUP BY vt.name;

/* List all vets and their specialties, including vets with no specialties. */
SELECT v.name, v.age, v.date_of_graduation, t.name AS specy
FROM specializations AS s 
LEFT JOIN vets AS v
ON s.vet_id = v.id
LEFT JOIN species AS t
ON s.specy_id = t.id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT v.date_of_visit, a.name AS animal, vt.name AS vet
FROM visits AS v
INNER JOIN animals AS a
ON v.animal_id = a.id
INNER JOIN vets As vt
ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez' AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets? */
SELECT a.name, a.date_of_birth, COUNT(v.animal_id) AS visit_count
FROM visits AS v
INNER JOIN animals AS a
ON v.animal_id = a.id
GROUP BY a.name, a.date_of_birth
ORDER BY visit_count desc
LIMIT 1;

/* Who was Maisy Smith's first visit? */
SELECT a.name AS first_visited 
FROM animals AS a
INNER JOIN(
  SELECT v.animal_id, MIN(v.date_of_visit) AS first_visit
  FROM visits AS v
  JOIN vets AS vt
  ON v.vet_id = vt.id
  WHERE vt.name = 'Maisy Smith'
  GROUP BY v.animal_id, v.date_of_visit
  ORDER BY v.date_of_visit asc
  LIMIT 1
) as first_visit
ON a.id = first_visit.animal_id;

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT MIN(v.date_of_visit) as last_visit, a.name, a.date_of_birth, vt.name
FROM visits AS v
INNER JOIN animals AS a
ON v.animal_id = a.id
INNER JOIN vets AS vt
ON v.vet_id = vt.id
GROUP BY a.name, a.date_of_birth, vt.name
ORDER BY last_visit DESC
LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(v.date_of_visit) AS number_of_visits, vt.name
FROM visits AS v
INNER JOIN animals AS a
ON v.animal_id = a.id
INNER JOIN vets AS vt
ON v.vet_id = vt.id
INNER JOIN species AS s
ON a.specy_id = s.id
LEFT JOIN specializations AS spec
ON spec.specy_id = s.id AND spec.vet_id = vt.id
WHERE spec.vet_id IS NULL
GROUP BY vt.name;

/* 
  What specialty should Maisy Smith consider getting? 
  Look for the species she gets the most. 
*/

SELECT COUNT (s.name) as specy_visited, s.name
FROM visits as v
INNER JOIN animals as a
ON v.animal_id = a.id
INNER JOIN vets as vt
ON v.vet_id = vt.id
INNER JOIN species as s
ON a.specy_id = s.id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY specy_visited DESC
LIMIT 1;


/* 
First Normal Form
- Add a Primary Key in the table. (primary keys added)
- Put the Data in its most reduced form. Example, avoid fields like ContactPersonAndRole
- Eliminate repeating groups of columns in the table - example: (Project1_ID, Project1_FeedBack) and (Project2_ID, Project2_Feedback). 
2nd Normal Form
- Ensure that all the columns in the table relate directly to the primary key of the record in the table.
3rd Normal Form
- Ensure that each column must be non-transitively dependent on the primary key of the table. 
This means that all columns in a table should rely only on the primary key and no other column
 */

-- Perfqct queries part

  -- added indexes to the tables to improve performance
  CREATE INDEX idx_visits_vet_id ON visits (vet_id);

  -- added indexes to the tables to improve performance
  CREATE INDEX idx_visits_animal_id ON visits (animal_id);

  -- added indexes to the tables to improve performance
  CREATE INDEX idx_date_of_visit ON visits (date_of_visit);

  -- added indexes to the tables to improve performance
  CREATE INDEX idx_animals_owner_id ON animals (email);


/* Visits table */
/* Delete all duplicate entry */

VACUUM FULL visits;

BEGIN;
CREATE TEMPORARY TABLE duplicates AS
SELECT animal_id, vet_id, date_of_visit, MIN(id) AS keep_id
FROM visits
GROUP BY animal_id, vet_id, date_of_visit
HAVING COUNT(*) > 1;
CREATE INDEX duplicate_records_index ON duplicates (animal_id, vet_id, date_of_visit, keep_id);
COMMIT;

BEGIN;
DELETE FROM visits
WHERE (animal_id, vet_id, date_of_visit) IN (
  SELECT animal_id, vet_id, date_of_visit
  FROM duplicates
  WHERE id != keep_id
);
SAVEPOINT find_duplicate_entries;
COMMIT;

DROP TABLE duplicates;
COMMIT;

VACUUM FULL visits;

EXPLAIN ANALYZE SELECT * FROM visits WHERE animal_id = 4;

EXPLAIN ANALYZE SELECT * FROM visits WHERE vet_id = 2;



/* owners table */
BEGIN;
CREATE TEMPORARY TABLE duplicates_owners_to_keep AS
SELECT
  MIN(id) AS keep_id
FROM owners
GROUP BY full_name, age, email
HAVING COUNT(*) > 1;
CREATE INDEX duplicates_to_keep_index ON duplicates_owners_to_keep (keep_id);
COMMIT;
  
/* query to delete duplicate owners not applied */
DELETE FROM owners
WHERE id NOT IN (SELECT keep_id FROM duplicates_owners_to_keep);
COMMIT;