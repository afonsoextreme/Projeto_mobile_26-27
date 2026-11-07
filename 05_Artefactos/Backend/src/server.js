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
        estado: 'agendado',
    },
];

app.get('/api/passeios', (req, res) =>{
    res.json(passeios);
});


app.listen(PORT, '0.0.0.0',() =>{
    console.log(`Api RideSync disponivel em http://localhost:${PORT}`);
});

let proximoId = 2;

app.post('/api/passeios', (req, res) => {
    const {
        nome,
        descricao = '',
        partida,
        destino,
        data, 
        limiteParticipantes,
    } = req.body ?? {};
    
    const camposObrigatorios = [nome, partida, destino];

    if(camposObrigatorios.some(
        valor => typeof valor !== 'string' || !valor.trim()
    )) {
        return res.status(400).json({
            mensagem: 'Preenche o nome, a partida e o destino.',
        });
    }

    if(typeof descricao !== 'string' || descricao.length > 500) {
        return res.status(400).json({
            mensagem: 'A descrição deve ter até 500 carateres.',
        });
    }
    
    const dataHora = typeof data === 'string'
        ? new Date(data)
        : new Date(NaN);
    if(
        Number.isNaN(dataHora.getDate()) ||
        dataHora.getDate() <= Date.now()
    ) {
        return res.status(400).json({
            mensagem: 'O limite de participantes deve ser pelo menos 1',
        });
    }
    
    const passeio = {
        id: proximoId++,
        nome: nome.trim(),
        descricao: descricao.trim(),
        partida: partida.trim(),
        destino: destino.trim(),
        data: dataHora.toISOString(),
        limiteParticipantes,
        participantes: 1,
        estado: 'agendado',
    };

    passeios.push(passeio);
    return res.status(201).json(passeio);
});


