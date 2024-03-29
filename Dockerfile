# syntax=docker/dockerfile:1

ARG NODE_VERSION=21.3.0

FROM node:${NODE_VERSION}-alpine as base
WORKDIR /usr/src/app
EXPOSE 3000

FROM base as dev
COPY package.json package.json
COPY package.json package-lock.json
RUN npm i --include=dev
#USER node
COPY . .
CMD npm run dev --open


FROM base as prod
ENV NODE_ENV production
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm i --omit=dev
USER node
COPY . .
CMD node src/index.js