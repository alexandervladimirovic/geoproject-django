FROM ghcr.io/astral-sh/uv:python3.11-alpine

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apk update && \
apk add --no-cache gdal \
    gdal-dev \
    geos \
    geos-dev \
    postgis \
    postgresql-dev && \
    rm -rf /var/cache/apk/*

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync \
    --frozen \
    --no-install-project \
    --no-dev

ADD ./geoproject-django /app

ENV PATH="/app/.venv/bin:$PATH"

RUN chmod +x prestart.sh