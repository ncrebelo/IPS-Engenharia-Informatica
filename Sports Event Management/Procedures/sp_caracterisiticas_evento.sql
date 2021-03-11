

DROP PROCEDURE IF EXISTS sp_caracterisiticas_evento;
DELIMITER $$
CREATE PROCEDURE sp_caracterisiticas_evento()
BEGIN
	select ocor_id as 'ID Ocorrência', ativ_nome as 'Nome da Atividade', eve_nome as 'Nome do Evento',
	ocor_dia as 'Dia', ocor_hora_inicio as 'Hora ínicio', ocor_hora_fim as 'Hora fim', ocor_loc_local as 'Local'
	from ocorrencia a
	join atividade on ativ_id = ocor_ativ_id
	join evento on ocor_eve_nome = eve_nome
	join (select ocoresp_ocor_id, avg(ocoresp_avaliacao) as 'average'
	from ocorrencia_espectador
	group by ocoresp_ocor_id) b on b.ocoresp_ocor_id = a.ocor_id
	order by eve_nome;
END $$
DELIMITER ;
