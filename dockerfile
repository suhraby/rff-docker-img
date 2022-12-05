FROM --platform=linux/amd64 node:16-alpine AS development

ENV PORT=8080

WORKDIR /code

RUN npm -g install npm@latest --registry=https://registry.npm.taobao.org

COPY package.json /code/package.json
COPY package-lock.json /code/package-lock.json
RUN npm install --registry=https://registry.npm.taobao.org

COPY . /code

CMD [ "npm", "start" ]

FROM development AS builder

RUN npm run build

FROM --platform=linux/amd64 nginx:stable-alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /code/build /usr/share/nginx/html