FROM node:20 AS base
WORKDIR /app

FROM base AS playwright
RUN npm install -g playwright-chromium
RUN npx playwright install-deps chromium
USER node
RUN npx playwright install chromium
USER root

FROM playwright AS development
ARG UID=1000
ARG GID=1000
RUN usermod -u $UID node \
    && groupmod -g $GID node
USER node

FROM playwright AS build
COPY package.json .
COPY package-lock.json .
RUN npm ci
COPY public public
COPY assets assets
COPY slides.md .
RUN npm run build \
    && npm run export

FROM scratch AS dist
COPY --from=build /app/dist /
COPY --from=build /app/slides-export.pdf /export.pdf
