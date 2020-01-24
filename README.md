locize-cli-docker
==================

This is a convenience wrapper for [locize-cli](https://github.com/locize/locize-cli)

### Default workdir
`/lang`

### Entrypoint
The entrypoint of the image is the cli so you only need to add ther parameters/arguments for the command. You can read more about enrypoints [here](https://aws.amazon.com/blogs/opensource/demystifying-entrypoint-cmd-docker/).

## Example usage

### For docker image builds (this is the primary reason this image exists)

	FROM maven:3-jdk-11-slim as dependencies
	WORKDIR /build
	COPY pom.xml .
	RUN mvn dependency:go-offline

	FROM neticle/locize-cli:latest as translations
	WORKDIR /lang
	ENV LOCIZE_PID=<YOUR_PROJECT_ID>
	RUN locize download --namespace backend --format properties

	FROM dependencies as target
	COPY src/ /build/src/
	COPY --from=translations /lang/*.properties /build/src/main/resources
	RUN mvn package

	FROM openjdk:11-jre-slim
	CMD exec java $JAVA_OPTS -jar /app/your-jar.jar
	COPY --from=target /build/target/your-jar.jar /app/your-jar.jar

### Use in docker compose

	version: '2.4'
	services:
  		locize:
	    	image: neticle/locize-cli:latest
	    	volumes:
	      		- './src/main/resources/:/locize/'
	    	user: '1000:1000'
	    	environment:
		      	LOCIZE_PID: <YOUR_PROJECT_ID>
		      	LOCIZE_KEY: <YOUR_PROJECT_SECRET>
	    	command: sync --skip-empty true --skip-delete true --format properties
	    	#restart: always # use this if you need 'real-time' sync

In this case you can use locize as follows: `docker-compose run locize --help`

### Use with docker run

	docker run -it --rm -it --rm --env LOCIZE_PID=<YOUR_PROJECT_ID> -v `pwd`/src/main/resources/:/lang neticle/locize-cli --help
