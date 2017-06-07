FROM <%= c.dockerRepo %>/workflows-library:<%= c.dockerWorkflowVersion %>

# These two lines should not be changed!
COPY ./package.json /app/package.project.json
RUN scripts/install_dependencies
