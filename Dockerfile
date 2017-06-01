FROM ubuntu:16.04

# Configure base folders.
ENV ANDROID_HOME /opt/android-sdk

# Update the base image with the required components.
RUN apt-get update
RUN apt-get install openjdk-8-jdk wget zip unzip expect git -y
RUN dpkg --add-architecture i386
RUN apt-get -qqy update
RUN apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386

RUN rm -rf /var/lib/apt/lists/*

# Download the Android SDK and unpack it to the destination folder.
ENV ANDROID_SDK_VERSION 3859397

RUN wget --quiet --output-document=sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip
RUN mkdir ${ANDROID_HOME}
RUN unzip -q sdk-tools.zip -d ${ANDROID_HOME}
RUN rm -f sdk-tools.zip

# Install the SDK components.
ENV ANDROID_BUILD_TOOLS_VERSION 25.0.3

RUN mkdir ${HOME}/.android
COPY repositories.cfg ${HOME}/.android
RUN touch ${HOME}/.android/repositories.cfg
RUN chown $RUN_USER:$RUN_USER ${HOME}/.android/repositories.cfg

RUN mkdir ${ANDROID_HOME}/.android
COPY repositories.cfg ${ANDROID_HOME}/.android
RUN touch ${ANDROID_HOME}/.android/repositories.cfg
RUN chown $RUN_USER:$RUN_USER ${ANDROID_HOME}/.android/repositories.cfg

RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --update 
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'tools'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platform-tools'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'build-tools;'${ANDROID_BUILD_TOOLS_VERSION}
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-23'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;android;m2repository'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;google;m2repository'
# RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2'
# RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'add-ons;addon-datalogic-sdk-v1-23-datalogic-23'

# Set Appropriate Environmental Variables
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
