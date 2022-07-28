/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals like '%mon'; /*Animals that ends with 'MON' */
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-1-1' AND '2019-12-31'; /*Born btw 2016 to 2019 */
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name ='Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = 'true';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*update the animals table by setting the species column to unspecified AND rolling back to normal */

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species FROM animals;
ROLLBACK;
select species FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' where name like '%mon';
UPDATE animals SET species = 'pokemon' where species IS NULL;
SELECT species FROM animals;
COMMIT;
SELECT species from animals;

/* Delete all TABLE records and RolledBack again */
BEGIN;
DELETE FROM animals;
select * from animals;
ROLLBACK;
select * from animals;

BEGIN;
DELETE from animals WHERE date_of_birth > '01-01-2022';


SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT name, weight_kg FROM animals;

ROLLBACK TO SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT name, weight_kg FROM animals;

/* Answers to query questions */

/*How many animals are there?*/
SELECT * FROM animals

/*How many animals have never tried to escape?*/
SELECT * FROM animals WHERE escape_attempts = 0;

/*What is the average weight of animals?*/
SELECT AVG(weight_kg) FROM animals;

/*Who escapes the most, neutered or not neutered animals?*/
SELECT count(escape_attempts) as escape_counts, neutered FROM animals group by neutered;

/*What is the minimum and maximum weight of each type of animal?*/

SELECT MIN(weight_kg) as min_weight, MAX(weight_kg) as max_weight, species FROM animals group by species;

/*What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT AVG(escape_attempts) as avg_escape_attempt, species FROM animals where date_of_birth between '01-01-1990' and '12-31-2000' group by species;

-- Write queries (using JOIN) to answer the following questions: 

    -- What animals belong to Melody Pond?
    SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id AND owners.full_name = 'Melody Pond';
    -- List of all animals that are pokemon (their type is Pokemon).
    SELECT * FROM animals JOIN species ON animals.species_id = species.id AND species.name = 'pokemon';
    -- List all owners and their animals, remember to include those that don't own any animal.
    SELECT * FROM animals RIGHT JOIN owners ON animals.owner_id = owners.id; 
    -- How many animals are there per species?
    SELECT COUNT(*), species.name FROM animals JOIN species on animals.species_id = species.id GROUP BY species.id; 
    -- List all Digimon owned by Jennifer Orwell.
    SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id JOIN species ON animals.species_id = species.id AND owners.full_name = 'Jennifer Orwell' AND species.name ='Digimon';
    -- List all animals owned by Dean Winchester that haven't tried to escape.
    SELECT * FROM animals JOIN owners ON animals.owner_id = owners.id and owners.full_name ='Dean Winchester' and animals.escape_attempts = 0;
    Who owns the most animals?
SELECT owners.full_name, COUNT(animals) FROM owners JOIN animals ON owners.id = animals.owner_id GROUP BY owners.full_name ORDER BY COUNT(animals) DESC LIMIT 1;
