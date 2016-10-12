FROM <%= c.dockerRepo %>/webpack

COPY ./package.json /app
COPY ./bower.json /app

RUN npm install --silent && \
  bower install --silent --allow-root
