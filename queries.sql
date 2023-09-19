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
