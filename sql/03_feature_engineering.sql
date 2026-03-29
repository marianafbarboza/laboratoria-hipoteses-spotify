-- Objective: create a unified dataset for analysis
-- Description:
-- - Create cleaned views for each table
-- - Join datasets into a single analytical table

-- 1. Cleaned Spotify View

CREATE OR REPLACE VIEW `projeto-spotify-457320.dadoshistoricos.view_spotify_clean` AS
SELECT
    track_id,
    artist_count,

    -- Clean text fields
    REGEXP_REPLACE(
        REGEXP_REPLACE(LOWER(track_name), '[^\\x00-\\x7F]', ' '),
        '[^a-z0-9]', ' '
    ) AS track_name_clean,

    REGEXP_REPLACE(
        REGEXP_REPLACE(LOWER(artist_name), '[^\\x00-\\x7F]', ' '),
        '[^a-z0-9]', ' '
    ) AS artist_name_clean,

    -- Release date
    PARSE_DATE(
        '%Y-%m-%d',
        FORMAT('%04d-%02d-%02d', released_year, released_month, released_day)
    ) AS release_date,

    in_spotify_playlists,
    in_spotify_charts,

    -- Clean streams
    SAFE_CAST(streams AS INT64) AS streams_clean

FROM `projeto-spotify-457320.dadoshistoricos.spotify`
WHERE track_id NOT IN (
    '7173596', '5080031', '5675634', '3814670',
    '1119309', '4586215', '4967469', '8173823', '4061483'
);


-- 2. Cleaned Competition View

CREATE OR REPLACE VIEW `projeto-spotify-457320.dadoshistoricos.view_competition_clean` AS
SELECT
    track_id,
    in_apple_playlists,
    in_apple_charts,
    in_deezer_playlists,
    in_deezer_charts
FROM `projeto-spotify-457320.dadoshistoricos.competition`
WHERE track_id NOT IN (
    '7173596', '5080031', '5675634', '3814670',
    '1119309', '4586215', '4967469', '8173823'
);


-- 3. Cleaned Technical Info View

CREATE OR REPLACE VIEW `projeto-spotify-457320.dadoshistoricos.view_technical_clean` AS
SELECT
    track_id,
    bpm,
    `danceability_%`,
    `valence_%`,
    `energy_%`
FROM `projeto-spotify-457320.dadoshistoricos.technical_info`
WHERE track_id NOT IN (
    '7173596', '5080031', '5675634', '3814670',
    '1119309', '4586215', '4967469', '8173823', '4061483'
);


-- 4. Final Unified Dataset
-- Combine all cleaned datasets into a single table for analysis

CREATE OR REPLACE VIEW `projeto-spotify-457320.dadoshistoricos.view_final_dataset` AS
SELECT
    -- Spotify
    s.track_id,
    s.track_name_clean,
    s.artist_name_clean,
    s.artist_count,
    s.release_date,
    s.in_spotify_playlists,
    s.in_spotify_charts,
    s.streams_clean,

    -- Competition
    c.in_apple_playlists,
    c.in_apple_charts,
    c.in_deezer_playlists,
    c.in_deezer_charts,

    -- Technical
    t.bpm,
    t.`danceability_%`,
    t.`valence_%`,
    t.`energy_%`

FROM `projeto-spotify-457320.dadoshistoricos.view_spotify_clean` s
LEFT JOIN `projeto-spotify-457320.dadoshistoricos.view_competition_clean` c
    ON s.track_id = c.track_id
LEFT JOIN `projeto-spotify-457320.dadoshistoricos.view_technical_clean` t
    ON s.track_id = t.track_id;
