-- Represent teams in the company
CREATE TABLE "teams" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
); 

-- Represent persons in the company
CREATE TABLE "persons" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "team_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("team_id") REFERENCES "teams"("id") ON DELETE SET NULL
); 

-- Represent assets' main types
CREATE TABLE "main_types" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
); 

-- Represent main types' subtypes
CREATE TABLE "subtypes" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "main_type_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("main_type_id") REFERENCES "main_types"("id")
); 

-- Represent assets
CREATE TABLE "assets" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "subtype_id" INTEGER NOT NULL,
    "owner_id" INTEGER,
    "team_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("subtype_id") REFERENCES "subtypes"("id"),
    FOREIGN KEY("owner_id") REFERENCES "persons"("id") ON DELETE SET NULL,
    FOREIGN KEY("team_id") REFERENCES "teams"("id")
); 

-- Represent scans
CREATE TABLE "scans" (
    "id" INTEGER,
    "asset_id" INTEGER NOT NULL,
    "date_time" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("asset_id") REFERENCES "assets"("id")
); 

-- Represent CVEs
CREATE TABLE "cves" (
    "id" TEXT,
    "description" TEXT NOT NULL,
    "cvss_score" NUMERIC NOT NULL CHECK("cvss_score" >= 0.0 AND "cvss_score" <= 10.0),
    PRIMARY KEY("id")
); 

-- Represent findings
CREATE TABLE "findings" (
    "id" INTEGER,
    "scan_id" INTEGER NOT NULL,
    "cve_id" TEXT NOT NULL,
    "severity" TEXT NOT NULL CHECK("severity" IN ('low', 'medium', 'high', 'critical')),
    PRIMARY KEY("id"),
    FOREIGN KEY("scan_id") REFERENCES "scans"("id"),
    FOREIGN KEY("cve_id") REFERENCES "cves"("id")
); 

-- Represent remediations
CREATE TABLE "remediations" (
    "id" INTEGER,
    "finding_id" INTEGER NOT NULL,
    "person_id" INTEGER NOT NULL,
    "action_datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "outcome" TEXT NOT NULL CHECK("outcome" IN ('successful', 'failed', 'in_progress', 'rolled_back')),
    "notes" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("finding_id") REFERENCES "findings"("id"),
    FOREIGN KEY("person_id") REFERENCES "persons"("id")
); 

-- Create useful indexes (see queries.sql)
CREATE INDEX "idx_remediation_finding_id" ON "remediations"("finding_id");
CREATE INDEX "idx_findings_scan_id" ON "findings"("scan_id");
CREATE INDEX "idx_scans_asset_id" ON "scans"("asset_id");

-- Create view to determine each findings current status
CREATE VIEW "finding_status" AS
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