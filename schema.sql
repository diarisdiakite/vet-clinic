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
ADD CONSTRAINT fk_species_id FOREIGN KEY (species_id) REFERENCES species(id);


ALTER TABLE animals 
ADD COLUMN owner_id INTEGER,
ADD CONSTRAINT fk_owners_id FOREIGN KEY (owners_id) REFERENCES owners(id);

