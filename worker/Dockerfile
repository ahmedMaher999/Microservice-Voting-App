# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source

# Copy the project file and restore dependencies
COPY Worker.csproj .
RUN dotnet restore

# Copy the rest of the source code and build
COPY . .
RUN dotnet publish -c Release -o /app

# Stage 2: Create the final runtime image
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app

# Copy the binary from the build stage
COPY --from=build /app .

ARG REDIS_HOST=redis
ARG POSTGRES_HOST=db
ARG POSTGRES_USER=postgres
ARG POSTGRES_PASSWORD=postgres
ARG POSTGRES_DB=postgres

ENV REDIS_HOST=$REDIS_HOST
ENV POSTGRES_HOST=$POSTGRES_HOST
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV POSTGRES_DB=$POSTGRES_DB

# Set the entrypoint
ENTRYPOINT ["dotnet", "Worker.dll"]