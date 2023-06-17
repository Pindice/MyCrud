# Construire l'image de l'application Django
FROM python:3.9 as backend

WORKDIR /app/backend

COPY backend/requirements.txt ./
RUN pip install -r requirements.txt

COPY backend/ .
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Construire l'image de l'application Vue.js
FROM node:14 as frontend

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ .
RUN npm run build

# Combiner l'application Django et l'application Vue.js
FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY --from=backend /app/backend /app/backend
COPY --from=frontend /app/frontend/dist /app/frontend/dist

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
