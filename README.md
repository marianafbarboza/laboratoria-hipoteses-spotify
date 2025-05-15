[Projeto em andamento]
# Projeto Hipóteses do Spotify


# 1. Contexto e Objetivo da Análise
Uma gravadora enfrenta o desafio de lançar um novo artista no cenário musical global. Ela tem um extenso conjunto de dados do Spotify com informações sobre as músicas lançadas de 1930 a 2023.  
A gravadora levantou uma série de hipóteses sobre o que faz uma música ser a mais ouvida. Essas hipóteses incluem:  
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


#### 4.2.4 Medidas de Dispersão
Optou-se por analisar o desvio padrão das mesmas variáveis analisadas nos passos anteriores: BPM e streams.
|      desvio_padrao_BPM        |      desvio_padrao_streams      |
|-------------------------------|---------------------------------|
| 28,05                         | 568568151,36                    | 

O desvio padrão de BPM possui um valor considerado baixo, demonstrando que a amostra possui muitos valores próximos a média, portanto, com menor variação dos valores. Informação confirmada ao analisar o histograma já apresentado.
Quanto ao desvio padrão de streams, o mesmo possui um valor alto, demonstrando dados mais dispersos, e relação a média. E, portanto, maior variação dos mesmos, como evidenciado no histograma em que observa-se algumas faixas com frequência bem alta e outras, quase inexistentes.


#### 4.2.5 Comportamento de variáveis ao longo do tempo
Neste ponto, as variáveis streams e quantidade de músicas lançadas foram analisadas, quanto ao seu comportamento ao longo do tempo. As análises foram realizadas considerando os valores mensais, do período analisado:

![mes](https://github.com/user-attachments/assets/9d82ede3-bcfd-4173-a983-8cb58d47258d)


Assim como, anuais:
![ano](https://github.com/user-attachments/assets/61bdfcff-4b00-4f77-b0bb-10770e6f5375)


#### 4.2.6 Análise da amostra em quartis
Utilizamos o BigQuery para calcular os quartis, considerando as variáveis: streams, bpm, dançabilidade, valência e energia, compilados e categorizados na seguinte consulta:

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

#### 4.2.7 Correlação entre variáveis
Realizamos a correlação entre as seguintes variáveis:
- streams e total de playlists;
- bpm e streams;
- dançabilidade e streams;
- valência e streams;
- energia e streams;
- presença da música nas paradas do Spotify e do Deezer;

Através de uma consulta no BigQuery:
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

Para verificar a correlação de total de músicas por artista x streams, realizamos o cálculo em um tabela auxiliar:

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

Para analisar tais valores, consideramos o conceito de correlação de Pearson, e a seguinte escala para os valores encontrados:

|      Valor de correlação (r)        |      Correlação          |
|-------------------------------------|--------------------------|
| 0,0 a 0,1                           | Muito Fraca ou Nula      | 
| 0,1 a 0,3                           | Fraca                    | 
| 0,3 a 0,5                           | Moderada                 | 
| 0,5 a 0,7                           | Moderada a Forte         | 
| 0,7 a 0,9                           | Forte                    | 
| 0,9 a 1,0                           | Muito Forte ou Perfeita  | 

Sendo assim, observa-se que as correlações entre bpm e streams é ausente (zero), assim como para as características de músicas (valência e energia), todas com valores próximos a zero.
A correlação dançabilidade/streams é -0.10 indicando uma correlação negativa e fraca. Enquanto a correlação streams/total_playlists é positiva, em 0,78 e a correlação entre músicas populares no spotify/deezer também possui correlação moderada a forte(0,60).



### 5. Aplicar técnica de análise

##### 5.1 Segmentação
Neste ponto foi realizada a análise, por meio de tabelas, da relação entre as categorias das características musicais analisadas (bpm, dançabilidade, valência e energia) e a média de streams de cada uma.

|      categorias BPM        |      Média de streams      |   
|----------------------------|----------------------------|
| Moderado                   | 540609401,83               | 
| Lento                      | 535027902,00               | 
| Muito Rápido               | 523204926,94               | 
| Rápido                     | 455456202,94               | 



|      categorias dançabilidade        |      Média de streams      |
|--------------------------------------|----------------------------|
| Pouco Dançante                       | 591406082,36               | 
| Bem Dançante                         | 518794398,17               | 
| Moderada                             | 515911337,86               | 
| Muito Dançante                       | 425852126,89               | 



|      categorias valencia        |      Média de streams      |   
|---------------------------------|----------------------------|
| Levemente Negativa              | 562454748,09               | 
| Muito Negativa                  | 520173193,76               | 
| Levemente Positiva              | 503719369,80               | 
| Muito Positiva                  | 469560947,37               | 



|      categorias energia        |      Média de streams      |   
|--------------------------------|----------------------------|
| Baixa Energia                  | 548708501,10               | 
| Energia Moderada               | 517451301,02               | 
| Energia Muito Alta             | 496477517,99               | 
| Alta Energia                   | 491513171,95               | 


##### 5.2 Validação de Hipóteses
Calculando-se a correlação das variáveis de cada hipótese do estudo, iremos visualizar e analisar de forma mais clara, se existe ou não correlação e se a hipótese será confirmada ou refutada, baseando-se na amostra de dados analisada.

HIPÓTESE 1 - Músicas com BPM (Batidas por Minuto) mais altos fazem mais sucesso em termos de streams no Spotify
O cálculo de correlação entre BPM e streams, considerando o coeficiente de Pearson, apresentou valor de -0,00323. Isso indica ausência de correlação linear entre as variáveis. Para confirmar isso, de forma mais visual e robusta, construímos um gráfico de dispersão, considerando os valores de streams e bpm, e adicionando uma linha de tendência (em vermelho), que evidencia o fato de não haver relação entre as duas variáveis.
Sendo assim, a hipótese 1 foi refutada!

![HIP1](https://github.com/user-attachments/assets/fa62bec1-72c1-40cc-820e-c9d27983ae36)

HIPÓTESE 2 - As músicas mais populares no ranking do Spotify também possuem um comportamento semelhante em outras plataformas como Deezer
O cálculo de correlação entre in_spotify_charts e in_deezer_charts considerando o coeficiente de Pearson, apresentou valor de 0,60803. O que indica uma correlação positiva e moderada, ou seja, não é uma correlação perfeita, mas quando uma aumenta a outra tende a aumentar também.
O gráfico de dispersão confirma a hipótese 2, portanto, com a linha de tendência indicando tal correlação:

![HIP2](https://github.com/user-attachments/assets/82c75532-40b2-4281-9a75-344b44b21393)

HIPÓTESE 3 - A presença de uma música em um maior número de playlists está correlacionada com um maior número de streams
O cálculo de correlação entre a presença em playlists (considerando a soma de Spotify, Deezer e Apple Music) e streams considerando o coeficiente de Pearson, apresentou valor de 0,78371. O que indica uma correlação positiva e forte, ou seja, também não é uma correlação perfeita, mas quando uma aumenta a outra tende fortemente a aumentar, confirmado pelo gráfico de dispersão construído. A hipótese 3 foi, portanto, confirmada.

![HIP3](https://github.com/user-attachments/assets/3e4e1a2b-4015-4dab-8b1e-ff4dd0c91610)

Destaca-se que nesse ponto da análise, optamos pela criação de uma nova medida no Power BI “total_playlists”, somando as variáveis de playlists de Apple Music, Deezer e Spotify.


HIPÓTESE 4 - Artistas com um maior número de músicas no Spotify têm mais streams
Para validar esta hipótese foi criada uma view auxiliar no BigQuery, contando o número total de faixas, agrupado por artista e só então, realizado o cálculo de correlação, considerando o total de faixas por artista e o total de streams.

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

O cálculo de correlação entre o número total de músicas de um artista e os streams considerando o coeficiente de Pearson, apresentou valor de 0,77640. O que indica uma correlação positiva e forte.
Para realizar o gráfico de dispersão e correlacionar o número de músicas agrupado por um artista, e relacionar com o número de streams, realizamos a criação de uma tabela Agregada no Power BI, com a seguinte fórmula DAX:

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

Só então, correlacionando as variáveis número de faixas e total de streams, temos o gráfico de dispersão, evidenciando a forte correlação e demonstrando que quando uma variável aumenta a outra tende a aumentar. Portanto, a hipótese 4 foi confirmada!

![HIP4](https://github.com/user-attachments/assets/e5fad6b0-3ec0-40be-beff-24683f88a3eb)


HIPÓTESE 5 - As características da música influenciam o sucesso em termos de número de streams no Spotify
Neste ponto, iremos analisar as características de música selecionadas anteriormente (bpm, dançabilidade, valência e energia), realizando um gráfico de dispersão para cada característica.
Como já descrito anteriormente os coeficientes de correlação foram: -0,00323 (bpm), -0,10557 (dançabilidade), -0,04153 (valência), -0,02543 (energia). Portanto, todos são negativos e muito fracos. 
O valor negativo indica que a medida que uma variável aumenta a outra tende a diminuir, no entanto, aqui a correlação é praticamente nula, por se tratarem de valores muito próximos a zero.

Foram construídos os gráficos para cada uma das variáveis, para verificar o comportamento em cada um dos casos:

![HIP5](https://github.com/user-attachments/assets/613daf3e-d05c-4a17-9bd1-3fe9d2662e6e)


### 6. Apresentação de Resultados em Dashboard e Recomendações

Como resultado das análises e para facilitar a tomade de decisão e acesso aos dados, de forma mais clara e objetiva, foi construído um dashboard no Power BI com as informações consideradas mais relevantes:

![DASH](https://github.com/user-attachments/assets/f89feb6b-bf43-49cb-b863-25f26f8e97d2)

Destaca-se a importância de valorizar a posição em charts, pois aumenta a visibilidade do artista. Assim como a importância de observar a sinergia entre as diferentes plataformas, que pode ser utilizada em futuros lançamentos.
O investimento em um número maior de músicas, assim como na inserção em playlists deve ser considerado, uma vez que possui influência direta no número de streams.
Recomenda-se também analisar outras informações quanto às características musicais, assim como analisar aspectos de gênero musical.
E por último, a importância de analisar o perfil do público alvo ou segmentos existentes para o artista a ser lançado.


### Links importantes
Para conclusão do projeto os dados foram apresentados na seguinte [apresentação](https://docs.google.com/presentation/d/1eFTrlbDkLOaLhSrzxFSJO-1vQ9XC7LXtVg7mvsKzKB0/edit#slide=id.g357c14ae11d_0_429);

O vídeo de entrega com a apresentação do projeto, pode ser acessado [aqui](https://www.loom.com/share/3b6d4ddd7b574d589f96742a2dc28b68);


