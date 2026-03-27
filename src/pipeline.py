from __future__ import annotations

import logging
from pathlib import Path

from dotenv import load_dotenv

try:
    from src.config import load_pipeline_config
    from src.utils import (
        SourceDatabase,
        TargetDatabase,
        discover_sql_files,
        load_sql_file,
        normalize_table_name,
    )
except ModuleNotFoundError:
    from config import load_pipeline_config
    from utils import (
        SourceDatabase,
        TargetDatabase,
        discover_sql_files,
        load_sql_file,
        normalize_table_name,
    )


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
)

logger = logging.getLogger(__name__)


def run_pipeline() -> None:
    project_root = Path(__file__).resolve().parent.parent
    load_dotenv(project_root / ".env")
    config = load_pipeline_config()

    logger.info("Iniciando pipeline EL")
    logger.info("Diretorio de SQL configurado: %s", config.sql_dir)

    source_db = SourceDatabase(config.source)
    target_db = TargetDatabase(config.target)

    target_db.ensure_schema_exists(config.raw_schema)
    sql_files = discover_sql_files(config.sql_dir)

    for sql_file in sql_files:
        query = load_sql_file(sql_file)
        table_name = normalize_table_name(Path(sql_file).stem)

        logger.info("Executando query: %s", sql_file.name)
        dataframe = source_db.extract_data(query)

        logger.info(
            "Carregando %s linhas na tabela %s.%s",
            len(dataframe),
            config.raw_schema,
            table_name,
        )
        target_db.load_data(
            dataframe=dataframe,
            table_name=table_name,
            schema=config.raw_schema,
            write_mode=config.write_mode,
        )

    logger.info("Pipeline finalizado com sucesso")


if __name__ == "__main__":
    run_pipeline()
