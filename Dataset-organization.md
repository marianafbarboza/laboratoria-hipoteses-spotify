O conjunto de dados está disponível no arquivo *spotify_2023.zip* deste projeto, que contém três arquivos CSV:

 ### track_in_spotify.csv
 Esse arquivo detalha a performance de cada música no Spotify. E contém as seguintes colunas:
 - track_id: Identificador exclusivo da música. É um número inteiro de 7 dígitos que não se repete;
 - track_name: Nome da música;
 - artist(s)_name: Nome do(s) artista(s) da música;
 - artist_count: Número de artistas que contribuíram na música;
 - released_year: Ano em que a música foi lançada;
 - released_month: Mês em que a música foi lançada;
 - released_day: Dia do mês em que a música foi lançada;
 - in_spotify_playlists: Número de listas de reprodução do Spotify em que a música está incluída;
 - in_spotify_charts: Presença e posição da música nas paradas do Spotify;
 - streams: Número total de streams no Spotify. Representa o número de vezes que a música foi ouvida;

 ### track_in_competition.csv
 Detalha o desempenho em outras plataformas (como Deezer ou Apple Music). Contém as colunas:
 - track_id: Identificador exclusivo da música. É um número inteiro de 7 dígitos que não se repete;
 - in_apple_playlists: número de listas de reprodução da Apple Music em que a música está incluída;
 - in_apple_charts: Presença e classificação da música nas paradas da Apple Music;
 - in_deezer_playlists: Número de playlists do Deezer em que a música está incluída;
 - in_deezer_charts: Presença e posição da música nas paradas da Deezer;
 - in_shazam_charts: Presença e classificação da música nas paradas da Shazam;

 ### track_technical_info.csv
 Traz as características das músicas, detalhando:
 - track_id: Identificador exclusivo da música. É um número inteiro de 7 dígitos que não se repete;
 - bpm: Batidas por minuto, uma medida do tempo da música;
 - key: Tom musical da música;
 - mode: Modo de música (maior ou menor);
 - danceability_%: Porcentagem que indica o quão apropriado a canção é para dançar;
 - valence_%: Positividade do conteúdo musical da música;
 - energy_%: Nível de energia percebido da música;
 - acusticness_%: Quantidade de som acústico na música;
 - instrumentality_%: Quantidade de conteúdo instrumental na música;
 - liveness_%: Presença de elementos de performance ao vivo;
 - speechiness_%: Quantidade de palavras faladas na música;

