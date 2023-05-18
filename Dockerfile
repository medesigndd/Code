# STEP 1 build static website
FROM trion/ng-cli-e2e:14.1.0 as builder
ARG environment

# Create app directory
WORKDIR /app
COPY package.json  /app
# Install app dependencies
RUN npm --registry=https://nexus.sec.or.th/repository/npm-proxy install

# Copy project files into the docker image
COPY .  /app
# Run Unit Test
# RUN npm test --watch false

# Build
RUN ng build -c $environment

# STEP 2 build a small nginx image with static website
FROM nginx:1.17.9-alpine

## Replace default nginx config
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf
## From 'builder' copy website to default nginx public folder
COPY --from=builder /app/dist/client /app/dist/client
