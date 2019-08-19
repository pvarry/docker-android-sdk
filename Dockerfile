FROM ubuntu:18.04

# Configure base folders.
ENV ANDROID_HOME /opt/android-sdk

# Update the base image with the required components.
RUN apt-get update \
  && apt-get install openjdk-8-jdk wget tar zip unzip lib32stdc++6 lib32z1 git file build-essential -y \
  && rm -rf /var/lib/apt/lists/*

# Download the Android SDK and unpack it to the destination folder.
RUN wget --quiet --output-document=sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
  && mkdir ${ANDROID_HOME} \
  && unzip -q sdk-tools.zip -d ${ANDROID_HOME} \
  && rm -f sdk-tools.zip

# Install the SDK components.
RUN mkdir ${HOME}/.android \
  && echo "count=0" > ${HOME}/.android/repositories.cfg \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'tools' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platform-tools' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'ndk-bundle' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'build-tools;29.0.2' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-19' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-23' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-25' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-26' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-27' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-28' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;android;m2repository' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --update

# Install the add-on SDKs (offline).
COPY add-ons-linux.zip add-ons.zip
RUN unzip -qo add-ons.zip -d ${ANDROID_HOME} \
  && rm -f add-ons.zip \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --update

# Disable Gradle daemon, since we are running on a CI server.
RUN mkdir ${HOME}/.gradle \
  && echo "org.gradle.daemon=false" > ${HOME}/.gradle/gradle.properties

# Set the environmental variables
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/ndk-bundle
