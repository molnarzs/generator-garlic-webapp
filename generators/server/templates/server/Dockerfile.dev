FROM <%= c.dockerRepo %>/workflows-server

COPY package.json /app/

RUN npm install --silent && \
  npm cache clear
