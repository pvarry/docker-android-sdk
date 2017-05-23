FROM ubuntu:16.04

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

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

RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager --update 
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager 'tools'
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager 'platform-tools'
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager 'build-tools;25.0.3'
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-23'
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;android;m2repository'
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;google;m2repository'

RUN rm -rf /var/lib/apt/lists/*
