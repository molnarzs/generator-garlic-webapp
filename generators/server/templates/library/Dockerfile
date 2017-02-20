FROM <%= c.dockerRepo %>/workflows-server:<%= c.dockerWorkflowVersion %>

COPY package.json /app/

RUN npm install --silent && \
  npm cache clear
