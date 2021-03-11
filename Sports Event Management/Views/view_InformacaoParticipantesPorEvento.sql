use eventos;

drop view if exists InformacaoParticipantesPorEvento;
create view InformacaoParticipantesPorEvento as
select parti_id_participativo as 'Id Competição', pess_nome as 'Nome', 
pess_data_de_nascimento as 'Data de Nascimento', pess_morada as 'Morada', pess_telefone as 'Telefone',
evpar_eve_nome as 'Evento', evpar_inscricao as 'Local da Inscrição'
from evento_participante
join participante on evpar_parti_id_participativo = parti_id_participativo
join pessoa on parti_pess_id = pess_id;
