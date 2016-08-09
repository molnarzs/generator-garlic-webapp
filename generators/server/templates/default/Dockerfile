FROM node:6

ARG NPM_TOKEN

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Install app dependencies
ADD package.json /app/
RUN echo "//registry.npmjs.org/:_authToken=\${NPM_TOKEN}" > ~/.npmrc
RUN npm install --silent && rm -f ~/.npmrc

RUN npm install --silent -g gulp

ADD . /app/
RUN npm run-script build

EXPOSE 3000

ENTRYPOINT [ "npm" ]
