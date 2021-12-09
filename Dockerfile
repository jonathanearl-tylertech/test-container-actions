# Container image that runs your code
FROM node:16 as builder
WORKDIR /app
COPY package*.json ./
RUN npm i
COPY . .
RUN npm run lint --if-present
RUN npm run build
RUN npm run test --if-present -- --watchAll=false

FROM amazon/aws-cli as s3publish
WORKDIR /publish
COPY --from=builder /app/build /publish
RUN ls -l /publish
RUN echo published this package somewhere!

FROM node:16 as npmpublish
WORKDIR /package
COPY --from=builder /app/build/ /package/
RUN ls -l /publish
RUN npm version 1.1.1 --no-git-tag-version
# RUN npm login
# RUN npm publish
RUN echo publish npm package as version 1.1.1
