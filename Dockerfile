FROM ubuntu:16.04

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

COPY android-accept-licenses.sh /opt

RUN apt-get update
RUN apt-get install default-jdk wget unzip expect git -y
RUN dpkg --add-architecture i386
RUN apt-get -qqy update
RUN apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386
RUN wget --quiet --output-document=sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
RUN mkdir /opt/android-sdk-linux
RUN unzip sdk-tools.zip -d /opt/android-sdk-linux
RUN rm -f sdk-tools.zip
RUN rm -rf /var/lib/apt/lists/*

RUN /opt/android-accept-licenses.sh "/opt/android-sdk-linux/tools/android update sdk -a -u -t tools,platform-tools,build-tools-25.0.3,android-23,extra-android-m2repository,extra-google-m2repository"
RUN rm -rf /var/lib/apt/lists/*
