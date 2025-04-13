#Build the package
FROM python:3.12-slim as builder

WORKDIR /app
COPY pyproject.toml README.md LICENSE ./
COPY src/ ./src

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir flit && \
    flit build

#Install it on the image
FROM python:3.12-slim as runtime

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/dist/*.whl ./

RUN pip install --no-cache-dir *.whl

CMD ["adk"]