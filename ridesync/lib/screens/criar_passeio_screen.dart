import 'package:flutter/material.dart';
import 'package:ridesync/models/passeio.dart';

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
  @override
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