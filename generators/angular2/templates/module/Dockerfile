FROM <%= conf.dockerRepo %>/angular2-module

COPY ./package.json /app/package_project.json
# COPY ./bower.json /app

# install_dependencies will merge deps in the container
RUN scripts/install_dependencies /app/package_project.json

#  bower install --silent --allow-root

# Don't modify these lines - END
COPY ./dev-site/dll /app/config/dll
RUN echo "APP_ENV=development" > /app/.env
RUN npm run build:dll
COPY tslint.json tsconfig.json /app/
# Don't modify these lines - START :)
