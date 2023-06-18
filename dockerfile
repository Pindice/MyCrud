# Build the Django application
FROM python:3.9-slim-buster as backend-build

# Install gcc libpq-dev
RUN apt-get update && apt-get install -y gcc libpq-dev

WORKDIR /backend

COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY backend .

# Build the Vue.js application
FROM node:14 as frontend-build

WORKDIR /frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend .
RUN npm run build

# Combine the Django and Vue.js applications
FROM python:3.9-slim-buster

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copy the Django application code
COPY --from=backend-build /backend /app

# Copy the Vue.js static files
COPY --from=frontend-build /frontend/dist /app/frontend/dist

# Install psycopg2 dependencies
RUN apt-get update && apt-get install -y libpq-dev

# Install the application dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Gunicorn
RUN pip install gunicorn

# Expose port 8000
EXPOSE 8000

# Set the entrypoint command to run Gunicorn
CMD ["gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:8000"]
