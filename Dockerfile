# Builder stage: Use official Python image to install dependencies
FROM python:3.9-slim as builder

WORKDIR /app

# Copy requirements and install into a target folder
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Copy app code
COPY app.py .

# Final stage: Use a clean Python image
FROM python:3.9-slim

WORKDIR /app

# Copy only the app code and installed packages from builder
COPY --from=builder /app/app.py .
COPY --from=builder /root/.local /root/.local

# Make sure python can find installed packages
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONPATH=/root/.local

EXPOSE 5000

CMD ["python", "app.py"]
