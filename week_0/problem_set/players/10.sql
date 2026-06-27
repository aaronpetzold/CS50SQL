SELECT "first_name" AS 'First Name', "last_name" AS 'Last Name', "weight" AS 'Weight', "height" AS 'Height' FROM "players"
WHERE "birth_country" != 'USA'
ORDER BY "weight" DESC
LIMIT 10