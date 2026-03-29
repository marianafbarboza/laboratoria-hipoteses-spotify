-- HYPOTHESIS VALIDATION
-- Correlation analysis between variables

-- Correlation between playlists and streams
SELECT
    CORR(
        streams_limpo,
        in_spotify_playlists + in_apple_playlists + in_deezer_playlists
    ) AS corr_streams_playlists
FROM `projeto-spotify-457320.dadoshistoricos.view-tab-unica`;


-- Correlation between BPM and streams
SELECT
    CORR(bpm, streams_limpo) AS corr_bpm_streams
FROM `projeto-spotify-457320.dadoshistoricos.view-tab-unica`;


-- Correlation between musical features and streams
SELECT
    CORR(`danceability_%`, streams_limpo) AS corr_danceability,
    CORR(`valence_%`, streams_limpo) AS corr_valence,
    CORR(`energy_%`, streams_limpo) AS corr_energy
FROM `projeto-spotify-457320.dadoshistoricos.view-tab-unica`;


-- Correlation between platforms (Spotify vs Deezer)
SELECT
    CORR(in_spotify_charts, in_deezer_charts) AS corr_spotify_deezer
FROM `projeto-spotify-457320.dadoshistoricos.view-tab-unica`;


-- Correlation: number of tracks per artist vs total streams
WITH artist_stats AS (
    SELECT
        artist_name_limpo,
        COUNT(DISTINCT track_name_limpo) AS total_tracks,
        SUM(streams_limpo) AS total_streams
    FROM `projeto-spotify-457320.dadoshistoricos.view-tab-unica`
    GROUP BY artist_name_limpo
)

SELECT
    CORR(total_tracks, total_streams) AS corr_tracks_streams
FROM artist_stats;
