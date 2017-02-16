FROM <%= conf.dockerRepo %>/angular2-module

# install_dependencies will merge deps in the container
COPY ./package.json /app/package_project.json
RUN scripts/install-project-dependencies.sh package_project.json
