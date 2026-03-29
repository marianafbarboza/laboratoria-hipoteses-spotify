## Dataset
O conjunto de dados está disponível no arquivo *spotify_2023.zip* e é composto por três tabelas principais:

---

### track_in_spotify
Contém informações sobre o desempenho das músicas no Spotify.

| Coluna | Descrição |
|--------|----------|
| track_id | Identificador único da música |
| track_name | Nome da música |
| artist(s)_name | Nome do(s) artista(s) |
| artist_count | Número de artistas envolvidos |
| released_year | Ano de lançamento |
| released_month | Mês de lançamento |
| released_day | Dia de lançamento |
| in_spotify_playlists | Número de playlists no Spotify |
| in_spotify_charts | Presença/posição nos charts do Spotify |
| streams | Número total de execuções |

---

### track_in_competition
Contém dados de desempenho em outras plataformas.

| Coluna | Descrição |
|--------|----------|
| track_id | Identificador único da música |
| in_apple_playlists | Playlists na Apple Music |
| in_apple_charts | Charts da Apple Music |
| in_deezer_playlists | Playlists no Deezer |
| in_deezer_charts | Charts do Deezer |
| in_shazam_charts | Charts do Shazam |

---

### track_technical_info
Contém características técnicas das músicas.

| Coluna | Descrição |
|--------|----------|
| track_id | Identificador único da música |
| bpm | Batidas por minuto |
| key | Tom musical |
| mode | Modo (maior/menor) |
| danceability_% | Nível de dançabilidade |
| valence_% | Positividade da música |
| energy_% | Nível de energia |
| acousticness_% | Grau de acústica |
| instrumentality_% | Presença instrumental |
| liveness_% | Presença de performance ao vivo |
| speechiness_% | Presença de fala |


As tabelas podem ser relacionadas através da coluna `track_id`, que funciona como chave primária em todas elas.

