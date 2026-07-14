# CS50 SQL - Introduction to Databases with SQL
> Harvard University's course on relational databases, offered free via [cs50.harvard.edu/sql](https://cs50.harvard.edu/sql/)

This repository contains my final project for **CS50 SQL**, taught by David J. Malan and Carter Zenke. The course covers relational database design and SQL from the ground up, using SQLite before introducing PostgreSQL and MySQL.

---

## What is CS50 SQL?

CS50 SQL is Harvard's dedicated database course. It teaches how to create, read, update, and delete data with relational databases; how to model real-world entities and relationships with tables, types, triggers, and constraints; how to normalize data to reduce redundancy; how to join tables via primary and foreign keys; and how to speed up and automate searches with indexes and views.

---

## Topics Covered

| Week | Topic |
|------|-------|
| 0 | Querying |
| 1 | Relating |
| 2 | Designing |
| 3 | Writing |
| 4 | Viewing |
| 5 | Optimizing |
| 6 | Scaling |
| - | Final Project |

---

## Repository Structure

```
CS50SQL/
├── week_0/             # Querying
│   ├── lecture/        # Lecture queries and sample databases
│   └── problem_set/    # cyberchase, players, views
├── week_1/             # Relating
│   ├── lecture/        # Lecture queries, CSVs, and sample databases
│   └── problem_set/    # dese, moneyball, packages
├── week_2/             # Designing
│   ├── lecture/        # Lecture schema and ALTER examples
│   └── problem_set/    # atl, connect, donuts
├── week_3/             # Writing
│   ├── lecture/        # INSERT/UPDATE/DELETE, imports, triggers
│   └── problem_set/    # dont-panic, meteorites
├── week_4/             # Viewing
│   ├── lecture/        # Aggregating, partitioning, securing, simplifying
│   └── problem_set/    # bnb, census, private
├── week_5/             # Optimizing
│   ├── lecture/        # Indexes and concurrency
│   └── problem_set/    # harvard, snap
├── week_6/             # Scaling
│   ├── lecture/        # Access control, injection, MySQL, PostgreSQL
│   └── problem_set/    # deep, dont-panic-python, sentimental-connect
└── project/            # Final project - Vulnerability & Asset Management Database
    ├── schema.sql
    ├── data.sql
    ├── queries.sql
    ├── DESIGN.md
    ├── research.md
    ├── goodnotes_diagram.png
    └── dbdiagram.png
```

---

## Final Project - Vulnerability & Asset Management Database

**Video overview:** [youtu.be/iQI12sL9JjA](https://youtu.be/iQI12sL9JjA)

A SQLite database that tracks security vulnerabilities (CVEs) found on assets during scans, and the remediation attempts made to fix them.

The schema models eight entities: `teams`, `persons`, `main_types`, `subtypes`, `assets`, `scans`, `cves`, `findings`, and `remediations`. A scan of an asset can produce multiple findings, each tying a CVE to a contextual severity level for that specific asset; each finding can then have one or more remediation attempts logged against it. A finding's current status (open vs. patched) is derived from its most recent remediation outcome rather than stored redundantly, via the `finding_status` view.

**Key design decisions** (see `project/DESIGN.md` for the full write-up):

* CVEs use their official NVD identifier (e.g. `CVE-2024-12345`) as a `TEXT` primary key instead of a surrogate integer key, since it's already unique.
* A CVE's `cvss_score` (0-10, `CHECK`-constrained) is distinct from a finding's `severity`, since the same CVE can pose different risk levels depending on the asset it's found on.
* Indexes are added on `remediations.finding_id`, `findings.scan_id`, and `scans.asset_id` to speed up the joins used most often in `queries.sql`.
* Out of scope: automated scanning, pulling CVE data from the NVD automatically, notifications/escalation, logins/permissions, and asset ownership history.

**Key files** (all under `project/`):

| File | Purpose |
|------|---------|
| `schema.sql` | `CREATE TABLE` statements, constraints, indexes, and the `finding_status` view |
| `data.sql` | Sample records for all eight tables, for testing the schema |
| `queries.sql` | CRUD operations, joins, aggregations, and time-based analysis (e.g. average time-to-remediation by severity) |
| `DESIGN.md` | Scope, functional requirements, entity representation, relationships, optimizations, and limitations |
| `research.md` | Notes on cybersecurity concepts (assets, scans, CVEs, CVSS, findings, remediation) that informed the schema |

**Running it locally:**

```
cd project
sqlite3 vulnerabilities.db < schema.sql
sqlite3 vulnerabilities.db < data.sql
sqlite3 vulnerabilities.db < queries.sql
```

---

## Certificate

[![CS50 SQL Certificate](https://certificates.cs50.io/2a1d6b9c-b7eb-47d7-ac37-d2ac8342748e.png?size=letter)](https://certificates.cs50.io/2a1d6b9c-b7eb-47d7-ac37-d2ac8342748e.pdf?size=letter)
