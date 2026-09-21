# lab-docker-flask

Stack Flask + PostgreSQL con Docker Compose: secretos, redes aisladas y volumen persistente.

## Estructura

```
flask-docker-app/
├── app.py            # API Flask (psycopg + connection pool)
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── .gitignore
├── pg_password.txt   # secreto (NO versionado, crear a mano)
├── init.sql          # esquema de la tabla item
└── compose.yaml
```

## Archivos que hay que crear a mano

`pg_password.txt` está en `.gitignore` y `.dockerignore`, así que no viene en el clon:

```bash
printf '<tu-password>' > pg_password.txt   # printf, no echo (sin salto de línea)
wc -c pg_password.txt                      # no debe incluir salto de línea final
```

## Uso

```bash
docker compose up --build -d
curl localhost:8080/api/health
curl -H "Content-Type: application/json" -d '{"priority":"high","task":"doctor appointment"}' localhost:8080/items
curl localhost:8080/items
```

## Qué incluye

| Aspecto | Implementación |
|---|---|
| Credenciales | Secret `pg_password` montado en ambos servicios (Forma B). Postgres usa `POSTGRES_PASSWORD_FILE`, Flask lee `/run/secrets/pg_password` |
| Red | `public` (solo Flask, puerto 8080) + `private` con `internal: true` (Flask y Postgres). Postgres sin `ports` |
| Persistencia | Named volume `postgres-data`; los datos sobreviven a `docker compose down` |
| Esquema | `init.sql` montado `:ro` en `/docker-entrypoint-initdb.d/` |
