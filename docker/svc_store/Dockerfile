FROM node:18-alpine

RUN mkdir /var/log/node
WORKDIR /app
RUN npm install -g nodemon
RUN apk add --no-cache graphicsmagick ghostscript

CMD npm run start:dev