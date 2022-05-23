FROM node:16-alpine AS STAGE_TEST

ENV NODE_ENV production

WORKDIR /app

ADD package*.json /app/
RUN apk add --no-cache --update make git &&  \
  npm ci

ADD . /app/

EXPOSE 80

CMD ["node", "./server.js"]
