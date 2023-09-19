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

