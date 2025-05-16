Aqui estão descritas algumas das queries utilizadas ao longo do projeto, para processamento e preparação dos dados.
Os títulos fazem referência as etapas disponíveis no README.md, para melhor identificação do processo realizado.

#### 4.1.3 Valores Duplicados
Para o tratamento dos valores duplicados, foram identificados, através do track_name, os track_ids das músicas duplicadas e realizou-se uma análise visual das informações de cada track_id. Foi verificado que há muitas informações divergentes das músicas duplicadas nas 03 tabelas, incluindo detalhes mais técnicos das mesmas. Sendo assim, considerou-se que a informação desses track_ids não é confiável e considerando que os 08 registros representam menos de 1% da amostra, foram considerados irrelevantes na presente análise e, portanto, excluídos através da utilização de `NOT IN` na nossa query:

```
SELECT
  *

FROM `projeto-spotify-457320.dadoshistoricos.spotify`

WHERE
  track_id NOT IN ('7173596', '5080031', '5675634', '3814670',
'1119309', '4586215', '4967469', '8173823')
```

#### 4.1.5 Identificação e Tratamento de Dados Discrepantes
Para trataento de caracteres especiais foram utilizadas as funções `REGEXUP_REPLACE` e `LOWER` para tratar estes casos. 
- LOWER: converte todo o texto para letras minúsculas;
- REGEXP_REPLACE(..., '[^\\x00-\\x7F]', ' '): identifica e substitui qualquer caractere não-ASCII (letras com acento, emojis e símbolos especiais) por um espaço;
- REGEXP_REPLACE(..., '[^a-z0-9]', ' '): identifica e substitui qualquer coisa que não seja letra minúscula ou número por um espaço;

Além disso, na variável numérica "streams" da tabela Spotify também encontrou-se valores inválidos, pois a variável está definida como tipo `STRING` e, por tratar-se de valores numéricos, deveria ser `INTEGER`. Sendo assim, optou-se por alterar o tipo de dado da variável, utilizando a seguinte função:

```
SELECT streams,

SAFE_CAST(streams AS INT64) AS streams_limpo

FROM `projeto-spotify-457320.dadoshistoricos.spotify`
```

#### 4.1.6 Criação de Novas Variáveis
Além da adição de uma nova variável (data_de_lançaento), as variáveis de data estavam definidas como do tipo `INTEGER` e para concatenar, deve-se utilizar o formato `STRING`. 
Para tal, foi utilizada a função `PARSE_DATE` que transforma a string formatada no tipo `DATE`, e o `FORMAT` para deixar utilizar o formato YYYY-MM-DD:

```
SELECT released_year, released_month, released_day

PARSE_DATE('%Y-%m-%d', FORMAT('%04d-%02d-%02d', released_year, released_month, released_day)) AS data_de_lancamento

FROM `projeto-spotify-457320.dadoshistoricos.spotify`

```

#### 4.1.7 Unir tabelas
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


