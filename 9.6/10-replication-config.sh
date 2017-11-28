#!/bin/bash
set -e

echo [*] configuring $REPLICATION_ROLE instance

echo "max_connections = $PG_MAX_CONNECTIONS" >> "$PGDATA/postgresql.conf"

# We set master replication-related parameters for both slave and master,
# so that the slave might work as a primary after failover.
echo "wal_level = hot_standby" >> "$PGDATA/postgresql.conf"
echo "wal_keep_segments = $PG_WAL_KEEP_SEGMENTS" >> "$PGDATA/postgresql.conf"
echo "max_wal_senders = $PG_MAX_WAL_SENDERS" >> "$PGDATA/postgresql.conf"

# slave settings, ignored on master
echo "hot_standby = on" >> "$PGDATA/postgresql.conf"
echo "primary_conninfo = postgresql://$POSTGRES_MASTER_SERVICE_USER:$POSTGRES_MASTER_SERVICE_PASSWORD@$POSTGRES_MASTER_SERVICE_HOST:POSTGRES_MASTER_SERVICE_PORT" >> "$PGDATA/postgresql.conf"

echo "host replication $REPLICATION_USER 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
