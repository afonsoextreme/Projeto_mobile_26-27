IADE, Faculdade de Design, Tecnologia e Comunicação 
RideSync 
Proposta Inicial de Projeto 
Aplicação móvel para organizar passeios de carro e mota em grupo 
Afonso Raimundo, 20251105 
Miguel Carvalho, 20220881 
António Silva, 20250370 
Tomas Estrela, 20210282 
Github: https://github.com/afonsoextreme/Projeto_mobile_26-27 
1.  Palavras Chaves 
Aplicação Móvel, Flutter, Passeios em grupo, Carros e motas, Mapas, QR Code, 
Chamadas de voz, API REST, MySQL 
2.  Descrição da App e Problema 
A RideSync é uma app para preparar e acompanhar passeios de carro ou de 
mota em grupo. Um organizador define a data, o percurso e pontos de 
paragem. Os participantes entram através de um convite, um qr code ou o 
código do passeio, escolhem a sua viatura da sua garagem e passam a ver a 
mesma informação na app. Durante o passeio podem-se comunicar através da 
app sem ter de sair da mesma. 
O problema: 
Hoje um passeio combina-se num grupo de whatsapp, o pecurso fica numa 
app de navegação e, quando alguém perde o grupo ou atrasa-se, liga-se por 
telefone. 
Quando o plano muda, as alterações nem sempre chegam a todos os 
elementos e perde-se informações. 
3. Objetivos e motivação 
O objetivo principal é implementar um percurso completo e verificável: criar 
um passeio, permitir a adesão de outro utilizador com um veículo e consultar o 
itinerário e os participantes. A motivação é reduzir a dispersão de informação e 
explorar capacidades próprias do smartphone num projeto que integre as 
unidades curriculares do semestre. 
Motivação: 
Os quatro elementos do grupo gostam de carros e motas e já passaram por 
estes problemas em passeios com amigos. O tema obriga-nos a usar recursos 
do telemóvel (GPS,mapas, câmara para o QR Code e microfone para as 
chamadas) e a construir um sistema completo, da interface até à base de 
dados. 
Objetivos Específicos: 
• Registar conta e gerir os veículos da garagem 
• Criar e publicar um passeio com percurso e checkpoints ordenados 
• Aderir por QR code ou código e escolher um veículo compatível 
• Ver o mapa, os checkpoints e a lista de participantes  
• Fazer uma chamada de voz para outro participante do mesmo passeio 
4. Público-alvo  
A Aplicação destina-se a adultos que organizam ou integram passeios de lazer: 
Grupos de amigos, clubes e comunidades de carros e motas. O organizador 
precisa de comunicar o plano e gerir as inscrições. O participante precisa de 
saber onde deve estar, com o veículo que inscreveu e as paragens. O mesmo 
utilizador pode desempenhar os papeis em passeios diferentes. 
5.  Pesquisa de mercado 
Solução  
O que faz bem 
REVER 
O que falta para o nosso 
caso 
Planear, descobrir e gravar 
percursos de mota; 
seguir amigos no mapa 
CALIMOTO 
Passeios de grupo com 
convite por link ou QR 
Code 
Só motas; não tem 
chamadas 
Só motas, não tem 
chamadas nem escolha de 
veículos  
SENA WAVE INTERCOM 
Intercomunicador pela rede 
móvel 
LIFE 360 
Só comunicação, sem 
organização de passeios  
Partilha de localização entre 
família e amigos 
WHATSAPP + GOOGLE 
MAPS 
Todos tem 
Não tem passeios, 
percursos nem checkpoints 
Informação espalhada pelas 
duas Apps 
6. Guiões de teste  
Os guiões são preliminares e usam dados fictícios. Em cada execução deverão ser 
registados resultados, os erros serão observados e evidências de uso. Um teste só 
passo quando o resultado é confirmado na interface e quando é aplicável, na base 
de dados 
6.1. Guião 1 (core): Criar e Publicar num passeio  
Ator: Organizador 
Pré-Condições:  Sessão iniciada e um veículo na garagem 
1- Em “Os meus passeios”, o Afonso clica em “Criar passeio” 
2- Preenche nome (“Serra da Arrábida”), descrição, data, hora, tipo de 
veículos (misto) e limite de participantes (15). 
3- No mapa marca a partida em Setúbal, o destino no Portinho e dois 
checkpoints pela ordem certa 
4- Revê o percurso e escolhe o veículo com que vai. 
5- Clica em “Publicar”. Se faltar algum campo, a app mostra erro junto ao 
campo 
6- Abre o passeio publicado e vê a lista de participantes e o convite com QR 
code e um código 
Resultado Esperado: O passeio fica no estado “Publicado”, o organizador 
aparece inscrito uma única vez e os checkpoints mantem a ordem. Uma data 
no passado, um percurso incompleto ou um veículo incompatível impedem a 
publicação do passeio. 
Guião 2: Adesão por convite e escolha do 
veículo 
Ator: Participante  
Pré-Condições: Sessão iniciada, convite válido e passeio com vagas. 
1- O Tomás Clica em “Entrar por convite” e lê o QR code ou introduz o código. 
2- Vê a data, o percurso, as vagas e os tipos de carros permitidos. 
3- Escolher a mota/carro da sua garagem. Se não tiver nenhum veículo 
Compatível, a app leva-o à garagem. 
4- Clica em “participar” e abre o mapa com os checkpoints 
Resultado Esperado: Fica criada uma participação que liga o tomas, o 
passeio e a mota/carro. Um convite expirado, um passeio cheio ou uma 
segunda tentativa de adesão, mostram uma mensagem de erro. Se não der 
acesso à câmara, pode introduzir o código. 
Guião 3: Adicionar e gerir um veículo 
Ator: Utilizador com sessão iniciada 
1- O Miguel abre a “garagem” e clica no “+” 
2- Indica o tipo, marca, modelo e um nome (“Ferrari Azul”). Ano e fotografia 
do carro são opcionais 
3- Guarda e confirma que o veículo aparece na garagem. 
4- Muda o nome, guarda e volta a abrir o ecrã para confirmar a alteração 
7. Descrição da solução  
7.1. Descrição Genérica 
A solução terá uma aplicação Flutter, um API REST em Node.js e uma base de 
dados MySQL. O cliente apresenta os ecrãs e usa os recursos do dispositivo; o 
servidor valida pedidos e regras de negócio; a base de dados conserva contas, 
veículos, passeios, inscrições, rotas e eventos. Os serviços de mapas serão 
integrados através de um fornecedor a selecionar. 
7.2. Enquadramento nas unidades curriculares  
Unidade Curricular 
Projeto de Desenvolvimento Móvel  
Contributo e evidencia prevista 
Analise, Trabalho ágil, Project Charter, WBS, 
Gantt e acompanhamento no GitHub 
Projects 
Programação de Dispositivos Móveis 
Flutter/Dart, servidor Node.js, REST, 
integração, Git e documentação. 
Redes e Comunicação de Dados  
Arquitetura cliente-servidor, pedidos 
HTTP/HTTPS e comportamento em falhas de 
comunicação. 
Base de Dados 
Modelo ER MySQL, integridade, dados 
fictícios e scripts create.sql, populate.sql e 
queries.sql. 
Interfaces e Usabilidade 
Pesquisa, personas, guia de estilo, Figma, 
avaliação heurística e testes de usabilidade. 
Matemática Discreta 
Estatística descritiva e um método numérico 
previsto no briefing, aplicado e testado. 
7.3. Requisitos Técnicos Provisórios 
Serão necessários Flutter/Dart, Node.js, MySQL, um editor compatível, Git, 
GitHub Project e Figma. Os testes utilizarão um emulador e. As versões serão 
postas no respositório. Mapas, Camara e localização exigem avaliação de 
bibliotecas, permissões e limites do serviço antes da integração. 
7.4. Arquitetura da Solução Provisória 
No frontend, Models representarão os dados, Views os widgets e 
Controllers os fluxos e estados; serviços próprios tratarão os pedidos REST. 
No backend, rotas encaminharão pedidos para Controllers, os serviços 
aplicarão regras e os Models/repositórios acederão ao MySQL. Esta 
separação concretiza MVC e o consumo/exposição de REST previstos no 
briefing.  
7.5. Tecnologias Previstas 
Área 
Tecnologias 
App 
Flutter, Dart, flutter map, geolocator, mobile 
scanner, qr flutter, flutter webrtc 
Servidor 
Base de dados 
Node.js, Express, JWT, bcrypt 
MYSQL 
Mapas 
Gestão e design 
OpenstreetMap e OSRM 
GitHub, GitHub Projects, Figma  
7.6. Requisitos funcionais e não funcionais 
ID 
Requisito Funcional 
RF01 
RF02 
Registar conta, iniciar e terminar sessão 
RF03 
Editar o próprio perfil 
Adicionar, editar e arquivar veículos (tipo, 
marca, modelo, nome) 
RF04 
Criar passeio com nome, descrição, data, 
hora, tipo de veículos, visibilidade e limite 
RF05 
Definir partida, destino e checkpoints 
ordenados no mapa 
RF06 
Guardar como rascunho e publicar; a 
publicação exige dados completos 
RF07 
Gerar convite em QR Code e código; o 
organizador pode revogá-lo 
RF08 
Aderir por QR Code ou código e escolher um 
veículo compatível 
RF09 
RF10 
Desistir de um passeio 
Ver detalhe, mapa, checkpoints e lista de 
participantes 
RF11 
Encerrar um passeio (organizador) 
Área 
Requisito não funcional 
Usabildade 
Pelo menos 80% de sucesso nas três tarefas 
dos guiões, com cinco participantes 
Desempenho 
Integridade 
95% das consultas à API abaixo de 2s 
Nenhuma participação duplicada nem 
lotação Ultrapassada 
Segurança 
Pedidos sem autenticação ou permissão 
recusados  
Resiliencia  
Sem rede, a app mostra o estado e permite 
repetir a ação sem duplicar 
Manutenção 
Código em módulos (MVC), com testes das 
regras críticas  
7.7. Modelo de domínio preliminar 
7.8  Mockups e interfaces 
 
 
Link: 
https://www.figma.com/design/5NsN1hUYVe7BaUxgMWbdbt/RideSync?m=auto&t=rjID15wP
BpMvwBXz-1 
 
8. Planeamento e Calendarização 
Campo  
Conteúdo 
Objetivo 
Entregar até 11/12/2026 uma app Flutter 
ligada a uma API REST e a MySQL, que 
cumpra os três guiões e inclua a chamada 
de voz 
Equipa  
Afonso Raimundo, Antonio Silva, Miguel 
Carvalho, Tomás Estrela 
Entregáveis 
Proposta e arquivo documental; mockups 
Figma; modelos de domínio, ER e classes; 
app; API; scripts SQL; documentação REST; 
relatório final, manual, poster, vídeo e 
apresentação 
Marcos  
Critérios de sucesso 
02/10, 06/11, 11/12/26 
Os três guiões executáveis no telemóvel, 
com dados guardados no servidor 
8.2. WBS  
WBS Decomposição do projeto em pacotes de trabalho 
As tarefas serão mantidas no GitHub com responsável, prazo, requisito, critério de 
aceitação e estado. Prevê-se revisão semanal do trabalho, demonstração do que 
funciona e atualização do plano. A conclusão de uma tarefa exige revisão, teste e 
documentação correspondente. 
8.3. Calendarização 
Figura 1 Gantt preliminar das semanas 
9. Conclusão 
A RideSync parte de um problema que conhecemos bem, organizar um passeio 
em grupo, obriga a andar entre varias apps e o plano perde-se pelo caminho. A 
propostas junta a preparação, a adesão e a comunicação num só sitio, tendo o 
passeio como objeto central que liga pessoas, veículos e percurso. 
Objetivos a atingir:  
Os objetivos a atingir são uma aplicação funcional num telemóvel, uma API 
organizada segundo MVC e REST, dados relacionais consistentes, interfaces 
validadas e documentação atualizada. Alterações significativas ao âmbito ou às 
tecnologias deverão ser justificadas numa segunda proposta, de acordo com o 
briefing. 
10. 
Bibliografia 
Referências utilizadas na proposta.  
1- Universidade Europeia / IADE 
Projeto Mobile — Project Briefing (L-EI), Licenciatura em Engenharia 
Informática, 2026–2027, 3.º semestre. Documento fornecido: 
2026_EI3_Projeto Mobile.pdf. Pontos 1, 4, 5, 8 e 9.1–9.5. 
2- Google Maps 
3- REVER: https://www.rever.co/faqs 
4- Cardo Ride / Riser: https://journal.riserapp.com/how-to-use-the-riser-app/ 
5- Link figma 
https://www.figma.com/design/5NsN1hUYVe7BaUxgMWbdbt/RideSync?m
=auto&t=rjID15wPBpMvwBXz-1 
