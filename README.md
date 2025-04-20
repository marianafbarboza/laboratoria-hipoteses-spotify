# laboratoria-hipoteses-spotify
Projeto realizado como parte do Bootcamp Jornada de Dados da Laboratória.

# Contexto do projeto
Uma gravadora enfrenta o desafio de lançar um novo artista no cenário musical global. Ela tem um extenso conjunto de dados do Spotify com informações sobre as músicas mais ouvidas no ano de 2023. A gravadora levantou uma série de hipóteses sobre o que faz uma música ser a mais ouvida. Essas hipóteses incluem:
 - Músicas com BPM (Batidas Por Minuto) mais altos fazem mais sucesso em termos de número de streams no Spotify;
 - As músicas mais populares no ranking do Spotify também possuem um comportamento semelhante em outras plataformas, como a Deezer;
 - A presença de uma música em um maior número de playlists está correlacionada com um maior número de streams;
 - Artistas com um maior número de músicas no Spotify têm mais streams;
 - As características da música influenciam o sucesso em termos de número de streams no Spotify;


# Conjunto de dados (dataset) analisado
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
 - inspotifyplaylists: Número de listas de reprodução do Spotify em que a música está incluída;
 - inspotifycharts: Presença e posição da música nas paradas do Spotify;
 - streams: Número total de streams no Spotify. Representa o número de vezes que a música foi ouvida;

 ### track_in_competition.csv
 Detalha o desempenho em outras plataformas (como Deezer ou Apple Music). Contém as colunas:
 - track_id: Identificador exclusivo da música. É um número inteiro de 7 dígitos que não se repete;
 - inappleplaylists: número de listas de reprodução da Apple Music em que a música está incluída;
 - inapplecharts: Presença e classificação da música nas paradas da Apple Music;
 - indeezerplaylists: Número de playlists do Deezer em que a música está incluída;
 - indeezercharts: Presença e posição da música nas paradas da Deezer;
 - inshazamcharts: Presença e classificação da música nas paradas da Shazam;

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



# Escopo da análise de dados
A presente análise consiste nas seguintes etapas:
 - Processar e preparar a base de dados;
 - Fazer uma análise exploratória;
 - Aplicar técnica de análise;
 - Resumir as informações em um dashboard ou relatório;
 - Apresentar os Resultados;
