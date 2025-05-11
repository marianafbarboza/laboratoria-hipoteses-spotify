[Projeto em andamento]
# Projeto hipoteses Spotify
Projeto realizado como parte do Bootcamp Jornada de Dados da Laboratória.


# 1. Contexto e Objetivo da Análise
Uma gravadora enfrenta o desafio de lançar um novo artista no cenário musical global. Ela tem um extenso conjunto de dados do Spotify com informações sobre as músicas mais ouvidas no ano de 2023. A gravadora levantou uma série de hipóteses sobre o que faz uma música ser a mais ouvida. Essas hipóteses incluem:
 - Músicas com BPM (Batidas Por Minuto) mais altos fazem mais sucesso em termos de número de streams no Spotify;
 - As músicas mais populares no ranking do Spotify também possuem um comportamento semelhante em outras plataformas, como a Deezer;
 - A presença de uma música em um maior número de playlists está correlacionada com um maior número de streams;
 - Artistas com um maior número de músicas no Spotify têm mais streams;
 - As características da música influenciam o sucesso em termos de número de streams no Spotify;

Sendo assim, o objetivo é analisar a base de dados para refutar ou confirmar tais hipóteses e auxiliar a gravadora com insights e informações importantes a respeito das músicas mais ouvidas.


# 2. Ferramentas e Tecnologias utilizadas
- BigQuery e Linguagem SQL;
- PowerBI;
- Python;


# 3. Conjunto de dados (dataset) analisado
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
 - in_spotif_yplaylists: Número de listas de reprodução do Spotify em que a música está incluída;
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


# 4. Escopo da análise de dados
A análise consiste no desenvolvimento das seguintes habilidades:
- Processamento e preparação dos dados;
- Análise Exploratória;
- Aplicação de técnicas de análise;
- Construção de Dashboards;
- Apresentação dos Resultados;


### 4.1 Processamento e preparação dos dados
#### 4.1.1 Importação de Dados
Como primeiro passo, foi realizada a identificação e tratamento de valores nulos encontrados. Nesse primeiro momento, optou-se por não excluir tais valores, uma vez que pode-se desconsiderá-los, caso necessário, com pequenas alterações nas consultas SQL realizadas.


#### 4.1.2 Valores Nulos
Como primeiro passo, utilizando a função `SELECT COUNT (*)` foi realizada a identificação e tratamento de valores nulos, sendo encontrados os seguintes, em cada tabela:
- Tabela competition: total de 953 registros, in_shazam_charts (50 nulos);
- Tabela spotify: total de 953 registros, não encontrei nulos;
- Tabela technical_info: 953 registros, key (95 nulos);

Nesse primeiro momento, optou-se por não excluir tais valores, uma vez que pode-se desconsiderá-los, caso necessário, com pequenas alterações nas consultas SQL realizadas.


#### 4.1.3 Valores Duplicados
No segundo momento foi realizada a identificação de valores duplicados, foram encontrados 04 valores com track_name e track_id duplicados (com 02 registros cada):

|      track_name      |      artist_name      |  contagem  |
|----------------------|-----------------------|------------|
| SNAP                 | Rosa Linn             | 2          |
| About Damn Time      | Lizzo                 | 2          |
| Take My Breath       | The Weeknd            | 2          |
| SPIT IN MY FACE!     | ThxSoMch              | 2          |


Para o tratamento destes dados, foram identificados, através do track_name, os track_ids das músicas duplicadas e realizou-se uma análise visual das informações de cada track_id. Foi verificado que há muitas informações divergentes das músicas duplicadas nas 03 tabelas, incluindo detalhes mais técnicos das mesmas. Sendo assim, considerou-se que a informação desses track_ids não é confiável e considerando que os 08 registros representam menos de 1% da amostra, foram considerados irrelevantes na presente análise e, portanto, excluídos através da utilização de `NOT IN` na nossa query:

```
SELECT
  *

FROM `projeto-spotify-457320.dadoshistoricos.spotify`

WHERE
  track_id NOT IN ('7173596', '5080031', '5675634', '3814670',
'1119309', '4586215', '4967469', '8173823')
```


#### 4.1.4 Dados fora do Escopo da Análise
O escopo da análise envolve as hipóteses já detalhadas, sendo assim, optamos por manter a seguinte variável de cada tabela:
- Tabela spotify: track_id, track_name, artist_name, artist_count, released_year, released_month, released_day, in_spotify_playlists, in_spotify_charts, streams;

- Tabela competition: track_id, in_apple_playlists, in_apple_charts, in_deezer_playlists, in_deezer_charts;
A variável “in_shazam_charts” foi excluída pois não é uma plataforma tão utilizada para ouvir música, mas sim para identificar artista e música, em tempo real, sendo irrelevante para a presente análise.

- Tabela technical_info: track_id, bpm, danceability_%, valence_%, energy_%; 
Considerando alguns estudos que apontam 03 variáveis mais relevantes no sucesso de uma música, optou-se por mantê-los, além de track_id e bpm.


#### 4.1.5 Identificação e Tratamento de Dados Discrepantes
Identificou-se que as variáveis categóricas "track_name" e "artist_name" da tabela spotify possuem caracteres especiais e letras maiúsculas, sendo assim, foram utilizadas as funções `REGEXUP_REPLACE` e `LOWER` para tratar estes casos.
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
Neste ponto do projeto, optou-se pela criação de uma nova variável "data_de_lançamento", concatenando as variáveis: released_year, released_month, released_day. Além disso, as mesmas estavam definidas como do tipo `INTEGER` e para concatenar, deve-se utilizar o formato `STRING`. 
Para tal, foi utilizada a função `PARSE_DATE` que transforma a string formatada no tipo `DATE`, e o `FORMAT` para deixar utilizar o formato YYYY-MM-DD:

```
SELECT released_year, released_month, released_day

PARSE_DATE('%Y-%m-%d', FORMAT('%04d-%02d-%02d', released_year, released_month, released_day)) AS data_de_lancamento

FROM `projeto-spotify-457320.dadoshistoricos.spotify`

```


#### 4.1.7 Unir tabelas
A fim de criar uma tabela única, para facilitar a análise dos dados, criou-se Views com os dados "limpos" de todas as tabelas. Considerando aqui, a vantagem de não armazenar os dados, apenas salvar a consulta, sendo mais rápido de executar e tendo um menor custo para armazenamento.
As views de cada tabela foram construídas por meio de consulta SQL, da seguinte maneira

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


### 4.2 Análise exploratória
Por se tratar de uma fase fundamental na compreensão de dados, foram utilizados BigQuery e Power BI, conjuntamente, nessa etapa. O Power BI agrega muito na visualização de dados, criação de dashboards interativos e gráficos dinâmicos, o que facilita a exploração e compreensão dos dados.
Já o BigQuery, ferramenta voltada para armazenamento e análise de dados, possibilita lidar com um grande volume de dados, com alto desempenho, fornecendo através das consultas, informações valiosas sobre o conjunto de dados.
A ideia de combinar BigQuery e Power BI é exatamente extrair e transformar dados, para na sequência visualizar e explorar os mesmos com profundidade. Permitindo desvendar insights significativos, identificar relacionamentos entre variáveis e possibilitar uma melhor tomada de decisão. 

#### 4.2.1 Variáveis Categóricas
Nessa fase do projeto foram construídas algumas tabelas no Power BI, destacando algumas variáveis categóricas, para realizar uma primeira análise exploratória, analisando, por exemplo:
- músicas e sua presença em playlists do spotify, assim como número total de streams;
- artista, quantidade de músicas na base de dados e soma total de streams;
- número de músicas por artista, ordenadas de forma decrescente;

A partir destas informações foram construídos gráficos para uma melhor visualização:
Analisando, por exemplo, os tops 10 artistas em playlists do Spotify, Deezer e Apple:

![barras1](https://github.com/user-attachments/assets/9e30784a-0a1b-4458-8018-eedea83ca502)


Assim como, o total de streams por artista (top 10):

![barras2](https://github.com/user-attachments/assets/362dba14-b408-4e28-954d-19629e157790)


E o total de músicas lançadas mensalmente, no período analisado:

![barras3](https://github.com/user-attachments/assets/43515ffe-40d5-47cf-90c2-2dedc7d53117)


#### 4.2.2 Medidas de Tendência Central
Para compreender melhor o conjunto de dados, calculou-se médias e medianas das variáveis BPM e streams. Quanto a BPM, pode-se observar que sua média e mediana, na amostra analisada, apresentam valores bastante próximos:

|      soma_BPM        |      media_BPM      |  mediana_BPM  |
|----------------------|---------------------|---------------|
| 115491               | 122,47              | 121,00        |


Já para a variável streams, média e mediana possuem valores muito distintos:

|      soma_streams    |      media_streams      |  mediana_streams  |
|----------------------|-------------------------|-------------------|
| 485404921248         | 512400128,44            | 287239934         |


#### 4.2.3 Distribuição dos dados através de histograma
Como os gráficos de histograma não estão disponíveis no pacote normal do Power BI, realizamos a instalação de Python, afim de utilizar as histogramas para uma visualização mais robusta da distribuição de nossa amostra em alguns aspectos, como streams, BPM e presença em playlist do Spotify.
Para gerar os histogramas utilizando Python, inserimos o seguinte código:

```
import matplotlib.pyplot as plt
import pandas as pd

# Obtenha os dados do Power BI - você só preciso alterar essas informações de todo o code
data = dataset[['variável']]

# Crie o histogram
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


### Aplicar técnica de análise

### Resumir as informações em um dashboard ou relatório

### Apresentar os Resultados
