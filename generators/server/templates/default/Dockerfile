FROM <%= c.dockerRepo %>/<%= c.type %>

COPY package.json /app/
RUN npm install --silent

COPY dist/ /app
