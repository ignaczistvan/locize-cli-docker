FROM node:12-alpine
WORKDIR /locize
RUN npm install -g locize-cli@7.0.1
ENTRYPOINT ["locize"]
