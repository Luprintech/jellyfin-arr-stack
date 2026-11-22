#!/usr/bin/env bash
# Prepara las carpetas del stack a partir de .env.
# Uso:  ./scripts/setup.sh
# No borra ni sobrescribe nada: solo crea lo que falte.
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ ! -f .env ]]; then
  echo "No existe .env. Créalo primero:  cp .env.example .env  (y edítalo)"
  exit 1
fi

set -a; source .env; set +a

if [[ "${CHAPTARR_DB_PASSWORD:-}" == cambia-esto* ]]; then
  echo "Aviso: CHAPTARR_DB_PASSWORD sigue con el valor de ejemplo. Cámbiala en .env."
  exit 1
fi

echo "==> Configuraciones en ${CONFIG_ROOT}"
for app in jellyfin/config jellyfin/cache qbittorrent prowlarr sonarr radarr \
           seerr wizarr/database chaptarr chaptarr-db/data; do
  mkdir -p "${CONFIG_ROOT}/${app}"
done

echo "==> Medios y descargas en ${DATA_ROOT}"
for dir in torrents/series torrents/peliculas torrents/libros torrents/audiolibros \
           Series Peliculas Libros Audiolibros; do
  mkdir -p "${DATA_ROOT}/${dir}"
done

# Postgres exige que su carpeta de datos sea del usuario con el que corre.
chown "${PUID}:${PGID}" "${CONFIG_ROOT}/chaptarr-db/data" 2>/dev/null || \
  echo "Aviso: no pude cambiar el dueño de chaptarr-db/data (prueba con sudo)."

# Seerr corre siempre como uid 1000.
chown -R 1000:1000 "${CONFIG_ROOT}/seerr" 2>/dev/null || \
  echo "Aviso: Seerr necesita:  sudo chown -R 1000:1000 ${CONFIG_ROOT}/seerr"

echo
echo "Listo. Arranca el stack con:  docker compose up -d"
