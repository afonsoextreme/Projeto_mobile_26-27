use ridesync;

select pas_id id, pas_nome nome, ifnull(pas_descricao, "") descricao, pas_partida partida,
    pas_destino destino, date_format(pas_data_hora, "%Y-%m-%dT%H:%i:%s") data,
    pas_limite_participantes limiteParticipantes,
    (select count(*) from inscricao where ins_pas_id = pas_id and ins_estado = "confirmada") participantes,
    pas_estado estado,
    case when pas_uti_id = 1 then 1 else 0 end souOrganizador,
    (select count(*) from inscricao where ins_pas_id = pas_id and ins_uti_id = 1
        and ins_uti_id <> pas_uti_id and ins_estado = "confirmada") inscrito,
    (select ins_vei_id from inscricao where ins_pas_id = pas_id and ins_uti_id = 1
        and ins_estado = "confirmada") veiculoId
from passeio
where pas_estado in ("agendado", "emCurso") or (pas_estado = "cancelado" and pas_data_hora > now())
order by pas_data_hora;

select pas_nome,
    case
        when pas_estado = "agendado" then "Agendado"
        when pas_estado = "emCurso" then "Em curso"
        when pas_estado = "terminado" then "Terminado"
        else "Cancelado"
    end estado,
    ifnull(pas_descricao, "Este passeio não tem descrição.") descricao,
    pas_partida, pas_destino, date_format(pas_data_hora, "%d/%m/%Y : %H:%i") data_hora,
    uti_nome organizador,
    concat((select count(*) from inscricao where ins_pas_id = pas_id and ins_estado = "confirmada"),
        " / ", pas_limite_participantes, " participantes") participantes,
    case
        when (select count(*) from inscricao where ins_pas_id = pas_id and ins_estado = "confirmada")
            >= pas_limite_participantes then "Passeio lotado"
        else "Há lugares livres"
    end lugares
from passeio
inner join utilizador on pas_uti_id = uti_id
where pas_id = 12;

select uti_nome participante,
    case when ins_uti_id = pas_uti_id then "Organizador" else "Participante" end papel,
    ifnull((select concat(vei_tipo, ": ", vei_marca, " ", vei_modelo, " (", vei_matricula, ")")
        from veiculo where vei_id = ins_vei_id), "Ainda sem veículo") veiculo
from inscricao
inner join utilizador on ins_uti_id = uti_id
inner join passeio on ins_pas_id = pas_id
where ins_pas_id = 12 and ins_estado = "confirmada"
order by papel, uti_nome;

select vei_id, vei_tipo tipo, concat(vei_marca, " ", vei_modelo) veiculo, vei_matricula matricula,
    ifnull(vei_cor, "-") cor, vei_ano ano
from veiculo
where vei_uti_id = (select uti_id from utilizador where uti_email = "ricardo.almeida@gmail.com")
order by vei_tipo, vei_marca;

select uti_nome, uti_email,
    (select count(*) from inscricao, passeio
        where ins_pas_id = pas_id and ins_uti_id = uti_id
        and ins_estado = "confirmada" and pas_estado = "terminado") passeios_terminados,
    (select ifnull(sum(pas_distancia_km), 0) from inscricao, passeio
        where ins_pas_id = pas_id and ins_uti_id = uti_id
        and ins_estado = "confirmada" and pas_estado = "terminado") km_percorridos
from utilizador
where uti_email = "ricardo.almeida@gmail.com";

select uti_id, uti_nome,
    case when position(" " in uti_nome) > 0 then substr(uti_nome, 1, position(" " in uti_nome) - 1)
    else uti_nome end primeiro_nome,
    uti_email, uti_password
from utilizador
where lower(uti_email) = lower("Ricardo.Almeida@gmail.com");

select upper(uti_nome) nome, timestampdiff(year, uti_data_nascimento, curdate()) idade,
    ifnull(uti_telemovel, "sem telemóvel") telemovel,
    coalesce(uti_localidade, "localidade não indicada") localidade
from utilizador
order by idade desc;

select pas_nome, date_format(pas_data_hora, "%d-%m-%Y") data, pas_estado
from passeio
where pas_data_hora >= str_to_date("01-11-2026", "%d-%m-%Y")
and pas_data_hora < str_to_date("01-01-2027", "%d-%m-%Y")
order by pas_data_hora;

select pas_nome, date_format(pas_data_hora, "%d/%m/%Y %H:%i") marcado_para,
    timestampdiff(minute, pas_data_hora, pas_data_inicio) minutos_de_atraso,
    concat(timestampdiff(hour, pas_data_inicio, pas_data_fim), "h",
        timestampdiff(minute, pas_data_inicio, pas_data_fim)
        - timestampdiff(hour, pas_data_inicio, pas_data_fim) * 60, "min") duracao
from passeio
where pas_estado = "terminado"
order by pas_data_hora;

select count(*) utilizadores, count(uti_telemovel) com_telemovel,
    count(*) - count(uti_telemovel) sem_telemovel,
    count(distinct uti_localidade) localidades_diferentes,
    round(avg(timestampdiff(year, uti_data_nascimento, curdate())), 1) idade_media
from utilizador;

select date_format(pas_data_hora, "%Y-%m") mes, count(*) passeios,
    sum(case when pas_estado = "cancelado" then 1 else 0 end) cancelados
from passeio
group by date_format(pas_data_hora, "%Y-%m")
order by mes;

select pas_nome, count(*) inscritos, pas_limite_participantes limite,
    round(count(*) * 100 / pas_limite_participantes, 1) ocupacao_pct
from passeio
inner join inscricao on ins_pas_id = pas_id
where ins_estado = "confirmada" and pas_estado = "agendado"
group by pas_id, pas_nome, pas_limite_participantes
order by ocupacao_pct desc;

select uti_nome organizador, count(*) passeios, sum(pas_distancia_km) km_planeados,
    date_format(min(pas_data_hora), "%d/%m/%Y") primeiro,
    date_format(max(pas_data_hora), "%d/%m/%Y") ultimo,
    round(avg(timestampdiff(minute, pas_data_hora, pas_data_inicio)), 1) atraso_medio_min
from utilizador
inner join passeio on pas_uti_id = uti_id
group by uti_id, uti_nome
having count(*) >= 2
order by passeios desc, km_planeados desc;

select u1.uti_nome utilizador_1, u2.uti_nome utilizador_2, count(*) passeios_juntos
from inscricao i1
inner join inscricao i2 on i1.ins_pas_id = i2.ins_pas_id and i1.ins_uti_id < i2.ins_uti_id
inner join utilizador u1 on i1.ins_uti_id = u1.uti_id
inner join utilizador u2 on i2.ins_uti_id = u2.uti_id
inner join passeio on i1.ins_pas_id = pas_id
where i1.ins_estado = "confirmada" and i2.ins_estado = "confirmada" and pas_estado = "terminado"
group by u1.uti_id, u1.uti_nome, u2.uti_id, u2.uti_nome
having count(*) >= 3
order by passeios_juntos desc, utilizador_1;

select pas_nome, count(*) participantes
from passeio
inner join inscricao on ins_pas_id = pas_id
where ins_estado = "confirmada"
group by pas_id, pas_nome
having count(*) = (select max(n_inscritos)
    from (select count(*) n_inscritos from inscricao where ins_estado = "confirmada" group by ins_pas_id) temp_table);

select uti_nome, uti_email
from utilizador
where uti_id not in (select vei_uti_id from veiculo);

select pas_nome, date_format(pas_data_hora, "%d/%m/%Y %H:%i") data_hora,
    pas_limite_participantes - (select count(*) from inscricao
        where ins_pas_id = pas_id and ins_estado = "confirmada") lugares_livres
from passeio
where pas_estado = "agendado"
and pas_limite_participantes > (select count(*) from inscricao
    where ins_pas_id = pas_id and ins_estado = "confirmada")
order by pas_data_hora;