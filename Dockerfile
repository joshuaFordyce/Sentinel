FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    procps \
    sysstat \
    iputils-ping \
    net-tools \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

COPY db_agent/ /app/
WORKDIR /app

RUN pip3 install psycopg2-binary
RUN chmod +x db_check.sh db_analyzer.py

CMD ["./db_check.sh"]