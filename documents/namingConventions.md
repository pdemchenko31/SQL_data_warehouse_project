## General Principles

- Naming Conventions: Use camelCase, with uppercase letters to separate words.
- Language: English

## Table Naming Conventions

### Bronze Rules

- All names must start with the source system name, and table names must match their original names without renaming.
- `<sourcesystem><Entity>`
    - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).
    - `<entity>`: Exact table name from the source system
    - Example: `crmCustomerInfo` → Customer information from the CRM system.

### Silver Rules

- All names must start with the source system name, and table names must match their original names without renaming.
- `<sourceSystem><Entity>`
    - `<sourceSystem>`: Name of the source system (e.g., `crm`, `erp`).
    - `<entity>`: Exact table name from the source system
    - Example: `crmCustomerInfo` → Customer information from the CRM system.

### Gold Rules

- All names must be use meaningful, business-aligned names for tables, starting with the category prefix
- `<category><Entity>`:
    - `<category>`: Describes the role of the table, such as `dim`(dimension) or `fact`(fact table).
    - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., customers, products, sales).
    - Examples:
        - `dimCustomers` → Dimension table for customer data.
        - `factSales` → Fact table containing sales transactions.

## Column Naming Conventions

### Surrogate Keys

- All primary keys in dimension tables must use the suffix Key.
- `<tableName>Key`:
    - `<tableName>`: Refers to the name of the table or entity the key belongs to.
    - `Key`: A suffix indicating that this column is a surrogate key.
    - Example: `customerKey` → Surrogate key in the `dimCustomers` table.

### Technical Columns

- All technical columns must start with the prefix `dwh`, followed by a descriptive name indicating the column’s purpose.
- `dwh<ColumnName>`
    - `dwh`: Prefix exclusively for system-generated metadata.
    - `<columnName>`: Descriptive name indicating the column’s purpose.
    - Example: `dwhLoadDate` → System-generated column used to store the date when the record was loaded.

## Stored Procedure

- All stored procedures used for loading data must follow the naming patter: `load<Layer>`.
    - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
    - Example:
        - `loadBronze` → Stored procedure for loading data into the Bronze layer.
        - `loadSilver` → Stored procedure for loading data into the Silver layer.
