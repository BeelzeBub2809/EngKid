FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copi$
# where available (npm@5+)
COPY db.json ./

RUN npm install -g json-server

EXPOSE 3000

CMD [ "json-server", "-H", "0.0.0.0", "db.json"]
