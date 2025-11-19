FROM node:20-alpine

ARG RESULT_PORT=4000
ARG PGUSER=postgres
ARG PGPASSWORD=postgres
ARG PGDATABASE=postgres
ARG PGHOST=db
ARG PGPORT=5432

ENV RESULT_PORT=$RESULT_PORT
ENV PGUSER=$PGUSER
ENV PGPASSWORD=$PGPASSWORD
ENV PGDATABASE=$PGDATABASE
ENV PGHOST=$PGHOST
ENV PGPORT=$PGPORT

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