use eventos;

DROP VIEW IF EXISTS top_espectador_avaliacoes;
CREATE VIEW top_espectador_avaliacoes AS
SELECT pess_nome AS "Espectador", COUNT(*) AS ocoresp_comentario
FROM ocorrencia_espectador
JOIN espectador 
ON ocoresp_esp_id_espectador = esp_id_espectador
JOIN pessoa
ON esp_id_espectador = pess_id
GROUP BY ocoresp_esp_id_espectador
ORDER BY ocoresp_comentario DESC
LIMIT 5;