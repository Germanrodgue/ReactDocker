# Build: docker build -f node.dockerfile -t danwahlin/node .

# Option 1
# Start MongoDB and Node (link Node to MongoDB container with legacy linking)
 
# docker run -d --name my-mongodb mongo
# docker run -d -p 3000:3000 --link my-mongodb:mongodb --name nodeapp danwahlin/node

# Option 2: Create a custom bridge network and add containers into it

# docker network create --driver bridge isolated_network
# docker run -d --net=isolated_network --name mongodb mongo
# docker run -d --net=isolated_network --name nodeapp -p 3000:3000 danwahlin/node

# Seed the database with sample database
# Run: docker exec nodeapp node dbSeeder.js

FROM node:latest

ENV NODE_ENV=development 
ENV PORT=4000

# COPY      . /var/www
WORKDIR  /src

ADD package.json /src/package.json

RUN       npm install 

COPY . /src/app
COPY public /src/public
COPY client /src/src

ADD client/nodemon.json /src/nodemon.json

EXPOSE $PORT

# CMD node app/dbSeeder.js & nodemon -L app/server.js
ENTRYPOINT ["npm", "start"]
