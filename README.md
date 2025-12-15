# SEBI Regulatory Database

## Overview
This database is designed to model the core regulatory, supervisory, and enforcement functions of the Securities and Exchange Board of India (SEBI). It captures essential entities involved in securities market regulation, investor protection, and compliance monitoring.

## Purpose
The primary objective of this database is to provide a structured and normalized representation of SEBI’s operations for academic DBMS projects. It demonstrates how a regulatory authority manages market participants, handles investor grievances, conducts investigations, and enforces regulations.

## Key Entities
- **Offices**: Stores details of SEBI head and regional offices.
- **Officials**: Contains information about SEBI officials, their designations, departments, and office postings.
- **Intermediaries**: Records SEBI-registered market intermediaries such as brokers, AMCs, registrars, and investment advisors.
- **Investors**: Maintains basic investor details for grievance redressal.
- **Complaints (SCORES)**: Tracks investor complaints, their status, and assigned officials.
- **Investigations**: Manages regulatory investigations initiated against intermediaries.
- **Regulations**: Stores major SEBI regulations with issue dates and descriptions.
- **Circulars**: Links circulars issued under specific regulations.
- **Penalties**: Records penalties imposed on intermediaries based on investigations.

## Design Considerations
- The schema follows normalization principles to reduce redundancy.
- Foreign key constraints ensure referential integrity between related entities.
- Address data is embedded within relevant tables (e.g., offices) to avoid unnecessary standalone relationships.
- ENUMs are used for controlled attributes such as status and intermediary type.

## Use Case
This database can be used to:
- Simulate investor complaint handling workflows.
- Track regulatory investigations and enforcement actions.
- Demonstrate relational database design in a financial regulatory context.
- Support SQL queries, joins, and reports for academic evaluation.
