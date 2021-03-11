drop procedure if exists sp_informação_ocorrencia;
delimiter $$
create procedure sp_informação_ocorrencia()
begin
	select ocor_id as 'ID Ocorrência', ativ_nome as 'Nome da Atividade',
	ocor_dia as 'Dia', ocor_hora_inicio as 'Hora ínicio', ocor_hora_fim as 'Hora fim', ocor_loc_local as 'Local', 
	average as 'Avaliação Média'
	from ocorrencia a
	join atividade on ativ_id = ocor_ativ_id
	join evento on ocor_eve_nome = eve_nome
	join (select ocoresp_ocor_id, avg(ocoresp_avaliacao) as 'average'
	from ocorrencia_espectador
	group by ocoresp_ocor_id) b on b.ocoresp_ocor_id = a.ocor_id
	order by eve_nome;
end$$
