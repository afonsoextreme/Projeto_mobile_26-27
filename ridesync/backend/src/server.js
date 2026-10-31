const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.get('/api/health',(req, res) => {
    res.json({
        status: 'ok',
        mensagem: 'API RideSync a funcionar!',
    });
});

// Serve para testar backend enquanto não ha bd, que está a ser tratada pelo António 
const passeios = [
    {
        id: 1,
        nome: 'Passeio à Arrábida',
        descricao: 'Passeio de carros e motas pela serra.',
        partida: 'Setubal',
        destino: 'Portinho da Arrabida',
        data: '2026-11-15T10:00:00',
        limiteParticipantes: 15,
        participantes: 1,
        estado: 'publicado',
    },
];

app.get('/api/passeios', (req, res) =>{
    res.json(passeios);
});


app.listen(PORT, '0.0.0.0',() =>{
    console.log(`Api RideSync disponivel em http://localhost:${PORT}`);
});
