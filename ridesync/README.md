RideSync - Protótipo

Elementos do Grupo
Antonio Silva
Afonso Raimundo
Miguel Carvalho

Tema do Projeto:
O RideSync é uma App para organizar e partipar em passeios de carros e motas.
O projeto pretende criar passeios, gerir veiculos e facilitar a organização e o acompanhamento do grupo.

Ecras disponiveis:

Os ecras disponiveis são: 
Passeios: consulta da lista de passeios
Criar Passeio/Editar Passeio: formulario com nome, descrição, partida, destino, data e hora.
Detalhes do Passeio: Consulta das informações e do estado do passeio, com escolha de um veiculo da garagem.
Garagem: Área destinada à gestão dos veiculos do utilizador.
Perfil: Área destinada às informações do utilizador.


Requesitos para executar:
-Flutter Instalado.
Node.js e npm instalados.
Google Chrome para executar a versão web do protótipo.

Como executar a app:

Extrair o zip, e abrir a pasta no vscode.
No terminal deve se executar na pasta onde esta o pubspec.yaml flutter pub get e depois flutter run.

Ambiente Utilzado para os testes foi o google chrome

O backend foi desenvolvido com Node.js e Express e disponibiliza
-GET /api/health para verificar o funcionamento da API
-GET /api/passeios: devolve uma lista de passeios com dados estaticos

Backend: Num terminal entra na pasta backend e executa

npm install 
node src/server.js

Manter este terminal aberto.
A base de dados ainda não existe


Funcionalidades simuladas e limitações 
-Criar, editar e cancelar Passeios, altera apenas os dados em memioria na app sem enviar essas alterações para o backend.
-Os veiculos da garagem são apenas em memoria, quando e fechada a app deixam de existir
-As alterações locais perdem-se ao reiniciar a aplicação
-A escolha do veiculo mantem.se apenas enquanto o ecrã de detalhes estiver aberto
-Escolher um veiculo ainda não confirma a participação no passeio
-O numero de participantes está fixo em 1 
-o perfil ainda não esta ligadi a um sistema de autenticação
-Mapas , localização do grupo e notificações ainda não estao implementados