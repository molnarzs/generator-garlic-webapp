FROM <%= c.dockerRepo %>/workflows-library:<%= c.dockerWorkflowVersion %>

ARG NPM_TOKEN
COPY ./package.json /app/package.project.json
RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > $HOME/.npmrc && \
  scripts/install_dependencies
