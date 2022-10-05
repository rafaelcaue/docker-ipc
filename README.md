This assumes you have [Docker](https://www.docker.com/) installed already.

Command to build the Docker image (sudo/admin rights may be required depending how docker was installed):   
`docker build -t ipc-simulator .`

Command to run the Docker image:   
`sudo docker run -it --rm -p 40000:40000 -p 30000:30000 ipc-simulator bash`

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

Now open another terminal in your machine (terminal 3), we assume you have already cloned https://gitlab.com/intention-progression-competition/example-agents/test-agent   
Navigate to the folder containing test-agent, and type the following commands (this assumes you have gradle installed in your pc):   
`gradlew jar`   
`java -jar build/libs/test-agent.jar`   
`<?xml version="1.0" encoding="UTF-8"?><command clientid="UONTEST1"><initiate><seed>10000</seed><gptfile>example-gpts-release/logistics/gpt-t5-a5-p10.xml</gptfile></initiate></command>`

You should now see the expected messages in all 3 terminals without any errors.
