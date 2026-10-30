import 'package:flutter/material.dart';
import 'package:ridesync/models/veiculo.dart';

class CriarVeiculoScreen extends StatefulWidget{
  final Veiculo? veiculo;

  const CriarVeiculoScreen({
    super.key,
    this.veiculo,
  });

  @override
  State<CriarVeiculoScreen> createState() => _CriarPasseioScreenState();
}

class _CriarPasseioScreenState extends State<CriarVeiculoScreen>{
  final _formKey = GlobalKey<FormState>();

  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _matriculaController = TextEditingController();

  String _tipo = 'Carro';

  @override
  void initState(){
    super.initState();

    final veiculo = widget.veiculo;

    if(veiculo != null){
      _tipo = veiculo.tipo;
      _marcaController.text = veiculo.marca;
      _modeloController.text = veiculo.modelo;
      _matriculaController.text = veiculo.matricula;
    }
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _matriculaController.dispose();
    super.dispose();
  }

  String? validarObrigatorio(String? valor){
    if(valor == null || valor.trim().isEmpty){
      return 'Preenche este campo';
    }

    return null;
  }

  void guardarVeiculo(){
    if(!_formKey.currentState!.validate()) return;

    final veiculo = Veiculo(
      tipo: _tipo,
      marca: _marcaController.text.trim(),
      modelo: _modeloController.text.trim(),
      matricula: _matriculaController.text.trim().toUpperCase(),
    );

    Navigator.of(context).pop(veiculo);
  }

  InputDecoration decoracao(String titulo, IconData icon) {
    return InputDecoration(
      labelText: titulo,
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context){
    final aEditar = widget.veiculo !=null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          aEditar ? 'Editar Veículo' : 'Adicionar Veiculo',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                aEditar
                    ? 'Atualiza o teu veiculo'
                    : 'Adiciona à tua garagem',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preenche os dados do teu carro ou mota',
                style: TextStyle(color: Colors.white60),
              ),
              const Text(
                'Tipo de veiculo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  ChoiceChip(
                    avatar: const Icon(Icons.directions_car),
                    label: const Text('Carro'), 
                    selected: _tipo == 'Carro',
                    onSelected: (_) {
                      setState(() {
                        _tipo = 'Carro';
                      });
                    },
                  ),
                  ChoiceChip(
                    avatar: const Icon(Icons.two_wheeler),
                    label: const Text('Mota'), 
                    selected: _tipo == 'Mota',
                    onSelected: (_){
                      setState(() {
                        _tipo = 'Mota';
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _marcaController,
                decoration: decoracao(
                  'Marca', 
                  Icons.branding_watermark_outlined,
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: validarObrigatorio,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modeloController,
                decoration: decoracao(
                  'Modelo', 
                  Icons.drive_eta_outlined
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: validarObrigatorio,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _matriculaController,
                decoration: decoracao(
                  'Matricula', 
                  Icons.pin_outlined,
                ),
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                validator: validarObrigatorio,
                onFieldSubmitted: (_) => guardarVeiculo(),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: guardarVeiculo,
                icon: const Icon(Icons.check), 
                label: Text(
                  aEditar
                      ? 'Guardar Alterações'
                      : 'Adicionar veículo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}