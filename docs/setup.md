# Setup and publication notes

## Oracle database
Use Oracle SQL Developer or SQLcl and a new, nonproduction Oracle user/schema. **Do not copy the username or password from the original assignment instructions.** Run the four scripts in numerical order.

The project creates nine base tables, and the third script defines additional history structures, views, and triggers. Some Oracle SQL tools require executing PL/SQL scripts using **Run Script (F5)** rather than statement-by-statement execution.

### Validation queries
```sql
SELECT table_name FROM user_tables ORDER BY table_name;
SELECT view_name FROM user_views ORDER BY view_name;
SELECT trigger_name, status FROM user_triggers ORDER BY trigger_name;
SELECT name, type, line, position, text FROM user_errors ORDER BY name, sequence;
```

Check compilation errors and exercise inserts/updates/deletes in a disposable test database. The provided test file may modify records.

## Microsoft Access frontend
The original `Assignment2.accdb` is not bundled publicly. It may contain saved ODBC connections, database usernames, cached records, or identifying metadata. Before publishing a frontend copy:
1. Inspect and remove saved connection strings, linked-table DSNs, credentials, and cached data.
2. Relink all tables/views to a dedicated demo Oracle database.
3. Test all forms and reports on a clean computer/account.
4. Save a sanitized copy and only then consider adding it to GitHub.

## Known source changes
- Corrected the first statement in the view/trigger script to reference `OrderTable` rather than the nonexistent quoted table `"Order"`.
- Disabled unconditional `DROP VIEW` statements so the script can be attempted on a new schema without failing solely because a view does not exist.
- Kept other original SQL logic for further testing rather than claiming unverified fixes.

## Original application workflow
The source instructions describe Microsoft Access forms for managing materials, employee tasks and delivery status, plus reports on inventory, deliveries, warehouses and orders. Oracle views and `INSTEAD OF` triggers implement changes and history tracking.
