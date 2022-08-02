/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INTEGER NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL(3, 2) NOT NULL
);

ALTER TABLE animals ADD COLUMN species VARCHAR(100);

 CREATE TABLE owners(
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(250) NOT NULL,
    age INT NOT NULL,
    PRIMARY KEY(id) 
);

CREATE TABLE species(
   id INT GENERATED ALWAYS AS IDENTITY,
   name VARCHAR(250) NOT NULL,
   PRIMARY KEY(id) 
);

-- Remove column species
ALTER TABLE animals DROP species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD CONSTRAINT species_id FOREIGN KEY(species_id) REFERENCES species(id);

-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals ADD CONSTRAINT owner_id FOREIGN KEY(owner_id) REFERENCES owners(id);

-- create vets tables

CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL,
    PRIMARY KEY(id)
);

-- specialization table
CREATE TABLE specializations (
   id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   vets_id INT NOT NULL,
   species_id INT NOT NULL,
   FOREIGN KEY(vets_id) REFERENCES vets(id) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

 -- Visits Table
 CREATE TABLE visits (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    animals_id INT NOT NULL,
    vets_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY(animals_id) REFERENCES animals(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY(vets_id) REFERENCES vets(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

  -- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- Removed NOT NULL in age of owners TABLE
ALTER TABLE owners
ALTER COLUMN age
DROP NOT NULL;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

-- perfomance audit
CREATE INDEX animals_id ON visits (animal_id);
CREATE INDEX vets_id ON visits (vet_id);
CREATE INDEX index_email ON owners (email);