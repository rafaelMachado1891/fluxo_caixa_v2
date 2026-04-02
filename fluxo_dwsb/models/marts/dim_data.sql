WITH mart_dim_date AS (
SELECT
    date_day AS data,
    month_of_year AS mes,
    month_name_short AS nome_mes,
    day_of_month AS dia,
    quarter_of_year AS trimestre,
    year_number AS ano,
    CONCAT((year_number:: TEXT || ' - '), month_of_year:: TEXT) AS ano_mes,
    week_of_year:: INTEGER AS semana_do_ano
FROM 
    {{ ref('int_dim_date') }}
)

SELECT * FROM mart_dim_date