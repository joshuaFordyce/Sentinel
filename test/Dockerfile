# Start with a lightweight Debian base image.
FROM debian:bookworm-slim

# Install core dependencies.
RUN apt-get update && apt-get install -y \
    procps net-tools lsb-release gnupg2 curl \
    systemd systemd-sysv \
    python3 python3-pip \
    # Install OpenJDK 11, which Cassandra requires
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install PostgreSQL (from PostgreSQL's official apt repo for the latest version).
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgresql.gpg \
    && echo "deb [ signed-by=/usr/share/keyrings/postgresql.gpg ] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install MySQL and Redis (from standard Debian repos)
RUN apt-get update && apt-get install -y \
    default-mysql-server \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# Install Cassandra: Download the tarball and extract it
RUN curl -fsSL "https://downloads.apache.org/cassandra/4.1.10/apache-cassandra-4.1.10-bin.tar.gz" \
    -o /tmp/cassandra.tar.gz \
    && mkdir -p /opt/cassandra \
    && tar -xzf /tmp/cassandra.tar.gz -C /opt/cassandra --strip-components=1 \
    && rm /tmp/cassandra.tar.gz

RUN sed -i 's/^#*\s*-XX:+UseConcMarkSweepGC/-XX:+UseG1GC/' /opt/cassandra/conf/jvm-server.options
# Set up Cassandra's data directories
RUN mkdir -p /var/lib/cassandra/data \
    /var/lib/cassandra/commitlog \
    /var/lib/cassandra/hints \
    /var/lib/cassandra/saved_caches \
    && chown -R cassandra:cassandra /var/lib/cassandra/ \
    || true 
# Ignore error if cassandra user doesn't exist yet

# First, update the package list and install
RUN apt-get update && apt-get install -y python3-venv

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and install packages
RUN /opt/venv/bin/pip install cassandra-driver

# Optional: Configure the container to use the venv by default
ENV PATH="/opt/venv/bin:$PATH"



# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose ports for all databases
EXPOSE 5432 3306 6379 9042

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]