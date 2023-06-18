# Construire l'image de l'application Django
FROM python:3.9 as backend

WORKDIR /backend

COPY backend/requirements.txt ./
RUN pip install -r requirements.txt

COPY backend .

# Construire l'image de l'application Vue.js
FROM node:14 as frontend

WORKDIR /frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend .
RUN npm run build

# Combiner l'application Django et l'application Vue.js
FROM python:3.9-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /backend

COPY --from=backend /backend /backend
COPY --from=frontend /frontend/dist /frontend/dist

# Copier l'environnement virtuel et les dépendances installées
COPY --from=backend /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]