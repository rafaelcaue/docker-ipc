There are 3 ways of running the Intention Progression Competition:
1. **Local:** cloning the server and bdi-interface repositories and running everything locally. This is only recommended if you want to experiment with the source code of the server outside of the competition.
2. **Docker server:** the server and the bdi-interface run inside a Docker container and you run your solution locally. This is the recommended way of running it during the development/testing stages of your solution.
3. **Docker server with Docker solution:** when both the server and your solution are inside Docker containers. This is required for submission.

## Local
This assumes you have Git, Gradle, and Java installed and are familiar with Git, Gradle, and Java commands.   
This tutorial will show you how to execute the server, the bdi-interface, and the test-agent.   
Steps 1 to 9 only have to be run once (you may need to update the repositories with `git pull` if there were any new changes, and rebuild the jars).
1. Create an `intention-progression-competition` folder
2. Open a terminal and navigate to that folder
3. Clone the simulator-server repository: `git clone https://gitlab.com/intention-progression-competition/simulator/simulator-server.git`
4. Clone the bdi-interface repository: `git clone https://gitlab.com/intention-progression-competition/simulator/bdi-interface.git`
5. Clone the test-agent repository: `git clone https://gitlab.com/intention-progression-competition/example-agents/test-agent.git`
6. Download the example GPTs from https://gitlab.com/intention-progression-competition/example-gpts/example-gpts/-/archive/release/example-gpts-release.zip and extract the zip file into the `intention-progression-competition` root folder
7. Navigate to `intention-progression-competition/simulator-server` and compile the jar file with: `./gradlew fatJar`
8. Navigate to `intention-progression-competition/bdi-interface` and compile the jar file with: `./gradlew fatJar`
9. Navigate to `intention-progression-competition/test-agent` and compile the jar file with: `./gradlew jar`
10. Navigate to `intention-progression-competition` folder
11. Run the simulator-server with: `java -jar simulator-server/build/libs/simulator-server-all-1.0.jar`
12. Open a new terminal and navigate to `intention-progression-competition` folder
13. Run the bdi-interface with: `java -jar bdi-interface/build/libs/bdi-interface-all-1.0.jar`
14. Open a new terminal and navigate to `intention-progression-competition` folder
15. Run the test-agent with: `java -jar test-agent/build/libs/test-agent.jar`
16. To test, provide the first command, for example with: `<?xml version="1.0" encoding="UTF-8"?><command clientid="UONTEST1"><initiate><seed>10000</seed><gptfile>example-gpts-release/logistics/gpt-t5-a5-p10.xml</gptfile></initiate></command>`


## Docker server

## Docker server with Docker solution


This assumes you have [Docker](https://www.docker.com/) installed already.

Run the following command only once to create the network the containers will use (sudo/admin rights may be required depending how docker was installed)::
`docker network create ipc_network`

Command to build the Docker image (sudo/admin rights may be required depending how docker was installed):   
`docker build -t ipc-simulator .`

Command to run the Docker image:   
`docker run -it --rm --network=ipc_network --name ipc_server ipc-simulator bash`

This will open a Docker container terminal, which we refer to as terminal 1.   
To test, run the following commands in terminal 1:   
`java -jar simulator-server/build/libs/simulator-server-all-1.0.jar`

Now open another terminal on your machine, and type the following commands:   
`docker ps`   
`docker exec -it <container_id> bash`   
(replace <container_id> with the id associated with the container ipc-simulator obtained from the docker ps command)   
This will open a second Docker container terminal, which we refer to as terminal 2.   
In terminal 2, run the following commands:   
`java -jar bdi-interface/build/libs/bdi-interface-all-1.0.jar`

## Local solution execution (using a test agent)

Now open another terminal in your machine (terminal 3), we assume you have already cloned https://gitlab.com/intention-progression-competition/example-agents/test-agent   
Navigate to the folder containing test-agent, and type the following commands (this assumes you have gradle installed in your pc):   
`./gradlew jar`   
`java -jar build/libs/test-agent.jar`   
`<?xml version="1.0" encoding="UTF-8"?><command clientid="UONTEST1"><initiate><seed>10000</seed><gptfile>example-gpts-release/logistics/gpt-t5-a5-p10.xml</gptfile></initiate></command>`

You should now see the expected messages in all 3 terminals without any errors.


## Containerising your solution for submission

Follow the example in: https://github.com/rafaelcaue/docker-ipc-submission-TestAgent


### FAQ
1. How to add a custom GPT to the simulation server?   
A. There are two ways of doing this:
   - You can do it live in the container as you would normally (it won't be there again in subsequent runs of the container)
   - Or to have it permanently added to the container, assuming the name of the file is `gpt-test.xml` and it is in the same folder as Dockerfile, you can add the following commands to line 23 of Dockerfile:   
   `COPY gpt-test.xml /home/example-gpts-release/`   
