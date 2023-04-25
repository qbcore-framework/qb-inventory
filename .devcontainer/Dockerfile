FROM mcr.microsoft.com/devcontainers/typescript-node:0-18-bullseye

# Install Cypress dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*
