FROM <%= c.dockerRepo %>/<%= c.type %>:<%= c.dockerWorkflowVersion %>

COPY package.json /app/package_project.json
# install_dependencies will merge deps in the container
RUN scripts/install_dependencies package_project.json && \
  npm cache clear

COPY dist/ /app
