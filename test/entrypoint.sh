#!/bin/bash
set -e

echo "Starting PostgreSQL..."
#pg_ctl 16 main start
#systemctl start postgresql

echo "Starting MySQL..."
mysqld_safe &
#systemctl start mysql

echo "Starting Redis..."
redis-server &
#systemctl start redis-server

# ====================================================================
# Cassandra Startup and JVM Fixes
# This section applies the fixes we identified for the JVM options.
# ====================================================================

# This command ensures any existing Cassandra process is terminated before a new one is started.
kill $(ps aux | grep 'cassandra' | awk '{print $2}' | head -1)

echo "Correcting Cassandra JVM options..."

# Comment out all outdated CMS garbage collector options found during troubleshooting.
sed -i 's/-XX:+UseConcMarkSweepGC/#-XX:+UseConcMarkSweepGC/' /opt/cassandra/conf/jvm11-server.options
sed -i 's/-XX:+CMSParallelRemarkEnabled/#-XX:+CMSParallelRemarkEnabled/' /opt/cassandra/conf/jvm11-server.options
sed -i 's/-XX:CMSInitiatingOccupancyFraction=75/#-XX:CMSInitiatingOccupancyFraction=75/' /opt/cassandra/conf/jvm11-server.options
sed -i 's/-XX:+UseCMSInitiatingOccupancyOnly/#-XX:+UseCMSInitiatingOccupancyOnly/' /opt/cassandra/conf/jvm11-server.options

# Uncomment the G1 Garbage Collector option, which is suitable for a modern JVM.
sed -i 's/#-XX:+UseG1GC/-XX:+UseG1GC/' /opt/cassandra/conf/jvm11-server.options

echo "Starting Cassandra in the background..."
/opt/cassandra/bin/cassandra -R &

# ====================================================================
# PostgreSQL Startup
# This section ensures PostgreSQL starts correctly with the right
# user, PATH, and data directory.
# ====================================================================

echo "Switching to 'postgres' user and starting PostgreSQL..."

# Set the PGDATA environment variable and start the server as the postgres user.
# The `su - postgres -c "..."` command is crucial to run the command with the
# correct user and its own environment, including the PATH.
su - postgres -c "export PATH=$PATH:/usr/lib/postgresql/17/bin; export PGDATA=/var/lib/postgresql/17/main; pg_ctl start"

# ====================================================================
# Keep the container running
# This prevents the container from exiting immediately.
# ====================================================================

echo "Services started. Waiting for the container to be terminated..."
wait


# Give services a moment to start up
echo "Waiting for databases to initialize..."
sleep 30

# Now, run your monitoring agent
#echo "Starting Database Sentinel..."
#/path/to/db_analyzer.py &

# Keep the container running
tail -f /dev/null