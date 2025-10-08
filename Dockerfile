# ----------- Build Stage -----------
FROM python:3.12 AS builder

# Install uv package manager
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy dependency file
COPY pyproject.toml .

# Install dependencies into a virtual environment
RUN uv venv .venv && \
    uv pip install -r pyproject.toml

# ----------- Final Stage -----------
FROM python:3.12-slim AS final

# Set working directory
WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv

# Copy application source code
COPY . .

# Create non-root user
RUN useradd -m appuser
RUN chown -R appuser /app
USER appuser

# set PATH
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONPATH="/app:$PYTHONPATH"

# Expose port
EXPOSE 8000

# Set CMD to run FastAPI server
CMD ["/app/.venv/bin/python", "-m", "uvicorn", "cc_simple_server.server:app", "--reload", "--host", "127.0.0.1", "--port", "8000"]
