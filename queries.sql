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

    --Who owns the most animals?
SELECT owners.full_name, COUNT(animals) FROM owners JOIN animals ON owners.id = animals.owner_id GROUP BY owners.full_name ORDER BY COUNT(animals) DESC LIMIT 1;

--Write queries to answer the following:

--     Who was the last animal seen by William Tatcher?
SELECT animals.name FROM animals JOIN visits ON animals.id = visits.animals_id JOIN vets ON vets.id = visits.vets_id WHERE visits.vets_id = 1 ORDER BY visits.date LIMIT 1; 

--     How many different animals did Stephanie Mendez see?
SELECT count(*) AS total_animals, vets.name FROM visits INNER JOIN animals ON visits.animals_id = animals.id INNER JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'Stephanie Mendez' GROUP BY vets.name;
--     List all vets and their specialties, including vets with no specialties.

SELECT vets.name, STRING_AGG(species.name, ',') FROM vets LEFT JOIN specializations ON vets.id = specializations.vets_id
 LEFT JOIN species ON species.id = specializations.species_id GROUP BY vets.name;

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name FROM animals JOIN visits ON animals.id = visits.animals_id JOIN vets 
ON vets.id = visits.vets_id WHERE visits.vets_id = 3 AND visits.date BETWEEN '2020-04-01' AND '2020-08-30';
-- What animal has the most visits to vets?
SELECT animals.name FROM animals JOIN visits ON animals.id = visits.animals_id JOIN vets ON vets.id = visits.vets_id GROUP BY animals.name ORDER BY COUNT(animals) DESC LIMIT 1; 
-- Who was Maisy Smith's first visit?
SELECT animals.name, date FROM animals JOIN visits ON animals.id = visits.animals_id JOIN vets ON vets.id = visits.vets_id WHERE vets.id = 2 ORDER BY date LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT * FROM animals JOIN visits ON animals.id = visits.animals_id JOIN vets ON vets.id = visits.vets_id ORDER BY visits.date DESC;
-- How many visits were with a vet that did not specialize in that animal's species?
SELECT vets.name , COUNT(visits.id) FROM vets LEFT JOIN specializations ON vets.id = specializations.vets_id 
LEFT JOIN species ON species.id = specializations.species_id JOIN visits ON vets.id = visits.vets_id WHERE specializations.species_id IS NULL GROUP BY vets.name;
-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name, COUNT(species.*) FROM vets JOIN visits ON vets.id = visits.vets_id
JOIN animals ON animals.id = visits.animals_id JOIN species ON species.id = animals.species_id WHERE vets.id = 2 GROUP BY species.name ORDER BY COUNT(species.name) DESC ;
