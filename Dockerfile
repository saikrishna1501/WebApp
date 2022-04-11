FROM node:14-alpine as builder

RUN npm install -g @angular/cli

WORKDIR /app

#copying package.json first so that if there is no change package.json then npm install will not execute
COPY package.json .

RUN npm install

#excluding node_modules in .dockerignore file
COPY . .

RUN ng build

FROM nginx as runner

COPY --from=builder /app/dist/WebApp /usr/share/nginx/html