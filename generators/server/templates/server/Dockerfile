FROM <%= c.dockerRepo %>/<%= c.type %>

COPY package.json /app/
RUN yarn && \
  yarn cache clean

COPY dist/ /app
