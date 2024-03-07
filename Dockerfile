# Stage 1: Build stage
FROM python:3.9 as builder

WORKDIR /app

# Copy requirements.txt to the container
COPY requirements.txt .

# Upgrade pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Install dependencies
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the application source code
COPY . .

# Remove requirements.txt to reduce the size of the final image
RUN rm requirements.txt

# Stage 2: Production stage
FROM builder

WORKDIR /app

# Copy the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy the application source code from the builder stage
COPY --from=builder /app/* .

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["python","app.py"]
