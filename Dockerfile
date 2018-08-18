FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y gnupg2
run apt-get install -y curl

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# install postgresql
RUN apt-get -y install postgresql-10

# install java - this is required for flyway
RUN apt-get -y install openjdk-8-jdk

# NOTE: THIS IS MOSTLY COPIED FROM https://github.com/flyway/flyway-docker/blob/master/Dockerfile
WORKDIR /flyway
ENV FLYWAY_VERSION 5.1.4
RUN curl -L https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz -o flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz --strip-components=1 \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && ln -s /flyway /usr/local/bin/flyway

# change ownership of flwyay to postgres
RUN chown postgres /usr/local/bin/flyway/flyway

# NOTE: THIS IS MOSTLY COPIED FROM https://docs.docker.com/engine/examples/postgresql_service/
USER postgres

# add sql migration files
ADD sql/ /flyway/sql

# set up database
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER tasks WITH SUPERUSER PASSWORD 'tasks';" &&\
    psql --command "CREATE DATABASE tasks;" &&\
    /usr/local/bin/flyway/flyway -url=jdbc:postgresql://localhost:5432/tasks -user=tasks -password=tasks migrate

RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/10/main/pg_hba.conf

RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf

EXPOSE 5432

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["/usr/lib/postgresql/10/bin/postgres", "-D", "/var/lib/postgresql/10/main", "-c", "config_file=/etc/postgresql/10/main/postgresql.conf"]
