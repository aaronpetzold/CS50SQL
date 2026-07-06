CREATE VIEW "frequently_reviewed" AS
SELECT "l"."id", "l"."property_type", "l"."host_name", COUNT("r"."id") AS 'reviews'
FROM "listings" AS 'l'
JOIN "reviews" AS 'r' ON "l"."id" = "r"."listing_id"
GROUP BY "l"."id"
ORDER BY "reviews" DESC
LIMIT 100;