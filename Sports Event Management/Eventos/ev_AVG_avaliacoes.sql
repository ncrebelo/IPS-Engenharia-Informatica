DROP EVENT IF EXISTS ev_AVG_avaliacoes;
CREATE EVENT IF NOT EXISTS ev_AVG_avaliacoes
ON SCHEDULE
    EVERY 1 MINUTE
    STARTS '2019-06-09 18:27:15' ON COMPLETION PRESERVE ENABLE
  DO
INSERT INTO auxiliar (aux_data_hora,aux_AVG)
SELECT 
    now(), AVG(a.count_neg_avaliacoes)
FROM
    (SELECT COUNT(ocoresp_avaliacao) AS count_neg_avaliacoes
    FROM ocorrencia_espectador
    WHERE ocoresp_avaliacao < 4) a;
