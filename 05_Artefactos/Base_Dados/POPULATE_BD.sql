use ridesync;

insert into utilizador (uti_id, uti_nome, uti_email, uti_password, uti_telemovel, uti_data_nascimento, uti_localidade, uti_data_registo) values
(1,  "Ricardo Almeida",  "ricardo.almeida@gmail.com",  "$2b$10$T2gyJMbWsZ/vrVlQOcjDHelggdg0bJkC7.WQ0/TULqZwvViRqtzv6", "912345678", "1985-04-12", "Setúbal", "2025-03-02 10:15:00"),
(2,  "Marta Sousa",      "marta.sousa@hotmail.com",    "$2b$10$oF3moXBQypnATUslzcZfWOzNOY4oGwvIy73NjQwZMaUGA4MR8b6Eu", "936781234", "1992-09-23", "Lisboa",  "2025-03-05 21:40:00"),
(3,  "João Ferreira",    "joao.ferreira@gmail.com",    "$2b$10$GpscOCMXI6GYnSz7FBjcAu4XsXl54jyUqTGeXweLeNdqoGAN57sNa", "961234987", "1978-01-30", "Almada",  "2025-03-10 18:22:00"),
(4,  "Inês Carvalho",    "ines.carvalho@sapo.pt",      "$2b$10$EFnn5mkXundEkbVUL9emQOX/tY2pw.51WaJlGSRHoNjd8C/e4.NiK", "917654321", "1996-06-14", "Lisboa",  "2025-04-01 09:05:00"),
(5,  "Pedro Santos",     "pedro.santos@gmail.com",     "$2b$10$eRaV96qYCM8J3.gy9jc2yek.8OkFshCKEJVmdEt5HuxYgX/yTtr.e", "925556677", "1989-11-02", "Sintra",  "2025-04-18 22:10:00"),
(6,  "Sofia Martins",    "sofia.martins@outlook.pt",   "$2b$10$.dHymKkqoahRSb6YmOiKJ.X2ffvOz572BJlL6ICc8PISMYTNvnuKG", "934442211", "2001-02-27", "Cascais", "2025-05-07 13:30:00"),
(7,  "Tiago Rodrigues",  "tiago.rodrigues@gmail.com",  "$2b$10$MxejrOeGA/t4/bzh9fMn5u/tWH0vJLj53B1r2qtOzYVg3.OvL5NlK", "913332244", "1983-07-19", "Porto",   "2025-05-20 19:45:00"),
(8,  "Ana Pereira",      "ana.pereira@sapo.pt",        "$2b$10$W23ZsHAbjUTqpOVrqAKQYudazzIXXNFh65CoUN8JWAU5LAWy580gq", "968887766", "1990-12-05", "Braga",   "2025-06-02 11:00:00"),
(9,  "Miguel Costa",     "miguel.costa@gmail.com",     "$2b$10$fGOuCNlRjOyPUzCkAcUfCeIALZXQeu5htP2J2RJ1zGcUQXdpb4Crm", "912223344", "1975-03-08", "Setúbal", "2025-06-15 17:20:00"),
(10, "Beatriz Gomes",    "beatriz.gomes@hotmail.com",  "$2b$10$wOgCGkLfhgh2rj7LB7aH8O.0pOfbPLzSiZ60wROkbglRwd3TDcte2", "931119988", "1999-08-11", "Palmela", "2025-07-03 20:55:00"),
(11, "Rui Oliveira",     "rui.oliveira@gmail.com",     "$2b$10$Ur7THtje9mCbR/opuN/8KecRU2iiAkXlpZE50.9rynlipv3HtCsr2", "926665544", "1968-10-25", "Coimbra", "2025-07-21 08:40:00"),
(12, "Carla Lopes",      "carla.lopes@sapo.pt",        "$2b$10$oKxqt.tDW2LzAggncVX6Du7aCxyVhDpxx/L/.2Hnr1taaCWAtoeNy", null,        "1987-05-16", "Leiria",  "2025-09-09 14:12:00"),
(13, "Diogo Fernandes",  "diogo.fernandes@gmail.com",  "$2b$10$f5M5sngSTsS7cdkoBPUD7O2vTz5c4gC5SC0hPyr50BcfXQCiTZxcO", "915557788", "2003-01-09", "Lisboa",  "2025-10-01 16:00:00"),
(14, "Helena Ribeiro",   "helena.ribeiro@outlook.pt",  "$2b$10$9XdTlFkqwQmnTvtwDfs.sea9YGZIP/C.izVkzd78M7TWGWzK7KCyW", "937778899", "1981-09-30", "Évora",   "2026-01-14 10:30:00"),
(15, "Nuno Marques",     "nuno.marques@gmail.com",     "$2b$10$Z8RVQx8x.xVaYoD/SoZQa..MngoHLmMQ49CKdr3GwSiLBY7hCnHUK", null,        "1994-04-04", null,      "2026-02-20 23:05:00"),
(16, "Joana Pinto",      "joana.pinto@gmail.com",      "$2b$10$kXPuHOZl4IZw3yRdafqKPurErKylM.gaMi/KYycj0NtX3xao/15PG", "918889900", "1997-12-21", "Faro",    "2026-04-11 12:45:00"),
(17, "André Teixeira",   "andre.teixeira@hotmail.com", "$2b$10$OTCVk3CmIK6Um8p70wSAZ.EEo1xZxXDoDwOb4rWE4kF2odofi7RiK", null,        null,         null,      "2026-09-28 19:10:00"),
(18, "Catarina Moreira", "catarina.moreira@sapo.pt",   "$2b$10$BgQ7.0oWZU9J623ily4RIOmmUY6fZ1s74ehehv68mRmZq1KTW7wLm", null,        null,         null,      "2026-10-30 09:20:00"),
(19, "Bruno Lima",       "bruno.lima@gmail.com",       "$2b$10$RIXH/ZUdLWcIfUIhfsBvzOg4mibf6EHTMJtSYC4KYH0WBr3USVfJq", null,        null,         null,      "2026-11-04 20:10:00");

insert into veiculo (vei_id, vei_uti_id, vei_tipo, vei_marca, vei_modelo, vei_matricula, vei_ano, vei_cor) values
(1,  1,  "Carro", "BMW",             "Série 3 Touring", "45-RT-12", 2016, "Cinzento"),
(2,  1,  "Mota",  "Honda",           "Africa Twin",     "AH-21-PL", 2021, "Vermelho"),
(3,  2,  "Carro", "Mazda",           "MX-5",            "AB-34-CD", 2020, "Vermelho"),
(4,  3,  "Carro", "Porsche",         "911 Carrera",     "12-34-LX", 1999, "Prata"),
(5,  3,  "Carro", "Volkswagen",      "Golf GTI",        "BF-67-TR", 2022, "Branco"),
(6,  4,  "Mota",  "Yamaha",          "MT-07",           "BG-12-MO", 2023, "Azul"),
(7,  5,  "Mota",  "BMW",             "R 1250 GS",       "88-ZX-41", 2019, "Branco"),
(8,  5,  "Carro", "Toyota",          "GR86",            "BL-90-PS", 2023, "Preto"),
(9,  6,  "Carro", "Mini",            "Cooper S",        "AT-55-SM", 2021, "Verde"),
(10, 7,  "Mota",  "Ducati",          "Monster",         "BH-03-TR", 2023, "Vermelho"),
(11, 7,  "Carro", "Volkswagen",      "Carocha 1300",    "LO-45-12", 1972, "Azul"),
(12, 8,  "Carro", "Peugeot",         "208 GTi",         "76-UV-33", 2018, "Amarelo"),
(13, 9,  "Mota",  "Harley-Davidson", "Sportster 883",   "23-PO-98", 2010, "Preto"),
(14, 9,  "Carro", "Mercedes-Benz",   "SL 500",          "91-56-HN", 1996, "Preto"),
(15, 10, "Mota",  "Honda",           "CB500F",          "BC-77-BG", 2022, "Preto"),
(16, 11, "Carro", "Alfa Romeo",      "Giulia Super",    "MN-12-34", 1974, "Vermelho"),
(17, 11, "Carro", "Volvo",           "XC60",            "AZ-88-RO", 2021, "Cinzento"),
(18, 12, "Mota",  "Vespa",           "GTS 300",         "BD-45-CL", 2022, null),
(19, 14, "Carro", "Fiat",            "500",             "BN-10-HR", 2024, "Branco"),
(20, 15, "Mota",  "KTM",             "390 Duke",        "BP-66-NM", null, "Laranja"),
(21, 16, "Carro", "Renault",         "Clio RS",         "54-QZ-21", 2014, "Azul"),
(22, 16, "Mota",  "Kawasaki",        "Z650",            "BQ-23-JP", 2025, "Verde"),
(23, 17, "Mota",  "Honda",           "CBR125R",         "BV-08-AT", 2026, "Branco"),
(24, 13, "Carro", "Seat",            "Ibiza FR",        "18-XS-77", 2016, "Branco");

insert into passeio (pas_id, pas_uti_id, pas_nome, pas_descricao, pas_partida, pas_destino, pas_data_hora, pas_limite_participantes, pas_distancia_km, pas_estado, pas_data_criacao, pas_data_inicio, pas_data_fim) values
(1, 5, "Serra de Sintra e Cabo da Roca",
    "Subida à Serra de Sintra pela Pena e pela Peninha, com descida até ao Cabo da Roca",
    "Sintra", "Cabo da Roca", "2025-09-14 09:30:00", 12, 35.0, "terminado", "2025-08-28 18:40:00",
    "2025-09-14 09:30:00", "2025-09-14 10:58:00"),
(2, 7, "Estrada N222 - Vale do Douro",
    "A famosa N222 entre a Régua e o Pinhão, sempre junto ao rio",
    "Peso da Régua", "Pinhão", "2025-10-05 10:00:00", 10, 27.0, "terminado", "2025-09-10 21:15:00",
    "2025-10-05 10:07:00", "2025-10-05 12:40:00"),
(3, 1, "Arrábida ao pôr do sol",
    "Fim de tarde pela estrada da serra, passagem pelo Cabo Espichel jantar de grupo em Sesimbra.",
    "Setúbal", "Sesimbra", "2025-11-08 16:00:00", 15, 32.5, "terminado", "2025-10-20 12:05:00",
    "2025-11-08 16:12:00", "2025-11-08 18:45:00"),
(4, 11, "Rota da Serra da Estrela",
    "Travessia da serra de Seia à Covilhã com subida à Torre.",
    "Seia", "Covilhã", "2026-03-22 09:00:00", 8, 49.0, "cancelado", "2026-02-25 19:30:00",
    null, null),
(5, 3, "Clássicos no Caramulo",
    "Encontro de carros clássicos com visita ao Museu do Caramulo.",
    "Viseu", "Museu do Caramulo", "2026-04-19 10:00:00", 20, 38.0, "terminado", "2026-03-15 10:50:00",
    "2026-04-19 10:03:00", "2026-04-19 11:30:00"),
(6, 4, "Costa Vicentina em duas rodas",
    "Passeio de motas pela costa alentejana e vicentina, de Sines até Sagres",
    "Sines", "Sagres", "2026-05-16 08:30:00", 10, 118.0, "terminado", "2026-04-20 22:10:00",
    "2026-05-16 08:41:00", "2026-05-16 15:20:00"),
(7, 11, "Aldeias do Xisto",
    "Estradas de montanha na Serra da Lousã com visita às aldeias do Talasnal e do Candal.",
    "Lousã", "Góis", "2026-06-13 09:30:00", 12, 42.0, "terminado", "2026-05-25 17:45:00",
    "2026-06-13 09:30:00", "2026-06-13 12:30:00"),
(8, 9, "Estrada Nacional 2 - Etapa Sul",
    "Metade sul da N2, de Abrantes até ao km 738 em Faro. Dia longo: depósito cheio à partida.",
    "Abrantes", "Faro", "2026-07-11 08:00:00", 15, 370.0, "terminado", "2026-06-01 09:30:00",
    "2026-07-11 08:05:00", "2026-07-11 18:25:00"),
(9, 8, "Gerês selvagem",
    "Percurso pelo Parque Nacional da Peneda-Gerês até à fronteira da Portela do Homem.",
    "Braga", "Portela do Homem", "2026-09-20 09:00:00", 10, 62.0, "terminado", "2026-08-30 20:00:00",
    "2026-09-20 09:18:00", "2026-09-20 12:10:00"),
(10, 14, "Alentejo: Évora - Monsaraz",
    "Planície alentejana até à vila medieval de Monsaraz, com vista sobre o Alqueva.",
    "Évora", "Monsaraz", "2026-10-24 10:00:00", 12, 52.0, "terminado", "2026-10-01 11:20:00",
    "2026-10-24 10:00:00", "2026-10-24 11:40:00"),
(11, 6, "Marginal ao pôr do sol",
    "Passeio calmo pela Marginal, de Belém a Cascais, ao fim da tarde.",
    "Belém", "Cascais", "2026-11-28 17:30:00", 6, 25.0, "cancelado", "2026-10-25 15:00:00",
    null, null),
(12, 1, "Passeio à Arrábida",
    "Passeio de carros e motas pela serra.",
    "Setúbal", "Portinho da Arrábida", "2026-11-15 10:00:00", 15, 18.5, "agendado", "2026-10-28 09:10:00",
    null, null),
(13, 2, "Tour noturno de Lisboa",
    null,
    "Parque das Nações", "Belém", "2026-11-13 21:00:00", 5, 14.0, "agendado", "2026-10-30 20:30:00",
    null, null),
(14, 7, "Feriado no Douro",
    "Passeio de feriado do Porto até à Régua pela margem do rio, com almoço de grupo.",
    "Porto", "Peso da Régua", "2026-12-08 09:00:00", 12, 125.0, "agendado", "2026-11-01 18:00:00",
    null, null),
(15, 12, "Lagoa de Óbidos e Nazaré",
    "Da vila de Óbidos à Nazaré pela costa, com paragens na Foz do Arelho e em São Martinho do Porto.",
    "Óbidos", "Nazaré", "2026-11-22 09:30:00", 10, 45.0, "agendado", "2026-11-02 13:25:00",
    null, null),
(16, 16, "Serra do Caldeirão pela N2",
    "Primeiro passeio do ano: as curvas da N2 na Serra do Caldeirão, de Loulé a Almodôvar.",
    "Loulé", "Almodôvar", "2027-01-10 09:00:00", 10, 64.0, "agendado", "2026-11-03 21:40:00",
    null, null),
(17, 19, "Serra de Montejunto",
    null,
    "Lisboa", "Serra de Montejunto", "2027-02-14 10:00:00", 8, null, "agendado", "2026-11-05 22:15:00",
    null, null),
(18, 9, "Sábado na Arrábida",
    "Volta à serra num sábado à tarde, com paragens na Figueirinha, no Portinho e no miradouro do Convento, e chegada a Sesimbra ao pôr do sol.",
    "Setúbal", "Sesimbra", "2026-11-07 15:30:00", 10, 38.0, "emCurso", "2026-10-31 10:55:00",
    "2026-11-07 15:36:00", null);

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(1, 5, 1, 7, "confirmada"),
(2, 2, 1, 3, "confirmada"),
(3, 4, 1, 6, "confirmada"),
(4, 6, 1, 9, "confirmada"),
(5, 1, 1, 2, "confirmada"),
(6, 3, 1, 4, "cancelada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(7,  7,  2, 10, "confirmada"),
(8,  8,  2, 12, "confirmada"),
(9,  5,  2, 7,  "confirmada"),
(10, 11, 2, 17, "confirmada"),
(11, 2,  2, 3,  "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(12, 1,  3, 1,  "confirmada"),
(13, 9,  3, 13, "confirmada"),
(14, 10, 3, 15, "confirmada"),
(15, 3,  3, 5,  "confirmada"),
(16, 4,  3, 6,  "confirmada"),
(17, 13, 3, 24, "confirmada"),
(18, 2,  3, 3,  "cancelada"),
(19, 6,  3, 9,  "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(20, 11, 4, 17, "confirmada"),
(21, 7,  4, 11, "confirmada"),
(22, 8,  4, 12, "confirmada"),
(23, 14, 4, 19, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(24, 3,  5, 4,  "confirmada"),
(25, 9,  5, 14, "confirmada"),
(26, 7,  5, 11, "confirmada"),
(27, 11, 5, 16, "confirmada"),
(28, 1,  5, 1,  "confirmada"),
(29, 12, 5, 18, "confirmada"),
(30, 14, 5, 19, "cancelada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(31, 4,  6, 6,  "confirmada"),
(32, 10, 6, 15, "confirmada"),
(33, 15, 6, 20, "confirmada"),
(34, 5,  6, 7,  "confirmada"),
(35, 1,  6, 2,  "confirmada"),
(36, 16, 6, 22, "confirmada"),
(37, 9,  6, 13, "cancelada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(38, 11, 7, 17, "confirmada"),
(39, 14, 7, 19, "confirmada"),
(40, 12, 7, 18, "confirmada"),
(41, 3,  7, 5,  "confirmada"),
(42, 8,  7, 12, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(43, 9,  8, 13, "confirmada"),
(44, 1,  8, 2,  "confirmada"),
(45, 5,  8, 7,  "confirmada"),
(46, 7,  8, 10, "confirmada"),
(47, 10, 8, 15, "confirmada"),
(48, 16, 8, 21, "confirmada"),
(49, 15, 8, 20, "confirmada"),
(50, 4,  8, 6,  "confirmada"),
(51, 2,  8, 3,  "confirmada"),
(52, 13, 8, 24, "confirmada"),
(53, 6,  8, 9,  "cancelada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(54, 8,  9, 12, "confirmada"),
(55, 7,  9, 10, "confirmada"),
(56, 11, 9, 17, "confirmada"),
(57, 5,  9, 8,  "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(58, 14, 10, 19, "confirmada"),
(59, 1,  10, 1,  "confirmada"),
(60, 9,  10, 14, "confirmada"),
(61, 16, 10, 22, "confirmada"),
(62, 17, 10, 23, "confirmada"),
(63, 6,  10, 9,  "confirmada"),
(64, 13, 10, 24, "confirmada"),
(65, 2,  10, 3,  "cancelada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(66, 6,  11, 9,  "confirmada"),
(67, 2,  11, 3,  "confirmada"),
(68, 13, 11, 24, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(69, 1,  12, 2,  "confirmada"),
(70, 9,  12, 13, "confirmada"),
(71, 10, 12, 15, "confirmada"),
(72, 3,  12, 4,  "confirmada"),
(73, 4,  12, 6,  "confirmada"),
(74, 17, 12, 23, "confirmada"),
(75, 15, 12, 20, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(76, 2,  13, 3,  "confirmada"),
(77, 4,  13, 6,  "confirmada"),
(78, 6,  13, 9,  "confirmada"),
(79, 13, 13, 24, "confirmada"),
(80, 17, 13, 23, "cancelada"),
(81, 5,  13, 8,  "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(82, 7,  14, 11, "confirmada"),
(83, 8,  14, 12, "confirmada"),
(84, 11, 14, 17, "confirmada"),
(85, 16, 14, 21, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(86, 12, 15, 18, "confirmada"),
(87, 14, 15, 19, "confirmada"),
(88, 11, 15, 16, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(89, 16, 16, 22, "confirmada"),
(90, 9,  16, 13, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(91, 19, 17, null, "confirmada");

insert into inscricao (ins_id, ins_uti_id, ins_pas_id, ins_vei_id, ins_estado) values
(92, 9,  18, 13, "confirmada"),
(93, 1,  18, 2,  "confirmada"),
(94, 10, 18, 15, "confirmada"),
(95, 4,  18, 6,  "confirmada"),
(96, 13, 18, 24, "confirmada"),
(97, 3,  18, 5,  "confirmada"),
(98, 6,  18, 9,  "cancelada");