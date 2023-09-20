/* Populate database with sample data. 
INSERT INTO animals (name) VALUES ('Luna');
INSERT INTO animals (name) VALUES ('Daisy');
INSERT INTO animals (name) VALUES ('Charlie');
*/

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES 
  ('Agumon', '2020-02-03', 0, true, 10.23),
  ('Gabumon', '2018-11-15', 2, true, 8),
  ('Pikachu', '2021-01-07', 1, false, 15.04),
  ('Devimon', '2017-05-12', 5, true, 11);

/* Insertion 2 */
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg, species)
VALUES 
  ('Charmander', '2020-02-08', 0, false, -11, null),
  ('Plantmon', '2021-11-15', 2, true, -5.7, null),
  ('Squirtle', '1993-04-02', 3, false, -12.13, null),
  ('Angemon', '2005-06-12', 1, true, -45, null),
  ('Boarmon', '2005-06-07', 7, true, 20.4, null),
  ('Blossom', '1998-10-13', 3, true, 17, null),
  ('Ditto', '2022-05-14', 4, true, 22, null);


INSERT INTO owners(full_name, age) 
VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);


INSERT INTO species (name) Values
('Pokemon'),
('Digimon');

/* Modify thr inserted animals so it includes the species_id value:
If the name ends in "mon" it will be Digimon
All other animals are Pokemon */
BEGIN;
UPDATE animals SET specy_id = 2 WHERE name LIKE '%mon';
UPDATE animals SET specy_id = 1 WHERE specy_id IS NULL;
SELECT * FROM animals;
COMMIT;

/* Modify the inserted animals to include owner information (owner_id): */

UPDATE animals SET owner_id = 1 WHERE name = 'Agumon';
UPDATE animals SET owner_id = 2 WHERE name IN ('Gabumon', 'Pikachu');
UPDATE animals SET owner_id = 3 WHERE name IN ('Devimon', 'Plantmon');
UPDATE animals SET owner_id = 4 WHERE name IN ('Charmander', 'Squirtle', 'Blossom');
UPDATE animals SET owner_id = 5 WHERE name IN ('Angemon', 'Boarmon');
