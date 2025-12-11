# Refactors based on work done for a course project.
FROM node:18-bullseye-slim

WORKDIR /usr/src/app

# Copy NPM package files to leverage Docker cache.
COPY shared/package*.json ./shared
COPY townService/package*.json /townService

# Copy the rest of the code needed for the backend.
COPY ./shared ./shared
COPY ./townService ./townService

RUN npm config set fetch-retries 3

# Install dependencies and build
RUN cd ./shared && npm ci --unsafe-perm && npm cache clean --force
RUN cd ./townService && npm ci --unsafe-perm && npm prestart && npm cache clean --force

ENV NODE_ENV=production\
    PORT=5000
EXPOSE 5000
CMD [ "npm", "start", "prefix", "townService" ]
