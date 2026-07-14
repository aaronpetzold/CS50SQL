-- ========================================
-- BASIC CRUD / LOOKUPS
-- ========================================

-- 1. Insert a new person 
INSERT INTO "persons" ("first_name", "last_name", "email", "team_id")
VALUES ('Max', 'Mustermann', 'max.muster@gmail.com', 4);

-- 2. Insert a new asset
INSERT INTO "assets" ("name", "subtype_id", "owner_id", "team_id")
VALUES (
    'Laptop Mustermann', 
    2, 
    (SELECT "id" FROM "persons" WHERE "email" = 'max.muster@gmail.com'), 
    5);

-- 3. List all findings for a specific asset (by name)
SELECT 
    "findings"."id", 
    "findings"."scan_id", 
    "findings"."cve_id", 
    "findings"."severity" 
FROM "findings" 
JOIN "scans" ON "findings"."scan_id" = "scans"."id"
JOIN "assets" ON "scans"."asset_id" = "assets"."id"
WHERE "assets"."name" = 'Laptop Mustermann';

-- 4. List all assets that belong to a specific team
SELECT "assets"."id", "assets"."name" FROM "assets"
JOIN "teams" ON "assets"."team_id" = "teams"."id"
WHERE "teams"."name" = 'Security Team';

-- 5. Update a remediation's outcome from 'in_progress' to 'successful'
UPDATE "remediations" SET "outcome" = 'successful'
WHERE id = 5;

-- 6. Delete a person
-- Only works if a person made no remediations 
-- because of NOT NULL constraint in "remediations" for "person_id"
-- A viable option would be to add soft deletions, which however is 
-- prone to mistakes when querying or during implementation
DELETE FROM "persons" WHERE "id" = 23;


-- ========================================
-- JOINS
-- ========================================

-- 7. List every finding with the asset name, CVE description, and CVSS score all in one row
SELECT "assets"."name", "cves"."description", "cves"."cvss_score" FROM "findings"
JOIN "scans" ON "findings"."scan_id" = "scans"."id"
JOIN "assets" ON "scans"."asset_id" = "assets"."id"
JOIN "cves" ON "findings"."cve_id" = "cves"."id";

-- 8. List every remediation attempt with the person's full name and the finding's severity
SELECT "persons"."first_name", "persons"."last_name", "findings"."severity" 
FROM "remediations"
JOIN "persons" ON "remediations"."person_id" = "persons"."id"
JOIN "findings" ON "remediations"."finding_id" = "findings"."id";


-- ========================================
-- AGGREGATION
-- ========================================

-- 9. Count how many findings each asset currently has
SELECT "assets"."id", "assets"."name", COUNT("findings"."id") as 'count'
FROM "findings"
JOIN "scans" ON "findings"."scan_id" = "scans"."id"
JOIN "assets" ON "scans"."asset_id" = "assets"."id"
GROUP BY "assets"."id"
ORDER BY "count" DESC;

-- 10. Count how many assets each team owns
SELECT "teams"."id" ,"teams"."name", COUNT("assets"."id") AS 'count'
FROM "teams"
JOIN "assets" ON "teams"."id" = "assets"."team_id"
GROUP BY "teams"."id"
ORDER BY "count" DESC;

-- 11. Find the average CVSS score across all CVEs currently identified in findings
SELECT AVG("cves"."cvss_score") AS 'average CVSS score'
FROM "findings"
JOIN "cves" ON "findings"."cve_id" = "cves"."id";


-- ========================================
--  STATUS & TIME-BASED ANALYSIS
-- ========================================

-- 12. For each finding, determine its current status (open / patched) by checking whether it has a remediation with outcome = 'successful'
SELECT
    "findings"."id",
    CASE 
        WHEN "latest"."outcome" = 'successful' THEN 'patched'
        ELSE 'open'
    END AS "status"
FROM "findings"
JOIN (
    SELECT 
        "finding_id",
        "outcome",
        MAX("action_datetime") AS "latest_date"
    FROM "remediations"
    GROUP BY "finding_id"
) AS "latest"
ON "findings"."id" = "latest"."finding_id";

-- Alternative
SELECT
    "finding_id",
    CASE 
        WHEN "outcome" = 'successful' THEN 'patched'
        ELSE 'open'
    END AS "status"
FROM (
    SELECT 
        "finding_id",
        "outcome",
        MAX("action_datetime") 
    FROM "remediations"
    GROUP BY "finding_id"
);

-- Lesson: Only bare columns get matched to the specific row that produced the MAX value
-- NOT columns inside wrappers!

-- 13. Calculate average time-to-remediation (in days) grouped by severity
SELECT
    "severity",
    ROUND(AVG(julianday("first_remediation") - julianday("scan_date")), 2) AS "average-time-to-remediation"
FROM (
    SELECT 
        "scans"."date_time" AS "scan_date", 
        MIN("remediations"."action_datetime") AS "first_remediation",
        "findings"."severity" AS "severity"
    FROM "findings"
    JOIN "scans" ON "findings"."scan_id" = "scans"."id"
    JOIN "remediations" ON "findings"."id" = "remediations"."finding_id"
    GROUP BY "findings"."id"
)
GROUP BY "severity"
ORDER BY CASE "severity"
    WHEN 'critical' THEN 1
    WHEN 'high' THEN 2
    WHEN 'medium' THEN 3
    ELSE 4
END;

-- 14. Find all findings that have had more than one remediation attempt (i.e. the first attempt failed)
SELECT "finding_id"
FROM "remediations"
GROUP BY "finding_id"
HAVING COUNT(*) > 1
ORDER BY "finding_id";

-- 15. List the 5 most recently scanned assets
SELECT 
    "assets"."id", 
    "assets"."name", 
    MAX("scans"."date_time")
FROM "assets"
JOIN "scans" ON "assets"."id" = "scans"."asset_id"
GROUP BY "assets"."id"
ORDER BY MAX("scans"."date_time") DESC
LIMIT 5;


-- ========================================
-- CREATING INDEXES
-- ========================================

-- coloums that are used often in the above queries:
-- 1: "remediations"."finding_id"
-- 2: "findings"."scan_id"
-- 3: "scans"."asset_id"