SELECT "id" AS 'ID', "english_title" AS 'English Title', "brightness" AS 'Brightness' FROM "views"
WHERE "english_title" LIKE '%Fuji%'
ORDER BY "brightness" DESC