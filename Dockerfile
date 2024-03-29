FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
	git \
	gradle \
	wget

WORKDIR /home
RUN git clone https://gitlab.com/intention-progression-competition/simulator/simulator-server.git
WORKDIR /home/simulator-server
RUN git pull
RUN git checkout release
RUN ./gradlew fatJar


WORKDIR /home
RUN git clone https://gitlab.com/intention-progression-competition/simulator/bdi-interface.git
WORKDIR /home/bdi-interface
RUN git pull
RUN git checkout release
RUN ./gradlew fatJar

WORKDIR /home

RUN wget https://gitlab.com/intention-progression-competition/example-gpts/example-gpts/-/archive/release/example-gpts-release.zip
RUN unzip example-gpts-release.zip
RUN rm example-gpts-release.zip
RUN mkdir gpts
RUN mv example-gpts-release example-gpts
RUN mv example-gpts gpts/
COPY test-gpts /home/gpts/test-gpts


EXPOSE 30000
EXPOSE 40000

# default command
CMD ["bash"]
