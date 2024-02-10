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
