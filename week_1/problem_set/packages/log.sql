
-- *** The Lost Letter ***
SELECT "addresses"."type", "addresses"."address", "scans"."action" FROM "packages"
JOIN "scans" ON "packages"."id" = "scans"."package_id"
JOIN "addresses" ON "scans"."address_id" = "addresses"."id"
WHERE "from_address_id" = (
    SELECT "id" FROM "addresses"
    WHERE address = '900 Somerville Avenue'
)
AND "to_address_id" IN (
    SELECT "id" FROM "addresses"
    WHERE address LIKE '2 F%'
);
 

-- *** The Devious Delivery ***
SELECT "packages"."contents", "addresses"."type", "scans"."action" FROM "packages"
JOIN "scans" ON "packages"."id" = "scans"."package_id"
JOIN "addresses" ON "scans"."address_id" = "addresses"."id"
WHERE "from_address_id" IS NULL;


-- *** The Forgotten Gift ***
SELECT "packages"."contents", "scans"."action", "scans"."timestamp", "drivers"."name"
FROM "packages"
JOIN "addresses" AS "from_addresses" ON "packages"."from_address_id" = "from_addresses"."id"
JOIN "addresses" AS "to_addresses" ON "packages"."to_address_id" = "to_addresses"."id"
JOIN "scans" ON "packages"."id" = "scans"."package_id"
JOIN "drivers" ON "scans"."driver_id" = "drivers"."id"
WHERE "from_addresses"."address" = '109 Tileston Street'
  AND "to_addresses"."address" = '728 Maple Place';

