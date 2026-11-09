create database ridesync default character set utf8mb4;

use ridesync;
 
create table utilizador (
    uti_id int not null auto_increment,
    uti_nome varchar(60) not null,
    uti_email varchar(60) not null,
    uti_password varchar(255) not null,
    uti_telemovel varchar(15) null,
    uti_data_nascimento date null,
    uti_localidade varchar(40) null,
    uti_data_registo datetime not null default current_timestamp,
    primary key (uti_id),
    constraint uq_utilizador_email unique (uti_email)
);
 
create table veiculo (
    vei_id int not null auto_increment,
    vei_uti_id int not null,
    vei_tipo varchar(10) not null default "Carro",
    vei_marca varchar(30) not null,
    vei_modelo varchar(40) not null,
    vei_matricula varchar(10) not null,
    vei_ano int null,
    vei_cor varchar(20) null,
    primary key (vei_id),
    constraint uq_veiculo_matricula unique (vei_matricula),
    constraint fk_veiculo_utilizador foreign key (vei_uti_id) references utilizador (uti_id)
);
 
create table passeio (
    pas_id int not null auto_increment,
    pas_uti_id int not null,
    pas_nome varchar(60) not null,
    pas_descricao varchar(500) null,
    pas_partida varchar(80) not null,
    pas_destino varchar(80) not null,
    pas_data_hora datetime not null,
    pas_limite_participantes int not null default 10,
    pas_distancia_km decimal(6,1) null,
    pas_estado varchar(10) not null default "agendado",
    pas_data_criacao datetime not null default current_timestamp,
    pas_data_inicio datetime null,
    pas_data_fim datetime null,
    primary key (pas_id),
    constraint fk_passeio_utilizador foreign key (pas_uti_id) references utilizador (uti_id)
);
 
create table inscricao (
    ins_id int not null auto_increment,
    ins_uti_id int not null,
    ins_pas_id int not null,
    ins_vei_id int null,
    ins_estado varchar(10) not null default "confirmada",
    primary key (ins_id),
    constraint uq_inscricao_utilizador_passeio unique (ins_uti_id, ins_pas_id),
    constraint fk_inscricao_utilizador foreign key (ins_uti_id) references utilizador (uti_id),
    constraint fk_inscricao_passeio foreign key (ins_pas_id) references passeio (pas_id),
    constraint fk_inscricao_veiculo foreign key (ins_vei_id) references veiculo (vei_id) on delete set null
);
 