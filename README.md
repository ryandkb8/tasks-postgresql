# Database for tasks service

This is the database for the tasks service.

## Database migrations 
This uses a tool called Flyway for database migrations. 
When the docker image is being built it will run Flyway database migrations using the SQL files in the `sql` directory.
This will result in the docker image having the latest schema. 

## Bringing up local instance
To bring up a local instance of this database database run the following: `./start_db.sh`

## Building docker image
To build the docker image run the following: `./build.sh`

## Releasing
To build the docker image and push it to docker hub run the following: `./release.sh`
The image is versioned by the shorted git hash.