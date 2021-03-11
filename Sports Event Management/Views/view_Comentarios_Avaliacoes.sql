use eventos;

DROP VIEW IF EXISTS comentarios_avaliacoes;
CREATE VIEW comentarios_avaliacoeS AS
SELECT evesp_eve_nome AS "Evento",ativ_nome AS "Atividade",eve_data_inicio "Data Inicio",eve_data_fim AS "Data Fim", 
		pess_nome "Espectador",ocoresp_avaliacao AS "Avaliação",ocoresp_comentario AS "Comentário"
FROM evento_espectador
JOIN evento
ON evesp_eve_nome = eve_nome
JOIN espectador
ON evesp_esp_id_espectador = esp_id_espectador
JOIN pessoa
ON esp_id_espectador = pess_id
JOIN ocorrencia_espectador
ON ocoresp_esp_id_espectador = esp_id_espectador
JOIN ocorrencia 
ON eve_nome = ocor_eve_nome
JOIN atividade
ON ativ_id = ocor_ativ_id
ORDER BY eve_data_inicio DESC, eve_data_fim DESC;