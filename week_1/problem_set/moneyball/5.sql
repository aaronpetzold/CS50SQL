/*
SELECT "name" FROM "teams"
WHERE "id" IN (
    SELECT "team_id" FROM "performances"
    WHERE "player_id" = (
        SELECT "id" FROM "players"
        WHERE "first_name" = 'Satchel'
        AND "last_name" = 'Paige'
    )
);
*/

SELECT DISTINCT "name" FROM "teams"
JOIN "performances" ON "teams"."id" = "performances"."team_id"
JOIN "players" ON "performances"."player_id" = "players"."id"
WHERE "players"."first_name" = 'Satchel'
AND "players"."last_name" = 'Paige';