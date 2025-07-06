# Stage 1: Builder
FROM python:3.10-slim AS builder



WORKDIR /app


RUN apt-get update && apt-get install -y build-essential gcc


COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --prefix=/install -r requirements.txt


COPY app.py .

# Create a non-root user with fixed UID/GID
RUN groupadd -g 1001 nonroot && useradd -u 1001 -g nonroot -m -s /usr/sbin/nologin nonrootuser

# Stage 2: Final Distroless Image
FROM gcr.io/distroless/python3-debian12

WORKDIR /app


COPY --from=builder /install /usr/local
COPY --from=builder /app .

# Use same UID/GID as created in builder stage
USER 1001

EXPOSE 8000

# Set the entrypoint to run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
