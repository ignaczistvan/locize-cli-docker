FROM node:12-alpine
WORKDIR /locize
RUN npm install -g locize-cli
ENTRYPOINT ["locize"]
