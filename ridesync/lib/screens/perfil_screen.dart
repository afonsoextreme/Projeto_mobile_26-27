import 'package:flutter/material.dart';

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