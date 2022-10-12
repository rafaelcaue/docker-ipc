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

You should now see the expected messages in all 3 terminals without any errors.

## Docker server

This assumes you have [Docker](https://www.docker.com/) installed, and that you have already cloned https://gitlab.com/intention-progression-competition/example-agents/test-agent into a folder.   
Steps 1 and 2 only need to be run once.
Sudo/admin rights may be required depending on how Docker was installed.   
Do not alter the Dockerfile unless you are experimenting with something. The Dockerfile for the competition will be used as is (pending any bugfixes).

1. Clone the Docker server repository: `git clone https://github.com/rafaelcaue/docker-ipc.git`
2. Build the Docker container: `docker build -t ipc-simulator .`
3. Run the container: `docker run -it --rm -p 40000:40000 -p 30000:30000 ipc-simulator bash`
4. Run the server: `java -jar simulator-server/build/libs/simulator-server-all-1.0.jar`
5. Open a new terminal and type `docker ps`
6. Copy the ID associated with the container ipc-simulator obtained from the docker ps command
7. Replace <container_id> with the ID from the previous step: `docker exec -it <container_id> bash`
8. Run the bdi-interface: `java -jar bdi-interface/build/libs/bdi-interface-all-1.0.jar`
9. Open a new terminal and navigate to the folder containing the `test-agent`
10. Compile the test agent if you have not done so yet (only needs to be done once and when the source code changes): `./gradlew jar`  
11. Run the test-agent with: `java -jar build/libs/test-agent.jar` 
12. To test, provide the first command, for example with: `<?xml version="1.0" encoding="UTF-8"?><command clientid="UONTEST1"><initiate><seed>10000</seed><gptfile>example-gpts-release/logistics/gpt-t5-a5-p10.xml</gptfile></initiate></command>`

You should now see the expected messages in all 3 terminals without any errors.

## Docker server with Docker solution

Note that some steps here will be replicated from the Docker server tutorial, and some may look similar but are different. In doubt just run all of the steps from this part of the tutorial.   
Steps 1 to 7 only need to be run once (steps 5 to 7 may require repeating if you make changes to your solution).

1. Create the network the containers will use (can be done from any directory): `docker network create ipc_network`
2. Clone the Docker server repository: `git clone https://github.com/rafaelcaue/docker-ipc.git`
3. Navigate to the docker-ipc folder
4. Build the Docker server container: `docker build -t ipc-simulator .`
5. Clone the Docker IPC submission example repository: `git clone https://github.com/rafaelcaue/docker-ipc-submission-TestAgent.git`
6. Navigate to the docker-ipc-submission-TestAgent folder
7. Build the Docker IPC submission container: `docker build -t ipc-submission-testagent .`
8. Navigate to the docker-ipc folder
9. Run the server container: `docker run -it --rm --network=ipc_network --name ipc_server ipc-simulator bash`
10. Run the server: `java -jar simulator-server/build/libs/simulator-server-all-1.0.jar`
11. Open a new terminal and type `docker ps`
12. Copy the ID associated with the container ipc-simulator obtained from the docker ps command
13. Replace <container_id> with the ID from the previous step: `docker exec -it <container_id> bash`
14. Run the bdi-interface: `java -jar bdi-interface/build/libs/bdi-interface-all-1.0.jar -C`
15. Open a new terminal and navigate to the docker-ipc-submission-TestAgent folder
16. Run the solution container: `docker run -it --rm --network=ipc_network ipc-submission-testagent`
17. Run the solution: `java -jar test-agent/build/libs/test-agent.jar -C`
18. To test, provide the first command, for example with: `<?xml version="1.0" encoding="UTF-8"?><command clientid="UONTEST1"><initiate><seed>10000</seed><gptfile>example-gpts-release/logistics/gpt-t5-a5-p10.xml</gptfile></initiate></command>`

You should now see the expected messages in all 3 terminals without any errors.

## Tutorial how to containerise your solution

TBD

### FAQ
1. How to add a custom GPT to the simulation server when running the containerised version of the server?   
A. There are two ways of doing this:
   - You can do it live in the container as you would normally (it won't be there again in subsequent runs of the container)
   - Or to have it permanently added to the container, assuming the name of the file is `gpt-test.xml` and it is in the same folder as Dockerfile, you can add the following commands to line 23 of Dockerfile:   
   `COPY gpt-test.xml /home/example-gpts-release/`   
