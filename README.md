# Champ

This is a version of GitHub's Campfire bot, hubot. He's pretty cool.

This version is designed to be deployed in a Docker container. He has a Redis brain, TeamCity scripts, and a HipChat adapter. You can test him out by building and then running him locally. By default, he won't use the HipChat adapter, but it's there if you want it.

## TL;DR

1. build champ: `docker build -t champ:local .`
1. create a Dockerfile that sets the variables Champ needs to interact with HipChat and TeamCity:

```Dockerfile
FROM champ:local

ENV HUBOT_HIPCHAT_JID=champs-hipchat-jid
ENV HUBOT_HIPCHAT_PASSWORD=champs-password
ENV HUBOT_HIPCHAT_ROOMS=hipchat,rooom,list
ENV HUBOT_AUTH_ADMIN=auth,ids
ENV HUBOT_TEAMCITY_USERNAME=champ-teamcity-username
ENV HUBOT_TEAMICTY_PASSWORD=champ-teamcity-password
ENV HUBOT_TEAMCITY_HOSTNAME=teamcity.example.com

CMD ["--adapter", "hipchat"]
```

1. build your image: `docker build -t champ:latest
1. Run a redis container: `docker run -d --name redis -p 6379:6379 dockerfile/redis`
1. Run champ: `docker run -d --name champ --link redis:redis champ:latest`
 
## Getting Started

## Building the Docker image

   docker build -t TAG .

### Testing Champ in Docker

   docker run --rm -i --name redis redis
   docker run --rm -i --link redis:redis TAG

### Building Champ Locally

Building and Testing Champ locally is largely an exercise in manually doing what the Dockerfile already wraps up. With that said:

1. Install the HipChat adapter's native dependencies. See https://github.com/hipchat/hubot-hipchat.
1. Install the Hubot dependencies

   npm install

### Testing Champ Locally

You can test your hubot by running the following.

    % bin/hubot

You'll see some start up output about where your scripts come from and a
prompt.

    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading adapter shell
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/scripts
    [Sun, 04 Dec 2011 18:41:11 GMT] INFO Loading scripts from /home/tomb/Development/hubot/src/scripts
    Hubot>

Then you can interact with hubot by typing `hubot help`.

    Hubot> hubot help

    Hubot> animate me <query> - The same thing as `image me`, except adds a few
    convert me <expression> to <units> - Convert expression to given units.
    help - Displays all of the help commands that Hubot knows about.
    ...

## Required configuration

All configuration is done via environment variables. It may be easiest to create a container based on champ, setting the environment variables that Champ needs using Dockerfile ENV commands

```Dockerfile
ENV HUBOT_HIPCHAT_JID=champs-hipchat-jid
ENV HUBOT_HIPCHAT_PASSWORD=champs-password
ENV HUBOT_HIPCHAT_ROOMS=hipchat,rooom,list
ENV REDIS_URL=redis://redis:6379
ENV HUBOT_AUTH_ADMIN=auth,ids
ENV HUBOT_TEAMCITY_USERNAME=champ-teamcity-username
ENV HUBOT_TEAMICTY_PASSWORD=champ-teamcity-password
ENV HUBOT_TEAMCITY_HOSTNAME=teamcity.example.com
ENV HUBOT_TEAMCITY_SCHEME=https

CMD ["--adapter", "hipchat"]
```

Champ is configured to expect HUBOT_TEAMCITY_SCHEME is https and REDIS_URL is constructed using environment variables, assuming a container named `redis` is linked to Champ. You can override those in your own Dockerfile, or at the command line if necessary.

### HipChat

The HipChat adapter is configured via environment variables. See https://github.com/hipchat/hubot-hipchat for details.

### Redis Persistence

To use the Redis brain, set the variables required by [redis-brain.coffee](https://github.com/github/hubot-scripts/blob/master/src/scripts/redis-brain.coffee). Linking a redis container is an easy to way to connect a Redis instance. In fact, Champ already expects that you've linked a Redis container: ```REDIS_URL=redis://redis:6379```. You are not required to use the REDIS_URL default; it can be overridden, or one of the other environment variables that the redis-brain uses can be set. The REDIS_URL is the least preferred of the possible environment variables.

### TeamCity Scheme

Champ expects TeamCity is accessed over HTTPS, but that can be overriden by setting the HUBOT_TEAMCITY_SCHEME environment variable.
