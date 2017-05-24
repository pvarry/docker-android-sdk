FROM ubuntu:16.04

# Configure base folders.
ENV ANDROID_HOME /opt/android-sdk
ENV GRADLE_HOME /usr/lib/gradle

# Update the base image with the required components.
RUN apt-get update
RUN apt-get install openjdk-8-jdk wget unzip expect git -y
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
RUN echo 'count=0' > ${HOME}/.android/repositories.cfg

RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --update 
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'tools'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platform-tools'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'build-tools;'${ANDROID_BUILD_TOOLS_VERSION}
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-23'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;android;m2repository'
RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;google;m2repository'

# Download and install Gradle
ENV GRADLE_VERSION 3.3
ENV GRADLE_SHA c58650c278d8cf0696cab65108ae3c8d95eea9c1938e0eb8b997095d5ca9a292

RUN cd /usr/lib \
 && curl -fl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
 && echo "${GRADLE_SHA} gradle-bin.zip" | sha256sum -c - \
 && unzip "gradle-bin.zip" \
 && ln -s "${GRADLE_HOME}-${GRADLE_VERSION}/bin/gradle" ${GRADLE_HOME} \
 && rm "gradle-bin.zip"

# Set Appropriate Environmental Variables
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV PATH ${PATH}:${GRADLE_HOME}/bin
