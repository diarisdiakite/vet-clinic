/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	date_of_birth TIMESTAMP,
	escape_attempts INTEGER,
	neutered BOOLEAN,
	weight_kg DECIMAL,
	created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ;

/* Add species column to the animals table */
ALTER TABLE ANIMALS ADD SPECIES VARCHAR(50);

CREATE TABLE owners (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name VARCHAR(150) NOT NULL,
  age INTEGER,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE owners
ADD PRIMARY KEY (id);


CREATE TABLE species(
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150),
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* Modify animals table:
Make sure that id is set as autoincremented PRIMARY KEY
Remove column species
Add column species_id which is a foreign key referencing species table
Add column owner_id which is a foreign key referencing the owners table */

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INTEGER, 
ADD CONSTRAINT fk_species_id FOREIGN KEY (specy_id) REFERENCES species(id);


ALTER TABLE animals 
ADD COLUMN owner_id INTEGER,
ADD CONSTRAINT fk_owners_id FOREIGN KEY (owner_id) REFERENCES owners(id);


/* 

  Many to many relationships 
  Create a table named vets

*/

CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  age INTEGER,
  date_of_graduation TIMESTAMP,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


/* Create a "join table" called specializations to handle this relationship. */

CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets(id),
  specy_id  INTEGER REFERENCES species(id)
);


/* Create a "join table" called visits to handle this relationship, 
it should also keep track of the date of the visit. */

CREATE TABLE visits (
  animal_id INTEGER REFERENCES animals(id),
  vet_id INTEGER REFERENCES vets(id),
  date_of_visit TIMESTAMP
);


/* 
  PERFORMANCE AUDIT
*/

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

/* 
  First Normal form 
*/

/* Add a primary key to the tables which don't have one */
ALTER TABLE visits
ADD PRIMARY KEY (animal_id, vet_id);

ALTER TABLE visits
ADD COLUMN id SERIAL PRIMARY KEY

ALTER TABLE specializations
ADD PRIMARY KEY (vet_id, specy_id);

ALTER TABLE specializations
ADD COLUMN id SERIAL PRIMARY KEY;


/* Put the Data in its most reduced form */
