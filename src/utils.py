from __future__ import annotations

import re
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine

try:
    from src.config import TargetDatabaseConfig, SourceDatabaseConfig
except ModuleNotFoundError:
    from config import TargetDatabaseConfig, SourceDatabaseConfig


class DatabaseConnection:
    def __init__(self, database_url: str):
        self.url = database_url
        self.engine: Engine | None = None

    def get_engine(self) -> Engine:
        if self.engine is None:
            self.engine = create_engine(self.url, pool_pre_ping=True)
        return self.engine


class SourceDatabase(DatabaseConnection):
    def __init__(self, config: SourceDatabaseConfig):
        super().__init__(config.database_url)
        
    def extract_data(self, query: str) -> pd.DataFrame:
        with self.get_engine().connect() as connection:
            return pd.read_sql_query(text(query), connection)


class TargetDatabase(DatabaseConnection):
    def __init__(self, config: TargetDatabaseConfig):
        super().__init__(config.database_url)
        
    def ensure_schema_exists(self, schema_name: str) -> None:
        with self.get_engine().begin() as connection:
            connection.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{schema_name}"'))
            
    def load_data(
        self,
        dataframe: pd.DataFrame,
        table_name: str,
        schema: str,
        write_mode: str,
    ) -> None:
        dataframe.to_sql(
            name=table_name,
            con=self.get_engine(),
            schema=schema,
            if_exists=write_mode,
            index=False,
        )


def discover_sql_files(sql_dir: str) -> list[Path]:
    root = Path(sql_dir)
    if not root.is_absolute():
        project_root = Path(__file__).resolve().parent.parent
        root = project_root / root

    if not root.exists():
        raise FileNotFoundError(f"Diretorio de SQL nao encontrado: {root}")

    files = sorted(root.glob("*.sql"))
    if not files:
        raise FileNotFoundError(f"Nenhum arquivo .sql encontrado em: {root}")

    return files


def load_sql_file(path: Path) -> str:
    return path.read_text(encoding="utf-8").strip()


def normalize_table_name(file_name: str) -> str:
    normalized = re.sub(r"[^a-zA-Z0-9_]+", "_", file_name.strip().lower())
    normalized = re.sub(r"_+", "_", normalized).strip("_")
    if not normalized:
        raise ValueError("Nao foi possivel gerar um nome de tabela valido.")
    return normalized
