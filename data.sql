/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Agumon', date'2020-02-03', boolean'true', int'0', '10.23');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Gabumon', date'2018-11-15', boolean'true', int'2', '8');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Pikachu', date'2021-01-07', boolean'false', int'1', '15.04');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Devimon', date'2017-05-12', boolean'true', int'5', '11');
INSERT 0 1

INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Charmander', date'2020-02-08', boolean'false',int'0','-11');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Plantmon', date'2021-11-15', boolean'true', int'2', '-5.7');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Squirtle', date'1993-04-02', boolean'false', int'3', '-12.13');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Angemon', date'2005-06-12', boolean'true', int'1', '-45');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Booarmon', date'2005-06-07', boolean'true', int'7', '20.4');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Blossom', date'1998-10-13', boolean'true', int'3', '17');
INSERT 0 1
INSERT INTO animals (name, date_of_birth, neutered, escape_attempts, weight_kg)
  VALUES ('Ditto', date'2022-05-14', boolean'true', int'4', '22');

  -- Inserting data into the owners table:
INSERT INTO owners (full_name, age)
VALUES ('Sam Smith', int'34'),
       ('Jennifer Orwell', int'19'),
       ('Bob', int'45'),
       ('Melody Pond', int'77'),
       ('Dean Winchester', int'14'),
       ('Jodie Whittaker', int'38');

  -- Inserting data into the species table:
INSERT INTO species (name)
VALUES ('Pokemon'),
       ('Digimon');

  -- Modify your inserted animals so it includes the species_id value: 
  -- If the name ends in "mon" it will be Digimon
UPDATE animals SET species_id = (
    SELECT id FROM species WHERE name= 'Digimon')
    WHERE name LIKE '%mon';
SELECT * FROM animals;

UPDATE animals SET species_id = (
   SELECT id FROM species WHERE name ='Pokemon') 
   WHERE name NOT LIKE '%mon';
SELECT * FROM animals;

-- Modify your inserted animals to include owner information (owner_id): 

    -- Sam Smith owns Agumon.
    UPDATE animals SET owner_id =( SELECT id FROM owners WHERE full_name ='Sam Smith') WHERE name = ' Agumon';

    -- Jennifer Orwell owns Gabumon and Pikachu.
    UPDATE animals SET owner_id =( SELECT id FROM owners WHERE full_name ='Jennifer Orwell') WHERE name = 'Gabumon' OR name = 'Pikachu';

    -- Bob owns Devimon and Plantmon.
     UPDATE animals SET owner_id =( SELECT id FROM owners WHERE full_name =' Bob') WHERE name = 'Devimon' OR name = 'Plantmon';
    -- Melody Pond owns Charmander, Squirtle, and Blossom.
    UPDATE animals SET owner_id =( SELECT id FROM owners WHERE full_name ='Melody Pond') WHERE name = 'Blossom' OR name = 'Squirtle' OR name = 'Charmander';
    -- Dean Winchester owns Angemon and Boarmon.
         UPDATE animals SET owner_id =( SELECT id FROM owners WHERE full_name ='Dean Winchester') WHERE name = ' Angemon' AND name = 'Boarmon';