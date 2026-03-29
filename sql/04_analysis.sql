-- Understanding data distribution and segmentation

-- Quartile calculation for key variables
WITH quartiles AS (
    SELECT
        *,
        
        -- Streams
        PERCENTILE_CONT(streams_limpo, 0.25) OVER() AS q1_streams,
        PERCENTILE_CONT(streams_limpo, 0.50) OVER() AS q2_streams,
        PERCENTILE_CONT(streams_limpo, 0.75) OVER() AS q3_streams,

        -- BPM
        PERCENTILE_CONT(bpm, 0.25) OVER() AS q1_bpm,
        PERCENTILE_CONT(bpm, 0.50) OVER() AS q2_bpm,
        PERCENTILE_CONT(bpm, 0.75) OVER() AS q3_bpm,

        -- Danceability
        PERCENTILE_CONT(`danceability_%`, 0.25) OVER() AS q1_dance,
        PERCENTILE_CONT(`danceability_%`, 0.50) OVER() AS q2_dance,
        PERCENTILE_CONT(`danceability_%`, 0.75) OVER() AS q3_dance,

        -- Valence
        PERCENTILE_CONT(`valence_%`, 0.25) OVER() AS q1_valence,
        PERCENTILE_CONT(`valence_%`, 0.50) OVER() AS q2_valence,
        PERCENTILE_CONT(`valence_%`, 0.75) OVER() AS q3_valence,

        -- Energy
        PERCENTILE_CONT(`energy_%`, 0.25) OVER() AS q1_energy,
        PERCENTILE_CONT(`energy_%`, 0.50) OVER() AS q2_energy,
        PERCENTILE_CONT(`energy_%`, 0.75) OVER() AS q3_energy

    FROM `projeto-spotify-457320.dadoshistoricos.view-tab-unica`
),

-- Categorization
final AS (
    SELECT
        *,

        -- Streams category
        CASE
            WHEN streams_limpo <= q1_streams THEN 'Baixa Popularidade'
            WHEN streams_limpo <= q2_streams THEN 'Pouco Popular'
            WHEN streams_limpo <= q3_streams THEN 'Popular'
            ELSE 'Muito Popular'
        END AS streams_categoria,

        -- BPM category
        CASE
            WHEN bpm <= q1_bpm THEN 'Lento'
            WHEN bpm <= q2_bpm THEN 'Moderado'
            WHEN bpm <= q3_bpm THEN 'Rápido'
            ELSE 'Muito Rápido'
        END AS bpm_categoria,

        -- Danceability category
        CASE
            WHEN `danceability_%` <= q1_dance THEN 'Pouco Dançante'
            WHEN `danceability_%` <= q2_dance THEN 'Moderada'
            WHEN `danceability_%` <= q3_dance THEN 'Bem Dançante'
            ELSE 'Muito Dançante'
        END AS dance_categoria,

        -- Valence category
        CASE
            WHEN `valence_%` <= q1_valence THEN 'Muito Negativa'
            WHEN `valence_%` <= q2_valence THEN 'Levemente Negativa'
            WHEN `valence_%` <= q3_valence THEN 'Levemente Positiva'
            ELSE 'Muito Positiva'
        END AS valence_categoria,

        -- Energy category
        CASE
            WHEN `energy_%` <= q1_energy THEN 'Baixa Energia'
            WHEN `energy_%` <= q2_energy THEN 'Energia Moderada'
            WHEN `energy_%` <= q3_energy THEN 'Alta Energia'
            ELSE 'Energia Muito Alta'
        END AS energy_categoria

    FROM quartiles
)

SELECT *
FROM final;
