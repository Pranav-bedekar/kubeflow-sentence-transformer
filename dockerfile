# Use Python 3.10 as base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Prevent Python from buffering stdout and installing cache
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install essential system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip install --no-cache-dir \
    boto3 \
    numpy \
    tqdm \
    sentence-transformers

# Optional: download a model ahead of time (to cache it inside image)
# This step makes first run much faster (can be commented if not needed)
RUN python -c "from sentence_transformers import SentenceTransformer; \
    print('Downloading model...'); \
    SentenceTransformer('all-MiniLM-L6-v2'); \
    print('Model cached successfully!')"

# Copy project files (if you have any component code)
COPY . .

# Default command — can be overridden by Kubeflow
CMD ["python3"]
