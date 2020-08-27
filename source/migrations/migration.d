/**
A library for automatically executing SQL DB migrations.

Not tested!
*/
module migrations.migration;

import migrations.models;

void migrate(Migrations m, void delegate()[] changes) {
    immutable version_ = m.version_;
    if(changes.length > version_) {
        auto transaction = m.db.getTransaction(m.db.getConnection());
        foreach(change; changes[version_ .. $])
            change();
        m.version_ = cast(uint) changes.length;
        transaction.commit();
    }
}