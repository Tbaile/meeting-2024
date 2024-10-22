FROM node:20 AS base
WORKDIR /app

FROM base AS development
ARG UID=1000
ARG GID=1000
RUN usermod -u $UID node \
    && groupmod -g $GID node
USER node

FROM base AS build
COPY package.json .
COPY package-lock.json .
RUN npm ci
COPY assets assets
COPY components components
COPY layouts layouts
COPY public public
COPY slides.md .
ARG BASE_PATH=/
RUN npm run build -- --base "${BASE_PATH}"

FROM scratch AS dist
COPY --from=build /app/dist /
