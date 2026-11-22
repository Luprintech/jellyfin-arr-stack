-- Se ejecuta solo la primera vez que arranca chaptarr-db (con la carpeta de datos vacía).
-- Chaptarr usa tres bases de datos: main (la crea POSTGRES_DB), log y cache.
CREATE DATABASE "chaptarr-log" OWNER chaptarr;
CREATE DATABASE "chaptarr-cache" OWNER chaptarr;
ALTER ROLE chaptarr CREATEDB;
