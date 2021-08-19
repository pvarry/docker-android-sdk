FROM openjdk:11-jdk

# Configure base folders.
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin

ADD start-default-emulator.sh /opt

# Update the base image with the required components.
RUN apt-get --quiet update --yes \
  && apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
  
ARG ANDROID_SDK_TOOLS="7583922"

# Download the Android SDK and unpack it to the destination folder.
RUN wget --quiet --output-document=commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip \
  && mkdir ${ANDROID_HOME} \
  && unzip -q commandlinetools.zip -d ${ANDROID_HOME}/cmdline-tools \
  && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
  && rm -f commandlinetools.zip

# Install the SDK components.
RUN mkdir ${HOME}/.android \
  && echo "count=0" > ${HOME}/.android/repositories.cfg \
  && echo y | sdkmanager --sdk_root=${ANDROID_HOME} --licenses || true \
  && echo y | sdkmanager 'tools' \
  && echo y | sdkmanager 'platform-tools' \
  && echo y | sdkmanager 'build-tools;31.0.0' \
  && echo y | sdkmanager 'platforms;android-31' \
  && echo y | sdkmanager "emulator" \
  && echo y | sdkmanager "system-images;android-31;google_apis;x86_64" \
  && echo y | sdkmanager --update \
  && echo "no" | avdmanager create avd -n default -k "system-images;android-31;google_apis;x86_64" -d "pixel_2_xl" \
  && rm -rf /var/lib/apt/lists/* \
  && chmod a+x /opt/start-default-emulator.sh

# Disable Gradle daemon, since we are running on a CI server.
RUN mkdir ${HOME}/.gradle \
  && echo "org.gradle.daemon=false" > ${HOME}/.gradle/gradle.properties

# Set the environmental variables
ENV PATH ${PATH}:${ANDROID_HOME}/platform-tools
