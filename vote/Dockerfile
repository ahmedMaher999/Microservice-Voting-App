FROM python:3.10-slim

    
# This ARG controls the final CMD. 'prod' or 'dev'.
# It defaults to 'prod' for safety in CI/CD.
ARG APP_ENV="prod"
    
# Args for application config (will be passed from docker-compose or GH Secrets)
# We set sensible defaults for the dev environment.
ARG REDIS_HOST="redis"
ARG REDIS_PORT=6379
ARG OPTION_A="Cats"
ARG OPTION_B="Dogs"
    

    
# Pass the build-time ARGs to runtime ENVs
# This "burns" the configuration into the final image,
# where os.getenv() in your app.py can read it.
ENV APP_ENV=$APP_ENV
ENV REDIS_HOST=$REDIS_HOST
ENV REDIS_PORT=$REDIS_PORT
ENV OPTION_A=$OPTION_A
ENV OPTION_B=$OPTION_B
        
  
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
    
COPY . .
    
 
# Both dev (app.py) and prod (gunicorn) are set to run on port 80
EXPOSE 80
    

# This command checks the $APP_ENV variable at runtime:
# - If "dev", it runs the Flask dev server (which supports hot-reloading)
# - Otherwise (else), it runs the production-ready gunicorn server
CMD ["sh", "-c", "\
if [ \"$APP_ENV\" = \"dev\" ]; then \
    python app.py; \
else \
    gunicorn --workers 4 --bind 0.0.0.0:80 app:app; \
fi"]

