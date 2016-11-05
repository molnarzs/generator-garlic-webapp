FROM <%= c.dockerRepo %>/<%= c.type %>

COPY package.json /app/
RUN npm install --silent && \
  npm cache clear

COPY dist/ /app
