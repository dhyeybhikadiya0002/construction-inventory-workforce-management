# Construction Inventory & Workforce Management System

A database-driven academic group project for managing construction materials, workers, project assignments, purchasing, and deliveries. **My contribution:** I implemented all project components; the original submission was completed as a group assignment.

## Technologies
- Oracle Database, SQL and PL/SQL
- Database views, history tables and `INSTEAD OF` triggers
- Microsoft Access frontend linked through ODBC (not included in this public archive)

## Features
- Manage materials and warehouse inventory
- Track project employees and worker types
- Record orders and delivery status
- Maintain historical changes through history tables and view triggers
- Access forms and reports in the original Microsoft Access interface

## Repository contents
- `sql/01_schema.sql` — nine base tables and sequences
- `sql/02_seed_data.sql` — sample records
- `sql/03_views_triggers.sql` — additional history tables, views and triggers
- `sql/04_test_queries.sql` — sample tests and inspection queries
- `docs/relationship-diagram.png` — original relationship diagram
- `docs/setup.md` — setup and validation guidance

## Getting started
1. Create a **new, empty Oracle schema** using your own account credentials.
2. Run `01_schema.sql`, followed by `02_seed_data.sql`.
3. Run `03_views_triggers.sql` and inspect Oracle's compilation errors.
4. Run `04_test_queries.sql` after reviewing its statements.

**Verification status:** The scripts have not been executed against an Oracle instance in this environment. One inconsistent table reference (`"Order"` versus `OrderTable`) was corrected. Further runtime and trigger testing is required before describing the project as fully reproducible.

## Frontend
The original project included an `.accdb` Microsoft Access frontend using Oracle ODBC connections. It is **intentionally excluded** from the public ZIP because Access files can retain connection metadata and user-specific information. The frontend should be sanitized and relinked to a demo database before being published. See [setup guidance](docs/setup.md).

## Academic attribution
Originally a group assignment. I implemented all project components, according to my contribution record. This is a portfolio adaptation; publish only if permitted by the institution's academic-integrity policy.
