-- Objective: create new variables to support analysis
-- Description:
-- - Create standardized release date
-- - Prepare derived features for analysis

-- 1. Create release date (YYYY-MM-DD)
-- Original fields are stored as integers (year, month, day)
-- We convert them into a proper DATE format

SELECT
    track_id,
    released_year,
    released_month,
    released_day,

    PARSE_DATE(
        '%Y-%m-%d',
        FORMAT('%04d-%02d-%02d', released_year, released_month, released_day)
    ) AS release_date

FROM `projeto-spotify-457320.dadoshistoricos.spotify`;


-- 2. Create total playlists (cross-platform)
-- Combine playlists from Spotify, Deezer and Apple Music

SELECT
    s.track_id,

    s.in_spotify_playlists,
    c.in_apple_playlists,
    c.in_deezer_playlists,

    (s.in_spotify_playlists
     + c.in_apple_playlists
     + c.in_deezer_playlists) AS total_playlists

FROM `projeto-spotify-457320.dadoshistoricos.spotify` s
LEFT JOIN `projeto-spotify-457320.dadoshistoricos.competition` c
    ON s.track_id = c.track_id;


-- 3. Prepare cleaned streams for analysis
-- Ensure streams are numeric and usable in aggregations

SELECT
    track_id,
    SAFE_CAST(streams AS INT64) AS streams_clean
FROM `projeto-spotify-457320.dadoshistoricos.spotify`;
