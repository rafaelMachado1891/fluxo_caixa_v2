from __future__ import annotations

import os
from dataclasses import dataclass
from urllib.parse import quote_plus


@dataclass(frozen=True)
class TargetDatabaseConfig:
    database_url: str
    schema: str


@dataclass(frozen=True)
class SourceDatabaseConfig:
    database_url: str


@dataclass(frozen=True)
class PipelineConfig:
    source: SourceDatabaseConfig
    target: TargetDatabaseConfig
    raw_schema: str
    sql_dir: str
    write_mode: str


def _get_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise ValueError(f"Variavel de ambiente obrigatoria nao encontrada: {name}")
    return value


def _build_postgres_url_from_parts() -> str:
    host = _get_env("HOST")
    user = quote_plus(_get_env("USER"))
    password = quote_plus(_get_env("PASSWORD"))
    port = _get_env("PORT")
    dbname = _get_env("DBNAME")
    ssl_mode = os.getenv("TARGET_DB_SSLMODE")

    database_url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{dbname}"
    if ssl_mode:
        separator = "&" if "?" in database_url else "?"
        database_url = f"{database_url}{separator}sslmode={ssl_mode}"

    return database_url


def _first_env(*names: str) -> str | None:
    for name in names:
        value = os.getenv(name)
        if value:
            return value
    return None


def _build_source_database_config() -> SourceDatabaseConfig:
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        return SourceDatabaseConfig(database_url=database_url)

    host = _first_env("SOURCE_DB_HOST", "HOST_ORIGEM")
    user = _first_env("SOURCE_DB_USER", "USER_ORIGEM")
    password = _first_env("SOURCE_DB_PASSWORD", "PASSWORD_ORIGEM")
    dbname = _first_env("SOURCE_DB_NAME", "DBNAME_ORIGEM")
    driver = os.getenv("SOURCE_DB_DRIVER", "ODBC Driver 17 for SQL Server")

    if not all([host, user, password, dbname]):
        raise ValueError(
            "Informe DATABASE_URL ou as variaveis de origem "
            "SOURCE_DB_HOST/SOURCE_DB_USER/SOURCE_DB_PASSWORD/SOURCE_DB_NAME."
        )

    encoded_user = quote_plus(user)
    encoded_password = quote_plus(password)
    encoded_driver = quote_plus(driver)
    database_url = (
        f"mssql+pyodbc://{encoded_user}:{encoded_password}@{host}/{dbname}"
        f"?driver={encoded_driver}"
    )
    return SourceDatabaseConfig(database_url=database_url)


def _build_target_database_config() -> TargetDatabaseConfig:
    database_url = os.getenv("TARGET_DATABASE_URL")
    if not database_url:
        database_url = _build_postgres_url_from_parts()

    return TargetDatabaseConfig(
        database_url=database_url,
        schema=_get_env("SCHEMA"),
    )


def load_pipeline_config() -> PipelineConfig:
    return PipelineConfig(
        source=_build_source_database_config(),
        target=_build_target_database_config(),
        raw_schema=os.getenv("RAW_SCHEMA", "raw"),
        sql_dir=os.getenv("SQL_DIR", "src/data/sql"),
        write_mode=os.getenv("WRITE_MODE", "replace"),
    )
