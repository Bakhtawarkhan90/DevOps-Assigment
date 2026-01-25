FROM python:3.11-slim

# 2. Set environment variables
# Prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE 1
# Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# 3. Set the working directory inside the container
WORKDIR /app

# 4. Install system dependencies for psycopg2 (PostgreSQL driver)
# We need these to compile the database driver
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 5. Install Python dependencies
# Instead of copying everything, we install specific packages first for better caching
RUN pip install --no-cache-dir django django-cors-headers psycopg2-binary gunicorn

# 6. Copy the rest of your Django project code into the container
COPY . .

# 7. Expose the port Django/Gunicorn will run on
EXPOSE 8000

# 8. Command to run the application
# For production, we use gunicorn instead of 'runserver'
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
