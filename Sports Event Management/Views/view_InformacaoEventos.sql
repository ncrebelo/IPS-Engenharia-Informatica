use eventos;

drop view if exists InformacaoEventos;
create view InformacaoEventos as
select eve_nome as 'Nome do Evento', eve_frequencia as 'Frequência', eve_data_inicio as 'Começo', eve_data_fim as'Fim',
evpat_patro_nome as 'Patrocinador',
pess_nome as 'Nome Participante'
from evento
join evento_patrocinador on eve_nome = evpat_eve_nome
join evento_participante on evpar_eve_nome = eve_nome
join participante on evpar_parti_id_participativo = parti_id_participativo
join pessoa on parti_pess_id = pess_id
order by eve_nome;


