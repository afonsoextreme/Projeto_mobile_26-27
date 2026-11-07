import 'package:flutter/material.dart';
import 'package:ridesync/services/sessao_store.dart';

class AuthScreen extends StatefulWidget{
  final bool iniciarNoRegisto;

  const AuthScreen({
    super.key,
    this.iniciarNoRegisto = false,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();

  late bool _registo = false;
  bool _ocultarPassword = true;
  bool _ocultarConfirmacao = true;

  @override
  void initState(){
    super.initState();
    _registo = widget.iniciarNoRegisto;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  void alternarFormulario() {
    _formKey.currentState?.reset();

    setState(() {
      _registo = !_registo;
      _passwordController.clear();
      _confirmarPasswordController.clear();
      _ocultarPassword = true;
      _ocultarConfirmacao = true;
    });
  }

  void submeter() {
    if(!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    //ISTO VAI SERVIR SO PARA SIMULAR ATE TER BD + API :)
    SessaoStore.entrar(
      nomeUtilizador: _registo
          ? _nomeController.text.trim()
          :'Utilizador de demonstração', 
      emailUtilizador: _emailController.text.trim(),
    );

    Navigator.of(context).pop(true);
  }

  String? validarEmail(String? valor) {
    final email = valor?.trim() ?? '';

    if(email.isEmpty) {
      return 'Introduz o teu email.';
    }

    if(!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)){
      return 'Introduz um email válido.';
    }

    return null;
  }

  String? validarPassword(String? valor){
    if(valor == null || valor.isEmpty) {
      return 'Introduz a tua palavra passe.';
    }

    if(_registo && valor.length < 8) {
      return 'Utiliza pelo menos 8 caracteres.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_registo ? 'Criar Conta' : 'Entrar'),
      ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Icon(
                      Icons.route,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'RideSync',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _registo
                          ? 'Cria a tua conta e prepara a proxima aventura.'
                          : 'Entra para organizar os teus passeios.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    if(_registo) ...[
                      TextFormField(
                        controller: _nomeController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Introduz o teu nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: validarEmail,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _ocultarPassword,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: _registo
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if(!_registo) submeter();
                      },
                      decoration: InputDecoration(
                        labelText: 'Palavra-Passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _ocultarPassword
                          ? 'Mostrar Palavra-Passe'
                          : 'Ocultar Palavra-Passe',
                          onPressed: (){
                            setState(() {
                              _ocultarPassword = !_ocultarPassword;
                            });
                          }, 
                          icon: Icon(
                            _ocultarPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: validarPassword,
                    ),

                    if(_registo) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmarPasswordController,
                        obscureText: _ocultarConfirmacao,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted:(_) => submeter(),
                        decoration: InputDecoration(
                          labelText: 'Confirmar Palavra-Passe',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _ocultarConfirmacao
                                ? 'Mostrar confirmação'
                                : 'Ocultar confirmação',
                            onPressed: () {
                              setState(() {
                                _ocultarConfirmacao = !_ocultarConfirmacao;
                              });
                            }, 
                            icon: Icon(
                              _ocultarConfirmacao
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator:(valor) {
                          if(valor == null || valor.isEmpty){
                            return 'As palavras-passe não coincidem';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: submeter,
                      icon: Icon(
                        _registo ? Icons.person_add_outlined : Icons.login,
                      ), 
                      label: Text(_registo ? 'Criar Conta' : 'Entrar'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: alternarFormulario, 
                      child: Text(
                        _registo
                            ? 'Já tens conta? Entrar'
                            : 'Não tens conta? Registar',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Protótipo: login e registo simulados.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ), 
              ),
            ),
          ), 
        ),
    );
  }

}