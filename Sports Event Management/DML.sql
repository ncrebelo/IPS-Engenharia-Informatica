use eventos;

-- RF14 Atualizar dados 
select *
from ocorrencia where ocor_id = 2;
update ocorrencia set ocor_ativ_id = 14, ocor_hora_inicio = '09:30:00' -- ocor_ativ_id antigo era '13' e ocor_hora_inicio era '09:00:00'
where ocor_id = 2;

-- RF15 Inserir dados
select * 
from pessoa;

insert into pessoa values(999,"José Alves Fernandes",'1970-10-10',"Rua do Vale Nº300","2900-266",911119999,"jaf@gmail.com");

select *
from pessoa where pess_id = 999; -- confirmação da ação acima

-- RF16 Remover dados
select * 
from pessoa where pess_id = 999;

delete from pessoa where pess_id = 999;

select * 
from pessoa where pess_id = 999; -- confirmação da ação acima