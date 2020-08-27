module migrations.models;

import hunt.database;
import std.format;

// struct Version {
//     ubyte id;
//     uint version_;
// }

struct Migrations {
    private string migrationsTable;
    public Database db;
 
    this(Database _db, string _migrationsTable = "migrations") {
        db = _db;
        migrationsTable = _migrationsTable;
    }
 
    void initDatabase() {
        /* block */ {
            immutable sql = format!"CREATE TABLE %s (id TINYINT UNSIGNED NOT NULL PRIMARY KEY, version INT UNSIGNED NOT NULL)"(migrationsTable);
            db.execute(sql);
        }
        /* block */ {
            immutable sql = format!"INSERT %s SET id=1, version=0"(migrationsTable);
            db.execute(sql);
        }
    }

    @property uint version_() {
        immutable sql = format!"SELECT version FROM %s LIMIT 1"(migrationsTable);
        return db.query(sql).iterator.front["version"].get!uint;
    }

    @property version_(uint value) {
        immutable sql = format!"UPDATE %s SET version=%d"(migrationsTable, value);
        db.execute(sql);
    }
}
