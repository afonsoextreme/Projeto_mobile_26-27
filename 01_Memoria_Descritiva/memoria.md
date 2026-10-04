# Identificação
Campo	Informação
Nome do projeto	RideSync
Ano letivo	2026/2027
Semestre	3.º semestre
Unidades curriculares	Projeto de Desenvolvimento Móvel; Programação de Dispositivos Móveis; Redes e Comunicações de Dados; Bases de Dados; Interfaces e Usabilidade; Matemática Discreta
Docentes	Fabio Guilherme (Projeto de Desenvolvimento Móvel); João Pedro Duarte Barros Monge (Programação de Dispositivos Móveis); Nathan Campos e Pedro Rosa (Redes e Comunicações de Dados); Miguel Boavida (Bases de Dados); Paula Neves (Interfaces e Usabilidade); André da Cunha Torcato e Ricardo Manuel Freitas de Sousa (Matemática Discreta)
## Resumo
A RideSync é uma aplicação móvel para organizar passeios de carro e de mota em grupo. A ideia vem de uma situação que conhecemos bem: quando se combina um passeio com amigos, a conversa fica num grupo de WhatsApp, o percurso fica numa app de navegação e, se alguém se atrasa ou perde o grupo, acaba-se por telefonar. E quando o plano muda, a alteração nem sempre chega a toda a gente.

Na RideSync, toda a informação fica ligada ao passeio. O organizador cria o passeio com nome, descrição, data, hora, tipo de veículos permitidos e limite de participantes, e marca no mapa a partida, o destino e os checkpoints pela ordem de passagem. Pode guardar o passeio como rascunho, mas só o consegue publicar com os dados completos. Depois de o passeio ser publicado, a app gera um convite com um QR Code e um código.

Quem recebe o convite lê o QR Code com a câmara ou escreve o código, vê a data, o percurso e as vagas e escolhe um veículo compatível da sua garagem. A partir daí todos veem a mesma informação: o mapa, os checkpoints e a lista de quem vai e com que veículo. Durante o passeio é possível fazer uma chamada de voz a outro participante sem sair da aplicação.

O sistema tem três partes: uma app em Flutter (Dart), uma API REST em Node.js com Express e uma base de dados relacional em MySQL. A app e o servidor seguem o padrão MVC. Estão ainda previstos o OpenStreetMap e o OSRM (mapas e percursos), o WebRTC (chamada de voz), o JWT (autenticação) e o bcrypt (palavras-passe).

O projeto é desenvolvido no 3.º semestre da Licenciatura em Engenharia Informática e junta seis unidades curriculares. Nesta primeira entrega fizemos a proposta inicial: pesquisa de mercado, público-alvo, três guiões de teste, requisitos funcionais e não funcionais, Project Charter, WBS, gráfico de Gantt e modelo de domínio preliminar. Fizemos também os primeiros mockups no Figma, com quatro ecrãs e uma biblioteca de componentes. A 2.ª entrega vai trazer um protótipo com servidor e base de dados a funcionar, e no fim do semestre queremos ter a app completa a correr num telemóvel. Em todo o desenvolvimento vamos usar apenas dados fictícios.

## Contexto
Problema abordado
Organizar um passeio em grupo obriga a andar entre várias aplicações. O plano combina-se no WhatsApp, o percurso fica numa app de navegação e, quando alguém perde o grupo ou se atrasa, resolve-se com uma chamada. Quando o plano muda, as alterações nem sempre chegam a todos e perde-se informação pelo caminho. Ao mesmo tempo, cada participante precisa de saber onde deve estar, com que veículo se inscreveu e quais são as paragens. Isto acontece a grupos de amigos, clubes e comunidades de carros e motas, que são o público-alvo da app.

Motivação
Gostamos todos de carros e motas e já passámos por estes problemas em passeios com amigos, e foi daí que surgiu o tema. Também nos interessou porque obriga a usar recursos próprios do telemóvel (GPS, mapas, câmara para o QR Code e microfone para as chamadas) e a construir um sistema completo, da interface até à base de dados.

Objetivos
O objetivo principal é que a app permita fazer, do início ao fim, o fluxo central: criar um passeio, deixar outro utilizador aderir com um veículo e consultar o itinerário e os participantes. Os objetivos específicos são:

registar conta e gerir os veículos da garagem;
criar e publicar um passeio com percurso e checkpoints ordenados;
aderir por QR Code ou código e escolher um veículo compatível;
ver o mapa, os checkpoints e a lista de participantes;
fazer uma chamada de voz para outro participante do mesmo passeio.
## Processo
Metodologia utilizada
Trabalhamos de forma ágil. As tarefas ficam no GitHub Projects e cada uma tem responsável, prazo, requisito associado, critério de aceitação e estado. Uma vez por semana revemos o trabalho, mostramos o que está feito e atualizamos o plano. Uma tarefa só fica concluída depois de revista, testada e documentada. O semestre está dividido em três marcos, que são as entregas de 02/10, 06/11 e 11/12/2026, e o gráfico de Gantt (img_10) mostra como distribuímos o trabalho pelas 14 semanas.

## Ferramentas utilizadas
GitHub, para o código e a documentação: https://github.com/afonsoextreme/Projeto_mobile_26-27
GitHub Projects, para as tarefas e o acompanhamento semanal
Figma, para os mockups e a biblioteca de componentes: https://www.figma.com/design/5NsN1hUYVe7BaUxgMWbdbt/RideSync?m=auto&t=rjID15wPBpMvwBXz-1
Um editor compatível com Flutter (Android Studio ou Visual Studio Code) e um emulador para os testes
Tecnologias utilizadas
Parte	Tecnologias
App	Flutter e Dart; flutter_map (mapa), geolocator (localização), mobile_scanner e qr_flutter (ler e gerar o QR Code), flutter_webrtc (chamada de voz)
Servidor	Node.js com Express; JWT (autenticação) e bcrypt (palavras-passe)
Base de dados	MySQL
Mapas	OpenStreetMap e OSRM
Estrutura da equipa
Elemento	N.º	Área principal
Afonso Raimundo	20251105	Coordenação, integração entre a app e o servidor, mapa e QR Code
Miguel Carvalho	20220881	Servidor Node.js, API REST e chamada de voz
António Silva	20250370	App em Flutter, Figma e testes de usabilidade
Tomás Estrela	20210282	Base de dados, testes e Matemática Discreta
## Resultados
Descrição da solução desenvolvida
Nesta entrega a solução está definida ao nível da proposta, do modelo e dos mockups. O código começa na fase seguinte.

A RideSync vai ter três partes (img_08):

a app em Flutter, organizada em MVC: os Models representam os dados, as Views são os widgets dos ecrãs e os Controllers tratam os fluxos e os estados; serviços próprios fazem os pedidos REST;
a API REST em Node.js com Express, também em MVC: as rotas passam os pedidos aos Controllers, os serviços aplicam as regras de negócio e os Models/repositórios acedem ao MySQL;
a base de dados MySQL, onde ficam as contas, os veículos, os passeios, as inscrições, as rotas e os eventos.
Funcionalidades principais
Registo, início e fim de sessão, e edição do perfil
Garagem: adicionar, editar e arquivar veículos (tipo, marca, modelo e nome)
Criar um passeio com nome, descrição, data, hora, tipo de veículos, visibilidade e limite de participantes
Marcar no mapa a partida, o destino e os checkpoints pela ordem certa
Guardar como rascunho e publicar, só com os dados completos
Gerar o convite com QR Code e código, que o organizador pode revogar
Aderir por QR Code ou código com um veículo compatível, e desistir
Ver o detalhe do passeio, o mapa, os checkpoints e os participantes
Encerrar o passeio (organizador)
Chamada de voz para outro participante do mesmo passeio
Contributos relevantes
O que produzimos nesta 1.ª entrega:

a proposta inicial (g01-proposta-v1, na pasta Documentos);
a pesquisa de mercado e a definição do público-alvo;
três guiões de teste;
os requisitos funcionais e não funcionais;
o Project Charter, a WBS e o gráfico de Gantt;
o modelo de domínio preliminar e a arquitetura provisória;
o logótipo, a biblioteca de componentes e os mockups de quatro ecrãs no Figma.
## Reflexão
Lições aprendidas
Partir de um problema que conhecemos bem ajudou. Os guiões descrevem coisas que fazemos quando combinamos um passeio, por isso foi fácil perceber o que a app tem mesmo de fazer.
Pôr o passeio no centro simplificou os requisitos e o modelo de domínio, porque quase tudo se liga a ele: participantes, veículos, percurso e checkpoints.
Limitações
Ainda não há código. A arquitetura e as tecnologias são provisórias e ainda temos de avaliar as bibliotecas de mapas, câmara e localização.
Os mockups cobrem só quatro ecrãs e os exemplos estão pensados sobretudo para motas. Faltam a garagem, o convite com QR Code e a adesão, e alguns textos dos ecrãs ainda são provisórios.
Trabalho futuro
Até à 2.ª entrega (06/11/2026): protótipo com servidor funcional, base de dados e app a consumir os serviços; guiões e personas finais; esboço do diagrama de classes; modelo ER com dicionário de dados e guia de dados; primeira versão da documentação REST; scripts create.sql, populate.sql e queries.sql.
Até à 3.ª entrega (11/12/2026): app completa no telemóvel, com os três guiões e a chamada de voz a funcionar, manual do utilizador, poster, vídeo e apresentação final.
