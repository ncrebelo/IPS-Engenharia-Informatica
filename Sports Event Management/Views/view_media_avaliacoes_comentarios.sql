use eventos;

DROP VIEW IF EXISTS media_avaliacoes_comentarios;
CREATE VIEW media_avaliacoes_comentarios AS
SELECT evesp_eve_nome AS "Evento",
		AVG(ocoresp_avaliacao) AS "Avaliação",COUNT(ocoresp_comentario) AS "Comentário"
FROM evento_espectador
JOIN evento
ON evesp_eve_nome = eve_nome
JOIN ocorrencia 
ON eve_nome = ocor_eve_nome
JOIN ocorrencia_espectador
ON ocoresp_ocor_id = ocor_id
GROUP BY evesp_eve_nome;


