use eventos;

drop view if exists InformacaoEspectadoresPorEvento;
create view InformacaoParticipantesPorEvento as
select evesp_esp_id_espectador as 'Id Competição', pess_nome as 'Nome', 
pess_data_de_nascimento as 'Data de Nascimento', pess_morada as 'Morada', pess_telefone as 'Telefone',
evesp_eve_nome as 'Evento', evesp_bilhete as 'Bilhete'
from evento_espectador
join espectador on  esp_id_espectador = evesp_esp_id_espectador
join pessoa on esp_pess_id = pess_id;
