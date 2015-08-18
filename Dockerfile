FROM node:0.12
MAINTAINER bhcleek <bhcleek@gmail.com>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
		apt-get install -y libexpat1-dev libicu-dev
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app

ENV REDIS_URL redis://redis:6379
ENV HUBOT_TEAMCITY_SCHEME https

ENTRYPOINT ["npm", "start", "--"]
CMD ["--name", "champ"]
