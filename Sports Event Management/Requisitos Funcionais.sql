use eventos;

-- RF01 
select parti_id_participativo, pess_nome, parti_clube
from participante
inner join pessoa
on pess_id = parti_pess_id
order by parti_clube;

select esp_id_espectador, pess_nome
from espectador
inner join pessoa
on pess_id = esp_pess_id;

--RF02
select parti_id_participativo, pess_data_de_nascimento
from participante
inner join pessoa
on pess_id = parti_pess_id;

select esp_id_espectador, pess_cod_postal
from espectador
inner join pessoa
on pess_id = esp_pess_id;

--RF03
select a.parti_id_participativo, pess_nome, eve_nome
from participante a
inner join pessoa on parti_id_participativo = pess_id
inner join evento_participante c on a.parti_id_participativo = c.parti_id_participativo
order by pess_nome;

select esp_id_espectador, pess_telefone
from espectador
inner join pessoa
on pess_id = esp_pess_id;

--RF04
select ocor_id, ocor_eve_nome
from ocorrencia;

--RF05
select ocor_id, ocor_loc_local
from ocorrencia;

--RF06
select ocor_id, ativ_nome
from ocorrencia a
inner join atividade on ativ_id = ocor_ativ_id
group by a.ocor_id;

--RF07
select *
from ocorrencia
where ocor_eve_nome like '%Natação%';

--RF08
select *
from ocorrencia
where year(ocor_dia) = 2021;

--RF09
select *
from ocorrencia
where ocor_loc_local like '%Bonfim%';

--RF10
select a.ocor_id, eve_nome, avg(avaliacao) as 'Avaliacão Média'
from ocorrencia a
inner join ocorrencia_espectador b on a.ocor_id = b.ocor_id
inner join evento on eve_nome = ocor_eve_nome
group by a.ocor_id;

--RF10
select a.ocor_id, eve_nome, min(avaliacao) as 'Avaliacão Mínima'
from ocorrencia a
inner join ocorrencia_espectador b on a.ocor_id = b.ocor_id
inner join evento on eve_nome = ocor_eve_nome
group by a.ocor_id;

--RF10
select a.ocor_id, eve_nome, max(avaliacao) as 'Avaliacão Máxima'
from ocorrencia a
inner join ocorrencia_espectador b on a.ocor_id = b.ocor_id
inner join evento on eve_nome = ocor_eve_nome
group by a.ocor_id;

--RF11
select eve_nome, avg(avaliacao) as 'Avaliacão Média'
from ocorrencia a
inner join ocorrencia_espectador b on a.ocor_id = b.ocor_id
inner join evento on eve_nome = ocor_eve_nome
group by eve_nome;

--RF11
select eve_nome, min(avaliacao) as 'Avaliacão Mínima'
from ocorrencia a
inner join ocorrencia_espectador b on a.ocor_id = b.ocor_id
inner join evento on eve_nome = ocor_eve_nome
group by eve_nome;

--RF11
select eve_nome, max(avaliacao) as 'Avaliacão Máxima'
from ocorrencia a
inner join ocorrencia_espectador b on a.ocor_id = b.ocor_id
inner join evento on eve_nome = ocor_eve_nome
group by eve_nome;

--RF12 
select max(c.numero_espetadores)
from(select a.ocor_id, count(esp_id_espectador) as numero_espetadores
from ocorrencia_espectador a
inner join ocorrencia b on a.ocor_id = b.ocor_id
group by b.ocor_id) c;

--RF12
select min(c.numero_espetadores)
from(select a.ocor_id, count(esp_id_espectador) as numero_espetadores
from ocorrencia_espectador a
inner join ocorrencia b on a.ocor_id = b.ocor_id
group by a.ocor_id) c;

--RF12
select avg(c.numero_espetadores)
from(select a.ocor_id, count(esp_id_espectador) as numero_espetadores
from ocorrencia_espectador a
inner join ocorrencia b on a.ocor_id = b.ocor_id
group by a.ocor_id) c;

--RF12
select stddev(c.numero_espetadores)
from(select a.ocor_id, count(esp_id_espectador) as numero_espetadores
from ocorrencia_espectador a
inner join ocorrencia b on a.ocor_id = b.ocor_id
group by a.ocor_id) c;

--RF13
select max(d.numero_espetadores)
from (
	select a.eve_nome, count(esp_id_espectador) as 'numero_espetadores'
	from evento_espectador a
	inner join evento b on b.eve_nome = a.eve_nome
	inner join ocorrencia c on ocor_eve_nome = a.eve_nome
	group by a.eve_nome) d;
    
--RF13	
select min(d.numero_espetadores)
from (
	select a.eve_nome, count(esp_id_espectador) as 'numero_espetadores'
	from evento_espectador a
	inner join evento b on b.eve_nome = a.eve_nome
	inner join ocorrencia c on ocor_eve_nome = a.eve_nome
	group by a.eve_nome) d;
 
--RF13 
select avg(d.numero_espetadores)
from (
	select a.eve_nome, count(esp_id_espectador) as 'numero_espetadores'
	from evento_espectador a
	inner join evento b on b.eve_nome = a.eve_nome
	inner join ocorrencia c on ocor_eve_nome = a.eve_nome
	group by a.eve_nome) d;

--RF13    
select stddev(d.numero_espetadores)
from (
	select a.eve_nome, count(esp_id_espectador) as 'numero_espetadores'
	from evento_espectador a
	inner join evento b on b.eve_nome = a.eve_nome
	inner join ocorrencia c on ocor_eve_nome = a.eve_nome
	group by a.eve_nome) d;





