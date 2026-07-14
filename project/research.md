# Cybersecurity Fundamentals: Key Concepts

## Team

An organizational grouping of people (e.g. "Security Team").

### Attributes (table: `team`)

| Attribute | Notes |
|---|---|
| `id` (PK) | |
| `name` | e.g. `"Security Team"` |

---

## Person

An individual responsible for owning assets and/or performing remediation work.

### Attributes (table: `person`)

| Attribute | Notes |
|---|---|
| `id` (PK) | |
| `name` | |
| `email` | |
| `team_id` (FK → team) | Which team this person belongs to |

---

## Asset

Any physical or digital resource that has value to an organization and is capable of being accessed, used, or exploited. Assets are the primary targets of cyberattacks and the foundational elements that need protection.

### Categories of Assets

- **Hardware:** Servers, laptops, mobile devices, routers, switches, IoT sensors
- **Software:** Operating systems, applications, databases, firmware
- **Data:** Customer information, intellectual property, financial records, employee data *(most valuable category)*
- **Network & Cloud:** Virtual machines, cloud instances, domain names, APIs, firewalls, encryption keys
- **Human Assets:** Employees, contractors, privileged administrative accounts

### Attributes (table: `asset`)

| Attribute | Notes |
|---|---|
| `id` (PK) | |
| `name` | e.g. `"MacBook-Aaron"`, `"prod-server-01"` |
| `type` | e.g. laptop, server, cloud_container, web_app |
| `owner_id` (FK → person) | Who's responsible for this asset |


- **Reference:** [huntress.com/cybersecurity-101/topic/asset-in-cybersecurity](https://www.huntress.com/cybersecurity-101/topic/asset-in-cybersecurity)

---

## Scan

An automated process that inspects networks, systems, or code to identify active components, misconfigurations, and security vulnerabilities. Serves as the mechanical engine behind asset discovery and continuous risk management.

### Types of Cybersecurity Scans

- **Discovery Scans:** Broad, agentless network sweeps used to map active IP addresses, open ports, and connected devices to eliminate hidden "shadow IT"
- **Vulnerability Scans:** Targeted inspections that compare system attributes against a database of known vulnerabilities (CVEs) to flag outdated software or weak settings
- **Web Application Scans:** Dynamic security testing (DAST) that simulates attacks on web interfaces to find flaws like SQL injection or Cross-Site Scripting (XSS)
- **Cloud & Container Scans:** API-driven checks that audit cloud environments (AWS, Azure) and container images for permission leaks and configuration errors

### Attributes (table: `scan`)

| Attribute | Notes |
|---|---|
| `id` (PK) | |
| `asset_id` (FK → asset) | Which asset was scanned |
| `date_time` | When the scan ran (combined DATETIME, not split into separate date/time fields) |



---

## CVE (Common Vulnerabilities and Exposures)

- Has a unique identifier
- Can have many different names
- **Format:** `CVE-Year-Bug`
    - Year indicates when the vulnerability was **confirmed**, not discovered
- **Example:** `CVE-2017-0144`
    - 0144 = 144th vulnerability confirmed in 2017
- CVE identifies **what** the vulnerability is and **where** it exists, but **not** how dangerous it is (→ CVSS)
- **Reference:** [nvd.nist.gov](https://nvd.nist.gov)

### Attributes (table: `cve`)

| Attribute | Notes |
|---|---|
| `id` (PK) | The actual NVD string, e.g. `CVE-2024-12345` — no separate auto-ID needed, it's already unique |
| `description` | Short text of what the vulnerability is (pulled from NVD) |
| `cvss_score` | The standardized 0–10 severity score (see below) |

### CVSS (Common Vulnerability Scoring System)

| Score Range | Severity Level |
|-------------|----------------|
| 0.1 – 3.9   | Low            |
| 4.0 – 6.9   | Medium         |
| 7.0 – 8.9   | High           |
| 9.0 – 10.0  | Critical       |

**Score Factors:**

1. **Attack Vector** – Is the attack remotely exploitable?
2. **Exploit Complexity**
    - **Simple:** Most common; exploits basic human behavior or known system flaws; minimal technical knowledge required
    - **Complex:** Targets hard-to-find systemic flaws or custom architectural weaknesses
3. **Privileges Required** – Does the attack need admin rights?
4. **User Interaction** – Is user interaction required?
5. **Impact** – What is the potential damage?


- **Reference:** [first.org/cvss](https://first.org/cvss)

---

## Finding

A **finding** is the documented evidence of a specific vulnerability, misconfiguration, or security anomaly discovered during a scan, audit, penetration test, or security assessment. It represents an actionable security issue that poses a potential risk to the organization.

A finding is what results when a **Scan** discovers that a **CVE** applies to a specific **Asset** — it's the junction where "this weakness" meets "this real thing it affects, found at this time."

### Attributes (table: `finding`)

| Attribute | Notes |
|---|---|
| `id` (PK) | |
| `scan_id` (FK → scan) | Which scan discovered this |
| `cve_id` (FK → cve) | Which vulnerability was found |
| `severity` | Contextual severity for *this* asset — may be derived from `cvss_score` + asset exposure, not just a copy of it |



---

## Remediation

- The process of addressing and resolving identified vulnerabilities and weaknesses
- Prioritization is based on **severity** and **potential impact** on the organization
- **Risk remediation** is an ongoing process of identifying, prioritizing, and fixing vulnerabilities

### Attributes (table: `remediation`)

| Attribute | Notes |
|---|---|
| `id` (PK) | |
| `finding_id` (FK → finding) | Which finding this attempt addresses |
| `person_id` (FK → person) | Who performed/is responsible for this attempt |
| `action_datetime` | When this remediation attempt happened |
| `outcome` | Result of *this specific attempt*: `successful`, `failed`, `in_progress`, `rolled_back` |
| `notes` | Optional free text |



---

## Entity Relationship Overview

| Relationship | Cardinality |
|---|---|
| Team → Person | 1:n ("employs") |
| Person → Asset | 1:n ("owns") |
| Person → Remediation | 1:n ("is responsible for") |
| Asset → Scan | 1:n ("is scanned in") |
| Scan → Finding | 1:n ("produces") |
| CVE → Finding | 1:n ("is identified in") |
| Finding → Remediation | 1:n ("is addressed by") |



---

## Sources

1. [CVE & CVSS Overview – YouTube](https://youtu.be/A4fryoYxWko?si=sYoGF3ZZy3ijX2S1)
2. [Remediation – YouTube](https://youtu.be/PibvIf-YdM0?si=ykr-UB1khdNYBUXl)
3. [Asset in Cybersecurity – Huntress](https://www.huntress.com/cybersecurity-101/topic/asset-in-cybersecurity)
4. [NVD – nvd.nist.gov](https://nvd.nist.gov)
5. [CVSS – first.org/cvss](https://first.org/cvss)

