/*
1. Quantos chamados foram abertos no dia 01/04/2023?
Resposta: 73 chamados (contados via id_chamado único) abertos em 01/04/2023
*/
SELECT
  COUNT(DISTINCT id_chamado) AS contagem_chamados
FROM `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  data_particao = '2023-04-01'
  AND FORMAT_DATETIME("%F", data_inicio) = "2023-04-01"
LIMIT 1;
/*
2. Qual o tipo de chamado que teve mais reclamações no dia 01/04/2023?
Resposta: Poluição sonora (id_tipo = 1393) com 24 chamados
*/
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
SELECT
  ch.id_bairro
  ,ANY_VALUE(b.nome) AS nome_bairro
  ,COUNT(ch.id_chamado) AS contagem_chamados
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
/*
4. Qual o nome da subprefeitura com mais chamados abertos nesse dia?
Resposta: Zona Norte
*/
SELECT
  ch.id_bairro
  ,ANY_VALUE(b.subprefeitura) AS nome_subprefeitura
  ,COUNT(ch.id_chamado) AS contagem_chamados
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
LIMIT 1;
/*
5. Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
Resposta: Existe uma reclamação sem bairro nem subprefeitura associados. O subtipo da reclamação é "Verificação de ar condicionado inoperante no ônibus", esse tipo de reclamação não parece precisar estar associado a um endereço específico, portanto não existe nenhuma informação de logradouro, bairro nem subprefeitura.
*/
SELECT
  subtipo
FROM
  `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  data_particao = '2023-04-01'
  AND FORMAT_DATETIME("%F", data_inicio) = "2023-04-01"
  AND id_bairro IS NULL;
/*
6. Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?
Resposta: 42408 chamados de perturbação do sossego.
*/
SELECT
  COUNT(DISTINCT id_chamado) AS qtde_chamados
FROM
  `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  data_particao BETWEEN "2022-01-01" AND "2023-12-31"
  AND EXTRACT(DATE FROM data_inicio) BETWEEN "2022-01-01" AND "2023-12-31"
  AND subtipo = "Perturbação do sossego"
LIMIT 10;
/*
7. Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).
Resposta: 
*/
SELECT
  v.evento
  ,ch.*
FROM
  `datario.administracao_servicos_publicos.chamado_1746` AS ch
  INNER JOIN
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS v ON (
      EXTRACT(DATE FROM ch.data_inicio) BETWEEN v.data_inicial AND v.data_final
    )
WHERE
  ch.subtipo = "Perturbação do sossego"
LIMIT 2000;
/*
8. Quantos chamados desse subtipo foram abertos em cada evento?
Resposta: 137 chamados no Reveillon, 241 no Carnaval e 834 no Rock in Rio.
*/
SELECT
  v.evento
  ,COUNT(DISTINCT ch.id_chamado) AS qtde_chamados
FROM
  `datario.administracao_servicos_publicos.chamado_1746` AS ch
  INNER JOIN
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS v ON (
      EXTRACT(DATE FROM ch.data_inicio) BETWEEN v.data_inicial AND v.data_final
    )
WHERE
  ch.subtipo = "Perturbação do sossego"
GROUP BY
  v.evento
LIMIT 10;
/*
9. Qual evento teve a maior média diária de chamados abertos desse subtipo?
Resposta: Rock in Rio com aproximadamente 119 chamados por dia de evento.
*/
SELECT
  v.evento
  ,COUNT(DISTINCT ch.id_chamado) / COUNT(DISTINCT EXTRACT(DATE FROM ch.data_inicio)) AS media_diaria_chamados
FROM
  `datario.administracao_servicos_publicos.chamado_1746` AS ch
  INNER JOIN
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS v ON (
      EXTRACT(DATE FROM ch.data_inicio) BETWEEN v.data_inicial AND v.data_final
    )
WHERE
  ch.subtipo = "Perturbação do sossego"
GROUP BY
  v.evento
ORDER BY
  COUNT(DISTINCT ch.id_chamado) / COUNT(DISTINCT EXTRACT(DATE FROM ch.data_inicio)) DESC
LIMIT 1;
/*
10. Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse subtipo considerando todo o período de 01/01/2022 até 31/12/2023.
Resposta: Rock in Rio (aproximadamente 119 chamados por dia) e Carnaval (por volta de 60 chamados por dia) tem mais chamados que a média diária do período (em torno de 52 por dia), já o Reveillon (quase 46 chamados por dia) tem menos.
*/
SELECT
  v.evento
  ,COUNT(DISTINCT ch.id_chamado) / COUNT(DISTINCT EXTRACT(DATE FROM ch.data_inicio)) AS media_diaria_chamados
FROM
  `datario.administracao_servicos_publicos.chamado_1746` AS ch
  INNER JOIN
    `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` AS v ON (
      EXTRACT(DATE FROM ch.data_inicio) BETWEEN v.data_inicial AND v.data_final
    )
WHERE
  ch.subtipo = "Perturbação do sossego"
GROUP BY
  v.evento
UNION ALL
SELECT
  "Período de 01/01/2022 a 31/12/2023" AS evento
  ,COUNT(DISTINCT id_chamado) / COUNT(DISTINCT EXTRACT(DATE FROM data_inicio)) AS media_diaria_chamados
FROM
  `datario.administracao_servicos_publicos.chamado_1746`
WHERE
  subtipo = "Perturbação do sossego";