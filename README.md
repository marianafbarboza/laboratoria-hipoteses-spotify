[Projeto em andamento]
# Projeto hipoteses Spotify
Projeto realizado como parte do Bootcamp Jornada de Dados da Laboratória.

# Contexto e Objetivo da Análise
Uma gravadora enfrenta o desafio de lançar um novo artista no cenário musical global. Ela tem um extenso conjunto de dados do Spotify com informações sobre as músicas mais ouvidas no ano de 2023. A gravadora levantou uma série de hipóteses sobre o que faz uma música ser a mais ouvida. Essas hipóteses incluem:
 - Músicas com BPM (Batidas Por Minuto) mais altos fazem mais sucesso em termos de número de streams no Spotify;
 - As músicas mais populares no ranking do Spotify também possuem um comportamento semelhante em outras plataformas, como a Deezer;
 - A presença de uma música em um maior número de playlists está correlacionada com um maior número de streams;
 - Artistas com um maior número de músicas no Spotify têm mais streams;
 - As características da música influenciam o sucesso em termos de número de streams no Spotify;

Sendo assim, o objetivo é analisar a base de dados para refutar ou confirmar tais hipóteses e auxiliar a gravadora com insights e informações importantes a respeito das músicas mais ouvidas.

# Ferramentas e Tecnologias utilizadas
- BigQuery e Linguagem SQL;
- PowerBI;

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
A análise consiste no desenvolvimento das seguintes habilidades:
- Processamento e preparação dos dados;
- Análise Exploratória;
- Aplicação de técnicas de análise;
- Construção de Dashboards;
- Apresentação dos Resultados;

### Processamento e preparação dos dados
#### Valores Nulos
Como primeiro passo, foi realizada a identificação e tratamento de valores nulos encontrados. Nesse primeiro momento, optou-se por não excluir tais valores, uma vez que pode-se desconsiderá-los, caso necessário, com pequenas alterações nas consultas SQL realizadas.

#### Valores Duplicados
No segundo momento foi realizada a identificação de valores duplicados, foram encontrados 04 valores com track_name e track_id duplicados (com 02 registros cada). Para o tratamento destes dados, foram identificados, através do track_name, os track_ids das músicas duplicadas e realizou-se uma análise visual das informações de cada track_id. Foi verificado que há muitas informações divergentes das músicas duplicadas nas 03 tabelas, incluindo detalhes mais técnicos das mesmas. Sendo assim, considerou-se que a informação desses track_ids não é confiável e considerando que os 08 registros representam menos de 1% da amostra, foram considerados irrelevantes na presente análise e, portanto, excluídos através da utilização de `NOT IN` na nossa query:

```
SELECT
  *
FROM `projeto-spotify-457320.dadoshistoricos.spotify`
WHERE track_id NOT IN ('7173596', '5080031',
'5675634', '3814670', '1119309',
'4586215', '4967469', '8173823')
```

#### Dados considerados fora do Escopo da Análise
O escopo da análise envolve as hipóteses já detalhadas, sendo assim, optamos por manter a seguinte variável de cada tabela:
- TABELA SPOTIFY: track_id, track_name, artist_name, artist_count, released_year, released_month, released_day, in_spotify_playlists, in_spotify_charts, streams;
- TABELA COMPETITION: track_id, in_apple_playlists, in_apple_charts, in_deezer_playlists, in_deezer_charts;
A variável “in_shazam_charts” foi excluída pois não é uma plataforma tão utilizada para ouvir música, mas sim para identificar artista e música, em tempo real, sendo irrelevante para a presente análise.

- TABELA TECHNICAL_INFO: track_id, bpm, danceability_%, valence_%, energy_%; 
Considerando alguns estudos que apontam 03 variáveis mais relevantes no sucesso de uma música, optou-se por mantê-los, além de track_id e bpm.

#### Identificação e Tratamento de Dados Discrepantes
Identificou que as variáveis categóricas "track_name" e "artist_name" da tabela spotify possuíam caracteres especiais e letras maiúsculas, sendo assim, foram utilizadas as funções `REGEXUP_REPLACE` e `LOWER` para tratar estes casos.
- LOWER: converte todo o texto para letras minúsculas;
- REGEXP_REPLACE(..., '[^\\x00-\\x7F]', ' '): identifica e substitui qualquer caractere não-ASCII (letras com acento, emojis e símbolos especiais) por um espaço;
- REGEXP_REPLACE(..., '[^a-z0-9]', ' '): identifica e substitui qualquer coisa que não seja letra minúscula ou número por um espaço;

Além disso, na variável numérica "streams" da tabela Spotify também encontrou-se valores inválidos, pois o campo é do tipo `STRING` e há valores numéricos `INTEGER`. Para alterar o tipo de dado da variável, utilizamos a seguinte função:

```

SELECT
streams,
SAFE_CAST(streams AS INT64) AS streams_limpo
FROM `projeto-spotify-457320.dadoshistoricos.spotify`

```

#### Criação de Novas Variáveis
texto


### Fazer uma análise exploratória

### Aplicar técnica de análise

### Resumir as informações em um dashboard ou relatório

### Apresentar os Resultados
