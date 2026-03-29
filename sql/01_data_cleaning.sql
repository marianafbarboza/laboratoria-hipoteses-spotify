-- Objective: clean and standardize raw Spotify data
-- Description:
-- - Remove unreliable duplicated records
-- - Standardize text fields (track and artist names)
-- - Convert data types (streams)

-- 1. Remove duplicated / unreliable records
-- Identified duplicated track_ids with inconsistent data across tables.
-- These records represent <1% of the dataset and were excluded.

SELECT *
FROM `projeto-spotify-457320.dadoshistoricos.spotify`
WHERE track_id NOT IN (
    '7173596', '5080031', '5675634', '3814670',
    '1119309', '4586215', '4967469', '8173823'
);

-- 2. Standardize text fields
-- Goal: normalize track and artist names
-- - Convert to lowercase
-- - Remove non-ASCII characters
-- - Remove special characters

SELECT
    track_id,

    REGEXP_REPLACE(
        REGEXP_REPLACE(LOWER(track_name), '[^\\x00-\\x7F]', ' '),
        '[^a-z0-9]', ' '
    ) AS track_name_clean,

    REGEXP_REPLACE(
        REGEXP_REPLACE(LOWER(artist_name), '[^\\x00-\\x7F]', ' '),
        '[^a-z0-9]', ' '
    ) AS artist_name_clean

FROM `projeto-spotify-457320.dadoshistoricos.spotify`;


-- 3. Convert streams to numeric format
-- Issue: streams stored as STRING
-- Solution: convert to INT64 safely

SELECT
    streams,
    SAFE_CAST(streams AS INT64) AS streams_clean
FROM `projeto-spotify-457320.dadoshistoricos.spotify`;
