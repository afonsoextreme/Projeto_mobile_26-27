import 'package:flutter/material.dart';

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