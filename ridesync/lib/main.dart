import 'package:flutter/material.dart';

void main() {
  runApp(const RideSyncApp());
}

class RideSyncApp extends StatelessWidget{
  const RideSyncApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RideSync',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange,
        brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101114),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int paginaAtual = 0;
  
  @override
  Widget build(BuildContext context) {
    const paginas = [
      PasseiosScreen(),
      GaragemScreen(),
      PerfilScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RideSync', style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle:  false,
      ),
      body: IndexedStack(
        index: paginaAtual,
        children: paginas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,
        onDestinationSelected: (index){
          setState(() {
            paginaAtual = index;
          });
        },
        destinations: const[
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Passeios'
          ),
          NavigationDestination(
            icon: Icon(Icons.garage_outlined),
            selectedIcon: Icon(Icons.garage),
            label: 'Garagem'
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil'
          ),
        ],
      ),
    );
  }
}

class PasseiosScreen extends StatefulWidget{
  const PasseiosScreen({super.key});
  
  @override
  State<PasseiosScreen> createState() => _PasseioScreenState();
}

class _PasseioScreenState extends State<PasseiosScreen>{
  final List <Passeio> passeios = [];

  String formatarData(DateTime data){
    String doisDigitos(int numero) => numero.toString().padLeft(2, '0');

    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year}'
        '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }

  Future<void> criarPasseio() async{
    final novoPasseio = await Navigator.of(context).push<Passeio>(
      MaterialPageRoute(
        builder: (context) => const CriarPasseioScreen(),
      ),
    );  
    
    if (!mounted || novoPasseio == null) return;

    setState(() {
      passeios.add(novoPasseio);

      passeios.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passeio criado com sucesso!'),
      ),
    );
  }

  Future<void> editarPasseio(Passeio passeio) async{
    final passeioEditado = await Navigator.of(context).push<Passeio>(
      MaterialPageRoute(
        builder: (context) => CriarPasseioScreen(
          passeio: passeio,
        ),
      ),
    );

    if(!mounted || passeioEditado == null) return;

    final indice = passeios.indexOf(passeio);
    
    if(indice == -1) return;

    setState(() {
      passeios[indice] = passeioEditado;

      passeios.sort(
        (a, b) => a.dataHora.compareTo(b.dataHora),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passeio atualizado com sucesso!'),
      ),
    );
  }

  Future<void> apagarPasseio(Passeio passeio) async {
    final confirmar = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Apagar passeio'),
        content: Text(
          'Queres apagar o passeio "${passeio.nome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text(
              'Apagar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if(!mounted || confirmar != true) return;

    setState(() {
      passeios.remove(passeio);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passeio Apagado.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'A proxima aventura começa aqui.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Organiza passeios e junta te ao teu grupo',
          style: TextStyle(color: Colors.white60),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: criarPasseio, 
          icon: const Icon(Icons.add),
          label: const Text('Criar Passeio'),
        ),
        const SizedBox(height: 30),
        const Text(
          'Proximos Passeios',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if(passeios.isEmpty)
        const Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.route,
                  size: 48,
                  color: Colors.orange,
                ),
                SizedBox(height: 12),
                Text(
                  'Ainda não tens Passeios.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Cria o primeiro para começar!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        ...passeios.map(
          (passeio) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PasseioCard(
              titulo: passeio.nome, 
              percurso: '${passeio.partida} -> ${passeio.destino}', 
              data: formatarData(passeio.dataHora), 
              participantes: 1, 
              limiteParticipantes: passeio.limiteParticipantes,
              icon: Icons.route,
              onEditar: () => editarPasseio(passeio),
              onApagar: () => apagarPasseio(passeio),
            ),
          ),
        ),
      ],
    );
  }
}


  


class Passeio {
  final String nome;
  final String descricao;
  final String partida;
  final String destino;
  final DateTime dataHora;
  final int limiteParticipantes;

  const Passeio({
    required this.nome,
    required this.descricao,
    required this.partida,
    required this.destino,
    required this.dataHora,
    required this.limiteParticipantes,
  }); 
}

class PasseioCard extends StatelessWidget{
  final String titulo;
  final String percurso;
  final String data;
  final int participantes;
  final IconData icon;
  final VoidCallback onEditar;
  final VoidCallback onApagar;
  final int limiteParticipantes;

  const PasseioCard({
    super.key,
    required this.titulo,
    required this.percurso,
    required this.data,
    required this.participantes,
    required this.icon,
    required this.onEditar,
    required this.onApagar,
    required this.limiteParticipantes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.orange, size: 36
                ),
                PopupMenuButton<String>(
                  tooltip: 'Opções do Passeio',
                  onSelected: (opcao){
                    if(opcao == 'Editar'){
                      onEditar();
                    } else if (opcao == 'Apagar'){
                      onApagar();
                    }
                  },
                  itemBuilder: (context) => const[
                    PopupMenuItem(
                      value: 'Editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 12),
                          Text('Editar'),
                        ],
                      )
                    ),
                    PopupMenuItem(
                      value: 'apagar',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Apagar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(percurso),
            const SizedBox(height: 8),
            Text(
              data,
              style: const TextStyle(color: Colors.white60),
            ),
            const Divider(height: 28),
            Row(
              children: [
                const Icon(Icons.group_outlined, size: 20),
                const SizedBox(width: 8),
                Text('$participantes / $limiteParticipantes participantes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GaragemScreen extends StatelessWidget{
  const GaragemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A minha Garagem', 
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Os teus Carros e motas vão aparecer aqui.',
            style: TextStyle(color: Colors.white60),
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.garage_outlined,
                color: Colors.orange
              ),
              title: Text('Ainda não tens veiculos'),
              subtitle: Text(
                'Em breve poderás adicionar o teu primeiro veiculo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PerfilScreen extends StatelessWidget{
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const[
        Center(
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'O meu perfil',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Ainda não iniciaste sessão.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60),
        ),
        SizedBox(height: 30),
        Card(
          child: ListTile(
            leading: Icon(Icons.route, color: Colors.orange),
            title: Text('Passeios Realizados'),
            trailing: Text('0'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.speed, color: Colors.orange),
            title: Text('Quilómetros percorridos'),
            trailing: Text('0 km'),
          ),
        ),
      ],
    );
  }
}

class CriarPasseioScreen extends StatefulWidget{
  final Passeio? passeio;
  const CriarPasseioScreen({super.key,this.passeio});

  @override
  State<CriarPasseioScreen> createState() => _CriarPasseioScreenState();
}

class _CriarPasseioScreenState extends State<CriarPasseioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _partidaController = TextEditingController();
  final _destinoController = TextEditingController();
  final _limiteParticipantesController = TextEditingController(
    text: '10',
  );

  DateTime? _data;
  TimeOfDay? _hora;
  String? _erroDataHora;

  @override
  void initState(){
    super.initState();

    final passeio = widget.passeio;

    if(passeio != null){
      _nomeController.text = passeio.nome;
      _descricaoController.text = passeio.descricao;
      _partidaController.text = passeio.partida;
      _destinoController.text = passeio.destino;
      _limiteParticipantesController.text = passeio.limiteParticipantes.toString();

      _data = DateTime(
        passeio.dataHora.year,
        passeio.dataHora.month,
        passeio.dataHora.day,
      );
      _hora =TimeOfDay.fromDateTime(passeio.dataHora);
    }
  }
  void dispose(){
    _nomeController.dispose();
    _descricaoController.dispose();
    _partidaController.dispose();
    _destinoController.dispose();
    _limiteParticipantesController.dispose();
    super.dispose();
  }
  String? validarObrigatorio(String? valor){
    if(valor == null || valor.trim().isEmpty){
      return 'Preenche este Campo.';
    }
    return null;
  }

  Future<void> selecionarData() async{
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);

    final dataSelecionada = await showDatePicker(context: context,
     initialDate: _data == null || _data!.isBefore(hoje)
     ? hoje
     :_data!,
     firstDate: hoje,
     lastDate: DateTime(agora.year +5,12,31),
     helpText: 'Seleciona a data do passeio',
     cancelText: 'Cancelar',
     confirmText: 'Confirmar',
     );

     if (!mounted || dataSelecionada == null) return;

     setState(() {
        _data = dataSelecionada;
        _erroDataHora = null;
     });
  }

  Future<void> selecionarHora() async {
    final horaSelecionada = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
      helpText: 'Seleciona a hora de partida',
      cancelText: 'Cancelar.',
      confirmText: 'Confirmar',
      builder: (context, child){
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
        ), 
        child: child!,
        );
      },
    );

    if(!mounted || horaSelecionada == null) return;

    setState(() {
      _hora = horaSelecionada;
      _erroDataHora = null;
    });
  }

  void guardarPasseio(){
    final camposValidos = _formKey.currentState!.validate();

    DateTime? dataHora;
    String? erro;

    if (_data == null || _hora == null){
      erro = 'Seleciona a data e a hora do passeio';
    } else {
      dataHora = DateTime(
        _data!.year,
        _data!.month,
        _data!.day,
        _hora!.hour,
        _hora!.minute,
      );

      if(!dataHora.isAfter(DateTime.now())){
        erro = 'Escolhe uma data e hora futuras.';
      }
    }
    setState(() {
      _erroDataHora = erro;
    });

    if(!camposValidos || erro != null || dataHora == null) return;

    final passeio = Passeio(
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(), 
      partida: _partidaController.text.trim(), 
      destino: _destinoController.text.trim(), 
      dataHora: dataHora,
      limiteParticipantes: int.parse(
        _limiteParticipantesController.text.trim(),
      ),
    );


    Navigator.of(context).pop(passeio);
  }
  InputDecoration decoracao(String titulo, IconData icon){
    return InputDecoration(
      labelText: titulo,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      alignLabelWithHint: true,
    );
  }

  @override
  Widget build(BuildContext context){
    String doisDigitos(int numero) => numero.toString().padLeft(2, '0');

    final textoData = _data == null
        ? 'Selecionar data'
        : '${doisDigitos(_data!.day)}/'
            '${doisDigitos(_data!.month)}/${_data!.year}';
    
    final textoHora = _hora == null
        ? 'Selecionar hora'
        : '${doisDigitos(_hora!.hour)}:${doisDigitos(_hora!.minute)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.passeio == null ? 'Criar Passeio': 'Editar Passeio',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Planeia a proxima aventura!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Define o percurso e combina a partida com o grupo.',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nomeController,
                decoration: decoracao(
                  'Nome do passeio', 
                  Icons.route
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                validator: validarObrigatorio,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: decoracao(
                  'Descrição (opcional)', 
                  Icons.description_outlined,
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                maxLength: 500,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _partidaController,
                decoration: decoracao(
                  'Local de Partida', 
                  Icons.trip_origin,
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: validarObrigatorio,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinoController,
                decoration: decoracao(
                  'Destino', 
                  Icons.location_on_outlined
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                validator: validarObrigatorio,
              ),
              TextFormField(
                controller:  _limiteParticipantesController,
                decoration: decoracao(
                  'Limite de participantes', 
                  Icons.group_outlined,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (valor){
                  final limite = int.tryParse(valor?.trim() ?? '');
                  
                  if(limite == null || limite < 1){
                    return 'Introduz um numero igual ou superior a 1.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: selecionarData,
                icon: const Icon(Icons.calendar_month), 
                label: Text(textoData),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: selecionarHora,
                icon: const Icon(Icons.schedule),
                label: Text(textoHora),
              ),
              if(_erroDataHora != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _erroDataHora!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: guardarPasseio,
                icon: const Icon(Icons.check),
                label: Text(
                  widget.passeio == null ? 'Guardar Passeio' : 'Guardar Alterações',
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}