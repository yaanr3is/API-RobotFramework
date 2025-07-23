FROM python:3.11

WORKDIR /app

RUN apt-get update && apt-get install -y \
    freetds-dev \
    freetds-bin \
    gcc \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN mkdir -p /app/output

RUN pip install poetry

RUN poetry install --no-root

RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]