FROM node:20-alpine

ARG RESULT_PORT=4000
ARG POSTGRES_USER=postgres
ARG POSTGRES_PASSWORD=postgres
ARG POSTGRES_DB=postgres
ARG POSTGRES_HOST=db
ARG POSTGRES_PORT=5432

ENV RESULT_PORT=$RESULT_PORT
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV POSTGRES_DB=$POSTGRES_DB
ENV POSTGRES_HOST=$POSTGRES_HOST
ENV POSTGRES_PORT=$POSTGRES_PORT

# Create a non-root user/group for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup


WORKDIR /app


COPY package*.json ./


RUN npm ci && npm cache clean --force


COPY . .

# Change ownership of the files to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser


EXPOSE 4000


CMD ["node", "server.js"]