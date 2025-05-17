# Detalhamento de consultas utilizadas no Projeto

Aqui estão descritas algumas das queries utilizadas ao longo do projeto, para processamento e preparação dos dados.
Os títulos fazem referência as etapas disponíveis no [README.md](README.md), para melhor identificação do processo realizado.

#### Valores Duplicados
Para o tratamento dos valores duplicados, foram identificados, através do track_name, os track_ids das músicas duplicadas e realizou-se uma análise visual das informações de cada track_id. Foi verificado que há muitas informações divergentes das músicas duplicadas nas 03 tabelas, incluindo detalhes mais técnicos das mesmas. Sendo assim, considerou-se que a informação desses track_ids não é confiável e considerando que os 08 registros representam menos de 1% da amostra, foram considerados irrelevantes na presente análise e, portanto, excluídos através da utilização de `NOT IN` na nossa query:

```
SELECT
  *

FROM `projeto-spotify-457320.dadoshistoricos.spotify`

WHERE
  track_id NOT IN ('7173596', '5080031', '5675634', '3814670',
'1119309', '4586215', '4967469', '8173823')
```

#### Identificação e Tratamento de Dados Discrepantes
Para trataento de caracteres especiais foram utilizadas as funções `REGEXUP_REPLACE` e `LOWER` para tratar estes casos. 
- LOWER: converte todo o texto para letras minúsculas;
- REGEXP_REPLACE(..., '[^\\x00-\\x7F]', ' '): identifica e substitui qualquer caractere não-ASCII (letras com acento, emojis e símbolos especiais) por um espaço;
- REGEXP_REPLACE(..., '[^a-z0-9]', ' '): identifica e substitui qualquer coisa que não seja letra minúscula ou número por um espaço;

Além disso, na variável numérica "streams" da tabela Spotify também encontrou-se valores inválidos, pois a variável está definida como tipo `STRING` e, por tratar-se de valores numéricos, deveria ser `INTEGER`. Sendo assim, optou-se por alterar o tipo de dado da variável, utilizando a seguinte função:

```
SELECT streams,

SAFE_CAST(streams AS INT64) AS streams_limpo

FROM `projeto-spotify-457320.dadoshistoricos.spotify`
.sql
```

#### Criação de Novas Variáveis
Além da adição de uma nova variável (data_de_lançaento), as variáveis de data estavam definidas como do tipo `INTEGER` e para concatenar, deve-se utilizar o formato `STRING`. 
Para tal, foi utilizada a função `PARSE_DATE` que transforma a string formatada no tipo `DATE`, e o `FORMAT` para deixar utilizar o formato YYYY-MM-DD:

```
SELECT released_year, released_month, released_day

PARSE_DATE('%Y-%m-%d', FORMAT('%04d-%02d-%02d', released_year, released_month, released_day)) AS data_de_lancamento

FROM `projeto-spotify-457320.dadoshistoricos.spotify`

```

#### Unir tabelas
As views de cada tabela foram construídas por meio de consulta SQL, da seguinte maneira:

```
--VIEW COMPETITION

SELECT
  * EXCEPT (in_shazam_charts)
FROM
  `projeto-spotify-457320.dadoshistoricos.competition`
WHERE
  track_id NOT IN ('7173596', '5080031', '5675634', '3814670',
'1119309', '4586215', '4967469', '8173823')


--VIEW TECHNICAL INFO

SELECT
  track_id, bpm, `danceability_%`, `valence_%`, `energy_%`
FROM
  `projeto-spotify-457320.dadoshistoricos.technical_info`
WHERE
  track_id NOT IN ('7173596', '5080031',     '5675634','3814670',
'1119309', '4586215','4967469','8173823', '4061483')


--VIEW-SPOTIFY

SELECT
  track_id, artist_count,

--limpeza de variáveis track name e artist name
  REGEXP_REPLACE( REGEXP_REPLACE(LOWER(track_name), '[^\\x00-\\x7F]', ' '), '[^a-z0-9]', ' ' ) AS track_name_limpo,
  REGEXP_REPLACE(REGEXP_REPLACE(LOWER(artist_name), '[^\\x00-\\x7F]', ' '),'[^a-z0-9]', ' ' ) AS artist_name_limpo,

--data de lancamento (YYYY-MM-DD)
PARSE_DATE('%Y-%m-%d', FORMAT('%04d-%02d-%02d', released_year, released_month, released_day)) AS data_de_lancamento,

in_spotify_playlists, in_spotify_charts,

--tratamento de streams como INTEGER
  SAFE_CAST(streams AS INT64) AS streams_limpo
FROM
  `projeto-spotify-457320.dadoshistoricos.spotify`

WHERE
track_id NOT IN ('7173596', '5080031', '5675634', '3814670',
 '1119309', '4586215', '4967469', '8173823', '4061483')

```

Agora com as views já filtrando os dados de interesse da análise, utilizou-se a função `LEFT JOIN` para unir as tabelas. Foram considerados os prefixos ".c", ".t" e ".s" para evitar ambiguidade se mais de uma tabela tiver uma coluna com o mesmo nome (track_id, por ex), facilitando a identificação das tabelas.
Consulta utilizada para unir as tabelas

```
SELECT
--variáveis tabela spotify
  s.track_id,
  s.track_name_limpo,
  s.artist_name_limpo,
  s.artist_count,
  s.data_de_lancamento,
  s.in_spotify_playlists,
  s.in_spotify_charts,
  s.streams_limpo,

  --variáveis tabela competition
  c.in_apple_playlists,
  c.in_apple_charts,
  c.in_deezer_playlists,
  c.in_deezer_charts,
 
  --variaveis tabela technical_info
  t.bpm,
  t.`danceability_%`,
  t.`valence_%`,
  t.`energy_%`
FROM
  `projeto-spotify-457320.dadoshistoricos.view-spotify` AS s
LEFT JOIN `projeto-spotify-457320.dadoshistoricos.view-competition` AS c
  ON s.track_id = c.track_id
LEFT JOIN `projeto-spotify-457320.dadoshistoricos.view-technical-info` AS t
  ON s.track_id = t.track_id

```

#### Distribuição dos dados através de histograma
Para gerar os histogramas utilizando Python, inserimos o seguinte código:

```
import matplotlib.pyplot as plt
import pandas as pd

# Obtenha os dados do Power BI - você só preciso alterar essas informações de todo o code
data = dataset[['variável']]

# Crie o histograma
plt.hist(data, bins=10, color='blue', alpha=0.7)
plt.xlabel('Value' )
plt.ylabel('Frequency')
plt .title('Histogram')

# Mostre o histogram
plt.show()

```

Para analisar as diferentes variáveis, basta substituir o campo 'variável' pelo que deseja analisar.
Aqui foram analisadas as variáveis streams, bpm, in_spotify_playlists e in_spotify_charts:


![histograma1](https://github.com/user-attachments/assets/ebac27a8-c1d3-49d7-84cf-2f6875f6d364)


![histograma2](https://github.com/user-attachments/assets/e91c573a-f2da-4c76-8607-5d0cba51015b)


#### Análise da amostra em quartis
A consulta utilizada para categorização:

```

WITH
  Quartis AS (
  SELECT
    *,

   PERCENTILE_CONT(streams_limpo, 0.25) OVER() AS q1_streams,
   PERCENTILE_CONT(streams_limpo, 0.50) OVER() AS q2_streams,
   PERCENTILE_CONT(streams_limpo, 0.75) OVER() AS q3_streams,

   PERCENTILE_CONT(bpm, 0.25) OVER() AS q1_bpm,
   PERCENTILE_CONT(bpm, 0.50) OVER() AS q2_bpm,
   PERCENTILE_CONT(bpm, 0.75) OVER() AS q3_bpm,
   
   PERCENTILE_CONT(`danceability_%`, 0.25) OVER() AS q1_dance,
   PERCENTILE_CONT(`danceability_%`, 0.50) OVER() AS q2_dance,
   PERCENTILE_CONT(`danceability_%`, 0.75) OVER() AS q3_dance,

   PERCENTILE_CONT(`valence_%`, 0.25) OVER() AS q1_valence,
   PERCENTILE_CONT(`valence_%`, 0.50) OVER() AS q2_valence,
   PERCENTILE_CONT(`valence_%`, 0.75) OVER() AS q3_valence,

   PERCENTILE_CONT(`energy_%`, 0.25) OVER() AS q1_energy,
   PERCENTILE_CONT(`energy_%`, 0.50) OVER() AS q2_energy,
   PERCENTILE_CONT(`energy_%`, 0.75) OVER() AS q3_energy
   
 
  FROM
    `projeto-spotify-457320.dadoshistoricos.view-tab-unica` ),

  final AS (
  SELECT
  *,
  -- streams categorias
    CASE
      WHEN streams_limpo <= q1_streams THEN 'Baixa Popularidade'
      WHEN streams_limpo <= q2_streams THEN 'Pouco Popular'
      WHEN streams_limpo <= q3_streams THEN 'Popular'
      ELSE 'Muito Popular'
    END AS streams_categoria,

  -- BPM categorias
    CASE
      WHEN bpm <= q1_bpm THEN 'Lento'
      WHEN bpm <= q2_bpm THEN 'Moderado'
      WHEN bpm <= q3_bpm THEN 'Rápido'
      ELSE 'Muito rápido'
    END AS bpm_categoria,

  -- Danceability categorias
    CASE
      WHEN `danceability_%` <= q1_dance THEN 'Pouco dançante'
      WHEN `danceability_%` <= q2_dance THEN 'Moderada'
      WHEN `danceability_%` <= q3_dance THEN 'Bem dançante'
      ELSE 'Muito dançante'
    END AS dance_categoria,

  -- Valence categorias
    CASE
      WHEN `valence_%` <= q1_valence THEN 'Muito Negativa'
      WHEN `valence_%` <= q2_valence THEN 'Levemente Negativa'
      WHEN `valence_%` <= q3_valence THEN 'Levemente Positiva'
      ELSE 'Muito Positiva'
    END AS valence_categoria,

  -- Energy categorias
    CASE
      WHEN `energy_%` <= q1_energy THEN 'Baixa Energia'
      WHEN `energy_%` <= q2_energy THEN 'Energia Moderada'
      WHEN `energy_%` <= q3_energy THEN 'Alta Energia'
      ELSE 'Energia Muito Alta'
    END AS energy_categoria

  FROM Quartis
)

SELECT * FROM final;

```


#### Correlação entre variáveis
A análise foi realizada através da seguinte consulta:

```

SELECT
CORR(streams_limpo,in_spotify_playlists+in_apple_playlists+in_deezer_playlists) AS correlacao_streams_playlists,
CORR(bpm, streams_limpo) AS correlacao_bpm_streams,
CORR(`danceability_%`, streams_limpo) AS correlacao_danceability_streams,
CORR(`valence_%`, streams_limpo) AS correlacao_valence_streams,
CORR(`energy_%`, streams_limpo) AS correlacao_energy_streams,
CORR(in_spotify_charts, in_deezer_charts) AS correlacao_spotify_deezer,
FROM `projeto-spotify-457320.dadoshistoricos.view-tab-auxiliar`

```

Para verificar a correlação de total de músicas por artista x streams, foi utilizado o cálculo em um tabela auxiliar:

```

WITH
  artistas_stats AS (
  SELECT
    artist_name_limpo,
    COUNT(DISTINCT track_name_limpo) AS num_faixas,
    SUM(streams_limpo) AS total_streams
  FROM
    `projeto-spotify-457320.dadoshistoricos.view-tab-auxiliar`
  GROUP BY
    artist_name_limpo )
SELECT
  CORR(artistas_stats.num_faixas, artistas_stats.total_streams) AS correlacao_faixas_streams
FROM
  artistas_stats

```

##### Segmentação
A análise da Hipótese 4, envolveu a criação de uma view auxiliar, contando o número total de faixas, agrupado por artista e só então, realizado o cálculo de correlação, considerando o total de faixas por artista e o total de streams.

```

WITH
  artistas_stats AS (
  SELECT
    artist_name_limpo,
    COUNT(DISTINCT track_name_limpo) AS num_faixas,
    SUM(streams_limpo) AS total_streams
  FROM
    `projeto-spotify-457320.dadoshistoricos.view-tab-auxiliar`
  GROUP BY
    artist_name_limpo )
SELECT
  CORR(artistas_stats.num_faixas, artistas_stats.total_streams) AS correlacao_faixas_streams
FROM
  artistas_stats

```

Para realizar o gráfico de dispersão e correlacionar o número de músicas agrupado por um artista, e relacionar com o número de streams, realizou-se a criação de uma tabela Agregada no Power BI, com a seguinte fórmula DAX:

```

ArtistaResumo =
ADDCOLUMNS(
    SUMMARIZE('view-tab-auxiliar','view-tab-auxiliar'[artist_name_limpo]),
    "NumFaixas", COUNTROWS(FILTER('view-tab-auxiliar','view-tab-auxiliar'[artist_name_limpo] = EARLIER('view-tab-auxiliar'[artist_name_limpo]))),
    "TotalStreams", CALCULATE(SUM('view-tab-auxiliar'[streams_limpo])))

```

O processo basicamente cria uma nova tabela com três colunas, para resumir os dados por artista. O passo a passo consiste basicamente em:
SUMMARIZE - gera uma lista única de artistas;
ADDCOLUMNS - adiciona as colunas agregadas;
COUNTROWS(FILTER) - vai realizar a contagem de linhas por artista;
CALCULATE(SUM) - soma o total de streams por artista;

