FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Expose port
EXPOSE 5000

# Set environment variable to disable Flask debug mode in production
ENV FLASK_ENV=production

# Run the application
CMD ["python", "app.py"]
