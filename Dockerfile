# --- Stage 1: Build Stage (for installing dependencies) ---
# Use a slim Python image for a smaller base. Replace YOUR_PYTHON_VERSION.
# Example: python:3.9-slim-buster, python:3.10-slim-bullseye, python:3.11-slim-bookworm
FROM python:3.8 AS builder

# Set the working directory inside the container
WORKDIR /app

# Install build dependencies that might be needed for some Python packages
# (e.g., psycopg2, numpy, pandas often need these).
# apt-get update && apt-get install -y --no-install-recommends ...
# Add common build dependencies here if your requirements.txt needs them
# For example, for psycopg2, you might need libpq-dev and gcc
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential \
#     libpq-dev \
#     && rm -rf /var/lib/apt/lists/*

# Copy only requirements.txt to leverage Docker cache
# If requirements.txt doesn't change, this layer won't rebuild
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# --- Stage 2: Production Stage (for running the application) ---
# Use a fresh, even smaller base image for the final production image
# This keeps the final image clean and small, without build dependencies
FROM python:3.8-slim

# Set environment variables (optional, but good practice)
ENV PYTHONUNBUFFERED=1 \
    APP_HOME=/app

# Create the application directory
WORKDIR ${APP_HOME}

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin/ /usr/local/bin/

# Copy your application code into the image
COPY . ${APP_HOME}

# Expose ports if your application is a web service or needs to listen
# EXPOSE 8000

# Define the command to run your application when the container starts
# CMD ["python", "src/main.py"] # If main.py is your entry point
# Or, if you have an entrypoint script:
# CMD ["/bin/bash", "-c", "python src/main.py"]

# More flexible entrypoint, allowing youP to override the default command
# This also makes signals (like Ctrl+C) work better
ENTRYPOINT ["python"]
CMD ["src/main.py"]