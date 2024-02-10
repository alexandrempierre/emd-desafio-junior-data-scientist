/*
1. Quantos chamados foram abertos no dia 01/04/2023?
Resposta: 73 chamados (contados via id_chamado único) abertos em 01/04/2023
*/
-- verificando se existem linhas em que a data_particao e a data de abertura do chamado são diferentes
SELECT
  COUNT(*) AS count_rows
FROM
  `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  EXTRACT(DATE FROM data_inicio) <> data_particao;
-- mesma verificação de cima, mas só para o dia 01/04/2023
-- concluí que todos os registros do dia 01/04/2023 estão nas linhas com data_particao igual
SELECT
  COUNT(*) AS count_rows
FROM
  `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  EXTRACT(DATE FROM data_inicio) <> data_particao
  AND EXTRACT(DATE FROM data_inicio) = "2023-04-01";
-- respondendo à pergunta 1
SELECT
  COUNT(DISTINCT id_chamado) AS contagem_chamados -- sem o DISTINCT o resultado é o mesmo
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  data_particao = '2023-04-01'
  AND FORMAT_DATETIME("%F", data_inicio) = "2023-04-01"
LIMIT 1;
/*
2. Qual o tipo de chamado que teve mais reclamações no dia 01/04/2023?
Resposta: Poluição sonora (id_tipo = 1393) com 24 chamados
*/
-- verificando se cada id_tipo está associado a mais de um tipo -- não está
SELECT
  id_tipo
  ,COUNT(DISTINCT tipo) AS count_tipo
FROM `datario.administracao_servicos_publicos.chamado_1746`
GROUP BY
  id_tipo
HAVING
  COUNT(DISTINCT tipo) > 1
LIMIT 100;
-- respondendo à pergunta 2
SELECT
  id_tipo
  ,ANY_VALUE(tipo) AS tipo
  ,COUNT(id_chamado) AS contagem_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  data_particao = '2023-04-01'
  AND FORMAT_DATETIME("%F", data_inicio) = "2023-04-01"
GROUP BY
  id_tipo
ORDER BY
  COUNT(DISTINCT id_chamado) DESC
LIMIT 1;
/*
3. Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
Resposta: Engenho de Dentro, Leblon, Campo Grande
*/
-- verificação se há mais de um nome para algum id_bairro -- não há
SELECT
  b.id_bairro
  ,COUNT(DISTINCT b.nome) AS contagem_nomes
FROM
  `datario.dados_mestres.bairro` AS b
GROUP BY
  b.id_bairro
HAVING
  COUNT(DISTINCT b.nome) > 1
LIMIT 100;
-- resposta à pergunta 3
SELECT
  ch.id_bairro
  ,ANY_VALUE(b.nome) AS nome_bairro
  ,COUNT(ch.id_chamado) AS contagem_chamados -- sem o DISTINCT o resultado é o mesmo
FROM
  `datario.administracao_servicos_publicos.chamado_1746` AS ch
  INNER JOIN `datario.dados_mestres.bairro` AS b ON (ch.id_bairro = b.id_bairro)
WHERE
  data_particao = '2023-04-01'
  AND FORMAT_DATETIME("%F", data_inicio) = "2023-04-01"
GROUP BY
  ch.id_bairro
ORDER BY
  COUNT(ch.id_chamado) DESC
LIMIT 3;
