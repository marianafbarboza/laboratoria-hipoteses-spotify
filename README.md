# Projeto de Validação de Hipóteses do Spotify


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
O conjunto de dados está disponível no arquivo *spotify_2023.zip* deste projeto.
A descrição de como estão organizadas as tabelas e variáveis que as compõe, podem ser verificadas [aqui](Dataset-organization.md).

# 4. Escopo da análise de dados
A análise consiste no desenvolvimento das seguintes habilidades:
- Processamento e preparação dos dados;
- Análise Exploratória;
- Aplicação de técnicas de análise;
- Construção de Dashboards;
- Apresentação dos Resultados;


### 4.1 Processamento e preparação dos dados
#### 4.1.1 Importação de Dados
Como primeiro passo, foi realizada a identificação e tratamento de valores nulos encontrados. 

#### 4.1.2 Valores Nulos
Como primeiro passo, utilizando a função `SELECT COUNT (*)` foi realizada a identificação e tratamento de valores nulos, sendo encontrados os seguintes, em cada tabela:
- Tabela competition: total de 953 registros, in_shazam_charts (50 nulos);
- Tabela spotify: total de 953 registros, não encontrei nulos;
- Tabela technical_info: 953 registros, key (95 nulos);

#### 4.1.3 Valores Duplicados
No segundo momento foi realizada a identificação de valores duplicados, foram encontrados 04 valores com track_name e track_id duplicados (com 02 registros cada):

|      track_name      |      artist_name      |  contagem  |
|----------------------|-----------------------|------------|
| SNAP                 | Rosa Linn             | 2          |
| About Damn Time      | Lizzo                 | 2          |
| Take My Breath       | The Weeknd            | 2          |
| SPIT IN MY FACE!     | ThxSoMch              | 2          |


#### 4.1.4 Dados fora do Escopo da Análise
O escopo da análise envolve as hipóteses já detalhadas, sendo assim, optamos por manter a seguinte variável de cada tabela:
- Tabela spotify: track_id, track_name, artist_name, artist_count, released_year, released_month, released_day, in_spotify_playlists, in_spotify_charts, streams;

- Tabela competition: track_id, in_apple_playlists, in_apple_charts, in_deezer_playlists, in_deezer_charts;
A variável “in_shazam_charts” foi excluída pois não é uma plataforma tão utilizada para ouvir música, mas sim para identificar artista e música, em tempo real, sendo irrelevante para a presente análise.

- Tabela technical_info: track_id, bpm, danceability_%, valence_%, energy_%; 
Considerando alguns estudos que apontam 03 variáveis mais relevantes no sucesso de uma música, optou-se por mantê-los, além de track_id e bpm.


#### 4.1.5 Identificação e Tratamento de Dados Discrepantes
Identificou-se que as variáveis categóricas "track_name" e "artist_name" da tabela spotify possuem caracteres especiais e letras maiúsculas, o tratamento realizado no BigQuery está [aqui](BigQuery.md).


#### 4.1.6 Criação de Novas Variáveis
Neste ponto do projeto, optou-se pela criação de uma nova variável "data_de_lançamento", concatenando as variáveis: released_year, released_month, released_day. 

#### 4.1.7 Unir tabelas
A fim de criar uma tabela única, para facilitar a análise dos dados, criou-se Views com os dados "limpos" de todas as tabelas. Considerando aqui, a vantagem de não armazenar os dados, apenas salvar a consulta, sendo mais rápido de executar e tendo um menor custo para armazenamento. O detalhamento desta etapa consta no [arquivo](BigQuery.md).


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


#### 4.2.2 Medidas de Tendência Central
Para compreender melhor o conjunto de dados, calculou-se médias e medianas das variáveis BPM e streams. 


#### 4.2.3 Distribuição dos dados através de histograma
Como os gráficos de histograma não estão disponíveis no pacote normal do Power BI, realizamos a instalação de Python, afim de utilizar as histogramas para uma visualização mais robusta da distribuição de nossa amostra em alguns aspectos, como streams, BPM e presença em playlist do Spotify.


#### 4.2.4 Medidas de Dispersão
Optou-se por analisar o desvio padrão das mesmas variáveis analisadas nos passos anteriores: BPM e streams.


#### 4.2.5 Análise da amostra em quartis
Foi utilizado o BigQuery para calcular os quartis, considerando as variáveis: streams, bpm, dançabilidade, valência e energia, compilados e categorizados na seguinte [consulta](BigQuery.md).


#### 4.2.6 Correlação entre variáveis
Optou-se por realizar a correlação entre as seguintes variáveis:
- streams e total de playlists;
- bpm e streams;
- dançabilidade e streams;
- valência e streams;
- energia e streams;
- presença da música nas paradas do Spotify e do Deezer;

Para analisar tais valores, considerou-se o conceito de correlação de Pearson, e a seguinte escala para os valores encontrados:

|      Valor de correlação (r)        |      Correlação          |
|-------------------------------------|--------------------------|
| 0,0 a 0,1                           | Muito Fraca ou Nula      | 
| 0,1 a 0,3                           | Fraca                    | 
| 0,3 a 0,5                           | Moderada                 | 
| 0,5 a 0,7                           | Moderada a Forte         | 
| 0,7 a 0,9                           | Forte                    | 
| 0,9 a 1,0                           | Muito Forte ou Perfeita  | 


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

### HIPÓTESE 1 - Músicas com BPM (Batidas por Minuto) mais altos fazem mais sucesso em termos de streams no Spotify
O cálculo de correlação entre BPM e streams, considerando o coeficiente de Pearson, apresentou valor de -0,00323. Isso indica ausência de correlação linear entre as variáveis. Para confirmar isso, de forma mais visual e robusta, construímos um gráfico de dispersão, considerando os valores de streams e bpm, e adicionando uma linha de tendência (em vermelho), que evidencia o fato de não haver relação entre as duas variáveis.
Sendo assim, a hipótese 1 foi refutada!

![HIP1](https://github.com/user-attachments/assets/fa62bec1-72c1-40cc-820e-c9d27983ae36)

### HIPÓTESE 2 - As músicas mais populares no ranking do Spotify também possuem um comportamento semelhante em outras plataformas como Deezer
O cálculo de correlação entre in_spotify_charts e in_deezer_charts considerando o coeficiente de Pearson, apresentou valor de 0,60803. O que indica uma correlação positiva e moderada, ou seja, não é uma correlação perfeita, mas quando uma aumenta a outra tende a aumentar também.
O gráfico de dispersão confirma a hipótese 2, portanto, com a linha de tendência indicando tal correlação:

![HIP2](https://github.com/user-attachments/assets/82c75532-40b2-4281-9a75-344b44b21393)

### HIPÓTESE 3 - A presença de uma música em um maior número de playlists está correlacionada com um maior número de streams
O cálculo de correlação entre a presença em playlists (considerando a soma de Spotify, Deezer e Apple Music) e streams considerando o coeficiente de Pearson, apresentou valor de 0,78371. O que indica uma correlação positiva e forte, ou seja, também não é uma correlação perfeita, mas quando uma aumenta a outra tende fortemente a aumentar, confirmado pelo gráfico de dispersão construído. A hipótese 3 foi, portanto, confirmada.

![HIP3](https://github.com/user-attachments/assets/3e4e1a2b-4015-4dab-8b1e-ff4dd0c91610)

Destaca-se que nesse ponto da análise, optamos pela criação de uma nova medida no Power BI “total_playlists”, somando as variáveis de playlists de Apple Music, Deezer e Spotify.


### HIPÓTESE 4 - Artistas com um maior número de músicas no Spotify têm mais streams
Para validar esta hipótese foi criada uma view auxiliar no [BigQuery](BigQuery.md).
O cálculo de correlação entre o número total de músicas de um artista e os streams considerando o coeficiente de Pearson, apresentou valor de 0,77640. O que indica uma correlação positiva e forte. Portanto, a hipótese 4 foi confirmada!

![HIP4](https://github.com/user-attachments/assets/e5fad6b0-3ec0-40be-beff-24683f88a3eb)


### HIPÓTESE 5 - As características da música influenciam o sucesso em termos de número de streams no Spotify
Neste ponto, iremos analisar as características de música selecionadas anteriormente (bpm, dançabilidade, valência e energia), realizando um gráfico de dispersão para cada característica.
Os coeficientes de correlação foram: -0,00323 (bpm), -0,10557 (dançabilidade), -0,04153 (valência), -0,02543 (energia). Portanto, todos são negativos e muito fracos. O valor negativo indica que a medida que uma variável aumenta a outra tende a diminuir, no entanto, aqui a correlação é praticamente nula, por se tratarem de valores muito próximos a zero.

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
Para conclusão do projeto os dados foram apresentados na seguinte [apresentação](Apresentacao.pdf);

O vídeo de entrega com a apresentação do projeto, pode ser acessado [aqui](https://www.loom.com/share/3b6d4ddd7b574d589f96742a2dc28b68);


