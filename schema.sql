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
